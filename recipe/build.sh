# Run bootstrap to generate message files and prepare build
./bootstrap

# Create out-of-source build directory
mkdir -p build
cd build

# Configure with CMake
cmake -G "Unix Makefiles" \
  -DCMAKE_INSTALL_PREFIX=${PREFIX} \
  -DCMAKE_BUILD_TYPE=Release \
  -DBUILD_SHARED_LIBS=ON \
  -DENABLE_JAVA=OFF \
  -DENABLE_MOTIF=OFF \
  -DREADLINE_DIR=${PREFIX} \
  -DLIBXML2_DIR=${PREFIX} \
  -DLIBXML2_LIBRARY=${PREFIX}/lib \
  -DLIBXML2_INCLUDE_DIR=${PREFIX}/include \
  -DCMAKE_PREFIX_PATH=${PREFIX} \
  ..

# Build and install C/C++ libraries
make -j${CPU_COUNT}
make install

# Install Python package to proper site-packages location
cd ../python/MDSplus
${PYTHON} -m pip install . -vv --no-deps --no-build-isolation
