# Base32H

You might already know what Base32H is, if not see https://base32h.github.io

## Installation

The package can be installed by adding `base32h` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:base32h, "~> 0.3.0"}
  ]
end
```

## How to use?

```elixir
Base32H.encode(17_854_910) == "H0WDY"
Base32H.encode_bin(<<227, 169, 72, 131, 141, 245, 213, 150, 217, 217>>) == "WELLH0WDYPARDNER"

Base32H.decode("88pzd") == 8_675_309
Base32H.decode_bin("2060W2G6009") == <<0, 0, 0, 8, 6, 7, 5, 3, 0, 9>>
```
