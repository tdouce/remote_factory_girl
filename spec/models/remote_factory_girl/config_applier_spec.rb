require 'remote_factory_girl/config_applier'
require 'remote_factory_girl/json_to_active_resource'
require 'ostruct'

describe RemoteFactoryGirl::ConfigApplier do

  describe '.post' do
    let(:json) {
      { user: { first_name: "Sam", last_name: "Iam"}}
    }
    let(:hash_to_dot_klass)      { double('RemoteFactoryGirl::HashToDot') }
    let(:dish_json_with_user)    { OpenStruct.new(user: OpenStruct.new(first_name: 'Sam', last_name: 'Iam')) }
    let(:dot_notation_without_root) { OpenStruct.new(first_name: 'Sam', last_name: 'Iam') }

    describe '.apply_config' do
      describe 'when configured to return root key' do
        it 'should return a hash with a root key when initialized with a hash that has a root key' do
          response = RemoteFactoryGirl::ConfigApplier.apply_config(json, with_root: true)

          expect(response).to have_key(:user)
        end
      end

      describe 'when configured to not return root key' do

        let(:factory_girl_json_parser) { double('RemoteFactoryGirl::FactoryGirlJsonParser', without_root: { first_name: 'Sam', last_name: 'Iam'}) }

        it 'should not return a hash with a root key when initialized with a hash that has a root key' do
          response = RemoteFactoryGirl::ConfigApplier.apply_config(json, return_with_root: false,
                                                                         factory_girl_json_parser: factory_girl_json_parser)

          expect(response).to_not have_key(:user)
          expect(response[:first_name]).to eq('Sam')
        end

        it 'should not return a hash with a root key when initialized with a hash that does not have a root key' do
          hash_without_root_key = { first_name: 'Sam', last_name: 'Iam'}
          response              = RemoteFactoryGirl::ConfigApplier.apply_config(hash_without_root_key, return_with_root: false,
                                                                                                       factory_girl_json_parser: factory_girl_json_parser)
          expect(response[:first_name]).to eq('Sam')
        end
      end

      it 'should return an object that responds to dot notation' do
        allow(hash_to_dot_klass).to receive(:convert).and_return(dish_json_with_user)
        response = RemoteFactoryGirl::ConfigApplier.apply_config(json, return_response_as:  :dot_notation,
                                                                       hash_to_dot_klass:   hash_to_dot_klass)
        expect(response.user.first_name).to eq('Sam')
      end

      it 'should not return root hash key and should return an object that responds to dot notation' do
        factory_girl_json_parser = double('RemoteFactoryGirl::FactoryGirlJsonParser', without_root: { first_name: 'Sam', last_name: 'Iam'})
        allow(hash_to_dot_klass).to receive(:convert).and_return(dot_notation_without_root)
        response = RemoteFactoryGirl::ConfigApplier.apply_config(json, return_response_as: :dot_notation,
                                                                       return_with_root:   false,
                                                                       hash_to_dot_klass:  hash_to_dot_klass,
                                                                       factory_girl_json_parser: factory_girl_json_parser)
        expect(response.first_name).to eq('Sam')
      end
    end

    describe 'when configured to return active resource objects' do
      it 'should return an active resource object' do
        json_to_active_resource_klass = double('RemoteFactoryGirl::JsonToActiveResource')
        expect(json_to_active_resource_klass).to receive(:convert).with(json)
        RemoteFactoryGirl::ConfigApplier.apply_config(json, return_as_active_resource:     true,
                                                            json_to_active_resource_klass: json_to_active_resource_klass)
      end
    end
  end
end
