.386P
.model flat

extern _ExitProcess@4: near
extern _GetStdHandle@4: near
extern _WriteConsoleA@20: near


.data

msg			byte	'Hello Worlds!', 10
written		dword	?
out_handle	dword	?

.code
main PROC near
_main:

	; Get the stdout handle
	push	-11					; This Selects the output as opposed to the input or error channels
	call	_GetStdHandle@4
	mov		out_handle, eax		; Save this handle (pointer?) for use later

	; Write our message
	push	0
	push	offset written
	push	14					; Message length
	push	offset msg
	push	out_handle
	call _WriteConsoleA@20

	; Exit Program
	push	0
	call	_ExitProcess@4

main ENDP
END