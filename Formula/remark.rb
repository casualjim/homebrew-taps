class Remark < Formula
  desc "Terminal-first code review notes for Git repos."
  homepage "https://github.com/casualjim/remark"
  version "0.3.3"
  if OS.mac? && Hardware::CPU.arm?
      url "https://github.com/casualjim/remark/releases/download/v0.3.3/remark-aarch64-apple-darwin.tar.xz"
      sha256 "907b1e0f7be9fe4c27ded5d2328d0a81f22d4fdcdca5f0f307746d4e9bd5b9c3"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/casualjim/remark/releases/download/v0.3.3/remark-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f1a4b5fdc3cf6f99a4039a27d6ac37bee3610666ed62de56c37544dca78d5362"
    end
    if Hardware::CPU.intel?
      url "https://github.com/casualjim/remark/releases/download/v0.3.3/remark-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "edb6aba8fd6db99ae9f4fb0cad21032fdca6cfea92a0bd0b9900af69d14f171c"
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
