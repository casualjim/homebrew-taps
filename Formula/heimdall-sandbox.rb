class HeimdallSandbox < Formula
  desc "Process sandbox runtime for Heimdall."
  homepage "https://github.com/casualjim/heimdall"
  version "0.1.7"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/casualjim/heimdall/releases/download/v0.1.7/heimdall-sandbox-aarch64-apple-darwin.tar.xz"
    sha256 "1a8e2fa186711a662ebed027f235babcd0bf2c4d283d970aa1f4691f19f19ee8"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/casualjim/heimdall/releases/download/v0.1.7/heimdall-sandbox-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "bd7aabe7a1a551046b539daacf260e8057cbc932e2bba3385cbab75b9deacd11"
    end
    if Hardware::CPU.intel?
      url "https://github.com/casualjim/heimdall/releases/download/v0.1.7/heimdall-sandbox-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "21155943fc84a49ff457bda978b5e48d21b13f7978f9416f4e831edc18d14724"
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

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
