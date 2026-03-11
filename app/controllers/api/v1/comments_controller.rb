class Api::V1::CommentsController < ApplicationController
  def create
    jid = ::V1::PushCommentService.run(params)

    render json: { message: "The comment has been queued", job_id: jid }
  end
end
