class Api::V1::CommentTemplatesController < ApplicationController
  before_action :load_comment_template, only: %i[show update destroy]

  def index
    @pagy, @comment_templates = pagy(CommentTemplate.order(id: :desc).includes(:repository),
                                     limit: params[:per_page])
    serializer_comment_templates = ::ActiveModelSerializers::SerializableResource.new(@comment_templates, each_serializer: ::CommentTemplateSerializer)
    render json: { data: serializer_comment_templates, meta: pagy_metadata(@pagy) }
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

  def destroy
    @comment_template = CommentTemplate.find(params[:id])

    if @comment_template.destroy
      render json: { message: "Comment template deleted successfully" }
    else
      render json: { error: "Failed to delete comment template" }, status: :unprocessable_entity
    end
  end

  private

  def comment_template_params
    params.require(:comment_template).permit(:content, :status, :repository_id)
  end

  def load_comment_template
    @comment_template = CommentTemplate.find(params[:id])
  end
end
