
#!/bin/bash

##lrwxrwxrwx 1 root root 13 Sep 24 14:37 /dev/serial/by-id/usb-Klipper_lpc1768_02F0000F271835AECA683E53811E00F5-if00 -> ../../ttyACM0
##lrwxrwxrwx 1 root root 13 Sep 24 14:37 /dev/serial/by-id/usb-Klipper_lpc1768_13FC0F0F93235253B409F34C020000F5-if00 -> ../../ttyACM1


CORES=$(grep -c processor /proc/cpuinfo)

sudo service klipper stop
cd ~/klipper

# Update mcu rpi

echo "Start update mcu rpi"
echo ""
make clean KCONFIG_CONFIG=/home/ente/printer_data/config/script/config.host
#make menuconfig KCONFIG_CONFIG=/home/ente/printer_data/config/script/config.host
make -j $CORES KCONFIG_CONFIG=/home/ente/printer_data/config/script/config.host
#read -p "mcu rpi firmware built, please check above for any errors. Press [Enter] to continue flashing, or [Ctrl+C] to abort"
make flash KCONFIG_CONFIG=/home/ente/printer_data/config/script/config.host
echo "Finish update mcu rpi"
echo ""

# Update mcu XYE and Z
echo "Start update mcu XYE and Z"
echo ""
make clean KCONFIG_CONFIG=/home/ente/printer_data/config/script/config.skr13XYE
#make menuconfig KCONFIG_CONFIG=/home/ente/printer_data/config/script/config.skr13XYE
make -j $CORES KCONFIG_CONFIG=/home/ente/printer_data/config/script/config.skr13XYE
#read -p "mcu XYE firmware built, please check above for any errors. Press [Enter] to continue, or [Ctrl+C] to abort"

./scripts/flash-sdcard.sh /dev/serial/by-id/usb-Klipper_lpc1768_02F0000F271835AECA683E53811E00F5-if00 btt-skr-v1.3
./scripts/flash-sdcard.sh /dev/serial/by-id/usb-Klipper_lpc1768_13FC0F0F93235253B409F34C020000F5-if00 btt-skr-v1.3

echo "Finish update mcu XYE and Z"
echo ""

## Update mcu Z
#echo "Start update mcu Z"
#echo ""
#make clean KCONFIG_CONFIG=/home/ente/printer_data/config/script/config.skr13Z
#make menuconfig KCONFIG_CONFIG=/home/ente/printer_data/config/script/config.skr13Z
#make -j $CORES KCONFIG_CONFIG=/home/ente/printer_data/config/script/config.skr13Z
#read -p "mcu XYE firmware built, please check above for any errors. Press [Enter] to continue, or [Ctrl+C] to abort"
#./scripts/flash-sdcard.sh /dev/serial/by-id/usb-Klipper_lpc1768_13FC0F0F93235253B409F34C020000F5-if00 btt-skr-v1.3
#echo "Finish update mcu Z"
#echo ""

## Update mcu Z
echo "Start update mcu rpzero"
echo ""
make clean KCONFIG_CONFIG=/home/ente/printer_data/config/script/config.rpzero
make menuconfig KCONFIG_CONFIG=/home/ente/printer_data/config/script/config.rpzero
make -j $CORES KCONFIG_CONFIG=/home/ente/printer_data/config/script/config.rpzero
#read -p "mcu XYE firmware built, please check above for any errors. Press [Enter] to continue, or [Ctrl+C] to abort"
#make flash KCONFIG_CONFIG=KCONFIG_CONFIG=/home/ente/printer_data/config/script/config.rpzero
make flash FLASH_DEVICE=/dev/serial/by-id/usb-Klipper_rp2040_4250305031373311-if00
echo "Finish update mcu rpzero"
#echo ""

sudo service klipper start
