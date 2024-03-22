Credit goes to the Orignal Milk-V Community Member for the development of this OS builder (logicethos)
https://github.com/logicethos/Milk-V_Duo_Linux2SD

https://community.milkv.io/t/milk-v-duo-debian-ubuntu-image-builder/1424

# Milk-V Duo Debian/Ubuntu Image builder modified for use with Meshtastic

- Menu driven selection
- Writes to SD Card & expands partition
- Create your own custom builds

#### Requirements
- Docker  
- whiptail (usually already installed)


### To Run
```
clone https://github.com/logicethos/Milk-V_Duo_Linux2SD.git
cd Milk-V_Duo_Linux2SD
./run.sh
```

#### Custom builds
Copy one of the existing directorys, and edit the files.

```
ENV - Distro vairables.
bootstrap.sh - This is run within your new envirment during the build.
```
Make sure `export ROOTFS_SIZE=“1G”` is large enough for your bootstrap.sh needs.
