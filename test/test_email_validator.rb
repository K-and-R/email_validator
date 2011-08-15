require 'helper'

class TestUser < TestModel
  validates :email, :email => true
end

class TestUserWithMessage < TestModel
  validates :email_address, :email => {:message => 'is not looking very good!'}
end

class TestEmailValidator < Test::Unit::TestCase
  def test_should_accept_valid_email_addresses
    email_addresses = %W{
      foo@bar.com f@c.com nigel.worthington@big.co.uk f@s.co s@gmail.com foo@g-mail.com -@foo.com
      areallylongnameaasdfasdfasdfasdf@asdfasdfasdfasdfasdf.ab.cd.ef.gh.co.ca
    }
    email_addresses.each do |email_address|
      user = TestUser.new :email => email_address
      assert user.valid?, "'#{email_address}' should be a valid address"
    end
  end

  def test_should_reject_invalid_email_addresses
    email_addresses = %W{
      asdfasdf f@s f@s.c foo@bar@foo.com @bar.com foo@
    }
    email_addresses += [' foo@bar.com', 'foo@bar.com ', '', '   ', 'foo bar@gmail.com', 'foobar@g mail.com']
    email_addresses.each do |email_address|
      user = TestUser.new :email => email_address
      assert !user.valid?, "'#{email_address}' should NOT be a valid address"
    end
  end

  def test_should_properly_set_message
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
