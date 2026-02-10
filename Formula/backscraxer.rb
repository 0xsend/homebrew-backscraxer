class Backscraxer < Formula
  desc "CLI tool for ingesting twitterapi.io tweets and media into local SQLite"
  homepage "https://github.com/0xsend/backscraXer"
  # Template formula in source repo; release workflow writes concrete checksums to tap repo.
  version "0.0.1"
  license "UNLICENSED"

  on_macos do
    on_arm do
      url "https://github.com/0xsend/backscraXer/releases/download/v#{version}/backscraxer-darwin-arm64"
      sha256 "REPLACE_WITH_ACTUAL_DARWIN_ARM64_SHA256_ON_RELEASE"
    end

    on_intel do
      url "https://github.com/0xsend/backscraXer/releases/download/v#{version}/backscraxer-darwin-x64"
      sha256 "REPLACE_WITH_ACTUAL_DARWIN_X64_SHA256_ON_RELEASE"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/0xsend/backscraXer/releases/download/v#{version}/backscraxer-linux-x64"
      sha256 "REPLACE_WITH_ACTUAL_LINUX_X64_SHA256_ON_RELEASE"
    end
  end

  def install
    binary_name = if OS.mac?
      Hardware::CPU.arm? ? "backscraxer-darwin-arm64" : "backscraxer-darwin-x64"
    else
      "backscraxer-linux-x64"
    end

    bin.install binary_name => "backscraxer"
  end

  test do
    output = shell_output("#{bin}/backscraxer docs:get-endpoints --format json")
    json = JSON.parse(output)
    assert_operator json.length, :>, 0
    assert_includes json.map { |e| e["key"] }, "user.info"
  end

  def caveats
    <<~EOS
      First-run setup:
        backscraxer setup

      Install agent skill files:
        backscraxer install --target codex
        backscraxer install --target claude
        backscraxer install --target cursor
    EOS
  end
end
