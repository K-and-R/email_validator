require 'spec_helper'

class TestUser < TestModel
  validates :email, :email => true
end

class StrictUser < TestModel
  validates :email, :email => {:strict_mode => true}
end

class TestUserAllowsNil < TestModel
  validates :email, :email => {:allow_nil => true}
end

class TestUserAllowsNilFalse < TestModel
  validates :email, :email => {:allow_nil => false}
end

class TestUserWithMessage < TestModel
  validates :email_address, :email => {:message => 'is not looking very good!'}
end

describe EmailValidator do
  describe "validation" do
    context "given the valid emails" do
      [
        "a+b@plus-in-local.com",
        "a_b@underscore-in-local.com",
        "user@example.com",
        "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ@letters-in-local.org",
        "01234567890@numbers-in-local.net",
        "a@single-character-in-local.org",
        "one-character-third-level@a.example.com",
        "single-character-in-sld@x.org",
        "local@dash-in-sld.com",
        "letters-in-sld@123.com",
        "one-letter-sld@x.org",
        "uncommon-tld@sld.museum",
        "uncommon-tld@sld.travel",
        "uncommon-tld@sld.mobi",
        "country-code-tld@sld.uk",
        "country-code-tld@sld.rw",
        "local@sld.newTLD",
        "local@sub.domains.com",
        "aaa@bbb.co.jp",
        "nigel.worthington@big.co.uk",
        "f@c.com",
        "f@s",
        "f@s.c",
        "user@localhost",
        "mixed-1234-in-{+^}-local@sld.net",
        "`&'*+-./=?^_{}~@other-valid-characters-in-local.net",
        "partially.\"quoted\"@sld.com",
        "areallylongnameaasdfasdfasdfasdf@asdfasdfasdfasdfasdf.ab.cd.ef.gh.co.ca",
      ].each do |email|

        it "#{email} should be valid" do
          expect(TestUser.new(:email => email)).to be_valid
        end

        it "#{email} should be valid in strict_mode" do
          expect(StrictUser.new(:email => email)).to be_valid
        end

        it "#{email} should be valid using EmailValidator.valid?" do
          expect(EmailValidator.valid?(email)).to be true
        end

        it "#{email} should be valid using EmailValidator.valid? in strict_mode" do
          expect(EmailValidator.valid?(email, strict_mode: true)).to be true
        end

        it "#{email} should not be invalid using EmailValidator.invalid?" do
          expect(EmailValidator.invalid?(email)).to be false
        end

        it "#{email} should not be invalid using EmailValidator.invalid? in strict_mode" do
          expect(EmailValidator.invalid?(email, strict_mode: true)).to be false
        end

        it "#{email} should match the regexp" do
          expect( !!(email.strip =~ EmailValidator.regexp) ).to be true
        end

        it "#{email} should match the strict regexp" do
          expect( !!(email.strip =~ EmailValidator.regexp(strict_mode: true)) ).to be true
        end
      end
    end

    context "given the invalid emails" do
      [
        "",
        "@bar.com",
        "test@example.com@example.com",
        "test@",
        "@missing-local.org",
        "a b@space-in-local.com",
        "! \#$%\|@invalid-characters-in-local.org",
        "<>@[]\|@even-more-invalid-characters-in-local.org",
        "missing-sld@.com",
        "invalid-characters-in-sld@! \"\#$%(),/;<>_[]\`|.org",
        "missing-tld@sld.",
        " ",
        "missing-at-sign.net",
        "unbracketed-IP@127.0.0.1",
        "invalid-ip@127.0.0.1.26",
        "another-invalid-ip@127.0.0.256",
        "IP-and-port@127.0.0.1:25",
        "host-beginning-with-dot@.example.com",
        "domain-beginning-with-dash@-example.com",
        "domain-ending-with-dash@example-.com",
        "the-local-part-is-invalid-if-it-is-longer-than-sixty-four-characters@sld.net",
        "user@example.com\n<script>alert('hello')</script>",
      ].each do |email|

        it "#{email} should not be valid" do
          expect(TestUser.new(:email => email)).not_to be_valid
        end

        it "#{email} should not be valid in strict_mode" do
          expect(StrictUser.new(:email => email)).not_to be_valid
        end

        it "#{email} should not be valid using EmailValidator.valid?" do
          expect(EmailValidator.valid?(email)).to be false
        end

        it "#{email} should not be valid using EmailValidator.valid? in strict_mode" do
          expect(EmailValidator.valid?(email, strict_mode: true)).to be false
        end

        it "#{email} should be invalid using EmailValidator.invalid?" do
          expect(EmailValidator.invalid?(email)).to be true
        end

        it "#{email} should be invalid using EmailValidator.invalid? in strict_mode" do
          expect(EmailValidator.invalid?(email, strict_mode: true)).to be true
        end

        it "#{email} should not match the regexp" do
          expect( !!(email.strip =~ EmailValidator.regexp) ).to be false
        end

        it "#{email} should not match the strict regexp" do
          expect( !!(email.strip =~ EmailValidator.regexp(strict_mode: true)) ).to be false
        end
      end
    end

    context "given the emails that should be invalid in strict_mode but valid in normal mode" do
      [
        " leading-and-trailing-whitespace@example.com ",
        "hans,peter@example.com",
        "hans(peter@example.com",
        "hans)peter@example.com",
        "user..-with-double-dots@example.com",
        ".user-beginning-with-dot@example.com",
        "user-ending-with-dot.@example.com",
        " user-with-leading-whitespace-space@example.com",
        "	user-with-leading-whitespace-tab@example.com",
        "
        user-with-leading-whitespace-newline@example.com",
        "domain-with-trailing-whitespace-space@example.com ",
        "domain-with-trailing-whitespace-tab@example.com	",
        "domain-with-trailing-whitespace-newline@example.com
        ",
      ].each do |email|

        it "#{email.strip} should be valid in model" do
          expect(TestUser.new(:email => email)).to be_valid
        end

        it "#{email.strip} should not be valid in strict_mode in model" do
          expect(StrictUser.new(:email => email)).not_to be_valid
        end

        it "#{email.strip} should be valid using EmailValidator.valid?" do
          expect(EmailValidator.valid?(email)).to be true
        end

        it "#{email.strip} should not be valid using EmailValidator.valid? in strict_mode" do
          expect(EmailValidator.valid?(email, strict_mode: true)).to be false
        end

        it "#{email.strip} should not be invalid using EmailValidator.invalid?" do
          expect(EmailValidator.invalid?(email)).to be false
        end

        it "#{email.strip} should be invalid using EmailValidator.invalid? in strict_mode" do
          expect(EmailValidator.invalid?(email, strict_mode: true)).to be true
        end

        it "#{email.strip} should match the regexp" do
          expect( !!(email =~ EmailValidator.regexp) ).to be true
        end

        it "#{email.strip} should not match the strict regexp" do
          expect( !!(email =~ EmailValidator.regexp(strict_mode: true)) ).to be false
        end
      end
    end
  end

  describe "error messages" do
    context "when the message is not defined" do
      subject { TestUser.new :email => 'invalidemail@' }
      before { subject.valid? }

      it "should add the default message" do
        expect(subject.errors[:email]).to include "is invalid"
      end
    end

    context "when the message is defined" do
      subject { TestUserWithMessage.new :email_address => 'invalidemail@' }
      before { subject.valid? }

      it "should add the customized message" do
        expect(subject.errors[:email_address]).to include "is not looking very good!"
      end
    end
  end

  describe "nil email" do
    it "should not be valid when :allow_nil option is missing" do
      expect(TestUser.new(:email => nil)).not_to be_valid
    end

    it "should be valid when :allow_nil options is set to true" do
      expect(TestUserAllowsNil.new(:email => nil)).to be_valid
    end

    it "should not be valid when :allow_nil option is set to false" do
      expect(TestUserAllowsNilFalse.new(:email => nil)).not_to be_valid
    end
  end

  describe "default_options" do
    context "when 'email_validator/strict' has been required" do
      before { require 'email_validator/strict' }

      it "should validate using strict mode" do
        expect(TestUser.new(:email => "()<>@,;:\".[]@other-valid-characters-in-local.net")).not_to be_valid
      end
    end
  end
end
