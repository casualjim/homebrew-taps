class Umber < Formula
  desc "cat with syntax highlighting - a modern replacement for cat with tree-sitter powered syntax highlighting"
  homepage "https://github.com/casualjim/umber"
  version "0.5.2"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/casualjim/umber/releases/download/v0.5.2/umber-aarch64-apple-darwin.tar.xz"
    sha256 "8aaf61c94c176c1dd4dc5549b2c2732cbce83b308ae41adb9acf14ec32830fa8"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/casualjim/umber/releases/download/v0.5.2/umber-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4af41f09503882ca907a6763973a1700a5dbc6c78e1918980a935f6c0a0094a5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/casualjim/umber/releases/download/v0.5.2/umber-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "cd369a3b893dceaf7a773343fe18e09fb4d30d4b6d7683079c314f9a5e0655a6"
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
