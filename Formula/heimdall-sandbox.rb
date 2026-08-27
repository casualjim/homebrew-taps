class HeimdallSandbox < Formula
  desc "Process sandbox runtime for Heimdall."
  homepage "https://github.com/casualjim/heimdall-sandbox"
  version "0.2.2"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/casualjim/heimdall-sandbox/releases/download/v0.2.2/heimdall-sandbox-aarch64-apple-darwin.tar.xz"
    sha256 "167d90e2cb08d0db6725abc6a0b34e8ec694ebb3a221b99fc749e9d4bd9c4615"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/casualjim/heimdall-sandbox/releases/download/v0.2.2/heimdall-sandbox-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "73f4bdcc9c57188095350eff4beafabcbed884fa6d13ddbf2a0e7c7265ab4945"
    end
    if Hardware::CPU.intel?
      url "https://github.com/casualjim/heimdall-sandbox/releases/download/v0.2.2/heimdall-sandbox-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d4ae7ac5ec9d50d5bee218fc415e62a1141a2c87af950dd22dfbd496d411a267"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "heimdall-sandbox"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "heimdall-sandbox"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "heimdall-sandbox"
    end

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
