class FormatMessageService < BaseService
  def initialize(data, comment_template)
    @data = data
    @comment_template = comment_template
  end

  def run
    formatted_string(raw_message)
  end

  private

  attr_reader :data, :comment_template

  def raw_message
    default_message ||= <<~TEXT
      ## Coverage Report

      Project: &:project_coverage
      Patch: &:patch_coverage

      ?:is_passed
    TEXT

    @raw_message ||= comment_template || default_message
  end

  # The format for variable should flow this pattern ?:variable_name for boolean
  # &:variable_name for string or number variable
  def formatted_string(message)
    message.gsub(/&:(\w+)/) do
      data[$1.to_sym] || "&:#{$1}"
    end.gsub(/\?:(\w+)/) do
      value = data[$1.to_sym] || "?:#{$1}"

      if boolean?(value) && value
        data[$1.to_sym]["success"]
      elsif boolean?(value) && !value
        data[$1.to_sym]["fail"]
      end
    end
  end

  def boolean?(value)
    value.is_a?(TrueClass) || value.is_a?(FalseClass)
  end
end
