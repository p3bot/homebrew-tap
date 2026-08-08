class Tk < Formula
  desc "Agent ticket management CLI using plain markdown files"
  homepage "https://github.com/p3bot/tk"
  url "https://github.com/p3bot/tk/archive/refs/tags/v0.0.0-placeholder.tar.gz"
  sha256 "0000000000000000000000000000000000000000000000000000000000000000"
  license "MPL-2.0"

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/tk"
  end

  test do
    assert_match "plain markdown", shell_output("#{bin}/tk --help")
  end
end
