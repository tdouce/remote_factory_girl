require 'remote_factory_girl'

describe RemoteFactoryGirl do

  it 'should return params for http request' do
    rfg = RemoteFactoryGirl::RemoteFactoryGirl.new('user', { :first_name => 'Sam' })
    expect(rfg.params).to eq(
      { :factory => 'user', :attributes => { :first_name => 'Sam'}}
    )
  end

  it 'should be able to configure with a block' do
    pending
  end

  describe '.config' do
    it 'should be able to set and get config' do
      config = double('config')
      RemoteFactoryGirl.config = config
      expect(RemoteFactoryGirl.config).to equal(config)
    end
  end

  describe '.reset' do
    it 'should be able to reset the configuration' do
      config = double('config')
      RemoteFactoryGirl.config = config
      RemoteFactoryGirl.reset(double('config'))
      expect(RemoteFactoryGirl.config).to_not equal(config)
    end
  end

  describe '.create' do
    it 'should send http request and parse request' do
      config = double('config', :home_url => 'http://somewhere', :to_hash => {})
      http   = double('RemoteFactoryGirlFriends::Http', :post => {})
      parser = double('RemoteFactoryGirlFriends::ResponseParser')
      RemoteFactoryGirl.config = config
      expect(http).to receive(:post).with(config, { :factory => 'user', :attributes => { :first_name => 'Sam'}})
      expect(parser).to receive(:parse).with(http.post, config.to_hash)
      RemoteFactoryGirl.create('user', { :first_name => 'Sam' }, parser, http)
    end
  end
end
