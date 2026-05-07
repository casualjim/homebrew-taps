class HeimdallSandbox < Formula
  desc "Linux-only process sandbox runtime for Heimdall."
  homepage "https://github.com/casualjim/heimdall"
  version "0.1.4"
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/casualjim/heimdall/releases/download/v0.1.4/heimdall-sandbox-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "2bb3aad5290c2b4dc0edd9f2763c66c40d83f0b4f41837b77aa63b36f409c5e9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/casualjim/heimdall/releases/download/v0.1.4/heimdall-sandbox-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6b9128293481f26813dedf136b3717d9567ccd7cc1d6b480f669d39095851d07"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-unknown-linux-gnu": {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

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
    bin.install "heimdall-sandbox" if OS.linux? && Hardware::CPU.arm?
    bin.install "heimdall-sandbox" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
