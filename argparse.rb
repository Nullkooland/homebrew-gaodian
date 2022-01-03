class Argparse < Formula
  desc "Single header C++ argparse library"
  homepage "https://github.com/p-ranav/argparse"
  url "https://github.com/p-ranav/argparse/archive/refs/tags/v2.2.tar.gz"
  sha256 "f0fc6ab7e70ac24856c160f44ebb0dd79dc1f7f4a614ee2810d42bb73799872b"
  license "MIT"
  head "https://github.com/p-ranav/argparse.git"

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  def install
    args = %w[
      -G Ninja
      -D CMAKE_BUILD_TYPE=Release
    ]

    system "cmake", "-B", "Build", *std_cmake_args, *args
    system "cmake", "--build", "Build"
    system "cmake", "--build", "Build", "--target", "install"
  end
end
