require 'spec_helper'

class DefaultUser < TestModel
  validates :email, :email => true
end

class ModerateUser < TestModel
  validates :email, :email => { :mode => :moderate }
end

class StrictUser < TestModel
  validates :email, :email => { :mode => :strict }
end

class AllowNilDefaultUser < TestModel
  validates :email, :email => { :allow_nil => true }
end

class AllowNilModerateUser < TestModel
  validates :email, :email => { :allow_nil => true, :mode => :moderate }
end

class AllowNilStrictUser < TestModel
  validates :email, :email => { :allow_nil => true, :mode => :strict }
end

class DisallowNilDefaultUser < TestModel
  validates :email, :email => { :allow_nil => false }
end

class DisallowNilModerateUser < TestModel
  validates :email, :email => { :allow_nil => false, :mode => :moderate }
end

class DisallowNilStrictUser < TestModel
  validates :email, :email => { :allow_nil => false, :mode => :strict }
end

class DomainModerateUser < TestModel
  validates :email, :email => { :domain => 'example.com', :mode => :moderate }
end

class DomainStrictUser < TestModel
  validates :email, :email => { :domain => 'example.com', :mode => :strict }
end

class NonFqdnModerateUser < TestModel
  validates :email, :email => { :require_fqdn => false, :mode => :moderate }
end

class NonFqdnStrictUser < TestModel
  validates :email, :email => { :require_fqdn => false, :mode => :strict }
end

class DefaultUserWithMessage < TestModel
  validates :email_address, :email => { :message => 'is not looking very good!' }
end

RSpec.describe EmailValidator do
  describe 'validation' do
    valid_special_chars = {
      :ampersand => '&',
      :asterisk => '*',
      :backtick => '`',
      :braceleft => '{',
      :braceright => '}',
      :caret => '^',
      :dollar => '$',
      :equals => '=',
      :exclaim => '!',
      :hash => '#',
      :hyphen => '-',
      :percent => '%',
      :plus => '+',
      :pipe => '|',
      :question => '?',
      :quotedouble => '"',
      :quotesingle => "'",
      :slash => '/',
      :tilde => '~',
      :underscore => '_'
    }

    invalid_special_chars = {
      :backslash => '\\',
      :braketleft => '[',
      :braketright => ']',
      :colon => ':',
      :comma => ',',
      :greater => '>',
      :lesser => '<',
      :parenleft => '(',
      :parenright => ')',
      :semicolon => ';'
    }

    valid_includable            = valid_special_chars.merge({ :dot => '.' })
    valid_beginable             = valid_special_chars
    valid_endable               = valid_special_chars
    invalid_includable          = { :at => '@' }
    whitespace                  = { :newline => "\n", :tab => "\t", :carriage_return => "\r", :space => ' ' }
    moderatly_invalid_includable = invalid_special_chars
    moderatly_invalid_beginable  = moderatly_invalid_includable.merge({ :dot => '.' })
    moderatly_invalid_endable    = moderatly_invalid_beginable
    domain_invalid_beginable    = invalid_special_chars.merge(valid_special_chars)
    domain_invalid_endable      = domain_invalid_beginable
    domain_invalid_includable   = domain_invalid_beginable.reject { |k, _v| k == :hyphen }

    # rubocop:disable Layout/BlockEndNewline, Layout/MultilineBlockLayout, Layout/MultilineMethodCallBraceLayout, Style/BlockDelimiters, Style/MultilineBlockChain
    context 'when given the valid email' do
      valid_includable.map { |k, v| [
        "include-#{v}-#{k}@valid-characters-in-local.dev"
      ]}.concat(valid_beginable.map { |k, v| [
        "#{v}start-with-#{k}@valid-characters-in-local.dev"
      ]}).concat(valid_endable.map { |k, v| [
        "end-with-#{k}-#{v}@valid-characters-in-local.dev"
      ]}).concat([
        'a+b@plus-in-local.com',
        'a_b@underscore-in-local.com',
        'user@example.com',
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ@letters-in-local.dev',
        '01234567890@numbers-in-local.dev',
        'a@single-character-in-local.dev',
        'one-character-third-level@a.example.com',
        'single-character-in-sld@x.dev',
        'local@dash-in-sld.com',
        'numbers-in-sld@s123.com',
        'one-letter-sld@x.dev',
        'uncommon-tld@sld.museum',
        'uncommon-tld@sld.travel',
        'uncommon-tld@sld.mobi',
        'country-code-tld@sld.uk',
        'country-code-tld@sld.rw',
        'local@sld.newTLD',
        'local@sub.domains.com',
        'aaa@bbb.co.jp',
        'nigel.worthington@big.co.uk',
        'f@c.com',
        'f@s.c',
        'someuser@somehost.somedomain',
        'mixed-1234-in-{+^}-local@sld.dev',
        'partially."quoted"@sld.com',
        'areallylongnameaasdfasdfasdfasdf@asdfasdfasdfasdfasdf.ab.cd.ef.gh.co.ca'
      ]).flatten.each do |email|
        context 'when using defaults' do
          it "#{email} should be valid" do
            expect(DefaultUser.new(:email => email)).to be_valid
          end

          it "#{email} should be valid using EmailValidator.valid?" do
            expect(described_class).to be_valid(email)
          end

          it "#{email} should not be invalid using EmailValidator.invalid?" do
            expect(described_class).not_to be_invalid(email)
          end

          it "#{email} should match the regexp" do
            expect(!!(email.strip =~ described_class.regexp)).to be(true)
          end
        end

        context 'when in `:moderate` mode' do
          it "#{email} should be valid" do
            expect(ModerateUser.new(:email => email)).to be_valid
          end

          it "#{email} should be valid using EmailValidator.valid?" do
            expect(described_class).to be_valid(email, :mode => :moderate)
          end

          it "#{email} should not be invalid using EmailValidator.valid?" do
            expect(described_class).not_to be_invalid(email, :mode => :moderate)
          end

          it "#{email} should match the regexp" do
            expect(!!(email.strip =~ described_class.regexp(:mode => :moderate))).to be(true)
          end
        end

        context 'when in `:strict` mode' do
          it "#{email} should be valid" do
            expect(StrictUser.new(:email => email)).to be_valid
          end

          it "#{email} should be valid using EmailValidator.valid?" do
            expect(described_class).to be_valid(email, :mode => :strict)
          end

          it "#{email} should not be invalid using EmailValidator.invalid?" do
            expect(described_class).not_to be_invalid(email, :mode => :strict)
          end

          it "#{email} should match the regexp" do
            expect(!!(email.strip =~ described_class.regexp(:mode => :strict))).to be(true)
          end
        end
      end
    end

    context 'when given the valid host-only email' do
      [
        'f@s',
        'user@localhost',
        'someuser@somehost'
      ].each do |email|
        context 'when using defaults' do
          it "#{email} should be valid" do
            expect(DefaultUser.new(:email => email)).to be_valid
          end

          it "#{email} should be valid using EmailValidator.valid?" do
            expect(described_class).to be_valid(email)
          end

          it "#{email} should not be invalid using EmailValidator.invalid?" do
            expect(described_class).not_to be_invalid(email)
          end

          it "#{email} should match the regexp" do
            expect(!!(email.strip =~ described_class.regexp)).to be(true)
          end
        end

        context 'when in `:moderate` mode' do
          it "#{email} should not be valid" do
            expect(ModerateUser.new(:email => email)).not_to be_valid
          end

          it "#{email} should not be valid using EmailValidator.valid?" do
            expect(described_class).not_to be_valid(email, :mode => :moderate)
          end

          it "#{email} should be invalid using EmailValidator.invalid?" do
            expect(described_class).to be_invalid(email, :mode => :moderate)
          end

          it "#{email} should not match the regexp" do
            expect(!!(email.strip =~ described_class.regexp(:mode => :moderate))).to be(false)
          end
        end

        context 'when in `:strict` mode' do
          it "#{email} should be valid" do
            expect(StrictUser.new(:email => email)).to be_valid
          end

          it "#{email} should be valid using EmailValidator.valid?" do
            expect(described_class).to be_valid(email, :mode => :strict)
          end

          it "#{email} should not be invalid using EmailValidator.invalid?" do
            expect(described_class).not_to be_invalid(email, :mode => :strict)
          end

          it "#{email} should match the regexp" do
            expect(!!(email.strip =~ described_class.regexp(:mode => :strict))).to be(true)
          end
        end
      end
    end

    context 'when given the valid IP address email' do
      [
        'bracketed-IP@[127.0.0.1]',
        'bracketed-and-labeled-IPv6@[IPv6:abcd:ef01:1234:5678:9abc:def0:1234:5678]'
      ].each do |email|
        context 'when using defaults' do
          it "#{email} should be valid" do
            expect(DefaultUser.new(:email => email)).to be_valid
          end

          it "#{email} should be valid using EmailValidator.valid?" do
            expect(described_class).to be_valid(email)
          end

          it "#{email} should not be invalid using EmailValidator.invalid?" do
            expect(described_class).not_to be_invalid(email)
          end

          it "#{email} should match the regexp" do
            expect(!!(email.strip =~ described_class.regexp)).to be(true)
          end
        end

        context 'when in `:moderate` mode' do
          it "#{email} should not be valid" do
            expect(ModerateUser.new(:email => email)).not_to be_valid
          end

          it "#{email} should not be valid using EmailValidator.valid?" do
            expect(described_class).not_to be_valid(email, :mode => :moderate)
          end

          it "#{email} should be invalid using EmailValidator.invalid?" do
            expect(described_class).to be_invalid(email, :mode => :moderate)
          end

          it "#{email} should not match the strict regexp" do
            expect(!!(email.strip =~ described_class.regexp(:mode => :moderate))).to be(false)
          end
        end

        context 'when in `:strict` mode' do
          it "#{email} should be valid" do
            expect(StrictUser.new(:email => email)).to be_valid
          end

          it "#{email} should be valid using EmailValidator.valid?" do
            expect(described_class).to be_valid(email, :mode => :strict)
          end

          it "#{email} should not be invalid using EmailValidator.invalid?" do
            expect(described_class).not_to be_invalid(email, :mode => :strict)
          end

          it "#{email} should match the strict regexp" do
            expect(!!(email.strip =~ described_class.regexp(:mode => :strict))).to be(true)
          end
        end
      end
    end

    context 'when given the invalid email' do
      invalid_includable.map { |k, v| [
        "include-#{v}-#{k}@invalid-characters-in-local.dev"
      ]}.concat(domain_invalid_beginable.map { |k, v| [
        "start-with-#{k}@#{v}invalid-characters-in-domain.dev"
      ]}).concat(domain_invalid_endable.map { |k, v| [
        "end-with-#{k}@invalid-characters-in-domain#{v}.dev"
      ]}).concat(domain_invalid_includable.map { |k, v| [
        "include-#{k}@invalid-characters-#{v}-in-domain.dev"
      ]}).concat([
        'test@example.com@example.com',
        'missing-sld@.com',
        'missing-tld@sld.',
        'only-numbers-in-domain-label@sub.123.com',
        'only-numbers-in-domain-label@123.example.com',
        'unbracketed-IPv6@abcd:ef01:1234:5678:9abc:def0:1234:5678',
        'unbracketed-and-labled-IPv6@IPv6:abcd:ef01:1234:5678:9abc:def0:1234:5678',
        'bracketed-and-unlabeled-IPv6@[abcd:ef01:1234:5678:9abc:def0:1234:5678]',
        'unbracketed-IPv4@127.0.0.1',
        'invalid-IPv4@127.0.0.1.26',
        'another-invalid-IPv4@127.0.0.256',
        'IPv4-and-port@127.0.0.1:25',
        'host-beginning-with-dot@.example.com',
        'domain-beginning-with-dash@-example.com',
        'domain-ending-with-dash@example-.com',
        'the-local-part-is-invalid-if-it-is-longer-than-sixty-four-characters@sld.dev',
        "user@example.com<script>alert('hello')</script>"
      ]).flatten.each do |email|
        context 'when using defaults' do
          it "#{email} should be valid" do
            expect(DefaultUser.new(:email => email)).to be_valid
          end

          it "#{email} should be valid using EmailValidator.valid?" do
            expect(described_class).to be_valid(email)
          end

          it "#{email} should not be invalid using EmailValidator.invalid?" do
            expect(described_class).not_to be_invalid(email)
          end

          it "#{email} should match the regexp" do
            expect(!!(email.strip =~ described_class.regexp)).to be(true)
          end
        end

        context 'when in `:moderate` mode' do
          it "#{email} should not be valid" do
            expect(ModerateUser.new(:email => email)).not_to be_valid
          end

          it "#{email} should not be valid using EmailValidator.valid?" do
            expect(described_class).not_to be_valid(email, :mode => :moderate)
          end

          it "#{email} should be invalid using EmailValidator.invalid?" do
            expect(described_class).to be_invalid(email, :mode => :moderate)
          end

          it "#{email} should not match the strict regexp" do
            expect(!!(email.strip =~ described_class.regexp(:mode => :moderate))).to be(false)
          end
        end

        context 'when in `:strict` mode' do
          it "#{email} should not be valid" do
            expect(StrictUser.new(:email => email)).not_to be_valid
          end

          it "#{email} should not be valid using EmailValidator.valid?" do
            expect(described_class).not_to be_valid(email, :mode => :strict)
          end

          it "#{email} should be invalid using EmailValidator.invalid?" do
            expect(described_class).to be_invalid(email, :mode => :strict)
          end

          it "#{email} should not match the strict regexp" do
            expect(!!(email.strip =~ described_class.regexp(:mode => :strict))).to be(false)
          end
        end
      end
    end

    context 'when given the invalid email with whitespace in parts' do
      whitespace.map { |k, v| [
        "include-#{v}-#{k}@invalid-characters-in-local.dev"
      ]}.concat([
        'foo @bar.com',
        "foo\t@bar.com",
        "foo\n@bar.com",
        "foo\r@bar.com",
        'test@ example.com',
        'user@example .com',
        "user@example\t.com",
        "user@example\n.com",
        "user@example\r.com",
        'user@exam ple.com',
        "user@exam\tple.com",
        "user@exam\nple.com",
        "user@exam\rple.com",
        'us er@example.com',
        "us\ter@example.com",
        "us\ner@example.com",
        "us\rer@example.com",
        "user@example.com\n<script>alert('hello')</script>",
        "user@example.com\t<script>alert('hello')</script>",
        "user@example.com\r<script>alert('hello')</script>",
        "user@example.com <script>alert('hello')</script>",
        ' leading-whitespace@example.com',
        'trailing-whitespace@example.com ',
        ' leading-and-trailing-whitespace@example.com ',
        ' user-with-leading-whitespace-space@example.com',
        "\tuser-with-leading-whitespace-tab@example.com",
        "
        user-with-leading-whitespace-newline@example.com",
        'domain-with-trailing-whitespace-space@example.com ',
        "domain-with-trailing-whitespace-tab@example.com\t",
        "domain-with-trailing-whitespace-newline@example.com
        "
      ]).flatten.each do |email|
        context 'when using defaults' do
          it "#{email} should not be valid" do
            expect(DefaultUser.new(:email => email)).not_to be_valid
          end

          it "#{email} should not be valid using EmailValidator.valid?" do
            expect(described_class).not_to be_valid(email)
          end

          it "#{email} should be invalid using EmailValidator.invalid?" do
            expect(described_class).to be_invalid(email)
          end

          it "#{email} should not match the regexp" do
            expect(!!(email =~ described_class.regexp)).to be(false)
          end
        end

        context 'when in `:moderate` mode' do
          it "#{email} should not be valid" do
            expect(ModerateUser.new(:email => email)).not_to be_valid
          end

          it "#{email} should not be valid using EmailValidator.valid?" do
            expect(described_class).not_to be_valid(email, :mode => :moderate)
          end

          it "#{email} should be invalid using EmailValidator.invalid?" do
            expect(described_class).to be_invalid(email, :mode => :moderate)
          end

          it "#{email} should not match the strict regexp" do
            expect(!!(email =~ described_class.regexp(:mode => :moderate))).to be(false)
          end
        end

        context 'when in `:strict` mode' do
          it "#{email} should not be valid" do
            expect(StrictUser.new(:email => email)).not_to be_valid
          end

          it "#{email} should not be valid using EmailValidator.valid?" do
            expect(described_class).not_to be_valid(email, :mode => :strict)
          end

          it "#{email} should be invalid using EmailValidator.invalid?" do
            expect(described_class).to be_invalid(email, :mode => :strict)
          end

          it "#{email} should not match the strict regexp" do
            expect(!!(email =~ described_class.regexp(:mode => :strict))).to be(false)
          end
        end
      end
    end

    context 'when given the invalid email with missing parts' do
      [
        '',
        '@bar.com',
        'test@',
        '@missing-local.dev',
        ' ',
        'missing-at-sign.dev'
      ].each do |email|
        context 'when using defaults' do
          it "#{email} should not be valid" do
            expect(DefaultUser.new(:email => email)).not_to be_valid
          end

          it "#{email} should not be valid using EmailValidator.valid?" do
            expect(described_class).not_to be_valid(email)
          end

          it "#{email} should be invalid using EmailValidator.invalid?" do
            expect(described_class).to be_invalid(email)
          end

          it "#{email} should not match the regexp" do
            expect(!!(email.strip =~ described_class.regexp)).to be(false)
          end
        end

        context 'when in `:moderate` mode' do
          it "#{email} should not be valid" do
            expect(ModerateUser.new(:email => email)).not_to be_valid
          end

          it "#{email} should not be valid using EmailValidator.valid?" do
            expect(described_class).not_to be_valid(email, :mode => :moderate)
          end

          it "#{email} should be invalid using EmailValidator.invalid?" do
            expect(described_class).to be_invalid(email, :mode => :moderate)
          end

          it "#{email} should not match the strict regexp" do
            expect(!!(email.strip =~ described_class.regexp(:mode => :moderate))).to be(false)
          end
        end

        context 'when in `:strict` mode' do
          it "#{email} should not be valid" do
            expect(StrictUser.new(:email => email)).not_to be_valid
          end

          it "#{email} should not be valid using EmailValidator.valid?" do
            expect(described_class).not_to be_valid(email, :mode => :strict)
          end

          it "#{email} should be invalid using EmailValidator.invalid?" do
            expect(described_class).to be_invalid(email, :mode => :strict)
          end

          it "#{email} should not match the strict regexp" do
            expect(!!(email.strip =~ described_class.regexp(:mode => :strict))).to be(false)
          end
        end
      end
    end

    context 'when given the moderatly invalid email' do
      moderatly_invalid_includable.map { |k, v| [
        "include-#{v}-#{k}@invalid-characters-in-local.dev"
      ]}.concat(moderatly_invalid_beginable.map { |k, v| [
        "#{v}start-with-#{k}@invalid-characters-in-local.dev"
      ]}).concat(moderatly_invalid_endable.map { |k, v| [
        "end-with-#{k}#{v}@invalid-characters-in-local.dev"
      ]}).concat([
        'user..-with-double-dots@example.com',
        '.user-beginning-with-dot@example.com',
        'user-ending-with-dot.@example.com'
      ]).flatten.each do |email|
        context 'when using defaults' do
          it "#{email.strip} in a model should be valid" do
            expect(DefaultUser.new(:email => email)).to be_valid
          end

          it "#{email.strip} should be valid using EmailValidator.valid?" do
            expect(described_class).to be_valid(email)
          end

          it "#{email.strip} should not be invalid using EmailValidator.invalid?" do
            expect(described_class).not_to be_invalid(email)
          end

          it "#{email.strip} should match the regexp" do
            expect(!!(email =~ described_class.regexp)).to be(true)
          end
        end

        context 'when in `:moderate` mode' do
          it "#{email.strip} in a model should be valid" do
            expect(ModerateUser.new(:email => email)).not_to be_valid
          end

          it "#{email.strip} should not be valid using EmailValidator.valid?" do
            expect(described_class).not_to be_valid(email, :mode => :moderate)
          end

          it "#{email.strip} should be invalid using EmailValidator.invalid?" do
            expect(described_class).to be_invalid(email, :mode => :moderate)
          end

          it "#{email.strip} should not match the strict regexp" do
            expect(!!(email =~ described_class.regexp(:mode => :moderate))).to be(false)
          end
        end

        context 'when in `:strict` mode' do
          it "#{email.strip} in a model should not be valid" do
            expect(StrictUser.new(:email => email)).not_to be_valid
          end

          it "#{email.strip} should not be valid using EmailValidator.valid?" do
            expect(described_class).not_to be_valid(email, :mode => :strict)
          end

          it "#{email.strip} should be invalid using EmailValidator.invalid?" do
            expect(described_class).to be_invalid(email, :mode => :strict)
          end

          it "#{email.strip} should not match the strict regexp" do
            expect(!!(email =~ described_class.regexp(:mode => :strict))).to be(false)
          end
        end
      end
    end

    context 'when `require_fqdn` is explicitly disabled' do
      let(:opts) { { :require_fqdn => false } }

      context 'when given a valid hostname-only email' do
        let(:email) { 'someuser@somehost' }

        context 'when using defaults' do
          it 'is valid using EmailValidator.valid?' do
            expect(described_class).to be_valid(email, opts)
          end

          it 'is not invalid using EmailValidator.invalid?' do
            expect(described_class).not_to be_invalid(email, opts)
          end

          it 'matches the regexp' do
            expect(!!(email =~ described_class.regexp(opts))).to be(true)
          end
        end

        context 'when in `"moderate` mode' do
          let(:opts) { { :require_fqdn => false, :mode => :moderate } }

          it 'is valid' do
            expect(NonFqdnModerateUser.new(:email => email)).to be_valid
          end

          it 'is valid using EmailValidator.valid?' do
            expect(described_class).to be_valid(email, opts)
          end

          it 'is not invalid using EmailValidator.invalid?' do
            expect(described_class).not_to be_invalid(email, opts)
          end

          it 'matches the regexp' do
            expect(!!(email =~ described_class.regexp(opts))).to be(true)
          end
        end

        context 'when in `:strict` mode' do
          let(:opts) { { :require_fqdn => false, :mode => :strict } }

          it 'is valid in strict mode' do
            expect(NonFqdnStrictUser.new(:email => email)).to be_valid
          end

          it 'is valid using EmailValidator.valid?' do
            expect(described_class).to be_valid(email, opts)
          end

          it 'is not invalid using EmailValidator.invalid?' do
            expect(described_class).not_to be_invalid(email, opts)
          end

          it 'does not match the strict regexp' do
            expect(!!(email =~ described_class.regexp(opts))).to be(true)
          end
        end
      end

      context 'when given a valid email using an FQDN' do
        let(:email) { 'someuser@somehost.somedomain' }

        it 'is valid' do
          expect(NonFqdnModerateUser.new(:email => email)).to be_valid
        end

        # rubocop:disable RSpec/PredicateMatcher
        it 'is valid using EmailValidator.valid?' do
          expect(described_class.valid?(email, opts)).to be(true)
        end

        it 'is not invalid using EmailValidator.invalid?' do
          expect(described_class.invalid?(email, opts)).to be(false)
        end
        # rubocop:enable RSpec/PredicateMatcher

        it 'matches the regexp' do
          expect(!!(email =~ described_class.regexp(opts))).to be(true)
        end

        context 'when in `:strict` mode' do
          let(:opts) { { :require_fqdn => false, :mode => :strict } }

          # rubocop:disable RSpec/PredicateMatcher
          it 'is valid using EmailValidator.valid?' do
            expect(described_class.valid?(email, opts)).to be(true)
          end

          it 'is not invalid using EmailValidator.invalid?' do
            expect(described_class.invalid?(email, opts)).to be(false)
          end
          # rubocop:enable RSpec/PredicateMatcher

          it 'is valid in strict mode' do
            expect(NonFqdnStrictUser.new(:email => email)).to be_valid
          end

          it 'does not match the strict regexp' do
            expect(!!(email =~ described_class.regexp(opts))).to be(true)
          end
        end

        context 'when requiring a non-matching domain' do
          let(:domain) { 'example.com' }
          let(:opts) { { :domain => domain } }

          it 'is not valid' do
            expect(DomainModerateUser.new(:email => email)).not_to be_valid
          end

          it 'is not valid using EmailValidator.valid?' do
            expect(described_class).not_to be_valid(email, opts)
          end

          it 'is invalid using EmailValidator.invalid?' do
            expect(described_class).to be_invalid(email, opts)
          end

          it 'does not matches the regexp' do
            expect(!!(email =~ described_class.regexp(opts))).to be(false)
          end

          context 'when in `:strict` mode' do
            let(:opts) { { :domain => domain, :require_fqdn => false, :mode => :strict } }

            it 'is not valid using EmailValidator.valid?' do
              expect(described_class).not_to be_valid(email, opts)
            end

            it 'is invalid using EmailValidator.invalid?' do
              expect(described_class).to be_invalid(email, opts)
            end

            it 'is not valid' do
              expect(DomainStrictUser.new(:email => email)).not_to be_valid
            end

            it 'does not match the regexp' do
              expect(!!(email =~ described_class.regexp(opts))).to be(false)
            end
          end
        end
      end
    end
  end
  # rubocop:enable Layout/BlockEndNewline, Layout/MultilineBlockLayout, Layout/MultilineMethodCallBraceLayout, Style/BlockDelimiters, Style/MultilineBlockChain

  describe 'error messages' do
    context 'when the message is not defined' do
      let(:model) { DefaultUser.new :email => 'invalidemail@' }

      before { model.valid? }

      it 'adds the default message' do
        expect(model.errors[:email]).to include 'is invalid'
      end
    end

    context 'when the message is defined' do
      let(:model) { DefaultUserWithMessage.new :email_address => 'invalidemail@' }

      before { model.valid? }

      it 'adds the customized message' do
        expect(model.errors[:email_address]).to include 'is not looking very good!'
      end
    end
  end

  describe 'nil email' do
    it 'is not valid when :allow_nil option is missing' do
      expect(DefaultUser.new(:email => nil)).not_to be_valid
    end

    it 'is valid when :allow_nil options is set to true' do
      expect(AllowNilDefaultUser.new(:email => nil)).to be_valid
    end

    it 'is not valid when :allow_nil option is set to false' do
      expect(DisallowNilDefaultUser.new(:email => nil)).not_to be_valid
    end
  end

  describe 'limited to a domain' do
    context 'when in `:moderate` mode' do
      it 'is not valid with mismatched domain' do
        expect(DomainModerateUser.new(:email => 'user@not-matching.io')).not_to be_valid
      end

      it 'is valid with matching domain' do
        expect(DomainModerateUser.new(:email => 'user@example.com')).to be_valid
      end

      it 'does not interpret the dot as any character' do
        expect(DomainModerateUser.new(:email => 'user@example-com')).not_to be_valid
      end
    end

    context 'when in strict mode' do
      it 'does not interpret the dot as any character' do
        expect(DomainStrictUser.new(:email => 'user@example-com')).not_to be_valid
      end

      it 'is valid with matching domain' do
        expect(DomainStrictUser.new(:email => 'user@example.com')).to be_valid
      end

      it 'is not valid with mismatched domain' do
        expect(DomainStrictUser.new(:email => 'user@not-matching.io')).not_to be_valid
      end
    end
  end

  describe 'default_options' do
    let(:email) { 'includes-whitespace-in-otherwise-valid-email@local' }

    it 'validates using `:loose` mode' do
      expect(DefaultUser.new(:email => email)).to be_valid
    end

    context 'when `email_validator/moderate` has been required' do
      before { require 'email_validator/moderate' }

      it 'validates using `:moderate` mode' do
        expect(DefaultUser.new(:email => email)).not_to be_valid
      end
    end

    context 'when `email_validator/strict` has been required' do
      before { require 'email_validator/strict' }

      it 'validate using `:strict` mode' do
        expect(DefaultUser.new(:email => email)).to be_valid
      end
    end
  end
end
