.386P
.model flat


extern _GetStdHandle@4: near
extern _WriteConsoleA@20: near
extern _ExitProcess@4: near



.data
    dwordValue DWORD 12345678
    srf dword offset srf +4
    charArray BYTE 20 DUP(?) ; Allocate space for 20 characters

.code
main PROC
    mov eax, dwordValue         ; Load the DWORD value into EAX
    mov ecx, LENGTHOF charArray ; Set ECX to the length of the character array
    mov edi, OFFSET charArray   ; Set EDI to point to the start of the character array

    ; Handle the case of zero separately
    test eax, eax
    jnz nonzero

    ; If the value is zero, simply store '0' and terminate the string
    mov byte ptr [edi], '0'
    inc edi
    mov byte ptr [edi], 0
    jmp end_conversion

nonzero:
    ; Convert the DWORD value to decimal
    mov ebx, 10                  ; Divisor for decimal conversion

convert_loop:
    xor edx, edx                ; Clear the remainder
    div ebx                     ; Divide EAX by EBX, result in EAX, remainder in EDX
    add dl, '0'                 ; Convert the remainder to ASCII
    mov [edi], dl               ; Store the ASCII character in the character array
    inc edi                     ; Move to the next character in the array
    test eax, eax               ; Check if quotient is zero
    jnz convert_loop            ; If not zero, continue conversion

    ; Reverse the character array
    mov esi, OFFSET charArray   ; Point to the start of the array
    mov edi, edi                ; Point to the end of the array
    dec edi                     ; Adjust to the last character

reverse_loop:
    cmp esi, edi                ; Compare pointers
    jge end_reverse             ; If equal or crossed, stop reversing
    mov al, [esi]               ; Swap characters
    mov dl, [edi]
    mov [esi], dl
    mov [edi], al
    inc esi                     ; Move to the next character from the start
    dec edi                     ; Move to the previous character from the end
    jmp reverse_loop

end_reverse:
    ; Add a null terminator to the end of the character array
    mov byte ptr [edi+1], 0

end_conversion:
    ; Now charArray contains the decimal representation of dwordValue

    push offset charArray
    call writeline

    ; Add your code here to further process or display the character array

    ; Exit the program
    push	0
	call	_ExitProcess@4
main ENDP


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
