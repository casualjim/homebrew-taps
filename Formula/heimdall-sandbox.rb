class HeimdallSandbox < Formula
  desc "Process sandbox runtime for Heimdall."
  homepage "https://github.com/casualjim/heimdall-sandbox"
  version "0.1.25"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/casualjim/heimdall-sandbox/releases/download/v0.1.25/heimdall-sandbox-aarch64-apple-darwin.tar.xz"
    sha256 "ae427c3a3fadc10b565271e852aee307b95bac72d0e7e3876622989b65559136"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/casualjim/heimdall-sandbox/releases/download/v0.1.25/heimdall-sandbox-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "20466872dcb42994e836aee230d2ebf6ca3248a5e8ba109171c126103c66468b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/casualjim/heimdall-sandbox/releases/download/v0.1.25/heimdall-sandbox-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "cfe4290aca826e115439459c39893074328894e901db38c37f9716b08e39bad9"
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

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?

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

  end
end
