class Snag < Formula
  desc "Browser-backed web content fetcher for AI agents"
  homepage "https://github.com/p3bot/snag"
  url "https://github.com/p3bot/snag/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "969e3133cae8c931ffb6d9fbc550e009cbac13709962682328f223b45fcf6c82"
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
