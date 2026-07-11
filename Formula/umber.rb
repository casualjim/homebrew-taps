class Umber < Formula
  desc "cat with syntax highlighting - a modern replacement for cat with tree-sitter powered syntax highlighting"
  homepage "https://github.com/casualjim/umber"
  version "0.5.4"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/casualjim/umber/releases/download/v0.5.4/umber-aarch64-apple-darwin.tar.xz"
    sha256 "7c37e14c5e95a33ad970eb2d49b28fa5451df784ccf5ff0fc49f9fe70f61ef02"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/casualjim/umber/releases/download/v0.5.4/umber-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "41bec707ec1832e2d13a9d30c65bccf0c7c952f074ac5cdca7abde6036c3eb74"
    end
    if Hardware::CPU.intel?
      url "https://github.com/casualjim/umber/releases/download/v0.5.4/umber-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "213cc0fe3e1f99c9c574769ae15e7250a7bd3c92959223c9f58237d314436880"
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
    bin.install "umber" if OS.mac? && Hardware::CPU.arm?
    bin.install "umber" if OS.linux? && Hardware::CPU.arm?
    bin.install "umber" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
