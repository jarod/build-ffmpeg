all: ffmpeg

PREFIX=$(shell pwd)/build

librtmp:
	cd rtmpdump/librtmp && make SHARED=no -j2 && make install prefix=$(PREFIX) SHARED=no

libfdk-aac:
	cd fdk-aac && ./autogen.sh && ./configure --prefix=$(PREFIX) --enable-shared=no && make -j2 && make install

libspeex:
	cd speex && ./autogen.sh && ./configure --prefix=$(PREFIX) --enable-shared=no --disable-binaries && make -j2 && make install

libx264:
	cd x264 && ./configure --prefix=$(PREFIX) --disable-cli --enable-static --disable-shared --enable-lto && make -j3 && make install

ffmpeg: librtmp libfdk-aac libspeex libx264
	cd ffmpeg \
	&& PKG_CONFIG_PATH=$(PREFIX)/lib/pkgconfig ./configure \
	--prefix=$(PREFIX) \
	--enable-gpl \
	--enable-nonfree \
	--enable-version3 \
	--pkg-config-flags="--static" \
	--enable-static \
	--disable-shared \
	--disable-debug \
	--enable-librtmp \
	--enable-libfdk-aac \
	--enable-libspeex \
	--enable-libx264 \
	&& make -j4 && make install

clean:
	rm -rf build
