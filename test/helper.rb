require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'active_record'

# connect to in memory sqlite DB
ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")

ActiveRecord::Schema.define(:version => 1) do
  create_table :test_users do |t|
    t.string :email
  end

  create_table :test_user_with_messages do |t|
    t.string :email
  end
end

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'email_validator'

class Test::Unit::TestCase
end
