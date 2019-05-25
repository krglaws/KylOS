[bits 16]
[org 0x7e00]

;**************
;start sector 2
;**************

mov ah, 0xe
mov bx, greeting

print_greeting:
	mov al, [bx]
	cmp al, 0
	je done
	int 0x10
	add bx, 1
	jmp print_greeting

done:
	cli
	hlt

greeting db 0x0a, 0x0d, "Successfully read sector 2!", 0

times 512 - ($ - $$) db 0
