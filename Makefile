# BOOT

BOOTSRC := boot/src/
BOOTBIN := boot/bin/

boot:
	nasm -f bin -o $(BOOTBIN)stage1.bin $(BOOTSRC)stage1.asm
	nasm -f bin -o $(BOOTBIN)stage2.bin $(BOOTSRC)stage2.asm

image:
	$(MAKE) boot
	dd conv=notrunc if=$(BOOTBIN)stage1.bin of=boot.img
	dd conv=notrunc if=$(BOOTBIN)stage2.bin seek=1 of=boot.img

clean:
	rm $(BOOTBIN)*.bin

.PHONY: boot
