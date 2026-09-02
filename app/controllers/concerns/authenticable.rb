module Authenticable
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_request
  end

  private

  def authenticate_request
    token = request.headers["Authorization"]&.split(" ")&.last
    if token.blank?
      render json: { error: "Token requerido" }, status: :unauthorized
      return
    end

    begin
      decoded = JWT.decode(token, jwt_secret, true, algorithm: "HS256")
      @current_user = User.find(decoded[0]["user_id"])
    rescue JWT::DecodeError, ActiveRecord::RecordNotFound
      render json: { error: "Token inválido" }, status: :unauthorized
    end
  end

  def current_user
    @current_user
  end

  def jwt_secret
    ENV.fetch("JWT_SECRET") { Rails.application.secret_key_base }
  end
end
