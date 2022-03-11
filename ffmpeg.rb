class Ffmpeg < Formula
  desc "Play, record, convert, and stream audio and video"
  homepage "https://ffmpeg.org/"
  url "https://ffmpeg.org/releases/ffmpeg-5.0.tar.xz"
  sha256 "51e919f7d205062c0fd4fae6243a84850391115104ccf1efc451733bc0ac7298"
  license "LGPL-2.1"
  head "https://github.com/FFmpeg/FFmpeg.git"
  
  livecheck do
    url "https://ffmpeg.org/download.html"
    regex(/href=.*?ffmpeg[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  depends_on "nasm" => :build
  depends_on "pkg-config" => :build

  depends_on "dav1d"
  depends_on "goose-bomb/gaodian/svt-av1"
  depends_on "freetype"
  depends_on "goose-bomb/gaodian/libass"
  depends_on "opus"
  depends_on "fdk-aac"
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
      --enable-libsvtav1
      --enable-libdav1d
      --enable-libopus
      --enable-gpl
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

    # Fix for Non-executables that were installed to bin/
    mv bin/"python", pkgshare/"python", force: true
  end

  test do
    # Create an example mp4 file
    mp4out = testpath/"video.mp4"
    system bin/"ffmpeg", "-filter_complex", "testsrc=rate=1:duration=1", mp4out
    assert_predicate mp4out, :exist?
  end
end
