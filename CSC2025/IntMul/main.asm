.386P
.model flat

extern _ExitProcess@4: near
extern _GetStdHandle@4: near
extern _WriteConsoleA@20: near
extern _ReadConsoleA@20: near

includelib .\writeline.asm
extern writeline: near

includelib .\readline.asm
extern readline: near

includelib .\atoi.asm
extern atoi: near

includelib .\itos.asm
extern itos: near

.data

srf				DWORD	offset srf +4
request1		BYTE	'Enter Number 1: ', 0
request2		BYTE	'Enter Number 2: ', 0
base			DWORD	10

srf2			DWORD	offset srf2 +4
; These strings are carriage return terminated and may not be full length
response1		BYTE	'65000', 0Dh  ; prepopulated with max value
response2		BYTE	'65000', 0Dh  ; prepopulated with max value

srf3		DWORD	offset srf3 +4
answer		DWORD	0

ansmsg		byte	'The multiplication result is: ','          '
nulltterm	byte	0

.code
main PROC near

	; We arent using any registers so dont save any
	
	push offset request1
	call writeline

	push 5
	push offset response1
	call readline

	push offset request2
	call writeline

	push 5
	push offset response2
	call readline

	; Convert strings to ints
	push offset response1
	call atoi

	mov ebx, eax

	push offset response2
	call atoi

	imul eax, ebx

	add esp, 26 ; clear all the arguments from previous function calls

	;mov answer, eax

	push OFFSET ansmsg + LENGTHOF ansmsg
	push eax
	call itos

	push eax
	call writeline

	push	0
	call	_ExitProcess@4

main ENDP
END