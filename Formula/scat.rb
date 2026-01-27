class Scat < Formula
  desc "cat with syntax highlighting - a modern replacement for cat with tree-sitter powered syntax highlighting"
  homepage "https://github.com/casualjim/scat"
  version "0.4.1"
  if OS.mac? && Hardware::CPU.arm?
      url "https://github.com/casualjim/scat/releases/download/v0.4.1/scat-aarch64-apple-darwin.tar.xz"
      sha256 "34dbd248037f1575907da20a408bca7af960ac735d7fb0a06bf29ed089820d5c"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/casualjim/scat/releases/download/v0.4.1/scat-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4695295d22337b193ea7668554f907853c705a82375645bb463d2db0262b1a6c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/casualjim/scat/releases/download/v0.4.1/scat-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "56021034ef5d95508db85bb42d34f0f09521097db92829f759d8e8d690c00eff"
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
    bin.install "scat" if OS.mac? && Hardware::CPU.arm?
    bin.install "scat" if OS.linux? && Hardware::CPU.arm?
    bin.install "scat" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
