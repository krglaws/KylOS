[bits 16]
[org 0x7c00]

; what happens if I don't set the stack pointer before pushing and popping?

xor bx, bx
mov bl, "A"

push bx
pop bx

mov al, bl
mov ah, 0xe
int 0x10

cli
hlt

times 510 - ($ - $$) db 0
dw 0xaa55
