module Api
  module V1
    class DevicesController < ApplicationController


      def index
        render json: current_user.devices
      end

      def create
        device = current_user.devices.new(device_params)
        device.sip_address = "sip:#{current_user.id}@voip.local" unless device.sip_address.present?
        device.status = "online"
        device.last_seen_at = Time.current
        if device.save
          render json: device, status: :created
        else
          render json: { errors: device.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        device = current_user.devices.find(params[:id])
        device.update(device_params.merge(status: "online", last_seen_at: Time.current))
        render json: device
      end

      def destroy
        device = current_user.devices.find(params[:id])
        device.destroy
        render json: { message: "Dispositivo eliminado" }
      end

      private

      def device_params
        params.permit(:name, :ip_address, :sip_address)
      end
    end
  end
end
