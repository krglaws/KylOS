# BOOT

BOOTSRC := boot/src/
BOOTBIN := boot/bin/

boot:
	nasm -f bin -o $(BOOTBIN)boot.bin $(BOOTSRC)*.asm

image:
	$(MAKE) boot
	dd conv=notrunc if=$(BOOTBIN)boot.bin of=boot.img

clean:
	rm $(BOOTBIN)*.bin

.PHONY: boot
