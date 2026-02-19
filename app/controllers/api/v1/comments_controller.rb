class Api::V1::CommentsController < ApplicationController
  def create
    github_auth_token = GithubAuthToken.active_token.last&.token

    if github_auth_token.blank?
      github_auth_token = GetGithubAuthTokenService.run
    end

    data = {
      project_coverage: "#{params[:project_coverage]}%",
      patch_coverage: "#{params[:patch_coverage]}%",
      is_passed: is_passed
    }

    message = FormatMessageService.run(data)
    jid = SendCommentJob.perform_async(github_auth_token, params[:owner], params[:repo], params[:pull_request_number], message)

    render json: { message: "The comment has been queued", job_id: jid }
  end

  private

  def is_passed
    return true if params[:patch_coverage].to_i > 90

    false
  end
end
