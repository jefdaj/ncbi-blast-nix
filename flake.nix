{
  description = "NCBI BLAST";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?rev=4f37689c8a219a9d756c5ff38525ad09349f422f";
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, flake-utils}:
    let
      # TODO do other architectures work?
      systems = [ "x86_64-linux" "x86_64-darwin" ];

      # pinned old version used by CRB-BLAST
      # TODO upgrade and see if anything actually breaks
      oldAttrs = system: rec {
        version = "2.2.29";
        name = "ncbi-blast-${version}";
        src = if system == "x86_64-darwin"
          then (nixpkgs.fetchurl {
            url = "ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/2.2.29/ncbi-blast-2.2.29+-universal-macosx.tar.gz";
            sha256="00g8pzwx11wvc7zqrxnrd9xad68ckl8agz9lyabmn7h4k07p5yll";
          }) else (nixpkgs.fetchurl {
            url = "ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/2.2.29/ncbi-blast-2.2.29+-x64-linux.tar.gz";
            sha256="1pzy0ylkqlbj40mywz358ia0nq9niwqnmxxzrs1jak22zym9fgpm";
          });
      };

    in flake-utils.lib.eachSystem systems (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in rec {

        # TODO are these structured properly?
        defaultPackage = packages.ncbi-blast;
        packages = rec {
          "ncbi-blast"        = nixpkgs.legacyPackages.${system}.pythonPackages.callPackage ./default.nix { };
          "ncbi-blast-2.2.29" = defaultPackage.overrideDerivation (_: oldAttrs system);
        };

      }
    );
}
