class Pj < Formula
  desc "Agent project management CLI using plain markdown files"
  homepage "https://github.com/p3bot/pj"
  url "https://github.com/p3bot/pj/archive/refs/tags/v0.0.1.tar.gz"
  sha256 "2910d7b9ce2c0bd71e7557e1e6043a4ed7fc43b07f6787b679d5409ad018c12a"
  license "MPL-2.0"

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/pj"
  end

  test do
    assert_match "plain markdown", shell_output("#{bin}/pj --help")
  end
end
