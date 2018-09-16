# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

name = "librealsense"
version = v"2.16.0"

# Collection of sources required to build librealsense
sources = [
    "https://github.com/IntelRealSense/librealsense.git" =>
    "b55069d177f69daea3b9437532f4b98fbe97a718",

]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir
cd librealsense/
mkdir build
cd build
CMAKE_FLAGS="-DCMAKE_INSTALL_PREFIX=$prefix -DCMAKE_TOOLCHAIN_FILE=/opt/$target/$target.toolchain"
CMAKE_FLAGS="${CMAKE_FLAGS} -DBUILD_EXAMPLES=false"
CMAKE_FLAGS="${CMAKE_FLAGS} -DBUILD_GRAPHICAL_EXAMPLES=false"
CMAKE_FLAGS="${CMAKE_FLAGS} -DBUILD_UNIT_TESTS=false"
CMAKE_FLAGS="${CMAKE_FLAGS} -DBUILD_WITH_OPENMP=false"
CMAKE_FLAGS="${CMAKE_FLAGS} -DENFORCE_METADATA=false"
CMAKE_FLAGS="${CMAKE_FLAGS} -DBUILD_PYTHON_BINDINGS=false"
CMAKE_FLAGS="${CMAKE_FLAGS} -DBUILD_NODEJS_BINDINGS=false"
CMAKE_FLAGS="${CMAKE_FLAGS} -DFORCE_LIBUVC=false"
CMAKE_FLAGS="${CMAKE_FLAGS} -DTRACE_API=false"
CMAKE_FLAGS="${CMAKE_FLAGS} -DHWM_OVER_XU=true"
CMAKE_FLAGS="${CMAKE_FLAGS} -DBUILD_SHARED_LIBS=true"
CMAKE_FLAGS="${CMAKE_FLAGS} -DCMAKE_BUILD_TYPE=Release"
CMAKE_FLAGS="${CMAKE_FLAGS} -DENABLE_ZERO_COPY=false"
CMAKE_FLAGS="${CMAKE_FLAGS} -DBUILD_EASYLOGGINGPP=true"
CMAKE_FLAGS="${CMAKE_FLAGS} -DBUILD_CV_EXAMPLES=false"
CMAKE_FLAGS="${CMAKE_FLAGS} -DBUILD_PCL_EXAMPLES=false"
CMAKE_FLAGS="${CMAKE_FLAGS} -DBUILD_WITH_TM2=false"
CMAKE_FLAGS="${CMAKE_FLAGS} -DBUILD_WITH_STATIC_CRT=true"
cmake ${CMAKE_FLAGS} -DCMAKE_SYSTEM_VERSION=0 ..
make -j${nproc}
make install

"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    Linux(:i686, :glibc),
    Linux(:x86_64, :glibc),
    Linux(:aarch64, :glibc),
    Linux(:armv7l, :glibc, :eabihf),
    MacOS(:x86_64)
]

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "librealsense2", :librealsense)
]

# Dependencies that must be installed before this package can be built
dependencies = [
    "https://github.com/JuliaPerception/LibusbBuilder/releases/download/v1.0.22-1/build_libusb.v1.0.22.jl"
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)
