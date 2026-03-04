class VariableSerializer < ActiveModel::Serializer
  attributes :id, :name, :format, :repository_id
end
