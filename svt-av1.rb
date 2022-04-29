class SvtAv1 < Formula
  desc "The Scalable Video Technology for AV1 (SVT-AV1 Encoder and Decoder)"
  homepage "https://gitlab.com/AOMediaCodec/SVT-AV1"
  url "https://gitlab.com/AOMediaCodec/SVT-AV1/-/archive/v1.0.0/SVT-AV1-v1.0.0.tar.gz"
  sha256 "84030ef7f33645ddfcdd2dc8a08277e49f3c4297fc53711958060c8ce51dc22d"
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

    system "cmake", "-B", "Build", *std_cmake_args, *args
    system "cmake", "--build", "Build"
    system "cmake", "--build", "Build", "--target", "install"
  end
end
