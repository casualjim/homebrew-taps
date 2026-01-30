class Umber < Formula
  desc "cat with syntax highlighting - a modern replacement for cat with tree-sitter powered syntax highlighting"
  homepage "https://github.com/casualjim/umber"
  version "0.5.0"
  if OS.mac? && Hardware::CPU.arm?
      url "https://github.com/casualjim/umber/releases/download/v0.5.0/umber-aarch64-apple-darwin.tar.xz"
      sha256 "b72f8c966eaefecc9145d6c4adaa34f9a973536424e65f188bf365146bb843a4"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/casualjim/umber/releases/download/v0.5.0/umber-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c5baaf0ab67aed7333d218cfc630d905135b89bdec7bf988e51e3a1f0c1111f8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/casualjim/umber/releases/download/v0.5.0/umber-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "30794a253df2547a14b8c2da1f0560cc7a8815f52dca4db45b4f0de2e14afac7"
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
