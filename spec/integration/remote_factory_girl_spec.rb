require 'remote_factory_girl'
require 'spec_helper'

describe RemoteFactoryGirl do

  before { RemoteFactoryGirl.remotes_config.reset }

  describe 'configuration' do
    it 'should be configured with correct defaults' do
      expect(RemoteFactoryGirl.config.home).to eq({ :host      => nil,
                                                    :port      => nil,
                                                    :end_point => '/remote_factory_girl/home'})
      expect(RemoteFactoryGirl.config.return_response_as).to eq(:as_hash)
      expect(RemoteFactoryGirl.config.return_with_root).to eq true
      expect(RemoteFactoryGirl.config.return_as_active_resource).to eq false
      expect(RemoteFactoryGirl.config.https).to eq false
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
      expect(RemoteFactoryGirl.config.return_with_root).to eq false
    end

    it 'should be able to configure .return_as_active_resource' do
      RemoteFactoryGirl.config.return_as_active_resource = true
      expect(RemoteFactoryGirl.config.return_as_active_resource).to eq true
    end

    it 'should be able to configure https' do
      RemoteFactoryGirl.config.https = true
      expect(RemoteFactoryGirl.config.https).to eq true
    end

    context 'when configuring multiple remotes' do

      before do
        configure_remote_factory_girl(remote_name: :travis,
                                      host: 'localhost',
                                      port: 3000,
                                      end_point: '/remote_factory_girl/travis/home')
        configure_remote_factory_girl(remote_name: :casey,
                                      host: 'over_the_rainbow',
                                      port: 6000,
                                      end_point: '/remote_factory_girl/casey/home')
      end

      it 'should return configuration for remote "travis"' do
        expect(RemoteFactoryGirl.config(:travis).home).to eq({:host      => 'localhost',
                                                              :port      => 3000,
                                                              :end_point => '/remote_factory_girl/travis/home'})
        expect(RemoteFactoryGirl.config(:travis).return_with_root).to eq(true)
        expect(RemoteFactoryGirl.config(:travis).return_response_as).to eq(:as_hash)
      end

      it 'should return configuration for remote "casey"' do
        expect(RemoteFactoryGirl.config(:casey).home).to eq({:host      => 'over_the_rainbow',
                                                             :port      => 6000,
                                                             :end_point => '/remote_factory_girl/casey/home'})
      end
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
      allow(RestClient).to receive(:post).and_return('{"user": {"id": "1", "first_name": "Sam", "last_name": "Iam"}}')
      allow(RestClient).to receive(:get).and_return('["user", "user_admin"]')
    end

    describe '.factories' do
      context 'when multiple remotes are configured' do

        before do
          configure_remote_factory_girl(remote_name: :travis,
                                        host: 'localhost',
                                        port: 3000,
                                        end_point: '/remote_factory_girl/travis/home')
          configure_remote_factory_girl(remote_name: :casey,
                                        host: 'over_the_rainbow',
                                        port: 6000,
                                        end_point: '/remote_factory_girl/casey/home')
        end

        context 'for remote "travis"' do
          it 'should return all factories available' do
            expect(RemoteFactoryGirl.with_remote(:travis).factories).to match_array(['user', 'user_admin'])
          end

          it 'should be configured to send HTTP request to remote "travis"' do
            remote_factory_girl = RemoteFactoryGirl.with_remote(:travis)

            expect(remote_factory_girl).to receive(:factories) do
              expect(
                remote_factory_girl.remotes_config.current_remote
              ).to eq(:travis)
              expect(
                remote_factory_girl.config(:travis).home_url
              ).to eq('http://localhost:3000/remote_factory_girl/travis/home')
            end
            remote_factory_girl.factories
          end
        end

        context 'for remote "casey"' do
          it 'should return all factories available' do
            expect(RemoteFactoryGirl.with_remote(:casey).factories).to match_array(['user', 'user_admin'])
          end

          it 'should be configured to send HTTP request to remote "casey"' do
            remote_factory_girl = RemoteFactoryGirl.with_remote(:casey)

            expect(remote_factory_girl).to receive(:factories) do
              expect(
                remote_factory_girl.remotes_config.current_remote
              ).to eq(:casey)
              expect(
                remote_factory_girl.config(:casey).home_url
              ).to eq('http://over_the_rainbow:6000/remote_factory_girl/casey/home')
            end
            remote_factory_girl.factories
          end
        end
      end

      context 'when configured with remote "default"' do

        before do
          configure_remote_factory_girl(host: 'not_configured_with_name',
                                        port: 9000)
        end

        it 'should return all factories available' do
          expect(RemoteFactoryGirl.factories).to match_array(['user', 'user_admin'])
        end

        it 'should be configured to send HTTP request to remote "default"' do
          remote_factory_girl = RemoteFactoryGirl

          expect(remote_factory_girl).to receive(:factories) do
            expect(
              remote_factory_girl.remotes_config.current_remote
            ).to eq(:default)
            expect(
              remote_factory_girl.config.home_url
            ).to eq('http://not_configured_with_name:9000/remote_factory_girl/home')
          end
          remote_factory_girl.factories
        end
      end
    end

    describe '.create' do
      context 'when configured with multiple remotes' do
        before do
          configure_remote_factory_girl(remote_name: :travis,
                                        host: 'localhost',
                                        port: 3000,
                                        end_point: '/remote_factory_girl/travis/home',
                                        return_with_root: false)
          configure_remote_factory_girl(remote_name: :casey,
                                        host: 'over_the_rainbow',
                                        port: 6000,
                                        end_point: '/remote_factory_girl/casey/home',
                                        return_response_as: :dot_notation,
                                        return_with_root: false)

        end

        it 'should be able to create a factory with "travis" remote' do
          user = RemoteFactoryGirl.with_remote(:travis).create(:user)
          expect(user['first_name']).to eq('Sam')
        end

        it 'should be able to create a factory with "casey" remote' do
          user = RemoteFactoryGirl.with_remote(:casey).create(:user)
          expect(user.first_name).to eq('Sam')
        end
      end

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
        configure_remote_factory_girl(host: 'localhost',
                                      port: 3000,
                                      return_response_as: :dot_notation,
                                      return_with_root: false)
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
