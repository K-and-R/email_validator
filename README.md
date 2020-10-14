[![Code Climate](https://codeclimate.com/github/karlwilbur/email_validator/badges/gpa.svg)](https://codeclimate.com/github/karlwilbur/email_validator)
[![Test Coverage](https://codeclimate.com/github/karlwilbur/email_validator/badges/coverage.svg)](https://codeclimate.com/github/karlwilbur/email_validator/coverage)
[![Build Status](https://secure.travis-ci.org/K-and-R/email_validator.svg)](http://travis-ci.org/K-and-R/email_validator)

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

You can also limit to a single domain (e.g: this might help if you have separate `User` and `AdminUser` models and want to ensure that `AdminUser` emails are on a specific domain):

```ruby
validates :my_email_attribute, email: {domain: 'example.com'}
```

## Strict mode

Normal mode basically checks for a properly sized mailbox label and a single "@" symbol with a proper domain. In order to have stricter validation (according to [http://www.remote.org/jochen/mail/info/chars.html](https://web.archive.org/web/20150508102948/http://www.remote.org/jochen/mail/info/chars.html)) enable strict mode. You can do this globally by adding the following to your Gemfile:

```ruby
gem 'email_validator', github: 'karlwilbur/email_validator', :require => 'email_validator/strict'
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

## Alternative gems

Do you prefer a different email validation gem? If so, open an issue with a brief explanation of how it differs from this gem. I'll add a link to it in this README.

* [`email_address`](https://github.com/afair/email_address) (https://github.com/K-and-R/email_validator/issues/58)
* [`email_verifier`](https://github.com/kamilc/email_verifier) (https://github.com/K-and-R/email_validator/issues/65)

## Thread safety

This gem is thread safe, with one caveat: `EmailValidator.default_options` must be configured before use in a multi-threaded environment. If you configure `default_options` in a Rails initializer file, then you're good to go since initializers are run before worker threads are spawned.
