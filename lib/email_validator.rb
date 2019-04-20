# Based on work from http://thelucid.com/2010/01/08/sexy-validation-in-edge-rails-rails-3/
class EmailValidator < ActiveModel::EachValidator
  @@default_options = {}

  def self.default_options
    @@default_options
  end

  def self.regexp(options={})
    # Refs:
    #  http://tools.ietf.org/html/rfc5321
    #  https://tools.ietf.org/html/rfc2822

    options = @@default_options.merge(options)

    #Domain name matching
    hyphen = '-'
    alnum = "[[:alnum:]]"
    alnumhy = "(?:#{alnum}|#{hyphen})"
    label_pattern = "#{alnum}(?:#{alnumhy}{,62}#{alnum}+)?"
    tld_pattern = '[[:alpha:]]{1,63}'
    domain_pattern = options[:domain].sub(/\./, '\.') if options[:domain]
    domain_pattern ||= "(?:#{label_pattern}\\.?)*#{tld_pattern}"
    if options[:strict_mode]
      # Local-part matching
      atom_char = '[-\p{Cased_Letter}\p{Nd}+_!"\'#$%^&*{}/=?`\|~]'
      local_part_pattern = "(?:#{atom_char}\\.?){,63}#{atom_char}"
      regexp = /\A(?>#{local_part_pattern})@#{domain_pattern}\z/i
    else
      regexp = /\A\s*(?>[^@\s]{1,64})@#{domain_pattern}\s*\z/i
    end
  end

  def self.valid?(value, options={})
    options = @@default_options.merge(options)
    !!((value.present? || value.nil? && options[:allow_nil].present?) && value =~ self.regexp(options))
  end

  def self.invalid?(value, options={})
    !valid?(value, options)
  end

  def validate_each(record, attribute, value)
    options = @@default_options.merge(self.options)
    record.errors.add(attribute, options[:message] || :invalid) unless self.class.valid?(value, options)
  end
end
