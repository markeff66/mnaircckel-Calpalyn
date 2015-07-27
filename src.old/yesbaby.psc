%!PS-Adobe-3.0 EPSF-3.0
%%Creator: CalPalyn Version 2.1
%%CreationDate: Fri Mar 13  1:02:35 PM 2009
%%BoundingBox: 0 0 612 792                                             
%%LanguageLevel: 1
%%EndComments
% make sure the file begins with "%!" before you try and print it!
/acutelines
{
/spacing exch def
/angle exch def
/x exch def
/y exch def

90 angle sub -1 mul rotate
angle cos y mul -1 mul 0 translate
0 spacing 
angle cos y mul 90 angle sub cos x mul add
{
	0 moveto
	0 angle sin y mul angle cos x mul add rlineto
	stroke
} for
} def

/obtuselines
{
/spacing exch def
/angle exch def
/x exch def
/y exch def

angle 90 sub rotate
0 180 angle sub cos x mul -1 mul translate
0 spacing 
angle 90 sub sin y mul angle 90 sub cos x mul add
{
	0 moveto
	0 angle 90 sub cos y mul 180 angle sub cos x mul add rlineto
	stroke
} for
} def

/setuserscreendict 22 dict def
setuserscreendict begin
	/tempctm matrix def
	/temprot matrix def
	/tempscale matrix def

	/concatprocs
	{
		/proc2 exch cvlit def
		/proc1 exch cvlit def
		/newproc proc1 length proc2 length add array def

		newproc 0 proc1 putinterval
		newproc proc1 length proc2 putinterval
		newproc cvx
	} def

	/resmatrix matrix def
	/findresolution
	{
		72 0 resmatrix defaultmatrix dtransform
		/yres exch def /xres exch def
		xres dup mul yres dup mul add sqrt
	} def
end

/setuserscreen
{
	setuserscreendict begin
	/spotfunction exch def
	/screenangle exch def
	/cellsize exch def

	/m tempctm currentmatrix def
	/rm screenangle temprot rotate def
	/sm cellsize dup tempscale scale def


	sm rm m m concatmatrix m concatmatrix pop

	1 0 m dtransform /y1 exch def /x1 exch def

	/veclength x1 dup mul y1 dup mul add sqrt def
	/frequency findresolution veclength div def

	/newscreenangle y1 x1 atan def

	m 2 get m 1 get mul m 0 get m 3 get mul sub 0 gt
		
		{{ neg } /spotfunction load concatprocs
			/spotfunction exch def
		}


	frequency newscreenangle /spotfunction load
		setscreen
	end
} def

/setpatterndict 18 dict def
setpatterndict begin
	/bitison
	{
		/ybit exch def /xbit exch def
		/bytevalue bstring ybit bwidth mul xbit 8 idiv
			add get def
		/mask 1 7 xbit 8 mod sub bitshift def
		bytevalue mask and 0 ne
	} def
end

/bitpatternspotfunction
{
	setpatterndict begin
	/y exch def /x exch def
	/xindex x 1 add 2 div bpside mul cvi def
	/yindex y 1 add 2 div bpside mul cvi def

	xindex yindex bitison
	{ /onbits onbits 1 add def 1}
	{ /offbits offbits 1 add def 0 }
	ifelse

	end
} def

/setpattern
{
	setpatterndict begin
	/cellsz exch def
	/angle exch def
	/bwidth exch def
	/bpside exch def
	/bstring exch def

	/onbits 0 def /offbits 0 def
	cellsz angle /bitpatternspotfunction load
		setuserscreen
	{} settransfer
	offbits offbits onbits add div setgray 
	end
} def

/inch {72 mul} def

/pat1 <d1e3c5885c3e1d88> def
/pat2 <3e418080e3140808> def
/pat3 <388387377830060e> def
/rox  <000000001c003e007e003c00183c007e00fe00ee003c07003f803f8006000000> def
/brix <1010101010101010101010101010ffff0101010101010101010101010101ffff> def
/csand <00001c003e007f007f007f003e001c000038007c00fe00fe00fe007c00380000> def
/msand <000018003c007e187e3c3c7e187e003c001806000f001f801f800f0006000000> def
/silt <0000300078007830307800780030000000000c001e001e0c0c1e001e000c0000> def
/fsilt <0002100038001002000700020020007000200100038001001000380010020007> def
/flour <00000000100010007c481030103000480000000000080008903e600860089000> def
/mystery <1e001fc017fcfff8fff0fff07ff07ff03ff31ff60ffc07f80030006000c00080> def
/set_title {
	/Helvetica findfont
	18 scalefont setfont
} def
/set_CSZ {
	/Times-Roman findfont
	10 scalefont setfont
} def
/set_chrkey {
	/Times-Roman findfont
	8 scalefont setfont
} def
/set_chron {
	/Times-Roman findfont
	8 scalefont setfont
} def
/set_strat {
	/Times-Roman findfont
	8 scalefont setfont
} def
/set_depkey {
	/Helvetica findfont
	8 scalefont setfont
} def
/set_depth {
	/Helvetica findfont
	8 scalefont setfont
} def
/set_taxon {
	/Times-Roman findfont
	12 scalefont setfont
} def
/set_botnum {
	/Times-Roman findfont
	8 scalefont setfont
} def
/set_botlab {
	/Times-Roman findfont
	8 scalefont setfont
} def
/set_taxgrp {
	/Times-Roman findfont
	10 scalefont setfont
} def
/set_zonnum {
	/Helvetica findfont
	8 scalefont setfont
} def
/set_taxon-italic {
	/Times-Italic findfont
	12 scalefont setfont
} def
/set_taxgrp-italic {
	/Times-Italic findfont
	10 scalefont setfont
} def
/leading 9 def
/leading_45 14 def
/nstr 7 string def
/lstr 30 string def
0 setlinewidth
90 rotate
72 -540 translate
0 396 moveto
set_title (Big Soda Lake, Nevada                                                           @€) show
% assign font for vertical label (e.g. Depth)
set_depkey
(Depth in cm. )
dup stringwidth pop 2 div -1 mul 144.0 add -24 exch moveto
90 rotate
show
-90 rotate
% assign font for numbers on vertical axis
set_depth
0 0 moveto
0 288.00 lineto
0 288.00 moveto
1 1 10 {
0 -3.27 rmoveto
-3 0 rmoveto 
3 0 rlineto
} for
0 288.00 moveto
1 nstr cvs dup stringwidth pop
 5 add -1 mul -3 rmoveto
show
0 255.27 moveto
1 1 10 {
0 -3.27 rmoveto
-3 0 rmoveto 
3 0 rlineto
} for
0 255.27 moveto
6 nstr cvs dup stringwidth pop
 5 add -1 mul -3 rmoveto
show
0 222.55 moveto
1 1 10 {
0 -3.27 rmoveto
-3 0 rmoveto 
3 0 rlineto
} for
0 222.55 moveto
11 nstr cvs dup stringwidth pop
 5 add -1 mul -3 rmoveto
show
0 189.82 moveto
1 1 10 {
0 -3.27 rmoveto
-3 0 rmoveto 
3 0 rlineto
} for
0 189.82 moveto
16 nstr cvs dup stringwidth pop
 5 add -1 mul -3 rmoveto
show
0 157.09 moveto
1 1 10 {
0 -3.27 rmoveto
-3 0 rmoveto 
3 0 rlineto
} for
0 157.09 moveto
21 nstr cvs dup stringwidth pop
 5 add -1 mul -3 rmoveto
show
0 124.36 moveto
1 1 10 {
0 -3.27 rmoveto
-3 0 rmoveto 
3 0 rlineto
} for
0 124.36 moveto
26 nstr cvs dup stringwidth pop
 5 add -1 mul -3 rmoveto
show
0 91.64 moveto
1 1 10 {
0 -3.27 rmoveto
-3 0 rmoveto 
3 0 rlineto
} for
0 91.64 moveto
31 nstr cvs dup stringwidth pop
 5 add -1 mul -3 rmoveto
show
0 58.91 moveto
1 1 10 {
0 -3.27 rmoveto
-3 0 rmoveto 
3 0 rlineto
} for
0 58.91 moveto
36 nstr cvs dup stringwidth pop
 5 add -1 mul -3 rmoveto
show
0 26.18 moveto
0 -3.27 rmoveto
-3 0 rmoveto 
3 0 rlineto
0 -3.27 rmoveto
-3 0 rmoveto 
3 0 rlineto
0 -3.27 rmoveto
-3 0 rmoveto 
3 0 rlineto
0 -3.27 rmoveto
-3 0 rmoveto 
3 0 rlineto
0 -3.27 rmoveto
-3 0 rmoveto 
3 0 rlineto
0 -3.27 rmoveto
-3 0 rmoveto 
3 0 rlineto
0 -3.27 rmoveto
-3 0 rmoveto 
3 0 rlineto
0 26.18 moveto
41 nstr cvs dup stringwidth pop
 5 add -1 mul -3 rmoveto
show
stroke
gsave
0 0 moveto
0 288.00 lineto
42.65 288.00 lineto
gsave
stroke
grestore
52.29 261.82 lineto
gsave
stroke
grestore
44.52 248.73 lineto
gsave
stroke
grestore
45.19 229.09 lineto
gsave
stroke
grestore
45.82 202.91 lineto
gsave
stroke
grestore
53.09 176.73 lineto
gsave
stroke
grestore
55.31 130.91 lineto
gsave
stroke
grestore
47.80 98.18 lineto
gsave
stroke
grestore
47.55 32.73 lineto
gsave
stroke
grestore
47.48 0.00 lineto
gsave
stroke
grestore
0 0 lineto
55.31 0 lineto 
8 leading_45 14 sub add 296 moveto
45 rotate
% assign font for taxon name
set_taxon-italic
(Pinus          ) show
-45 rotate
8 leading_45 add 296 moveto
45 rotate
set_taxon
(                ) show
-45 rotate
8 2 leading_45 mul add 296 moveto
45 rotate
set_taxon
(                ) show
-45 rotate
gsave
1 0 0 setrgbcolor fill
grestore
stroke
% assign font for numbers under taxon x-axis
set_botnum
0 nstr cvs dup stringwidth pop
2 div
0.00 exch sub -11 moveto
show
0.00 -3 moveto
0 6 rlineto
25 nstr cvs dup stringwidth pop
2 div
24.77 exch sub -11 moveto
show
24.77 -3 moveto
0 6 rlineto
50 nstr cvs dup stringwidth pop
2 div
49.55 exch sub -11 moveto
show
49.55 -3 moveto
0 6 rlineto
% assign font for label under taxon curve
set_botlab
0 11 leading add neg moveto
( % Total Pollen               ) show
0 11 leading 2 mul add neg moveto
(                              ) show
70.17 0 translate
stroke
0 0 moveto
0 288.00 lineto
4.31 288.00 lineto
gsave
stroke
grestore
1.96 261.82 lineto
gsave
stroke
grestore
4.02 248.73 lineto
gsave
stroke
grestore
3.02 229.09 lineto
gsave
stroke
grestore
5.12 202.91 lineto
gsave
stroke
grestore
3.42 176.73 lineto
gsave
stroke
grestore
3.55 130.91 lineto
gsave
stroke
grestore
4.87 98.18 lineto
gsave
stroke
grestore
5.19 32.73 lineto
gsave
stroke
grestore
8.69 0.00 lineto
gsave
stroke
grestore
0 0 lineto
24.77 0 lineto 
5 296 moveto
45 rotate
% assign font for taxon name
set_taxon-italic
(Abies          ) show
-45 rotate
5 leading_45 add 296 moveto
45 rotate
set_taxon
(                ) show
-45 rotate
5 2 leading_45 mul add 296 moveto
45 rotate
set_taxon
(                ) show
-45 rotate
gsave
1 0 0 setrgbcolor fill
grestore
stroke
% assign font for numbers under taxon x-axis
set_botnum
0 nstr cvs dup stringwidth pop
2 div
0.00 exch sub -11 moveto
show
0.00 -3 moveto
0 6 rlineto
10 nstr cvs dup stringwidth pop
2 div
24.77 exch sub -11 moveto
show
24.77 -3 moveto
0 6 rlineto
% assign font for label under taxon curve
set_botlab
0 11 leading add neg moveto
(                              ) show
0 11 leading 2 mul add neg moveto
(                              ) show
39.64 0 translate
stroke
0 0 moveto
0 288.00 lineto
2.74 288.00 lineto
gsave
stroke
grestore
1.63 261.82 lineto
gsave
stroke
grestore
1.34 248.73 lineto
gsave
stroke
grestore
1.34 229.09 lineto
gsave
stroke
grestore
1.46 202.91 lineto
gsave
stroke
grestore
0.93 176.73 lineto
gsave
stroke
grestore
2.13 130.91 lineto
gsave
stroke
grestore
0.32 98.18 lineto
gsave
stroke
grestore
3.19 32.73 lineto
gsave
stroke
grestore
1.65 0.00 lineto
gsave
stroke
grestore
0 0 lineto
24.77 0 lineto 
5 296 moveto
45 rotate
% assign font for taxon name
set_taxon-italic
(TCT            ) show
-45 rotate
5 leading_45 add 296 moveto
45 rotate
set_taxon
(                ) show
-45 rotate
5 2 leading_45 mul add 296 moveto
45 rotate
set_taxon
(                ) show
-45 rotate
gsave
1 0 0 setrgbcolor fill
grestore
stroke
% assign font for numbers under taxon x-axis
set_botnum
0 nstr cvs dup stringwidth pop
2 div
0.00 exch sub -11 moveto
show
0.00 -3 moveto
0 6 rlineto
10 nstr cvs dup stringwidth pop
2 div
24.77 exch sub -11 moveto
show
24.77 -3 moveto
0 6 rlineto
% assign font for label under taxon curve
set_botlab
0 11 leading add neg moveto
(                              ) show
0 11 leading 2 mul add neg moveto
(                              ) show
39.64 0 translate
stroke
0 0 moveto
0 288.00 lineto
1.57 288.00 lineto
gsave
stroke
grestore
0.00 261.82 lineto
gsave
stroke
grestore
0.00 248.73 lineto
gsave
stroke
grestore
0.00 229.09 lineto
gsave
stroke
grestore
0.00 202.91 lineto
gsave
stroke
grestore
0.00 176.73 lineto
gsave
stroke
grestore
0.00 130.91 lineto
gsave
stroke
grestore
0.00 98.18 lineto
gsave
stroke
grestore
1.20 32.73 lineto
gsave
stroke
grestore
0.00 0.00 lineto
gsave
stroke
grestore
0 0 lineto
24.77 0 lineto 
5 296 moveto
45 rotate
% assign font for taxon name
set_taxon-italic
(Pseudostuga    ) show
-45 rotate
5 leading_45 add 296 moveto
45 rotate
set_taxon
(                ) show
-45 rotate
5 2 leading_45 mul add 296 moveto
45 rotate
set_taxon
(                ) show
-45 rotate
gsave
1 0 0 setrgbcolor fill
grestore
stroke
% assign font for numbers under taxon x-axis
set_botnum
0 nstr cvs dup stringwidth pop
2 div
0.00 exch sub -11 moveto
show
0.00 -3 moveto
0 6 rlineto
10 nstr cvs dup stringwidth pop
2 div
24.77 exch sub -11 moveto
show
24.77 -3 moveto
0 6 rlineto
% assign font for label under taxon curve
set_botlab
0 11 leading add neg moveto
(                              ) show
0 11 leading 2 mul add neg moveto
(                              ) show
39.64 0 translate
stroke
0 0 moveto
0 288.00 lineto
0.78 288.00 lineto
gsave
stroke
grestore
1.31 261.82 lineto
gsave
stroke
grestore
1.68 248.73 lineto
gsave
stroke
grestore
0.00 229.09 lineto
gsave
stroke
grestore
2.56 202.91 lineto
gsave
stroke
grestore
2.49 176.73 lineto
gsave
stroke
grestore
2.49 130.91 lineto
gsave
stroke
grestore
0.65 98.18 lineto
gsave
stroke
grestore
1.60 32.73 lineto
gsave
stroke
grestore
0.83 0.00 lineto
gsave
stroke
grestore
0 0 lineto
24.77 0 lineto 
5 296 moveto
45 rotate
% assign font for taxon name
set_taxon-italic
(Tsuga          ) show
-45 rotate
5 leading_45 add 296 moveto
45 rotate
set_taxon
(                ) show
-45 rotate
5 2 leading_45 mul add 296 moveto
45 rotate
set_taxon
(                ) show
-45 rotate
gsave
1 0 0 setrgbcolor fill
grestore
stroke
% assign font for numbers under taxon x-axis
set_botnum
0 nstr cvs dup stringwidth pop
2 div
0.00 exch sub -11 moveto
show
0.00 -3 moveto
0 6 rlineto
10 nstr cvs dup stringwidth pop
2 div
24.77 exch sub -11 moveto
show
24.77 -3 moveto
0 6 rlineto
% assign font for label under taxon curve
set_botlab
0 11 leading add neg moveto
(                              ) show
0 11 leading 2 mul add neg moveto
(                              ) show
39.64 0 translate
stroke
0 0 moveto
0 288.00 lineto
10.19 288.00 lineto
gsave
stroke
grestore
10.46 261.82 lineto
gsave
stroke
grestore
8.05 248.73 lineto
gsave
stroke
grestore
8.38 229.09 lineto
gsave
stroke
grestore
7.68 202.91 lineto
gsave
stroke
grestore
7.46 176.73 lineto
gsave
stroke
grestore
4.62 130.91 lineto
gsave
stroke
grestore
6.17 98.18 lineto
gsave
stroke
grestore
8.78 32.73 lineto
gsave
stroke
grestore
4.55 0.00 lineto
gsave
stroke
grestore
0 0 lineto
24.77 0 lineto 
5 296 moveto
45 rotate
% assign font for taxon name
set_taxon-italic
(Quercus        ) show
-45 rotate
5 leading_45 add 296 moveto
45 rotate
set_taxon
(                ) show
-45 rotate
5 2 leading_45 mul add 296 moveto
45 rotate
set_taxon
(                ) show
-45 rotate
gsave
1 0 0 setrgbcolor fill
grestore
stroke
% assign font for numbers under taxon x-axis
set_botnum
0 nstr cvs dup stringwidth pop
2 div
0.00 exch sub -11 moveto
show
0.00 -3 moveto
0 6 rlineto
10 nstr cvs dup stringwidth pop
2 div
24.77 exch sub -11 moveto
show
24.77 -3 moveto
0 6 rlineto
% assign font for label under taxon curve
set_botlab
0 11 leading add neg moveto
(                              ) show
0 11 leading 2 mul add neg moveto
(                              ) show
39.64 0 translate
stroke
0 0 moveto
0 288.00 lineto
1.96 288.00 lineto
gsave
stroke
grestore
1.31 261.82 lineto
gsave
stroke
grestore
1.68 248.73 lineto
gsave
stroke
grestore
1.68 229.09 lineto
gsave
stroke
grestore
1.10 202.91 lineto
gsave
stroke
grestore
2.49 176.73 lineto
gsave
stroke
grestore
0.00 130.91 lineto
gsave
stroke
grestore
0.32 98.18 lineto
gsave
stroke
grestore
2.39 32.73 lineto
gsave
stroke
grestore
0.00 0.00 lineto
gsave
stroke
grestore
0 0 lineto
24.77 0 lineto 
5 296 moveto
45 rotate
% assign font for taxon name
set_taxon
(RRA             ) show
-45 rotate
5 leading_45 add 296 moveto
45 rotate
set_taxon
(                ) show
-45 rotate
5 2 leading_45 mul add 296 moveto
45 rotate
set_taxon
(                ) show
-45 rotate
gsave
1 0 0 setrgbcolor fill
grestore
stroke
% assign font for numbers under taxon x-axis
set_botnum
0 nstr cvs dup stringwidth pop
2 div
0.00 exch sub -11 moveto
show
0.00 -3 moveto
0 6 rlineto
10 nstr cvs dup stringwidth pop
2 div
24.77 exch sub -11 moveto
show
24.77 -3 moveto
0 6 rlineto
% assign font for label under taxon curve
set_botlab
0 11 leading add neg moveto
(                              ) show
0 11 leading 2 mul add neg moveto
(                              ) show
39.64 0 translate
stroke
0 0 moveto
0 288.00 lineto
1.57 288.00 lineto
gsave
stroke
grestore
0.98 261.82 lineto
gsave
stroke
grestore
2.68 248.73 lineto
gsave
stroke
grestore
2.01 229.09 lineto
gsave
stroke
grestore
1.46 202.91 lineto
gsave
stroke
grestore
1.87 176.73 lineto
gsave
stroke
grestore
1.42 130.91 lineto
gsave
stroke
grestore
1.30 98.18 lineto
gsave
stroke
grestore
0.80 32.73 lineto
gsave
stroke
grestore
2.07 0.00 lineto
gsave
stroke
grestore
0 0 lineto
24.77 0 lineto 
5 296 moveto
45 rotate
% assign font for taxon name
set_taxon-italic
(Salix          ) show
-45 rotate
5 leading_45 add 296 moveto
45 rotate
set_taxon
(                ) show
-45 rotate
5 2 leading_45 mul add 296 moveto
45 rotate
set_taxon
(                ) show
-45 rotate
gsave
1 0 0 setrgbcolor fill
grestore
stroke
% assign font for numbers under taxon x-axis
set_botnum
0 nstr cvs dup stringwidth pop
2 div
0.00 exch sub -11 moveto
show
0.00 -3 moveto
0 6 rlineto
10 nstr cvs dup stringwidth pop
2 div
24.77 exch sub -11 moveto
show
24.77 -3 moveto
0 6 rlineto
% assign font for label under taxon curve
set_botlab
0 11 leading add neg moveto
(                              ) show
0 11 leading 2 mul add neg moveto
(                              ) show
39.64 0 translate
stroke
0 0 moveto
0 288.00 lineto
12.54 288.00 lineto
gsave
stroke
grestore
10.46 261.82 lineto
gsave
stroke
grestore
12.57 248.73 lineto
gsave
stroke
grestore
13.91 229.09 lineto
gsave
stroke
grestore
12.26 202.91 lineto
gsave
stroke
grestore
8.55 176.73 lineto
gsave
stroke
grestore
9.06 130.91 lineto
gsave
stroke
grestore
9.58 98.18 lineto
gsave
stroke
grestore
10.17 32.73 lineto
gsave
stroke
grestore
10.75 0.00 lineto
gsave
stroke
grestore
0 0 lineto
24.77 0 lineto 
5 296 moveto
45 rotate
% assign font for taxon name
set_taxon-italic
(Artemisia      ) show
-45 rotate
5 leading_45 add 296 moveto
45 rotate
set_taxon
(                ) show
-45 rotate
5 2 leading_45 mul add 296 moveto
45 rotate
set_taxon
(                ) show
-45 rotate
gsave
1 0 0 setrgbcolor fill
grestore
stroke
% assign font for numbers under taxon x-axis
set_botnum
0 nstr cvs dup stringwidth pop
2 div
0.00 exch sub -11 moveto
show
0.00 -3 moveto
0 6 rlineto
20 nstr cvs dup stringwidth pop
2 div
24.77 exch sub -11 moveto
show
24.77 -3 moveto
0 6 rlineto
% assign font for label under taxon curve
set_botlab
0 11 leading add neg moveto
(                              ) show
0 11 leading 2 mul add neg moveto
(                              ) show
39.64 0 translate
stroke
0 0 moveto
0 288.00 lineto
1.18 288.00 lineto
gsave
stroke
grestore
3.27 261.82 lineto
gsave
stroke
grestore
3.69 248.73 lineto
gsave
stroke
grestore
3.35 229.09 lineto
gsave
stroke
grestore
4.03 202.91 lineto
gsave
stroke
grestore
3.11 176.73 lineto
gsave
stroke
grestore
5.33 130.91 lineto
gsave
stroke
grestore
2.60 98.18 lineto
gsave
stroke
grestore
1.60 32.73 lineto
gsave
stroke
grestore
1.65 0.00 lineto
gsave
stroke
grestore
0 0 lineto
24.77 0 lineto 
5 296 moveto
45 rotate
% assign font for taxon name
set_taxon
(COMPOSITAE      ) show
-45 rotate
5 leading_45 add 296 moveto
45 rotate
set_taxon
(                ) show
-45 rotate
5 2 leading_45 mul add 296 moveto
45 rotate
set_taxon
(                ) show
-45 rotate
gsave
1 0 0 setrgbcolor fill
grestore
stroke
% assign font for numbers under taxon x-axis
set_botnum
0 nstr cvs dup stringwidth pop
2 div
0.00 exch sub -11 moveto
show
0.00 -3 moveto
0 6 rlineto
10 nstr cvs dup stringwidth pop
2 div
24.77 exch sub -11 moveto
show
24.77 -3 moveto
0 6 rlineto
% assign font for label under taxon curve
set_botlab
0 11 leading add neg moveto
(                              ) show
0 11 leading 2 mul add neg moveto
(                              ) show
39.64 0 translate
stroke
0 0 moveto
0 288.00 lineto
0.78 288.00 lineto
gsave
stroke
grestore
0.98 261.82 lineto
gsave
stroke
grestore
0.67 248.73 lineto
gsave
stroke
grestore
0.00 229.09 lineto
gsave
stroke
grestore
1.10 202.91 lineto
gsave
stroke
grestore
0.62 176.73 lineto
gsave
stroke
grestore
0.00 130.91 lineto
gsave
stroke
grestore
0.00 98.18 lineto
gsave
stroke
grestore
0.00 32.73 lineto
gsave
stroke
grestore
0.00 0.00 lineto
gsave
stroke
grestore
0 0 lineto
24.77 0 lineto 
5 296 moveto
45 rotate
% assign font for taxon name
set_taxon
(ELAEAGNACEAE    ) show
-45 rotate
5 leading_45 add 296 moveto
45 rotate
set_taxon
(                ) show
-45 rotate
5 2 leading_45 mul add 296 moveto
45 rotate
set_taxon
(                ) show
-45 rotate
gsave
1 0 0 setrgbcolor fill
grestore
stroke
% assign font for numbers under taxon x-axis
set_botnum
0 nstr cvs dup stringwidth pop
2 div
0.00 exch sub -11 moveto
show
0.00 -3 moveto
0 6 rlineto
10 nstr cvs dup stringwidth pop
2 div
24.77 exch sub -11 moveto
show
24.77 -3 moveto
0 6 rlineto
% assign font for label under taxon curve
set_botlab
0 11 leading add neg moveto
(                              ) show
0 11 leading 2 mul add neg moveto
(                              ) show
39.64 0 translate
stroke
0 0 moveto
0 288.00 lineto
4.31 288.00 lineto
gsave
stroke
grestore
0.33 261.82 lineto
gsave
stroke
grestore
1.01 248.73 lineto
gsave
stroke
grestore
0.34 229.09 lineto
gsave
stroke
grestore
0.37 202.91 lineto
gsave
stroke
grestore
0.00 176.73 lineto
gsave
stroke
grestore
0.00 130.91 lineto
gsave
stroke
grestore
0.00 98.18 lineto
gsave
stroke
grestore
0.00 32.73 lineto
gsave
stroke
grestore
0.00 0.00 lineto
gsave
stroke
grestore
0 0 lineto
24.77 0 lineto 
5 296 moveto
45 rotate
% assign font for taxon name
set_taxon-italic
(Rumex          ) show
-45 rotate
5 leading_45 add 296 moveto
45 rotate
set_taxon-italic
(acetosella     ) show
-45 rotate
5 2 leading_45 mul add 296 moveto
45 rotate
set_taxon
(                ) show
-45 rotate
gsave
1 0 0 setrgbcolor fill
grestore
stroke
% assign font for numbers under taxon x-axis
set_botnum
0 nstr cvs dup stringwidth pop
2 div
0.00 exch sub -11 moveto
show
0.00 -3 moveto
0 6 rlineto
10 nstr cvs dup stringwidth pop
2 div
24.77 exch sub -11 moveto
show
24.77 -3 moveto
0 6 rlineto
% assign font for label under taxon curve
set_botlab
0 11 leading add neg moveto
(                              ) show
0 11 leading 2 mul add neg moveto
(                              ) show
39.64 0 translate
stroke
0 0 moveto
0 288.00 lineto
2.35 288.00 lineto
gsave
stroke
grestore
0.00 261.82 lineto
gsave
stroke
grestore
0.00 248.73 lineto
gsave
stroke
grestore
0.34 229.09 lineto
gsave
stroke
grestore
0.00 202.91 lineto
gsave
stroke
grestore
0.00 176.73 lineto
gsave
stroke
grestore
0.00 130.91 lineto
gsave
stroke
grestore
0.00 98.18 lineto
gsave
stroke
grestore
0.00 32.73 lineto
gsave
stroke
grestore
0.00 0.00 lineto
gsave
stroke
grestore
0 0 lineto
24.77 0 lineto 
5 296 moveto
45 rotate
% assign font for taxon name
set_taxon-italic
(Plantago       ) show
-45 rotate
5 leading_45 add 296 moveto
45 rotate
set_taxon-italic
(lanceolata     ) show
-45 rotate
5 2 leading_45 mul add 296 moveto
45 rotate
set_taxon
(                ) show
-45 rotate
gsave
0.3 setgray fill
grestore
stroke
% assign font for numbers under taxon x-axis
set_botnum
0 nstr cvs dup stringwidth pop
2 div
0.00 exch sub -11 moveto
show
0.00 -3 moveto
0 6 rlineto
10 nstr cvs dup stringwidth pop
2 div
24.77 exch sub -11 moveto
show
24.77 -3 moveto
0 6 rlineto
% assign font for label under taxon curve
set_botlab
0 11 leading add neg moveto
(                              ) show
0 11 leading 2 mul add neg moveto
(                              ) show
39.64 0 translate
stroke
0 0 moveto
0 288.00 lineto
6.66 288.00 lineto
gsave
stroke
grestore
5.56 261.82 lineto
gsave
stroke
grestore
5.36 248.73 lineto
gsave
stroke
grestore
7.71 229.09 lineto
gsave
stroke
grestore
5.86 202.91 lineto
gsave
stroke
grestore
5.28 176.73 lineto
gsave
stroke
grestore
1.78 130.91 lineto
gsave
stroke
grestore
7.14 98.18 lineto
gsave
stroke
grestore
7.18 32.73 lineto
gsave
stroke
grestore
2.48 0.00 lineto
gsave
stroke
grestore
0 0 lineto
24.77 0 lineto 
5 296 moveto
45 rotate
% assign font for taxon name
set_taxon
(GRAMINEAE       ) show
-45 rotate
5 leading_45 add 296 moveto
45 rotate
set_taxon
(                ) show
-45 rotate
5 2 leading_45 mul add 296 moveto
45 rotate
set_taxon
(                ) show
-45 rotate
gsave
0.3 setgray fill
grestore
stroke
% assign font for numbers under taxon x-axis
set_botnum
0 nstr cvs dup stringwidth pop
2 div
0.00 exch sub -11 moveto
show
0.00 -3 moveto
0 6 rlineto
10 nstr cvs dup stringwidth pop
2 div
24.77 exch sub -11 moveto
show
24.77 -3 moveto
0 6 rlineto
% assign font for label under taxon curve
set_botlab
0 11 leading add neg moveto
(                              ) show
0 11 leading 2 mul add neg moveto
(                              ) show
39.64 0 translate
stroke
0 0 moveto
0 288.00 lineto
16.66 288.00 lineto
gsave
stroke
grestore
15.20 261.82 lineto
gsave
stroke
grestore
18.27 248.73 lineto
gsave
stroke
grestore
19.11 229.09 lineto
gsave
stroke
grestore
18.48 202.91 lineto
gsave
stroke
grestore
16.63 176.73 lineto
gsave
stroke
grestore
18.84 130.91 lineto
gsave
stroke
grestore
24.19 98.18 lineto
gsave
stroke
grestore
19.95 32.73 lineto
gsave
stroke
grestore
16.34 0.00 lineto
gsave
stroke
grestore
0 0 lineto
24.77 0 lineto 
5 296 moveto
45 rotate
% assign font for taxon name
set_taxon
(CHENOPODIACEAE  ) show
-45 rotate
5 leading_45 add 296 moveto
45 rotate
set_taxon
(                ) show
-45 rotate
5 2 leading_45 mul add 296 moveto
45 rotate
set_taxon
(                ) show
-45 rotate
gsave
0.3 setgray fill
grestore
stroke
% assign font for numbers under taxon x-axis
set_botnum
0 nstr cvs dup stringwidth pop
2 div
0.00 exch sub -11 moveto
show
0.00 -3 moveto
0 6 rlineto
20 nstr cvs dup stringwidth pop
2 div
24.77 exch sub -11 moveto
show
24.77 -3 moveto
0 6 rlineto
% assign font for label under taxon curve
set_botlab
0 11 leading add neg moveto
(                              ) show
0 11 leading 2 mul add neg moveto
(                              ) show
39.64 0 translate
stroke
0 0 moveto
0 288.00 lineto
31.75 288.00 lineto
gsave
stroke
grestore
28.76 261.82 lineto
gsave
stroke
grestore
31.18 248.73 lineto
gsave
stroke
grestore
25.48 229.09 lineto
gsave
stroke
grestore
25.62 202.91 lineto
gsave
stroke
grestore
24.87 176.73 lineto
gsave
stroke
grestore
24.17 130.91 lineto
gsave
stroke
grestore
23.05 98.18 lineto
gsave
stroke
grestore
25.93 32.73 lineto
gsave
stroke
grestore
38.05 0.00 lineto
gsave
stroke
grestore
0 0 lineto
38.05 0 lineto 
5 296 moveto
45 rotate
% assign font for taxon name
set_taxon
(PORTULACACEAE   ) show
-45 rotate
5 leading_45 add 296 moveto
45 rotate
set_taxon
(                ) show
-45 rotate
5 2 leading_45 mul add 296 moveto
45 rotate
set_taxon
(                ) show
-45 rotate
gsave
0.3 setgray fill
grestore
stroke
% assign font for numbers under taxon x-axis
set_botnum
0 nstr cvs dup stringwidth pop
2 div
0.00 exch sub -11 moveto
show
0.00 -3 moveto
0 6 rlineto
10 nstr cvs dup stringwidth pop
2 div
24.77 exch sub -11 moveto
show
24.77 -3 moveto
0 6 rlineto
% assign font for label under taxon curve
set_botlab
0 11 leading add neg moveto
(                              ) show
0 11 leading 2 mul add neg moveto
(                              ) show
52.92 0 translate
stroke
0 0 moveto
0 288.00 lineto
5.88 288.00 lineto
gsave
stroke
grestore
2.29 261.82 lineto
gsave
stroke
grestore
2.35 248.73 lineto
gsave
stroke
grestore
2.01 229.09 lineto
gsave
stroke
grestore
5.49 202.91 lineto
gsave
stroke
grestore
3.11 176.73 lineto
gsave
stroke
grestore
0.00 130.91 lineto
gsave
stroke
grestore
1.95 98.18 lineto
gsave
stroke
grestore
3.19 32.73 lineto
gsave
stroke
grestore
2.48 0.00 lineto
gsave
stroke
grestore
0 0 lineto
24.77 0 lineto 
5 296 moveto
45 rotate
% assign font for taxon name
set_taxon
(CYPERACEAE      ) show
-45 rotate
5 leading_45 add 296 moveto
45 rotate
set_taxon
(                ) show
-45 rotate
5 2 leading_45 mul add 296 moveto
45 rotate
set_taxon
(                ) show
-45 rotate
gsave
0.3 setgray fill
grestore
stroke
% assign font for numbers under taxon x-axis
set_botnum
0 nstr cvs dup stringwidth pop
2 div
0.00 exch sub -11 moveto
show
0.00 -3 moveto
0 6 rlineto
10 nstr cvs dup stringwidth pop
2 div
24.77 exch sub -11 moveto
show
24.77 -3 moveto
0 6 rlineto
% assign font for label under taxon curve
set_botlab
0 11 leading add neg moveto
(                              ) show
0 11 leading 2 mul add neg moveto
(                              ) show
39.64 0 translate
stroke
grestore
% assign font for taxon group labels
set_taxgrp
-7 296.00 moveto
45 rotate
90 0 rlineto
-45 rotate
9 0 rlineto
9 -3 rmoveto
(TREES) show
9 3 rmoveto
426.29 359.64 lineto
45 rotate
-90 0 rlineto
-45 rotate
stroke
387.29 0 translate
-7 296.00 moveto
45 rotate
90 0 rlineto
-45 rotate
9 0 rlineto
9 -3 rmoveto
(HERBS & SHRUBS) show
9 3 rmoveto
237.20 359.64 lineto
45 rotate
-90 0 rlineto
-45 rotate
stroke
198.20 0 translate
-7 296.00 moveto
45 rotate
90 0 rlineto
-45 rotate
9 0 rlineto
9 -3 rmoveto
(AQUATICS) show
9 3 rmoveto
171.19 359.64 lineto
45 rotate
-90 0 rlineto
-45 rotate
stroke
132.19 0 translate
stroke
showpage
