class CommentTemplateSerializer < ActiveModel::Serializer
  attributes :id, :content, :status, :created_at

  belongs_to :repository
end
