		  org 0000h
		  jmp start
		  org 0bh
		  jmp tim0
	    
start: 
       mov sp,#70h
	   mov 24h,#0ffh
	   mov 23h,#0ffh
	   mov 22h,#0ffh
	   mov 21h,#0ffh
	   mov 2ch,#00
	   mov 2bh,#00
	   mov 2ah,#12
	   
	   mov tmod,#01h
	   mov th0,#(65536-10000)/256
	   mov tl0,#(65536-10000)mod 256
	   mov ie,#10000010b
	   mov r4,#170
	   mov dptr ,#0ffech
	   setb tr0

	  
		 
loop:
     jb p3.5, n2
     call delay
	 clr p1.7
	 mov a,2bh
	 add a,#01h
	 mov 2bh,a
     cjne a,#60,n1
	 mov 2bh,#00
n1:  	
        jnb p3.5,$
        setb p1.7
        call delay
n2:  jb p3.4,n4
     call delay
	 clr p1.0
	 mov a,2ah
	 add a,#01h
	 mov 2ah,a
	 cjne a,#24,n3
	 mov 2ah,#00
n3:  jnb p3.4,$
     setb p1.0
     call delay
n4:	
    jmp loop



tim0: 
     setb p1.4

       
     mov th0,#(65536-10000)/256
	  mov tl0,#(65536-10000)mod 256
	  push acc
	  push psw
	 
	  djnz r4,x2
	  
	  mov r4,170
	  call clock	   
	  call disp
x2:   call x3
	  
      pop psw
	  pop acc
	   
	  reti
x3:  
	mov dptr,#0ffefh
    mov a,21h
	movx @dptr,a
	mov dptr,#0ffeeh
	mov a,22h
	movx @dptr,a
	mov dptr,#0ffedh
	mov a,23h
	movx @dptr,a
	  mov dptr,#0ffech
	mov a,24h
	movx @dptr,a	 			
	ret
	

clock:
      
 	  mov a,2ch
	  add a,#1	  
	  mov 2ch,a
	  cjne a,#60,x4
	  mov 2ch,#00
	  mov a,2bh
	  add a,#1
	  mov 2bh,a
	  cjne a,#60,x4
	  mov 2bh,#00
	  mov a,2ah
	  add a,#1
	  mov 2ah,a
	  cjne a,#24,x4
	  mov 2ah,#00
	
x4:   ret


	 
disp:  
       clr  p1.4
       lcall delay
       lcall delay
      mov r1,#20h
	  mov a,2ch
	  mov b,#10
	  div ab
	  mov @r1,b
	  inc r1
	  
	  mov a,2bh
	  mov b,#10
	  div ab
	  mov dptr,#tab
	  movc a,@a+dptr
	  mov 22h,a
	  mov a,b
	  mov dptr,#tab
	  movc a,@a+dptr
	  mov 21h,a
	 
	  mov  a ,2ah
	  
	  mov b,#10
	  div ab
	  mov dptr,#tab
	  movc a,@a+dptr
	  mov  24h,a
	  mov  a,b
	  mov dptr,#tab1
	  movc a,@a+dptr
	  mov 23h,a
	  

	  ret



delay: mov r6,#200
d1:    mov r5,#250
	  
	   djnz r5,$
	   djnz r6,d1
	   ret 

tab: db 0c0h ,0f9h,0a4h,0b0h,099h,092h,082h,0f8h,080h,090h
tab1: db 40h,79h,24h,30h,19h,12h,02h,78h,00h,10h
		 end
	    
	  
	 