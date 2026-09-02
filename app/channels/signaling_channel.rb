class SignalingChannel < ApplicationCable::Channel
  def subscribed
    # Suscriptor se une a un stream personal para recibir señalización
    stream_from "signaling_user_#{current_user.id}" if current_user
  end

  def unsubscribed
    # Handle user disconnect if needed
  end

  # Cliente envía una oferta SDP (WebRTC) a otro usuario
  def offer(data)
    target_id = data["target_id"]
    ActionCable.server.broadcast("signaling_user_#{target_id}", {
      type: "offer",
      from: current_user.id,
      sdp: data["sdp"]
    })
  end

  # Cliente envía respuesta SDP
  def answer(data)
    target_id = data["target_id"]
    ActionCable.server.broadcast("signaling_user_#{target_id}", {
      type: "answer",
      from: current_user.id,
      sdp: data["sdp"]
    })
  end

  # Intercambio de ICE candidates
  def ice_candidate(data)
    target_id = data["target_id"]
    ActionCable.server.broadcast("signaling_user_#{target_id}", {
      type: "ice_candidate",
      from: current_user.id,
      candidate: data["candidate"]
    })
  end

  # Iniciar llamada (ringing)
  def call_request(data)
    target_id = data["target_id"]
    ActionCable.server.broadcast("signaling_user_#{target_id}", {
      type: "call_request",
      from: current_user.id,
      from_name: current_user.name
    })
  end

  # Aceptar / rechazar / terminar llamada
  def call_response(data)
    target_id = data["target_id"]
    ActionCable.server.broadcast("signaling_user_#{target_id}", {
      type: "call_response",
      from: current_user.id,
      action: data["action"] # 'accept' | 'reject' | 'end'
    })
  end

  # Iniciar / unirse a sala (conferencia)
  def room_join(data)
    room_id = data["room_id"]
    ActionCable.server.broadcast("room_#{room_id}", {
      type: "room_join",
      from: current_user.id,
      from_name: current_user.name
    })
    stream_from "room_#{room_id}"
  end

  # Señalización dentro de una sala (conferencia multipunto)
  def room_signal(data)
    room_id = data["room_id"]
    ActionCable.server.broadcast("room_#{room_id}", {
      type: data["signal_type"],
      from: current_user.id,
      sdp: data["sdp"],
      candidate: data["candidate"],
      from_name: current_user.name
    })
  end

  def room_leave(data)
    room_id = data["room_id"]
    ActionCable.server.broadcast("room_#{room_id}", {
      type: "room_leave",
      from: current_user.id,
      from_name: current_user.name
    })
  end
end
