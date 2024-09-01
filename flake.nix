{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs = { self, nixpkgs, rust-overlay, utils }:
    utils.lib.eachDefaultSystem (system:
      let
        overlays = [ (import rust-overlay )];
        pkgs = import nixpkgs { inherit system overlays; };
      in
      {
        devShell = with pkgs; mkShell {
         #nativeBuildInputs = [
            #pkg-config
          #];
          buildInputs = [ 
            (rust-bin.stable.latest.default.override {
              targets = [
                "x86_64-unknown-linux-musl"
              ];
            })
            rust-analyzer # LSP
            cargo-nextest # much faster test runner
          ];
          RUST_SRC_PATH = rustPlatform.rustLibSrc;
        };
      });
}
