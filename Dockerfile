FROM alpin3/ulx3s-core
MAINTAINER kost - https://github.com/kost

ENV ULX3SBASEDIR=/opt GHDLSRC=/opt/ghdl-git GHDLOPT=/opt/ghdl

# qt5-qtbase-dev
RUN apk --update add git patch bash wget build-base python3-dev boost-python3 boost-static boost-dev libusb-dev libusb-compat-dev libftdi1-dev libtool automake autoconf make cmake pkgconf eigen-dev eigen bison flex gawk libffi-dev zlib-dev tcl-dev graphviz readline-dev py2-pip libgnat gcc-gnat libunwind-dev readline-dev ncurses-static && \
 rm -f /var/cache/apk/* && \
 echo "Success [deps]"

COPY root /
RUN apk add -f --allow-untrusted $ULX3SBASEDIR/apk/libgnat-8.3.0-r0.apk && \
 rm -f /var/cache/apk/* && \
 cd $ULX3SBASEDIR && \
 git clone https://github.com/ldoolitt/vhd2vl.git && \
 cd vhd2vl/src && \
 make WARNS="-static" && \
 install -m 755 -s vhd2vl /usr/local/bin && \
 cd $ULX3SBASEDIR && \
 git clone https://github.com/emard/Next186.git && \
 cd Next186 && \
 unzip Next186_SoC_Diamond_Project.zip  && \
 mkdir -p proj/ulx3s/clocks && \
 cd proj/ulx3s/ && \
 for size in 25 45 85; do make clean; make FPGA_SIZE=${size} ulx3s_${size}f_next186.bit; make FPGA_SIZE=${size} ulx3s_${size}f_next186.bit; cp -a project/project_project.bit $ulx3s_dist/ulx3s_${size}f_next186.bit; done && \
 /opt/ulx3s/bin/ecpunpack --input $ulx3s_dist/ulx3s_25f_next186.bit --textcfg /tmp/ulx3s_12f_next186.config --idcode 0x41111043 && \
 /opt/ulx3s/bin/ecppack --input /tmp/ulx3s_12f_next186.config --bit $ulx3s_dist/ulx3s_12f_next186.bit --compress --idcode 0x21111043 && \
 echo "Success [build]"
#VOLUME ["/fpga"]
#WORKDIR /opt



