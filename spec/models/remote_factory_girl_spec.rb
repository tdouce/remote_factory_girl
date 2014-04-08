require 'remote_factory_girl'

describe RemoteFactoryGirl do

  let(:config) { double('config', :to_hash => {}) }

  it 'should return params for http request' do
    rfg = RemoteFactoryGirl::RemoteFactoryGirl.new('user', { :first_name => 'Sam' }, config)
    expect(rfg.params).to eq(
      { :factory => 'user', :attributes => { :first_name => 'Sam'}}
    )
  end

  describe '#post' do
    it 'should send a post request' do
      http       = double('RemoteFactoryGirl::Http')
      attributes = { :first_name => 'Sam' }
      expect(http).to receive(:post).with(config, {:factory => 'user', :attributes => { :first_name => 'Sam'}})
      RemoteFactoryGirl::RemoteFactoryGirl.new('user', attributes, config).post(http)
    end
  end

  describe '#parse' do
    it 'should parse json with supplied configuration' do
      attributes = { :first_name => 'Sam' }
      parser = double('RemoteFactoryGirl::ResponseParser')
      post = double('RemoteFactoryGirl::Http', :json => {})
      RemoteFactoryGirl::Http.stub(:post).and_return(post)
      expect(parser).to receive(:parse).with(post.json, config.to_hash)
      RemoteFactoryGirl::RemoteFactoryGirl.new('user', attributes, config).parse(parser)
    end
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
    describe 'when not returning active resource object' do
      pending
    end

    describe 'when returning active resource object' do
      pending
    end
  end
end
