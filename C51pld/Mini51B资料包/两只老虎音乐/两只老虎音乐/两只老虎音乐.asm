;两只老虎音乐(用P1.0 口驱动一扬声器)

        org 0000h
        ljmp main

        org 000bh
        ljmp tim0

        org 0030h
main:   mov th0,#0a0h
        mov tl0,#0ffh
        setb et0
        mov tmod,#01h
        setb ea
        setb tr0

loop:
        mov 40h,#0fch
        mov 41h,#44h      ;1
        lcall dely

        mov 40h,#0fch     ; 2
        mov 41h,#0ach
        lcall dely

        mov 40h,#0fdh
        mov 41h,#09h      ;3
        lcall dely

        mov 40h,#0fch
        mov 41h,#44h      ;1
        lcall dely

        clr ea
        lcall delyy
        setb ea

        mov 40h,#0fch
        mov 41h,#44h      ;1
        lcall dely

        mov 40h,#0fch     ;2
        mov 41h,#0ach
        lcall dely

        mov 40h,#0fdh
        mov 41h,#09h      ;3
        lcall dely

        mov 40h,#0fch
        mov 41h,#44h      ;1
        lcall dely
        lcall dely

        clr ea
        lcall delyy
        setb ea


        mov 40h,#0fdh
        mov 41h,#09h      ;3
        lcall dely

        mov 40h,#0fdh
        mov 41h,#34h      ;4
        lcall dely

        mov 40h,#0fdh
        mov 41h,#82h      ;5-
        lcall dely
        lcall dely

        clr ea
        lcall delyy
        setb ea


        mov 40h,#0fdh
        mov 41h,#82h      ;/5
        lcall delyy

        mov 40h,#0fdh    ; /6
        mov 41h,#0c7h
        lcall delyy

        mov 40h,#0fdh
        mov 41h,#82h      ;/5
        lcall delyy

        mov 40h,#0fdh
        mov 41h,#034h      ;/4
        lcall delyy

        mov 40h,#0fdh
        mov 41h,#09h         ;3
        lcall dely

        mov 40h,#0fch
        mov 41h,#44h          ;1
        lcall dely


        clr ea
        lcall delyy
        setb ea

        mov 40h,#0fdh
        mov 41h,#82h     ;/5
        lcall delyy

        mov 40h,#0fdh    ; /6
        mov 41h,#0c7h
        lcall delyy

        mov 40h,#0fdh
        mov 41h,#82h      ;/5
        lcall delyy

        mov 40h,#0fdh
        mov 41h,#034h     ;/4
        lcall delyy

        mov 40h,#0fdh
        mov 41h,#09h      ;3
        lcall dely

        mov 40h,#0fch
        mov 41h,#44h      ;1
        lcall dely

        clr ea
        lcall delyy
        setb ea


        mov 40h,#0fch
        mov 41h,#44h           ;1
        lcall dely

        mov 40h,#0f6h
        mov 41h,#08h        ;.5
        lcall dely

        mov 40h,#0fch
        mov 41h,#44h        ;1-
        lcall dely
        lcall dely

        clr ea
        lcall dely
        setb ea
        ljmp loop


delyy:  mov r5,#02
d0:	mov r7,#080h
d1:     mov r6,#0dfh
d2:     djnz r6,d2
        djnz r7,d1
   	djnz r5,d0
	ret


dely:	mov r5,#02
d00:	mov r7,#0ffh
d11:     mov r6,#0dfh
d22:     djnz r6,d22
        djnz r7,d11
    	djnz r5,d00
	ret

tim0:   mov th0,40h
        mov tl0,41h
        cpl p1.0
        reti
		
		end

