class Libavif < Formula
  desc "Library for encoding and decoding .avif files"
  homepage "https://github.com/AOMediaCodec/libavif"
  url "https://github.com/AOMediaCodec/libavif/archive/refs/tags/v0.9.3.tar.gz"
  sha256 "bcd9a1f57f982a9615eb7e2faf87236dc88eb1d0c886f3471c7440ead605060d"
  license "BSD-2-Clause"

  depends_on "cmake" => :build
  depends_on "nasm" => :build
  depends_on "goose-bomb/gaodian/svt-av1"
  depends_on "dav1d"
  depends_on "jpeg"
  depends_on "libpng"

  uses_from_macos "zlib"

  def install
    args = %W[
      -G Ninja
      -D CMAKE_INSTALL_RPATH=#{rpath}
      -D AVIF_CODEC_SVT=ON
      -D AVIF_CODEC_DAV1D=ON
      -D AVIF_BUILD_APPS=ON
      -D AVIF_BUILD_EXAMPLES=OFF
      -D AVIF_BUILD_TESTS=OFF
    ]

    mkdir "build" do
      system "cmake", "..", *args, *std_cmake_args
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    system bin/"avifenc", test_fixtures("test.png"), testpath/"test.avif"
    assert_path_exists testpath/"test.avif"

    system bin/"avifdec", testpath/"test.avif", testpath/"test.jpg"
    assert_path_exists testpath/"test.jpg"
  end
end
