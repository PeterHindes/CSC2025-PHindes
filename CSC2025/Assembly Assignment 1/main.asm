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

	xchg	number1, number4
	xchg	number2, number3

	push	0
	call	_ExitProcess@4

main ENDP
END