# frozen_string_literal: true
require 'active_model'

class EmailValidator < ActiveModel::EachValidator
  def self.regexp(options = {})
    if options[:strict_mode]
      ActiveSupport::Deprecation.warn(
        'Strict mode has been deprecated in email_validator 2.0. To fix this warning, '\
        'remove `strict_mode: true` from your validation call.'
      )
    end

    /[^\s]@[^\s]/
  end

  def self.valid?(value, options = nil)
    !invalid?(value)
  end

  def self.invalid?(value, options = nil)
    !(value =~ regexp)
  end

  def validate_each(record, attribute, value)
    if self.class.invalid?(value)
      record.errors.add(attribute, :invalid, options.slice(:message).merge(value: value))
    end
  end
end
