# Start from Ubuntu 20.04
FROM ubuntu:20.04

ENV TZ=America/LosAngeles
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt update && DEBIAN_FRONTEND=noninteractive apt -y install sudo software-properties-common wget default-jre xterm &&\
	useradd -s /bin/bash -m developer && echo "developer:developer" | chpasswd && adduser developer sudo

# Add dependencies needed to build cisTEM
RUN sudo apt-get --allow-releaseinfo-change update && sudo apt-get install -y gcc g++ gtk2.0-dev xterm unzip fftw3-dev gdb valgrind git vim bc meson

# Build & install wxWidgets (static, for cisTEM)
RUN wget -q https://github.com/wxWidgets/wxWidgets/releases/download/v3.0.4/wxWidgets-3.0.4.tar.bz2 -O /tmp/wxwidgets.tar.gz && \
    echo 'Installing wxWidgets' && \
    sudo tar -xf /tmp/wxwidgets.tar.gz -C /tmp && \
    cd /tmp/wxWidgets-3.0.4 && \
    CXX=g++ CC=gcc CXXFLAGS=-fPIC CFLAGS=-fPIC ./configure --disable-precomp-headers --prefix=/usr/local --with-libnotify=no --disable-shared --without-gtkprint --with-libjpeg=builtin --with-libpng=builtin --with-libtiff=builtin --with-zlib=builtin --with-expat=builtin --disable-compat28 --without-liblzma --without-libjbig --with-gtk=2 && \
    make -j4 && \
    sudo make install

# Build & install wxWidgets (dynamic, for wxformbuilder)
RUN wget -q https://github.com/wxWidgets/wxWidgets/releases/download/v3.0.4/wxWidgets-3.0.4.tar.bz2 -O /tmp/wxwidgets.tar.gz && \
    echo 'Installing wxWidgets' && \
    sudo tar -xf /tmp/wxwidgets.tar.gz -C /tmp && \cd /tmp/wxWidgets-3.0.4 &&\
	CXX=g++ CC=gcc ./configure --disable-precomp-headers --prefix=/usr/local --with-libnotify=no --enable-shared --without-gtkprint --with-libjpeg=builtin --with-libpng=builtin --with-libtiff=builtin --with-zlib=builtin --with-expat=builtin --disable-compat28 --without-liblzma --without-libjbig --with-gtk=2 && \
    make -j4 && \
    sudo make install

# Build & install wxformbuilder
RUN cd /tmp && git clone -b v3.9.0 --recursive --depth=1 https://github.com/wxFormBuilder/wxFormBuilder  &&\
	cd wxFormBuilder &&\
	meson _build --prefix=/usr/local --buildtype=release&&\
	sudo ninja -C _build install && \
	sudo cp -r /usr/local/lib/x86_64-linux-gnu/wxformbuilder/ /usr/local/lib/

# Install eclipse
RUN wget http://ftp.fau.de/eclipse/technology/epp/downloads/release/photon/R/eclipse-cpp-photon-R-linux-gtk-x86_64.tar.gz -O /tmp/eclipse.tar.gz -q && \
    echo 'Installing eclipse C_Cpp' && \
    sudo tar -xf /tmp/eclipse.tar.gz -C /opt && \
    rm /tmp/eclipse.tar.gz

# Build & install libtiff, including static
RUN cd /tmp && wget -q http://download.osgeo.org/libtiff/tiff-4.0.10.tar.gz &&\
    tar -xzf tiff-4.0.10.tar.gz &&\
    cd tiff-4.0.10 &&\
    ./configure --enable-shared --enable-static --disable-jpeg --disable-lzma --disable-jbig --disable-pixar --disable-zlib &&\
    make -j2 &&\
    sudo make install


# This is needed for wxformbuilder
ENV LD_LIBRARY_PATH="/usr/local/lib"

# This is needed for Eclipse's indexer to find setup.h 
RUN cd /usr/local/include/wx-3.0/wx && sudo ln -s /usr/local/lib/wx/include/gtk2-unicode-static-3.0/wx/setup.h .


# We begin at the host's home, which will be mounted by the docker run command
#WORKDIR /mnt/ext_home

# A script to launch multiple applications
#COPY --chown=developer:developer cistem_dev_launcher.sh /
#CMD /cistem_dev_launcher.sh

# Just tell the user what they need to know using an old-fashioned MOTD
RUN printf "\n\n*****************************************************************\n\nWelcome to the cisTEM development environment\n\nUseful commands:\n/opt/eclipse/eclipse      our IDE of choice\nwxformbuilder             for tweaking the cisTEM GUI \n\nTips:\n- Your username: developer\n- Your password: developer\n- Your host system's home directory is mounted at /mnt/ext_home \n- on MacOS, if you find that your GUI applications \n  (Eclipse, wxformbuilder) get killed at random times, you may \n  want to start an xterm with top running in it\n\n*****************************************************************\n\n" | sudo tee /etc/motd > /dev/null && printf "cat /etc/motd\n" > /home/developer/.bashrc


USER developer
ENV HOME /home/developer
WORKDIR /home/developer






