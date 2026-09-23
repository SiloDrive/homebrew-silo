class Silo < Formula
  desc "Single-binary file sync server with per-library end-to-end encryption"
  homepage "https://github.com/SiloDrive/silo"
  version "0.9.0"
  license "AGPL-3.0-only"

  on_macos do
    on_arm do
      url "https://github.com/SiloDrive/silo/releases/download/v0.9.0/silo-v0.9.0-darwin-arm64.tar.gz"
      sha256 "5174c6705103a6afc7a597fb4d42a3d4d155cb0f256e7774094e00e098f5059b"
    end
    on_intel do
      url "https://github.com/SiloDrive/silo/releases/download/v0.9.0/silo-v0.9.0-darwin-amd64.tar.gz"
      sha256 "6356d6ef7197aed79b1a368bbe71714631926ed0e175b1e1b419d221c1a26b67"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/SiloDrive/silo/releases/download/v0.9.0/silo-v0.9.0-linux-arm64.tar.gz"
      sha256 "2cce990e06518a07fd2201fed9fc4120b8890421c7513124962d995427352a37"
    end
    on_intel do
      url "https://github.com/SiloDrive/silo/releases/download/v0.9.0/silo-v0.9.0-linux-amd64.tar.gz"
      sha256 "5f367ff36a3b69294fbd6a0ea9ce5149c4453846bcd73eb095eb0b9ad4ee2642"
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
