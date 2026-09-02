module Api
  module V1
    class AuthController < ApplicationController
      skip_before_action :authenticate_request, only: [:login, :register]

      def register
        user = User.new(register_params)
        if user.save
          token = encode_token(user)
          render json: { user: user_response(user), token: token }, status: :created
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def login
        user = User.find_by(email: params[:email])
        if user&.authenticate(params[:password])
          user.update(status: "online")
          token = encode_token(user)
          render json: { user: user_response(user), token: token }
        else
          render json: { error: "Credenciales inválidas" }, status: :unauthorized
        end
      end

      def logout
        current_user.update(status: "offline")
        render json: { message: "Sesión cerrada" }
      end

      def profile
        render json: user_response(current_user)
      end

      private

      def register_params
        params.permit(:email, :password, :name)
      end

      def encode_token(user)
        payload = { user_id: user.id, exp: 24.hours.from_now.to_i }
        JWT.encode(payload, jwt_secret, "HS256")
      end

      def user_response(user)
        { id: user.id, email: user.email, name: user.name, role: user.role, status: user.status }
      end
    end
  end
end
