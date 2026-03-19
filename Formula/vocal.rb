class Vocal < Formula
  desc "Local speech recognition, synthesis, and voice cloning"
  homepage "https://github.com/offbeatengineer/vocal"
  url "https://github.com/offbeatengineer/vocal/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "PLACEHOLDER"
  license "MIT"

  depends_on "cmake" => :build

  resource "ggml" do
    url "https://github.com/ggerganov/ggml/archive/a8db410a252c8c8f2d120c6f2e7133ebe032f35d.tar.gz"
    sha256 "3f6acec7660e784325214c2d53d45035c426d28b8763266f0ef3cdc9f9f1d103"
  end

  def install
    (buildpath/"third_party/ggml").install resource("ggml")

    ggml_args = %w[-DCMAKE_BUILD_TYPE=Release]
    ggml_args << "-DGGML_METAL=ON" if OS.mac?
    system "cmake", "-B", "third_party/ggml/build", "-S", "third_party/ggml", *ggml_args
    system "cmake", "--build", "third_party/ggml/build", "--parallel"

    system "cmake", "-B", "build", "-DCMAKE_BUILD_TYPE=Release",
           "-DCMAKE_INSTALL_PREFIX=#{prefix}"
    system "cmake", "--build", "build", "--parallel"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"vocal", "version"
  end
end
