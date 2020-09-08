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

  defguardp is_encodable(num) when is_integer(num) and num >= 0

  def encode(num) when is_encodable(num) do
    num
    |> Stream.unfold(fn n ->
      if n == 0, do: nil, else: {rem(n, 32), div(n, 32)}
    end)
    |> Enum.to_list()
    |> Enum.reverse()
    |> case do
      [] -> [0]
      l -> l
    end
    |> Enum.map(&Map.fetch!(@encode_map, &1))
    |> Enum.into('')
    |> to_string()
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
