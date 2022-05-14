.386															
dseg	segment	use16													
buffer  db	512	dup(0)												
buffer1 db	510	dup(0),	55h,0aah											
forMBR	db	4	dup(0),	05h,	11	dup(0)									
forEPR	db	8	dup(0),	80h,7	dup(0)										
forEPR1	db	4	dup(0),	05h,	11	dup(0)									
forEPR2	db	8	dup(0),	80h,7	dup(0)										
text	  db	'error!$'													
text0	  db	0Ah,'В	MBR	нет	свободного	места$'									
text1	  db	0Ah,'В	MBR	уже	есть	РР$'									
invate1	db	0Ah,'Введите	размер	первого	диска	(в	секторах):$'								
invate2	db	0Ah,'Введите	размер	второго	диска	(в	секторах):$'								
invate3	db	0Ah,'Выберите	ф.с.	для	первого	диска(1.	FAT16	2.	FAT32	3.	NTFS)$'				
invate4	db	0Ah,'Выберите	ф.с.	для	второго	диска:$'									
succes1	db	0Ah,'В	MBR	есть	свободное	место$'									
succes2	db	0Ah,'В	MBR	нет	РР$'										
razmer1	db	7,8	dup(0)												
razmer2	db	7,8	dup(0)												
fc1	    db	2,3	dup(0)												
fc2	    db	2,3	dup(0)												
numb1	  db	8	dup(0)												
numb2	  db	8	dup(0)												
paket	  db	16													
        db	0														
        db	1														
        db	0														
        dw	buffer														
        dw	dseg														
        dq	0														
paket1	db	16													
        db	0														
        db	1														
        db	0														
        dw	buffer1														
        dw	dseg														
Smesh	  dq	0													
DivH	  dd	255													
DivS	  dd	63													
DivHS	  dd	16065													
nul	    db	1,2	dup(0)												
LBA	    dd	0													
zero	  db	16	dup(0)												
ten	    dd	10													
															
dseg	ends														
															
code	segment	use16													
 assume	cs:code,ds:dseg,	es:dseg													
															
a1:	mov	ax,dseg													
mov	ds,ax														
mov	es,ax														
mov	ah,42h														
mov	dl,80h														
lea	si,paket														
int	13h;счтитываем	MBR													
jc	err														
															
															
;проверка	mbr	на	свободное	место	и	существование	РР								
															
;	проверка	mbr	на	свободное	место	осуществляется	за	счет	сравнения	координаты	S	из	CHS	и	0
xor	ax,ax														
lea	di,	[buffer+1D0h]													
lea	dx,	[text0]													
a2:	mov	al,	byte	ptr	[di]										
cmp	al,0														
jz	short	a3													
add	di,	10h													
inc	ah														
cmp	ah,	3													
jz	short	err0													
jmp	short	a2													
															
a3:	mov	ah,9													
lea	dx,	succes1													
int	21h														
mov	ah,	0Ah													
lea	dx,	nul													
int	21h														
															
;проверка	mbr	на	существование	РР											
xor	ax,ax														
lea	di,	[buffer+1C2h]													
lea	dx,	[text1]													
a4:	mov	al,	byte	ptr	[di]										
cmp	al,5														
jz	short	err0													
add	di,	10h													
inc	ah														
cmp	ah,	4													
jz	short	a5													
jmp	short	a4													
															
err0:	mov	ah,9													
int	21h														
mov	ah,	0Ah													
lea	dx,	nul													
int	21h														
jmp	end														
															
a5:	mov	ah,9													
lea	dx,	succes2													
int	21h														
mov	ah,	0Ah													
lea	dx,	nul													
int	21h														
															
;расчет	координат	LBA													
mov	eax,	dword	ptr	[buffer+1c6h]											
mov	ebx,	dword	ptr	[buffer+1cah]											
add	eax,ebx														
mov	dword	ptr	[forMBR+08h],eax												
															
;расчет	CHS	начала													
lea	si,	[forMBR+1]	;куда	записать	результат										
lea	di,	[forMBR+8]	;	откуда	брать	LBA									
call	CHS														
;	CHS	in	EPR												
mov	eax,	dword	ptr	[forMBR+08h]											
add	dword	ptr	[forEPR+08h],eax												
push	eax														
lea	si,	[forEPR+1]													
lea	di,	[forEPR+08h]													
call	CHS														
pop	eax														
sub	dword	ptr	[forEPR+08h],eax												
															
															
;ввод	размеров	разделов													
mov	ah,9														
lea	dx,	invate1													
int	21h														
mov	ah,	0Ah													
lea	dx,	razmer1													
int	21h														
lea	di,	razmer1													
lea	si,	numb1													
call	Number														
															
mov	eax,	dword	ptr	[numb1]	;запись	размера	1	в	EPR						
mov	dword	ptr	[forEPR+12],	eax											
															
;push	dx														
mov	ah,9														
lea	dx,	invate2													
int	21h														
mov	ah,	0Ah													
lea	dx,	razmer2													
int	21h														
lea	di,	razmer2													
lea	si,	numb2													
;pop	dx														
call	Number														
															
mov	eax,	dword	ptr	[numb2]	;запись	размера	2	в	EPR2						
mov	dword	ptr	[forEPR2+12],	eax											
															
;расчет	общего	размера	раздела	и	запись	в	forMBR								
mov	eax,0														
mov	ebx,0														
mov	eax,dword	ptr	[numb1]												
mov	ebx,dword	ptr[numb2]													
add	eax,ebx														
add	eax,	256	;	зарезирвированные	сектора	под	epr								
mov	dword	ptr	[forMBR+12],eax												
															
;смещение	до	EPR2	(размер	1	+128)										
mov	eax,	dword	ptr	[numb1]											
add	eax,	dword	ptr	[forEPR+8]											
mov	dword	ptr	[forEPR1+08h],eax												
															
;смещение	в	свободную	обл												
mov	ebx,	dword	ptr	[forMBR+12]											
sub	ebx,eax	;	in	eax	смещение	до	EPR2	(размер	1	+128)					
mov	dword	ptr	[forEPR1+12],ebx												
															
;расчет	конечного	CHS	for	MBR											
mov	eax,	dword	ptr	[forMBR+12]											
mov	ebx,	dword	ptr	[forMBR+8]											
add	eax,	ebx													
mov	dword	ptr	LBA,eax												
lea	si,[forMBR+5]														
lea	di,	LBA													
call	CHS														
;дублирование	конечного	CHS	for	MBR	в	EPR1	и	EPR2	из	MBR					
xor	ax,ax														
mov	ah,	byte	ptr	[forMBR+5]											
mov	byte	ptr	[forEPR1+5],ah												
mov	byte	ptr	[forEPR2+5],ah												
mov	ax,	word	ptr	[forMBR+6]											
mov	word	ptr	[forEPR1+6],ax												
mov	word	ptr	[forEPR2+6],ax												
															
															
															
;CHS	end	for	EPR												
mov	ebx,	dword	ptr	[forMBR+8]											
mov	eax,	dword	ptr	numb1											
add	eax,	ebx													
add	eax,128														
mov	dword	ptr	LBA,eax												
lea	si,[forEPR+5]														
lea	di,	LBA													
call	CHS														
															
;CHS	start	for	EPR1												
xor	ax,ax														
mov	ah,	byte	ptr	[forEPR+5]											
mov	byte	ptr	[forEPR1+1],ah												
mov	ax,	word	ptr	[forEPR+6]											
inc	ax														
mov	word	ptr	[forEPR1+2],ax												
															
;CHS	start	for	EPR2												
mov	eax,	dword	ptr	[forMBR+8]	;LBA	start									
add	eax,	dword	ptr	[forEPR1+8]	;										
add	eax,	dword	ptr	[forEPR+8]											
mov	dword	ptr	[LBA],	eax											
lea	di,	LBA													
lea	si,	[forEPR2+1]													
call	CHS														
															
															
;ввод	ф.с.														
;для	первого														
mov	ah,9														
lea	dx,	invate3													
int	21h														
mov	ah,	0Ah													
lea	dx,	fc1													
int	21h														
lea	di,fc1														
lea	si,	forEPR													
call	FC														
															
;для	второго														
mov	ah,9														
lea	dx,	invate4													
int	21h														
mov	ah,	0Ah													
lea	dx,	fc2													
int	21h														
lea	di,fc2														
lea	si,	forEPR2													
call	FC														
															
															
															
;запись	в	сектора	диска												
															
;запись	16	битной	строки	MBR	в	buffer									
lea	si,	forMBR	;строка	источник											
lea	di,	[buffer+1ceh]	;строка	приемника											
mov	cx,4														
repnz	movsd														
															
;запись	16	битной	строки	EPR2	в	buffer1									
lea	si,	forEPR2	;строка	источник											
lea	di,	[buffer1+1beh]	;строка	приемника											
mov	cx,4														
repnz	movsd														
															
;запись	buffer1	с	EPR2	в	сегмент	равный	LBA	начала	(из	MBR)	+	размер	1	128	
xor	eax,eax														
mov	eax,	dword	ptr	[forMBR+08h]											
mov	dword	ptr	Smesh,eax												
mov	eax,	dword	ptr	numb1											
add	dword	ptr	Smesh,eax	;запись	смещения	в	LBA	для	таблицы	EPR2					
add	dword	ptr	Smesh,128												
mov	ah,43h														
mov	dl,80h														
lea	si,paket1														
int	13h;записываем	во	вторую	epr	таблицу										
jc	err														
															
;	обнуление	использованной	строки	в	buffer1										
lea	si,	zero	;строка	источник	(строка	нулей)									
lea	di,	[buffer1+1beh]	;строка	приемника											
mov	cx,4														
repnz	movsd														
															
;запись	32	битнов:	строки	EPR	и	EPR1	в	buffer1							
lea	si,	forEPR	;строка	источник											
lea	di,	[buffer1+1beh]	;строка	приемника											
mov	cx,8														
repnz	movsd														
															
;запись	buffer1	с	EPR	и	EPR1	в	сегмент	равный	LBA	начала	(из	MBR)			
xor	eax,eax														
mov	eax,	dword	ptr	[forMBR+08h]											
mov	dword	ptr	Smesh,eax												
mov	ah,43h														
mov	dl,80h														
lea	si,paket1														
int	13h;записываем	в	первую	epr	таблицу										
jc	err														
															
															
															
;запись	buffer	в	сектор												
mov	ah,43h														
mov	dl,80h														
lea	si,paket														
int	13h;записываем	в	MBR												
jc	err														
															
															
															
															
end:	mov	ah,4ch													
int	21h														
															
															
															
CHS	proc														
mov	eax,dword	ptr	[di]												
xor	edx,edx														
push	eax														
div	DivHS;	C	in	eax											
mov	byte	ptr	[si+2],	al											
shl	ah,6														
mov	bl,ah														
pop	eax														
xor	edx,edx														
div	DivS														
inc	edx	;	S	in	edx										
or	dl,bl														
mov	byte	ptr	[si+1],	dl											
xor	edx,edx														
div	DivH;	H	in	edx											
mov	byte	ptr	[si],	dl											
															
															
ret															
CHS	endp														
															
err:	mov	ah,9													
lea	dx,text														
int	21h														
mov	ah,	0Ah													
lea	dx,	nul													
int	21h														
jmp	short	end													
															
															
															
Number	proc	;перевод	из	аски	в	число									
xor	cx,cx														
xor	eax,eax														
xor	ebx,ebx														
mov	cl,	byte	ptr	[di+1]	;	кол-во	элементов	в	сх						
add	di,2	;	указатель	на	старший	элемент									
															
z0:	push	cx													
dec	cx														
mov	al,byte	ptr	[di]												
and	al,	0fh													
mov	dx,0ffffh														
z1:	mul	ten													
mov	ebx,	eax													
loop	z1														
add	dword	ptr	[si],ebx												
xor	ebx,ebx														
xor	eax,eax														
pop	cx														
inc	di														
loop	z0														
mov	al,byte	ptr	[di-1]												
and	al,	0fh													
add	byte	ptr	[si],	al											
															
ret															
															
Number	endp														
															
FC	proc														
															
xor	ax,ax														
mov	al,byte	ptr	[di+2]												
cmp	al,32h														
ja	short	ntfs													
jz	short	fat32													
mov	byte	ptr	[si+4],06;FAT16												
q1:	ret														
fat32:	mov	byte	ptr	[si+4],0Bh;FAT32											
jmp	short	q1													
ntfs:	mov	byte	ptr	[si+4],07;NTFS											
jmp	short	q1													
															
FC	endp														
code	ends														
end	a1														
