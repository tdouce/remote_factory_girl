require 'remote_factory_girl/factory_girl_json_parser'

describe RemoteFactoryGirl::FactoryGirlJsonParser do

  let(:hash_with_root)    { { user: { first_name: 'Sam', last_name: 'Iam' }} }
  let(:hash_without_root) { { first_name: 'Sam', last_name: 'Iam' } }

  describe '.without_root' do
    it 'should return a hash without a root key when given a hash with a root key' do
      without_root = RemoteFactoryGirl::FactoryGirlJsonParser.without_root(hash_with_root)

      expect(without_root).to_not have_key(:user)
      expect(without_root[:first_name]).to eq('Sam')
    end

    it 'should return a hash without a root key when given a hash without a root key' do
      without_root = RemoteFactoryGirl::FactoryGirlJsonParser.without_root(hash_with_root)

      expect(without_root).to_not have_key('user')
    end
  end
end
