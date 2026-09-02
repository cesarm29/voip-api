module Api
  module V1
    class CallsController < ApplicationController


      def index
        calls = Call.where(caller: current_user).or(Call.where(callee: current_user))
        render json: calls.map { |c| call_response(c) }
      end

      def create
        call = Call.new(
          caller: current_user,
          callee: find_callee,
          status: "pending",
          started_at: Time.current
        )
        if call.save
          render json: call_response(call), status: :created
        else
          render json: { errors: call.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        call = Call.find(params[:id])
        action = params[:action_name]
        case action
        when "accept"
          call.update(status: "active", started_at: Time.current)
        when "reject", "end"
          call.update(status: action == "end" ? "ended" : "failed", ended_at: Time.current, duration: duration(call))
        else
          return render json: { error: "Acción inválida" }, status: :unprocessable_entity
        end
        render json: call_response(call)
      end

      private

      def find_callee
        if params[:callee_id].present?
          User.find(params[:callee_id])
        elsif params[:room_id].present?
          Room.find(params[:room_id])
        else
          raise ActiveRecord::RecordNotFound
        end
      end

      def duration(call)
        ((Time.current - call.started_at) / 60).round if call.started_at
      end

      def call_response(call)
        {
          id: call.id,
          caller_id: call.caller_id,
          caller_type: call.caller_type,
          callee_id: call.callee_id,
          callee_type: call.callee_type,
          status: call.status,
          started_at: call.started_at,
          ended_at: call.ended_at,
          duration: call.duration
        }
      end
    end
  end
end
