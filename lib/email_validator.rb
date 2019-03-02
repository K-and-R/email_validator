# frozen_string_literal: true
require 'active_model'

# Based on work from http://thelucid.com/2010/01/08/sexy-validation-in-edge-rails-rails-3/
class EmailValidator < ActiveModel::EachValidator
  @@default_options = {}

  def self.regexp(options = {})
    if options[:strict_mode]
      ActiveSupport::Deprecation.warn(
        'Strict mode has been deprecated in email_validator 2.0. To fix this warning, '\
        'remove `strict_mode: true` from your validation call.'
      )
    end
    options = default_options.merge(options)

    name_validation = options[:strict_mode] ? "-\\p{L}\\d+._" : "^@\\s"

    /\A\s*([#{name_validation}]{1,64})@((?:[-\p{L}\d]+\.)+?\p{L}{2,})\s*\z/i
  end

  def self.valid?(value, options = {})
    !!(value =~ regexp(options))
  end

  def self.invalid?(value, options = {})
    !valid?(value, options)
  end

  def self.default_options
    @@default_options
  end

  def validate_each(record, attribute, value)
    options = @@default_options.merge(self.options)

    unless self.class.valid?(value, self.options)
      record.errors.add(attribute, options[:message] || :invalid)
    end
  end
end
