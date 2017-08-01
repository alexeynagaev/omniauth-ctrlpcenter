require "omniauth/ctrlpcenter/version"
require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Ctrlpcenter < OmniAuth::Strategies::OAuth2
      # change the class name and the :name option to match your application name
      option :name, :ctrlpcenter

      option :client_options, {
        :site => "https://auth.ctrl-p.center",
        :authorize_url => "/oauth/authorize"
      }

      uid { raw_info["id"] }

      info do
        {
          :email => raw_info["email"],
          :name => raw_profile["name"],
          :surname => raw_profile["surname"],
          :patronymic => raw_profile["patronymic"]
          # and anything else you want to return to your API consumers
        }
      end

      def raw_info
        @raw_info ||= access_token.get('/api/v1/me.json').parsed
      end
      def raw_profile
        @raw_profile ||= access_token.get('/api/v1/mepro.json').parsed
      end

      # https://github.com/intridea/omniauth-oauth2/issues/81
      def callback_url
        full_host + script_name + callback_path
      end
    end
  end
end
