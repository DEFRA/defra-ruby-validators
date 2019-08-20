<img src="/defra-ruby-validators.png" alt="Defra ruby validators logo" />

[![Build Status](https://travis-ci.com/DEFRA/defra-ruby-validators.svg?branch=master)](https://travis-ci.com/DEFRA/defra-ruby-validators)
[![Maintainability](https://api.codeclimate.com/v1/badges/a0f8611f1a879786f642/maintainability)](https://codeclimate.com/github/DEFRA/defra-ruby-validators/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/a0f8611f1a879786f642/test_coverage)](https://codeclimate.com/github/DEFRA/defra-ruby-validators/test_coverage)
[![security](https://hakiri.io/github/DEFRA/defra-ruby-validators/master.svg)](https://hakiri.io/github/DEFRA/defra-ruby-validators/master)
[![Gem Version](https://badge.fury.io/rb/defra_ruby_validators.svg)](https://badge.fury.io/rb/defra_ruby_validators)
[![Licence](https://img.shields.io/badge/Licence-OGLv3-blue.svg)](http://www.nationalarchives.gov.uk/doc/open-government-licence/version/3)

Package of validations commonly used in Defra Rails based digital services.

## Installation

Add this line to your application's Gemfile

```ruby
gem "defra_ruby_validators"
```

And then update your dependencies by calling

```bash
bundle install
```

## Usage

With this gem installed, a number of active model based validators become available.

### Business type

This validator checks the value provided is one of our known business types

- `soleTrader`
- `limitedCompany`
- `partnership`
- `limitedLiabilityPartnership`
- `localAuthority`
- `charity`

If blank or not one of these it will return an error.

Add it to your model or form object using

```ruby
validates :business_type, "defra_ruby/validators/business_type": true
```

### Companies House number

This validator checks the company registration number provided. Specifically it first checks that it matches a known format. All registration numbers are 8 characters long but can be formatted in the following ways.

- 09764739
- 10997904
- SC534714
- IP00141R

If the format is valid, it then makes a call to Companies House to validate that the number

- is recognised
- belongs to an 'active' company

A company can be in various states for example liquidation, which means for the purposes of Defra its not a valid entity. So we check the status along with the number as part of the validation.

Add it to your model or form object using

```ruby
validates :company_no, "defra_ruby/validators/companies_house_number": true
```

### Email

This validator checks the value is present and in a format that meets [RFC 2822](https://tools.ietf.org/html/rfc2822) and [RFC 3696](https://tools.ietf.org/html/rfc3696) (we use [validates_email_format_of](https://github.com/validates-email-format-of/validates_email_format_of) to check the format).

Add it to your model or form object using

```ruby
validates :email, "defra_ruby/validators/email": true
```

### Grid reference

This validator checks the value is present, is in the correct format for an [Ordnance Survey National Grid Reference](https://en.wikipedia.org/wiki/Ordnance_Survey_National_Grid), and that its valid (we use [os_map_ref](https://github.com/DEFRA/os-map-ref) to check the coordinate is valid).

Add it to your model or form object using

```ruby
validates :grid_reference, "defra_ruby/validators/grid_reference": true
```

### Location

This validator checks the value provided is one of our accepted locations

- `england`
- `northern_ireland`
- `scotland`
- `wales`

If blank or not one of these it will return an error.

Add it to your model or form object using

```ruby
validates :location, "defra_ruby/validators/location": true
```

If you want to include `overseas` in the accepted locations, you can enable this in the options:

 ```ruby
validates :location, "defra_ruby/validators/location": { allow_overseas: true }
```

### Phone number

This validator checks the value is present, is not too long (15 is th maximum length for any phone number), and is in the correct format as per [E.164](https://en.wikipedia.org/wiki/E.164) (we use [phonelib](https://github.com/daddyz/phonelib) to check the format).

Add it to your model or form object using

```ruby
validates :phone_number, "defra_ruby/validators/phone_number": true
```

### Position

This validator checks the value provided for 'position' i.e. someones role or title within an organisation. This is an optional field so the validator has to handle the value being blank. If it's not then it can be no longer than 70 characters and only include letters, spaces, commas, full stops, hyphens and apostrophes else it will return an error.

Add it to your model or form object using

```ruby
validates :position, "defra_ruby/validators/position": true
```

### Token

This validator checks the value is present and in the correct format, which in this case is that the value has a length of 24. If blank or not in a valid format it will return an error.

Add it to your model or form object using

```ruby
validates :token, "defra_ruby/validators/token": true
```

### True or false

This validator checks the value provided is either `"true"` or `"false"`. If blank or not one of these it will return an error.

Add it to your model or form object using

```ruby
validates :is_a_farmer, "defra_ruby/validators/true_false": true
```

## Adding custom error messages

All the validators in this gem have built-in error messages. But if you want, you can provide your own custom message in the app, like this:

```ruby
validates :position, "defra_ruby/validators/position": { messages: { too_long: "This position is too long" } }
```

You will need to know the error symbol raised by the validator (eg `too_long` or `invalid_format`).

## Contributing to this project

If you have an idea you'd like to contribute please log an issue.

All contributions should be submitted via a pull request.

## License

THIS INFORMATION IS LICENSED UNDER THE CONDITIONS OF THE OPEN GOVERNMENT LICENCE found at:

http://www.nationalarchives.gov.uk/doc/open-government-licence/version/3

The following attribution statement MUST be cited in your products and applications when using this information.

> Contains public sector information licensed under the Open Government license v3

### About the license

The Open Government Licence (OGL) was developed by the Controller of Her Majesty's Stationery Office (HMSO) to enable information providers in the public sector to license the use and re-use of their information under a common open licence.

It is designed to encourage use and re-use of information freely and flexibly, with only a few conditions.
