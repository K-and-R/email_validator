[![Code Climate](https://codeclimate.com/github/karlwilbur/email_validator/badges/gpa.svg)](https://codeclimate.com/github/karlwilbur/email_validator)
[![Test Coverage](https://codeclimate.com/github/karlwilbur/email_validator/badges/coverage.svg)](https://codeclimate.com/github/karlwilbur/email_validator/coverage)

# EmailValidator

An email validator for Rails 3+.

Supports RFC-2822-compliant and RFC-5321-compliant email validation.

Originally forked from: https://github.com/balexand/email_validator

## Installation

Add to your Gemfile:

```ruby
gem 'email_validator', github: 'karlwilbur/email_validator'
```

Run:

```
bundle install
```

## Usage

Add the following to your model:

```ruby
validates :my_email_attribute, email: true
```

You may wish to allow domains without a FDQN, like `user@somehost`. While this is technically a valid address, it is uncommon to consider such address valid. We will consider them invalid by default but this can be allowed by setting `require_fqdn: false`:

```ruby
validates :my_email_attribute, email: {require_fqdn: false}
```

You can also limit to a single domain (e.g: this might help if you have separate `User` and `AdminUser` models and want to ensure that `AdminUser` emails are on a specific domain):

```ruby
validates :my_email_attribute, email: {domain: 'example.com'}
```

## Configuration

Default configuration can be overridden by setting options in `config/initializers/email_validator.rb`:

```ruby
if defined?(EmailValidator)
  # To completly override the defaults
  EmailValidator.default_options = {
    :allow_nil => false,
    :domain => nil,
    :require_fqdn => true,
    :strict_mode => false
  }

  # or just a few options
  EmailValidator.default_options.merge!({ :domain => 'mydomain.com' })
end
```

### Strict mode

Normal mode basically checks for a properly sized mailbox label and a single "@" symbol with a properly formatted FQDN. In order to have stricter validation (according to [http://www.remote.org/jochen/mail/info/chars.html](https://web.archive.org/web/20150508102948/http://www.remote.org/jochen/mail/info/chars.html)) enable strict mode. You can do this globally by requiring `email_validator/strict` in your `Gemfile`, by setting the options in `config/initializers/email_validator.rb`, or you can do this in a specific `validates` call.

* `Gemfile`:

  ```ruby
  gem 'email_validator', github: 'karlwilbur/email_validator', :require => 'email_validator/strict'
  ```

* `config/initializers/email_validator.rb`:

  ```ruby
  if defined?(EmailValidator)
    EmailValidator.default_options[:strict_mode] = true
  end
  ```

* `validates` call:

  ```ruby
  validates :my_email_attribute, email: {strict_mode: true}
  ```

## Validation outside a model

If you need to validate an email outside a model, you can get the regexp:

### Normal mode

```ruby
EmailValidator.valid?('narf@example.com') # boolean
```

### Requiring a FQDN

```ruby
EmailValidator.valid?('narf@somehost') # boolean false
EmailValidator.invalid?('narf@somehost', require_fqdn: false) # boolean true
```

### Requiring a specific domain

```ruby
EmailValidator.valid?('narf@example.com', domain: 'foo.com') # boolean false
EmailValidator.invalid?('narf@example.com', domain: 'foo.com') # boolean true
```

### Strict mode

```ruby
EmailValidator.regexp(strict_mode: true) # returns the regex
EmailValidator.valid?('narf@example.com', strict_mode: true) # boolean
```

## Thread safety

This gem is thread safe, with one caveat: `EmailValidator.default_options` must be configured before use in a multi-threaded environment. If you configure `default_options` in a Rails initializer file, then you're good to go since initializers are run before worker threads are spawned.
