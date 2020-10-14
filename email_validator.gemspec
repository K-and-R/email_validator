Gem::Specification.new do |s|
  s.name = 'email_validator'
  s.version = '1.8.0'
  s.authors = ['Brian Alexander', 'Karl Wilbur']
  s.description = 'An email validator for Rails 3+. See homepage for details: http://github.com/karlwilbur/email_validator'
  s.email = 'karl@kandrsoftware.com'
  s.extra_rdoc_files = [
    'LICENSE'
  ]
  s.files = `git ls-files`.split('\n')
  s.test_files = `git ls-files -- spec/*`.split('\n')

  s.homepage = 'https://github.com/karlwilbur/email_validator'
  s.require_paths = %w[lib]
  s.summary = 'An email validator for Rails 3+.'

  # This gem will work with 2.4.0 or greater... but *should* work with 1.8.7+
  s.required_ruby_version = '>= 2.4.0'

  s.add_dependency('activemodel')

  s.add_development_dependency('codeclimate-test-reporter')
  s.add_development_dependency('pry')
  s.add_development_dependency('rake')
  s.add_development_dependency('rspec')
  s.add_development_dependency('rubocop')
  s.add_development_dependency('rubocop-rspec')
  s.add_development_dependency('simplecov')

  s.add_development_dependency('rubysl', '~> 2.0') if RUBY_ENGINE == 'rbx'
end
