# 1 "" 
************************************************************************
      subroutine qplot (datum, qlevel, level, instmx, pctgmx, bstrng,
     + nameary, type, rep, lbl, ibar,legend, lbl2,
     + staxa, sdata, sshade,staxref, qlevell,levell,qlevelr,
     + levelr,fill,angle,density,rstrat,istrat)

c    This segment creates PostScript code  

# 1 "./pollen.h" 1





  
      integer  regtab(3),exreg(3), instab(3,6)	

      common  /basics/ rawtab, doname, mixtab, exmix, qsums, qcalcs,
     +nqlevs, nqtaxa, nqtopl, nscrsr, nscrsm, regtab, exreg, nrec8,
     +nrec9, filtyp, exraw, depfac, instab

      integer nqsum(9),doqsum(9)	

      common  /rework/ dofact, nqfact, nqsum, doplot, doqsum

      character vqname(16,37)

      common /vqname/ vqname

      character*12 lstrat(40,3)
      character*40 lstrng
      character*80 title
      real rstrat(40)
      integer istrat(40,4)
      character*8 isotyp(40)
      integer izone(10)	
      real c14(40,4)
      integer c14col,strcol,bigfnt
      integer usrfnt(24)

      common /qissco/ ipat0, ipat1, ibars, isize, lstrng, title, yqhite,
     +ystep, brfact, nytcks, levlin, c14col, strcol, bigfnt, c14, rstrat,
     +istrat, lstrat, ndates, nstrts, isotyp, nzone, izone, azone, bzone,
     +xwidth, crstep, abscal, usrfnt

      character*40  sumlbl

      common /summry/ idosd,sscale, sumlbl, isrep

# 10 "" 2

      real datum(180,147), qlevel(180), level(180),
     +pctgmx(120),offset,
     +sdata(180,6),temp(200),   temp2(200),
     +boxlen(2), lblsiz, boxhit, qlevell(360),qlevelr(360),
     +levell(360), levelr(360),     mxary(2),myary(2),
     +zmax,zmin,angle(120),
     +rstrat(40)

      integer filtyp, rawtab, doname, exmix, 
     +exraw, instmx(120,10) 
     +,fill(120), staxa(6), sshade(6),staxref(6)
     +,density(120)
      integer type(120), rep(120),flag, ibar(120),
     +nullary(2)
      integer istrat(40,4)

      character*4 name1(4), name2(4), name3(4)
      character*16 nameary(6)
      character*30 bstrng(120)
      character*30 lbl(120), lbl2(120)
      character*40 legend

      logical qsums, qcalcs

      nullary(1) = 0
      nullary(2) = 0

*  read mixed table into central array:

      nrec9 = 3 * 180
      do 10 i=1,nqlevs
10    read (9,rec=(nrec9+i)) (datum(i,j), j=1,nqtopl)
      close (unit=9, status='delete')

*  calculate default graph height within paper limits:
11    format (f7.0, f7.0, f7.0, f7.0)

      call psdraw(datum,level,nqlevs,nqtopl,pctgmx,instmx,ibar,
     + bstrng,lbl2,legend,c14col,strcol,bigfnt,usrfnt,izone,
     + yqhite,xwidth,ystep,crstep,abscal,nstrts,istrat,rstrat,
     + lstrng,title,rep,type,lbl,c14,isotyp,ndates,lstrat,depfac,
     + azone,bzone,levlin,fill,angle,density)

      return
      end

************************************************************************
      subroutine smooth (datum, iiitax)

# 1 "./pollen.h" 1





  
      integer  regtab(3),exreg(3), instab(3,6)	

      common  /basics/ rawtab, doname, mixtab, exmix, qsums, qcalcs,
     +nqlevs, nqtaxa, nqtopl, nscrsr, nscrsm, regtab, exreg, nrec8,
     +nrec9, filtyp, exraw, depfac, instab

      integer nqsum(9),doqsum(9)	

      common  /rework/ dofact, nqfact, nqsum, doplot, doqsum

      character vqname(16,37)

      common /vqname/ vqname

      character*12 lstrat(40,3)
      character*40 lstrng
      character*80 title
      real rstrat(40)
      integer istrat(40,4)
      character*8 isotyp(40)
      integer izone(10)	
      real c14(40,4)
      integer c14col,strcol,bigfnt
      integer usrfnt(24)

      common /qissco/ ipat0, ipat1, ibars, isize, lstrng, title, yqhite,
     +ystep, brfact, nytcks, levlin, c14col, strcol, bigfnt, c14, rstrat,
     +istrat, lstrat, ndates, nstrts, isotyp, nzone, izone, azone, bzone,
     +xwidth, crstep, abscal, usrfnt

      character*40  sumlbl

      common /summry/ idosd,sscale, sumlbl, isrep

# 61 "" 2

      real datum(180,147), minus, plus, value
      integer iiitax

      do 100 i=1,nqlevs

      if (i.eq.1) then
         minus = datum(i,iiitax)
      else
         minus = datum(i-1,iiitax)
         datum(i-1,iiitax) = value
      end if

      if (i.eq.nqlevs) then
         plus = datum(i,iiitax)
      else
         plus = datum(i+1,iiitax)
      end if

      value = (minus + 2.0*datum(i,iiitax) + plus) / 4.0

100   continue

      datum(nqlevs,iiitax) = value

      return
      end

************************************************************************
      subroutine grstep (step1,val)

*  rounds positive or negative values on a logarithmic scale:          *
* ...0.1,0.25,0.5,1.0,2.5,5,10,25,50,100,250,500,1000,2500,5000...     *
* [>= 175 >> 250; >= 375 >> 500; >= 750 >> 1000 etc etc]               *
************************************************************************
      character*11 intfil
      real val	
*     write (4,'('' step1 = '',e11.4)') step1
      write (intfil,'(e11.4)') step1
      read (intfil,'(1x,f6.0,1x,i3)') sigstp, iexp
      if (sigstp.ge.0.75) then
         step2 = 1.0*10.0**(iexp)
      else if (sigstp.ge.0.375) then
         step2 = 0.5*10.0**(iexp)
      else if (sigstp.ge.0.175) then
         step2 = 0.25*10.0**(iexp)
      else
         step2 = 0.1*10.0**(iexp)
      end if

      if (step1.lt.0.0) step2 = -(step2)

      val = step2

      return
      end

**********************************************************************
      subroutine getname(name1,name2,name3,instmx,i)

# 1 "./pollen.h" 1





  
      integer  regtab(3),exreg(3), instab(3,6)	

      common  /basics/ rawtab, doname, mixtab, exmix, qsums, qcalcs,
     +nqlevs, nqtaxa, nqtopl, nscrsr, nscrsm, regtab, exreg, nrec8,
     +nrec9, filtyp, exraw, depfac, instab

      integer nqsum(9),doqsum(9)	

      common  /rework/ dofact, nqfact, nqsum, doplot, doqsum

      character vqname(16,37)

      common /vqname/ vqname

      character*12 lstrat(40,3)
      character*40 lstrng
      character*80 title
      real rstrat(40)
      integer istrat(40,4)
      character*8 isotyp(40)
      integer izone(10)	
      real c14(40,4)
      integer c14col,strcol,bigfnt
      integer usrfnt(24)

      common /qissco/ ipat0, ipat1, ibars, isize, lstrng, title, yqhite,
     +ystep, brfact, nytcks, levlin, c14col, strcol, bigfnt, c14, rstrat,
     +istrat, lstrat, ndates, nstrts, isotyp, nzone, izone, azone, bzone,
     +xwidth, crstep, abscal, usrfnt

      character*40  sumlbl

      common /summry/ idosd,sscale, sumlbl, isrep

# 122 "" 2
      character*4 name1(4), name2(4), name3(4)
      integer instmx(120,10)
 

      read (8,'(12a4)',rec = instmx(i,1)) name1,name2,name3	

      return
      end
