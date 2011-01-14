; File name		:	AH14h_HDiag.asm
; Project name	:	IDE BIOS
; Created date	:	28.9.2007
; Last update	:	14.1.2011
; Author		:	Tomi Tilli,
;				:	Krister Nordvall (optimizations)
; Description	:	Int 13h function AH=14h, Controller Internal Diagnostic.

; Section containing code
SECTION .text

;--------------------------------------------------------------------
; Int 13h function AH=14h, Controller Internal Diagnostic.
;
; AH14h_HandlerForControllerInternalDiagnostic
;	Parameters:
;		AH:		Bios function 14h
;		DL:		Drive number (8xh)
;	Parameters loaded by Int13h_Jump:
;		DS:		RAMVARS segment
;	Returns:
;		AH:		BIOS Error code
;		AL:		0 (custom for this BIOS: .bReset byte from DPT)
;		CF:		0 if succesfull, 1 if error
;		IF:		1
;	Corrupts registers:
;		Flags
;--------------------------------------------------------------------
ALIGN JUMP_ALIGN
AH14h_HandlerForControllerInternalDiagnostic:
	call	FindDPT_ForDriveNumber		; DS:DI now points to DPT
	mov		al, [di+DPT.bReset]			; Load reset byte to AL
	test	al, al						; Any error?
	mov		ah, RET_HD_RESETFAIL		; Assume there was an error
	stc
	jnz		SHORT .Return
	xor		ah, ah						; Zero AH and CF since success
.Return:
	jmp		Int13h_PopDiDsAndReturn
