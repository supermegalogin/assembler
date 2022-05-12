.386
dseg segment use16
 	a	dw 1,2,-3,288,+128
 	b	db 'abc'
 	c	db 5 dup(?)
 	 	db 5 dup(?)
dseg  ends
cseg segment use16
 	assume ds:dseg,cs:cseg
 	m1:	mov ax,dseg
 		mov ds,ax

 		mov ax,0h
		
 		mov al, byte ptr ds:a+1
 		mov ds:c,al

		mov al, byte ptr ds:a+3
 		mov ds:c+1,al

 		mov al, byte ptr ds:a+5
 		mov ds:c+2,al

 		mov al, byte ptr ds:a+7
 		mov ds:c+3,al

 		mov al, byte ptr ds:a+9
 		mov ds:c+4,al

 		mov ds:c+5,'0'

 		mov al, byte ptr ds:b+2
 		mov ds:c+7,al

 		mov al, byte ptr ds:b+1
		mov ds:c+8,al

		mov al, byte ptr ds:b
		mov ds:c+9,al

		mov ah,4ch
 		int 21h
cseg ends 
end m1
