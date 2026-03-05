class Variable < ApplicationRecord
  validates :name, presence: true

  belongs_to :repository

  enum :type, { string: "string", boolean: "boolean" }

  # The format will contain &: as placement for the value
  def formatted(value)
    if boolean?
      { success: boolean_success_message, fail: boolean_false_message }
    else
      format.gsub(/&:/, value)
    end
  end
end
