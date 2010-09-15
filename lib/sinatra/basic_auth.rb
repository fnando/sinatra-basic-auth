require "sinatra/base"

module Sinatra
  module BasicAuth
    REALM_ENV = "REALM:%s"

    class << self
      attr_accessor :validators
    end

    self.validators = {}

    module Helpers
      def auth
        @auth ||= Rack::Auth::Basic::Request.new(request.env)
      end

      def authorized?
        request.env[REALM_ENV % realm] != nil
      end

      def realm
        @realm
      end

      private
      def valid_credentials?
        validator = Sinatra::BasicAuth.validators[realm]
        validator && validator.call(*auth.credentials)
      end
    end

    def authorize(realm = "Restricted", &block)
      Sinatra::BasicAuth.validators[realm] = block
    end

    def protect(_realm = "Restricted", &block)
      condition do
        @realm = _realm

        catch(:request_authorization) {
          unless authorized?
            if auth.provided? && auth.basic? && valid_credentials?
              request.env[REALM_ENV % realm] = auth.credentials.first
            else
              headers "WWW-Authenticate" => %[Basic realm="#{realm}"]
              throw :halt, [ 401, "Authorization Required" ]
            end

            throw :request_authorization unless authorized?
          end
        }

        authorized?
      end

      yield
    end

    def self.registered(app)
      app.helpers Sinatra::BasicAuth::Helpers
    end
  end

  register BasicAuth
end
