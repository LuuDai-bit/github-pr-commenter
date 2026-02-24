class Api::V1::CommentTemplatesController < ApplicationController
  def index
    @pagy, @comment_templates = pagy(CommentTemplate.order(id: :desc), limit: params[:per_page])

    render json: { data: @comment_templates, meta: pagy_metadata(@pagy) }
  end

  def create
    @comment_template = CommentTemplate.new(comment_template_params)
    if @comment_template.save
      render json: @comment_template, status: :created
    else
      render json: @comment_template.errors, status: :unprocessable_entity
    end
  end

  def update
    @comment_template = CommentTemplate.find(params[:id])
    if @comment_template.update(comment_template_params)
      render json: @comment_template
    else
      render json: @comment_template.errors, status: :unprocessable_entity
    end
  end

  def show
    @comment_template = CommentTemplate.find(params[:id])

    render json: { data: @comment_template }
  end

  private

  def comment_template_params
    params.require(:comment_template).permit(:content, :status)
  end
end
