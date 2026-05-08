class HeimdallSandbox < Formula
  desc "Process sandbox runtime for Heimdall."
  homepage "https://github.com/casualjim/heimdall-sandbox"
  version "0.1.9"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/casualjim/heimdall-sandbox/releases/download/v0.1.9/heimdall-sandbox-aarch64-apple-darwin.tar.xz"
    sha256 "3c85c5b7a73473167507a8ccae89e8fccd895536eb8665f86dd995397d33dbed"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/casualjim/heimdall-sandbox/releases/download/v0.1.9/heimdall-sandbox-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7941b7f769d7cd80963be2f6170744c3713525f847db607b1a9c255a9acfb105"
    end
    if Hardware::CPU.intel?
      url "https://github.com/casualjim/heimdall-sandbox/releases/download/v0.1.9/heimdall-sandbox-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "dfab2757be8075fc5051995792a6ed13bab5d74ce0c8bd7a7e4dd2c6f9f520ba"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
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
    bin.install "heimdall-sandbox" if OS.mac? && Hardware::CPU.arm?
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
