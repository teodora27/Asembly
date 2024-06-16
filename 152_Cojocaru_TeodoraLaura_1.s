.data
	m: .space 4
	n: .space 4
	mn: .space 4
	p: .space 4
	k: .space 4
	s: .space 4
	nr: .long 0
	num: .long 0
	cod: .long 0
	poz: .space 4
	loc: .space 4
	sir: .space 1000
	binar: .space 1000
	nr1: .long 0
	mesaj: .space 1600
	cuvant: .space 1000
	linie: .space 4
	coloana: .space 4
	cerinta: .space 4
	matrice1: .space 1600
	matrice2: .space 1600
	i: .space 4
	j: .space 4
	index: .space 4
	
	formatScanf: .asciz "%ld"
	formatPrintf: .asciz "%ld "
	formatPrintfc: .asciz "%c"
	formatPrintf16: .asciz "%X"
	formatScanfcuvant: .asciz "%s"
	newLine: .asciz "\n"
	hexa: .asciz "0x"
.text

transforma_binar:
	movl $0, j
	while:
		movl j, %ecx
		movl $8, %edx
		cmp %ecx, %edx
		je sari
		
		movl %ebx, %eax
		movl $0, %edx
		movl $2, %ecx
		idiv %ecx
		
		movl %eax, %ebx	
		pushl %edx
			
	incl j	
	jmp while
	
	sari:
	
	movl $0,  j
	while1:
		movl $8, %edx
		movl j, %ecx
		cmp %ecx, %edx
		je return
			
		lea mesaj, %edi
		popl %ebx
		movl nr, %eax
		mov %bl, (%edi, %eax, 1) 
	incl nr	
	incl j	
	jmp while1
	
	return: 
		ret

.global main
main:
	
citeste_m_n_p:
	pushl $m
	pushl $formatScanf
	call scanf
	popl %ebx
	popl %ebx
	incl m
	incl m
	
	pushl $n
	pushl $formatScanf
	call scanf
	popl %ebx
	popl %ebx
	incl n
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
		je citire_cerinta
		
		movl $1, i
			for_pana_la_m:
				movl i, %ecx
				incl %ecx
				cmp %ecx, m
				je copiere
				
				movl $1, j
				for_pana_la_n:
					movl j, %ecx
					incl %ecx
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


citire_cerinta:
	pushl $cerinta
	pushl $formatScanf
	call scanf
	popl %ebx
	popl %ebx

	
	movl $0, %eax
	cmp %eax, cerinta
	jne daca_cerinta_e_1
	
#daca cerinta e 0

citire_mesaj:
	pushl $cuvant
	pushl $formatScanfcuvant
	call scanf
	popl %ebx
	popl %ebx
	
	
transformare_cuvant_in_binar:
	
	movl $0, i
	cat_mai_sunt_litere:
	
		lea cuvant, %edi
		movl i, %eax
		movl $0, %ebx
		mov (%edi, %eax, 1), %bl
			
		
		mov $0, %eax
		cmp %eax, %ebx
		je xor
		
		call transforma_binar
		
	incl i
	jmp cat_mai_sunt_litere
		
xor:
	#mn=m*n	
	movl n, %eax
	movl m, %ebx
	mul %ebx
	movl %eax, mn
		
	movl $0, i
	for:
		movl i, %eax
		movl nr, %edx
		cmp %eax, %edx
		je afisare
		
		movl i, %eax
		movl mn, %ebx
		movl $0, %edx
		div %ebx
		movl %edx, poz
		
		lea mesaj, %edi
		movl $0, %ebx
		movl i, %eax
		mov (%edi, %eax, 1), %bl
		
		lea matrice1, %edi
		movl poz, %eax
		movl (%edi, %eax, 4), %ecx
		
		xor %cl, %bl	
		lea mesaj, %edi
		movl i, %eax
		mov %bl, (%edi, %eax, 1)
		
	incl i
	jmp for
	
afisare:

	movl $4, %eax
	movl $1, %ebx
	movl $hexa, %ecx
	movl $2, %edx
	int $0x80


	movl $0, i
	movl $1, j
	movl $0, num
	for_afis:
		movl i, %eax
		movl nr, %edx
		cmp %eax, %edx
		jb exit
		
			mov j, %eax
			movl $5, %ebx
			cmp %eax, %ebx
			jne sari1
		
			movl num, %ebx
			push %ebx
			pushl $formatPrintf16
			call printf
			popl %ecx
			popl %ecx
		
			pushl $0
			call fflush
			popl %ebx
		
			movl $1, j
			movl $0, num
		
		sari1:
		lea mesaj, %edi
		movl i, %eax
		movl $0, %ebx
		mov (%edi, %eax, 1), %bl
		
		movl num, %eax
		movl $2, %ecx
		movl $0, %edx
		mull %ecx
		movl %eax, num
		addl %ebx, %eax
		movl %eax, num
			
			

	incl j
	incl i
	jmp for_afis		
		
daca_cerinta_e_1:

pushl $sir
	pushl $formatScanfcuvant
	call scanf
	popl %ebx
	popl %ebx
	
	movl $2, i
	forr:
		lea sir, %edi
		movl i, %eax
		movl $0, %ebx
		mov (%edi, %eax, 1), %bl
			
		
		mov $0, %eax
		cmp %eax, %ebx
		je xor2
		
		movl $65, %eax #codul asci pentru 'A'
		cmp %eax, %ebx
		jb este_cifra
		
		movl $55, %eax
		subl %eax, %ebx
		jmp transformare_binar
		
		este_cifra:
		movl $48, %eax #codul asci pentru '0'
		subl %eax, %ebx				
		
		transformare_binar:
				
				
			movl $0, j
			while2:
				movl j, %ecx
				movl $4, %edx
				cmp %ecx, %edx
				je sarii
			
				movl %ebx, %eax
				movl $0, %edx
				movl $2, %ecx
				idiv %ecx
			
				movl %eax, %ebx	
				pushl %edx
			incl j	
			jmp while2
		sarii:
		
			movl $0,  j
			while3:
				movl $4, %edx
				movl j, %ecx
				cmp %ecx, %edx
				je continuare123
					
				lea binar, %edi
				popl %ebx
				movl nr1, %eax
				mov %bl, (%edi, %eax, 1) 
		
			incl nr1	
			incl j	
			jmp while3
	
	continuare123:
		
	incl i
	jmp forr
	
	
xor2:	

#mn=m*n	
	movl n, %eax
	movl m, %ebx
	mul %ebx
	movl %eax, mn
	
			

	movl $0, i
	for_xor:
		movl i, %eax
		movl nr1, %ebx
		cmp %eax, %ebx
		je afisare2
		
		movl i, %eax
		movl mn, %ebx
		movl $0, %edx
		divl %ebx
		movl %edx, loc
		

		lea binar, %edi
		movl $0, %ebx
		movl i, %eax
		mov (%edi, %eax, 1), %bl
		
		lea matrice1, %edi
		movl loc, %eax
		movl (%edi, %eax, 4), %ecx
		
		xor %cl, %bl	
		lea binar, %edi
		movl i, %eax
		mov %bl, (%edi, %eax, 1)

	incl i
	jmp for_xor
	
afisare2:
		
	
	movl $0, i
	movl $0, j
	movl $0, cod
	incl nr1
	for_afi:
		movl i, %eax
		movl nr1, %ebx
		cmp %eax, %ebx
		je exit
		
		movl j, %eax
		movl $8, %ebx
		cmp %eax, %ebx
		jne sare 
		
				#afisare cod
				
				movl cod, %eax
				pushl %eax
				pushl $formatPrintfc
				call printf
				popl %ebx
				popl %ebx

				pushl $0
				call fflush
				popl %ebx
		
		
				movl $0, cod
				movl $0, j
				jmp for_afi
		
		sare:
		
			lea binar, %edi
			movl i, %eax
			movl $0, %ebx
			mov (%edi, %eax, 1), %bl
			
			movl cod, %eax
			movl $2, %ecx
			movl $0, %edx
			mull %ecx
			addl %ebx, %eax
			movl %eax, cod
			
		
	incl j
	incl i
	jmp for_afi	

	

exit:
	movl $1, %eax
	xorl %ebx, %ebx
	int $0x80
