
[bits 16]
[org 0x7c00]

; =======================================================
; setup stack and stuff
; 1st KiB reserved for bootloader
; 1st 512 bytes for boot code
; 2nd 512 for stack space -- probably more than necessary
; =======================================================

init:
	mov ax, 0x7e00
	mov ss, ax 	; ss 512 bytes ahead
	mov sp, 0x0200	; sp 512 ahead of ss

	mov ax, 0x0
	mov ds, ax	; set ds to 0, make life easier


; ==========
; main duhhh
; ==========

main:

	; display RAM info
	mov si, ram_str
	call print_str

	call get_ram
	call print_num

	mov si, new_line
	call print_str

	call find_rsdp
	cmp eax, 0

	je .not_found

	mov si, rsdp_found_str
	call print_str
	mov si, new_line
	call print_str

	cli
	hlt

.not_found:

	mov si, rsdp_not_found_str
	call print_str
	mov si, new_line
	call print_str

	cli
	hlt


; ===========================
; in: dx:ax - number to print
; out: none
; ===========================

print_num:
	cmp ax, 0	; if we get 0, 
	je .zero	; just print and return
	
	xor dx, dx
	mov cx, 0xa
	div cx
	push dx		; push remainder
	
	cmp ax, 0	; if quotient is 0
	je .done	; print and return

	call print_num	; otherwise call print_num
	
    .done:
	pop ax		; should be 0x09 or less
	add al, 0x30	; add ASCII offset
	mov ah, 0xe
	int 0x10	; pop and print
	ret

    .zero:
	push ax
	jmp .done


; ==========================
; in: ds:si - pointer to string
; out: none
; ==========================

print_str:
	mov ah, 0xe

    .next:
	lodsb
	cmp al, 0
	je .done
	int 0x10
	jmp .next

    .done:
	ret


; ======================================
; in: none
; out: ax - available RAM in kBs (KiBs?)
; ======================================

get_ram:
	clc
	xor ax, ax
	int 0x12
	ret


; ============================================
; in: none
; out: eax - the address of the RSDP signature
; ============================================

find_rsdp:
	mov eax, 0x0000040E ;ptr to RSDP is sometimes located here

	mov edx, 0x20445352
	mov ecx, [eax]
	cmp ecx, edx
	jne .E0000

	mov edx, 0x20525450
	mov ecx, [eax + 0x04]
	cmp ecx, edx
	jne .E0000

	ret
.E0000:
	mov eax, 0x000DFFFF
.loop:
	add eax, 1
	cmp eax, 0x000E0000 ; any higher and it crashes... check bochsrc for RAM setting?
	je .nada

	mov edx, 0x20445352
	mov ecx, [eax]
	cmp ecx, edx
	jne .loop

	mov edx, 0x20535450
	mov ecx, [eax + 0x04]
	cmp ecx, edx
	jne .loop

	ret
.nada:
	xor eax, eax
	ret


ram_str db "Available RAM (kBs): ", 0

realmode_str db "Entering Protected Mode... ", 0

rsdp_found_str db "RSDP Found.", 0

rsdp_not_found_str db "RSDP Not Found.", 0

new_line db 0x0a, 0x0d, 0x00

times 510 -  ($ - $$) db 0
dw 0xaa55

