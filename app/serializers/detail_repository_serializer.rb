class DetailRepositorySerializer < ActiveModel::Serializer
  attributes :id, :owner, :name, :added_method, :created_at, :updated_at

  has_many :variables
  has_many :comment_templates
end
