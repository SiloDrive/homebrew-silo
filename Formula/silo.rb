class Silo < Formula
  desc "Single-binary file sync server with per-library end-to-end encryption"
  homepage "https://github.com/SiloDrive/silo"
  version "0.11.2"
  license "AGPL-3.0-only"

  on_macos do
    on_arm do
      url "https://github.com/SiloDrive/silo/releases/download/v0.11.2/silo-v0.11.2-darwin-arm64.tar.gz"
      sha256 "882f3ab23d8933a6c9b5f5b5b3376a3fe4b0daf80b10648ccfd62b4e21b076b9"
    end
    on_intel do
      url "https://github.com/SiloDrive/silo/releases/download/v0.11.2/silo-v0.11.2-darwin-amd64.tar.gz"
      sha256 "163c8e0b1d119b2005f420bd5da2058b65aec02582be03f09f537cf9ebad966d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/SiloDrive/silo/releases/download/v0.11.2/silo-v0.11.2-linux-arm64.tar.gz"
      sha256 "010950c826c96b749102f2913eefc6e34a8ce7066dd4fb9e52aa21e9624fee70"
    end
    on_intel do
      url "https://github.com/SiloDrive/silo/releases/download/v0.11.2/silo-v0.11.2-linux-amd64.tar.gz"
      sha256 "8659af08e12161e0ea4a92dfef7df0cc03013693fc1aefb4901cf2297f96eac2"
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
