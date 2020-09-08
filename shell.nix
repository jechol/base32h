let
  sources = import ./nix/sources.nix;
  pkgs = import sources.nixpkgs { };
  jechol-nur = import sources.jechol-nur { };
  inherit (pkgs.lib) optional optionals;
in pkgs.mkShell {
  buildInputs =
    [ jechol-nur.beam.all.packages.erlang_23_0.elixirs.elixir_1_10_4 ];
}
