# Start from Ubuntu with Eclipse CDT install
FROM rafdouglas/eclipse_docker:eclipse_photon_C_Cpp


# Add dependencies needed to build cisTEM
RUN sudo apt-get --allow-releaseinfo-change update && sudo apt-get install -y gcc g++ gtk2.0-dev xterm unzip fftw3-dev gdb valgrind git vim bc

# Build & install wxWidgets (static, for cisTEM)
RUN wget https://github.com/wxWidgets/wxWidgets/releases/download/v3.0.4/wxWidgets-3.0.4.tar.bz2 -O /tmp/wxwidgets.tar.gz && \
    echo 'Installing wxWidgets' && \
    sudo tar -xf /tmp/wxwidgets.tar.gz -C /tmp && \
    cd /tmp/wxWidgets-3.0.4 && \
    CXX=g++ CC=gcc CXXFLAGS=-fPIC CFLAGS=-fPIC ./configure --disable-precomp-headers --prefix=/usr/local --with-libnotify=no --disable-shared --without-gtkprint --with-libjpeg=builtin --with-libpng=builtin --with-libtiff=builtin --with-zlib=builtin --with-expat=builtin --disable-compat28 --without-liblzma --without-libjbig --with-gtk=2 && \
    make -j4 && \
    sudo make install

# Build & install wxWidgets (dynamic, for wxformbuilder)
RUN cd /tmp/wxWidgets-3.0.4 &&\
	CXX=g++ CC=gcc ./configure --disable-precomp-headers --prefix=/usr/local --with-libnotify=no --enable-shared --without-gtkprint --with-libjpeg=builtin --with-libpng=builtin --with-libtiff=builtin --with-zlib=builtin --with-expat=builtin --disable-compat28 --without-liblzma --without-libjbig --with-gtk=2 && \
    make -j4 && \
    sudo make install


# Build & install wxformbuilder
RUN wget -q http://cfhcable.dl.sourceforge.net/project/wxformbuilder/wxformbuilder-nightly/3.5.0-beta/wxFormBuilder_v3.5.0-beta-source.zip -O /tmp/wxformbuilder.zip && \
	cd /tmp && rm -fr source && unzip -q wxformbuilder.zip && cd source && \
	sh ./create_build_files4.sh --disable-mediactrl &&\
	cd /tmp/source/build/3.0/gmake && make config=release &&\
	sudo cp -vaL /tmp/source/output/bin/wxformbuilder /usr/local/bin/ &&\
	sudo cp -vaL  /tmp/source/output/lib /usr/local/ &&\
	sudo mkdir -p /usr/local/share/wxformbuilder &&\
	sudo cp -va  /tmp/source/output/share/wxformbuilder/* /usr/local/share/wxformbuilder/

# This is needed for wxformbuilder
ENV LD_LIBRARY_PATH="/usr/local/lib:${LD_LIBRARY_PATH}"

# Build & install libtiff, including static
RUN cd /tmp && wget -q http://download.osgeo.org/libtiff/tiff-4.0.10.tar.gz &&\
	tar -xzf tiff-4.0.10.tar.gz &&\
	cd tiff-4.0.10 &&\
	./configure --enable-shared --enable-static --disable-jpeg --disable-lzma --disable-jbig --disable-pixar --disable-zlib &&\
	make -j2 &&\
	sudo make install
	
	
# Cleanup 
RUN cd /tmp && rm -fr source wx* tiff*

# This is needed for Eclipse's indexer to find setup.h 
RUN cd /usr/local/include/wx-3.0/wx && sudo ln -s /usr/local/lib/wx/include/gtk2-unicode-static-3.0/wx/setup.h .

# Define the user
USER developer
ENV HOME /home/developer
ENV LDFLAGS -L/usr/local/lib


# We begin at the host's home, which will be mounted by the docker run command
WORKDIR /mnt/ext_home

# A script to launch multiple applications
COPY --chown=developer:developer cistem_dev_launcher.sh /
CMD /cistem_dev_launcher.sh