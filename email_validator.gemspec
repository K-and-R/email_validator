Gem::Specification.new do |s|
  s.name = %q{email_validator}
  s.version = "1.3.0"
  s.authors = ["Brian Alexander"]
  s.date = %q{2011-07-23}
  s.description = %q{An email validator for Rails 3. See homepage for details: http://github.com/balexand/email_validator}
  s.email = %q{balexand@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE",
    "README.rdoc"
  ]
  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {spec}/*`.split("\n")
  s.homepage = %q{http://github.com/balexand/email_validator}
  s.require_paths = %w(lib)
  s.summary = %q{An email validator for Rails 3.}
  s.add_dependency("activemodel", ">= 0")
  s.add_development_dependency("rake")
  s.add_development_dependency("rspec", ">= 0")
end

