defmodule PlugForwardedPeer.Mixfile do
  use Mix.Project

  def project do
    [app: :plug_forwarded_peer,
     version: "0.0.2",
     elixir: "~> 1.0",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: """
     Very simple plug which reads `X-Forwarded-For` or `Forwarded` header according
     to rfc7239 and fill `conn.remote_ip` with the root client ip.
     """,
     package: [links: %{"Source"=>"http://github.com/awetzel/plug_forwarded_peer"},
               contributors: ["Arnaud Wetzel"],
               licenses: ["MIT"],
               files: ["lib", "priv", "mix.exs", "README*", "templates", "LICENSE*"]],
     deps: deps()]
  end

  def application do
    [applications: [:plug]]
  end

  defp deps do
   [{:plug, "~> 1.0"}]
  end
end
