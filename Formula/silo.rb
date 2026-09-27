class Silo < Formula
  desc "Single-binary file sync server with per-library end-to-end encryption"
  homepage "https://github.com/SiloDrive/silo"
  version "0.11.1"
  license "AGPL-3.0-only"

  on_macos do
    on_arm do
      url "https://github.com/SiloDrive/silo/releases/download/v0.11.1/silo-v0.11.1-darwin-arm64.tar.gz"
      sha256 "ba71bf34db550aaf72ed8030085ecf732d2f999e5e73dc7a00e764305d648a8b"
    end
    on_intel do
      url "https://github.com/SiloDrive/silo/releases/download/v0.11.1/silo-v0.11.1-darwin-amd64.tar.gz"
      sha256 "081629b20b0d737b42d42727b96c4337a3182fb20b89c945e3e4b7e15aab53ed"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/SiloDrive/silo/releases/download/v0.11.1/silo-v0.11.1-linux-arm64.tar.gz"
      sha256 "1d5d4e61a9da899ccdd4c40543564528a28ec70ff402133b884a3c42d75af341"
    end
    on_intel do
      url "https://github.com/SiloDrive/silo/releases/download/v0.11.1/silo-v0.11.1-linux-amd64.tar.gz"
      sha256 "f4a77a82b02a57adf7d87a0a9ed43ec8af01b4befbc43809023e62d64314f50c"
    end
  end

  def install
    bin.install "silo"

    # Which package manager owns this binary. The binary inside the release
    # tarball is the tarball build, stamped InstallMethod=tarball, so without
    # this marker `silo upgrade` would tell a Homebrew user to pipe
    # install.sh into sh -- which writes a second silo to /usr/local/bin,
    # ahead of the Cellar one on PATH. The .deb, the .rpm and the AUR package
    # each write the same file; this is the fourth.
    #
    # internal/upgrade.MarkerPath reads <prefix>/share/silo/install-method,
    # derived from the binary's own location. That lands here whether
    # os.Executable resolves the symlink (Linux, via /proc/self/exe, giving
    # the Cellar path) or not (macOS, giving #{HOMEBREW_PREFIX}/bin/silo,
    # whose share/silo is the symlink `brew link` made to this one).
    (share/"silo").mkpath
    (share/"silo/install-method").write "homebrew\n"
  end

  test do
    # `silo version` prints the version with no leading v -- normalizeVersion
    # in cmd/silo/main.go strips it -- so asserting "v#{version}" here silently
    # fails for every release. Compare against the bare string.
    assert_equal version.to_s, shell_output("#{bin}/silo version").strip
  end
end
