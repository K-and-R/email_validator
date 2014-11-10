# Based on work from http://thelucid.com/2010/01/08/sexy-validation-in-edge-rails-rails-3/
class EmailValidator < ActiveModel::EachValidator
  @@default_options = {}

  def self.default_options
    @@default_options
  end

  def validate_each(record, attribute, value)
    options = @@default_options.merge(self.options)
    name_validation = options[:strict_mode] ? "-a-z0-9+._" : "^@\\s"
    valid_dns = options[:dns_mode] ? (dns_lookup? value) : true
    unless value =~ /\A\s*([#{name_validation}]{1,64})@((?:[-a-z0-9]+\.)+[a-z]{2,})\s*\z/i && valid_dns
      record.errors.add(attribute, options[:message] || :invalid)
    end
  end

  private
  def dns_lookup? value
    if value.match(/.*@(.*)/)
      mx = Resolv::DNS.open.getresources $1, Resolv::DNS::Resource::IN::MX
      return mx.size > 0 ? true : false
    end
    false
  end
end
