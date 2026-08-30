class Remark < Formula
  desc "Terminal-first code review notes for Git repos."
  homepage "https://github.com/casualjim/remark"
  version "0.6.2"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/casualjim/remark/releases/download/v0.6.2/remark-aarch64-apple-darwin.tar.xz"
    sha256 "12bf1cdbdf1b09c47e089dc66efa78f7662a62169638e1492e8f4f9673dcaa4e"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/casualjim/remark/releases/download/v0.6.2/remark-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ddca05e340028c83956335b5d1f231dc94d5321d9f48c468a7ecc64c0122376d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/casualjim/remark/releases/download/v0.6.2/remark-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7e4ff4fd1f83f4d1964195567c2c9a22d7523a3f46ae35a14b0cc71ec2f3b498"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "remark"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "remark"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "remark"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
