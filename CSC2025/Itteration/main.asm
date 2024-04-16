.386P
.model flat

extern _ExitProcess@4: near
extern _GetStdHandle@4: near
extern _WriteConsoleA@20: near

.data
prelude	byte	'The sum is: '
msg		byte	'0'
msg2	byte	'0'
written		dword	?
out_handle	dword	?

.code
main PROC near
_main:

	; eax = sum
	; ebx = i

	mov eax, 0

	mov ebx, 0
_loop:
	cmp ebx, 11
	je _quit

	add eax, ebx

	add ebx, 1
	jmp _loop

_quit:
	mov ebx, eax	; save eax
	mov edx, 0		; clear edx
	mov esi, 10
	idiv esi		; divide edx - eax by 10
	mov ecx, eax	; save the 10s place
	imul eax, 10	; restore the eax for a modulus effect
	sub ebx, eax	; subtract from our orig number to make ebx the 1s place
	add ecx, 48		; shift the raw number over to the ascii code for numbers - 10s palce
	add ebx, 48		; 1s place

	mov msg, bl
	mov msg2, cl

	; Get the stdout handle
	push	-11					; This Selects the output as opposed to the input or error channels
	call	_GetStdHandle@4
	mov		out_handle, eax		; Save this handle (pointer?) for use later

	; Write our message ; https://learn.microsoft.com/en-us/windows/console/writeconsole
	push	0
	push	offset written
	push	14					; Message length
	push	offset prelude
	push	out_handle
	call _WriteConsoleA@20

	; exit
	push	0
	call	_ExitProcess@4

main ENDP
END