class Api::V1::RepositoriesController < ApplicationController
  def index
    repositories = Repository.all

    render json: { data: repositories }, status: :ok
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
      param[:added_method] = 'manual'
    end
  end
end
