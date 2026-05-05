require 'simplecov'
require 'simplecov_json_formatter'

SimpleCov.formatters = [
  SimpleCov::Formatter::HTMLFormatter,
  SimpleCov::Formatter::JSONFormatter
]

SimpleCov.start 'rails' do
  coverage_dir = ['app/controllers', 'app/services', 'app/jobs', 'app/models']
  changed_files = `git diff --name-only HEAD origin/main`.split("\n")
  add_group "Changed" do |source_file|
    next unless coverage_dir.any? { |dir| source_file.filename.match?(dir) }

    changed_files.detect do |filename|
      source_file.filename.ends_with?(filename)
    end
  end

  add_group "Project" do
    SimpleCov.result.covered_percent
  end

  enable_coverage :branch
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end
