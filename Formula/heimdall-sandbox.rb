class HeimdallSandbox < Formula
  desc "Process sandbox runtime for Heimdall."
  homepage "https://github.com/casualjim/heimdall-sandbox"
  version "0.1.24"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/casualjim/heimdall-sandbox/releases/download/v0.1.24/heimdall-sandbox-aarch64-apple-darwin.tar.xz"
    sha256 "0526a215eb8386785860e27a5c2a8a3a8f6fa3383664b90cf3e2828b79b7eb47"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/casualjim/heimdall-sandbox/releases/download/v0.1.24/heimdall-sandbox-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e6bb414ac016b699cf40b64ea82781a6e06e55bd027bcf0d50ec304bc851f489"
    end
    if Hardware::CPU.intel?
      url "https://github.com/casualjim/heimdall-sandbox/releases/download/v0.1.24/heimdall-sandbox-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "883cab54a16ce3394d7dbd9f4693e13c1c5210fcd9119f6e275868c4532a5513"
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
        bin.install_symlink bin.source.to_s => dest
      end
    end
  end

  def install
    bin.install "heimdall-sandbox", "heimdall-sandbox-inner" if OS.mac? && Hardware::CPU.arm?
    bin.install "heimdall-sandbox", "heimdall-sandbox-inner" if OS.linux? && Hardware::CPU.arm?
    bin.install "heimdall-sandbox", "heimdall-sandbox-inner" if OS.linux? && Hardware::CPU.intel?

    dylib = Dir["libwebgpu_dawn.*"].first
    lib.install dylib if dylib

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?

    # Patch rpath into the binaries so they find libwebgpu_dawn in Homebrew's lib.
    return unless OS.mac?

    %w[heimdall-sandbox heimdall-sandbox-inner].each do |binary|
      path = "#{bin}/#{binary}"
      chmod "+w", path
      MachO::Tools.add_rpath(path, "@loader_path/../lib", :max_align)
      system "codesign", "--force", "--sign", "-", path
    end
  end
end
