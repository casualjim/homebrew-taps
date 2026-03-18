class Zage < Formula
  desc "Shell history indexing and next-command suggestions with an online model"
  homepage "https://github.com/casualjim/zage"
  version "0.1.4"
  if OS.mac? && Hardware::CPU.arm?
      url "https://github.com/casualjim/zage/releases/download/v0.1.4/zage-aarch64-apple-darwin.tar.xz"
      sha256 "c0f99c2cd791b934e86aa88a242b0ec99cde1f21ada24488d8748db07fbf8723"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/casualjim/zage/releases/download/v0.1.4/zage-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "cdb1e3945b18cb788abe5b32ce944139f12f962a9bd0f908ab00249b84c9d83e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/casualjim/zage/releases/download/v0.1.4/zage-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3cc5bf2f60cd5567249c87951107076132451a62799dc0b8a02c71e02c01fd32"
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
