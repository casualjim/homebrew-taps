class FmpCli < Formula
  desc "Command-line interface for Financial Modeling Prep API"
  homepage "https://github.com/casualjim/fmp-rs"
  version "0.1.10"
  if OS.mac? && Hardware::CPU.arm?
      url "https://github.com/casualjim/fmp-rs/releases/download/v0.1.10/fmp-cli-aarch64-apple-darwin.tar.xz"
      sha256 "5fa9349fd15d916bbc79786628e2e61e4324ac9c5d7ae000dc49a7fefb95ed91"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/casualjim/fmp-rs/releases/download/v0.1.10/fmp-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ce30025e5154c264ca4167509bd8c8600dbc1fbac36f0e3b3bbb9ecaec71b8a0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/casualjim/fmp-rs/releases/download/v0.1.10/fmp-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "bec1973612f74dc3c061af065756810b7bbee971563ad3fa354a16c12faa52e2"
    end
  end
  license "none"

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
