sandbox="$PWD/sandbox"
mkdir sandbox
cd "$sandbox"
#git clone git://git.rtems.org/rtems-source-builder.git
wget https://git.rtems.org/rtems-source-builder/snapshot/rtems-source-builder-5.tar.bz2
tar -xjf rtems-source-builder-5.tar.bz2
mv rtems-source-builder-5 rsb

#git clone git://git.rtems.org/rtems.git
wget https://git.rtems.org/rtems/snapshot/rtems-5.tar.bz2
tar -xjf rtems-5.tar.bz2
mv rtems-5 rtems
git clone git://git.rtems.org/rtems-libbsd.git


git clone http://github.com/matthew-renodin/ACE-TAO-linux-installer
git clone http://github.com/matthew-renodin/ACE-TAO-RTEMS-installer
git clone https://github.com/USCiLab/cereal.git
git clone https://github.com/catchorg/Catch2.git

cd "$sandbox"
cd rsb/rtems
../source-builder/sb-set-builder --prefix="$sandbox/rtems/5" 5/rtems-arm

cd "$sandbox"
cd rtems
PATH="$sandbox/rtems/5/bin:$PATH" ./bootstrap

cd "$sandbox"
mkdir b-xilinx_zynq_a9_qemu
cd b-xilinx_zynq_a9_qemu
PATH="$sandbox/rtems/5/bin:$PATH" "$sandbox/rtems/configure" \
  --target=arm-rtems5 --prefix="$sandbox/rtems/5" \
  --disable-networking --enable-rtemsbsp=xilinx_zynq_a9_qemu
PATH="$sandbox/rtems/5/bin:$PATH" make
PATH="$sandbox/rtems/5/bin:$PATH" make install

cd "$sandbox"
cd rtems-libbsd
git checkout 13421d06177df03916665bb2f3a7fcadc51a951b
git submodule init
git submodule update rtems_waf
./waf configure --prefix="$sandbox/rtems/5" \
  --rtems-bsps=arm/xilinx_zynq_a9_qemu \
  --buildset=buildset/everything.ini
./waf
./waf install

cd "$sandbox"

cd ACE-TAO-linux-installer
source setenv

./ace-tao--install.sh

cd "$sandbox"

cd ACE-TAO-RTEMS-installer
./ace-tao-rtems--install.sh

echo "Run \"source setenv\" in ACE-TAO-RTEMS-installer"
