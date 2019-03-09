# encoding: UTF-8
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
      [
        "a+b@plus-in-local.com",
        "a_b@underscore-in-local.com",
        "user@example.com",
        " user@example.com ",
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
        "areallylongnameaasdfasdfasdfasdf@asdfasdfasdfasdfasdf.ab.cd.ef.gh.co.ca",
        "ящик@яндекс.рф",
        "test@test.testtesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttes",
        "hans,peter@example.com",
        "hans(peter@example.com",
        "hans)peter@example.com",
        "partially.\"quoted\"@sld.com",
        "&'*+-./=?^_{}~@other-valid-characters-in-local.net",
        "mixed-1234-in-{+^}-local@sld.net",
        "user@domain.рф",
        "寿司@example.com"
      ].each do |email|

        it "#{email.inspect} should be valid" do
          expect(TestUser.new(:email => email)).to be_valid
        end

        it "#{email.inspect} should not be invalid" do
          expect(TestUser.new(:email => email)).not_to be_invalid
        end

        it "#{email.inspect} should match the regexp" do
          expect(email =~ EmailValidator.regexp).to be_truthy
        end

        it "#{email.inspect} should pass the class tester" do
          expect(EmailValidator.valid?(email)).to be_truthy
        end

      end

    end

    context "given the invalid emails" do
      [
        "",
        "@bar.com",
        " @bar.com",
        "test@",
        "test@ ",
        " ",
        "missing-at-sign.net",
      ].each do |email|

        it "#{email.inspect} should not be valid" do
          expect(TestUser.new(:email => email)).not_to be_valid
        end

        it "#{email.inspect} should be invalid" do
          expect(TestUser.new(:email => email)).to be_invalid
        end

        it "#{email.inspect} should not match the regexp" do
          expect(email =~ EmailValidator.regexp).to be_falsy
        end

        it "#{email.inspect} should fail the class tester" do
          expect(EmailValidator.valid?(email)).to be_falsy
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

  describe "error details" do
    subject { TestUser.new :email => 'invalidemail@' }
    before { subject.valid? }

    it "should add the default message" do
      expect(subject.errors.details[:email]).to eq [{ error: :invalid, value: 'invalidemail@' }]
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
end
