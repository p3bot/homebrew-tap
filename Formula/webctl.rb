class Webctl < Formula
  desc "Browser automation and debugging CLI for AI agents"
  homepage "https://github.com/p3bot/webctl"
  url "https://github.com/p3bot/webctl/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "ce4a1f99024808e88f119a399ec2c65bcfc3fb997960647f819a1de4576bfb8a"
  license "MPL-2.0"

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    # v0.2.0 still uses the pre-org module path for package symbols.
    ldflags = "-s -w -X github.com/grantcarthew/webctl/internal/cli.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/webctl"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/webctl --version")
  end
end
