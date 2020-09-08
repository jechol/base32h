defmodule Base32H do
  @digit_set %{
    0 => ["0", "O", "o"],
    1 => ["1", "l", "i"],
    2 => ["2"],
    3 => ["3"],
    4 => ["4"],
    5 => ["5", "S", "s"],
    6 => ["6"],
    7 => ["7"],
    8 => ["8"],
    9 => ["9"],
    10 => ["A", "a"],
    11 => ["B", "b"],
    12 => ["C", "c"],
    13 => ["D", "d"],
    14 => ["E", "e"],
    15 => ["F", "f"],
    16 => ["G", "g"],
    17 => ["H", "h"],
    18 => ["J", "j"],
    19 => ["K", "k"],
    20 => ["L", "l"],
    21 => ["M", "m"],
    22 => ["N", "n"],
    23 => ["P", "p"],
    24 => ["Q", "q"],
    25 => ["R", "r"],
    26 => ["T", "t"],
    27 => ["V", "v", "U", "u"],
    28 => ["W", "w"],
    29 => ["X", "x"],
    30 => ["Y", "y"],
    31 => ["Z", "z"]
  }

  @encode_map @digit_set |> Enum.map(fn {n, [s | _]} -> {n, s} end) |> Enum.into(%{})
  @decode_map @digit_set |> Enum.map(fn {n, [s | _]} -> {s, n} end) |> Enum.into(%{})

  @min_encode 0
  # max integer representible by 5 bytes.
  @max_encode 1_099_511_627_775
  @min_decode "0"
  @max_decode "ZZZZ-ZZZZ"

  def encode(n, allow_starting_zeros \\ false)
      when is_integer(n) and n >= @min_encode and n <= @max_encode do
    bin = <<n::40>>
    raw_encoded = for <<five_bits::size(5) <- bin>>, do: @encode_map |> Map.fetch!(five_bits)

    chunks = for <<five_bits::size(5) <- bin>>, do: five_bits

    zeros_processed =
      if allow_starting_zeros do
        chunks
      else
        chunks |> remove_starting_zeros()
      end

    encoded = zeros_processed |> Enum.map(&Map.fetch!(@encode_map, &1))

    encoded |> Enum.into("")
  end

  def encode_bin(<<bin::binary>>) do
    padded = pad(bin)
    expanded = for <<n::40 <- padded>>, do: expand_int(n)

    expanded
    |> List.flatten()
    |> remove_starting_zeros()
    |> do_encode()
  end

  defp do_encode(nums) when is_list(nums) do
    nums
    |> Enum.map(&Map.fetch!(@encode_map, &1))
    |> Enum.into("")
  end

  defp expand_int(n) when is_integer(n) and n >= @min_encode and n <= @max_encode do
    expand_bin(<<n::40>>)
  end

  defp expand_bin(<<bin::binary-size(5)>>) do
    for <<key::5 <- bin>>, do: key
  end

  defp pad(<<bin::binary>>) do
    pad_size = rem(byte_size(bin), 5)
    <<0::pad_size*8, bin::binary>>
  end

  defp remove_starting_zeros([last_digit]), do: [last_digit]
  defp remove_starting_zeros([0 | tail]), do: remove_starting_zeros(tail)
  defp remove_starting_zeros(non_zero_started), do: non_zero_started

  def decode(str) do
  end
end
