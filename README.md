Plug ForwardedPeer
=================

Very simple plug which reads `X-Forwarded-For` or `Forwarded` header according
to rfc7239 and fill `conn.remote_ip` with the root client ip.

## Usage

```elixir
defmodule MyPlug do
  use Plug.Builder
  plug PlugForwardedPeer
end
```
