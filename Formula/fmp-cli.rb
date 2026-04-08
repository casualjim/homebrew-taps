class FmpCli < Formula
  desc "Command-line interface for Financial Modeling Prep API"
  homepage "https://github.com/casualjim/fmp-rs"
  version "0.1.15"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/casualjim/fmp-rs/releases/download/v0.1.15/fmp-cli-aarch64-apple-darwin.tar.xz"
    sha256 "7a2aa729a17cd9646b834bb4abdea0d8cd20662e7d8b1af2ea3d85b6327da6c7"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/casualjim/fmp-rs/releases/download/v0.1.15/fmp-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "746cf19042c71e2640bb31eb39ced58678d012836205278f6132286d928720a9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/casualjim/fmp-rs/releases/download/v0.1.15/fmp-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "035f6dc0aaeece68d7bfe5a0cda94a4f312c54549869ef75d9a521dcd2b7bb8a"
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
