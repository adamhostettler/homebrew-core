class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https://gofeatureflag.org"
  url "https://github.com/thomaspoignant/go-feature-flag.git",
      tag:      "v1.9.0",
      revision: "fe37218eb1e928f7ae9ff8b3e6ff8deb2e4520b5"
  license "MIT"
  head "https://github.com/thomaspoignant/go-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0c325b1f7fdd9358d0e1fff692da158b1f583fb823cb3d52ee516aa8a03f7e61"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa7a05b1dde0bbd8db10879175678446681af5735c43af130aeb62e113ec2797"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aa7a05b1dde0bbd8db10879175678446681af5735c43af130aeb62e113ec2797"
    sha256 cellar: :any_skip_relocation, ventura:        "cd71532f525f432845bea175fcd46344eb0d75f31b77ebf85c8116f64c469e46"
    sha256 cellar: :any_skip_relocation, monterey:       "cd71532f525f432845bea175fcd46344eb0d75f31b77ebf85c8116f64c469e46"
    sha256 cellar: :any_skip_relocation, big_sur:        "cd71532f525f432845bea175fcd46344eb0d75f31b77ebf85c8116f64c469e46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c13f85a332a6e149e3f254f3085b0befeca3df37541a7e27b6931a4af1dfeab6"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/relayproxy"
  end

  test do
    port = free_port

    (testpath/"flags.yml").write <<~EOS
      test-flag:
        variations:
          true-var: true
          false-var: false
        defaultRule:
          variation: true-var
    EOS

    (testpath/"test.yml").write <<~EOS
      listen: #{port}
      pollingInterval: 1000
      retriever:
        kind: file
        path: #{testpath}/flags.yml
    EOS

    begin
      pid = fork do
        exec bin/"go-feature-flag-relay-proxy", "--config", "#{testpath}/test.yml"
      end
      sleep 3

      expected_output = /true/

      assert_match expected_output, shell_output("curl -s http://localhost:#{port}/health")
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
