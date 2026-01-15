class Scat < Formula
  desc "cat with syntax highlighting - a modern replacement for cat with tree-sitter powered syntax highlighting"
  homepage "https://github.com/casualjim/scat"
  version "0.1.4"
  if OS.mac? && Hardware::CPU.arm?
      url "https://github.com/casualjim/scat/releases/download/v0.1.4/scat-aarch64-apple-darwin.tar.xz"
      sha256 "511c86c8539f3959d8c81466e2e8d37d3510a4be7706788af95a947a53c528cf"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/casualjim/scat/releases/download/v0.1.4/scat-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3ff99b3cdbe8fa4198fac1a0768e2c92f4b1cd5d20c4db799c9d407d25cf9cdb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/casualjim/scat/releases/download/v0.1.4/scat-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "979e9505f992eebd2336d4a76eefe673b44126809e94b7c199f03dc295c2f16c"
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
