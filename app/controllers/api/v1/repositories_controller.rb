class Api::V1::RepositoriesController < ApplicationController
  def index
    if params[:page].blank?
      repositories = Repository.all
      serializer = ActiveModelSerializers::SerializableResource.new(repositories, each_serializer: RepositorySerializer)

      render json: { data: serializer }
    else
      pagy, repositories = pagy(Repository.order(id: :desc))
      serializer = ActiveModelSerializers::SerializableResource.new(repositories, each_serializer: RepositorySerializer)

      render json: { data: serializer, meta: pagy_metadata(pagy) }, status: :ok
    end
  end

  def show
    repository = Repository.find(params[:id])
    serializer = ActiveModelSerializers::SerializableResource.new(repository, serializer: DetailRepositorySerializer)
    render json: { data: serializer }, status: :ok
  end

  def create
    repository = Repository.new(repository_params)

    if repository.save
      render json: repository, status: :created
    else
      render json: { errors: repository.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def repository_params
    params.require(:repository).permit(:owner, :name).tap do |param|
      param[:added_method] = "manual"
    end
  end
end
