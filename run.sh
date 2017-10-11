#!/bin/bash
#################Transdutor Romanos

######### Uni
fstcompile --isymbols=syms.sym --osymbols=syms.sym rod_uni.txt | fstarcsort > rod_uni.fst
#fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait rod_uni.fst | dot -Tpdf  > rod_uni.pdf

######### dec
fstcompile --isymbols=syms.sym --osymbols=syms.sym rod_dec.txt | fstarcsort > rod_dec.fst
#fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait rod_dec.fst | dot -Tpdf  > rod_dec.pdf

######### cent
fstcompile --isymbols=syms.sym --osymbols=syms.sym rod_cen.txt | fstarcsort > rod_cen.fst
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait rod_cen.fst | dot -Tpdf  > rod_cen.pdf
######### Zero
fstcompile --isymbols=syms.sym --osymbols=syms.sym rod_zero.txt | fstarcsort > rod_zero.fst
#fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait rod_zero.fst | dot -Tpdf  > rod_zero.pdf

### Concat e union para gerar estado final
fstunion rod_uni.fst rod_zero.fst > uni_zero.fst
fstconcat rod_dec.fst uni_zero.fst > dec_zero_uni.fst

fstconcat rod_cen.fst rod_zero.fst > cen_zero.fst
fstconcat cen_zero.fst rod_zero.fst  > cen_zero_zero.fst

fstunion cen_zero_zero.fst dec_zero_uni.fst > almost_final.fst
fstunion almost_final.fst rod_uni.fst > final.fst
#fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait final.fst | dot -Tpdf  > final.pdf

### invert
fstinvert final.fst > invert_final.fst
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait invert_final.fst | dot -Tpdf  > invert_final.pdf

#################

#################
#Transdutor 1
python compact2fst.py letras.txt > letras_transdutor.txt
fstcompile --isymbols=syms.sym --osymbols=syms.sym letras_transdutor.txt | fstarcsort > letras_transdutor.fst
fstcompile --isymbols=syms.sym --osymbols=syms.sym black_space.txt | fstarcsort > black_space.fst

###operacoes transdutores
fstconcat letras_transdutor.fst black_space.fst > letras_transdutor1.fst
fstconcat invert_final.fst black_space.fst > invert_final_space.fst
fstunion invert_final_space.fst letras_transdutor1.fst > transdutor1_union.fst
fstclosure transdutor1_union.fst > transdutor1.fst

###print transdutor1
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait transdutor1.fst | dot -Tpdf  > transdutor1.pdf

#################
#Transdutor 2
python compact2fst.py transdutor2.txt > transdutor2_final.txt
fstcompile --isymbols=syms.sym --osymbols=syms.sym transdutor2_final.txt | fstarcsort > transdutor2_final.fst
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait transdutor2_final.fst | dot -Tpdf  > transdutor2_final.pdf

#################
#Transdutor 3
python compact2fst.py transdutor3.txt > transdutor3_final.txt
fstcompile --isymbols=syms.sym --osymbols=syms.sym transdutor3_final.txt | fstarcsort > transdutor3_final.fst
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait transdutor3_final.fst | dot -Tpdf  > transdutor3_final.pdf

#################
#Descodificador
fstarcsort --sort_type=ilabel transdutor1.fst > transdutor1sort.fst
fstintersect transdutor1sort.fst transdutor2_final.fst > r.fst 
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait r.fst | dot -Tpdf  > r.pdf




#################
#################
#Testes
#teste 1o transdutor
fstcompile --isymbols=syms.sym --osymbols=syms.sym  99.txt | fstarcsort > 99.fst

fstcompose 99.fst transdutor1.fst > XCIX.fst
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait XCIX.fst | dot -Tpdf  > XCIX.pdf

# teste 2o transdutor
fstcompile --isymbols=syms.sym --osymbols=syms.sym  XCIX_trans2.txt | fstarcsort > XCIX_trans2.fst

fstcompose XCIX_trans2.fst transdutor2_final.fst > 3513.fst
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait 3513.fst | dot -Tpdf  > 3513.pdf




####
