#!/bin/bash

# WORK directory
WORK=`pwd`

# MMNGR library and driver commit IDs
MMNGR_LIB_COMMIT="0322548e54b45a064c9cecea29018ef50cdb8423"
MMNGR_DRV_COMMIT="bd1c9b76cbddf80d5d47255031d6049a6fee21d8"
 
# Set environment variables
# sudo locale-gen vi_VN
source /opt/poky/3.1.11/environment-setup-aarch64-poky-linux
export INCSHARED=/usr/include
export KERNELSRC=/home/quathd/rvc/linux-bsp
export M=/home/quathd/rvc/VSP/vspm_drv/vspm-module/files/vspm/drv
export CP=cp
export MMNGR_CONFIG=MMNGR_EBISU
export MMNGR_SSP_CONFIG=MMNGR_SSP_DISABLE
export MMNGR_IPMMU_MMU_CONFIG=IPMMU_MMU_DISABLE
export INCSHARED=$SDKTARGETSYSROOT/usr/local/include

# Clone MMNGR library and driver repositories
git clone https://github.com/renesas-rcar/mmngr_lib.git &
git clone https://github.com/renesas-rcar/mmngr_drv.git &

# Wait for both repositories to be cloned
wait

# Checkout the specified commits for the MMNGR library and driver
cd ${WORK}/mmngr_lib
git checkout -b tmp ${MMNGR_LIB_COMMIT}
cd ${WORK}/mmngr_drv
git checkout -b tmp ${MMNGR_DRV_COMMIT}

# Display a menu of options
echo "Please choose an option:"
echo "1. Build the MMNGR library"
echo "2. Build the MMNGR buffer library"
echo "3. Build the Kernel Image and Kernel module"
echo "4. Exit"

# Read the user's choice
read -p "Your choice: " choice

# Switch on the user's choice
case "$choice" in
1)
    # Build the MMNGR library
    cd ${WORK}/mmngr_lib/libmmngr/mmngr
    autoreconf -i
    ./configure ${CONFIGURE_FLAGS} --prefix=$PWD/tmp
    make > libmmngr_buildlog.log
    make install includedir=$INCSHARED >> libmmngr_buildlog.log
    cp libmmngr_buildlog.log ${WORK}
    cd ${WORK}
    cat libmmngr_buildlog.log
    #Verify the library
    ls ${WORK}/mmngr_lib/libmmngr/mmngr/tmp/lib | grep libmmngr.so*
    ;;
2)
    # Build the MMNGR buffer library
    cd ${WORK}/mmngr_lib/libmmngr/mmngrbuf
    autoreconf -i
    ./configure ${CONFIGURE_FLAGS} --prefix=$PWD/tmp
    make > libmmngr_buildlog.log
    #make install includedir=$INCSHARED >> libmmngr_buildlog.log
    cp libmmngr_buildlog.log ${WORK}
    cd ${WORK}
    cat libmmngr_buildlog.log
    #Verify the library
    ls ${WORK}/mmngr_lib/libmmngr/mmngr/tmp/lib | grep libmmngr.so*
    ;;
3)
    source ${WORK}/../poky/oe-init-build-env
    echo $MMNGR_CONFIG
    echo $MMNGR_SSP_CONFIG
    echo $MMNGR_IPMMU_MMU_CONFIG
    bitbake linux-renesas -c compile -f
    ;;
*)
    # Invalid choice
    echo "Invalid choice. Please try again."
    ;;
esac
# Display a message indicating that the operation is complete
echo "Operation complete."


