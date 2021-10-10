class Ffmpeg < Formula
  desc "Play, record, convert, and stream audio and video"
  homepage "https://ffmpeg.org/"
  url "https://github.com/FFmpeg/FFmpeg/archive/refs/tags/n4.4.tar.gz"
  version "4.4-with-options" # to distinguish from homebrew-core's ffmpeg
  sha256 "bea6d9f91cdbe4c5ad98e0878955ad5077df3883ef321fd4668ee1076de793fe"
  license "GPL-2.0-or-later"
  head "https://github.com/FFmpeg/FFmpeg.git"

  depends_on "nasm" => :build
  depends_on "pkg-config" => :build
  depends_on "texinfo" => :build

  depends_on "aom"
  depends_on "dav1d"
  depends_on "freetype"
  depends_on "goose-bomb/gaodian/libass"
  depends_on "opus"
  depends_on "fdk-aac"
  depends_on "x264"
  depends_on "x265"
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    args = %W[
      --prefix=#{prefix}
      --enable-shared
      --cc=#{ENV.cc}
      --host-cflags=#{ENV.cflags}
      --host-ldflags=#{ENV.ldflags}
      --enable-libaom
      --enable-libdav1d
      --enable-libopus
      --enable-gpl
      --enable-libx264
      --enable-libx265
      --enable-libfreetype
      --enable-libass
      --enable-nonfree
      --enable-libfdk-aac
      --enable-opencl
      --enable-videotoolbox
      --disable-doc
    ]

    system "./configure", *args
    system "make", "install"

    # Build and install additional FFmpeg tools
    system "make", "alltools"
    bin.install Dir["tools/*"].select { |f| File.executable? f }
    mv bin/"python", pkgshare/"python", force: true
  end

  test do
    # Create an example mp4 file
    mp4out = testpath/"video.mp4"
    system bin/"ffmpeg", "-filter_complex", "testsrc=rate=1:duration=1", mp4out
    assert_predicate mp4out, :exist?
  end
end
