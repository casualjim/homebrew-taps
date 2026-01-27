class Scat < Formula
  desc "cat with syntax highlighting - a modern replacement for cat with tree-sitter powered syntax highlighting"
  homepage "https://github.com/casualjim/scat"
  version "0.4.0"
  if OS.mac? && Hardware::CPU.arm?
      url "https://github.com/casualjim/scat/releases/download/v0.4.0/scat-aarch64-apple-darwin.tar.xz"
      sha256 "a53125fd0514a817249de04e7f0499cfc6d13d257c7ffe3cc69f444da4812b86"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/casualjim/scat/releases/download/v0.4.0/scat-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "70ea06b2ada6037fcb4e4c5bd7bb17d4fedec73db40424ae0f4520f177043da9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/casualjim/scat/releases/download/v0.4.0/scat-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "686ae48b761ffbb0a4efcf40e07cb079c8f2003dee7150f295b58fc38613e7a8"
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
