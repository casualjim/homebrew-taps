class Remark < Formula
  desc "Terminal-first code review notes for Git repos."
  homepage "https://github.com/casualjim/remark"
  version "0.6.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/casualjim/remark/releases/download/v0.6.0/remark-aarch64-apple-darwin.tar.xz"
    sha256 "3523e867b70a7ed7428304a428e8d498719a3f086f7a32ea38f27e15ec97c8d6"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/casualjim/remark/releases/download/v0.6.0/remark-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6a10d30a3ede54fca7cfd9d9032f1e443c606d0d1a9a794b62d6b9931e44943b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/casualjim/remark/releases/download/v0.6.0/remark-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c0fbaa7e7e628f41b7c6e5b5f4d812134b0b3a1b0f322b6210996f8e451a21b2"
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
    bin.install "remark" if OS.mac? && Hardware::CPU.arm?
    bin.install "remark" if OS.linux? && Hardware::CPU.arm?
    bin.install "remark" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
