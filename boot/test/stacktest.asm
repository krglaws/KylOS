[bits 16]
[org 0x7c00]

; setup the stack

xor ax, ax
mov ss, ax
mov sp, 0x4000

mov ax, 0x7c0
mov ds, ax

print_2_As:
	mov ah, 0xe
	mov al, "A"
	int 0x10
	pusha
	call print_1_B
	popa
	int 0x10

cli
hlt

print_1_B:
	mov ah, 0xe
	mov al, "B"
	int 0x10
	ret

times 510 - ($ - $$) db 0
dw 0xaa55
