class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://github.com/harfbuzz/harfbuzz"
  url "https://github.com/harfbuzz/harfbuzz/archive/4.2.0.tar.gz"
  sha256 "7152d1bdcbd2bf6ba777cfe9161d40564fe0a7583e04e55e0a057d5f4414d3c9"
  license "MIT"
  head "https://github.com/harfbuzz/harfbuzz.git", branch: "main"

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "freetype"

  resource "ttf" do
    url "https://github.com/harfbuzz/harfbuzz/raw/fc0daafab0336b847ac14682e581a8838f36a0bf/test/shaping/fonts/sha1sum/270b89df543a7e48e206a2d830c0e10e5265c630.ttf"
    sha256 "9535d35dab9e002963eef56757c46881f6b3d3b27db24eefcc80929781856c77"
  end

  def install
    args = %w[
      -G Ninja
      -D CMAKE_BUILD_TYPE=Release
      -D BUILD_SHARED_LIBS=ON
      -D HB_HAVE_FREETYPE=ON
      -D HB_BUILD_SUBSET=OFF
    ]

    system "cmake", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--build", "build", "--target", "install"
  end

  test do
    resource("ttf").stage do
      shape = `echo 'സ്റ്റ്' | #{bin}/hb-shape 270b89df543a7e48e206a2d830c0e10e5265c630.ttf`.chomp
      assert_equal "[glyph201=0+1183|U0D4D=0+0]", shape
    end
  end
end
