class PalateCapi < Formula
  desc "C API adapter for Palate file type detection"
  homepage "https://github.com/casualjim/palate"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/casualjim/palate/releases/download/v0.4.0/palate-capi-aarch64-apple-darwin.tar.xz"
      sha256 "95b70935d277703b95252d2b0638f65e36a3fa4d5cce39007f446658934519d0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/casualjim/palate/releases/download/v0.4.0/palate-capi-x86_64-apple-darwin.tar.xz"
      sha256 "6974f5d467cce16adbf695165c59ab13f1792e1068e556edcf0a4d891889f26a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/casualjim/palate/releases/download/v0.4.0/palate-capi-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "68a48a9fa19c1637a2e80730d9bd6475002cd76d900f96a3c3f1cea9bedea802"
    end
    if Hardware::CPU.intel?
      url "https://github.com/casualjim/palate/releases/download/v0.4.0/palate-capi-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "86d47b5a9645b635e72606424f4572907aa88ead2769bb6ae36b12ed1248d041"
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
