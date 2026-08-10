class Agentdex < Formula
  desc "Detect AI coding agents installed on the local machine"
  homepage "https://github.com/p3bot/agentdex"
  url "https://github.com/p3bot/agentdex/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "99520aa789bfdd3c147ef12d7002d3893ff2caf1c789665101e079d5126db208"
  license "MPL-2.0"

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.com/p3bot/agentdex/internal/cli.Version=#{version}
      -X github.com/p3bot/agentdex/internal/cli.Commit=62b68205df4f9f69f1f2c6e8d23f9b52d690d4cf
      -X github.com/p3bot/agentdex/internal/cli.Date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/agentdex"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/agentdex version")
  end
end
