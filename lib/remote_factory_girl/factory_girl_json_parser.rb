module RemoteFactoryGirl
  class FactoryGirlJsonParser

    def self.without_root(response_hash)
      new(response_hash).without_root
    end

    attr_reader :response_hash

    def initialize(response_hash)
      @response_hash = response_hash
    end

    def without_root
      has_root_key? ? response_array.last : response_hash
    end

    private

    def has_root_key?
      response_array.length == 2 && response_array.last.is_a?(Hash)
    end

    def response_array
      @response_array ||= Array(response_hash).flatten
    end
  end
end

