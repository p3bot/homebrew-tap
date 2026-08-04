class Webctl < Formula
  desc "Browser automation and debugging CLI for AI agents"
  homepage "https://github.com/p3bot/webctl"
  url "https://github.com/p3bot/webctl/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "caf75293456b4e7e42d1ec3f502d4ccccb281e1af68852a61966840935d62baf"
  license "MPL-2.0"

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-s -w -X github.com/p3bot/webctl/internal/cli.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/webctl"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/webctl --version")
  end
end
