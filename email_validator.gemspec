Gem::Specification.new do |s|
  s.name = 'email_validator'
  s.version = '2.2.4'
  s.authors = ['Brian Alexander', 'Karl Wilbur']
  s.summary = 'An email validator for Rails.'
  s.description = 'An email validator for Rails. See homepage for details: http://github.com/K-and-R/email_validator'
  s.email = 'karl@kandrsoftware.com'
  s.homepage = 'https://github.com/K-and-R/email_validator'
  s.licenses = ['MIT']
  s.extra_rdoc_files = %w[
    LICENSE
    README.md
    CHANGELOG.md
  ]
  s.files = Dir['lib/**/*.rb']
  s.require_paths = %w[lib]
  s.required_ruby_version = '>= 2.7.0'

  s.add_dependency('activemodel')

  s.add_development_dependency('rubysl', '~> 2.0') if RUBY_ENGINE == 'rbx'
  s.metadata['rubygems_mfa_required'] = 'true'
end
