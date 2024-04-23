.386P
.model flat

extern _ExitProcess@4: near
extern _GetStdHandle@4: near
extern _WriteConsoleA@20: near
extern _ReadConsoleA@20: near

.data

srf			DWORD	offset srf +4
request		byte	'Please input number : ', 0
base		dword	10

srf2		DWORD	offset srf2 +4
response	byte	'fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff'		; There's a problem here we can't use all 1023 characters because we're limited to 32 bit numbers 
res2		byte	'fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff'		; we need 107 bits to store the full number 
res3		byte	'fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff'
res4		byte	'fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff'
res5		byte	'fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff'
res6		byte	'fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff'
res7		byte	'fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff'
res8		byte	'fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff'
res9		byte	'fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff'
res10		byte	'fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff'
res11		byte	'fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff'
res12		byte	'fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff'
res13		byte	'fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff'
res14		byte	'fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff'

srf3		DWORD	offset srf3 +4
answer	dword	0

.code
main PROC near
_main:

	; Get handle
	; Dont save registers because they are unused at this point
	push	-11					; This Selects the output
	call	_GetStdHandle@4
	; eax now has the handle

	; Print a request for info
	push	0
	push	ebp					; Bytes Written Output
	push	23					; Message length
	push	offset request		; Message Address
	push	eax					; Out Handle
	call _WriteConsoleA@20


	; Get handle
	; Dont save registers because they are unused at this point
	push	-10					; This Selects the input
	call	_GetStdHandle@4
	; eax now has the handle

	; Read a number from the console as a string
	push	0
	push	ebp					; Bytes Written Output
	push	1023				; Message length
	push	offset response		; Message Address
	push	eax					; In Handle
	call _ReadConsoleA@20

	; Find the end of string
	mov edx, offset response
	sub edx, 1 ; because we start by adding one and we want to support 0 length messages
	nextchar:
	add edx, 1
	mov AL, [edx]
	cmp AL, 13 ; check for enter
	jnz nextchar
	sub edx, offset response
	; len found and stored in edx
	sub edx, 1 ; make the string 0 indexed

	; for ecx in range 0->edx
	; add up the powers of 10 that make up the number
	; eax += ([response+ecx]-48) * 10^ecx

	mov ecx, -1
	mov ebx, 0
	forchars:
		add ecx, 1
		
		mov eax, edx
		sub eax, ecx
		mov edi, 1 ; result
		power:
			cmp eax, 0
			jz endpower

			imul edi, base

			dec eax
			jmp power
		endpower:
		; edi now has 10^ecx

		mov eax, 0
		mov al, [response+ecx]
		sub al, 48
		; al now has the number at response+ecx

		imul eax, edi
		; eax now has ([response+ecx]-48) * 10^ecx
		add ebx, eax
	cmp ecx, edx
	jnz forchars
	
	; ebx now has the number

	mov answer, ebx

	push	0
	call	_ExitProcess@4

main ENDP
END