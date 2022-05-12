.386
dseg segment use16
 	x	db +91
	y	dw ?
dseg  ends
cseg segment use16
 	assume ds:dseg,cs:cseg
 	m1:	mov ax,dseg
 		mov ds,ax

		cmp ds:x,+90
		jg short p1
		jl short p2
		mov ds:y,79
		jmp short exit

	p3:	mov ds:y,bx
				
	exit:	mov ah,4ch
		int 21h


	p1:	mov bx,25
		movsx ax,ds:x
		sbb bx,ax
		jmp p3

	p2:	movsx bx,ds:x
		add bx,24
		jmp p3
cseg ends 
end m1
