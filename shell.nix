let
  nixpkgs = import (fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/20.03.tar.gz";
    sha256 = "0182ys095dfx02vl2a20j1hz92dx3mfgz2a6fhn31bqlp1wa8hlq";
  }) { };
  jechol = import (fetchTarball {
    url = "https://github.com/jechol/nur-packages/archive/v1.0.tar.gz";
    sha256 = "0v5fph0rb8bjibbfzapi8pq46hk5aysrmh6x32nxw4p807ix10l0";
  }) { };
in nixpkgs.mkShell {
  buildInputs = [ jechol.beam.all.packages.erlang_23_0.elixirs.elixir_1_10_4 ];
}
