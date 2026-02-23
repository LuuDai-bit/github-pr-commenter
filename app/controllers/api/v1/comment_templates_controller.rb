class Api::V1::CommentTemplatesController < ApplicationController
  before_action :set_repository, only: [:create, :update]

  def index
    @pagy, @comment_templates = pagy(CommentTemplate.order(id: :desc), limit: params[:per_page])

    render json: { data: @comment_templates, meta: pagy_metadata(@pagy) }
  end

  def create
    @comment_template = @repository.comment_templates.new(comment_template_params)
    if @comment_template.save
      render json: @comment_template, status: :created
    else
      render json: @comment_template.errors, status: :unprocessable_entity
    end
  end

  def update
    @comment_template = @repository.comment_templates.find(params[:id])
    if @comment_template.update(comment_template_params)
      render json: @comment_template
    else
      render json: @comment_template.errors, status: :unprocessable_entity
    end
  end

  private

  def set_repository
    @repository = Repository.find(params[:repository_id])
  end

  def comment_template_params
    params.require(:comment_template).permit(:content, :status)
  end
end
