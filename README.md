[![Codeship Status for karlwilbur/email_validator](https://codeship.io/projects/4e17e1c0-f4c8-0132-fe8f-324898733d21/status)](https://codeship.io/projects/85627)
[![Code Climate](https://codeclimate.com/github/karlwilbur/email_validator/badges/gpa.svg)](https://codeclimate.com/github/karlwilbur/email_validator)
[![Test Coverage](https://codeclimate.com/github/karlwilbur/email_validator/badges/coverage.svg)](https://codeclimate.com/github/karlwilbur/email_validator/coverage)

# EmailValidator
An email validator for Rails 3+.

Supports RFC-5321-compliant email validation.

Originally forked from: https://github.com/balexand/email_validator

## Installation

Add to your Gemfile:

```ruby
gem 'email_validator'
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

## Strict mode

In order to have stricter validation (according to http://www.remote.org/jochen/mail/info/chars.html) enable strict mode. You can do this globally by adding the following to your Gemfile:

```ruby
gem 'email_validator', :require => 'email_validator/strict'
```

Or you can do this in a specific `validates` call:

```ruby
validates :my_email_attribute, email: {strict_mode: true}
```

## Validation outside a model

If you need to validate an email outside a model, you can get the regexp :

### Normal mode

```ruby
EmailValidator.regexp # returns the regex
EmailValidator.valid?('narf@example.com') # boolean
```

### Strict mode

```ruby
EmailValidator.regexp(strict_mode: true) # returns the regex
EmailValidator.valid?('narf@example.com', {strict_mode: true}) # boolean
```

## Thread safety

This gem is thread safe, with one caveat: `EmailValidator.default_options` must be configured before use in a multi-threaded environment. If you configure `default_options` in a Rails initializer file, then you're good to go since initializers are run before worker threads are spawned.

## Credit

Based on http://thelucid.com/2010/01/08/sexy-validation-in-edge-rails-rails-3

Regular Expression based on http://fightingforalostcause.net/misc/2006/compare-email-regex.php tests.
