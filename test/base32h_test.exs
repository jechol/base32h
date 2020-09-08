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

  describe "reference test" do
    test "roundtrip encode/decode" do
      assert Base32H.decode(Base32H.encode(8675309)) == 8675309
    end

    test "numeric encode" do
      for {encoded, num} <- Enum.with_index('0123456789ABCDEFGHJKLMNPQRTVWXYZ') do
        assert Base32H.encode(num) == <<encoded>>
      end

      assert Base32H.encode(2**5-1) ==  "Z"
      assert Base32H.encode(2**10-1) == ( "ZZ");
      assert Base32H.encode(2**20-1) == ( "ZZZZ");
      assert Base32H.encode(2**40-1) == ( "ZZZZZZZZ");

      assert Base32H.encode(2**8-1) == ( "7Z");
      assert Base32H.encode(2**16-1) == ( "1ZZZ");
      assert Base32H.encode(2**32-1) == ( "3ZZZZZZ");
    end

    test "numeric decode" do
      for {encoded, num} <- Enum.with_index('0123456789ABCDEFGHJKLMNPQRTVWXYZ') do
        assert Base32H.decode(encoded) == n
      end

      for {encoded, num} <- Enum.with_index('0123456789abcdefghjklmnpqrtvwxyz') do
        assert Base32H.decode(encoded) == n
      end

        assert Base32H.decode('o') == 0
        assert Base32H.decode('O') == (0);
        assert Base32H.decode('i') == (1);
        assert Base32H.decode('I') == (1);
        assert Base32H.decode('s') == (5);
        assert Base32H.decode('S') == (5);
        assert Base32H.decode('u') == (27);
        assert Base32H.decode('U') == (27);

        assert Base32H.decode('Z') ==2**5-1
        assert Base32H.decode('Zz') ==2**10-1
        assert Base32H.decode('ZzzZ') ==2**20-1
        assert Base32H.decode('zZzZZzZz') ==2**40-1

        assert Base32H.decode('7z') ==2**8-1
        assert Base32H.decode('iZzZ') ==2**16-1
        assert Base32H.decode('3zZzZzZ') ==2**32-1

    end

    test "bin encode" do

    assert Base32H.encode([255])                   == '0000007Z'
    assert Base32H.encode([255,255])               == '00001ZZZ'
    assert Base32H.encode([255,255,255])           == '000FZZZZ'
    assert Base32H.encode([255,255,255,255])       == '03ZZZZZZ'
    assert Base32H.encode([255,255,255,255,255])   == 'ZZZZZZZZ'

    assert Base32H.encode([255, 255,255,255,255,255])  ==      '0000007ZZZZZZZZZ'
    assert Base32H.encode([255,255,255,255,255, 255,255,255,255,255]) ==  'ZZZZZZZZZZZZZZZZ'
    end

    test "bin decode" do
    assert Base32H.decode('7z') ==              [0,0,0,0,255]
    assert Base32H.decode('1zZz') ==            [0,0,0,255,255]
    assert Base32H.decode('fZzZz') ==           [0,0,255,255,255]
    assert Base32H.decode('3zZzZzZ') ==         [0,255,255,255,255]
    assert Base32H.decode('zZzZzZzZ') ==        [255,255,255,255,255]

    assert Base32H.decode('7ZZZZZZZZZ') ==      [0,0,0,0,255, 255,255,255,255,255]
    assert Base32H.decode('zZzZzZzZzZzZzZzZ') ==[255,255,255,255,255, 255,255,255,255,255]

    end



  end
end
