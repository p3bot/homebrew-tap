class Snag < Formula
  desc "Browser-backed web content fetcher for AI agents"
  homepage "https://github.com/p3bot/snag"
  url "https://github.com/p3bot/snag/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "f5a756b793791183c8085a16b7b712ae9947731297e89ff2bab2525bc222c3e6"
  license "MPL-2.0"

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snag --version")
  end
end
