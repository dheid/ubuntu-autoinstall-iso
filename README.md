
# Ubuntu Autoinstall ISO

This repository helps to create an automatic installation ISO for Ubuntu according to [Dr. Donald Kinghorn's excellent guide on Puget Systems](https://www.pugetsystems.com/labs/hpc/ubuntu-22-04-server-autoinstall-iso/).

You need to have the following tools installed:

- wget
- 7z
- xorriso

Copy the file [user-data.yml.example](user-data.yml.example) and adapt it to your needs:

```bash
cp user-data.yml.example user-data.yml
```

You can create a password using `mkpasswd`, e.g.

```bash
mkpasswd --method=SHA-512 --rounds=500000
```

If you want to generate SSH keys, I recommend you to use

```bash
ssh-keygen -t ed25519 -f key -C infra
```

The default Ubuntu image is Ubuntu Server 22.04 (Jammy). You can also use another Ubuntu image by adapting the variable
`image_filename` in the script [build.sh](build.sh).

After that just run

```bash
./build.sh
```

It will download the ISO, put its contents to the directory `output`, move the boot images to the folder `BOOT`,
copy the user data file to a server subdirectory and create the new ISO file.

More information:

- [Autoinstall configuration reference manual](https://canonical-subiquity.readthedocs-hosted.com/en/latest/reference/autoinstall-reference.html)
- [cloud-init Module reference](https://cloudinit.readthedocs.io/en/latest/reference/modules.html)