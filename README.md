# RemoteFactoryGirl

Create [FactoryGirl](https://github.com/thoughtbot/factory_girl) factories remotely. 

Integration testing SOA (Software Oriented Architecture) apps is an inherently 
difficult problem (Rails apps included :). SOA is comprised of multiple applications, 
and while individual apps can be tested (and presumably passing) in isolation (usually by 
mocking http requests), it does not guarantee the apps will work in unison. Testing 
interactions between apps is more difficult. 

One problem with integration testing SOA apps is that it is difficult to write 
integration tests in the client. Due to the nature of SOA you can not 
create *just* the data you need when you need it because the data you need resides 
in another application.  Traditional apps contain a database and tools such as 
[FactoryGirl](https://github.com/thoughtbot/factory_girl) provide an excellent tool to 
create the data you need when you need it when writing tests. RemoteFactoryGirl,
when used in conjunction with [RemoteFactoryGirlHome](https://github.com/tdouce/remote_factory_girl_home),
provide a mechanism to create the data you need when you need it from the client 
by leveraging the efforts of [FactoryGirl](https://github.com/thoughtbot/factory_girl).

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

## Run tests


    $ rspec


## Contributing

1. Fork it ( http://github.com/<my-github-username>/remote_factory_girl/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
