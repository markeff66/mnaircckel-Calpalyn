#define maxtax 120
#define maxlev 180
#define mt27   147
#define ml2    360
#define maxsum 6
  
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

