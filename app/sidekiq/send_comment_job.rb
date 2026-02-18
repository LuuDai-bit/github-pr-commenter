require "httparty"

class SendCommentJob
  include Sidekiq::Job

  def perform(github_auth_token, owner = "LuuDai-bit", repo = "blog", issue_number = 57, message)
    url = "https://api.github.com/repos/#{owner}/#{repo}/issues/#{issue_number}/comments"

    @response = HTTParty.post(url,
                              headers: headers(github_auth_token),
                              body: body(message))

    puts response
  end

  private

  attr_accessor :response

  def headers(github_auth_token)
    {
      "Authorization": "Bearer #{github_auth_token}",
      "Accept": "application/vnd.github+json"
    }
  end

  def body(message)
    {
      "body": message
    }.to_json
  end
end
