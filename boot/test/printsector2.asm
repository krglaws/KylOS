[bits 16]
[org 0x7c00]

reset_disk:

	mov ah, 0xe
	mov al, "z"
	int 0x10	; print 'z' for every reset attempt
	
	mov ah, 0
	mov dl, 0
	int 0x13	; reset the disk
	jc reset_disk
	
	mov ax, 0x0000
	mov es, ax	
	mov bx, 0x7e00	; load sector 2 here

read_disk:
	
	mov ah, 0xe
	mov al, "r"
	int 0x10	; print 'r' for every read attempt

	mov ah, 2	; read sector from drive
	mov al, 1	; number of sectors
	mov ch, 0	; cylinder number
	mov cl, 2	; sector number (sector nums start from 1)
	mov dh, 0	; head number
	mov dl, 0	; drive number
	int 0x13
	jc reset_disk

print_setup:

	mov ah, 0xe
	mov al, "n"
	int 0x10
	mov al, ":"
	int 0x10

	mov bx, 0x7e00
	mov ax, [bx]
	mov cx, 0xa

print:
	cmp ax, 0
	je done
	xor dx, dx
	div cx
	mov bx, ax
	mov ah, 0xe
	mov al, dl
	add al, 0x30
	int 0x10
	mov ax, bx
	jmp print

done:
	mov bx, done_msg
	mov ah, 0xe

print_done:
	mov al, [bx]
	cmp al, 0
	je donedone
	int 0x10
	add bx, 1
	jmp print_done
	
donedone:
	cli
	hlt	

done_msg db 0x0a, 0x0d, "Done.", 0
times 510 - ($ - $$) db 0
dw 0xaa55

; ========
; SECTOR 2
; ========

dw 0x8888
times 510 db 0
