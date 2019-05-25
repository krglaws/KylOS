[bits 16]
[org 0x7c00]

mov bx, 0x7dfe
mov ax, [bx]
mov cx, 0xa
			; =====================
print_num:		; Remember this kind of
	cmp ax, 0	; thing prints numbers
	je done		; backwards
	xor dx, dx	; =====================
	div cx
	mov bx, ax
	mov ah, 0xe
	mov al, dl
	add al, 0x30
	int 0x10
	mov ax, bx
	jmp print_num 

done:
	cli
	hlt

times 510 - ($ - $$) db 0
dw 0xaa55
