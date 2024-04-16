.386P
.model flat

extern _ExitProcess@4: near

.data
number1		dword	10
number2		dword	20
number3		dword	30
number4		dword	40

.code
main PROC near
_main:

	mov eax, number1
	mov ebx, number2
	mov ecx, number3
	mov edx, number4

	xchg eax, edx
	xchg ebx, ecx

	mov number1, eax
	mov number2, ebx
	mov number3, ecx
	mov number4, edx

	push	0
	call	_ExitProcess@4

main ENDP
END