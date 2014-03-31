# RemoteFactoryGirl

Create FactoryGirl factories remotely. 

Integration testing SOA (Software Oriented Architecture) apps is an inherently 
difficult problem (Rails apps included :). SOA is comprised of multiple applications, 
and while individual apps can be tested (and presumably passing) in isolation (usually by 
mocking http requests), it does not guarantee they will work in unison. Testing 
interactions between the apps is more difficult, and this provides a mechanism to 
do so.  RemoteFactoryGirl creates data needed by the client in the home.

## Installation

Add this line to your application's Gemfile:

    group :test do
      gem 'remote_factory_girl'
    end

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
  it 'creating a user factory in RemoteFactoryGirlHome' do
    user = RemoteFactoryGirl.create(:user, first_name: 'Sam', last_name: 'Iam')
    expect(user.first_name).to eq('Sam')
  end
end
```


## Contributing

1. Fork it ( http://github.com/<my-github-username>/remote_factory_girl/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
