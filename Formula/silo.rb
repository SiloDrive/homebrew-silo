class Silo < Formula
  desc "Single-binary file sync server with per-library end-to-end encryption"
  homepage "https://silodrive.io"
  version "0.13.0"
  license "AGPL-3.0-only"

  on_macos do
    on_arm do
      url "https://silodrive.io/alpha/download/silo/silo-v0.13.0-darwin-arm64.tar.gz"
      sha256 "63230e740536226e41ff3a18baef827701cc6f538eb0572fcd72cabfc814d0da"
    end
    on_intel do
      url "https://silodrive.io/alpha/download/silo/silo-v0.13.0-darwin-amd64.tar.gz"
      sha256 "a946ca3a984d9073f620bb62dc628bc8d5271799b5cbf707258c42c3415d4dcf"
    end
  end

  on_linux do
    on_arm do
      url "https://silodrive.io/alpha/download/silo/silo-v0.13.0-linux-arm64.tar.gz"
      sha256 "29b765ae96677e3f273eee0680c244af997c88b5740527efa1c18e33e52a407d"
    end
    on_intel do
      url "https://silodrive.io/alpha/download/silo/silo-v0.13.0-linux-amd64.tar.gz"
      sha256 "a02f91dca7abc5fce200f4d99c8f7fd8a4a3402c2c59ac134a5a2ee483d018a9"
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
    # silo-upgrade's marker_path (Go's internal/upgrade.MarkerPath before
    # it) reads <prefix>/share/silo/install-method, derived from the
    # binary's own location. That lands here whether the executable's path
    # resolves the symlink (Linux, via /proc/self/exe, giving
    # the Cellar path) or not (macOS, giving #{HOMEBREW_PREFIX}/bin/silo,
    # whose share/silo is the symlink `brew link` made to this one).
    (share/"silo").mkpath
    (share/"silo/install-method").write "homebrew\n"
  end

  test do
    # `silo version` prints the version with no leading v -- normalize_version
    # in crates/silo/src/main.rs strips it -- so asserting "v#{version}" here silently
    # fails for every release. Compare against the bare string.
    assert_equal version.to_s, shell_output("#{bin}/silo version").strip
  end
end
