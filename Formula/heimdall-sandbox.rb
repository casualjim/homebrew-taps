class HeimdallSandbox < Formula
  desc "Process sandbox runtime for Heimdall."
  homepage "https://github.com/casualjim/heimdall-sandbox"
  version "0.2.3"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/casualjim/heimdall-sandbox/releases/download/v0.2.3/heimdall-sandbox-aarch64-apple-darwin.tar.xz"
    sha256 "686d223eb438406807e0b23707d28d583e4e31d1d44a171771f6e97cfb6778ea"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/casualjim/heimdall-sandbox/releases/download/v0.2.3/heimdall-sandbox-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f770107e804934c964220141108e98c938bdd8e5ae413342b9090d9b5cbe0603"
    end
    if Hardware::CPU.intel?
      url "https://github.com/casualjim/heimdall-sandbox/releases/download/v0.2.3/heimdall-sandbox-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4375b80905aa0d181913b75bfd7f65e8659d02617675cbc890d5ef82c80d5011"
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
