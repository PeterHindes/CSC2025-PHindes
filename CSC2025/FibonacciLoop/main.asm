.386P
.model flat

extern _ExitProcess@4: near

.data

stupid	byte	"IDOT"
srf		dword	offset stupid

.code
main PROC near
_main:

	mov eax, 2		; the nth fibonacci number will be found (not valid for 0 or below) ; !!!! wont work if eax starts at 1 or below

	mov ecx, eax	; set the number of times to loop
	sub ecx, 1		; the loop starts on the third itteration; and continues until i equals n

	mov ebx, 1		; previous
	mov edx, 1		; current
	mov eax, 1		; next

_loop:
	; n = c + p
	mov eax, edx ; current -> next
	add eax, ebx ; next += prev

	; p = c
	mov ebx, edx ; current -> previus

	; c = n
	mov edx, eax ; next -> current

	LOOP _loop

; Exit
	push	0
	call	_ExitProcess@4

main ENDP
END