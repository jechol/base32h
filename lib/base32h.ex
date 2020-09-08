defmodule Base32H do
  @digits [
    '0Oo',
    '1Ii',
    '2',
    '3',
    '4',
    '5Ss',
    '6',
    '7',
    '8',
    '9',
    'Aa',
    'Bb',
    'Cc',
    'Dd',
    'Ee',
    'Ff',
    'Gg',
    'Hh',
    'Jj',
    'Kk',
    'Ll',
    'Mm',
    'Nn',
    'Pp',
    'Qq',
    'Rr',
    'Tt',
    'VvUu',
    'Ww',
    'Xx',
    'Yy',
    'Zz'
  ]
  @encode_map @digits
              |> Enum.with_index()
              |> Enum.map(fn {[c | _], n} -> {n, c} end)
              |> Enum.into(%{})
  @decode_map @digits
              |> Enum.with_index()
              |> Enum.map(fn {chars, n} -> chars |> Enum.map(fn c -> {c, n} end) end)
              |> List.flatten()
              |> Enum.into(%{})

  defguardp is_encodable(n) when is_integer(n) and n >= 0 and n <= 1_099_511_627_775

  def encode(n) when is_encodable(n) do
    bin = <<n::40>>

    chunks = for <<five_bits::size(5) <- bin>>, do: five_bits

    zeros_processed = chunks |> remove_starting_zeros()

    encoded = zeros_processed |> Enum.map(&Map.fetch!(@encode_map, &1))

    encoded |> Enum.into('') |> to_string()
  end

  def encode_bin(<<bin::binary>>) do
    padded = pad(bin)
    expanded = for <<n::40 <- padded>>, do: expand_int(n)

    expanded
    |> List.flatten()
    |> do_encode()
  end

  defp do_encode(nums) when is_list(nums) do
    nums |> Enum.map(&Map.fetch!(@encode_map, &1)) |> Enum.into('') |> to_string()
  end

  defp expand_int(n) when is_encodable(n) do
    expand_bin(<<n::40>>)
  end

  defp expand_bin(<<bin::binary-size(5)>>) do
    for <<key::5 <- bin>>, do: key
  end

  defp pad(<<bin::binary>>) do
    pad_size = Integer.mod(5 - byte_size(bin), 5)
    <<0::pad_size*8, bin::binary>>
  end

  defp remove_starting_zeros([last_digit]), do: [last_digit]
  defp remove_starting_zeros([0 | tail]), do: remove_starting_zeros(tail)
  defp remove_starting_zeros(non_zero_started), do: non_zero_started

  def decode(<<str::binary>>) do
    do_decode(str, 0)
  end

  defp do_decode(<<>>, acc), do: acc

  defp do_decode(<<c::utf8, tail::binary>>, acc),
    do: do_decode(tail, acc * 32 + Map.fetch!(@decode_map, c))

  def decode_bin(str) do
    last_size = (div(String.length(str) - 1, 8) + 1) * 5
    n = decode(str)
    <<n::last_size*8>>
  end
end
