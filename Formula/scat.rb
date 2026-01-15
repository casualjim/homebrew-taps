class Scat < Formula
  desc "cat with syntax highlighting - a modern replacement for cat with tree-sitter powered syntax highlighting"
  homepage "https://github.com/casualjim/scat"
  version "0.1.5"
  if OS.mac? && Hardware::CPU.arm?
      url "https://github.com/casualjim/scat/releases/download/v0.1.5/scat-aarch64-apple-darwin.tar.xz"
      sha256 "cfa006061e9bc0f02a4098729ec0bd01f37c8f95832df58139840e3f2fa04080"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/casualjim/scat/releases/download/v0.1.5/scat-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "493a22224c441d113f2e0e3e5aa86ce92a564898bb9a3b5c559d5dea5d3e6eca"
    end
    if Hardware::CPU.intel?
      url "https://github.com/casualjim/scat/releases/download/v0.1.5/scat-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7eb3e6286b4e001c1d9e9a2118137dde8c9572c3f3f6c3906c78a75a63e62a8d"
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
    bin.install "scat" if OS.mac? && Hardware::CPU.arm?
    bin.install "scat" if OS.linux? && Hardware::CPU.arm?
    bin.install "scat" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
