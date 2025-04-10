.386P
.model flat


extern _GetStdHandle@4: near
extern _WriteConsoleA@20: near
extern _ExitProcess@4: near



.data
    dwordValue DWORD 4294967295
    srf dword offset srf +4
    charArray BYTE 10 DUP(?) ; Allocate space for 10 characters (32bits max)
	nullterm  byte 0
.code
main PROC

	push OFFSET charArray + LENGTHOF charArray
	push dwordValue
	call itos

	push eax
    call writeline


    ; Exit the program
    push	0
	call	_ExitProcess@4
main ENDP

; Expects pointer to end of destination string
; expects dword to decode
; returns address of string start in eax
itos PROC

	; Subroutine Prologue
	push ebp     ; Save the old base pointer value.
	mov ebp, esp ; Set the new base pointer value.
	sub esp, 4   ; Make room for one 4-byte local variable.
	; Save the values of registers that the function will modify.
	push ebx
	push edi
	push esi


	; Subroutine Body

	; Load from stack
	mov edi, [ebp+12]
	mov eax, [ebp+8]

	; Convert the DWORD value to decimal
    mov ebx, 10                  ; Divisor for decimal conversion

convert_loop:
    mov edx, 0                  ; Clear the remainder
    div ebx                     ; Divide EAX by EBX, result in EAX, remainder in EDX
    add dl, '0'                 ; Convert the remainder to ASCII
    mov [edi], dl               ; Store the ASCII character in the character array
    dec edi                     ; Move to the next character in the array
    cmp eax, 0                  ; Check if quotient is zero
    jnz convert_loop            ; If not zero, continue conversion

    inc edi                     ; Adjust to the first char of the array

end_conversion:
    ; Now edi points to the begining of our string

	mov eax, edi


	; Subroutine Epilogue 
	pop esi      ; Recover register values
	pop edi
	pop ebx
	mov esp, ebp ; Deallocate local variables
	pop ebp ; Restore the caller's base pointer value
	ret

itos ENDP


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
