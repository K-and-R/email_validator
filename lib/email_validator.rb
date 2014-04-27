# Based on work from http://thelucid.com/2010/01/08/sexy-validation-in-edge-rails-rails-3/
class EmailValidator < ActiveModel::EachValidator
  @@default_options = {}

  def self.default_options
    @@default_options
  end

  def validate_each(record, attribute, value)
    options = @@default_options.merge(self.options)
    validator = options[:strict_mode] ? STRICT_REGEX : REGEX
    unless value =~ validator
      record.errors.add(attribute, options[:message] || :invalid)
    end
  end
  
  STRICT_REGEX = /\A\s*([-a-z0-9+._]{1,64})@((?:[-a-z0-9]+\.)+[a-z]{2,})\s*\z/i
  REGEX = /\A\s*([^@\\s]{1,64})@((?:[-a-z0-9]+\.)+[a-z]{2,})\s*\z/i
end
