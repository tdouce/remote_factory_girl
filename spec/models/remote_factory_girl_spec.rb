require 'remote_factory_girl'

describe RemoteFactoryGirl do
  describe '#create' do

    let(:http) { double('RemoteFactoryGirl::Http') }
    let(:factory_attributes) { { :first_name => 'Sam' } }

    context 'when remote configuration does not specify a remote name' do

      before do
        RemoteFactoryGirl.configure do |config|
          config.home = {:host      => 'localhost',
                         :port      => 3000,
                         :end_point => '/remote_factory_girl/home' }
        end
      end

      it "should send a post request to remote" do
        config     = RemoteFactoryGirl.config
        expect(http).to receive(:post).with(config, {:factory => :user, :attributes => factory_attributes})
        RemoteFactoryGirl::RemoteFactoryGirl.new(config).create(:user, factory_attributes, http)
      end
    end

    context 'when multiple remotes are configured' do
      before do
        RemoteFactoryGirl.configure(:travis) do |config|
          config.home = {:host      => 'localhost',
                         :port      => 3000,
                         :end_point => '/remote_factory_girl/travis/home' }
        end

        RemoteFactoryGirl.configure(:casey) do |config|
          config.home = {:host      => 'over_the_rainbow',
                         :port      => 6000,
                         :end_point => '/remote_factory_girl/casey/home' }
        end
      end

      it "should be configured to send HTTP requests to 'travis' remote" do
        remote_config_travis = RemoteFactoryGirl.config(:travis)
        remote_factory_girl  = RemoteFactoryGirl::RemoteFactoryGirl.new(remote_config_travis)

        expect(remote_factory_girl).to receive(:create).with(:user, factory_attributes, http) do |_, _, _|
          expect(
            remote_factory_girl.config.home_url
          ).to eq('http://localhost:3000/remote_factory_girl/travis/home')
        end

        remote_factory_girl.create(:user, factory_attributes, http)
      end

      it "should be configured to send HTTP requests to 'casey' remote" do
        remote_config_casey = RemoteFactoryGirl.config(:casey)
        remote_factory_girl = RemoteFactoryGirl::RemoteFactoryGirl.new(remote_config_casey)

        expect(remote_factory_girl).to receive(:create).with(:user, factory_attributes, http) do |_, _, _|
          expect(
            remote_factory_girl.config.home_url
          ).to eq('http://over_the_rainbow:6000/remote_factory_girl/casey/home')
        end

        remote_factory_girl.create(:user, factory_attributes, http)
      end
    end
  end

  xit 'should be able to configure with a block' do
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
    context 'when multiple remotes are configured' do

      before do
        RemoteFactoryGirl.configure(:travis) do |config|
          config.home = {:host      => 'localhost',
                         :port      => 3000,
                         :end_point => '/remote_factory_girl/travis/home' }
        end

        RemoteFactoryGirl.configure(:casey) do |config|
          config.home = {:host      => 'over_the_rainbow',
                         :port      => 6000,
                         :end_point => '/remote_factory_girl/casey/home' }
        end
      end

      it 'should be able to reset the configuration' do
        RemoteFactoryGirl.remotes_config.reset
        expect(RemoteFactoryGirl.remotes_config.to_hash.keys).to eq([:default])
      end
    end

    context 'when only one remote configuration and does not specify a remote name' do
      before do
        RemoteFactoryGirl.configure do |config|
          config.home               = {:host => 'not_configured_with_name',
                                       :port => 9000,
                                       :end_point => '/remote_factory_girl/home' }
          config.return_response_as = :dot_notation
          config.return_with_root   = false
        end
      end

      it 'should be able to reset the configuration' do
        RemoteFactoryGirl.remotes_config.reset
        expect(RemoteFactoryGirl.remotes_config.to_hash.keys).to eq([:default])
      end
    end
  end

  describe '.factories' do
    context 'when multiple remotes are configured' do

      let(:http) { double('RemoteFactoryGirl::Http') }

      before do
        RemoteFactoryGirl.configure(:travis) do |config|
          config.home = {:host      => 'localhost',
                         :port      => 3000,
                         :end_point => '/remote_factory_girl/travis/home' }
        end

        RemoteFactoryGirl.configure(:casey) do |config|
          config.home = {:host      => 'over_the_rainbow',
                         :port      => 6000,
                         :end_point => '/remote_factory_girl/casey/home' }
        end
      end

      it "should be configured to send HTTP requests to 'travis' remote" do
        remote_config_travis = RemoteFactoryGirl.config(:travis)
        remote_factory_girl  = RemoteFactoryGirl::RemoteFactoryGirl.new(remote_config_travis)

        expect(remote_factory_girl).to receive(:factories).with({}, http) do |_, _|
          expect(
            remote_factory_girl.config.home_url
          ).to eq('http://localhost:3000/remote_factory_girl/travis/home')
        end

        remote_factory_girl.factories({}, http)
      end

      it "should be configured to send HTTP requests to 'casey' remote" do
        remote_config_casey = RemoteFactoryGirl.config(:casey)
        remote_factory_girl = RemoteFactoryGirl::RemoteFactoryGirl.new(remote_config_casey)

        expect(remote_factory_girl).to receive(:factories).with({}, http) do |_, _|
          expect(
            remote_factory_girl.config.home_url
          ).to eq('http://over_the_rainbow:6000/remote_factory_girl/casey/home')
        end

        remote_factory_girl.factories({}, http)
      end
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
