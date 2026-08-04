class Kagi < Formula
  desc "CLI client for the Kagi FastGPT search API"
  homepage "https://github.com/p3bot/kagi"
  url "https://github.com/p3bot/kagi/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "c8fd5fe1ac1d355d74a87917d90c0ca2e8b89c775b01fe74e8288fea31585d45"
  license "MPL-2.0"

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kagi --version")
  end
end
