# Based on work from http://thelucid.com/2010/01/08/sexy-validation-in-edge-rails-rails-3/
class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    name_validation = %|a-z0-9+\\-._|
    name_validation << %|&'*/=?^{}~| unless options[:strict_mode]
    unless value =~ /^\s*([#{name_validation}]{1,64})@((?:[-a-z0-9]+\.)+[a-z]{2,})\s*$/i
      record.errors.add(attribute, options[:message] || :invalid)
    end
  end
end
