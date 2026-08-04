class Start < Formula
  desc "AI agent CLI orchestrator built on CUE"
  homepage "https://github.com/p3bot/start"
  url "https://github.com/p3bot/start/archive/refs/tags/v0.0.1.tar.gz"
  sha256 "b5e23e892301133d9ebad343b3531f6d49a0e45cd4b72af3cf35812a9c3325f6"
  license "MPL-2.0"

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    pkg = "github.com/p3bot/start/internal/cli"
    ldflags = %W[
      -s -w
      -X #{pkg}.cliVersion=#{version}
      -X #{pkg}.commit=877986d9d00af8cfaaa5575f64e4c9c9ee364348
      -X #{pkg}.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/start"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/start --version")
  end
end
