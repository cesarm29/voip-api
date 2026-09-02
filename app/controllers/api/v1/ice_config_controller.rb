module Api
  module V1
    class IceConfigController < ApplicationController


      # Devuelve la configuración ICE (STUN/TURN) para WebRTC
      def show
        render json: {
          iceServers: [
            { urls: "stun:stun.l.google.com:19302" },
            { urls: "stun:stun1.l.google.com:19302" }
          ] + turn_servers
        }
      end

      private

      def turn_servers
        # Si configuras credenciales TURN en env, se incluyen
        if ENV["TURN_URL"].present?
          [{ urls: ENV["TURN_URL"], username: ENV["TURN_USERNAME"], credential: ENV["TURN_CREDENTIAL"] }]
        else
          []
        end
      end
    end
  end
end
