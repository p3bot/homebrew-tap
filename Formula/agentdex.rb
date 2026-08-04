class Agentdex < Formula
  desc "Detect AI coding agents installed on the local machine"
  homepage "https://github.com/p3bot/agentdex"
  url "https://github.com/p3bot/agentdex/archive/refs/tags/v0.0.2.tar.gz"
  sha256 "83d3035d30044f8a5d002ac30d3a991b7e21b170ec3b5cd743a34b0c29a843da"
  license "MPL-2.0"

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.com/p3bot/agentdex/internal/cli.Version=#{version}
      -X github.com/p3bot/agentdex/internal/cli.Commit=198756a48c98182a90adee0c7c2330ad8999292c
      -X github.com/p3bot/agentdex/internal/cli.Date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/agentdex"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/agentdex version")
  end
end
