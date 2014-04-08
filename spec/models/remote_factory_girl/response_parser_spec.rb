require 'remote_factory_girl/response_parser'
require 'remote_factory_girl/json_to_active_resource'

describe RemoteFactoryGirl::ResponseParser do

  describe '.post' do

    let(:unparsed_json) {
      '{ "user": {"first_name": "Sam", "last_name": "Iam"}}'
      }
    let(:json) {  
      { :user => { :first_name => "Sam", :last_name => "Iam"}}
    }
    let(:hash_to_dot_klass)      { double('RemoteFactoryGirl::HashToDot') }
    let(:dish_json_with_user)    { OpenStruct.new(:user => OpenStruct.new(:first_name => 'Sam', :last_name => 'Iam')) }
    let(:dish_json_without_user) { OpenStruct.new(:first_name => 'Sam', :last_name => 'Iam') }

    describe '.parse' do
      it 'should not return root hash key when .return_with_root is false' do
        response = RemoteFactoryGirl::ResponseParser.parse(json, :return_with_root => false)
        expect(response).to_not have_key(:user) 
      end

      it 'should not return root hash key when .return_with_root is false' do
        response = RemoteFactoryGirl::ResponseParser.parse(json, :with_root => true)
        expect(response).to have_key(:user)
      end

      it 'should return an object that responds to dot notation' do
        hash_to_dot_klass.stub(:convert).and_return(dish_json_with_user)
        response = RemoteFactoryGirl::ResponseParser.parse(json, :return_response_as  => :dot_notation,
                                                                 :hash_to_dot_klass   => hash_to_dot_klass)
        expect(response.user.first_name).to eq('Sam') 
      end

      it 'should not return root hash key and should return an object that responds to dot notation' do
        hash_to_dot_klass.stub(:convert).and_return(dish_json_without_user)
        response = RemoteFactoryGirl::ResponseParser.parse(json, :return_response_as => :dot_notation, 
                                                                 :return_with_root   => false,
                                                                 :hash_to_dot_klass  => hash_to_dot_klass)
        expect(response.first_name).to eq('Sam') 
      end
    end

    describe 'when configured to return active resource objects' do
      it 'should return an active resource object' do
        json_to_active_resource_klass = double('RemoteFactoryGirl::JsonToActiveResource')
        expect(json_to_active_resource_klass).to receive(:convert).with(json)
        RemoteFactoryGirl::ResponseParser.parse(json, :return_as_active_resource     => true, 
                                                      :json_to_active_resource_klass => json_to_active_resource_klass)
      end
    end
  end
end
