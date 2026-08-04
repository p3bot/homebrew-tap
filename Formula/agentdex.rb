class Agentdex < Formula
  desc "Detect AI coding agents installed on the local machine"
  homepage "https://github.com/p3bot/agentdex"
  url "https://github.com/p3bot/agentdex/archive/refs/tags/v0.0.1.tar.gz"
  sha256 "e0e8d4b1e9fe16ab171c578188a47c1a764c6adbcec006e93ecb579161721f65"
  license "MPL-2.0"

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    # v0.0.1 still uses the pre-org module path for package symbols.
    ldflags = %W[
      -s -w
      -X github.com/start-cli/agentdex/internal/cli.Version=#{version}
      -X github.com/start-cli/agentdex/internal/cli.Commit=56aaa3ce8d047d3af17fe275e1c1c3ecc5e4db86
      -X github.com/start-cli/agentdex/internal/cli.Date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/agentdex"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/agentdex version")
  end
end
