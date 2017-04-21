# encoding: UTF-8
# Based on work from http://thelucid.com/2010/01/08/sexy-validation-in-edge-rails-rails-3/
class EmailValidator < ActiveModel::EachValidator
  @@default_options = {}

  def self.regexp(options = {})
    format(options).regex
  end

  def self.valid?(value, options = {})
    format(options).valid?(value)
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

  def self.format(options = {})
    strict_mode?(options) ? StrictEmailFormat.new : BasicEmailFormat.new
  end

  def self.strict_mode?(options = {})
    default_options.merge(options)[:strict_mode]
  end

  class BasicEmailFormat
    def valid?(email)
      !!(email =~ regex)
    end

    def regex
      left_part = "\\A\\s*#{name.prefix}(#{name.body}{1,64})#{name.suffix}"
      right_part = "#{domain.prefix}(#{domain.body})#{domain.suffix}\\.\\p{L}{2,}\\s*\\z"
      /#{left_part}@#{right_part}/i
    end

    protected

    def name
      EmailRule.new(body:'[^@\\s]')
    end

    def domain
      EmailRule.new(body:'(?:[-\\p{L}\\d\\.]+)', 
                    prefix: '(?![\\-\\.])', 
                    suffix: '(?<![\\-\\.])')
    end
  end

  class StrictEmailFormat < BasicEmailFormat
    protected

    def name
      EmailRule.new(
        prefix: '(?!\\.)',
        body: '[-\\p{L}\\d+._]',
        suffix: '(?<!\\.)'
      )
    end
  end

  class EmailRule
    attr_accessor :prefix, :body, :suffix
    
    def initialize(attributes = {})
      self.prefix, self.body, self.suffix = attributes.values_at(:prefix, :body, :suffix)
    end
  end
end
