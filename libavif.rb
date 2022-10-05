class Libavif < Formula
  desc "Library for encoding and decoding .avif files"
  homepage "https://github.com/AOMediaCodec/libavif"
  url "https://github.com/AOMediaCodec/libavif/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "66e82854ceb84a3e542bc140a343bc90e56c68f3ecb4fff63e636c136ed9a05e"
  license "BSD-2-Clause"

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "nasm" => :build
  
  depends_on "goose-bomb/gaodian/svt-av1"
  depends_on "dav1d"
  depends_on "jpeg-turbo"
  depends_on "libpng"

  uses_from_macos "zlib"

  def install
    args = %W[
      -G Ninja
      -D AVIF_CODEC_SVT=ON
      -D AVIF_CODEC_DAV1D=ON
      -D AVIF_BUILD_APPS=ON
      -D AVIF_BUILD_EXAMPLES=OFF
      -D AVIF_BUILD_TESTS=OFF
      -D JPEG_LIBRARY=#{Formula["jpeg-turbo"].opt_lib}/libjpeg.dylib
      -D JPEG_INCLUDE_DIR=#{Formula["jpeg-turbo"].opt_include}
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
