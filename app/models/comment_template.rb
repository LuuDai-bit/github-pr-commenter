class CommentTemplate < ApplicationRecord
  validates :content, :status, presence: true

  belongs_to :repository

  enum :status, { draft: "draft", active: "active" }
end
