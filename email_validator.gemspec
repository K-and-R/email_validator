Gem::Specification.new do |s|
  s.name = %q{email_validator}
  s.version = "1.6.0"
  s.authors = ["Karl Wilbur"]
  s.description = %q{An email validator for Rails 3+. See homepage for details: http://github.com/karlwilbur/email_validator}
  s.email = %q{karlwilbur@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE",
  ]
  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {spec}/*`.split("\n")

  s.homepage = %q{https://github.com/karlwilbur/email_validator}
  s.require_paths = %w(lib)
  s.summary = %q{An email validator for Rails 3+.}

  s.add_dependency("activemodel", ">= 0")

  s.add_development_dependency("rake")
  s.add_development_dependency("pry")
  s.add_development_dependency("rspec", ">= 0")
  s.add_development_dependency("codeclimate-test-reporter")
  s.add_development_dependency("simplecov")

  s.add_development_dependency('rubysl', '~> 2.0') if RUBY_ENGINE == 'rbx'
end
