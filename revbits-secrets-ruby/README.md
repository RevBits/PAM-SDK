# Revbits PAM

This gem give you programmatic access to securely fetch secrets form RevBits PAM.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'revbits_pam'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install revbits_pam

## Usage

### Configuration

RevBits PAM supports the following configurations

- [Basic Configuration](#basic-configuration)
- [ENV Configuration](#env-configuration)
- [Block Configuration](#block-configuration)

#### Basic Configuration

The simplest configuration is to supply required attributes to configuration object as follows:

```ruby
# Authentication Type (Optional), default (and only available option for now) is :pam
RevbitsPam.configuration.auth_type = :pam

# 'appliance_url' required
RevbitsPam.configuration.appliance_url = "https://your-appliance-url.com"

# 'api_key' required
RevbitsPam.configuration.api_key = "YourRevBitsPamApiKey"
```

#### ENV Configuration

RevBits PAM will automatically fetch the configuration if the following ENV variables are set.

- `REVBITS_AUTH_TYPE` (Optional)
- `REVBITS_APPLIANCE_URL` (Required)
- `REVBITS_API_KAY` (Required)

#### Block Configuration

RevBits PAM also supports configuration via block as follows:

```ruby
RevbitsPam.configure do |c| 
  c.auth_type = :pam (Optional)
  c.appliance_url = "https://your-appliance-url.com"
  c.api_key = "YourRevBitsPamApiKey"
end
```

> :warning: Beware of adding your credentials directly into code always use secrets or ENV to fetch them dynamically.

### Example Usage

```ruby
# Configuration
RevbitsPam.configuration.auth_type = :pam
RevbitsPam.configuration.appliance_url = "https://your-appliance-url.com"
RevbitsPam.configuration.api_key = "YourRevBitsPamApiKey"

# Fetching secrets form RevBits PAM
db_password = RevbitsPam::API.fetch_secret('DB_PASSWORD')
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/RevBits/PAM-SDK/revbits-secrets-ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/RevBits/PAM-SDK/revbits-secrets-ruby/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the RevbitsPam project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/RevBits/revbits_pam/CODE_OF_CONDUCT.md).
