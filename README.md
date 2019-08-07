Plug ForwardedPeer
=================

Very simple plug which reads `X-Forwarded-For` or `Forwarded` header according
to rfc7239 and fill `conn.remote_ip` with the root client ip.

## Installation

Add to your list of dependencies in mix.exs:

```
def deps do
  [
    {:plug_forwarded_peer, "~> 0.0.2"}
  ]
end
```

## Usage

In Phoenix:

```elixir
defmodule MyApp.Endpoint do
  use Phoenix.Endpoint, otp_app: :my_app

  ...

  plug PlugForwardedPeer
end
```

Or in plain elixir:

```elixir
defmodule MyPlug do
  use Plug.Builder
  plug PlugForwardedPeer
end
```
