.386
code1 segment use16
	assume      cs:code1,  ss:code2
	m1:	xor bx,bx
		lea si,a
		lea di,c
		mov cx,5h
		call far ptr cs:PR1
		lea si,c

		xor ax,ax
		mov cx,bx
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
	
	m4:	movsx eax,ax
		mov  cs:b,eax
		jmp short m5

		a	dw +5,-28,-4,-29,+1
		b	dd ?
		c	dw 5 dup(?)
code1 ends

code2 segment use16
	assume    cs:code2,  ds:code1
	PR1	proc
		mov ax,code1
	        mov ds,ax
	p1:	cmp word ptr ds:si ,0
		jnge short p2
	p3:	inc si
		inc si
		loop p1
		ret
		PR1 endp
	p2:	mov dx,word ptr ds:si
		mov  ds:di,dx
		inc di
		inc di
		inc bx
		jmp short p3
	code2 ends
end m1
