class FmpCli < Formula
  desc "Command-line interface for Financial Modeling Prep API"
  homepage "https://github.com/casualjim/fmp-rs"
  version "0.1.14"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/casualjim/fmp-rs/releases/download/v0.1.14/fmp-cli-aarch64-apple-darwin.tar.xz"
    sha256 "f88d8d47af34f71493e92f35e8f2796209dfd7233ccdd6ecf8228f373afe077a"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/casualjim/fmp-rs/releases/download/v0.1.14/fmp-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "72a6f32f96fe8159cd19375f87d77a0c050f64a227703b1743b062ad6c73bb3a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/casualjim/fmp-rs/releases/download/v0.1.14/fmp-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "62027e6c621c45ff37048c41dbf7e298efbd47646e6cfe2ef91b540d1b61fdd1"
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
