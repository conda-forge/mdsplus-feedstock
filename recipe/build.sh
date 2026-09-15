# Run bootstrap to generate message files and prepare build
./bootstrap

# Create out-of-source build directory
mkdir -p build
cd build

# On macOS, inject sysroot/arch into CMAKE_ARGS so cmake's compiler detection
# uses the correct SDK. conda-forge normally provides CONDA_BUILD_SYSROOT via
# xcrun, but xcrun can fail in some local environments (e.g. Rosetta on
# macOS 26). Fall back to SDKROOT if available.
if [[ "${target_platform}" == osx-* ]]; then
  _sysroot="${CONDA_BUILD_SYSROOT:-${SDKROOT}}"
  if [[ -n "${_sysroot}" ]]; then
    export CMAKE_ARGS="${CMAKE_ARGS} \
      -DCMAKE_OSX_SYSROOT=${_sysroot} \
      -DCMAKE_OSX_ARCHITECTURES=${OSX_ARCH} \
      -DCMAKE_OSX_DEPLOYMENT_TARGET=${MACOSX_DEPLOYMENT_TARGET}"
  fi
fi
# Convert version to release tag format (e.g., 7.157.0 -> alpha_release-7-157-0)
RELEASE_TAG="alpha_release-${PKG_VERSION//./-}"

# Configure with CMake
cmake -G "Unix Makefiles" \
  -DCMAKE_INSTALL_PREFIX=${PREFIX} \
  -DCMAKE_BUILD_TYPE=Release \
  -DBUILD_SHARED_LIBS=ON \
  -DENABLE_JAVA=OFF \
  -DENABLE_MOTIF=OFF \
  -DENABLE_DOXYGEN=OFF \
  -DENABLE_LABVIEW=OFF \
  -DENABLE_IDL=OFF \
  -DREADLINE_DIR=${PREFIX} \
  -DLIBXML2_DIR=${PREFIX} \
  ${CMAKE_ARGS} \
  -DLIBXML2_LIBRARY=${PREFIX}/lib/libxml2${SHLIB_EXT} \
  -DLIBXML2_INCLUDE_DIR=${PREFIX}/include \
  -DCMAKE_PREFIX_PATH=${PREFIX} \
  -DRELEASE_TAG="${RELEASE_TAG}" \
  ..

# Build and install C/C++ libraries
make -j${CPU_COUNT}
make install

# Install Python package to proper site-packages location
cd ../python/MDSplus
${PYTHON} -m pip install . -vv --no-deps --no-build-isolation
