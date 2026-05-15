class Palate < Formula
  desc "Command-line interface for Palate file type detection"
  homepage "https://github.com/casualjim/palate"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/casualjim/palate/releases/download/v0.4.0/palate-cli-aarch64-apple-darwin.tar.xz"
      sha256 "26e92ee1a3d15940601dc10752f1d15b943a85178c41cb710c16fd89641a5f7e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/casualjim/palate/releases/download/v0.4.0/palate-cli-x86_64-apple-darwin.tar.xz"
      sha256 "f3660ee63ab75c427826743c5af27b14f334455dc41901366d89d8226f66d8f9"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/casualjim/palate/releases/download/v0.4.0/palate-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0aa51f8c727f5b111c9beaa564e8360278ecae697b0af73884de759a9f2eef23"
    end
    if Hardware::CPU.intel?
      url "https://github.com/casualjim/palate/releases/download/v0.4.0/palate-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "dbb4de730ec4862901056b5c4bc705fbf792025eb51a0333c74960bafc73e771"
    end
  end
  license "GPL-3.0-or-later"

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin": {},
    "x86_64-pc-windows-gnu": {},
    "x86_64-unknown-linux-gnu": {}
  }

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
      bin.install "palate"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "palate"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "palate"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "palate"
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
