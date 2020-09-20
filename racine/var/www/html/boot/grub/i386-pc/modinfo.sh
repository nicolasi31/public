#!/bin/sh

# User-controllable options
grub_modinfo_target_cpu=i386
grub_modinfo_platform=pc
grub_disk_cache_stats=0
grub_boot_time_stats=0
grub_have_font_source=1

# Autodetected config
grub_have_asm_uscore=0
grub_bss_start_symbol="__bss_start"
grub_end_symbol="end"

# Build environment
grub_target_cc='gcc'
grub_target_cc_version='gcc (GCC) 8.3.1 20191121 (Red Hat 8.3.1-5)'
grub_target_cflags='	 -fno-strict-aliasing -fno-strict-aliasing -g -pipe -Wall -Werror=format-security -Wp,-D_GLIBCXX_ASSERTIONS -grecord-gcc-switches -m32 -march=x86-64 -mtune=generic -mfpmath=sse -mstackrealign -fstack-clash-protection -fcf-protection -Wall -W -Wshadow -Wpointer-arith -Wundef -Wchar-subscripts -Wcomment -Wdeprecated-declarations -Wdisabled-optimization -Wdiv-by-zero -Wfloat-equal -Wformat-extra-args -Wformat-security -Wformat-y2k -Wimplicit -Wimplicit-function-declaration -Wimplicit-int -Wmain -Wmissing-braces -Wmissing-format-attribute -Wmultichar -Wparentheses -Wreturn-type -Wsequence-point -Wshadow -Wsign-compare -Wswitch -Wtrigraphs -Wunknown-pragmas -Wunused -Wunused-function -Wunused-label -Wunused-parameter -Wunused-value  -Wunused-variable -Wwrite-strings -Wnested-externs -Wstrict-prototypes -g -Wredundant-decls -Wmissing-prototypes -Wmissing-declarations  -Wextra -Wattributes -Wendif-labels -Winit-self -Wint-to-pointer-cast -Winvalid-pch -Wmissing-field-initializers -Wnonnull -Woverflow -Wvla -Wpointer-to-int-cast -Wstrict-aliasing -Wvariadic-macros -Wvolatile-register-var -Wpointer-sign -Wmissing-include-dirs -Wmissing-prototypes -Wmissing-declarations -Wformat=2 -march=i386 -m32 -mrtd -mregparm=3 -mno-mmx -mno-sse -mno-sse2 -mno-sse3 -mno-3dnow -fno-dwarf2-cfi-asm -mno-stack-arg-probe -fno-asynchronous-unwind-tables -fno-unwind-tables -fno-stack-protector'
grub_target_cppflags='-I/builddir/build/BUILD/grub-2.02/grub-i386-pc-2.02 -Wall -W  -DGRUB_MACHINE_PCBIOS=1 -DGRUB_MACHINE=I386_PC -m32 -nostdinc -isystem /usr/lib/gcc/i686-redhat-linux/8/include -I$(top_srcdir)/include -I$(top_builddir)/include'
grub_target_ccasflags=' -g  -m32'
grub_target_ldflags='	-Wl,-z,relro -static -m32 -Wl,-melf_i386 -Wl,--build-id=none'
grub_cflags=''
grub_cppflags=''
grub_ccasflags=''
grub_ldflags=''
grub_target_strip='strip'
grub_target_nm='nm'
grub_target_ranlib='ranlib'
grub_target_objconf=''
grub_target_obj2elf=''
grub_target_img_base_ldopt='-Wl,-Ttext'
grub_target_img_ldflags='@TARGET_IMG_BASE_LDFLAGS@'

# Version
grub_version="2.03"
grub_package="grub"
grub_package_string="GRUB 2.03"
grub_package_version="2.03"
grub_package_name="GRUB"
grub_package_bugreport="bug-grub@gnu.org"
