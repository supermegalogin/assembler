.386
dseg segment use16
	a	db 9
	b	dw 16h
	c	db ?,?
	d	dw ?,?
dseg ends
cseg segment use16
	assume ds:dseg,cs:cseg
 	m1:	mov ax,dseg
		mov ds,ax

		movzx ax,ds:a
		mov bl, byte ptr ds:b
		div bl
		mov ds:c,al
		mov ds:c+1,ah

		movzx ax,ds:a
		mov bx,ds:b
		mul bx
		mov ds:d,dx
		mov ds:d+2,ax

		mov bl,al	
		mov bh,al
		shl bl,5
		shr bh,5
		or bl,bh
		and bl,11011110b
		xor al,00010000b
		or al, bl
		mov ds:d+2,ax
		
		mov ah,4ch
		int 21h
cseg ends 
end m1
