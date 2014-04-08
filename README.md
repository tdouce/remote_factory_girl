# RemoteFactoryGirl

Create [factory_girl](https://github.com/thoughtbot/factory_girl) factories
remotely using remote_factory_girl in conjuction with [remote_factory_girl_home_rails](https://github.com/tdouce/remote_factory_girl_home_rails).

remote_factory_girl should live in the *client* application (the app that is a client/dependency of the *home* app)
and [remote_factory_girl_home_rails](https://github.com/tdouce/remote_factory_girl_home_rails)
should live in the *home* app (the app with factory_girl factories).

Integration testing SOA (Software Oriented Architecture) apps is an inherently
difficult problem (Rails apps included :). SOA is comprised of multiple applications,
and while individual apps can be tested (and presumably passing) in isolation (usually by
mocking http requests), it does not guarantee the apps will work in unison. Testing
interactions between apps is more difficult.

One problem with integration testing SOA apps is that it is difficult to write
integration tests in the client. Due to the nature of SOA you can not
create the data you need when you need it because the database you need to create the data
resides in another application.  It is possible to create test data in traditional apps (apps
that contain a database) with tools such as [FactoryGirl](https://github.com/thoughtbot/factory_girl).
However, in SOA apps factory_girl alone does not suffice.
remote_factory_girl when used in conjunction with [remote_factory_girl_home_rails](https://github.com/tdouce/remote_factory_girl_home_rails),
builds on top of [factory_girl](https://github.com/thoughtbot/factory_girl) (because
we all work on the backs of giants) and provides a mechanism to create the data you need
when you need it in the *home* app from a client app.

## Installation

Add this line to your application's Gemfile:

```ruby
group :test do
  gem 'remote_factory_girl'
end
```


And then execute:

    $ bundle

Or install it yourself as:

    $ gem install remote_factory_girl

## Usage

# Basic

Configure in `spec/spec_helper.rb`
```ruby
RemoteFactoryGirl.configure do |config|
  config.home = { host: 'localhost', port: 5000, end_point: "/over_the_rainbow" }
  config.return_with_root = false
  config.return_response_as = :dot_notation
  config.return_as_active_resource = true 
end
```

Use in specs

```ruby
require 'spec_helper'

describe User do
  it 'should create a user factory in RemoteFactoryGirlHome' do
    user = RemoteFactoryGirl.create(:user, first_name: 'Sam', last_name: 'Iam')
    expect(user.first_name).to eq('Sam')
  end
end
```

# ActiveResource 

Configure in `spec/spec_helper.rb`
```ruby
RemoteFactoryGirl.configure do |config|
  config.home = { host: 'localhost', port: 5000, end_point: "/over_the_rainbow" }
  config.return_as_active_resource = true 
end
```

Use in specs

```ruby
require 'spec_helper'

describe User do
  it 'should create a user factory in RemoteFactoryGirlHome' do
    user = RemoteFactoryGirl.create(:user_with_friends, first_name: 'Sam', last_name: 'Iam').resource(User)
    expect(user.first_name).to eq('Sam')
  end
end
```

## Run tests


    $ rspec


## Contributing

1. Fork it ( http://github.com/<my-github-username>/remote_factory_girl/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
