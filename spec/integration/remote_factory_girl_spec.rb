require 'remote_factory_girl'

describe RemoteFactoryGirl do

  before { RemoteFactoryGirl.reset }

  describe 'configuration' do
    it 'should be configured with correct defaults' do
      expect(RemoteFactoryGirl.config.home).to eq({ :host      => nil, 
                                                    :port      => nil, 
                                                    :end_point => '/remote_factory_girl_homes'})
      expect(RemoteFactoryGirl.config.return_response_as).to eq(:as_hash) 
      expect(RemoteFactoryGirl.config.return_with_root).to be_true 
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
      RemoteFactoryGirl::Http.stub(:post).and_return(
          '{ "user": {"first_name": "Sam",
                      "last_name": "Iam"}}'
        )
    end

    describe '.create' do
      it 'should be able to create a factory' do
        RemoteFactoryGirl.config.home[:host] = 'localhost'
        user = RemoteFactoryGirl.create(:site)
        expect(user).to have_key('user') 
      end

      it 'should not return root hash key when .return_with_root is false' do
        RemoteFactoryGirl.config.home[:host] = 'localhost'
        RemoteFactoryGirl.config.return_with_root = false
        user = RemoteFactoryGirl.create(:user)
        expect(user).to_not have_key('user') 
      end

      it 'should not return an object that responds to dot notation' do
        RemoteFactoryGirl.config.home[:host] = 'localhost'
        RemoteFactoryGirl.config.return_response_as = :dot_notation
        user = RemoteFactoryGirl.create(:user)
        expect(user.first_name).to_not eq('Sam') 
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

      it 'should send a post request to home' do
        RemoteFactoryGirl.config.home[:host] = 'localhost'
        config = RemoteFactoryGirl.config
        params = { :factory    => :user, 
                   :attributes => { :first_name => 'Sam', :last_name => 'Iam' } }
        expect(RemoteFactoryGirl::Http).to receive(:post).with(config, params) 
        RemoteFactoryGirl.create(:user, :first_name => 'Sam', :last_name => 'Iam')
      end
    end
  end
end
