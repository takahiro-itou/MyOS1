
OUTPUT_FORMAT(binary)
OUTPUT_ARCH(i386)

KERNEL_BASE  =  0x00100000;

SECTIONS {
    .  =  KERNEL_BASE;
    .text       : { *(.text) }
}
