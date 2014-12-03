module RemoteFactoryGirl
  class JsonToActiveResource

    def self.convert(json, config = {})
      new(json, config)
    end

    attr_reader :config, :json

    alias_method :to_hash, :json

    def initialize(json, config = {})
      raise 'ActiveResource not defined' if !defined?(ActiveResource)
      @json   = json
      @config = config
    end

    def resource(resource)
      resource.find(id)
    end

    private

    def id
      hash = to_array.flatten.last
      (hash['id'] || hash[:id]).to_i
    end

    def to_array
      @to_arry ||= Array(json)
    end
  end
end
