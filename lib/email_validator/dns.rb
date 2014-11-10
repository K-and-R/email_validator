# require this file to enable :dns_mode by default

require 'email_validator'

EmailValidator::default_options[:dns_mode] = true
