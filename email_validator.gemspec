Gem::Specification.new do |s|
  s.name = 'email_validator'
  s.version = '2.2.3'
  s.authors = ['Brian Alexander', 'Karl Wilbur']
  s.summary = 'An email validator for Rails 3+.'
  s.description = 'An email validator for Rails 3+. See homepage for details: http://github.com/K-and-R/email_validator'
  s.email = 'karl@kandrsoftware.com'
  s.homepage = 'https://github.com/K-and-R/email_validator'
  s.licenses = ['MIT']
  s.extra_rdoc_files = %w[
    LICENSE
    README.md
    CHANGELOG.md
  ]
  s.files = `git ls-files -- lib/*`.split("\n")
  s.require_paths = %w[lib]

  s.test_files = `git ls-files -- spec/*`.split("\n")

  # This gem will work with 2.4.0 or greater... but *should* work with 1.8.7+
  s.required_ruby_version = '>= 2.4.0'

  s.add_dependency('activemodel')

  s.add_development_dependency('rubysl', '~> 2.0') if RUBY_ENGINE == 'rbx'
end
