class Libass < Formula
  desc "Subtitle renderer for the ASS/SSA subtitle format"
  homepage "https://github.com/libass/libass"
  url "https://github.com/libass/libass/releases/download/0.16.0/libass-0.16.0.tar.xz"
  sha256 "5dbde9e22339119cf8eed59eea6c623a0746ef5a90b689e68a090109078e3c08"
  license "ISC"
  head "https://github.com/libass/libass.git"

  depends_on "nasm" => :build
  depends_on "pkg-config" => :build

  depends_on "freetype"
  depends_on "fribidi"
  depends_on "goose-bomb/gaodian/harfbuzz"
  
  def install
    args = %W[
      --disable-fontconfig
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "ass/ass.h"
      int main() {
        ASS_Library *library;
        ASS_Renderer *renderer;
        library = ass_library_init();
        if (library) {
          renderer = ass_renderer_init(library);
          if (renderer) {
            ass_renderer_done(renderer);
            ass_library_done(library);
            return 0;
          }
          else {
            ass_library_done(library);
            return 1;
          }
        }
        else {
          return 1;
        }
      }
    EOS
    system ENV.cc, "test.cpp", "-I#{include}", "-L#{lib}", "-lass", "-o", "test"
    system "./test"
  end
end
