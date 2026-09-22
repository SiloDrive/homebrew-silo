class Silo < Formula
  desc "Single-binary file sync server with per-library end-to-end encryption"
  homepage "https://github.com/SiloDrive/silo"
  version "0.8.0"
  license "AGPL-3.0-only"

  on_macos do
    on_arm do
      url "https://github.com/SiloDrive/silo/releases/download/v0.8.0/silo-v0.8.0-darwin-arm64.tar.gz"
      sha256 "c9a1bddb018c01ce29dd227fc28e3db48ca4da43af8d0af036c710810ed40020"
    end
    on_intel do
      url "https://github.com/SiloDrive/silo/releases/download/v0.8.0/silo-v0.8.0-darwin-amd64.tar.gz"
      sha256 "3d874d2aff5e5562a5bac30bad14d7e7e6607bc1e89b3accceacf9512f466a48"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/SiloDrive/silo/releases/download/v0.8.0/silo-v0.8.0-linux-arm64.tar.gz"
      sha256 "5fdced179b669ccd6de3fce93401265db095939a4c3151e5527a64ecc7add505"
    end
    on_intel do
      url "https://github.com/SiloDrive/silo/releases/download/v0.8.0/silo-v0.8.0-linux-amd64.tar.gz"
      sha256 "08c53bc60f67d5dff2ec8dc0c486fb13529f3a86f9785f7fcb1a8ecc103ea549"
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
