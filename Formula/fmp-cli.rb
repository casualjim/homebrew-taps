class FmpCli < Formula
  desc "Command-line interface for Financial Modeling Prep API"
  homepage "https://github.com/casualjim/fmp-rs"
  version "0.1.11"
  if OS.mac? && Hardware::CPU.arm?
      url "https://github.com/casualjim/fmp-rs/releases/download/v0.1.11/fmp-cli-aarch64-apple-darwin.tar.xz"
      sha256 "b11c914270dfa2b04098fbf0b96c507102c0e550d1084d6d84f4f38be1db1ef7"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/casualjim/fmp-rs/releases/download/v0.1.11/fmp-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "032277e3453f94067740e3abb63afbe630d09663d82ef1402e043cf837da08af"
    end
    if Hardware::CPU.intel?
      url "https://github.com/casualjim/fmp-rs/releases/download/v0.1.11/fmp-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d31f85b7420cb95550b2b80d2e4f21940b6d899b8f5ae5062330cc5ab169b68a"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-pc-windows-gnu":     {},
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
    bin.install "fmp" if OS.mac? && Hardware::CPU.arm?
    bin.install "fmp" if OS.linux? && Hardware::CPU.arm?
    bin.install "fmp" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
