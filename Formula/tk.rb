class Tk < Formula
  desc "Agent ticket management CLI using plain markdown files"
  homepage "https://github.com/p3bot/tk"
  url "https://github.com/p3bot/tk/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "742237b60ccb8fcc86c4d8e8c9cf2f2b2438a6769e4f1a00393e9c8d7b3c1680"
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
