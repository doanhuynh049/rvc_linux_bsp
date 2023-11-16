WORK=`pwd`
MMNGR_LIB_COMMIT="0322548e54b45a064c9cecea29018ef50cdb8423"
MMNGR_DRV_COMMIT="bd1c9b76cbddf80d5d47255031d6049a6fee21d8"

# setting environment variables
sudo locale-gen vi_VN
source /opt/poky/3.1.11/environment-setup-aarch64-poky-linux
export INCSHARED=/usr/include
export KERNELSRC=/home/quathd/rvc/linux-bsp
export M=/home/quathd/rvc/VSP/vspm_drv/vspm-module/files/vspm/drv

git clone https://github.com/renesas-rcar/mmngr_lib.git &
git clone https://github.com/renesas-rcar/mmngr_drv.git &

wait
cd ${WORK}/mmngr_lib
git checkout -b tmp ${MMNGR_LIB_COMMIT}
cd ${WORK}/mmngr_drv
git checkout -b tmp ${MMNGR_DRV_COMMIT}

#building the shared library
cd ${WORK}/mmngr_lib/libmmngr/mmngr
#autoreconf -i
cd ${WORK}/mmngr_lib/libmmngr/mmngr
./configure ${CONFIGURE_FLAGS} --prefix=$PWD/tmp

echo ${KERNELSRC}
echo ${INCSHARED}
#Run make
#make > log_build_mmngr_lib.log
#make install includedir=$INCSHARED >> log_build_mmngr_lib.log
#cp log_build_mmngr_lib.log ${WORK}
#Verify the library
ls ${WORK}/mmngr_lib/libmmngr/mmngr/tmp/lib | grep libmmngr.so*

export INCSHARED=/usr/include
export KERNELSRC=/home/quathd/rvc/linux-bsp
#Build the mmngrbuf
cd ${WORK}/mmngr_lib/libmmngr/mmngrbuf
autoreconf -i
./configure ${CONFIGURE_FLAGS} --prefix=$PWD/tmp
#Run make
make >  log_build_mmngr_lib_mmngrbuf.log
make install includedir=$INCSHARED >> log_build_mmngr_lib_mmngrbuf.log
cp log_build_mmngr_lib_mmngrbuf.log ${WORK}

ls ${WORK}/mmngr_lib/libmmngr/mmngrbuf/tmp/lib | grep libmmngrbuf.so*

 

#cd libmmngr/mmngr &&
#Solve bug
# make clean
# sudo apt install flex
# sudo apt install bison
# make defconfig
# sudo apt install  libelf-dev
# make oldconfig && make prepare
