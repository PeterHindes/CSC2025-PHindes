.386P
.model flat

extern _ExitProcess@4: near
extern _GetStdHandle@4: near
extern _WriteConsoleA@20: near

.data
;srf			DWORD	offset srf
msg			byte	'hi', 10
nullterm	byte	0
overflow	byte	'Dont print this'

.code
main PROC near

	; Test registers are safe
	mov eax, 5555555
	mov ebx, 5555555
	mov ecx, 5555555
	mov edx, 5555555
	mov esi, 5555555
	mov edi, 5555555

	; Save Caller saved vals
	push eax
	push ecx
	push edx

	push offset msg
	call PrintLine

	;sub esp, 4 ; clear args
	pop edx
	pop ecx
	pop eax

	push	0
	call	_ExitProcess@4

main ENDP


; Print A Message From Memory address
; 1 argument: message address
PrintLine PROC near
	; Prologue
	push ebp
	mov ebp, esp
	sub esp, 8 ; make room for written and out handle
	; Dont save any registers as we will only use caller saved registers to save time

	mov ecx, [ebp+8]	; load in our message pointer

	; Find the end of string
	mov edx, [ebp+8]
	sub edx, 1 ; because we start by adding one and we want to support 0 length messages
	nextchar:
	add edx, 1
	mov AL, [edx]
	cmp AL, 0
	jnz nextchar
	sub edx, [ebp+8]
	; len found and stored in edx

	; or you could just take in the end ptr and diff them
	;mov edx, offset nullterm
	;sub edx, offset msg
	
	; Get the stdout handle
	push	-11					; This Selects the output as opposed to the input or error channels
	call	_GetStdHandle@4

	; Write our message ; https://learn.microsoft.com/en-us/windows/console/writeconsole
	push	0
	push	ebp					; Bytes Written Output
	push	edx					; Message length
	push	ecx					; Message Address
	push	eax					; Out Handle
	call _WriteConsoleA@20

	; Return Value
	mov eax, [ebp]

	; Epilogue
	mov esp, ebp
	pop ebp
	ret 4 ; clear args

PrintLine ENDP
END