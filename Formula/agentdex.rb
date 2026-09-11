class Agentdex < Formula
  desc "Detect AI coding agents installed on the local machine"
  homepage "https://github.com/p3bot/agentdex"
  url "https://github.com/p3bot/agentdex/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "104627366829b966b2edd8dffeef05f33e92be7c677208e8a9ea33100889d7b4"
  license "MPL-2.0"

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.com/p3bot/agentdex/internal/cli.Version=#{version}
      -X github.com/p3bot/agentdex/internal/cli.Commit=731060d018bbaf700008e6278a09a3a1a9eae0f3
      -X github.com/p3bot/agentdex/internal/cli.Date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/agentdex"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/agentdex version")
  end
end
