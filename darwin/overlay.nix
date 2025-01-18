final: prev: {
  bitwarden-cli = prev.bitwarden-cli.override {
    # Use LLVM 18 stdenv to avoid the libcxx char_traits issue
    stdenv = prev.llvmPackages_18.stdenv;
  };
}
