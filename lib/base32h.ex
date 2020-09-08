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

  def encode(num) when is_integer(num) and num >= 0 do
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
    padded = add_padding(bin, 5, 0)

    for <<chunk::binary-size(5) <- padded>> do
      for <<digit::5 <- chunk>>, do: digit
    end
    |> List.flatten()
    |> Enum.map(&Map.fetch!(@encode_map, &1))
    |> Enum.into('')
    |> to_string()
  end

  def decode(<<str::binary>>) do
    str
    |> String.to_charlist()
    |> Enum.reduce(0, fn c, acc -> acc * 32 + Map.fetch!(@decode_map, c) end)
  end

  def decode_bin(<<str::binary>>) do
    binary_size = (div(String.length(str) - 1, 8) + 1) * 5
    <<decode(str)::size(binary_size)-unit(8)>>
  end

  defp add_padding(<<bin::binary>>, unit_size, padding) do
    pad_size = Integer.mod(unit_size - byte_size(bin), unit_size)
    <<padding::size(pad_size)-unit(8), bin::binary>>
  end
end
