# Run bootstrap to generate message files and prepare build
./bootstrap

# Create out-of-source build directory
mkdir -p build
cd build

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
  -DREADLINE_DIR=${PREFIX} \
  -DLIBXML2_DIR=${PREFIX} \
  -DCMAKE_PREFIX_PATH=${PREFIX} \
  -DRELEASE_TAG="${RELEASE_TAG}" \
  ..

# Build and install C/C++ libraries
make -j${CPU_COUNT}
make install

# Replace the broken _version.py with a correct one
# CMake generates a malformed version, so we override it entirely
cat > ../python/MDSplus/_version.py << EOF
version = tuple(map(int, "${PKG_VERSION}".split('.')))
__version__ = "${PKG_VERSION}"
release_tag = "${PKG_VERSION}"
release_date = "$(date -u '+%a %b %d %H:%M:%S UTC %Y')"
EOF

# Install Python package to proper site-packages location
cd ../python/MDSplus
${PYTHON} -m pip install . -vv --no-deps --no-build-isolation
