class Termrec < Formula
  desc "Record videos of terminal output"
  homepage "https://angband.pl/termrec.html"
  url "https://github.com/kilobyte/termrec/archive/refs/tags/v0.19.tar.gz"
  sha256 "0550c12266ac524a8afb764890c420c917270b0a876013592f608ed786ca91dc"
  license "LGPL-3.0-or-later"
  head "https://github.com/kilobyte/termrec.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2b08f0b04c98a5152357e074c14027a63b64ccbd4814f4c04235eef9d2862942"
    sha256 cellar: :any,                 arm64_monterey: "3c45928def623126f5999ab77cd48cc6711731a44cfa28c5746841ee19f313c3"
    sha256 cellar: :any,                 arm64_big_sur:  "a03a052b7ee89450b145a866724f6f97727c56bbf0220a14a089c84951aeed35"
    sha256 cellar: :any,                 ventura:        "df2afb4aa2443fdb4ff692e87b076edc753effa283ffc3a7ade6b6957a7702b1"
    sha256 cellar: :any,                 monterey:       "634617e61f1492c473f62bfa37cf742e5fc4e7b0e36339ddc1f6b8574ed90272"
    sha256 cellar: :any,                 big_sur:        "81060090e19bbb56f0b991dfa987eb890c00b116b656be2d2bd29ea027f9496a"
    sha256 cellar: :any,                 catalina:       "1d93149ec34c0bf531da76b0137390ed1f05bf2e35e806f1fe875fe6648c4c2b"
    sha256 cellar: :any,                 mojave:         "e3f9f241763a05de367da2ee91727674e18a126a99480a750b901a21bdad0ffb"
    sha256 cellar: :any,                 high_sierra:    "d6cb43ed14ec0531824bd4eb55ddc625b5711c28b274ce78eb815501e5f3ebf2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "367ae28f9b68565c985f0762a0781ac1df02267fa34b47806477456dc0d22e5f"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "xz"

  uses_from_macos "zlib"

  def install
    # Work around build error: call to undeclared function 'forkpty'
    # Issue ref: https://github.com/kilobyte/termrec/issues/8
    ENV.append "CFLAGS", "-include util.h" if DevelopmentTools.clang_build_version >= 1403

    system "./autogen.sh"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"termrec", "--help"
  end
end
