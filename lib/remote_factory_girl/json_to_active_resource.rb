module RemoteFactoryGirl
  class JsonToActiveResource

    #def self.convert(json, resource = nil)
    #  new(json, {:with => opts[:resource]})
    #end

    attr_reader :config, :json

    def initialize(json, config = {})
      @json   = json
      @config = config
    end

    def resource(resource = nil) 
      raise 'ActiveResource not defined' if !defined?(ActiveResource)

      if resource
        resource.find(id)
      else
        begin
          infer_resource.find(id)
        rescue
          raise 'Can not infer ActiveResource class'
        end
      end
    end

    #TODO alias method?
    def to_hash
      json
    end

    private

    def infer_resource
      to_array.first.first.titleize.constantize
    end

    def id
      to_array.last.last['id']
    end

    def to_array
      @to_arry ||= Array(json)
    end
  end
end
