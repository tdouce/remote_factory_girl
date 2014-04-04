require 'remote_factory_girl/exceptions'
require 'virtus'

module RemoteFactoryGirl
  class Config
    include Virtus.model

    DEFAULT_HOME_CONFIG = { :host      => nil, 
                            :port      => nil, 
                            :end_point => '/remote_factory_girl/home' }

    attribute :home,               Hash,    :default => DEFAULT_HOME_CONFIG
    attribute :return_response_as, Symbol,  :default => :as_hash 
    attribute :return_with_root,   Boolean, :default => true 

    def self.configure(configs)
      new(configs)
    end

    def initialize(attrs = {})
      attrs[:home] = update_home_config(attrs)
      super(attrs)
    end

    def home_url
      raise_no_host_error
      http = 'http://'
      if home[:port]
        "#{ http }#{ home.fetch(:host) }:#{ home.fetch(:port) }#{ home.fetch(:end_point) }"
      else
        "#{ http }#{ home.fetch(:host) }#{ home.fetch(:end_point) }"
      end
    end

    def to_hash
      raise_no_host_error
      super.merge(home_url: home_url)
    end

    def raise_no_host_error
      raise RemoteFactoryGirlConfigError.new("RemoteFactoryGirl.config.home[:host] can not be nil") unless has_home?
    end

    def has_home?
      !home[:host].nil? && !(home[:host] == '') && !home[:end_point].nil? && !(home[:end_point] == '')
    end

    private

    def update_home_config(attrs)
      attrs[:home] = DEFAULT_HOME_CONFIG.merge(attrs.fetch(:home, {}))
    end
  end
end
