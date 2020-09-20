**Luks**

[[_TOC_]]

# Create en encrypted partition

```markdown
`Will **erase** partition!!! Be carefull!!!`
```

```shell
LUKS_ORG_PART="/dev/sdz1"
LUKS_PART_NAME="lukspart"
LUKS_FS_NAME="luksfs"

cryptsetup luksFormat -c aes -h sha256 ${LUKS_ORG_PART}
cryptsetup luksOpen ${LUKS_ORG_PART} ${LUKS_PART_NAME}
mkfs.ext4 -m 0 -L ${LUKS_FS_NAME} /dev/mapper/${LUKS_PART_NAME}
mount /dev/mapper/${LUKS_PART_NAME} /media/temp/
```

# /etc/crypttab
```shell
# <target name> <source device>                           <key file>    <options>
lukspart        UUID=01234567-89ab-cdef-0123-456789abcdef none          luks,noauto
```

