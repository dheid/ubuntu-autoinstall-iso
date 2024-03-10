#!/bin/bash -e

if ! command -v wget &> /dev/null; then
    echo "Error: wget command not found. Please install wget to proceed." >&2
    exit 1
fi

if ! command -v 7z &> /dev/null; then
    echo "Error: 7z command not found. Please install p7zip-full to proceed." >&2
    exit 1
fi

if ! command -v xorriso &> /dev/null; then
    echo "Error: xorriso command not found. Please install xorriso to proceed" >&2
    exit 1
fi

readonly image_filename=jammy-live-server-amd64.iso
curl -z ${image_filename} -o ${image_filename} "https://cdimage.ubuntu.com/ubuntu-server/jammy/daily-live/current/${image_filename}"

readonly output_dir=output
if [ ! -d ${output_dir} ]; then
    7z -y x ${image_filename} -o${output_dir}
fi

readonly boot_dir=BOOT
if [ ! -d ${boot_dir} ]; then
    mv ${output_dir}/\[BOOT\]/ BOOT
fi

cp grub.cfg ${output_dir}/boot/grub
readonly server_dir=${output_dir}/server
mkdir -p ${server_dir}
touch ${server_dir}/meta-data
cp user-data.yml ${server_dir}/user-data

readonly output_filename="$(basename ${image_filename} .iso)_autoinstall.iso"
xorriso -as mkisofs -r \
    -V 'Ubuntu-Server 22.04.4 LTS amd64' \
    --grub2-mbr BOOT/1-Boot-NoEmul.img \
    --protective-msdos-label \
    -partition_cyl_align off \
    -partition_offset 16 \
    --mbr-force-bootable \
    -append_partition 2 28732ac11ff8d211ba4b00a0c93ec93b BOOT/2-Boot-NoEmul.img \
    -appended_part_as_gpt \
    -iso_mbr_part_type a2a0d0ebe5b9334487c068b6b72699c7 \
    -c '/boot.catalog' \
    -b '/boot/grub/i386-pc/eltorito.img' \
    -no-emul-boot \
    -boot-load-size 4 \
    -boot-info-table \
    --grub2-boot-info \
    -eltorito-alt-boot \
    -e '--interval:appended_partition_2:::' \
    -no-emul-boot \
    -boot-load-size 10068 \
    -o "${output_filename}" \
    ${output_dir}

echo "Created file ${output_filename}"
