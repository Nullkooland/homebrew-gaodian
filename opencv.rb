class Opencv < Formula
  desc "Open source computer vision library"
  homepage "https://opencv.org/"
  url "https://github.com/opencv/opencv/archive/4.5.4.tar.gz"
  sha256 "c20bb83dd790fc69df9f105477e24267706715a9d3c705ca1e7f613c7b3bad3d"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "goose-bomb/gaodian/ffmpeg"
  depends_on "goose-bomb/gaodian/harfbuzz"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "protobuf"
  depends_on "python"
  depends_on "tbb"

  uses_from_macos "zlib"

  resource "contrib" do
    url "https://github.com/opencv/opencv_contrib/archive/4.5.4.tar.gz"
    sha256 "ad74b440b4539619dc9b587995a16b691246023d45e34097c73e259f72de9f81"
  end

  def install
    ENV.cxx11

    resource("contrib").stage buildpath/"opencv_contrib"
    
    args = std_cmake_args + %W[
      -G Ninja
      -D CMAKE_BUILD_TYPE=Release
      -D BUILD_SHARED_LIBS=ON
      -D OPENCV_EXTRA_MODULES_PATH=#{buildpath}/opencv_contrib/modules
      -D CPU_BASELINE=AVX2
      -D WITH_TBB=ON
      -D WITH_IPP=OFF
      -D WITH_LAPACK=ON
      -D WITH_OPENCL=ON
      -D WITH_ONNX=ON
      -D BUILD_ZLIB=OFF
      -D BUILD_IPP_IW=OFF
      -D BUILD_JASPER=OFF
      -D BUILD_OPENJPEG=OFF
      -D BUILD_JPEG=OFF
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
      -D WITH_TIFF=OFF
      -D WITH_WEBP=OFF
      -D WITH_JASPER=OFF
      -D WITH_OPENEXR=OFF
      -D WITH_OPENGL=OFF
      -D WITH_IMGCODEC_SUNRASTER=OFF
      -D WITH_VTK=OFF
      -D BUILD_LIST=core,python3,imgproc,imgcodes,videoio,highgui,gapi,ml,flann,dnn,features2d,objdetect,photo,optflow,video,calib3d,stitching,saliency,aruco,bgsegm,ximgproc,xphoto,shape,quality,line_descriptor,intensity_transform,phase_unwrapping
      -D PYTHON3_EXECUTABLE=#{Formula["python"].opt_bin}/python3
      -D BUILD_TESTS=OFF
      -D BUILD_PERF_TESTS=OFF
      -D BUILD_EXAMPLES=OFF
      -D INSTALL_C_EXAMPLES=OFF
      -D INSTALL_PYTHON_EXAMPLES=OFF
    ]

    mkdir "build" do
      system "cmake", "..", *std_cmake_args, *args
      system "ninja"
      system "ninja", "install"
    end
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
    system ENV.cxx, "-std=c++11", "test.cpp", "-I#{include}/opencv4",
                    "-o", "test"
    assert_equal `./test`.strip, version.to_s

    output = shell_output(Formula["python"].opt_bin/"python3 -c 'import cv2; print(cv2.__version__)'")
    assert_equal version.to_s, output.chomp
  end
end
