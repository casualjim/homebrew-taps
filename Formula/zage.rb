class Zage < Formula
  desc "Shell history indexing and next-command suggestions with an online model"
  homepage "https://github.com/casualjim/zage"
  version "0.1.9"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/casualjim/zage/releases/download/v0.1.9/zage-aarch64-apple-darwin.tar.xz"
    sha256 "e773f36968743356b7d3b2b5a1d68f44b50f39983155dfb2c29f5bb1cedf698b"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/casualjim/zage/releases/download/v0.1.9/zage-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a6a8043cd48932c8f71d9a10d37a60b4c364625ccf752a5206bf5e9db9475a03"
    end
    if Hardware::CPU.intel?
      url "https://github.com/casualjim/zage/releases/download/v0.1.9/zage-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "227b167c12023b92018b85036505cc73c41b993e52acf8c6a37d9d09dc08e065"
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
