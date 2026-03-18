class Umber < Formula
  desc "cat with syntax highlighting - a modern replacement for cat with tree-sitter powered syntax highlighting"
  homepage "https://github.com/casualjim/umber"
  version "0.5.1"
  if OS.mac? && Hardware::CPU.arm?
      url "https://github.com/casualjim/umber/releases/download/v0.5.1/umber-aarch64-apple-darwin.tar.xz"
      sha256 "7736c1cf7cdab1fb4e36b735f9f1e14328633d71d071f99867285c0cbd8a992f"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/casualjim/umber/releases/download/v0.5.1/umber-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0b1d9c08d12f1d22ac2b2e01b602e447eb44b251ffbe56a8095e721bdf9ce671"
    end
    if Hardware::CPU.intel?
      url "https://github.com/casualjim/umber/releases/download/v0.5.1/umber-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f6dc9ac38624bf79ec2f3177890b9052bca8b1658cc087f47c7b6517050fe287"
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
    bin.install "umber" if OS.mac? && Hardware::CPU.arm?
    bin.install "umber" if OS.linux? && Hardware::CPU.arm?
    bin.install "umber" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
