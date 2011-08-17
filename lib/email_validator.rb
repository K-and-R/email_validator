# Based on work from http://thelucid.com/2010/01/08/sexy-validation-in-edge-rails-rails-3/
class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    address, domain = value.split('@')

    unless address.size <= 64 and domain.to_s.size <= 254 and value =~ /^([a-z0-9!\#$%&'*+\/=?^_`{|}~-]+(\.[a-z0-9!\#$%&'*+\/=?^_`{|}~-]+)*|"([\040-\041\043-\133\135-\176]|\134[\040-\176])*")@(\[\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\]|((((([a-z0-9]{1}[a-z0-9-]+[a-z0-9]{1})|[a-z])\.)+[a-z]{2,6}))|[a-z0-9]+\.xn\-\-[a-f0-9]+)$/i
      record.errors.add(attribute, options[:message] || :invalid)
    end
  end
end
