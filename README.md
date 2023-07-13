# Gaargh

gaargh is a **G**CP **A**lternative **A**uthentication **R**uby **G**em **H**elper and it's also the noise I make when working with GCP and ruby.

This gem was created as a work around for the lack of support for account impersonation using Ruby with GCP.

Ruby isn't one of the 4 language that support account impersonation on GCP as documented [here](https://cloud.google.com/docs/authentication/provide-credentials-adc#sa-impersonation).

The is a github feature request https://github.com/googleapis/google-auth-library-ruby/issues/353 but there has been no update since Nov 16, 2021.

This gem uses the work around discussed in https://github.com/googleapis/google-cloud-ruby/issues/17915 as a work around for dealing with account impersonation.

## Installation

Add this line to your application's Gemfile:

bundler:

```ruby
gem 'gaargh'
```

Or

`gem install 'gaargh'`

## Usage

EXample usage with `Google::Cloud::Storage` client.

```ruby
require 'gaargh'
require 'google/cloud/storage'
impersonated_credentials_client = Gaargh.impersonate_service_account(service_account_email: 'my-service-account@my-project-id.iam.gserviceaccount.com')
storage = Google::Cloud::Storage.new(credentials: impersonated_credentials_client, project_id: 'my-project-id')
puts storage.buckets.map { |b| b.name}
token_info = Gaargh.token_expiration_time(access_token: impersonated_credentials_client.access_token)
pp token_info
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/gaargh.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Creating a Gem

### Create a Gem Skeleton

```bash
bundle gem json_ruby_logger \
--mit \
--linter=rubocop \
--test=rspec \
--ci=github \
--no-coc
```

### Build the gem

```bash
  gem build json_ruby_logger.gemspec
```

### push the gem to rubygems.org

```bash
  gem push json_ruby_logger-0.1.0.gem
```

## Revoke/yank a gem

```bash
  gem yank json_ruby_logger -v 0.1.0
```

## Bump Gem Version

```bash
  gem install gem-release
  gem bump patch --skip-ci --push
```
