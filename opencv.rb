class Opencv < Formula
  desc "Open source computer vision library"
  homepage "https://opencv.org/"
  url "https://github.com/opencv/opencv/archive/4.7.0.tar.gz"
  sha256 "8df0079cdbe179748a18d44731af62a245a45ebf5085223dc03133954c662973"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "pkg-config" => :build
  depends_on "cmake" => :build
  depends_on "ninja" => :build
  
  depends_on "goose-bomb/gaodian/ffmpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "protobuf@3"
  depends_on "python@3.10"
  depends_on "tbb"
  depends_on "freetype"
  
  uses_from_macos "zlib"

  def install
    args = %W[
      -G Ninja
      -D CMAKE_BUILD_TYPE=Release
      -D BUILD_SHARED_LIBS=ON
      -D CPU_BASELINE=AVX2
      -D WITH_TBB=ON
      -D WITH_IPP=OFF
      -D WITH_LAPACK=ON
      -D WITH_OPENCL=ON
      -D OPENCV_DNN_OPENCL=ON
      -D WITH_FREETYPE=ON
      -D BUILD_ZLIB=OFF
      -D BUILD_IPP_IW=OFF
      -D BUILD_JASPER=OFF
      -D BUILD_OPENJPEG=OFF
      -D BUILD_JPEG=ON
      -D BUILD_OPENEXR=OFF
      -D BUILD_PNG=OFF
      -D BUILD_PROTOBUF=OFF
      -D BUILD_TIFF=OFF
      -D BUILD_WEBP=OFF
      -D BUILD_JAVA=OFF
      -D BUILD_OBJC=OFF
      -D PROTOBUF_UPDATE_FILES=ON
      -D WITH_1394=OFF
      -D WITH_CUDA=OFF
      -D WITH_FFMPEG=ON
      -D WITH_GPHOTO2=OFF
      -D WITH_GSTREAMER=OFF
      -D WITH_WEBP=OFF
      -D WITH_JASPER=OFF
      -D WITH_OPENJPEG=OFF
      -D WITH_OPENEXR=OFF
      -D WITH_OPENGL=OFF
      -D WITH_IMGCODEC_SUNRASTER=OFF
      -D WITH_VTK=OFF
      -D BUILD_LIST=core,gapi,imgproc,imgcodes,videoio,video,ml,flann,dnn,features2d,objdetect,photo,optflow,calib3d,stitching,highgui,python3
      -D BUILD_opencv_apps=OFF
      -D BUILD_opencv_python2=OFF
      -D BUILD_opencv_python3=ON
      -D BUILD_TESTS=OFF
      -D BUILD_PERF_TESTS=OFF
      -D BUILD_EXAMPLES=OFF
      -D INSTALL_C_EXAMPLES=OFF
      -D INSTALL_PYTHON_EXAMPLES=OFF
      -D OPENCV_GENERATE_PKGCONFIG=ON
    ]

    system "cmake", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--build", "build", "--target", "install"

    # Prevent dependents from using fragile Cellar paths.
    inreplace lib/"pkgconfig/opencv#{version.major}.pc", prefix, opt_prefix
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <opencv2/opencv.hpp>
      #include <iostream>
      int main() {
        std::cout << CV_VERSION << std::endl;
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++17", "test.cpp", "-I#{include}/opencv4",
                    "-o", "test"
    assert_equal `./test`.strip, version.to_s

    output = shell_output(Formula["python@3.10"].opt_bin/"python3 -c 'import cv2; print(cv2.__version__)'")
    assert_equal version.to_s, output.chomp
  end
end
