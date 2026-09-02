module Api
  module V1
    class RoomsController < ApplicationController


      def index
        render json: current_user.rooms
      end

      def create
        room = current_user.rooms.new(room_params)
        room.active = true
        if room.save
          render json: room, status: :created
        else
          render json: { errors: room.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        room = current_user.rooms.find(params[:id])
        room.update(room_params)
        render json: room
      end

      def destroy
        room = current_user.rooms.find(params[:id])
        room.destroy
        render json: { message: "Sala eliminada" }
      end

      private

      def room_params
        params.permit(:name, :max_participants)
      end
    end
  end
end
