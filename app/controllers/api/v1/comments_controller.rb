class CommentsController < ApplicationController
  def create
    github_auth_token = GithubAuthToken.active_token

    if github_auth_token.blank?
      # Generate JWT
      # Call get auth token api
    end

    # Push comment job to job queue
    # Return jid, message
  end
end
