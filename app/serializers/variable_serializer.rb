class VariableSerializer < ActiveModel::Serializer
  attributes :id, :name, :format, :repository_id, :variable_type,
             :boolean_false_message, :boolean_success_message
end
