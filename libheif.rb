class Libheif < Formula
  desc "ISO/IEC 23008-12:2017 HEIF file format decoder and encoder"
  homepage "https://www.libde265.org/"
  url "https://github.com/strukturag/libheif/releases/download/v1.12.0/libheif-1.12.0.tar.gz"
  sha256 "e1ac2abb354fdc8ccdca71363ebad7503ad731c84022cf460837f0839e171718"
  license "LGPL-3.0-only"
  head "https://github.com/strukturag/libheif"

  depends_on "pkg-config" => :build
  depends_on "cmake" => :build
  depends_on "ninja" => :build
  
  depends_on "aom"
  depends_on "dav1d"
  depends_on "jpeg"
  depends_on "libde265"
  depends_on "libpng"
  depends_on "x265"

  def install
    args = %w[
      -G Ninja
      -D CMAKE_BUILD_TYPE=Release
      -D BUILD_SHARED_LIBS=ON
    ]
    
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, *args
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    output = "File contains 2 images"
    example = "examples/example.heic"
    exout = testpath/"exampleheic.jpg"

    assert_match output, shell_output("#{bin}/heif-convert #{example} #{exout}")
    assert_predicate testpath/"exampleheic-1.jpg", :exist?
    assert_predicate testpath/"exampleheic-2.jpg", :exist?

    output = "File contains 1 images"
    example = "examples/example.avif"
    exout = testpath/"exampleavif.jpg"

    assert_match output, shell_output("#{bin}/heif-convert #{example} #{exout}")
    assert_predicate testpath/"exampleavif.jpg", :exist?
  end
end
