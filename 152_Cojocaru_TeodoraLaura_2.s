.data
	m: .space 4
	n: .space 4
	p: .space 4
	k: .space 4
	s: .space 4
	linie: .space 4
	coloana: .space 4
	matrice1: .space 1600
	matrice2: .space 1600
	i: .space 4
	j: .space 4
	index: .space 4
	
	formatScanf: .asciz "%ld"
	formatPrintf: .asciz "%ld "
	newLine: .asciz "\n"
	
	in: .asciz "in.txt"
	out: .asciz "out.txt"
	read: .asciz "r"
	write: .asciz "w"
.text
.global main
main:
	push stdin
	push $read
	push $in
	call freopen
	pop %ebx
	pop %ebx
	pop %ebx
	
	push stdout
	push $write
	push $out
	call freopen
	pop %ebx
	pop %ebx
	pop %ebx
	
citeste_m_n_p:
	pushl $m
	pushl $formatScanf
	call scanf
	popl %ebx
	popl %ebx
	incl m
	
	pushl $n
	pushl $formatScanf
	call scanf
	popl %ebx
	popl %ebx
	incl n
	
	pushl $p
	pushl $formatScanf
	call scanf
	popl %ebx
	popl %ebx
	
	#citesc linia si coloana
	movl $0, i
for_citire:
	movl i, %ecx
	cmp %ecx, p
	je completare_matrice
	
	#citesc linia si coloana si le cresc cu 1 ca sa am matricea indexata de la 1
	pushl $linie
	pushl $formatScanf
	call scanf
	popl %ebx
	popl %ebx
	
	incl linie 
	
	pushl $coloana
	pushl $formatScanf
	call scanf
	popl %ebx
	popl %ebx
	
	incl coloana
	
	#fac matrice1[linie][coloana]=1
	movl linie, %eax
	movl $0, %edx
	mull n
	addl coloana, %eax
	lea matrice1, %edi
	movl $1, (%edi, %eax, 4)
	
	#fac matrice2[linie][coloana]=1
	lea matrice2, %edi
	movl $1, (%edi, %eax, 4)
	
	incl i
	jmp for_citire
	
completare_matrice:
	movl $0, i
	for_linii1:
		movl i, %ecx
		cmp %ecx, m
		jb citire_k
		
		movl $0, j
		for_coloane1:
			movl j, %ecx
			cmp %ecx, n
			jb continua1
			
			movl i, %eax
			movl $0, %edx
			mull n
			addl j, %eax
			
			lea matrice1, %edi
			movl (%edi, %eax, 4), %ebx
			movl $1, %edx
			cmp %ebx, %edx
			je trece_mai_departe
			movl $0, (%edi, %eax, 4)
			lea matrice2, %edi
			movl $0, (%edi, %eax, 4)
		
		trece_mai_departe:
		incl j
		jmp for_coloane1
	
	continua1:
		
	incl i
	jmp for_linii1
		

citire_k:
	pushl $k
	pushl $formatScanf
	call scanf
	popl %ebx
	popl %ebx	

rezolvare:
	movl $0, index
	for_pana_la_k:
		movl index, %ecx
		cmp %ecx, k
		je afisare_matrice
		
		movl $1, i
			for_pana_la_m:
				movl i, %ecx
				cmp %ecx, m
				je copiere
				
				movl $1, j
				for_pana_la_n:
					movl j, %ecx
					cmp %ecx, n
					je cont
					
					#calculez in s suma vecinilor
					movl $0, s
					
					#sus stanga
					movl i, %eax
					subl $1, %eax
					movl $0, %edx
					mull n
					addl j, %eax
					subl $1, %eax
					lea matrice1, %edi
					movl (%edi, %eax, 4), %ecx
					addl %ecx, s
					
					#sus
					addl $1, %eax
					movl (%edi, %eax, 4), %ecx
					addl %ecx, s
					
					#sus dreapta
					addl $1, %eax
					movl (%edi, %eax, 4), %ecx
					addl %ecx, s
					
					#dreapta
					addl n, %eax
					movl (%edi, %eax, 4), %ecx
					addl %ecx, s
					
					#dreapta jos
					addl n, %eax
					movl (%edi, %eax, 4), %ecx
					addl %ecx, s
					
					#jos
					subl $1, %eax
					movl (%edi, %eax, 4), %ecx
					addl %ecx, s
					
					#stanga jos
					subl $1, %eax
					movl (%edi, %eax, 4), %ecx
					addl %ecx, s
					
					#stanga
					subl n, %eax
					movl (%edi, %eax, 4), %ecx
					addl %ecx, s
					
					daca_elementul_este_1:
					addl $1, %eax
					movl (%edi, %eax, 4), %ecx				
					movl $1, %edx
					cmp %ecx, %edx
					lea matrice2, %edi
					jne daca_elementul_este_0
						
						daca_s_e_mai_putin_de_2:
						movl s, %ecx
						movl $2, %edx
						cmp %edx, %ecx
						jae daca_s_e_2
						lea matrice2, %edi
						movl $0, (%edi, %eax, 4)
						jmp gata
						
						daca_s_e_2:
						movl s, %ecx
						movl $2, %edx
						cmp %edx, %ecx
						jne daca_s_e_3
						movl $1, (%edi, %eax, 4)
						jmp gata
						
						daca_s_e_3:
						movl $3, %edx
						cmp %edx, %ecx
						jne daca_s_e_mai_mare_decat_3
						movl $1, (%edi, %eax, 4)
						jmp gata
					
						daca_s_e_mai_mare_decat_3:
						movl $0, (%edi, %eax, 4)
						jmp gata
						
					daca_elementul_este_0:
					
						daca_s_e_3_:
						movl s, %ecx
						movl $3, %edx
						cmp %edx, %ecx
						jne gata
						movl $1, (%edi, %eax, 4)
									
				gata:						
				incl j
				jmp for_pana_la_n
			
			cont:
			incl i
			jmp for_pana_la_m
			
		copiere:
		movl $1, i
		for_i:
			movl i, %ecx
			cmp %ecx, m
			je conti
			
			movl $1, j
			for_j:
				movl j, %ecx
				cmp %ecx, n
				je urm
				
				movl i, %eax
				movl $0, %edx
				mull n
				addl j, %eax
				
				lea matrice2, %edi
				movl (%edi, %eax, 4), %ebx
				lea matrice1, %edi
				movl %ebx, (%edi, %eax, 4)
				
			incl j
			jmp for_j
			
		urm:			
		incl i
		jmp for_i
			
	conti:
	
	incl index
	jmp for_pana_la_k


afisare_matrice:
	movl $1, i
	for_linii:
		movl i, %ecx
		cmp %ecx, m
		je exit
		
		movl $1, j
		for_coloane:		
			movl j, %ecx
			cmp %ecx, n
			je continua
			
			movl i, %eax
			movl $0, %edx
			mull n
			addl j, %eax
			
			lea matrice1, %edi
			movl (%edi, %eax, 4), %ebx

			pushl %ebx
			pushl $formatPrintf
			call printf
			popl %ebx
			popl %ebx
			
			pushl $0
			call fflush
			popl %ebx
			
			incl j
			jmp for_coloane
			
	continua:
	
	pusha
	push $newLine
	call printf
	pop %ebx
	push $0
	call fflush
	popl %ebx
	popa
	
	incl i
	jmp for_linii

exit:
	movl $1, %eax
	xorl %ebx, %ebx
	int $0x80
