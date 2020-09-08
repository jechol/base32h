defmodule Base32HTest do
  use ExUnit.Case
  doctest Base32H

  describe "encoding" do
    test "encode/1" do
      assert Base32H.encode(0) == "0"
      assert Base32H.encode(1_099_511_627_775) == "ZZZZZZZZ"

      assert_raise(FunctionClauseError, fn ->
        Base32H.encode(-1)
      end)

      assert_raise(FunctionClauseError, fn ->
        Base32H.encode(1_099_511_627_776)
      end)

      assert Base32H.encode(17_854_910) == "H0WDY"
    end

    test "encode_bin/1" do
      assert Base32H.encode_bin(<<227, 169, 72, 131, 141, 245, 213, 150, 217, 217>>) ==
               "WELLH0WDYPARDNER"

      assert Base32H.encode_bin(<<0, 0, 0, 8, 6, 7, 5, 3, 0, 9>>) == "2060W2G6009"
    end
  end

  describe "decoding" do
    test "decode/1" do
      assert Base32H.decode("0") == 0
      assert Base32H.decode("ZZZZZZZZ") == 1_099_511_627_775

      assert Base32H.decode("88pzd") == 8_675_309
    end

    test "decode_bin/1" do
      assert Base32H.decode_bin("WELLH0WDYPARDNER") ==
               <<227, 169, 72, 131, 141, 245, 213, 150, 217, 217>>

      assert Base32H.decode_bin("2060W2G6009") == <<0, 0, 0, 8, 6, 7, 5, 3, 0, 9>>
    end
  end
end
