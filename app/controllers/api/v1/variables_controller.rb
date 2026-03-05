class Api::V1::VariablesController < ApplicationController
  before_action :get_variable, only: %i[update destroy]

  def index
    repository = Repository.find(params[:repository_id])
    variables = repository.variables
    serializer = ActiveModelSerializers::SerializableResource.new(variables, each_serializer: VariableSerializer)

    render json: { data: serializer }, status: :ok
  end

  def create
    variable = Variable.new(variable_params)

    if variable.save
      render json: variable, status: :created
    else
      render json: { errors: variable.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @variable.update(variable_params)
      render json: @variable, status: :ok
    else
      render json: { errors: @variable.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @variable.destroy

    render json: { message: "Variable deleted successfully" }, status: :ok
  end

  private

  def get_variable
    @variable = Variable.find(params[:id])
  end

  def variable_params
    params.require(:variable).permit(:name, :format, :repository_id,
                                     :variable_type, :boolean_false_message,
                                     :boolean_success_message)
  end
end
