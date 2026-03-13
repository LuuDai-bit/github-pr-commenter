require "comment_services_pb"

class CommentService < Comment::CommentService::Service
  def create_comment(request, _call)
    github_auth_token = GithubAuthToken.active_token.last&.token

    if github_auth_token.blank?
      github_auth_token = GetGithubAuthTokenService.run(request.owner, request.repo)
    end

    repository = create_repository_if_not_exists(request.owner, request.repo)
    comment_template = repository.comment_templates.active.last&.content
    variables = repository.variables
    data = validated_params(variables.pluck(:name), request.variables.to_h)
    Rails.logger.info data
    formatted_variables = {}
    variables.each do |variable|
      value = data[variable.name]
      formatted_value = variable.formatted(value)
      formatted_variables[variable.name] = formatted_value
    end

    message = FormatMessageService.run(formatted_variables, comment_template)
    Rails.logger.info message
    jid = SendCommentJob.perform_later(github_auth_token, request.owner, request.repo, request.pullRequestNumber, message)

    Comment::CreateCommentResponse.new(
      message: "success",
      job_id: ""
    )
  end

  private

  def validated_params(variable_names, variables)
    variables.slice(*variable_names)
  end

  def create_repository_if_not_exists(owner, repo)
    Repository.find_or_create_by(owner: owner, name: repo)
  end
end
