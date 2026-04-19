class Zage < Formula
  desc "Shell history indexing and next-command suggestions with an online model"
  homepage "https://github.com/casualjim/zage"
  version "0.1.8"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/casualjim/zage/releases/download/v0.1.8/zage-aarch64-apple-darwin.tar.xz"
    sha256 "c74609d1b32738213410f592545c6a9c710427ac0b43f6341bedc467ea298cff"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/casualjim/zage/releases/download/v0.1.8/zage-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7b417f2c5666475821a2c9d3c1482b1afd7f459047453ffe9d0b87b16ab03226"
    end
    if Hardware::CPU.intel?
      url "https://github.com/casualjim/zage/releases/download/v0.1.8/zage-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "647ae4968a852a38c143de94e555413633b833427f94f5ab7314b128616a4f18"
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
    bin.install "zage" if OS.mac? && Hardware::CPU.arm?
    bin.install "zage" if OS.linux? && Hardware::CPU.arm?
    bin.install "zage" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
