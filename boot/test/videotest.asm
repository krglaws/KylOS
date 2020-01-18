[bits 16]
[org 0x7c00]

mov ax, 0xffff
mov di, 0x000B7777
mov cx, 0x7777

write:
	mov [di], ax
	add di, 1
	sub cx, 1
	cmp cx, 0
	jne write

cli
hlt

times 510 - ($ - $$) db 0
dw 0xaa55
