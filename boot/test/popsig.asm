[bits 16]
[org 0x7c00]

init_regs:
	
	xor ax, ax
	xor bx, bx
	xor cx, cx
	xor dx, dx

	xor sp, sp
	xor bp, bp
	xor si, si
	xor di, di

setup_stack:
	mov ax, 0x07df
	mov ss, ax
	mov sp, 0x000e

see_if_this_works:
	pop ax
	call print_num

donesky:
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

times 510 - ($ - $$) db 0
dw 0xaa55
	
