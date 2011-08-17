require 'spec_helper'

class TestUser < TestModel
  validates :email, :email => true
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
      [ "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ@letters-in-local.org",
        "01234567890@numbers-in-local.net",
        "&'*+-./=?^_{}~@other-valid-characters-in-local.net",
        "mixed-1234-in-{+^}-local@sld.net",
        "a@single-character-in-local.org",
        "\"quoted\"@sld.com",
        "\"\\e\\s\\c\\a\\p\\e\\d\"@sld.com",
        "\"quoted-at-sign@sld.org\"@sld.com",
        "\"escaped\\\"quote\"@sld.com",
        "\"back\\slash\"@sld.com",
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
        "punycode-numbers-in-tld@sld.xn--3e0b707e",
        "local@sub.domains.com",
        "bracketed-IP-instead-of-domain@[127.0.0.1]" ].each do |email|

        it "#{email.inspect} should be valid" do
          TestUser.new(:email => email).should be_valid
        end

      end

    end

    context "given the invalid emails" do
      [ "@missing-local.org",
        "! \#$%\`|@invalid-characters-in-local.org",
        "(),:;\`|@more-invalid-characters-in-local.org",
        "<>@[]\`|@even-more-invalid-characters-in-local.org",
        ".local-starts-with-dot@sld.com",
        "local-ends-with-dot.@sld.com",
        "two..consecutive-dots@sld.com",
        "partially.\"quoted\"@sld.com",
        "the-local-part-is-invalid-if-it-is-longer-than-sixty-four-characters@sld.net",
        "missing-sld@.com",
        "sld-starts-with-dashsh@-sld.com",
        "sld-ends-with-dash@sld-.com",
        "invalid-characters-in-sld@! \"\#$%(),/;<>_[]\`|.org",
        "missing-dot-before-tld@com",
        "missing-tld@sld.",
        " ",
        "the-total-length@of-an-entire-address-cannot-be-longer-than-two-hundred-and-fifty-four-characters-and-this-address-is-255-characters-exactly-so-it-should-be-invalid-and-im-going-to-add-some-more-words-here-to-increase-the-lenght-blah-blah-blah-blah-blah-blah-blah-blah.org",
        "missing-at-sign.net",
        "unbracketed-IP@127.0.0.1",
        "invalid-ip@127.0.0.1.26",
        "another-invalid-ip@127.0.0.256",
        "IP-and-port@127.0.0.1:25" ].each do |email|

        it "#{email.inspect} should not be valid" do
          TestUser.new(:email => email).should_not be_valid
        end

      end
    end
  end

  describe "error messages" do
    context "when the message is not defined" do
      subject { TestUser.new :email => 'invalidemail@' }
      before { subject.valid? }

      it "should add the default message" do
        subject.errors[:email].should include "is invalid"
      end
    end

    context "when the message is defined" do
      subject { TestUserWithMessage.new :email_address => 'invalidemail@' }
      before { subject.valid? }

      it "should add the customized message" do
        subject.errors[:email_address].should include "is not looking very good!"
      end
    end
  end

  describe "nil email" do
    it "should not be valid when :allow_nil option is missing" do
      TestUser.new(:email => nil).should_not be_valid
    end

    it "should be valid when :allow_nil options is set to true" do
      TestUserAllowsNil.new(:email => nil).should be_valid
    end

    it "should not be valid when :allow_nil option is set to false" do
      TestUserAllowsNilFalse.new(:email => nil).should_not be_valid
    end
  end
end
