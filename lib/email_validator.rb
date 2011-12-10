# Based on work from http://thelucid.com/2010/01/08/sexy-validation-in-edge-rails-rails-3/
class EmailValidator < ActiveModel::EachValidator
  @@default_options = {}

  def self.default_options
    @@default_options
  end

  def validate_each(record, attribute, value)
    options = @@default_options.merge(self.options)
    name_validation = options[:strict_mode] ? "-a-z0-9+._" : "^@\\s"
    unless value =~ /^\s*([#{name_validation}]{1,64})@((?:[-a-z0-9]+\.)+[a-z]{2,})\s*$/i
      record.errors.add(attribute, options[:message] || :invalid)
    end
  end
end
