/*
 *  psdraw:  generates PostScript diagram of pollen data as specified  
 *           in instruction file.				    
 */

#include <stdio.h>
#include <math.h>

#define MAXLEV 180
#define MAXTAX 120
#define ML2 360       

FILE	*out;

psdraw_(datum,level,nqlevs,nqtopl,pctgmx,instmx,ibar,bstrng,lbl2,legend,c14colp,strcolp,bigfntp,usrfnt,izone,yqhitep,xwidthp,ystepp,crstepp,abscalp,nstrts,istrat,rstrat,lstrng,title,rep,type,lbl,c14,isotyp,ndatesp,lstrat,depfac,azone,bzone,levlinp,fill,angle,density)
float	*datum,*level,*pctgmx,*yqhitep,*xwidthp,*ystepp,*crstepp;
float	*rstrat,*c14,*depfac,*azone,*bzone,*angle;
int	*nqlevs,*nqtopl,*instmx,*ibar,*c14colp,*strcolp,*bigfntp;
int	*usrfnt,*izone,*abscalp;
int	*nstrts,*ndatesp,*istrat,*rep,*type,*levlinp,*fill,*density;
char	*bstrng,*lbl2,*legend,*lstrng,*title,*lbl,*isotyp,*lstrat;

{
	int	levs,bar;
	int	taxa,ndata;
	int	i,j,b;
	int     c14col,strcol,levlin,bigfnt,exag5x,abscal;
	int	siz,fnt,labelypos;
	int	cur_type;
	int	*llpts,*lrpts;
	int	XLEN,YLEN;

	float   a;
	float	xmax[MAXTAX];
	float	xend,bardep,zonvec; 
	float	xscale,yscale,ylen,xlen,max,x,y,ystop,ystart;
	float	curr5x,last5x,prevy;
	float   sum,xstep,val,ystep,crstep,ymin,ymax,oshift;
	float	ytick,depth,xwidth,yqhite;
	float	zmax,zmin;
	float	*qlevell,*qlevelr,*levell,*levelr,*qlevel;

	char    name1[17],name2[17],name3[17];
	static 	char	*nameary[] = {"","TREES","SHRUBS","HERBS","FERNS","AQUATICS","HERBS & SHRUBS"};
	static 	char	*fontlery[] = {"/Times-Roman","/Times-Italic","/Helvetica","/Helvetica-Oblique","/Palatino-Roman","/Palatino-Italic","/other"};

	c14col = *c14colp;
	strcol = *strcolp;
	bigfnt = *bigfntp;
	ystep  = *ystepp;
	levlin = *levlinp;
	xwidth = *xwidthp;
	yqhite = *yqhitep;
	crstep = *crstepp;
	abscal = *abscalp;

	if ((out = fopen("plot.psc","a")) == NULL) {
		printf("error opening file\n");
		exit(1);
	}

/* assign XLEN and YLEN */
	if ((xwidth >= 2.0) && (xwidth <= 14.0)) {
		XLEN = (int)(xwidth * 72.0);
	} else {
		XLEN = 792;
	}
	if ((yqhite >= 1.0) && (yqhite <= 8.0)) {
		YLEN = (int)(yqhite * 72.0);
	} else {
		YLEN = 396;
	}

/* for (i=0;i<6;i++) { printf ("initial rstrat[%d] = %f\n",i,rstrat[i]);} */

/* assign font sizes, etc., the new way (August 1992) */

	if (bigfnt > 1) { /* define all fonts according to line 21E-Z */
		
		for (i = 0; i < 24; i = i+2) {

			switch (i) {
			case 0: fprintf(out,"/set_title {\n"); break;
			case 2: fprintf(out,"/set_CSZ {\n"); break;
			case 4: fprintf(out,"/set_chrkey {\n"); break;
			case 6: fprintf(out,"/set_chron {\n"); break;
			case 8: fprintf(out,"/set_strat {\n"); break;
			case 10: fprintf(out,"/set_depkey {\n"); break;
			case 12: fprintf(out,"/set_depth {\n"); break;
			case 14: fprintf(out,"/set_taxon {\n"); break;
			case 16: fprintf(out,"/set_botnum {\n"); break;
			case 18: fprintf(out,"/set_botlab {\n"); break;
			case 20: fprintf(out,"/set_taxgrp {\n"); break;
			case 22: fprintf(out,"/set_zonnum {\n"); break;
			}
			/* default value usrfnt[i] = 0 ---> Times-Roman */
			fprintf(out,"\t%s findfont\n",fontlery[usrfnt[i]]);
			/* compromise if any values 21E-Z are left blank */
			if (usrfnt[i+1] == 0) { usrfnt[i+1] = 10; }
			fprintf(out,"\t%d scalefont setfont\n",usrfnt[i+1]);
			fprintf(out,"} def\n");

		}

		/* taxon-italic */
		fprintf(out,"/set_taxon-italic {\n");
		fprintf(out,"\t%s findfont\n",fontlery[usrfnt[14] + 1]);
		fprintf(out,"\t%d scalefont setfont\n",usrfnt[15]);
		fprintf(out,"} def\n");

		/* taxon_group-italic */
		fprintf(out,"/set_taxgrp-italic {\n");
		fprintf(out,"\t%s findfont\n",fontlery[usrfnt[20] + 1]);
		fprintf(out,"\t%d scalefont setfont\n",usrfnt[21]);
		fprintf(out,"} def\n");

		/* label offsets */
		fprintf(out,"/leading %d def\n",usrfnt[9] + 1);
		fprintf(out,"/leading_45 %d def\n",usrfnt[15] + 3);

	} else { /* default font & size assignments */
		
		for (i = 0; i < 24; i = i+2) {

			switch (i) {
			case 0: fprintf(out,"/set_title {\n");
				fnt = 2;   /* Helvetica    */
				siz = 18;
				break;
			case 2: fprintf(out,"/set_CSZ {\n");
				fnt = 0;     /* Times-Roman  */
				siz = 10 + (bigfnt * 5);
				break;
			case 4: fprintf(out,"/set_chrkey {\n");
				fnt = 0;
				siz = 8 + (bigfnt * 4);
				break;
			case 6: fprintf(out,"/set_chron {\n");
				fnt = 0;
				siz = 8 + (bigfnt * 4);
				break;
			case 8: fprintf(out,"/set_strat {\n");
				fnt = 0;
				siz = 8 + (bigfnt * 4);
		/* define size of stratigraphy font labels--important later! */
				usrfnt[9] = siz;
				break;
			case 10: fprintf(out,"/set_depkey {\n");
				 fnt = 2;
				 siz = 8 + (bigfnt * 4);
				 break;
			case 12: fprintf(out,"/set_depth {\n");
				 fnt = 2;
				 siz = 8 + (bigfnt * 4);
				 break;
			case 14: fprintf(out,"/set_taxon {\n");
				 fnt = 0;
				 siz = 12 + (bigfnt * 4);
				 break;
			case 16: fprintf(out,"/set_botnum {\n");
				 fnt = 0;
				 siz = 8 + (bigfnt * 4);
		/* define size of stratigraphy font labels--important later! */
				 usrfnt[17] = siz;
				 break;
			case 18: fprintf(out,"/set_botlab {\n");
				 fnt = 0;
				 siz = 8 + (bigfnt * 4);
				 break;
			case 20: fprintf(out,"/set_taxgrp {\n");
				 fnt = 0;
				 siz = 10 + (bigfnt * 4);
				 break;
			case 22: fprintf(out,"/set_zonnum {\n");
				 fnt = 2;
				 siz = 8 + (bigfnt * 4);
				 break;
			}

			fprintf(out,"\t%s findfont\n",fontlery[fnt]);
			fprintf(out,"\t%d scalefont setfont\n",siz);
			fprintf(out,"} def\n");
		}

		/* taxon-italic */
		fprintf(out,"/set_taxon-italic {\n");
		fprintf(out,"\t%s findfont\n",fontlery[1]);
		fprintf(out,"\t%d scalefont setfont\n",12 + (bigfnt * 4));
		fprintf(out,"} def\n");

		/* taxon_group-italic */
		fprintf(out,"/set_taxgrp-italic {\n");
		fprintf(out,"\t%s findfont\n",fontlery[1]);
		fprintf(out,"\t%d scalefont setfont\n",10 + (bigfnt * 4));
		fprintf(out,"} def\n");

		/* label offsets */
		fprintf(out,"/leading %d def\n",8 + (bigfnt * 4) + 1);
		fprintf(out,"/leading_45 %d def\n",12 + (bigfnt * 4) + 2);

	}

	fprintf (out,"/nstr 7 string def\n");
	fprintf (out,"/lstr 30 string def\n");
	fprintf (out,"0 setlinewidth\n");

/* set up page....	*/
	fprintf (out,"90 rotate\n");		
	fprintf (out,"72 -540 translate\n");
	if (strcol == 2) {
		fprintf (out,"0 18 translate\n"); }

/* print title at top	*/
	fprintf (out,"0 %d moveto\n",(YLEN + 108 - strcol*12));
	fprintf (out,"set_title (%s) show\n",title);

/* figure out max xlength and then ssccccale accordingly	*/
	
	xlen = 3.0;
 	
	levs = *nqlevs; 	
	taxa = *nqtopl;
	if (ibar[0] == 2) {
		qlevell = (float *)calloc(taxa*ML2,sizeof(float));	
		qlevelr = (float *)calloc(taxa*ML2,sizeof(float));	
		levell = (float *)calloc(taxa*ML2,sizeof(float));	
		levelr = (float *)calloc(taxa*ML2,sizeof(float));	
		llpts = (int *) calloc(taxa,sizeof(int));
		lrpts = (int *) calloc(taxa,sizeof(int));
		xlen += 2.0;
	}

	ndata = 0;
	sum = 0;
	for (i=0;i<taxa; i++) {
		if (pctgmx[i] <= 0) {
			for (j=1;j<levs;j++) {
				if (datum[MAXLEV*i + j] > 0) {
					sum += datum[MAXLEV*i +j];
					++ ndata;
				}
			}
		}
		if (instmx[MAXTAX*10 +i] <= 0) {
			instmx[MAXTAX*10 +i] = 4;
		}
	}
	if (ndata == 0) {ndata = 1;}
	y = 1.3*(sum/ndata);
	grstep_(&y,&val);
	xstep = val;

	/* determine relative sizes of chronology and stratigraphy columns */
	x = 0;
	if ((strcol > 0) && (c14col > 0)) {
		xlen += 2.0;
		x += 0.5;
		if (strcol == 1) {
			xlen += 1.0;
			x += 0.5;	}
		if (c14col == 1) {
			xlen += 0.5;	}
	} else if (strcol > 0) {
		xlen += (3.5 - 1.5*(float)strcol);
	} else if (c14col > 0) {
		xlen += (2.0 - 0.5*(float)c14col);
	}
	if (izone[1] != 0) {
		xlen += 1.5;
	}

	for (i=0; i<taxa; i++) {
		max = 0;
		if (instmx[MAXTAX*9 + i] > 0) {
			smooth_(datum,&i);
		}
		for (j=0;j<levs;j++) {
			max = (datum[(MAXLEV*i + j)] < max) ? max:      
				datum[(MAXLEV*i + j)];
		}
		if (pctgmx[i] <= 0) {
			pctgmx[i] = xstep;
		}
		max = (max < pctgmx[i]) ? pctgmx[i]: max;
		xmax[i] = max/pctgmx[i];
		xlen += (max/pctgmx[i]) + 0.6;		
	}

	bardep = 0.0;

	ylen =  level[levs-1] - level[0];
	yscale = (float)YLEN/ylen;
/*
printf ("YLEN = %d   ylen = %f   yscale = %f\n",YLEN,ylen,yscale);
*/
	if (ibar[0] == 3) { bar = 2;}
	for (i=0;i<(levs-1);i++) {
		bardep = ((abs(level[i+1]-level[i])<bardep)?(level[i+1]-level[i]):bardep);
	}
	if ((bardep =(bardep*(-yscale) + 2.0))> 20.0) {
		bardep = 18.0;
	} else {
		bardep = bardep*(-yscale) ;		
	}
	if (bardep < 4.0) {bardep = 4.0;}
	
	if (abscal > 0) {
		xscale = (float)abscal;
	} else {
		xscale = ((float)XLEN-x*72.0)/xlen;
	}
/*
printf ("XLEN = %d   xlen = %f   x = %f   xscale = %f\n",XLEN,xlen,x,xscale);
*/

/* draw C14 column	*/

	if (c14col > 0) {
		draw_c14(xscale,yscale,XLEN,YLEN,legend,c14col,strcol,crstep,c14,isotyp,ndatesp,level[0]);
	}

/* draw stratigraphy column	*/

	if (strcol > 0) {
		draw_strat(xscale,yscale,XLEN,YLEN,strcol,c14col,nstrts,istrat,rstrat,lstrat,level[0],usrfnt[9]);
	}

/* put in original scale, for left of plot or zone box	*/

	/* print label along axis	*/
	fprintf(out,"%% assign font for vertical label \(e.g. Depth\)\n");
	fprintf(out,"set_depkey\n");
	fprintf (out,"\(%c",lstrng[0]);
	for (i=1; i<30; i++) {
		if ((lstrng[i] != ' ') || (lstrng[i-1] != ' ')) {
			fprintf (out,"%c",lstrng[i]);
		} else { break; }
	}
	fprintf (out,"\)\n");
	fprintf (out,"dup stringwidth pop 2 div -1 mul %.1f add -24 exch moveto\n",(float)YLEN/2);
	fprintf (out,"90 rotate\n");
	fprintf (out,"show\n");
	fprintf (out,"-90 rotate\n");

	fprintf(out,"%% assign font for numbers on vertical axis\n");
	fprintf(out,"set_depth\n");

	if (ystep <= 0.0) { 
		y = ylen/10;
		grstep_(&y,&val);
		ystep = val;
		ystep = -ystep;
	}
	y = (float)YLEN;
	ymin = -level[0];
	ymax = -level[levs-1];
	depth = -ymax - ymin;
	fprintf(out,"0 0 moveto\n");
	fprintf(out,"0 %.2f lineto\n",y);
	ytick = (ystep/10)*yscale;
 	for(y = ymin; y <= ymax; y += ystep) {
		fprintf(out,"0 %.2f moveto\n",((float)YLEN + y*yscale)-(yscale*ymin));
		if (((float)YLEN+y*yscale-yscale*ymin+10*ytick) < 0.0) {
			for (x=0;x<10;x++) {
				if ((float)YLEN+y*yscale-yscale*ymin+(x+1)*ytick < 0.0) 
					{ break; }
				fprintf(out,"0 %.2f rmoveto\n",ytick);
				fprintf(out,"-3 0 rmoveto \n");
				fprintf(out,"3 0 rlineto\n");
			}
		} else {
			fprintf(out,"1 1 10 {\n");
			fprintf(out,"0 %.2f rmoveto\n",ytick);
			fprintf(out,"-3 0 rmoveto \n");
			fprintf(out,"3 0 rlineto\n");
			fprintf(out,"} for\n");	
		}

		fprintf(out,"0 %.2f moveto\n",((float)YLEN + y*yscale)-(ymin*yscale));
		fprintf(out,"%.0f nstr cvs dup stringwidth pop\n",y);
		fprintf(out," 5 add -1 mul -3 rmoveto\n");
		fprintf(out,"show\n");
	}
	fprintf(out,"stroke\n");

/* draw zone box if needed	*/

	if (*izone != 0) {
		y = (float)YLEN;
		fprintf(out,"0 0 moveto\n");
		/* fixed width of 13.5 points (= 3/16")		*/
		fprintf(out,"13.5 0 lineto\n");
		fprintf(out,"0 %.2f rlineto\n",y);
		fprintf(out,"-13.5 0 rlineto\n");
		fprintf(out,"stroke\n");
		y += 8.0;
		fprintf(out,"3.5 %.2f moveto\n",y);
		fprintf(out,"45 rotate\n");
		fprintf(out,"set_CSZ\n");
		fprintf(out,"(ZONATION) show\n");
		fprintf(out,"-45 rotate\n");
		fprintf(out,"gsave\n");
		fprintf(out,"%.2f 0 translate\n",(.8*xscale));
		
	}
	zonvec = .8*xscale;


/* central taxon graphing loop	*/

	fprintf(out,"gsave\n");

	oshift = 0.0;

	for (i=0; i< taxa; i++) {
		
		fprintf(out,"0 0 moveto\n");
		y = (float)YLEN;
		fprintf(out,"0 %.2f lineto\n",y);

		if ((ibar[i] == 0) || (ibar[i] == 2)) {

/* do sawtooth graph		*/

			exag5x = instmx[MAXTAX*7 + i];
			for (j = 0;j<levs;j++) {
				x = xscale*(datum[MAXLEV*i+j]/pctgmx[i]);
				y = (float)YLEN + ((level[0]-level[j]) * yscale);
				fprintf(out,"%.2f %.2f lineto\n",x,y);
				fprintf(out,"gsave\n");

				if (exag5x == 1) {
 				/* 5x exaggeration curve */
				  curr5x = 5.0 * x;

				  if (j > 0) {
				    if (last5x <= ((xmax[i]+0.6)*xscale) ) {
				      fprintf(out,"newpath\n");
				      fprintf(out,"%.2f %.2f moveto\n",last5x,prevy);
				      if (curr5x <= ((xmax[i]+0.6)*xscale) ) {
					fprintf(out,"%.2f %.2f lineto\n",curr5x,y);
				      } else {
					/* lineto y position where x ==
					   the next taxon curve's y-axis */
					ystop = y + 
					 ( ( (curr5x - ((xmax[i]+0.6)*xscale) )/
					     (curr5x - last5x) ) *
					     (prevy - y) );
					fprintf(out,"%.2f %.2f lineto\n",((xmax[i]+0.6)*xscale),ystop);
				      }
				    } else if (curr5x < ((xmax[i]+0.6)*xscale)) {
				      fprintf(out,"newpath\n");
				      /* moveto y position where x ==
				         the next taxon curve's y-axis */
				      ystart = y + 
					 ( ( (curr5x - ((xmax[i]+0.6)*xscale) )/
					     (curr5x - last5x) ) *
					     (prevy - y) );
				      fprintf(out,"%.2f %.2f moveto\n",((xmax[i]+0.6)*xscale),ystart);
				      fprintf(out,"%.2f %.2f lineto\n",curr5x,y);
				    } /* if both last5x & curr5x > next y axis,
					no line segment will be drawn */

				  } else { /* j = 0 */
				    fprintf(out,"0 %.2f moveto\n",y);
				    if (curr5x <= ((xmax[i]+0.6)*xscale) ) {
				      fprintf(out,"%.2f %.2f lineto\n",curr5x,y);
				    } else {
				      fprintf(out,"%.2f %.2f lineto\n",((xmax[i]+0.6)*xscale),y);
				    }
				  }

				  if (levlin == 1) {	
				  /* dotted lines */
				    if (curr5x < ((xmax[i]+0.6)*xscale)) {
				    /* don't draw if 5x exag > next y axis! */
					fprintf(out,"stroke\n");
					fprintf(out,"[2] 0 setdash\n");
					fprintf(out,"newpath\n");
					fprintf(out,"%.2f %.2f moveto\n",curr5x,y);
					fprintf(out,"%.2f %.2f lineto\n",(xmax[i]+.6)*xscale,y);
				    }
				  }

				last5x = 5 * x;
				prevy = y;

				} else if (levlin == 1) {
				/* dotted lines, no exaggeration curve */	
					fprintf(out,"[2] 0 setdash\n");
					fprintf(out,"newpath\n");
					fprintf(out,"%.2f %.2f moveto\n",x,y);
					fprintf(out,"%.2f %.2f lineto\n",(xmax[i]+.6)*xscale,y);
				}	
				fprintf(out,"stroke\ngrestore\n");
			}
			fprintf(out,"0 0 lineto\n");
			fprintf(out,"%.2f 0 lineto \n",((xmax[i])*xscale));

		} else if (ibar[i] == 1) {
/* do bar graph	*/
/* will do autoscaled barwidth; none of this user defined shit	*/
			fprintf(out,"0 9 translate\n");	
			for (j = 0;j<levs;j++) {
				x = xscale*(datum[MAXLEV*i+j]/pctgmx[i]);
/* printf("count = %.2f , scaled x = %.2f\n",datum[MAXLEV*i+j],x); */
				y = (float)YLEN-(level[j]*yscale)+level[0]*yscale - 9.0;
				fprintf(out,"0 %.2f moveto\n",y-bardep/2);
				fprintf(out,"%.2f %.2f lineto\n",x,y-bardep/2);
				fprintf(out,"%.2f %.2f lineto\n",x,y+bardep/2);
				fprintf(out,"0 %.2f lineto\n",y+bardep/2);
				fprintf(out,"0 %.2f lineto\n",y-bardep/2);
				fprintf(out,"gsave\n");
				fprintf(out,"gsave\n");
				if (levlin == 1) {	
					fprintf(out,"[2] 0 setdash\n");
					fprintf(out,"newpath\n");
					fprintf(out,"%.2f %.2f moveto\n",x,y);
					fprintf(out,"%.2f %.2f lineto\n",(xmax[i]+.6)*xscale,y);
				}	
				fprintf(out,"stroke\ngrestore\n");
				fprintf(out,"0 setgray fill\n");
				fprintf(out,"grestore\n");
				fprintf(out,"stroke\n");
			}
				
			fprintf(out,"0 -9 translate\n");
			fprintf(out,"0 0 moveto\n");
			fprintf(out,"0 0 lineto\n");
			fprintf(out,"%.2f 0 lineto \n",((xmax[i])*xscale));
			fprintf(out,"stroke\n");

		} else if (ibar[i] == 4) {
/* do crosses ("+") on levels where taxon is present	*/
			for (j = 0;j<levs;j++) {
				/* no need to define x--yes or no, that's all */
				y = (float)YLEN + ((level[0]-level[j]) * yscale);

				if ( (datum[MAXLEV*i+j]/pctgmx[i]) > 0 ) {
					fprintf(out,"1 %.2f moveto\n",y);
					fprintf(out,"11 %.2f lineto\n",y);
					fprintf(out,"6 %.2f moveto\n",y-5.0);
					fprintf(out,"6 %.2f lineto\n",y+5.0);
					x = 13.0;
				} else { x = 0.0;
				}
				if (levlin == 1) {	
					fprintf(out,"[2] 0 setdash\n");
					fprintf(out,"newpath\n");
					fprintf(out,"%.2f %.2f moveto\n",x,y);
					fprintf(out,"%.2f %.2f lineto\n",(xmax[i]+.6)*xscale,y);
				}	
				fprintf(out,"stroke\ngrestore\n");
			}
			fprintf(out,"0 0 moveto\n");
			fprintf(out,"%.2f 0 lineto \n",((xmax[i])*xscale));
		}

/* print name above taxon			*/
		j = i+1;
		getname_(name1,name2,name3,instmx,&j);
		y = (float)YLEN + 8.0;

		if ((ibar[i] == 2) || (ibar[i-1] == 2)) {
			/* if overlay, shift each label over taxon */
			/* this is lame...... */
			fprintf (out,"%.2f %.0f moveto\n",((xmax[i]*xscale)*0.667),y);
		} else {
			if (i==0) { /* first taxon; leave room */
				fprintf (out,"8 leading_45 14 sub add %.0f moveto\n",y);
				labelypos = 8;
			} else { 
				fprintf (out,"5 %.0f moveto\n",y);
				labelypos = 5;
			}
		}

		fprintf(out,"45 rotate\n");
		fprintf(out,"%% assign font for taxon name\n");
		name1[16] = '\0';
		if (name1[0] == '\*') { /* italics requested */
			fprintf(out,"set_taxon-italic\n");
			for (j=0;j<16;j++) {
				name1[j] = name1[j+1];
				if (name1[j] == '#'){
					name1[j] = ' ';	
				}
			}		
		} else {
			fprintf(out,"set_taxon\n");
		} 
		fprintf(out,"(%s) show\n",name1);
		fprintf(out,"-45 rotate\n");
		fprintf(out,"%d leading_45 add %.0f moveto\n",labelypos,y);  
		fprintf(out,"45 rotate\n");

		name2[16] = '\0';
		if (name2[0] == '\*') {
			fprintf(out,"set_taxon-italic\n");
			for (j=0;j<16;j++) {
				name2[j] = name2[j+1];
				if (name2[j] == '#') name2[j] = ' ';	
			}		
		} else {
			fprintf(out,"set_taxon\n");
		}
		fprintf(out,"(%s) show\n",name2);
		fprintf(out,"-45 rotate\n");

		fprintf(out,"%d 2 leading_45 mul add %.0f moveto\n",labelypos,y);  

		fprintf(out,"45 rotate\n");
		name3[16] = '\0';
		if (name3[0] == '\*') {
			fprintf(out,"set_taxon-italic\n");
			for (j=0;j<16;j++) {
				name3[j] = name3[j+1];
				if (name3[j] == '#') name3[j] = ' ';	
			}		
		} else {
			fprintf(out,"set_taxon\n");
		}
		fprintf(out,"(%s) show\n",name3);
		fprintf(out,"-45 rotate\n");

/* shade with fill pattern	*/
		if ((ibar[i] == 0) || (ibar[i] == 2)) {
			a = angle[i];
			b = density[i];
			dofill(xmax,xscale,YLEN,i,name1,fill,a,b);
		}

/* axis numbering and tick marks	*/
		fprintf(out,"%% assign font for numbers under taxon x-axis\n");
		fprintf(out,"set_botnum\n");
	
		j = 0;
		if (ibar[0] == 3) { /* sawtooth around mean */
			for (j = 0;j<=xmax[i];j++) {
				x = xscale * (float)j;
				fprintf(out,"%d nstr cvs dup stringwidth pop\n",j);
				fprintf(out,"2 div\n");
				fprintf(out,"%.2f exch sub -12 moveto\n",x); 
				fprintf(out,"show\n");
				fprintf(out,"%.2f -3 moveto\n",x);
				fprintf(out,"0 6 rlineto\n");
				fprintf(out,"%d nstr cvs dup stringwidth pop\n",j);
				fprintf(out,"2 div\n");
				fprintf(out,"-%.2f exch sub  -12 moveto\n",x); 
				fprintf(out,"show\n");
				fprintf(out,"-%.2f -3 moveto\n",x);
				fprintf(out,"0 6 rlineto\n");
			}
		} else {	
			while ((pctgmx[i]*j) <= xmax[i]*pctgmx[i]) {
				x = xscale * (float)j;
				fprintf(out,"%.0f nstr cvs dup stringwidth pop\n",(pctgmx[i] * (float)j));
				fprintf(out,"2 div\n");
				fprintf(out,"%.2f exch sub -%d moveto\n",x,usrfnt[17] + 3); 
				fprintf(out,"show\n");
				fprintf(out,"%.2f -3 moveto\n",x);
				fprintf(out,"0 6 rlineto\n");
				++ j;
			}
		}	

/* label underneath graph	*/
		fprintf(out,"%% assign font for label under taxon curve\n");
		fprintf(out,"set_botlab\n");
		bstrng[i*30 +29] = '\0';
		lbl2[i*30 +29] = '\0';
		fprintf(out,"0 11 leading add neg moveto\n");
		fprintf(out,"(%30s) show\n",bstrng+(i*30));
		fprintf(out,"0 11 leading 2 mul add neg moveto\n");
		fprintf(out,"(%30s) show\n",lbl2+(i*30));

/* shift origin if no overlay requested */
		if (ibar[i] != 2) {
			if ((i == 0) || (ibar[i-1] != 2)) {
				fprintf(out,"%.2f 0 translate\n",((xmax[i])*xscale+(.6*xscale)));
				zonvec += (xmax[i]+.6)*xscale;
			} else {
				fprintf(out,"%.2f 0 translate\n",oshift);
				zonvec += oshift;
				oshift = 0.0;
			}
		} else {
			if (oshift == 0.0) {
				oshift = (xmax[i] + .6) * xscale;
			}
		}
				
		fprintf(out,"stroke\n");

	} /* end of central taxon graphing loop	*/

/* now do labels above - icky	*/
	fprintf(out,"grestore\n");

	y = (float)YLEN + 8;

	fprintf(out,"%% assign font for taxon group labels\n");
	fprintf(out,"set_taxgrp\n");

	xend = 0.0;
	cur_type = -1;
	for (i = 0; i < taxa; i++) {
		/* sawtooth around mean ==> double the apparent width
		if (ibar[0] == 3) { xmax[i] *= 2;} */
		if ((rep[i] == 1) || (i == (taxa-1))) {    /* new label */
			if (xend != 0.0) {
			    if (cur_type !=0) {
				y = (float)YLEN + 8;
				fprintf(out,"-7 %.2f moveto\n",y);
				fprintf(out,"45 rotate\n");
				fprintf(out,"90 0 rlineto\n");
				fprintf(out,"-45 rotate\n");
				fprintf(out,"9 0 rlineto\n");
				fprintf(out,"9 -3 rmoveto\n");
				fprintf(out,"(%s) show\n",nameary[cur_type]);
				fprintf(out,"9 3 rmoveto\n");
				y = y+sqrt(4050.0);
				if (i == (taxa-1)) {
					xend += (xmax[i]+.6)*xscale;
				}
				fprintf(out,"%.2f %.2f lineto\n",xend + 39.0,y);
				fprintf(out,"45 rotate\n");
				fprintf(out,"-90 0 rlineto\n");
				fprintf(out,"-45 rotate\n");	
				fprintf(out,"stroke\n");
			    }
			    fprintf(out,"%.2f 0 translate\n",xend); 
			    xend = 0.0;
			}
			cur_type = type[i];
		} 
		if ((i == 0) || (ibar[i-1] != 2)) { /* this is not an overlay */
			xend += (xmax[i] +.6)*xscale;
		}
	}

/* draw zones in, if requested, and (someday) dendrogram, etccc. 	*/

	if (*izone != 0) {
		fprintf (out,"grestore\n"); 
		ymin = ymin;
		dendro_(&levs,&ymax,&ymin,&depth,&yqhite,depfac,&zonvec,izone,azone,bzone,level,qlevel,&xscale,&yscale);
		ymin = ymin;
	}
			              
	fprintf (out,"stroke\n");
	fprintf (out,"showpage\n");
	fclose ( out );
}
	
/* draw chronology column, if requested		*/

draw_c14(xscale,yscale,xdim,ydim,legend,c14col,strcol,crstep,c14,isotyp,ndatesp,ymin)
float	xscale,yscale,crstep,*c14,ymin;
int	xdim,ydim,c14col,strcol,*ndatesp;
char	*legend,*isotyp;
{
	float 	x,y;
	int 	ndates,i,j,count;
	char	str[8];
	float	interval,date1,date2,depth1,depth2,tick_dist;
	float	leftover, leftover_dist,curr_depth,curr_date;

	ndates = *ndatesp;

	fprintf(out,"set_CSZ\n");

	fprintf(out,"%.2f 0 translate\n",((1 - (float)c14col*0.25) * xscale));	
	y = (float)ydim;
	/* fixed width of 9 points (= 1/8") */
	fprintf(out,"0 0 moveto\n");
	fprintf(out,"0 %.2f rlineto\n",y);
	fprintf(out,"9 0 rlineto\n");
	fprintf(out,"0 -%.2f rlineto\n",y);
	fprintf(out,"-9 0 rlineto\n");
	fprintf(out,"stroke\n");

	y += 8.0;
	fprintf(out,"5 %.0f moveto\n",y);
	fprintf(out,"45 rotate\n");
	fprintf(out,"(CHRONOLOGY) show\n");
	fprintf(out,"-45 rotate\n");

	fprintf(out,"%% assign font for chronology key or legend\n");
	fprintf(out,"set_chrkey\n");

	if (strcol == 0) {
		fprintf(out,"leading_45 %.0f moveto\n",y);
		fprintf(out,"45 rotate\n");
		fprintf(out,"(%30s) show\n",legend);
		fprintf(out,"-45 rotate\n");
	} else {
		fprintf(out,"-36 -24 moveto\n");
		fprintf(out,"(%30s) show\n",legend);
	}

	fprintf(out,"%% assign font for chronology labels or numbers\n");
	fprintf(out,"set_chron\n");

	if (c14col == 2) {
	/* figure out interval for tick marks	*/

		if (crstep > 0.0) {
			interval = crstep;
		} else {
			interval = c14[80 + ndates-1]/50.0;
			if (interval >= 100.0) {
				interval = (float) ((int)(interval/100.0)*100);
			} else if (interval >= 10.0) {
				interval = (float) ((int)(interval/10.0)*10);
			} else {
				printf("chron interval too small; I'm setting it to 5\n");
				interval = 5.0;
			}
		}
	
		/* draw tick marks	*/
		count = 0;
		date1 = 0.0;	
		depth1 = 0.0;
		x = 0.0;
		leftover = 0.0;
		for (i = 0; i< ndates; i++ ) {
			date2= c14[80+i];
			depth2 = c14[i];
			tick_dist = (interval*(depth2 - depth1))/(date2 - date1);
			if (leftover != 0.0) {	
				leftover_dist = (leftover*tick_dist)/interval;
			} else {
				leftover_dist = 0.0;
			}
			curr_depth = depth1 + leftover_dist; 
			curr_date = date1 + leftover;
			while (curr_date < date2) {
				y = (float)ydim - (curr_depth - ymin)*yscale;
				fprintf(out,"%.2f %.2f moveto\n",x,y);
				fprintf(out,"-3 0 rmoveto\n");
				fprintf(out,"3 0 rlineto\n");
				if (((int)(((float)(count))/5.0)) == 
					(((float)(count))/5.0)) {
					fprintf(out,"(%d)\n",(int)(count*interval));	
					fprintf(out,"lstr cvs dup stringwidth pop\n");
					fprintf(out,"8 add -1 mul %.2f 4.0 sub moveto\n",y);
					fprintf(out,"show\n"); 
				}
				++count;
				curr_date += interval;
				curr_depth += tick_dist;
			}
			curr_date -= interval;
			date1 = date2;
			depth1 = depth2;
			leftover = interval - (date2 - curr_date); 
		}
	} /* (c14col == 2)	*/

/* fill in each date, and label according to material used	*/
	for (i = 0;i < ndates; i++) {
		x = 9.0;
		y = (float)ydim - (c14[i] + c14[40+i]/2 - ymin)*yscale;
		if (y > (float)ydim) {
			y = (float)ydim;}
		fprintf(out,"0 %.2f moveto\n",y);	
		fprintf(out,"%.0f %.2f lineto\n",x,y);
		y = (float)ydim - (c14[i] - c14[40+i]/2 - ymin)*yscale;
		fprintf(out,"%.0f %.2f lineto\n",x,y);
		fprintf(out,"0 %.2f lineto\n",y);
		fprintf(out,"closepath \n");
		fprintf(out,"0 setgray\n");
		fprintf(out,"fill\n");
		
		if (c14col == 1) {
			for (j=0;j<8;j++) {
				if (isotyp[i*8 + j] == ' ') {
					str[j] = '\0';
					break;
				}
				str[j] = isotyp[i*8 +j];
			}

			y = ((float)ydim-c14[i]*yscale)-3+ymin*yscale;
			fprintf(out,"(%s: %.0f +/- %.0f)\n",str,c14[80+i],c14[120+i]);
			fprintf(out,"lstr cvs dup stringwidth pop\n");
			fprintf(out,"5 add -1 mul %.2f moveto\n",y);
			fprintf(out,"show\n");
		}
	}

	if (strcol ==  0) {
		fprintf(out,"%.2f 0 translate\n",(1.75*xscale));
	}
}

/* 
 * draw_strat: draw stratigraphy column, if requested
 */	

draw_strat(xscale,yscale,xdim,ydim,strcol,c14col,nstrts,istrat,rstrat,lstrat,ymin,stratsiz)
float	xscale,yscale,*rstrat,ymin;
int	xdim,ydim,strcol,c14col,*nstrts,*istrat,stratsiz;
char	*lstrat;
{
	float	x,y,yval[13],gray;
	int	str_levs,i,j;
	int	igray;
	float	xval[13]; 
	float   yjag[13]; 
	float	ylast[13];

/*
for (i=0;i<6 ;i++){
	printf ("depth of strat bndry = %f\n",rstrat[i]);
}
for (i=0;i<4 ;i++){
  for (j=0;j<6;j++) {
	printf ("istrat = %d subscript = %d\n",istrat[40*i + j],(40*i + j));
  }
}
*/

	for(i=0;i<13;i++) {
		ylast[i] = 0.0;
	}

	xval[0] = 0.0; 	
	xval[1] = 0.17; 	
	xval[2] = 0.21;	
	xval[3] = 0.28;
	xval[4] = 0.29;	
	xval[5] = 0.37;	
	xval[6] = 0.47;	
	xval[7] = 0.5;	
	xval[8] = 0.57;	
	xval[9] = 0.65;	
	xval[10] = 0.69;	
	xval[11] = 0.77;	
	xval[12] = 0.8;	

	yjag[0] = -1; 	
	yjag[1] = 1; 	
	yjag[2] = -1;	
	yjag[3] = 1;
	yjag[4] = -1;	
	yjag[5] = 1;	
	yjag[6] = -1;	
	yjag[7] = 1;	
	yjag[8] = -1;	
	yjag[9] = 1;	
	yjag[10] = -1;	
	yjag[11] = 1;	
	yjag[12] = -1;	

	str_levs = *nstrts;

	if (c14col > 0) {
		fprintf(out,"9 0 translate\n");
	}
	y = (float)ydim;
	x = .8*xscale;
	fprintf(out,"0 0 moveto\n");
	fprintf(out,"0 %.2f rlineto\n",y);
	fprintf(out,"%.2f 0 rlineto\n",x);
	fprintf(out,"0 -%.2f rlineto\n",y);
	fprintf(out,"-%.2f 0 rlineto\n",x);
	fprintf(out,"stroke\n");

	fprintf(out,"gsave\n");
	y += 8.0;
	fprintf(out,"14 %.2f moveto\n",y);
	fprintf(out,"45 rotate\n");
	fprintf(out,"set_CSZ\n");
	fprintf(out,"(STRATIGRAPHY) show\n");
	fprintf(out,"-45 rotate\n");

	for(i = 0;i<13;i++) {
		xval[i] *= xscale;
	}

/* draw stratigraphy box for each level	*/
	for (i = 0;i<str_levs;i++) {
		x = .8 * xscale + 3.0;

		y = (float)ydim - (rstrat[i]-ymin)*yscale;
		y  = (y+ylast[0])/2.0; /*position label halfway up current box*/

		/* printf("strat level %d; y = %.2f\n",i,y); */
		
		if (strcol == 1) { /* labels go next to stratigraphy column */
		
			fprintf(out,"%% assign font for stratigraphy labels\n");
			fprintf(out,"set_strat\n");
			fprintf(out,"%.2f %.2f leading add moveto\n",x,y);
			fprintf(out,"\(");
			for(j=0;j<12;j++){
				fprintf(out,"%c",lstrat[12*i+j]);
			}
			fprintf(out,"\) show\n");
			fprintf(out,"%.2f %.2f moveto\n",x,y);
			fprintf(out,"\(");
			for(j=0;j<12;j++){
				fprintf(out,"%c",lstrat[480+12*i+j]);
			}
			fprintf(out,"\) show\n");
			fprintf(out,"%.2f %.2f leading sub moveto\n",x,y);
			fprintf(out,"\(");
			for(j=0;j<12;j++){
				fprintf(out,"%c",lstrat[2*480+12*i+j]);
			}
			fprintf(out,"\) show\n");
		}

		fprintf(out,"newpath\n");
		fprintf(out,"0 %.2f moveto\n",ylast[0]);
		if (istrat[i] == 1) {
			fprintf(out,"[2] 0 setdash\n");
		}
		for (j=0;j<13;j++) {
			yval[j] = (float)ydim - (rstrat[i]-ymin)*yscale;
			if (istrat[i] == 3) {
				yval[j] = yval[j] + yjag[j];
			} else if (istrat[i] == 4) {
				yval[j] = yval[j] + yjag[j] - 2;
			}
			fprintf(out,"%.2f %.2f lineto\n",xval[j],yval[j]);
		}
		for (j=12;j>= 0;j--) {
			fprintf(out,"%.2f %.2f lineto\n",xval[j],ylast[j]);
			ylast[j] = yval[j];
		}
		fprintf(out,"gsave\n");

/* get fill for that level	*/
/*printf ("fill %d for level %d\n",istrat[40+i],i);*/

		igray = istrat[40+i];
		if ((igray >=0) && (igray < 10)) {
			fprintf(out,"0.%d setgray\n",igray);
		} else if (igray == 10) {
			fprintf(out,"1 setgray\n");
		} else if (igray == 13) {
			fprintf(out,"pat2 8 1 0 72 300 32 div div setpattern\n");
		} else if ((igray <= 20) && (igray > 0)) {
			switch (igray) {
			case 12: fprintf(out,"brix ");
				break;
			case 14: fprintf(out,"rox ");
				break;
			case 15: fprintf(out,"csand ");
				break;
			case 16: fprintf(out,"msand ");
				break;
			case 17: fprintf(out,"silt ");
				break;
			case 18: fprintf(out,"fsilt ");
				break;
			case 19: fprintf(out,"flour ");
				break;
			case 20: fprintf(out,"mystery ");
				break;
			}
			fprintf (out,"16 2 0 72 300 32 div div setpattern\n");
		} else { /* pattern out of bounds in .instrs file	*/
			printf ("level %d : pattern %d out of bounds in .instrs file\n",i+1,igray);
			fprintf (out,"1 setgray\n");
		}
		fprintf(out,"fill\n");
		fprintf(out,"grestore\n");
		
		fprintf(out,"[] 0 setdash\n");
		if (istrat[i] > 0) {
			fprintf(out,"stroke\n");	
		}
		if (istrat[i] == 4) {
			fprintf(out,"%.2f %.2f moveto\n",xval[12],(float)ydim -yval[12]+2);
			for(j=12;j>=0;j--) {
				fprintf(out,"%.2f %.2f lineto\n",xval[j],(float)ydim -yval[j]+2);
				ylast[j] = yval[j] +2;
			}
			fprintf(out,"stroke\n");
		}
	}	

	if (strcol == 2) {
		str_key(nstrts,istrat,lstrat,xdim);
	}

	y = (float)ydim;
	fprintf(out,"0 0 moveto\n");
	fprintf(out,"0 %.2f lineto\n",y);
	fprintf(out,"stroke\n");
	fprintf(out,"grestore\n");
	if (stratsiz > 8) {
		x = 2.25 * xscale;
	} else { x = 1.75 * xscale; }
	if (strcol == 1) {
		x += (float)stratsiz * 6.0;}
	fprintf(out,"%.2f 0 translate\n",x);
}

/*	str_key: draw and label stratigraphy boxes below diagram	*/

str_key(nstrts,istrat,lstrat,xdim)
int	*nstrts,*istrat,xdim;
char	*lstrat;
{
	int	str_levs,i,j,k,npatts,boxct,patt_used,newchk;
	int	pattern[40];
	float	xkey;

	str_levs = *nstrts;

	for (i=0;i<str_levs;i++) {
		pattern[i] = istrat[40+i]; }

	npatts = 0;
	for (j=0;j<=20;j++) {
		for (k=0;k<str_levs;k++) {
			if (pattern[k] == j) {
				npatts += 1;
				break;
			}
		}
	}

	/* each box-label combination is 100 points wide--center them */
	xkey = (float)(xdim/2 - (100 * npatts / 2));
	fprintf (out,"%.2f -60 translate\n",xkey-72);

	boxct = 0;
	for (i=0;i<str_levs;i++) {

		/*if i is a new pattern, draw it; otherwise, next i */
		patt_used = 0;
		for (newchk = 0; newchk < i; newchk ++) {
			if (pattern[newchk] == pattern[i]) {
				patt_used = 1;}
		}
		if (patt_used != 1) {

			/*draw box */
			fprintf (out,"newpath\n");
			fprintf (out,"%d 0 moveto\n",100*boxct);
			fprintf (out,"%d 22 lineto\n",100*boxct);
			fprintf (out,"%d 22 lineto\n",(100*boxct)+27);
			fprintf (out,"%d 0 lineto\n",(100*boxct)+27);
			fprintf (out,"%d 0 lineto\n",100*boxct);
			fprintf (out,"gsave\n");
			/* fprintf (out,"stroke\ngrestore\n"); */

			/*fill box */
			if ((pattern[i] >=0) && (pattern[i] < 10)) {
				fprintf(out,"0.%d setgray\n",pattern[i]);
			} else if (pattern[i] == 10) {
				fprintf(out,"1 setgray\n");
			} else if (pattern[i] == 13) {
				fprintf(out,"pat2 8 1 0 72 300 32 div div setpattern\n");
			} else if ((pattern[i] <= 20) && (pattern[i] > 0)) {
				switch (pattern[i]) {
					case 11: fprintf(out,"brix ");
					break;
					case 12: fprintf(out,"brix ");
					break;
					case 14: fprintf(out,"rox ");
					break;
					case 15: fprintf(out,"csand ");
					break;
					case 16: fprintf(out,"msand ");
					break;
					case 17: fprintf(out,"silt ");
					break;
					case 18: fprintf(out,"fsilt ");
					break;
					case 19: fprintf(out,"flour ");
					break;
					case 20: fprintf(out,"mystery ");
					break;
				}
				fprintf (out,"16 2 0 72 300 32 div div setpattern\n");
			} else { /* pattern out of bounds in .instrs file */
				fprintf(out,"0 setgray\n");
			}
			fprintf(out,"fill\n");
			fprintf(out,"grestore\n");

			fprintf(out,"[] 0 setdash stroke\n");

			/*label*/
			fprintf(out,"%% assign font for stratigraphy labels\n");
			fprintf(out,"set_strat\n");
			fprintf(out,"%d 8 leading add moveto\n",(100*boxct)+30);
			fprintf(out,"\(");
			for(j=0;j<12;j++){
				fprintf(out,"%c",lstrat[12*i+j]);
			}
			fprintf(out,"\) show\n");
			fprintf(out,"%d 8 moveto\n",(100*boxct)+30);
			fprintf(out,"\(");
			for(j=0;j<12;j++){
				fprintf(out,"%c",lstrat[480+12*i+j]);
			}
			fprintf(out,"\) show\n");
			fprintf(out,"%d 8 leading sub moveto\n",(100*boxct)+30);
			fprintf(out,"\(");
			for(j=0;j<12;j++){
				fprintf(out,"%c",lstrat[2*480+12*i+j]);
			}
			fprintf(out,"\) show\n");

			boxct += 1;

		} /* patt_used != 1 */

	}
	/* return origin to post-stratigraphy column position	*/
	fprintf (out,"-%.2f 60 translate\n",xkey-72);
}


/*--- draw curves around the mean value, if requested ----------------*/

domean(qlevel,level,qlevell,levell,qlevelr,levelr,llptsp,lrptsp,zmaxp,zminp,levs)
float	*qlevel,*level,*qlevell,*qlevelr,*levelr,*levell,*zmaxp,*zminp;
int	*llptsp,*lrptsp,levs;

{
/*------- calculate mean -----------------------------------------------*/

	float	mean,zmax,zmin;	
	float	sd;
	float	center,slope;
	int	i,llpts,lrpts;

	mean = 0;
	for (i=0;i<levs;i++) {
		mean += qlevel[i];
	}
	mean = mean/levs;

/*-----compute standard deviation ---------------------------------*/

	sd = 0;
	for (i=0;i<levs;i++) {
		sd += (qlevel[i] - mean)*(qlevel[i]-mean);
	}
	sd = sd/(levs);
	sd = exp((.5)*log(sd));

/*----- transform to z-function (mean 0, sd 1) -------*/

	zmax = 0;
	zmin = 0;
	for(i=0;i<levs;i++) {
		qlevel[i] = (qlevel[i] - mean)/sd;
		if (qlevel[i] > zmax) {
			zmax = qlevel[i];
		} else if (qlevel[i] < zmin) {
			zmin = qlevel[i];
		}
	}


/*---- compute curves left and right of the mean (0)---------------------*/


/*---- do first point ---------*/ 

	if (qlevel[0] <  0  ) {
		center = -1;
		qlevell[0] = qlevel[0];
		qlevelr[0] =  0;
	} else if (qlevel[0] ==  0  ) {
		center = 0;
		qlevell[0] = 0;
		qlevelr[0] = 0;
	} else {
		center = 1;
		qlevell[0] = 0;
		qlevelr[0] = qlevel[0];
	}
	levell[0] = level[0];
	levelr[0] = level[0];
	llpts = 0;
	lrpts = 0;

	for(i=1;i<levs;i++) {
/* current point is less than the mean	*/	
		if (qlevel[i] < 0  )  {
			if (center ==  1) {  /* previous point > mean	*/
				++llpts;
				++lrpts;
				qlevell[llpts] = 0;
				qlevelr[lrpts] = 0;
				slope = (level[i] - level[i-1])/(qlevel[i] - qlevel[i-1]);
				levelr[lrpts] = level[i] + (slope*(-qlevel[i]));
				levell[llpts] = levelr[lrpts];
				llpts ++;
				qlevell[llpts] = qlevel[i];
				levell[llpts] = level[i];
			} else {   /* previous point <= mean	*/
				llpts ++;
				qlevell[llpts] = qlevel[i];
				levell[llpts] = level[i];
			}	
			center = -1;
/* current point is the mean	*/
		} else if (qlevel[i] == 0) {
			llpts = llpts + 1;
			lrpts = lrpts + 1;
			qlevell[llpts] = 0;
			levell[llpts] = level[i];
			qlevelr[lrpts] = 0;
			levelr[lrpts] = levelr[i];
			center = 0;
/* current point is greater than the mean	*/
		} else {
			if (center == -1) {  /* previous point < mean	*/
				llpts = llpts + 1;
				lrpts = lrpts + 1;
				qlevelr[lrpts] = 0;
				qlevell[llpts] = 0;
				slope = (level[i] - level[i-1])/(qlevel[i] - qlevel[i-1]);
				levell[llpts] = level[i] + (slope*(-qlevel[i]));
				levelr[lrpts] = levell[llpts];
				lrpts ++;
				qlevelr[lrpts] = qlevel[i];
				levelr[lrpts] = level[i];
			} else {  /* previous point >= mean	*/
				lrpts ++;
				qlevelr[lrpts] = qlevel[i];
				levelr[lrpts] = level[i];
			}
			center = 1;
		}
	}
/* finish up last point	*/
	if (center == 1) {
		llpts ++;
		qlevell[llpts] = 0;
		levell[llpts] = level[levs];
	} else if (center == -1) {
		lrpts ++;
		qlevelr[lrpts] = 0;
		levelr[lrpts] = level[levs];
	}

/* set up pointers for return values	*/
	*llptsp = llpts;
	*lrptsp = lrpts;
	*zmaxp = zmax;
	*zminp = zmin;
}

/* 
 * dofill: fills in a sawtooth graph of a taxon with nothing, solid black,
 * lines (variable density and angle), grayscale, or (maybe) color
 */
dofill(xmax,xscale,ydim,i,name,fill,angle,density)
float	*xmax,xscale,angle;
int	ydim,i,*fill,density;
char	*name;
{
	float	y, darkness;

	y = (float)ydim;	
	fprintf(out,"gsave\n");

	if (fill[i] == 2) {
		fprintf(out,"clip\n");
		if (angle <= 90.0) {
			fprintf(out,"%.2f %.2f %.2f %d acutelines\n",y,((xmax[i])*xscale),angle,density);
		} else {
			fprintf(out,"%.2f %.2f %.2f %d obtuselines\n",y,((xmax[i])*xscale),angle,density);
		}
	} else if (fill[i] == 1) {
		fprintf (out,"0 setgray\n");
		fprintf(out,"fill\n");
	} else if (fill[i] == 3) {
		darkness = density / 10.0;
		fprintf (out, "%1.1f setgray fill\n",darkness);
	} else if (fill[i] == 4) {
		fprintf (out, "1 0 0 setrgbcolor fill\n");
	}

	fprintf(out,"grestore\nstroke\n");
}
	
/*
 * drawthatpup: draws the zone and subzone boxes.  Called from fortran
 * area of program 
 */ 
 
drawthatpup_(vec,ivtype,nvecsp,zonvecp,yscalep,xscalep,yminp,yqhitep)
float	*vec,*zonvecp,*yscalep,*xscalep,*yminp,*yqhitep;
int	*ivtype,*nvecsp;
{
	float	zonvec,yscale,xscale,yqhite,lasty,y,x,ymin;
	int	nvecs,zone,subzone,lastzone,i,ytemp,ydim;

	zonvec = *zonvecp;
	nvecs = *nvecsp;
	yscale = -(*yscalep);
	xscale = *xscalep;
	ymin = *yminp;
	yqhite = *yqhitep;

	if ((yqhite > 0.0) && (yqhite <= 8.0)) {
		ydim = (int)(yqhite * 72.0);
	} else {
		ydim = 396;
	}
	fprintf(out,"set_zonnum\n");
	fprintf(out,".5 setlinewidth\n");

	x = .15*xscale;
	zone = 1;
	subzone = 97; 
	lasty = 0;
	lastzone = 1;

	ytemp = 0;
	for (i=0;i<nvecs;i++) {
/*	draw zone 	*/
		if (ivtype[i] == 1) {
			fprintf(out,"0 %.2f moveto\n",ytemp + yscale*vec[i]+ymin*(yscale));	
			fprintf(out,"%.2f 0 rlineto\n",-zonvec); 
			fprintf(out,"stroke\n");
			y = ytemp + lasty + (yscale*vec[i] - lasty)/2;  
			fprintf(out,"%.2f %.2f moveto \n",x,y+ymin*(yscale));	
			if (lastzone == 1) {
				fprintf(out,"(%d) show\n",zone);
			} else {
				fprintf(out,"(%d%c) show\n",zone,(char)subzone);
				subzone = 97;
			}
			++zone;	
			lasty = yscale*vec[i];
			lastzone = 1;
/*	draw subzone	*/
		} else {
			fprintf(out,"gsave\n");
			fprintf(out,"0 %.2f moveto\n",ytemp + yscale*vec[i]+ymin*(yscale));	
			fprintf(out,"[2] 0 setdash\n");
			fprintf(out,"%.2f 0 rlineto\n",-zonvec); 
			fprintf(out,"stroke\n");
			fprintf(out,"grestore\n");
			y = ytemp + lasty + (yscale*vec[i] - lasty)/2;  
			fprintf(out,"%.2f %.2f moveto \n",x,y+ymin*(yscale));	
			fprintf(out,"(%d%c) show\n",zone,(char)subzone);
			++ subzone;
			lasty = yscale*vec[i]; 
			lastzone = 2; 
		} 
	}
 /* finish up trailing segment.... */	
	y = ytemp + lasty + (-ydim - lasty)/2;  
	fprintf(out,"%.2f %.2f moveto \n",x,y+ymin*(yscale));	
		if (lastzone == 1) {
			fprintf(out,"(%d) show\n",zone);
		} else {
			fprintf(out,"(%d%c) show\n",zone,(char)subzone);
		}
	fprintf(out,"0 setlinewidth\n");
}

