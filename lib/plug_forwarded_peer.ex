defmodule PlugForwardedPeer do
  import Plug.Conn

  def init(_), do: []

  def call(conn, _) do
    cond do
      header_data = extract_data_from_header(conn, "x-forwarded-for") ->
        extract_and_replace_remote_ip(conn, header_data)

      header_data = extract_data_from_header(conn, "forwarded") ->
        extract_and_replace_remote_ip(conn, header_data)

      true ->
        conn
    end
  end

  defp clean_ip(maybe_quoted_ip) do
    maybe_ip =
      maybe_quoted_ip
      |> String.trim(~s(for=))
      |> String.trim(~s("))
      |> String.trim_trailing("]")
      |> String.trim_leading("[")

    case :inet_parse.address('#{maybe_ip}') do
      {:ok, ip} -> ip
      _ -> nil
    end
  end

  defp extract_data_from_header(conn, header_name) do
    case get_req_header(conn, header_name) do
      [] -> nil
      [head | _tail] -> head
    end
  end

  defp extract_and_replace_remote_ip(conn, data) do
    ips =
      data
      |> String.split(~r/\s*,\s*/)
      |> Enum.map(&clean_ip/1)
      |> Enum.reject(&is_nil/1)

    case ips do
      [] -> conn
      [ip | _] -> %{conn | remote_ip: ip}
    end
  end
end
