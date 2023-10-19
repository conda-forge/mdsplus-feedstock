./bootstrap
./configure --prefix=$PREFIX --enable-shared --disable-java --disable-dependency-tracking --with-readline=$PREFIX --with-xml-prefix=$PREFIX CFLAGS="-I${PREFIX}/include -I${PREFIX}/include/libxml2 $CFLAGS" --enable-debug=no
export CFLAGS="-I${PREFIX}/include -I${PREFIX}/include/libxml2 $CFLAGS"
export XML_CFLAGS="-I${PREFIX}/include -I${PREFIX}/include/libxml2"
export XML_LIBS="-L${PREFIX}/lib -lxml2 -lz -llzma -lpthread -liconv -licui18n -licuuc -licudata -lm"

make MOTIF_APS="" PARTS="mdsshr mdsdcl treeshr tdishr mdstcpip mdslib mdsmisc xtreeshr" MISC_PARTS="tdi include"
make install MOTIF_APS="" PARTS="mdsshr mdsdcl treeshr tdishr mdstcpip mdslib mdsmisc xtreeshr" MISC_PARTS="tdi include"
cd python
cat > setup.py << _EOF_
from setuptools import setup

setup(
    name='MDSplus',
    version='7.139.40',
    description='MDSplus Python Objects',
    url='https://gafusion.github.io/omas',
    author='MDSplus Developers',
    license='MIT',
    classifiers=['License :: OSI Approved :: MIT License', 'Programming Language :: Python :: 3'],
    keywords=['physics', 'mdsplus', ],
    long_description=(
            "This module provides all of the functionality of MDSplus TDI natively in python.\n"
            "All of the MDSplus data types such as signal are represented as python classes.\n"
        ),
    packages=['MDSplus'],
    package_data={'MDSplus':['*.py']},
)
_EOF_

python -m pip install .
