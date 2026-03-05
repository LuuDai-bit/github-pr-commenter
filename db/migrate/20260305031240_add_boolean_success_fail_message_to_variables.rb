class AddBooleanSuccessFailMessageToVariables < ActiveRecord::Migration[8.1]
  def change
    add_column :variables, :variable_type, :string, default: 'string'
    add_column :variables, :boolean_success_message, :string
    add_column :variables, :boolean_false_message, :string
  end
end
