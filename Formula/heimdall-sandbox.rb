class HeimdallSandbox < Formula
  desc "Process sandbox runtime for Heimdall."
  homepage "https://github.com/casualjim/heimdall-sandbox"
  version "0.1.44"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/casualjim/heimdall-sandbox/releases/download/v0.1.44/heimdall-sandbox-aarch64-apple-darwin.tar.xz"
    sha256 "dfe62f7291772c81c579ed024c1cfbe1ecd1c4b9f48a2a892e834801c20ef859"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/casualjim/heimdall-sandbox/releases/download/v0.1.44/heimdall-sandbox-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "59fe76966e138f7ca82848277cc3a819c998f2726d9d9c9ad3155419e2c7fe68"
    end
    if Hardware::CPU.intel?
      url "https://github.com/casualjim/heimdall-sandbox/releases/download/v0.1.44/heimdall-sandbox-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ebe2d6616f2feef5a8475cb7b00350fba253275e2986a7d13ce0fd292ec72dbf"
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
