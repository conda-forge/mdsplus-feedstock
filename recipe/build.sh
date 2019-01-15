./configure --prefix=$PREFIX --enable-shared --disable-java --disable-dependency-tracking --with-readline=$PREFIX --with-xml-prefix=$PREFIX CFLAGS="-I${PREFIX}/include -I${PREFIX}/include/libxml2 $CFLAGS"
export CFLAGS="-I${PREFIX}/include -I${PREFIX}/include/libxml2 $CFLAGS"
export XML_CFLAGS="-I${PREFIX}/include -I${PREFIX}/include/libxml2"
make MOTIF_APS=""
make install MOTIF_APS=""
cd mdsobjects/python
python setup.py install --single-version-externally-managed --record record.txt
