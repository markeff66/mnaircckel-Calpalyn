%!PS-Adobe-3.0 EPSF-3.0
%%Creator: CalPalyn Version 2.1
%%CreationDate: Tue Mar 24  2:16:29 PM 2009
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
set_title (Mountain Lake, San Francisco                                                    @€) show
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
0 9 translate
0 272.45 moveto
71.92 272.45 lineto
71.92 285.55 lineto
0 285.55 lineto
0 272.45 lineto
gsave
gsave
stroke
grestore
0 setgray fill
grestore
stroke
0 265.91 moveto
48.68 265.91 lineto
48.68 279.00 lineto
0 279.00 lineto
0 265.91 lineto
gsave
gsave
stroke
grestore
0 setgray fill
grestore
stroke
0 259.36 moveto
5.04 259.36 lineto
5.04 272.45 lineto
0 272.45 lineto
0 259.36 lineto
gsave
gsave
stroke
grestore
0 setgray fill
grestore
stroke
0 252.82 moveto
5.70 252.82 lineto
5.70 265.91 lineto
0 265.91 lineto
0 252.82 lineto
gsave
gsave
stroke
grestore
0 setgray fill
grestore
stroke
0 246.27 moveto
5.38 246.27 lineto
5.38 259.36 lineto
0 259.36 lineto
0 246.27 lineto
gsave
gsave
stroke
grestore
0 setgray fill
grestore
stroke
0 239.73 moveto
0.00 239.73 lineto
0.00 252.82 lineto
0 252.82 lineto
0 239.73 lineto
gsave
gsave
stroke
grestore
0 setgray fill
grestore
stroke
0 233.18 moveto
16.56 233.18 lineto
16.56 246.27 lineto
0 246.27 lineto
0 233.18 lineto
gsave
gsave
stroke
grestore
0 setgray fill
grestore
stroke
0 226.64 moveto
0.00 226.64 lineto
0.00 239.73 lineto
0 239.73 lineto
0 226.64 lineto
gsave
gsave
stroke
grestore
0 setgray fill
grestore
stroke
0 213.55 moveto
5.51 213.55 lineto
5.51 226.64 lineto
0 226.64 lineto
0 213.55 lineto
gsave
gsave
stroke
grestore
0 setgray fill
grestore
stroke
0 200.45 moveto
0.00 200.45 lineto
0.00 213.55 lineto
0 213.55 lineto
0 200.45 lineto
gsave
gsave
stroke
grestore
0 setgray fill
grestore
stroke
0 187.36 moveto
0.00 187.36 lineto
0.00 200.45 lineto
0 200.45 lineto
0 187.36 lineto
gsave
gsave
stroke
grestore
0 setgray fill
grestore
stroke
0 180.82 moveto
0.00 180.82 lineto
0.00 193.91 lineto
0 193.91 lineto
0 180.82 lineto
gsave
gsave
stroke
grestore
0 setgray fill
grestore
stroke
0 174.27 moveto
0.00 174.27 lineto
0.00 187.36 lineto
0 187.36 lineto
0 174.27 lineto
gsave
gsave
stroke
grestore
0 setgray fill
grestore
stroke
0 161.18 moveto
0.00 161.18 lineto
0.00 174.27 lineto
0 174.27 lineto
0 161.18 lineto
gsave
gsave
stroke
grestore
0 setgray fill
grestore
stroke
0 148.09 moveto
0.00 148.09 lineto
0.00 161.18 lineto
0 161.18 lineto
0 148.09 lineto
gsave
gsave
stroke
grestore
0 setgray fill
grestore
stroke
0 115.36 moveto
0.00 115.36 lineto
0.00 128.45 lineto
0 128.45 lineto
0 115.36 lineto
gsave
gsave
stroke
grestore
0 setgray fill
grestore
stroke
0 95.73 moveto
0.00 95.73 lineto
0.00 108.82 lineto
0 108.82 lineto
0 95.73 lineto
gsave
gsave
stroke
grestore
0 setgray fill
grestore
stroke
0 82.64 moveto
0.00 82.64 lineto
0.00 95.73 lineto
0 95.73 lineto
0 82.64 lineto
gsave
gsave
stroke
grestore
0 setgray fill
grestore
stroke
0 56.45 moveto
0.00 56.45 lineto
0.00 69.55 lineto
0 69.55 lineto
0 56.45 lineto
gsave
gsave
stroke
grestore
0 setgray fill
grestore
stroke
0 17.18 moveto
0.00 17.18 lineto
0.00 30.27 lineto
0 30.27 lineto
0 17.18 lineto
gsave
gsave
stroke
grestore
0 setgray fill
grestore
stroke
0 -15.55 moveto
0.00 -15.55 lineto
0.00 -2.45 lineto
0 -2.45 lineto
0 -15.55 lineto
gsave
gsave
stroke
grestore
0 setgray fill
grestore
stroke
0 -9 translate
0 0 moveto
0 0 lineto
80.82 0 lineto 
stroke
8 leading_45 14 sub add 296 moveto
45 rotate
% assign font for taxon name
set_taxon-italic
(Salsola        ) show
-45 rotate
8 leading_45 add 296 moveto
45 rotate
set_taxon-italic
(collina        ) show
-45 rotate
8 2 leading_45 mul add 296 moveto
45 rotate
set_taxon
(                ) show
-45 rotate
% assign font for numbers under taxon x-axis
set_botnum
0 nstr cvs dup stringwidth pop
2 div
0.00 exch sub -11 moveto
show
0.00 -3 moveto
0 6 rlineto
2 nstr cvs dup stringwidth pop
2 div
80.82 exch sub -11 moveto
show
80.82 -3 moveto
0 6 rlineto
% assign font for label under taxon curve
set_botlab
0 11 leading add neg moveto
( ercent Total Non-Aquatic Poll) show
0 11 leading 2 mul add neg moveto
(                              ) show
129.31 0 translate
stroke
0 0 moveto
0 288.00 lineto
0 9 translate
0 272.45 moveto
242.45 272.45 lineto
242.45 285.55 lineto
0 285.55 lineto
0 272.45 lineto
gsave
gsave
stroke
grestore
0 setgray fill
grestore
stroke
0 265.91 moveto
121.22 265.91 lineto
121.22 279.00 lineto
0 279.00 lineto
0 265.91 lineto
gsave
gsave
stroke
grestore
0 setgray fill
grestore
stroke
0 259.36 moveto
0.00 259.36 lineto
0.00 272.45 lineto
0 272.45 lineto
0 259.36 lineto
gsave
gsave
stroke
grestore
0 setgray fill
grestore
stroke
0 252.82 moveto
0.00 252.82 lineto
0.00 265.91 lineto
0 265.91 lineto
0 252.82 lineto
gsave
gsave
stroke
grestore
0 setgray fill
grestore
stroke
0 246.27 moveto
0.00 246.27 lineto
0.00 259.36 lineto
0 259.36 lineto
0 246.27 lineto
gsave
gsave
stroke
grestore
0 setgray fill
grestore
stroke
0 239.73 moveto
0.00 239.73 lineto
0.00 252.82 lineto
0 252.82 lineto
0 239.73 lineto
gsave
gsave
stroke
grestore
0 setgray fill
grestore
stroke
0 233.18 moveto
0.00 233.18 lineto
0.00 246.27 lineto
0 246.27 lineto
0 233.18 lineto
gsave
gsave
stroke
grestore
0 setgray fill
grestore
stroke
0 226.64 moveto
0.00 226.64 lineto
0.00 239.73 lineto
0 239.73 lineto
0 226.64 lineto
gsave
gsave
stroke
grestore
0 setgray fill
grestore
stroke
0 213.55 moveto
40.41 213.55 lineto
40.41 226.64 lineto
0 226.64 lineto
0 213.55 lineto
gsave
gsave
stroke
grestore
0 setgray fill
grestore
stroke
0 200.45 moveto
0.00 200.45 lineto
0.00 213.55 lineto
0 213.55 lineto
0 200.45 lineto
gsave
gsave
stroke
grestore
0 setgray fill
grestore
stroke
0 187.36 moveto
0.00 187.36 lineto
0.00 200.45 lineto
0 200.45 lineto
0 187.36 lineto
gsave
gsave
stroke
grestore
0 setgray fill
grestore
stroke
0 180.82 moveto
0.00 180.82 lineto
0.00 193.91 lineto
0 193.91 lineto
0 180.82 lineto
gsave
gsave
stroke
grestore
0 setgray fill
grestore
stroke
0 174.27 moveto
0.00 174.27 lineto
0.00 187.36 lineto
0 187.36 lineto
0 174.27 lineto
gsave
gsave
stroke
grestore
0 setgray fill
grestore
stroke
0 161.18 moveto
0.00 161.18 lineto
0.00 174.27 lineto
0 174.27 lineto
0 161.18 lineto
gsave
gsave
stroke
grestore
0 setgray fill
grestore
stroke
0 148.09 moveto
0.00 148.09 lineto
0.00 161.18 lineto
0 161.18 lineto
0 148.09 lineto
gsave
gsave
stroke
grestore
0 setgray fill
grestore
stroke
0 115.36 moveto
0.00 115.36 lineto
0.00 128.45 lineto
0 128.45 lineto
0 115.36 lineto
gsave
gsave
stroke
grestore
0 setgray fill
grestore
stroke
0 95.73 moveto
0.00 95.73 lineto
0.00 108.82 lineto
0 108.82 lineto
0 95.73 lineto
gsave
gsave
stroke
grestore
0 setgray fill
grestore
stroke
0 82.64 moveto
0.00 82.64 lineto
0.00 95.73 lineto
0 95.73 lineto
0 82.64 lineto
gsave
gsave
stroke
grestore
0 setgray fill
grestore
stroke
0 56.45 moveto
0.00 56.45 lineto
0.00 69.55 lineto
0 69.55 lineto
0 56.45 lineto
gsave
gsave
stroke
grestore
0 setgray fill
grestore
stroke
0 17.18 moveto
0.00 17.18 lineto
0.00 30.27 lineto
0 30.27 lineto
0 17.18 lineto
gsave
gsave
stroke
grestore
0 setgray fill
grestore
stroke
0 -15.55 moveto
0.00 -15.55 lineto
0.00 -2.45 lineto
0 -2.45 lineto
0 -15.55 lineto
gsave
gsave
stroke
grestore
0 setgray fill
grestore
stroke
0 -9 translate
0 0 moveto
0 0 lineto
242.45 0 lineto 
stroke
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
% assign font for numbers under taxon x-axis
set_botnum
0 nstr cvs dup stringwidth pop
2 div
0.00 exch sub -11 moveto
show
0.00 -3 moveto
0 6 rlineto
2 nstr cvs dup stringwidth pop
2 div
80.82 exch sub -11 moveto
show
80.82 -3 moveto
0 6 rlineto
4 nstr cvs dup stringwidth pop
2 div
161.63 exch sub -11 moveto
show
161.63 -3 moveto
0 6 rlineto
6 nstr cvs dup stringwidth pop
2 div
242.45 exch sub -11 moveto
show
242.45 -3 moveto
0 6 rlineto
% assign font for label under taxon curve
set_botlab
0 11 leading add neg moveto
(                              ) show
0 11 leading 2 mul add neg moveto
(                              ) show
290.94 0 translate
stroke
0 0 moveto
0 288.00 lineto
0 9 translate
0 272.45 moveto
26.15 272.45 lineto
26.15 285.55 lineto
0 285.55 lineto
0 272.45 lineto
gsave
gsave
stroke
grestore
0 setgray fill
grestore
stroke
0 265.91 moveto
0.00 265.91 lineto
0.00 279.00 lineto
0 279.00 lineto
0 265.91 lineto
gsave
gsave
stroke
grestore
0 setgray fill
grestore
stroke
0 259.36 moveto
10.09 259.36 lineto
10.09 272.45 lineto
0 272.45 lineto
0 259.36 lineto
gsave
gsave
stroke
grestore
0 setgray fill
grestore
stroke
0 252.82 moveto
0.00 252.82 lineto
0.00 265.91 lineto
0 265.91 lineto
0 252.82 lineto
gsave
gsave
stroke
grestore
0 setgray fill
grestore
stroke
0 246.27 moveto
32.28 246.27 lineto
32.28 259.36 lineto
0 259.36 lineto
0 246.27 lineto
gsave
gsave
stroke
grestore
0 setgray fill
grestore
stroke
0 239.73 moveto
26.37 239.73 lineto
26.37 252.82 lineto
0 252.82 lineto
0 239.73 lineto
gsave
gsave
stroke
grestore
0 setgray fill
grestore
stroke
0 233.18 moveto
22.08 233.18 lineto
22.08 246.27 lineto
0 246.27 lineto
0 233.18 lineto
gsave
gsave
stroke
grestore
0 setgray fill
grestore
stroke
0 226.64 moveto
0.00 226.64 lineto
0.00 239.73 lineto
0 239.73 lineto
0 226.64 lineto
gsave
gsave
stroke
grestore
0 setgray fill
grestore
stroke
0 213.55 moveto
0.00 213.55 lineto
0.00 226.64 lineto
0 226.64 lineto
0 213.55 lineto
gsave
gsave
stroke
grestore
0 setgray fill
grestore
stroke
0 200.45 moveto
51.56 200.45 lineto
51.56 213.55 lineto
0 213.55 lineto
0 200.45 lineto
gsave
gsave
stroke
grestore
0 setgray fill
grestore
stroke
0 187.36 moveto
36.68 187.36 lineto
36.68 200.45 lineto
0 200.45 lineto
0 187.36 lineto
gsave
gsave
stroke
grestore
0 setgray fill
grestore
stroke
0 180.82 moveto
0.00 180.82 lineto
0.00 193.91 lineto
0 193.91 lineto
0 180.82 lineto
gsave
gsave
stroke
grestore
0 setgray fill
grestore
stroke
0 174.27 moveto
0.00 174.27 lineto
0.00 187.36 lineto
0 187.36 lineto
0 174.27 lineto
gsave
gsave
stroke
grestore
0 setgray fill
grestore
stroke
0 161.18 moveto
20.54 161.18 lineto
20.54 174.27 lineto
0 174.27 lineto
0 161.18 lineto
gsave
gsave
stroke
grestore
0 setgray fill
grestore
stroke
0 148.09 moveto
0.00 148.09 lineto
0.00 161.18 lineto
0 161.18 lineto
0 148.09 lineto
gsave
gsave
stroke
grestore
0 setgray fill
grestore
stroke
0 115.36 moveto
0.00 115.36 lineto
0.00 128.45 lineto
0 128.45 lineto
0 115.36 lineto
gsave
gsave
stroke
grestore
0 setgray fill
grestore
stroke
0 95.73 moveto
0.00 95.73 lineto
0.00 108.82 lineto
0 108.82 lineto
0 95.73 lineto
gsave
gsave
stroke
grestore
0 setgray fill
grestore
stroke
0 82.64 moveto
0.00 82.64 lineto
0.00 95.73 lineto
0 95.73 lineto
0 82.64 lineto
gsave
gsave
stroke
grestore
0 setgray fill
grestore
stroke
0 56.45 moveto
0.00 56.45 lineto
0.00 69.55 lineto
0 69.55 lineto
0 56.45 lineto
gsave
gsave
stroke
grestore
0 setgray fill
grestore
stroke
0 17.18 moveto
0.00 17.18 lineto
0.00 30.27 lineto
0 30.27 lineto
0 17.18 lineto
gsave
gsave
stroke
grestore
0 setgray fill
grestore
stroke
0 -15.55 moveto
0.00 -15.55 lineto
0.00 -2.45 lineto
0 -2.45 lineto
0 -15.55 lineto
gsave
gsave
stroke
grestore
0 setgray fill
grestore
stroke
0 -9 translate
0 0 moveto
0 0 lineto
80.82 0 lineto 
stroke
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
% assign font for numbers under taxon x-axis
set_botnum
0 nstr cvs dup stringwidth pop
2 div
0.00 exch sub -11 moveto
show
0.00 -3 moveto
0 6 rlineto
1 nstr cvs dup stringwidth pop
2 div
80.82 exch sub -11 moveto
show
80.82 -3 moveto
0 6 rlineto
% assign font for label under taxon curve
set_botlab
0 11 leading add neg moveto
(                              ) show
0 11 leading 2 mul add neg moveto
(                              ) show
129.31 0 translate
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
(HERBS & SHRUBS) show
9 3 rmoveto
588.55 359.64 lineto
45 rotate
-90 0 rlineto
-45 rotate
stroke
549.55 0 translate
stroke
showpage
