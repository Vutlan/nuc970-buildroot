# nuc970-buildroot
Custom buildroot project for VT300(NUC97x)

Building:
<pre>
  ./setup.sh
  ./build.sh
</pre>

Save current configurations:
<pre>
  ./save_configs.sh
</pre>

for more information use:
<pre>
  ./build.sh help
</pre>







===============================================================

СБОРКА buildroot

1) проверить директории проекта в файле buildroot/Makefile
# projects place here
SKY_LOCAL_ROOT = /home/gerner_terner/repo/nuc970-buildroot-master/nuc970-buildroot
SKY_XMON_ROOT = /home/gerner_terner/repo/XMON/XMON-release

2) подготовка, создание директории output/
./setup.sh

3) сборка, проходит в директорию output/
./build.sh

4) ошибка при сборке:
ERROR: /nuc970-buildroot/contrib/packages/mjpeg-streamer/mjpg-streamer-experimental does not exist
скопировать нужную директорию из addons/

5) другие ошибки при сборке - применить соответствующие файлы update_*.sh

6) ошибка при сборке XMON:
ошибка: неизвестное поле «tx_nbits» в инициализаторе ......
скопировать новый файл spidev.h из addons/ в директорию /output/host/usr/arm-buildroot-linux-uclibcgnueabi/sysroot/usr/include/linux/spi/
sudo cp spidev.h output/host/usr/arm-buildroot-linux-uclibcgnueabi/sysroot/usr/include/linux/spi/spidev.h

7) выходные файлы в директории output/images/ :

environment.img - конфиг u-boot
firmware.vut - обновление
firmware-kernel.vut - обновление ядра системы
nucwriterpack.bin - прошивка для NucWriter
rootfs.jffs2 - файловая система
rootfs.tar - файловая система в архиве, для развертывания NFS
u-boot.bin - загрузчик
uImage - ядро

8) развертывание NFS
./nfsinstall.sh



Пересборка если чтото изменено в конфиге:

1) ./build.sh menuconfig
конфиг и сохранить

2) ./save_configs.sh
сохранение и синхронизация файлов конфига

3) ./build.sh clean
очистка проекта

4) ./build.sh
сборка

