require 'remote_factory_girl'

describe RemoteFactoryGirl do

  before { RemoteFactoryGirl.reset }

  describe 'configuration' do
    it 'should be configured with correct defaults' do
      expect(RemoteFactoryGirl.config.home).to eq({ :host      => nil,
                                                    :port      => nil,
                                                    :end_point => '/remote_factory_girl/home'})
      expect(RemoteFactoryGirl.config.return_response_as).to eq(:as_hash)
      expect(RemoteFactoryGirl.config.return_with_root).to be_true
      expect(RemoteFactoryGirl.config.return_as_active_resource).to be_false
      expect(RemoteFactoryGirl.config.https).to be_false
    end

    it 'should be able to configure with a block' do
      RemoteFactoryGirl.configure do |config|
        config.home = { host: 'tifton' }
      end
      expect(RemoteFactoryGirl.config.home[:host]).to eq('tifton')
    end

    it 'should be able to configure .home' do
      RemoteFactoryGirl.config.home[:host] = 'fun_guy'
      RemoteFactoryGirl.config.home[:port] = 3333
      RemoteFactoryGirl.config.home[:end_point] = '/down_home'
      expect(RemoteFactoryGirl.config.home[:host]).to eq('fun_guy')
      expect(RemoteFactoryGirl.config.home[:port]).to eq(3333)
      expect(RemoteFactoryGirl.config.home[:end_point]).to eq('/down_home')
    end

    it 'should be able to configure .return_response_as' do
      expect(RemoteFactoryGirl.config.return_response_as).to eq(:as_hash)
    end

    it 'should be able to configure .return_with_root' do
      RemoteFactoryGirl.config.return_with_root = false
      expect(RemoteFactoryGirl.config.return_with_root).to be_false
    end

    it 'should be able to configure .return_as_active_resource' do
      RemoteFactoryGirl.config.return_as_active_resource = true
      expect(RemoteFactoryGirl.config.return_as_active_resource).to be_true
    end

    it 'should be able to configure https' do
      RemoteFactoryGirl.config.https = true
      expect(RemoteFactoryGirl.config.https).to be_true
    end
  end

  describe 'errors' do
    it 'should raise RemoteFactoryGirlConfigError if .config.home[:host] is nil' do
      RemoteFactoryGirl.config.home[:host] = nil
      expect { RemoteFactoryGirl.create(:site) }.to raise_error(RemoteFactoryGirl::RemoteFactoryGirlConfigError)
    end

    it 'should raise RemoteFactoryGirlConfigError if .config.home[:end_point] is nil' do
      RemoteFactoryGirl.config.home[:end_point] = nil
      expect { RemoteFactoryGirl.create(:site) }.to raise_error(RemoteFactoryGirl::RemoteFactoryGirlConfigError)
    end
  end

  describe 'creating a remote factory' do

    before do
      RestClient.stub(:post).and_return('{"user": {"id": "1", "first_name": "Sam", "last_name": "Iam"}}')
      RestClient.stub(:get).and_return('["user", "user_admin"]')
    end

    describe '.factories' do

      before { RemoteFactoryGirl.config.home[:host] = 'localhost' }

      it 'should return all factories available' do
        expect(RemoteFactoryGirl.factories).to match_array(['user', 'user_admin'])
      end
    end

    describe '.create' do

      describe 'default .home' do

        before { RemoteFactoryGirl.config.home[:host] = 'localhost' }

        it 'should be able to create a factory' do
          user = RemoteFactoryGirl.create(:site)
          expect(user).to have_key('user')
        end

        it 'should not return root hash key when .return_with_root is false' do
          RemoteFactoryGirl.config.return_with_root = false
          user = RemoteFactoryGirl.create(:user)
          expect(user).to_not have_key('user')
        end

        it 'should not return an object that responds to dot notation' do
          RemoteFactoryGirl.config.return_response_as = :dot_notation
          user = RemoteFactoryGirl.create(:user)
          expect(user.first_name).to_not eq('Sam')
        end

        it 'should send a post request to home' do
          expect(RestClient).to receive(:post)
          RemoteFactoryGirl.create(:user, :first_name => 'Sam', :last_name => 'Iam')
        end
      end

      it 'should not return root hash key and should return an object that responds to dot notation' do
        RemoteFactoryGirl.configure do |config|
          config.home               = { :host => 'localhost' }
          config.return_response_as = :dot_notation
          config.return_with_root   = false
        end
        user = RemoteFactoryGirl.create(:user)
        expect(user.first_name).to eq('Sam')
      end

      describe 'when configured to return active_resource object' do

        class ActiveResource
          def self.find(id); end;
        end

        class User < ActiveResource; end

        before do
          RemoteFactoryGirl.configure do |config|
            config.home = { :host => 'localhost' }
            config.return_as_active_resource = true
          end
        end

        it 'should return an active resource object' do
          expect(ActiveResource).to receive(:find).with(1)
          RemoteFactoryGirl.create(:user).resource(User)
        end
      end
    end
  end
end
