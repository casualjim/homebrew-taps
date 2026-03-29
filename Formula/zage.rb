class Zage < Formula
  desc "Shell history indexing and next-command suggestions with an online model"
  homepage "https://github.com/casualjim/zage"
  version "0.1.6"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/casualjim/zage/releases/download/v0.1.6/zage-aarch64-apple-darwin.tar.xz"
    sha256 "d8e51249cbfaa560b7af0770a51f76a8c8c1da7aa590020ae05ebcd07aa29ddd"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/casualjim/zage/releases/download/v0.1.6/zage-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b1fe4365c41b5432c03e990fefa6b81e6212a306203a801768b10b7046c8dd24"
    end
    if Hardware::CPU.intel?
      url "https://github.com/casualjim/zage/releases/download/v0.1.6/zage-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "577c2866b2283c76935a157f512a0e3368814dbcd243ab7fc6866505a08a8a56"
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
