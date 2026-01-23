class Remark < Formula
  desc "Terminal-first code review notes for Git repos."
  homepage "https://github.com/casualjim/remark"
  version "0.4.0"
  if OS.mac? && Hardware::CPU.arm?
      url "https://github.com/casualjim/remark/releases/download/v0.4.0/remark-aarch64-apple-darwin.tar.xz"
      sha256 "b5cf898c73495982616886362a01e2eee03dfa3dcbb311958305d4367a97d1f2"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/casualjim/remark/releases/download/v0.4.0/remark-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "511de9b24deb9c906971a3ac5a5fbbec91a3dd5b91bd712f7eeebe0307692133"
    end
    if Hardware::CPU.intel?
      url "https://github.com/casualjim/remark/releases/download/v0.4.0/remark-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "43c9b6c083daabcb13e4ae65b75adcc36e361447b5ca423da0797afab926e33f"
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
