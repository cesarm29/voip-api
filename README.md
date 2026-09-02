# VoIP API (Rails 8.1)

API gratuita de voz IP (VoIP) construida con Ruby on Rails 8.1 usando WebRTC con señalización vía ActionCable, más endpoints REST para usuarios, dispositivos, llamadas y salas de conferencia. Es 100% gratis: WebRTC no requiere servicios de pago, solo usa servidores STUN públicos.

## Características

- **WebRTC** para transmisión de audio/voz peer-to-peer (sin costo por minuto).
- **Señalización en tiempo real** con ActionCable (canal `SignalingChannel`): ofertas SDP, respuestas, ICE candidates, solicitudes de llamada, conferencias en sala.
- **Autenticación JWT** con `has_secure_password` (bcrypt).
- **Configuración ICE (STUN/TURN)** servida por un endpoint.
- **Modelos**: `User`, `Device`, `Call`, `Room`, `CallLog`.
- CORS habilitado para clientes web/JavaScript.
- PostgreSQL como base de datos.

## Requisitos

- Ruby 4.0+
- Rails 8.1+
- Bundler
- PostgreSQL (local)

## Instalación

```bash
bundle install
cp .env.example .env   # edita DB_PASSWORD y genera secretos
rails db:create db:migrate
rails server
```

Variables de entorno (ver `.env.example`):

| Variable | Descripción |
|----------|-------------|
| `DB_HOST` | Host de PostgreSQL (default `localhost`) |
| `DB_USERNAME` | Usuario de PostgreSQL (default `postgres`) |
| `DB_PASSWORD` | Contraseña de PostgreSQL |
| `DB_PORT` | Puerto (default `5432`) |
| `JWT_SECRET` | Secreto para firmar tokens JWT |
| `TURN_URL` / `TURN_USERNAME` / `TURN_CREDENTIAL` | (Opcional) Servidor TURN para soporte NAT manual |

## Endpoints

### Autenticación
| Método | Ruta | Descripción |
|--------|------|-------------|
| POST | `/api/v1/auth/register` | Registrar usuario (`email`, `password`, `name`) |
| POST | `/api/v1/auth/login` | Iniciar sesión, devuelve `token` JWT |
| POST | `/api/v1/auth/logout` | Cerrar sesión |
| GET | `/api/v1/auth/profile` | Perfil del usuario autenticado |

### Recursos
| Método | Ruta | Descripción |
|--------|------|-------------|
| GET/POST | `/api/v1/devices` | Listar / crear dispositivos SIP |
| PATCH/DELETE | `/api/v1/devices/:id` | Actualizar / eliminar dispositivo |
| GET/POST | `/api/v1/calls` | Listar / crear llamadas |
| PATCH | `/api/v1/calls/:id` | Aceptar / rechazar / terminar llamada |
| GET/POST | `/api/v1/rooms` | Listar / crear salas de conferencia |
| PATCH/DELETE | `/api/v1/rooms/:id` | Actualizar / eliminar sala |
| GET | `/api/v1/ice-config` | Configuración ICE (STUN/TURN) para WebRTC |

Todos los endpoints (excepto `register`/`login`) requieren el header:

```
Authorization: Bearer <tu_token_jwt>
```

## WebRTC / Señalización (ActionCable)

Conecta el cliente al WebSocket con el token:

```
ws://localhost:3000/cable?token=<jwt>
```

Luego suscríbete al canal `SignalingChannel`. Acciones soportadas:

- `offer` / `answer` — intercambio de SDP (WebRTC).
- `ice_candidate` — intercambio de candidatos ICE.
- `call_request` / `call_response` — iniciar, aceptar, rechazar o terminar una llamada.
- `room_join` / `room_signal` / `room_leave` — conferencias multipunto por sala.

Cada usuario escucha en el stream `signaling_user_<user_id>`; las salas usan `room_<room_id>`.

## Stack técnico

- Ruby on Rails 8.1 (modo API)
- ActionCable (WebSocket / señalización)
- JWT + bcrypt (auth)
- PostgreSQL
- rack-cors
- dotenv-rails

## Licencia

MIT