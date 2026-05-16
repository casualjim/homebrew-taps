class HeimdallSandbox < Formula
  desc "Process sandbox runtime for Heimdall."
  homepage "https://github.com/casualjim/heimdall-sandbox"
  version "0.1.34"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/casualjim/heimdall-sandbox/releases/download/v0.1.34/heimdall-sandbox-aarch64-apple-darwin.tar.xz"
    sha256 "1345408a3a0e89827a9d21a80bf4385c4f7802ffae4305db3af925d189b34f07"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/casualjim/heimdall-sandbox/releases/download/v0.1.34/heimdall-sandbox-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "bd7f3266f74bda500eb8b05c79d6eedad4fe59fcc8d41a2fa542be94a964a97c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/casualjim/heimdall-sandbox/releases/download/v0.1.34/heimdall-sandbox-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "aad1db6ecc4f712a9d6b0a7406256f75fc2b5f3aab466e86bcc42dd428f90057"
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
    bin.install "heimdall-sandbox", "heimdall-sandbox-inner" if OS.mac? && Hardware::CPU.arm?
    bin.install "heimdall-sandbox", "heimdall-sandbox-inner" if OS.linux? && Hardware::CPU.arm?
    bin.install "heimdall-sandbox", "heimdall-sandbox-inner" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!


# Install the WebGPU Dawn shared library.
dylib = Dir["libwebgpu_dawn.*"].first
lib.install dylib if dylib

# Add rpath so binaries find the shared library in Homebrew's lib directory.
if OS.mac?
  %w[heimdall-sandbox heimdall-sandbox-inner].each do |binary|
    p = "#{bin}/#{binary}"
    chmod "+w", p
    MachO::Tools.add_rpath(p, "@loader_path/../lib", :max_align)
    system "codesign", "--force", "--sign", "-", p
  end
end

        # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
