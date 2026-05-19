class Remark < Formula
  desc "Terminal-first code review notes for Git repos."
  homepage "https://github.com/casualjim/remark"
  version "0.6.1"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/casualjim/remark/releases/download/v0.6.1/remark-aarch64-apple-darwin.tar.xz"
    sha256 "0d2ea640bcab66115e1dc61438f2a1e3a4f19cdc20f1ad1951c9b9074c4a9fc9"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/casualjim/remark/releases/download/v0.6.1/remark-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "727f220901036cac1c1745b77a80a5b465df58145235de6896f95caf0ff0bb41"
    end
    if Hardware::CPU.intel?
      url "https://github.com/casualjim/remark/releases/download/v0.6.1/remark-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a645634b9e631e7f46eff528e9c415186010976c01467308f8d3c0f2daf1c006"
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
