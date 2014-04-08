# RemoteFactoryGirl and RemoteFactoryGirlHomeRails

Create [factory_girl](https://github.com/thoughtbot/factory_girl) factories
remotely using [remote_factory_girl](https://github.com/tdouce/remote_factory_girl) in conjuction with [remote_factory_girl_home_rails](https://github.com/tdouce/remote_factory_girl_home_rails).

# Why RemoteFactoryGirl and RemoteFactoryGirlHomeRails?

Integration testing SOA (Software Oriented Architecture) apps is an inherently
difficult problem (Rails apps included :). SOA is comprised of multiple applications,
and while individual apps can be tested (and presumably passing) in isolation (usually by
mocking http requests), it does not guarantee the apps will work in unison. Testing
interactions between apps is more difficult.

One problem with integration testing SOA apps is that it is difficult to write
integration tests in the client. Due to the nature of SOA you can not
create the data you need because the database that is needed to create the data
resides in another application.  Consider the following architecture:

- image of 
  - *home* (with database) 
    - with user model
  - *client*
  - communicate over http (via json)

The *home* application contains the database, and the *client* application does
not have a database.  If the *client* application wants a list of all the
users, it has to make an http json request to *home*, *home* requests all the users
from the database, and *home* sends the response back to the *client*.

In traditional applications (apps that contain a database), it is possible to create 
test data  with tools such as [FactoryGirl](https://github.com/thoughtbot/factory_girl).
However, in SOA apps factory_girl alone does not suffice.  remote_factory_girl when used in 
conjunction with [remote_factory_girl_home_rails](https://github.com/tdouce/remote_factory_girl_home_rails), builds on top of [factory_girl](https://github.com/thoughtbot/factory_girl) (because we all work on the backs of giants) 
and provides a mechanism to create the data you need from the *client* app in the *home* app.


## Installation

[remote_factory_girl](https://github.com/tdouce/remote_factory_girl) should live in the *client* application and [remote_factory_girl_home_rails](https://github.com/tdouce/remote_factory_girl_home_rails) should live in the *home* app (the app with factory_girl factories).

## Client

Add this line to the *client* application's Gemfile:

```ruby
group :test do
  gem 'remote_factory_girl'
end
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install remote_factory_girl

### Basic

Configure in `spec/spec_helper.rb`
```ruby
RemoteFactoryGirl.configure do |config|
  config.home = { host: 'localhost', port: 5000, end_point: "/over_the_rainbow" }
  config.return_with_root = false
  config.return_response_as = :dot_notation
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

### ActiveResource 

Configure in `spec/spec_helper.rb`
```ruby
RemoteFactoryGirl.configure do |config|
  config.home = { host: 'localhost', port: 5000, end_point: '/remote_factory_girl' }
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

## Home

Add this line to *home* application's Gemfile:

```ruby
group :test do
  gem 'remote_factory_girl_home_rails'
end
```

And then execute:

    $ bundle


## Usage

Configure in `config/environments/*.rb`

Activate [remote_factory_girl_home_rails](https://github.com/tdouce/remote_factory_girl_home_rails) to run in the environments in which it is intended to
run. For example, if remote_factory_girl_home_rails is included in `group
:test` (most common), then activate it in `config/environments/test.rb`

```ruby
YourApplication::Application.configure do
  ...
  config.remote_factory_girl_home_rails.enable = true
  ...
end
```

Configure in `config/routes.rb`

```ruby
YourApplication::Application.routes.draw do
  if defined?(RemoteFactoryGirlHomeRails::Engine)
    mount RemoteFactoryGirlHomeRails::Engine, at: '/remote_factory_girl' 
  end
end
```

Configure in `config/initializers/remote_factory_girl_home_rails.rb` 

Specify any methods that should be skipped for incoming http requests.  The most
common methods to skip are authentication related methods that live in
`ApplicationController`.


```ruby
RemoteFactoryGirlHomeRails.configure do |config|
  config.skip_before_filter = [:authenticate, :some_other_method]
end if defined?(RemoteFactoryGirlHomeRails)
```


## Usage

### Home

1. Run any outstanding migrations. 
2. Start the *home* application's server at the port and end point specified in the *client*
application's configuration. Given the above example:

```bash
rails server --environment=test --pid=/Users/your_app/tmp/pids/test.pid --port=5000
```

### Client

Run your test suite.




