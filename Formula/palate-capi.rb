class PalateCapi < Formula
  desc "C API adapter for Palate file type detection"
  homepage "https://github.com/casualjim/palate"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/casualjim/palate/releases/download/v0.4.0/palate-capi-aarch64-apple-darwin.tar.xz"
      sha256 "a6f1c49ae460999cb349e4bc8a03596cdb3ea857bab982d2f8f2944beb523320"
    end
    if Hardware::CPU.intel?
      url "https://github.com/casualjim/palate/releases/download/v0.4.0/palate-capi-x86_64-apple-darwin.tar.xz"
      sha256 "611cec494235e257a48753a716a195766e2514562a66f0d03aba02478c5d6f45"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/casualjim/palate/releases/download/v0.4.0/palate-capi-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "dedc659daf1b423b1d153708d7653d963a49de5aa0b2e5356eb20980e23d6f58"
    end
    if Hardware::CPU.intel?
      url "https://github.com/casualjim/palate/releases/download/v0.4.0/palate-capi-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d0215d3b6f95e6d968226d83973c2c36393420a8c215786fc28e397fa976d8e4"
    end
  end
  license "GPL-3.0-or-later"

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin": {},
    "x86_64-pc-windows-gnu": {},
    "x86_64-unknown-linux-gnu": {}
  }

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      lib.install "libpalate_capi.dylib"
      lib.install "libpalate_capi.a"
    end
    if OS.mac? && Hardware::CPU.intel?
      lib.install "libpalate_capi.dylib"
      lib.install "libpalate_capi.a"
    end
    if OS.linux? && Hardware::CPU.arm?
      lib.install "libpalate_capi.so"
      lib.install "libpalate_capi.a"
    end
    if OS.linux? && Hardware::CPU.intel?
      lib.install "libpalate_capi.so"
      lib.install "libpalate_capi.a"
    end

    include.install "include/palate.h" if File.exist?("include/palate.h")
    if File.exist?("lib/pkgconfig/palate-capi.pc")
      (lib/"pkgconfig").install "lib/pkgconfig/palate-capi.pc"
      # Archives keep libraries at the archive root for cargo-dist. Homebrew
      # installs them under lib/, so adjust the relocatable pkg-config file.
      inreplace lib/"pkgconfig/palate-capi.pc", 'libdir=${prefix}', 'libdir=${prefix}/lib'
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files - ["include", "lib"]

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
