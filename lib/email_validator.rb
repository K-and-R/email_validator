# Based on work from http://thelucid.com/2010/01/08/sexy-validation-in-edge-rails-rails-3/
class EmailValidator < ActiveModel::EachValidator
  @@default_options = {}

  def self.default_options
    @@default_options
  end

  def validate_each(record, attribute, value)
    valid = false
    options = @@default_options.merge(self.options)
    unless value.nil?

      # length check
      local_part = value.strip.split('@').first
      local_part_too_long = local_part.length > 64 if local_part
      domain = value.strip.split('@').last
      label_too_long = !domain.split('.').each.map{|l| !!(l.length < 64) }.all? if domain
      
      unless local_part_too_long || label_too_long
        # Ref: http://tools.ietf.org/html/rfc5321

        #Domain name matching
        letter = '[a-z]'
        digit = '[0-9]'
        hyphen = '-'
        let_dig = "(?:#{letter}|#{digit})"
        ldh = "(?:#{let_dig}|#{hyphen})"
        label_pattern = "#{let_dig}(?:#{ldh}*#{let_dig}+)*"
        tld_pattern = '[a-z]{1,63}'
        domain_pattern = "(?:#{label_pattern}\\.?)*#{tld_pattern}"

        if options[:strict_mode]
          # Local-part matching
          atom_char = '[-a-z0-9+_!"\'#$%^&*{}/=?`\|~]'
          local_part_pattern = "(?:#{atom_char}\\.?)*#{atom_char}"

          valid = true if !!(value.strip =~ /\A#{local_part_pattern}@#{domain_pattern}\z/i)
        else
          valid = true if !!(value.strip =~ /\A[^@\s]+@#{domain_pattern}\z/i)
        end
      end

    end
    record.errors.add(attribute, options[:message] || :invalid) unless valid
  end
end
