[![Build Status](https://secure.travis-ci.org/balexand/email_validator.png)](http://travis-ci.org/balexand/email_validator)

## Usage

Add to your Gemfile:

```ruby
gem 'email_validator'
```

Run:

```
bundle install
```

Then add the following to your model:

```ruby
validates :my_email_attribute, :email => true
```

## Strict mode

In order to have stricter validation (according to http://www.remote.org/jochen/mail/info/chars.html) enable strict mode. You can do this globally by adding the following to your Gemfile:

```ruby
gem 'email_validator', :require => 'email_validator/strict'
```

Or you can do this in a specific `validates` call:

```ruby
validates :my_email_attribute, :email => {:strict_mode => true}
```

## DNS mode

DNS mode checks the mail exchanger record for the domain of an email address. If themail exchanger record comes back empty, the email will not be validated. To enable this mode globally, you can add it to your Gemfile:

```ruby
gem 'email_validator', :require => 'email_validator/dns'
```

Or you can do this in a specific `validates` call:

```ruby
validates :my_email_attribute, :email => {:dns_mode => true}
```

## Thread safety

This gem is thread safe, with one caveat: `EmailValidator.default_options` must be configured before use in a multi-threaded environment. If you configure `default_options` in a Rails initializer file, then you're good to go since initializers are run before worker threads are spawned.

## Credit

Based on http://thelucid.com/2010/01/08/sexy-validation-in-edge-rails-rails-3

Regular Expression based on http://fightingforalostcause.net/misc/2006/compare-email-regex.php tests.

