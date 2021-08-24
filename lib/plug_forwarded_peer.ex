defmodule PlugForwardedPeer do
  import Plug.Conn
  def init(_), do: []
  def call(conn,_) do
    case get_req_header(conn,"x-forwarded-for") do
      []->
        case get_req_header(conn,"forwarded") do
          []-> conn
          [header|_]->
            ips = for "for="<>quoted_ip<-String.split(header,~r/\s*,\s*/), ip=clean_ip(quoted_ip), !is_nil(ip), do: ip
            case ips do
              []->conn
              [ip|_]->%{conn|remote_ip: ip}
            end
        end
      [header|_]->
        ips = for quoted_ip<-String.split(header,~r/\s*,\s*/), ip=clean_ip(quoted_ip), !is_nil(ip), do: ip
        case ips do
          []->conn
          [ip|_]->%{conn|remote_ip: ip}
        end
    end
  end
  def clean_ip(maybe_quoted_ip) do
    maybe_ip = maybe_quoted_ip |> String.trim("\"") |> String.trim_trailing("]") |> String.trim_leading("[")
    case :inet_parse.address('#{maybe_ip}') do
      {:ok,ip}->ip
      _->nil
    end
  end
end
