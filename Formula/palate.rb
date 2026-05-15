class Palate < Formula
  desc "Command-line interface for Palate file type detection"
  homepage "https://github.com/casualjim/palate"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/casualjim/palate/releases/download/v0.4.0/palate-cli-aarch64-apple-darwin.tar.xz"
      sha256 "79bde4bb062a37471d89236075ac057a1b729e22f9eb31204994edb685d12516"
    end
    if Hardware::CPU.intel?
      url "https://github.com/casualjim/palate/releases/download/v0.4.0/palate-cli-x86_64-apple-darwin.tar.xz"
      sha256 "25b8ede92121d51e73f53992b9fe02eba6ba0fd933936ef04e4282e5fc9942a3"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/casualjim/palate/releases/download/v0.4.0/palate-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e7b75e5ffd3e45056259275da2cfdb0cb8804823b5dcbfe0dafa0e4406ca8ae3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/casualjim/palate/releases/download/v0.4.0/palate-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4c00d83fe38fb864b03d8da6e3ec1569080c9fa548feaf75fa7fd70dbeb36786"
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
