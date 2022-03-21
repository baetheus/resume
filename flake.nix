{
  description = "Brandon Blaylock's Resume";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
  let
    inherit (flake-utils.lib) eachDefaultSystem;
    version = "0.0.0";
  in eachDefaultSystem (system: 
  let
    pkgs = import nixpkgs { inherit system; };
    inherit (pkgs.stdenv) mkDerivation;
    inherit (pkgs.lib) cleanSource;
    
    resume = mkDerivation {
      inherit version;
      pname = "resume";
      src = cleanSource ./. ;
      nativeBuildInputs = with pkgs; [ texlive.combined.scheme-full rubber ];
      buildPhase = ''
        $rubber --pdf resume
        $rubber --clean resume
      '';
      installPhase = ''
        mv $TMP/reesume.pdf $out
      '';
    };
  in rec {
    defaultPackage = resume;
    defaultApp = flake-utils.lib.mkApp {
      drv = defaultPackage;
    };
    devShell = pkgs.mkShell {
      buildInputs = [
        resume
      ];
    };
  });
}


