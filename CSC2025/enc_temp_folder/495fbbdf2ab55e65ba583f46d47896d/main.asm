.386P
.model flat

extern _ExitProcess@4: near

.data

.code
main PROC near
_main:

	mov eax, 0 ; the nth fibonacci number will be found

	; previous	ebx
	; current	ecx
	; next		edx
	; 
	; i			esi
	mov esi, 3
	mov ebx, 1
	mov ecx, 1
	mov edx, 1
_loop:
	; i <= n
	cmp esi, eax
	jg _exit

	; n = c + p
	mov edx, ecx ; current -> next
	add edx, ebx ; next += prev

	; p = c
	mov ebx, ecx ; current -> previus

	; c = n
	mov ecx, edx ; next -> current

	; i++
	add esi, 1
	jmp _loop

_exit:
	
	mov eax, edx

	; Exit
	push	0
	call	_ExitProcess@4

main ENDP
END