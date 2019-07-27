[bits 16]
[org 0x7c00]

mov si, sta_msg
call print_str

mov ax, sp
call print_num

mov si, end_msg
call print_str

cli
hlt

print_num:
	mov cx, 0x0a
	xor dx, dx
	div cx
	push dx
	cmp ax, 0
	je .done
	call print_num

  .done:
	pop dx
	mov al, dl
	add al, 0x30
	mov ah, 0xe
	int 0x10
	ret

print_str:
	lodsb
	cmp al, 0
	je .done
	mov ah, 0x0e
	int 0x10
	jmp print_str

  .done:
	ret

sta_msg db "the stack starts at: ", 0
end_msg db 0x0d, 0x0a, "done!", 0

times 510 - ($ - $$) db 0
dw 0xaa55
