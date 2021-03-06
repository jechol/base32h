defmodule Base32HTest do
  use ExUnit.Case
  doctest Base32H

  describe "boundary conditions" do
    test "encoding" do
      assert Base32H.encode(0) == "0"
      assert Base32H.encode(1_099_511_627_775) == "ZZZZZZZZ"
      assert Base32H.encode(1_099_511_627_776) == "100000000"

      assert_raise(FunctionClauseError, fn ->
        Base32H.encode(-1)
      end)
    end

    test "decoding" do
      assert Base32H.decode("0") == 0
      assert Base32H.decode("ZZZZZZZZ") == 1_099_511_627_775
      assert Base32H.decode("100000000") == 1_099_511_627_776
    end
  end

  describe "tests from Base32H/base32h.js README" do
    test "encoding" do
      assert Base32H.encode(17_854_910) == "H0WDY"

      assert Base32H.encode_bin(<<227, 169, 72, 131, 141, 245, 213, 150, 217, 217>>) ==
               "WELLH0WDYPARDNER"
    end

    test "decoding" do
      assert Base32H.decode("88pzd") == 8_675_309

      assert Base32H.decode_bin("2060W2G6009") == <<0, 0, 0, 8, 6, 7, 5, 3, 0, 9>>
    end
  end

  describe "tests from https://github.com/Base32H/base32h.js/blob/master/spec.js" do
    test "roundtrip encode/decode" do
      assert Base32H.decode(Base32H.encode(8_675_309)) == 8_675_309
    end

    test "numeric encode" do
      for {encoded, num} <- Enum.with_index('0123456789ABCDEFGHJKLMNPQRTVWXYZ') do
        assert Base32H.encode(num) == <<encoded>>
      end

      assert Base32H.encode(pow_of_2(5) - 1) == "Z"
      assert Base32H.encode(pow_of_2(10) - 1) == "ZZ"
      assert Base32H.encode(pow_of_2(20) - 1) == "ZZZZ"
      assert Base32H.encode(pow_of_2(40) - 1) == "ZZZZZZZZ"

      assert Base32H.encode(pow_of_2(8) - 1) == "7Z"
      assert Base32H.encode(pow_of_2(16) - 1) == "1ZZZ"
      assert Base32H.encode(pow_of_2(32) - 1) == "3ZZZZZZ"
    end

    test "numeric decode" do
      for {encoded, num} <- Enum.with_index('0123456789ABCDEFGHJKLMNPQRTVWXYZ') do
        assert Base32H.decode(<<encoded>>) == num
      end

      for {encoded, num} <- Enum.with_index('0123456789abcdefghjklmnpqrtvwxyz') do
        assert Base32H.decode(<<encoded>>) == num
      end

      assert Base32H.decode("o") == 0
      assert Base32H.decode("O") == 0
      assert Base32H.decode("i") == 1
      assert Base32H.decode("I") == 1
      assert Base32H.decode("s") == 5
      assert Base32H.decode("S") == 5
      assert Base32H.decode("u") == 27
      assert Base32H.decode("U") == 27

      assert Base32H.decode("Z") == pow_of_2(5) - 1
      assert Base32H.decode("Zz") == pow_of_2(10) - 1
      assert Base32H.decode("ZzzZ") == pow_of_2(20) - 1
      assert Base32H.decode("zZzZZzZz") == pow_of_2(40) - 1

      assert Base32H.decode("7z") == pow_of_2(8) - 1
      assert Base32H.decode("iZzZ") == pow_of_2(16) - 1
      assert Base32H.decode("3zZzZzZ") == pow_of_2(32) - 1
    end

    test "bin encode" do
      assert Base32H.encode_bin(<<255>>) == "0000007Z"
      assert Base32H.encode_bin(<<255, 255>>) == "00001ZZZ"
      assert Base32H.encode_bin(<<255, 255, 255>>) == "000FZZZZ"
      assert Base32H.encode_bin(<<255, 255, 255, 255>>) == "03ZZZZZZ"
      assert Base32H.encode_bin(<<255, 255, 255, 255, 255>>) == "ZZZZZZZZ"
      assert Base32H.encode_bin(<<255, 255, 255, 255, 255, 255>>) == "0000007ZZZZZZZZZ"

      assert Base32H.encode_bin(<<255, 255, 255, 255, 255, 255, 255, 255, 255, 255>>) ==
               "ZZZZZZZZZZZZZZZZ"
    end

    test "bin decode" do
      assert Base32H.decode_bin("7z") == <<0, 0, 0, 0, 255>>
      assert Base32H.decode_bin("1zZz") == <<0, 0, 0, 255, 255>>
      assert Base32H.decode_bin("fZzZz") == <<0, 0, 255, 255, 255>>
      assert Base32H.decode_bin("3zZzZzZ") == <<0, 255, 255, 255, 255>>
      assert Base32H.decode_bin("zZzZzZzZ") == <<255, 255, 255, 255, 255>>
      assert Base32H.decode_bin("7ZZZZZZZZZ") == <<0, 0, 0, 0, 255, 255, 255, 255, 255, 255>>

      assert Base32H.decode_bin("zZzZzZzZzZzZzZzZ") ==
               <<255, 255, 255, 255, 255, 255, 255, 255, 255, 255>>
    end
  end

  defp pow_of_2(0), do: 1
  defp pow_of_2(n), do: 2 * pow_of_2(n - 1)
end
