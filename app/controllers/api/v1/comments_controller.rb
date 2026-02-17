class CommentsController < ApplicationController
  def create
    github_auth_token = GithubAuthToken.active_token&.token

    if github_auth_token.blank?
      github_auth_token = GetGithubAuthTokenService.run
    end

    data = { project_coverage: "70%", patch_coverage: "90%", is_passed: true }
    message = FormatMessageService.run(data)
    jid = SendCommentJob.perform_async

    render json: { message: "The comment has been queued", job_id: jid }
  end
end
