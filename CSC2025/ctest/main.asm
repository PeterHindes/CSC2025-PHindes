_DATA   SEGMENT
$SG7431 DB        '65000', 00H
_DATA   ENDS
voltbl  SEGMENT
_volmd  DD  0ffffffffH
        DDSymXIndex:    FLAT:_main
        DD      0dH
        DD      033H
voltbl  ENDS

_i$1 = -4                                         ; size = 4
_num$ = 8                                         ; size = 4
_pow$ = 12                                          ; size = 4
_pow    PROC
        push    ebp
        mov     ebp, esp
        push    ecx
        mov     DWORD PTR _i$1[ebp], 0
        jmp     SHORT $LN4@pow
$LN2@pow:
        mov     eax, DWORD PTR _i$1[ebp]
        add     eax, 1
        mov     DWORD PTR _i$1[ebp], eax
$LN4@pow:
        mov     ecx, DWORD PTR _i$1[ebp]
        cmp     ecx, DWORD PTR _pow$[ebp]
        jge     SHORT $LN3@pow
        mov     edx, DWORD PTR _num$[ebp]
        imul    edx, DWORD PTR _num$[ebp]
        mov     DWORD PTR _num$[ebp], edx
        jmp     SHORT $LN2@pow
$LN3@pow:
        mov     eax, DWORD PTR _num$[ebp]
        mov     esp, ebp
        pop     ebp
        ret     0
_pow    ENDP

_accumulate$ = -8                                 ; size = 4
_i$ = -4                                                ; size = 4
_res$ = 8                                         ; size = 4
_terminator$ = 12                                 ; size = 1
_atoi   PROC
        push    ebp
        mov     ebp, esp
        sub     esp, 8
        push    esi
        mov     DWORD PTR _i$[ebp], 0
        mov     DWORD PTR _accumulate$[ebp], 0
$LN2@atoi:
        mov     eax, DWORD PTR _res$[ebp]
        add     eax, DWORD PTR _i$[ebp]
        movsx   ecx, BYTE PTR [eax]
        movsx   edx, BYTE PTR _terminator$[ebp]
        cmp     ecx, edx
        je      SHORT $LN3@atoi
        mov     eax, DWORD PTR _res$[ebp]
        add     eax, DWORD PTR _i$[ebp]
        movsx   esi, BYTE PTR [eax]
        sub     esi, 48                             ; 00000030H
        mov     ecx, DWORD PTR _i$[ebp]
        push    ecx
        push    10                                  ; 0000000aH
        call    _pow
        add     esp, 8
        imul    esi, eax
        add     esi, DWORD PTR _accumulate$[ebp]
        mov     DWORD PTR _accumulate$[ebp], esi
        jmp     SHORT $LN2@atoi
$LN3@atoi:
        pop     esi
        mov     esp, ebp
        pop     ebp
        ret     0
_atoi   ENDP

_res$ = -12                                   ; size = 6
__$ArrayPad$ = -4                                 ; size = 4
_main   PROC
        push    ebp
        mov     ebp, esp
        sub     esp, 12                             ; 0000000cH
        mov     eax, DWORD PTR ___security_cookie
        xor     eax, ebp
        mov     DWORD PTR __$ArrayPad$[ebp], eax
        mov     eax, DWORD PTR $SG7431
        mov     DWORD PTR _res$[ebp], eax
        mov     cx, WORD PTR $SG7431+4
        mov     WORD PTR _res$[ebp+4], cx
        push    13                                  ; 0000000dH
        lea     edx, DWORD PTR _res$[ebp]
        push    edx
        call    _atoi
        add     esp, 8
        xor     eax, eax
        mov     ecx, DWORD PTR __$ArrayPad$[ebp]
        xor     ecx, ebp
        call    @__security_check_cookie@4
        mov     esp, ebp
        pop     ebp
        ret     0
_main   ENDP