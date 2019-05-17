[bits 16]
[org 0x7c00]

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
	cmp ax, 0
	je ram_done
	xor dx, dx
	div cx
	mov bx, ax
	mov ah, 0xe
	mov al, dl
	add al, 0x30
	int 0x10
	mov ax, bx
	jmp print_ram	

ram_done:
	mov ah, 0x0e
	mov bx, read_attempt_msg

print_read_attempt:
	mov al, [bx]
	cmp al, 0
	je reset_disk
	int 0x10
	add bx, 1
	jmp print_read_attempt

reset_disk:

	mov ah, 0xe 
	mov al, "z"
	int 0x10 	; print 'z' for every reset attempt

	mov ah, 0
	mov dl, 0
	int 0x13
	jc reset_disk

	mov ax, 0x0000
	mov es, ax
	mov bx, 0x7e00

read_disk:

	mov ah, 0x0e
	mov al, "r"
	int 0x10	; print 'r' for every read attempt

	mov ah, 0x02
	mov al, 1
	mov ch, 1
	mov cl, 2
	mov dh, 0
	mov dl, 0
	int 0x13
	jc read_disk
	
;	jmp 0x0:0x7e00

get_byte_at_7e00:
	
	mov ah, 0xe
	mov al, "b"
	int 0x10
	
	mov al, ":"
	int 0x10
	
	mov al, " "
	int 0x10

	mov bx, 0x7dff
	mov ax, [bx]
	mov cx, 0xa
	
print_byte:
	cmp ax, 0
	je done
	xor dx, dx
	div cx
	mov bx, ax
	mov ah, 0xe
	mov al, dl
	int 0x10
	mov ax, bx
	jmp print_byte

done:
	cli
	hlt

greeting db "Welcome to KylOS!", 0x0a, 0x0d, 0x0a, 0x0d, "Available memory (KBs): ", 0
read_attempt_msg db 0x0a, 0x0d, "Attempting to read sector 2...", 0x0a, 0x0d, 0

times 510 - ($ - $$) db 0
dw 0xaa55

