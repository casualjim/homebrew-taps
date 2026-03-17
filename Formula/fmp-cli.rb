class FmpCli < Formula
  desc "Command-line interface for Financial Modeling Prep API"
  homepage "https://github.com/casualjim/fmp-rs"
  version "0.1.9"
  if OS.mac? && Hardware::CPU.arm?
      url "https://github.com/casualjim/fmp-rs/releases/download/v0.1.9/fmp-cli-aarch64-apple-darwin.tar.xz"
      sha256 "c1743405be21670a09ce3629498df2f8bbda0087a358c4268e11f24858363eee"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/casualjim/fmp-rs/releases/download/v0.1.9/fmp-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b56ab114b29d41e268cad71e478f35fb0b6ff339110b3be02a25ce3806693cea"
    end
    if Hardware::CPU.intel?
      url "https://github.com/casualjim/fmp-rs/releases/download/v0.1.9/fmp-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "2b9807c59be01fbcd1d274b0f600e671d4b514e9ebef80c3997726cd1bf61f5a"
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
