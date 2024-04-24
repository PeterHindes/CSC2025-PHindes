.386P
.model flat

extern _ExitProcess@4: near
extern _GetStdHandle@4: near
extern _WriteConsoleA@20: near
extern _ReadConsoleA@20: near

.data
base	dword	10
srf10	dword	offset srf10
powten	dword	000001h,00000ah,100,1000,10000		; Our numbers will only be up to 65000 on input alternativley make a power of 10 function that returns the vals for arbitrary values of 10 or go all the way up to 1bilion to max out 32 bit numbers

.code

; Expects a carriage return terminated string and returns a 32 bit unsigned int from the numbers of the char
; does not support skipping non numberic chars to form a number (no commas in your inputs)
atoi PROC near
	
	; Subroutine Prologue
	push ebp     ; Save the old base pointer value.
	mov ebp, esp ; Set the new base pointer value.
	sub esp, 4   ; Make room for one 4-byte local variable.
	; Save the values of registers that the function will modify.
	push ebx
	push edi
	push esi


	; Subroutine main code
	; Find the end of string
	mov edx, [ebp+8]
	sub edx, 1 ; because we start by adding one and we want to support 0 length messages
	nextchar:
	add edx, 1
	mov AL, [edx]
	cmp AL, 13 ; check for enter
	jnz nextchar
	sub edx, [ebp+8]
	; len found and stored in edx
	sub edx, 1 ; make the string 0 indexed

	; for ecx in range 0->edx
	; add up the powers of 10 that make up the number
	; eax += ([response+ecx]-48) * 10^ecx

	mov eax, 0
	mov ecx, edx
	add ecx, 1
	mov ebx, 0
	mov edi, [ebp+8]
	sub edi, 1
	forchars:

		sub ecx, 1
		add edi, 1

		mov eax, 0 ; zero top of register
		mov al, [edi] ; fetch the character
		sub al, 48 ; do asci offset
		; al now has the number at response+ecx

		mov esi, [offset powten + ecx*4]
		; esi now has 10^ecx
		imul eax, esi
		; eax now has ([response+ecx]-48) * 10^ecx
		add ebx, eax ; ebx+=eax

	cmp ecx, 0
	jnz forchars
	
	; ebx now has the number

	mov eax, ebx


	; Subroutine Epilogue 
	pop esi      ; Recover register values
	pop edi
	pop ebx
	mov esp, ebp ; Deallocate local variables
	pop ebp ; Restore the caller's base pointer value
	ret

atoi ENDP
END