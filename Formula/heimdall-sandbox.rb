class HeimdallSandbox < Formula
  desc "Process sandbox runtime for Heimdall."
  homepage "https://github.com/casualjim/heimdall"
  version "0.1.5"
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/casualjim/heimdall/releases/download/v0.1.5/heimdall-sandbox-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "cd648225a529dd5763f8fc7cbb4b191e291a7a24e9562e086357fc9fded79c1b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/casualjim/heimdall/releases/download/v0.1.5/heimdall-sandbox-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8ec81d6598067321a7c05d7df7b15dc44a4f4cde3ebd5d32bad29792cd424f69"
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
