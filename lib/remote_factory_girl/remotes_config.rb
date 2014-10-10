require 'remote_factory_girl/config'

module RemoteFactoryGirl
  class RemotesConfig

    attr_writer :current_remote
    attr_accessor :remotes

    DEFAULT_REMOTE_NAME = :default

    alias_method :to_hash, :remotes

    def initialize
      @remotes = {}
    end

    def current_remote
      @current_remote || default_remote_name
    end

    def default_remote_name
      DEFAULT_REMOTE_NAME
    end

    def reset(config = Config.new)
      self.current_remote = default_remote_name
      self.remotes        = { default_remote_name => config}
    end
  end
end
