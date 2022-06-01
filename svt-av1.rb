class SvtAv1 < Formula
  desc "The Scalable Video Technology for AV1 (SVT-AV1 Encoder and Decoder)"
  homepage "https://gitlab.com/AOMediaCodec/SVT-AV1"
  url "https://gitlab.com/AOMediaCodec/SVT-AV1/-/archive/v1.1.0/SVT-AV1-v1.1.0.tar.gz"
  sha256 "1c211b944ac83ef013fe91aee96c01289da4e3762c1e2f265449f3a964f8e4bc"
  license "BSD-3-clause-clear"
  head "https://gitlab.com/AOMediaCodec/SVT-AV1.git"

  depends_on "nasm" => :build
  depends_on "cmake" => :build
  depends_on "ninja" => :build

  def install
    args = %w[
      -G Ninja
      -D CMAKE_BUILD_TYPE=Release
      -D BUILD_SHARED_LIBS=ON
      -D ENABLE_NASM=ON
      -D BUILD_DEC=OFF
      -D BUILD_TESTING=OFF
      -D BUILD_APPS=OFF
    ]

    system "cmake", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--build", "build", "--target", "install"
  end
end
