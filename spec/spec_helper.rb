require 'rubygems'
require 'bundler/setup'
# our gem
require 'remote_factory_girl'

RSpec.configure do |config|

end

def configure_remote_factory_girl(remote_name: nil,
                                  host: nil, 
                                  port: nil, 
                                  end_point: '/remote_factory_girl/home',
                                  return_response_as: :as_hash, 
                                  return_with_root: true,
                                  return_as_active_resource: false,
                                  https: false)
  if remote_name.nil?
    RemoteFactoryGirl.configure do |config|
        config.home                     = {:host      => host,
                                           :port      => port,
                                           :end_point => end_point }
        config.return_response_as        = return_response_as
        config.return_with_root          = return_with_root
        config.return_as_active_resource = return_as_active_resource
        config.https                     = https
    end

  else
    RemoteFactoryGirl.configure(remote_name) do |config|
        config.home                     = {:host      => host,
                                           :port      => port,
                                           :end_point => end_point }
        config.return_response_as        = return_response_as
        config.return_with_root          = return_with_root
        config.return_as_active_resource = return_as_active_resource
        config.https                     = https
    end
  end
end
