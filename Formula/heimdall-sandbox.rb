class HeimdallSandbox < Formula
  desc "Linux-only process sandbox runtime for Heimdall."
  homepage "https://github.com/casualjim/heimdall"
  version "0.1.3"
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/casualjim/heimdall/releases/download/v0.1.3/heimdall-sandbox-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4ecd2edefd600b4f115c21c55ba06dc31ad997ab1ef37c4afae8ee7cef2f2327"
    end
    if Hardware::CPU.intel?
      url "https://github.com/casualjim/heimdall/releases/download/v0.1.3/heimdall-sandbox-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "11e8ba6d296e695927ed4364f70dd696b735fbf57e6a37208ae87cb0f9a34366"
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
