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
validates :my_email_attribute, email: true
```

## Validation outside a model

If you'd like to validate an email outside of a model then here are some class methods that you can use:

```ruby
EmailValidator.regexp # returns the regex
EmailValidator.valid?('narf@example.com') # => true
EmailValidator.invalid?('narf@example.com') # => false
```

## Validation philosophy

The validation provided by this gem is loose. It just checks that there's an `@` with something before and after it. See [this article by David Gilbertson](https://hackernoon.com/the-100-correct-way-to-validate-email-addresses-7c4818f24643) for an explanation of why.

## Alternative gems

Do you prefer a different email validation gem? If so, open an issue with a brief explanation of how it differs from this gem. I'll add a link to it in this README.

## Thread safety

This gem is thread safe.
