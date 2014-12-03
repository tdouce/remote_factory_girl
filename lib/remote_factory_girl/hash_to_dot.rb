require 'dish'

module RemoteFactoryGirl
  class HashToDot
    def self.convert(json)
      Dish(json)
    end
  end
end
