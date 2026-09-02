module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    private

    def find_verified_user
      token = request.params[:token]
      if token.present?
        decoded = JWT.decode(token, jwt_secret, true, algorithm: "HS256")
        User.find(decoded[0]["user_id"])
      else
        reject_unauthorized_connection
      end
    rescue JWT::DecodeError, ActiveRecord::RecordNotFound
      reject_unauthorized_connection
    end

    def jwt_secret
      ENV.fetch("JWT_SECRET") { Rails.application.secret_key_base }
    end
  end
end
