class HeimdallSandbox < Formula
  desc "Process sandbox runtime for Heimdall."
  homepage "https://github.com/casualjim/heimdall-sandbox"
  version "0.1.42"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/casualjim/heimdall-sandbox/releases/download/v0.1.42/heimdall-sandbox-aarch64-apple-darwin.tar.xz"
    sha256 "b52aa0e9f5a479f1623d67d7991458842ece7a191017d010390c49669e7c2491"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/casualjim/heimdall-sandbox/releases/download/v0.1.42/heimdall-sandbox-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "20888008ec08b3a8f863e20cf03405c82c294123a6ace761f9202a4f4a300f9b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/casualjim/heimdall-sandbox/releases/download/v0.1.42/heimdall-sandbox-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8225fb93233ffe90397faf88b4e960500a882e2b2cb763419647801635fb0b2e"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
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
    bin.install "heimdall-sandbox" if OS.mac? && Hardware::CPU.arm?
    bin.install "heimdall-sandbox" if OS.linux? && Hardware::CPU.arm?
    bin.install "heimdall-sandbox" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!


# Install the WebGPU Dawn shared library.
dylib = Dir["libwebgpu_dawn.*"].first
lib.install dylib if dylib

# Add rpath so binaries find the shared library in Homebrew's lib directory.
if OS.mac?
  p = "#{bin}/heimdall-sandbox"
  chmod "+w", p
  MachO::Tools.add_rpath(p, "@loader_path/../lib", :max_align)
  system "codesign", "--force", "--sign", "-", p
end

        # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
