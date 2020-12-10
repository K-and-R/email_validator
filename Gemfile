# frozen_string_literal: true

# Determine from where we get our gems
if File.exist?(File.expand_path('.rubygems-proxy-url', __dir__))
  rubygems_url = File.read(
    File.expand_path('../.rubygems-proxy-url', __dir__),
    :mode => 'rb'
  ).chomp
end
# rubocop:disable Style/IfUnlessModifier
if rubygems_url.nil? || rubygems_url.empty?
  rubygems_url = 'https://rubygems.org'
end
# rubocop:enable Style/IfUnlessModifier
source rubygems_url

# Normalize repo path
def github_repo_path(repo_name)
  repo_name.include?('/') ? repo_name : "#{repo_name}/#{repo_name}"
end
# Add source for GitHub
git_source(:github) do |repo_name|
  "https://github.com/#{github_repo_path(repo_name)}.git"
end

# load requirements from the `*.gemspec` file
gemspec

# Make-like utility
gem 'rake'

# RSpec testing framework
gem 'rspec'

# Pry, an IRB alternative
gem 'pry'

# Simplecov for code coverage reporting
# gem 'simplecov', '>= 0.20.0'
gem 'simplecov', '>= 0.17.0', '< 0.18'

# These are all development dependencies, since the Gemfile is only used in development
group :development do
  # Pry addons, from K&R repo
  gem 'kandr-pry-plus'
  # Pry Rails extensions
  gem 'pry-rails'

  # Rubocop for ensuring well written code
  gem 'rubocop', '>= 1.0'
  # Rubocop performance evaluation
  gem 'rubocop-performance', '>= 1.0'
  # Rubocop Rake evaluation
  gem 'rubocop-rake'
  # Rubocop RSpec evaluation
  gem 'rubocop-rspec', '>= 2.0'

  # Markdown lint tool
  gem 'mdl'
end
