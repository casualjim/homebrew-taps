class HeimdallSandbox < Formula
  desc "Process sandbox runtime for Heimdall."
  homepage "https://github.com/casualjim/heimdall-sandbox"
  version "0.1.8"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/casualjim/heimdall-sandbox/releases/download/v0.1.8/heimdall-sandbox-aarch64-apple-darwin.tar.xz"
    sha256 "78fe639fd3687c11270b301191e39059de178dc525027f14e99e8514841ef9b1"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/casualjim/heimdall-sandbox/releases/download/v0.1.8/heimdall-sandbox-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f67c0c87dc64f91f9f9f8c92463b6effc80e1807ccdfe11088afd1f3fb0682e0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/casualjim/heimdall-sandbox/releases/download/v0.1.8/heimdall-sandbox-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "80d7738c43062f4decd971095ffda1d8f7ad7025a5dabada66a9f6aacefb5eab"
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
