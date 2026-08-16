class Agentdex < Formula
  desc "Detect AI coding agents installed on the local machine"
  homepage "https://github.com/p3bot/agentdex"
  url "https://github.com/p3bot/agentdex/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "1ef62982e98f651e2e96578e549e75235ec61a55a430097612a918ae63e84f45"
  license "MPL-2.0"

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.com/p3bot/agentdex/internal/cli.Version=#{version}
      -X github.com/p3bot/agentdex/internal/cli.Commit=f5b3e3d2adc5df0cd8c5658ddc9ec8fa4c1958b5
      -X github.com/p3bot/agentdex/internal/cli.Date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/agentdex"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/agentdex version")
  end
end
