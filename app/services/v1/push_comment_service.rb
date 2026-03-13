class V1::PushCommentService < BaseService
  def initialize(params)
    @params = params
  end

  def run
    github_auth_token = GithubAuthToken.active_token.last&.token

    if github_auth_token.blank?
      github_auth_token = GetGithubAuthTokenService.run(params[:owner], params[:repo])
    end

    repository = create_repository_if_not_exists(params[:owner], params[:repo])
    comment_template = repository.comment_templates.active.last&.content
    variables = repository.variables
    data = validated_params(variables.pluck(:name)).merge(is_passed: is_passed)
    formatted_variables = {}
    variables.each do |variable|
      value = data[variable.name.to_sym]
      formatted_value = variable.formatted(value)

      formatted_variables[variable.name] = formatted_value
    end

    message = FormatMessageService.run(formatted_variables, comment_template)
    SendCommentJob.perform_later(github_auth_token, params[:owner], params[:repo], params[:pull_request_number], message)
  end

  private

  attr_reader :params

  def create_repository_if_not_exists(owner, repo)
    Repository.find_or_create_by(owner: owner, name: repo)
  end

  def validated_params(variable_names)
    params.require(:variables).permit(variable_names)
  end

  def is_passed
    params[:patch_coverage].to_i > 90
  end
end
