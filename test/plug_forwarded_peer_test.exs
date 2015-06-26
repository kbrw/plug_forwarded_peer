defmodule PlugForwardedPeerTest do
  use ExUnit.Case
  use Plug.Test

  defp test_conn(header \\ nil,value \\ nil) do 
    c = %{conn("GET","/")| remote_ip: {127,0,0,1}}
    c = if header, do: put_req_header(c,header,value), else: c
    PlugForwardedPeer.call(c,[]).remote_ip
  end

  test "no header keeps peer ip" do
    assert test_conn == {127,0,0,1}
  end

  test "override client-ip with x-forwarded-for" do
    assert test_conn("x-forwarded-for","200.10.0.1 , 100.1.29.1, 12") == {200,10,0,1}
    assert test_conn("x-forwarded-for",~s/"200.10.0.1" , 100.1.29.1, 12/) == {200,10,0,1}
    assert test_conn("x-forwarded-for",~s/"titi" , [::1], 12/) == {0,0,0,0,0,0,0,1}
  end

  test "override client-ip with forwarded for:" do
    assert test_conn("forwarded",~s/host=toto, for="[::1]", for="127.1.1.1"/) == {0,0,0,0,0,0,0,1}
  end
  
  test "override client-ip with wrong ip keeps peer ip" do
    assert test_conn("x-forwarded-for","errornous header") == {127,0,0,1}
    assert test_conn("forwarded",~s/host=toto, for="[:1]", for="256.1.1.1"/) == {127,0,0,1}
  end
end
