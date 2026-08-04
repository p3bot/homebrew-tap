class Start < Formula
  desc "AI agent CLI orchestrator built on CUE"
  homepage "https://github.com/p3bot/start"
  url "https://github.com/p3bot/start/archive/refs/tags/vTODO.tar.gz"
  sha256 "TODO"
  license "MPL-2.0"

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    pkg = "github.com/p3bot/start/internal/cli"
    commit = "TODO"
    ldflags = "-s -w -X #{pkg}.cliVersion=#{version} -X #{pkg}.commit=#{commit} -X #{pkg}.buildDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/start"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/start --version")
  end
end
