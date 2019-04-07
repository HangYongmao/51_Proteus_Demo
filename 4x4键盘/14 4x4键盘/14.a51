KEYBUF    EQU 30H
            ORG 00H
START:      MOV KEYBUF,#2
WAIT:   
            MOV P3,#0FFH
            CLR P3.4
            MOV A,P3
            ANL A,#0FH  
            XRL A,#0FH
            JZ NOKEY1
            LCALL DELY10MS
            MOV A,P3
            ANL A,#0FH
            XRL A,#0FH
            JZ NOKEY1
            MOV A,P3
            ANL A,#0FH
            CJNE A,#0EH,NK1
            MOV KEYBUF,#0
            LJMP DK1
NK1:        CJNE A,#0DH,NK2
            MOV KEYBUF,#1
            LJMP DK1
NK2:        CJNE A,#0BH,NK3
            MOV KEYBUF,#2
            LJMP DK1
NK3:        CJNE A,#07H,NK4
            MOV KEYBUF,#3
            LJMP DK1
NK4:        NOP
DK1:    
            MOV A,KEYBUF
            MOV DPTR,#TABLE
            MOVC A,@A+DPTR
            MOV P0,A

DK1A:       MOV A,P3
            ANL A,#0FH
            XRL A,#0FH
            JNZ DK1A
NOKEY1:
            MOV P3,#0FFH
            CLR P3.5
            MOV A,P3
            ANL A,#0FH
            XRL A,#0FH
            JZ NOKEY2
            LCALL DELY10MS
            MOV A,P3
            ANL A,#0FH
            XRL A,#0FH
            JZ NOKEY2
            MOV A,P3
            ANL A,#0FH
            CJNE A,#0EH,NK5
            MOV KEYBUF,#4
            LJMP DK2
NK5:        CJNE A,#0DH,NK6
            MOV KEYBUF,#5
            LJMP DK2
NK6:        CJNE A,#0BH,NK7
            MOV KEYBUF,#6
            LJMP DK2
NK7:        CJNE A,#07H,NK8
            MOV KEYBUF,#7
            LJMP DK2
NK8:        NOP
DK2:    
            MOV A,KEYBUF
            MOV DPTR,#TABLE
            MOVC A,@A+DPTR
            MOV P0,A

DK2A:       MOV A,P3
            ANL A,#0FH
            XRL A,#0FH
            JNZ DK2A
NOKEY2:
            MOV P3,#0FFH
            CLR P3.6
            MOV A,P3
            ANL A,#0FH
            XRL A,#0FH
            JZ NOKEY3
            LCALL DELY10MS
            MOV A,P3
            ANL A,#0FH
            XRL A,#0FH
            JZ NOKEY3
            MOV A,P3
            ANL A,#0FH
            CJNE A,#0EH,NK9
            MOV KEYBUF,#8
            LJMP DK3
NK9:        CJNE A,#0DH,NK10
            MOV KEYBUF,#9
            LJMP DK3
NK10:       CJNE A,#0BH,NK11
            MOV KEYBUF,#10
            LJMP DK3
NK11:       CJNE A,#07H,NK12
            MOV KEYBUF,#11
            LJMP DK3
NK12:       NOP
DK3:
            MOV A,KEYBUF
            MOV DPTR,#TABLE
            MOVC A,@A+DPTR
            MOV P0,A

DK3A:       MOV A,P3
            ANL A,#0FH
            XRL A,#0FH
            JNZ DK3A
NOKEY3:
            MOV P3,#0FFH
            CLR P3.7
            MOV A,P3
            ANL A,#0FH
            XRL A,#0FH
            JZ NOKEY4
            LCALL DELY10MS
            MOV A,P3
            ANL A,#0FH
            XRL A,#0FH
            JZ NOKEY4
            MOV A,P3
            ANL A,#0FH
            CJNE A,#0EH,NK13
            MOV KEYBUF,#12
            LJMP DK4
NK13:       CJNE A,#0DH,NK14
            MOV KEYBUF,#13
            LJMP DK4
NK14:       CJNE A,#0BH,NK15
            MOV KEYBUF,#14
            LJMP DK4
NK15:       CJNE A,#07H,NK16
            MOV KEYBUF,#15
            LJMP DK4
NK16:       NOP
DK4:        MOV A,KEYBUF
            MOV DPTR,#TABLE
            MOVC A,@A+DPTR
            MOV P0,A
DK4A:       MOV A,P3
            ANL A,#0FH 
            XRL A,#0FH  
            JNZ DK4A
NOKEY4:
            LJMP WAIT
DELY10MS:
            MOV R6,#10
D1:         MOV R7,#248
            DJNZ R7,$
            DJNZ R6,D1
            RET
TABLE:      DB 3FH,06H,5BH,4FH,66H,6DH,7DH,07H
            DB 7FH,6FH,77H,7CH,39H,5EH,79H,71H
            END
