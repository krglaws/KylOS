[org 0x7c00]
[bits 16]

mov bx, signature
mov ax, [bx]

cmp bx, 0xaa55
je print_t
jmp print_f

print_t:
	mov ah, 0xe
	mov al, "t"
	int 0x10
	jmp done

print_f:
	mov ah, 0xe
	mov al, "f"
	int 0x10
	jmp done

done:
	cli
	hlt

times 510 - ($ - $$) db 0
signature dw 0xaa55
