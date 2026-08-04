class Kagi < Formula
  desc "CLI client for the Kagi FastGPT search API"
  homepage "https://github.com/p3bot/kagi"
  url "https://github.com/p3bot/kagi/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "ab7582b96ff3001e7da82c05b5435848159ff602895d5b6b2c47c4a0ad30aa63"
  license "MPL-2.0"

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kagi --version")
  end
end
