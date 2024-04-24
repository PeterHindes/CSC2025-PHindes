.386P
.model flat

extern _GetStdHandle@4: near
extern _ReadConsoleA@20: near

.data

.code

; Expects a null terminated strings address as its only perameter, it will read a string up to 6 bytes (including enter) from the user into this address
readline PROC near

	; Subroutine Prologue
	push ebp     ; Save the old base pointer value.
	mov ebp, esp ; Set the new base pointer value.
	sub esp, 4	 ; make room for our number of bytes read variable
	; no need to save any registers
	
	; Subroutine Body

	; Get handle
	push	-10					; This Selects the output
	call	_GetStdHandle@4
	; eax now has the handle

	;add esp, 4 ; clear args ; we dont care if the stack has an extra 4 bytes on it

	; ReadConsole
	push	0
	push	ebp					; Bytes read
	push	[ebp+12]			; Message length (does this include the enter?)
	push	[ebp+8]				; Message Address
	push	eax					; In Handle
	call _ReadConsoleA@20

	; Return info about bytes read to caller in eax
	mov eax, [ebp]

	;add esp, 20 ; clear args ; unneeded as we are about to overwrite esp anyway.

	; Here is where we would restore any registers
	mov esp, ebp ; Deallocate local variable
	pop ebp ; Restore the caller's base pointer value
	ret ; pops off from esp the return address and returns

readline ENDP
END