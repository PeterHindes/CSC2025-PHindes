.386P
.model flat

extern _GetStdHandle@4: near
extern _WriteConsoleA@20: near

.data

.code

; Print A Message From Memory address
; 1 argument: the address of a null terminated message to print
; 1 return: the number of bytes we printed
writeline PROC near

	; Prologue
	push ebp
	mov ebp, esp
	sub esp, 4; make room for written bytes value
	; Save Callee registers

	mov ecx, [ebp + 8]; load in our message pointer

	; Find the end of string
	mov edx, [ebp + 8]
	sub edx, 1; because we start by adding one and we want to support 0 length messages
	nextchar :
	add edx, 1
	mov AL, [edx]
	cmp AL, 0
	jnz nextchar
	sub edx, [ebp + 8]
	; len found and stored in edx

	; Get the stdout handle
	push -11; This Selects the output as opposed to the input or error channels
	call _GetStdHandle@4

	; Write our message; https://learn.microsoft.com/en-us/windows/console/writeconsole
	push	0
	push	ebp; Bytes Written Output STUPID STUFF NEEDS TO BE FIXED!!!!!
	push	edx; Message length
	push	ecx; Message Address
	push	eax; Out Handle
	call _WriteConsoleA@20

	; Return Value
	mov eax, [ebp]

	; Epilogue
	mov esp, ebp
	pop ebp
	; ret 4; clear args
	ret; Actualy dont clear args, the caller will handle it

writeline ENDP
END