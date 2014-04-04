module RemoteFactoryGirl
  class JsonToActiveResource

    def self.convert(json, config)
      new(JSON.parse(json), {:with => config[:with]}).convert
    end

    attr_reader :config, :json

    def initialize(json, config = {})
      @json   = json
      @config = config
    end

    def convert
      raise 'ActiveResource not defined' if !defined?(ActiveResource)

      if resource_provided? 
        config[:with].find(id)
      else
        begin
          infer_resource.find(id)
        rescue
          raise 'Can not infer ActiveResource class'
        end
      end
    end

    private

    def infer_resource
      to_array.first.first.titleize.constantize
    end

    def resource_provided?
      config[:with]
    end

    def id
      to_array.last.last['id']
    end

    def to_array
      @to_arry ||= Array(json)
    end
  end
end
