.386P
.model flat

extern _ExitProcess@4: near
extern _GetStdHandle@4: near
extern _WriteConsoleA@20: near
extern _ReadConsoleA@20: near

.data
quest		byte	'Whats your name: '
msg			byte	'Hello '
name		byte	'                                                         '
msg_end		byte	'!', 10
written		dword	?
read		dword	?
out_handle	dword	?
in_handle	dword	?

.code
main PROC near
_main:

	; Get the stdin handle
	push	-10					; This Selects the output as opposed to the input or error channels
	call	_GetStdHandle@4
	mov		in_handle, eax		; Save this handle (pointer?) for use later

	; Get the stdout handle
	push	-11					; This Selects the output as opposed to the input or error channels
	call	_GetStdHandle@4
	mov		out_handle, eax		; Save this handle (pointer?) for use later

	; Write our message ; https://learn.microsoft.com/en-us/windows/console/writeconsole
	push	0
	push	offset written
	push	17					; Message length
	push	offset quest
	push	out_handle
	call _WriteConsoleA@20

	; Exit Program
	push	0
	call	_ExitProcess@4

main ENDP
END