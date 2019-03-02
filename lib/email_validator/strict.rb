# frozen_string_literal: true

ActiveSupport::Deprecation.warn(
  'Strict mode has been deprecated in email_validator 2.0. You are receiving '\
  'this warning because your project is requiring "email_validator/strict", '\
  'most likely in your Gemfile.'
)

require 'email_validator'
