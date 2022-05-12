.386
cseg segment use16
	assume      cs:cseg
	m1:	lea si,a

		xor ax,ax
		mov cx,5
	m2:	cmp word ptr cs:si,ax
		jnl short m3
		mov ax,word ptr cs:si
	m3:	inc si
		inc si
		loop m2
		cmp ax,-30
		jnle short m4
		
	m5:	mov ah,4ch
		int 21h
	
	m4:	movzx eax,ax
		mov  cs:b,eax
		jmp short m5

		a	dw +5,-28,-4,-29,+1
		b	dd ?

cseg ends
end m1
