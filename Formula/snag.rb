class Snag < Formula
  desc "Browser-backed web content fetcher for AI agents"
  homepage "https://github.com/p3bot/snag"
  url "https://github.com/p3bot/snag/archive/refs/tags/v1.1.3.tar.gz"
  sha256 "3d625ca8998e1708353b3590e47180fcfb9e9bb9db7aed47ada0cfc5fd66eb46"
  license "MPL-2.0"

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snag --version")
  end
end
