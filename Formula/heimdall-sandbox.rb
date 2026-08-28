class HeimdallSandbox < Formula
  desc "Process sandbox runtime for Heimdall."
  homepage "https://github.com/casualjim/heimdall-sandbox"
  version "0.2.4"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/casualjim/heimdall-sandbox/releases/download/v0.2.4/heimdall-sandbox-aarch64-apple-darwin.tar.xz"
    sha256 "a9cd4504e80635619c6d8f1c5a95f7549d9c309205c3ef541db35693b1c748e1"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/casualjim/heimdall-sandbox/releases/download/v0.2.4/heimdall-sandbox-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "134608f56ec7f82ed4ed1f87ee813687c778e4d2135608a61238e851ac4a63ce"
    end
    if Hardware::CPU.intel?
      url "https://github.com/casualjim/heimdall-sandbox/releases/download/v0.2.4/heimdall-sandbox-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "800a52b9828338d93c9401a7a5eb8b2439a92afdb000960c0d0ac164460d0518"
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
