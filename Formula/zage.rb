class Zage < Formula
  desc "Shell history indexing and next-command suggestions with an online model"
  homepage "https://github.com/casualjim/zage"
  version "0.1.5"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/casualjim/zage/releases/download/v0.1.5/zage-aarch64-apple-darwin.tar.xz"
    sha256 "d05d1688128e7dfe436b013e02054cc394e35bf18c8312e884fba0f71e8f32da"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/casualjim/zage/releases/download/v0.1.5/zage-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ce16442321cd10ec9c5d8a9d1e4f9691246b728acb404a376c8194a8f91f85d0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/casualjim/zage/releases/download/v0.1.5/zage-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1a52675c1ab2b04d9d9b66699f4f2369397ba8486b97582d94626f0a925f67ce"
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
