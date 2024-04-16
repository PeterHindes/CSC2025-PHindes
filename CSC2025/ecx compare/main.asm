.386P
.model flat

extern _ExitProcess@4: near
extern _GetStdHandle@4: near
extern _WriteConsoleA@20: near


.data

negmsg		byte	'The number is negative', 10
posmsg		byte	'The number is positive', 10
written		dword	?
out_handle	dword	?

.code
main PROC near
_main:

	; Get the stdout handle
	push	-11					; This Selects the output as opposed to the input or error channels
	call	_GetStdHandle@4
	mov		out_handle, eax		; Save this handle (pointer?) for use later

	; Setup ecx
	mov ecx, -500

	; Conditional flow
	cmp ecx, 0
	;js _neg
	jns _pos 
_neg:
	; Change msg addr
	mov ebx, offset negmsg
	jmp _write
_pos:
	mov ebx, offset posmsg
_write:
	; Write our message ; https://learn.microsoft.com/en-us/windows/console/writeconsole
	push	0
	push	offset written
	push	23					; Message length
	push	ebx
	push	out_handle
	call _WriteConsoleA@20

	; Exit Program
	push	0
	call	_ExitProcess@4


main ENDP
END