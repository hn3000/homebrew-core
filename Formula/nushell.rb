class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/0.4.0.tar.gz"
  sha256 "7111d3067db3dabc6137e8a441670de0fae63deae522d1675fc77402948f2c67"
  revision 1
  head "https://github.com/nushell/nushell.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1d4472e6f82b1f9b0b8da4a59d641d56d8da15c2ba6c8b9069dad0c94fe0c93c" => :catalina
    sha256 "78e24987e5f9697452966b7476733d2125319faf9b9ee746c023769e3cdd92a4" => :mojave
    sha256 "3e06fbbb3fde18b3ebb2d1e6282a5b0b2eacbc9f29f0703db95c0173514bb13c" => :high_sierra
    sha256 "8a7835a0ac11682f9f4a95ec92db6617252bb3bb2295996a812f28b47af19002" => :sierra
  end

  depends_on "openssl@1.1"

  # Nu requires features from Rust 1.39 to build, so we can't use Homebrew's
  # Rust; picking a known-good Rust nightly release to use instead.
  resource "rust-nightly" do
    url "https://static.rust-lang.org/dist/2019-09-25/rust-beta-x86_64-apple-darwin.tar.xz"
    sha256 "11feba2542e079b2deacf6edf6a9e62b34ad6e0f509dd11e11db3a66d16565c7"
  end

  def install
    resource("rust-nightly").stage do
      system "./install.sh", "--prefix=#{buildpath}/rust-nightly"
      ENV.prepend_path "PATH", "#{buildpath}/rust-nightly/bin"
    end
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    assert_equal "#{Dir.pwd}> 2\n#{Dir.pwd}> CTRL-D\n", pipe_output("#{bin}/nu", 'echo \'{"foo":1, "bar":2}\' | from-json | get bar | echo $it')
  end
end
