class Variable < ApplicationRecord
  validates :name, presence: true
  validates :boolean_success_message, :boolean_false_message, presence: true, if: :boolean?

  belongs_to :repository

  enum :variable_type, { string: "string", boolean: "boolean" }

  # The format will contain &: as placement for the value
  def formatted(value)
    return value if format.blank? && !boolean?

    return "" if value.blank? && !boolean?

    if boolean?
      value ? boolean_success_message : boolean_false_message
    else
      format.gsub(/&:/, value)
    end
  end
end
