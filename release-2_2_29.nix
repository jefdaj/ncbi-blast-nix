with import <nixpkgs> {};
with pkgs;

# crb-blast only supports exactly 2.2.29
# and there are reports of a bug in newer ones (TODO still?)

(callPackage ./default.nix {}).overrideDerivation (old: rec {
  version="2.2.29";
  name="ncbi-blast-${version}";
  src = if pkgs.stdenv.hostPlatform.system == "x86_64-darwin"
    then (pkgs.fetchurl {
      url = "ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/2.2.29/ncbi-blast-2.2.29+-universal-macosx.tar.gz";
      sha256="00g8pzwx11wvc7zqrxnrd9xad68ckl8agz9lyabmn7h4k07p5yll";
    }) else (pkgs.fetchurl {
      url = "ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/2.2.29/ncbi-blast-2.2.29+-x64-linux.tar.gz";
      sha256="1pzy0ylkqlbj40mywz358ia0nq9niwqnmxxzrs1jak22zym9fgpm";
    });
})
