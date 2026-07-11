class Umber < Formula
  desc "cat with syntax highlighting - a modern replacement for cat with tree-sitter powered syntax highlighting"
  homepage "https://github.com/casualjim/umber"
  version "0.5.3"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/casualjim/umber/releases/download/v0.5.3/umber-aarch64-apple-darwin.tar.xz"
    sha256 "87c1bed1d32b917c175131f19b635bdbec9830a8a88e83ddbef89b4df61730b1"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/casualjim/umber/releases/download/v0.5.3/umber-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5acf22c91210d4078dee0d414917c3235383c11ec15824d2ec84859235f6c181"
    end
    if Hardware::CPU.intel?
      url "https://github.com/casualjim/umber/releases/download/v0.5.3/umber-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f56d5f21a0d9ab79df495fdc1320155be0aa7e9ea0403b13d9d7c8625b432129"
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
