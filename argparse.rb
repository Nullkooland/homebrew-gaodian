class Argparse < Formula
  desc "Single header C++ argparse library"
  homepage "https://github.com/p-ranav/argparse"
  url "https://github.com/p-ranav/argparse/archive/refs/tags/v2.3.tar.gz"
  sha256 "6895d0f30d250ebb58bd93c1f07dbbcd0234216cb99ccc3ad211aa769bc5cf43"
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
