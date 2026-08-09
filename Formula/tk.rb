class Tk < Formula
  desc "Agent ticket management CLI using plain markdown files"
  homepage "https://github.com/p3bot/tk"
  url "https://github.com/p3bot/tk/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "d1f52da551d4cf9dcddd20a26f68a0df5909e0c25822b1a5065fa2bfa3ca28d4"
  license "MPL-2.0"

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.com/p3bot/tk/internal/cli.cliVersion=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/tk"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tk --version")
  end
end
