class Opencv < Formula
  desc "Open source computer vision library"
  homepage "https://opencv.org/"
  url "https://github.com/opencv/opencv/archive/4.6.0.tar.gz"
  sha256 "1ec1cba65f9f20fe5a41fda1586e01c70ea0c9a6d7b67c9e13edf0cfe2239277"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "pkg-config" => :build
  depends_on "cmake" => :build
  depends_on "ninja" => :build
  
  depends_on "goose-bomb/gaodian/ffmpeg"
  depends_on "goose-bomb/gaodian/harfbuzz"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "protobuf"
  depends_on "python@3.10"
  depends_on "tbb"
  
  uses_from_macos "zlib"

  resource "contrib" do
    url "https://github.com/opencv/opencv_contrib/archive/4.6.0.tar.gz"
    sha256 "1777d5fd2b59029cf537e5fd6f8aa68d707075822f90bde683fcde086f85f7a7"
  end

  def install
    resource("contrib").stage buildpath/"opencv_contrib"

    # Remove bundled libraries to make sure formula dependencies are used
    libdirs = %w[ffmpeg libjasper libjpeg libjpeg-turbo libpng libtiff libwebp openexr openjpeg protobuf tbb zlib]
    libdirs.each { |l| (buildpath/"3rdparty"/l).rmtree }

    args = %W[
      -G Ninja
      -D CMAKE_BUILD_TYPE=Release
      -D BUILD_SHARED_LIBS=ON
      -D OPENCV_EXTRA_MODULES_PATH=#{buildpath}/opencv_contrib/modules
      -D CPU_BASELINE=AVX2
      -D WITH_TBB=ON
      -D WITH_IPP=OFF
      -D WITH_LAPACK=ON
      -D WITH_OPENCL=ON
      -D OPENCV_DNN_OPENCL=ON
      -D BUILD_ZLIB=OFF
      -D BUILD_IPP_IW=OFF
      -D BUILD_JASPER=OFF
      -D BUILD_OPENJPEG=OFF
      -D BUILD_JPEG=OFF
      -D BUILD_OPENEXR=OFF
      -D BUILD_PNG=OFF
      -D BUILD_PROTOBUF=OFF
      -D PROTOBUF_UPDATE_FILES=ON
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
      -D JPEG_LIBRARY=#{Formula["jpeg-turbo"].opt_lib}/libjpeg.dylib
      -D BUILD_LIST=core,python3,imgproc,imgcodes,videoio,highgui,gapi,ml,flann,dnn,features2d,objdetect,photo,optflow,video,calib3d,stitching,saliency,aruco,bgsegm,ximgproc,xphoto,shape,quality,line_descriptor,intensity_transform,phase_unwrapping
      -D BUILD_opencv_apps=OFF
      -D BUILD_opencv_python2=OFF
      -D BUILD_opencv_python3=ON
      -D PYTHON3_EXECUTABLE=#{Formula["python@3.10"].opt_bin}/python3
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
