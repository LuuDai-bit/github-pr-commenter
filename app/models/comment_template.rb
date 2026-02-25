class CommentTemplate < ApplicationRecord
  validates :content, :status, presence: true
  validates :status, uniqueness: { scope: :repository_id }, if: -> { active? }

  belongs_to :repository

  enum :status, { draft: "draft", active: "active" }
end
