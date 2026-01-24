class Remark < Formula
  desc "Terminal-first code review notes for Git repos."
  homepage "https://github.com/casualjim/remark"
  version "0.4.1"
  if OS.mac? && Hardware::CPU.arm?
      url "https://github.com/casualjim/remark/releases/download/v0.4.1/remark-aarch64-apple-darwin.tar.xz"
      sha256 "1b0adcf8c20dc2bc289947b12ec3348276ac7c9860e4cfc51f79d187fee91ecf"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/casualjim/remark/releases/download/v0.4.1/remark-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d8d0e2defa324c5d7a1bb465fd7f99f6b62f6cdb75c9cca8c3741206f710491e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/casualjim/remark/releases/download/v0.4.1/remark-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "173b34e3e7da62b2134cedb944e1be1225e17826ff39185dadf2929f0a6f75a5"
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
