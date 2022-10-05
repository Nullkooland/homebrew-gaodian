class SvtAv1 < Formula
  desc "The Scalable Video Technology for AV1 (SVT-AV1 Encoder and Decoder)"
  homepage "https://gitlab.com/AOMediaCodec/SVT-AV1"
  url "https://gitlab.com/AOMediaCodec/SVT-AV1/-/archive/v1.2.1/SVT-AV1-v1.2.1.tar.gz"
  sha256 "5c2466eb2990fa045b29c63b92a2b5f13d9cb841709df5e7206f96a59e119fdd"
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
      -D BUILD_TESTING=OFF
      -D BUILD_ENC=ON
      -D BUILD_DEC=OFF
      -D BUILD_APPS=OFF
    ]

    system "cmake", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--build", "build", "--target", "install"
  end
end
