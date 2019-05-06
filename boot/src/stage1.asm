[org 0x7c00]
[bits 16]

mov ah, 0xe
mov bx, greeting

print_greeting:
	mov al, [bx]
	cmp al, 0
	je find_ram
	int 0x10
	add bx, 1
	jmp print_greeting

find_ram:
	xor ax, ax
	xor bx, bx
	xor cx, cx
	xor dx, dx
	int 0x12
	mov cx, 0xa

print_ram:
	cmp ax, 0	; if RAM is 0,
	je done		; jump to done
	xor dx, dx	; zero out dx
	div cx		; ax = dx:ax / cx, dx = ax % cx
	mov bx, ax	; save RAM count
	mov ah, 0xe	; prepare to print
	mov al, dl	; grab mod from dx
	add al, 0x30	; apply ascii offset
	int 0x10	; print
	mov ax, bx	; return RAM to ax
	jmp print_ram	; loop

done:
	hlt

greeting db "Welcome to KylOS!", 0x0a, 0x0d, 0x0a, 0x0d, "Available memory (KBs): ", 0

times 510 - ($ - $$) db 0
dw 0xaa55

