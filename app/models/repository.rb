class Repository < ApplicationRecord
  validates :owner, :name, presence: true

  has_many :comment_templates, dependent: :destroy
end
