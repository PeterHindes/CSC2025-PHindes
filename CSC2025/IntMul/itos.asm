.386P
.model flat

.data

.code

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
END