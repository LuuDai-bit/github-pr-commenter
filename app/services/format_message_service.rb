class FormatMessageService < BaseService
  def initialize(data)
    @data = data
  end

  def run
    formatted_string(raw_message)
  end

  private

  attr_reader :data

  def raw_message
    # TODO: Flow 2 should allow to pull it out from database and fill data accordingly
    @raw_message ||= <<~TEXT
      ## Coverage Report

      Project: &:project_coverage
      Patch: &:patch_coverage

      ?:is_passed
    TEXT
  end

  # The format for variable should flow this pattern ?:variable_name for boolean
  # &:variable_name for string or number variable
  def formatted_string(message)
    message.gsub(/&:(\w+)/) do
      data[$1.to_sym] || "&:#{$1}"
    end.gsub(/\?:(\w+)/) do
      value = data[$1.to_sym] || "?:#{$1}"

      # TODO: Think about this later if the variable is dynamic
      # and possible has more than 1 boolean
      if boolean?(value) && value
        "✅ Passed"
      elsif boolean?(value) && !value
        "❌ Below threshold"
      end
    end
  end

  def boolean?(value)
    value.is_a?(TrueClass) || value.is_a?(FalseClass)
  end
end
