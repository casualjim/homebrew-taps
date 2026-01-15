class Scat < Formula
  desc "cat with syntax highlighting - a modern replacement for cat with tree-sitter powered syntax highlighting"
  homepage "https://github.com/casualjim/scat"
  version "0.1.6"
  if OS.mac? && Hardware::CPU.arm?
      url "https://github.com/casualjim/scat/releases/download/v0.1.6/scat-aarch64-apple-darwin.tar.xz"
      sha256 "46d10734f1f697f582c84305339d93a6e9a14a47ea04651bcadaf86068914748"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/casualjim/scat/releases/download/v0.1.6/scat-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "040c5d0ee621f1740bd5513544c48226e1f162291929a88f7be3cdbe7dbcaceb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/casualjim/scat/releases/download/v0.1.6/scat-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0690c9db08cdb8ef9e4e119e41aaa4405ec7be811996aec7bdd79905a79d5514"
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
