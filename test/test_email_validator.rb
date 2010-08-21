require 'helper'

class TestUser < ActiveRecord::Base
  attr_accessor :email
  validates :email, :email => true
end

class TestUserWithMessage < ActiveRecord::Base
  attr_accessor :email_address
  validates :email_address, :email => {:message => 'is not looking very good!'}
end

class TestEmailValidator < Test::Unit::TestCase
  def email(email)
    TestUser.new :email => email
  end

  should "accept valid email addresses" do
    email_addresses = %W{
      foo@bar.com f@c.com nigel.worthington@big.co.uk f@s.co s@gmail.com foo@g-mail.com -@foo.com
      areallylongnameaasdfasdfasdfasdf@asdfasdfasdfasdfasdf.ab.cd.ef.gh.co.ca
    }
    email_addresses.each do |email_address|
      user = TestUser.new :email => email_address
      assert user.valid?, "'#{email_address}' should be a valid address"
    end
  end

  should "reject invalid email addresses" do
    email_addresses = %W{
      asdfasdf f@s f@s.c foo@bar@foo.com @bar.com foo@
    }
    email_addresses += [' foo@bar.com', 'foo@bar.com ', '', '   ', 'foo bar@gmail.com', 'foobar@g mail.com']
    email_addresses.each do |email_address|
      user = TestUser.new :email => email_address
      assert !user.valid?, "'#{email_address}' should NOT be a valid address"
    end
  end

  should "properly set message" do
    user = TestUser.new :email => 'invalidemail@'
    assert !user.valid?
    assert user.errors.full_messages.count == 1
    assert user.errors.full_messages[0] == "Email is not valid"

    user = TestUserWithMessage.new :email_address => 'invalidemail@'
    assert !user.valid?
    assert user.errors.full_messages.count == 1
    assert user.errors.full_messages[0] == "Email address is not looking very good!"
  end
end
