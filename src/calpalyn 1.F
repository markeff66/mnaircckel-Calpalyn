c
c
c            universal pollen conversion and graphics program
c
c
c        fortran 77:  ibm "vs" release 3.1, with extensions.
c
c        disspla graphics:  calls to release 10.0
c
c        spss-x:  file (unit 7) written for release 1.0.
c
c
c        d. m. power                        may, 1968
c        f. j. huhn                         april, 1971
c        a. r. gibson                       may, 1975
c        ralph dubayah                      january, 1
c        kenneth h. orvis                   june, 1984
c        romy bauer                         july, 1988
c        eric edlund                        october, 1991
c
c        palynology laboratory, university of california, berkeley
c        version 1.61; april 1987
c
c
c***********************************************************************
c***********************************************************************
c

      program pollen


c  define size of program (central arrays) here:

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

# 35 "" 2

      real datum(180,(147)), level(180), factor(147)
     +, rqline(16), qlevel(180), pctgmx(120)
     +, sdata(180,6), spct(180,6),qlevell(360),
     + levell(360), qlevelr(360), levelr(360),angle(120),rstrat(40)

      integer sumtax(9,120), instmx(120,10),
     +taxon(147), factax(120), filtyp, 
     +dofact, mixtab, exmix, doplot, doname, rawtab, exraw,
     +qtaxon(147), c14col, strcol, bigfnt, usrfnt(24), abscal, 
     +fill(120), staxa(6), sshade(6), staxref(6),
     +density(120),istrat(40,4)

      integer type(120), rep(120), ibar(120),isize
      logical qsums, qcalcs

      character*5 regvar(147), mixvar(147)
      character*30 bstrng(120)
      character*30 lbl(120),lbl2(120)
      character*40 legend 
      character*16 nameary(6)
      character*30 datafile,instrfile,taxafile	


      nameary(1) = 'trees'
      nameary(2) = 'shrubs'
      nameary(3) = 'herbs'
      nameary(4) = 'ferns'
      nameary(5) = 'aquatics'
      nameary(6) = 'trees & shrubs'

*--initialize main array (this way to avoid large object file)----------

      do 1002, i=1,180
      do 1000, j=1,120
1000  datum(i,j) = 1.0e10
      do 1001, j=(120+1),(147)
1001  datum(i,j) = 0.0
1002  continue

*--notify user we're up-------------------------------------------------

c      write (6,2000) 120, 180
c2000  format ('welcome to calpalyn.'//' we are currently able to handle
c     + ', i4, ' samples or levels, and ', i4, ' active "taxa".'/)

*--get input files-----------------------------------------------------
 
c      write (6,2001)
c2001  format('please enter data file')
c      read (5,2002) datafile
c2002  format (a30)
c      write (6,2003)
c2003  format('please enter instruction file')
c      read (5,2004) instrfile
c2004  format (a30)
c      write (6,2005)
c2005  format('please enter instruction file')
c      read (5, 2006) taxafile	 
c2006  format (a30)

*--open calpalyn listing file--------------------------------------------

      open (20, file = 'calpalyn.listing')	

*--read in instruction file (unit 2)------------------------------------

      call instrs (2, factax, factor, sumtax, instmx, pctgmx, bstrng,
     + nameary,type,rep,lbl,ibar,rstrat,istrat,legend,lbl2,
     + staxa, sshade, instrfile,fill,angle,density,*9999)

*--read in data file (unit 1), rewrite if necessary---------------------
*  [re-writing has been disabled.]

      call qdata (2, level, qlevel, taxon, qtaxon, datum,datafile,*9999)

c      write (6, '('' your data file includes '', i4, '' samples or level
c     +s and '', i4, '' active "taxa".''/)') nqlevs, nqtaxa

*--factor any data values requested (ignore inactive taxa)--------------

3600  if (dofact .eq. 0) go to 3650

      do 3612 i=1,nqfact
      do 3611 j=1,nqtaxa
      if (factax(i) .ne. taxon(j)) go to 3611
      do 3610 ij=1,nqlevs
3610  datum(ij,j) = datum(ij,j) * factor(i)
      go to 3612
3611  continue
3612  continue

*--factor levels as requested-------------------------------------------

3650  if (depfac .eq. 1.0) go to 3700
      do 3651 i=1,nqlevs
3651  level(i) = level(i) * depfac

*--calculate any sums requested-----------------------------------------
*  also, if 9th sum is active, export data values for the first 18
*  active taxa to unit 15 for use by zonation routine.

3700  qsums = .false.
      nzone = 0

      do 3750 i=1,9
      if (doqsum(i) .eq. 0) go to 3750
      qsums = .true.

      if (doqsum(i) .ne. 2) go to 3720
      do 3710 j=1,9
3710  sumtax(1,j) = j + 99
      nqsum(1) = 9

3720  if (i .eq. 1 .and. doqsum(1) .eq. 1) go to 3740
      do 3723 j=1,nqsum(i)
      do 3722 ij=1,nqtaxa
      if (sumtax(i,j) .ne. taxon(ij)) go to 3722
      do 3721 ijk=1,nqlevs
3721  datum(ijk,i+120) = datum(ijk,i+120) + datum(ijk,ij)
      if (i.eq.9 .and. nzone.lt.18) then
         write (15,'(13f6.0)') (datum(ijk,ij),ijk=1,nqlevs)
         nzone = nzone + 1
      end if
      go to 3723
3722  continue
3723  continue

      if (i .gt. 1) go to 3750
      do 3730 j=1,nqlevs
3730  datum(j,i+120) = -(datum(j,i+120))

3740  do 3742 j=1,nqtaxa
      if (taxon(j) .le. 0) go to 3742
      do 3741 ij=1,nqlevs
3741  datum(ij,i+120) = datum(ij,i+120) + datum(ij,j)
3742  continue

3750  continue
      if (nzone.eq.0 .and. abs(izone(1)).gt.1) then
         if (izone(1).lt.0) then
            izone(1) = -1
         else
            izone(1) = 0
         end if
      end if

*--extract any values for automatic calculations------------------------

      qcalcs = .false.

      do 3803 i=1,16
      do 3802 j=1,nqtaxa
      if (taxon(j) .ne. (i - 66)) go to 3802
      qcalcs = .true.
      do 3801 ij=1,nqlevs
3801  datum(ij,120+9+i) = datum(ij,j)
      go to 3803
3802  continue
3803  continue

      if (.not. qcalcs) go to 3841

*--automatic calculations-----------------------------------------------

      do 3840 i=1,nqlevs

*  separate data values for this level, discarding negative values:

      do 3810 j=1,16
      rqline(j) = datum(i,120+9+j)
      if (rqline(j) .lt. 0.0) rqline(j) = 0.0
3810  datum(i,120+9+j) = 0.0

*  determine or estimate volumes, net wet weights, weight ratio:

      if (rqline(9) .eq. 0.0) rqline(9) = rqline(6) * rqline(7)
      if (rqline(15)-rqline(16) .gt. 0.0) then
         rqline(15) = rqline(15) - rqline(16)
      else
         rqline(15) = 0.0
      end if
      if (rqline(13)-rqline(14) .gt. 0.0) then
         rqline(13) = rqline(13) - rqline(14)
      else
         rqline(13) = 0.0
      end if
      if (rqline(8).ne.0.0 .and. rqline(9).ne.0.0 .and. rqline(13).ne.
     + 0.0 .and. rqline(15).ne.0.0) then
         wratio = rqline(15) / rqline(13)
         vratio = rqline(9) / rqline(8)
      else if (rqline(13).ne.0.0 .and. rqline(15).ne.0.0) then
         wratio = rqline(15) / rqline(13)
         vratio = wratio
      else if (rqline(8).ne.0.0 .and. rqline(9).ne.0.0) then
         vratio = rqline(9) / rqline(8)
         wratio = vratio
      else
         wratio = 1.0
         vratio = 1.0
      end if
      if (rqline(9).eq.0.0) rqline(9) = rqline(8) * vratio
      if (rqline(15).eq.0.0) rqline(15) = rqline(13) * wratio
      datum(i,147) = rqline(15)

*  estimate dry weight, water fraction if possible:

3824  if (rqline(12)-rqline(14) .le. 0.0) go to 3825
      datum(i,120+26) = (rqline(12) - rqline(14)) * wratio
      if (datum(i,147) .eq. 0.0) go to 3825
      datum(i,120+25) = datum(i,147) - datum(i,120+26)
      datum(i,120+20) = (datum(i,120+25) / datum(i,147)) *
     +100.0

*  estimate organic, inorganic fractions if possible:

3825  if (rqline(11)-rqline(14) .le. 0.0) go to 3826
      datum(i,120+23) = (rqline(11) - rqline(14)) * wratio
      if (datum(i,120+26) .eq. 0.0) go to 3826
      datum(i,120+24) = datum(i,120+26) - datum(i,120+23)
      datum(i,120+19) = (datum(i,120+24) / datum(i,120+26)) *
     +100.0
      datum(i,120+18) = (datum(i,120+23) / datum(i,120+26)) *
     +100.0

*  estimate carbonate, mineral ash fractions if possible:

3826  if (rqline(10)-rqline(14) .le. 0.0) go to 3827
      datum(i,120+21) = (rqline(10) - rqline(14)) * wratio
      if (datum(i,120+23) .eq. 0.0) go to 11111
      datum(i,120+22) = datum(i,120+23) - datum(i,120+21)
11111 if (datum(i,120+26) .eq. 0.0) go to 3827
      datum(i,120+17) = (datum(i,120+22) / datum(i,120+26)) *
     +100.0
      datum(i,120+16) = (datum(i,120+21) / datum(i,120+26)) *
     +100.0

*  estimate wet density if possible (wratio may be 1.0):

3827  if (rqline(9) .eq. 0.0) go to 3828
      datum(i,120+15) = datum(i,147) / rqline(9)

*  estimate dry sedimentation rate if possible:

3828  if (rqline(7) .eq. 0.0 .or. datum(i,120+26) .eq. 0.0) go to
     +3830
      if (rqline(4) .ne. 0.0) go to 3829
      if (rqline(6) .eq. 0.0 .or. rqline(5) .eq. 0.0) go to 3830
      rqline(4) = rqline(5) * rqline(6)
3829  datum(i,120+14) = (datum(i,120+26) / rqline(7)) / rqline(4)

*  calculate multipliers if possible:

3830  if (rqline(1) .eq. 0.0) go to 3840
      cntfac = (rqline(3) * rqline(2)) / rqline(1)
      if (cntfac .eq. 0.0) go to 3840
      if (datum(i,147) .eq. 0.0) go to 3831
      datum(i,120+12) = cntfac / datum(i,147)
3831  if (datum(i,120+26) .eq. 0.0) go to 3832
      datum(i,120+13) = cntfac / datum(i,120+26)
3832  if (rqline(9) .eq. 0.0) go to 3833
      datum(i,120+11) = cntfac / rqline(9)
3833  if (rqline(7) .eq. 0.0 .or. rqline(4) .eq. 0.0) go to 3840
      datum(i,120+10) = (cntfac / rqline(7)) / rqline(4)

3840  continue

*--include any new values in program's data domain----------------------

3841  if (.not. qcalcs .and. .not. qsums) go to 4000

      do 3855 i=1,27
      if (i .lt. 10 .and. doqsum(i) .eq. 0) go to 3855
3850  do 3851 j=1,nqlevs
3851  if (datum(j,120+i) .ne. 0.0) go to 3852
      go to 3855
3852  if (nqtaxa + 1 .eq. 120 + i) go to 3854
      do 3853 j=1,nqlevs
3853  datum(j,nqtaxa+1) = datum(j,120+i)
3854  nqtaxa = nqtaxa + 1
      taxon(nqtaxa) = i - 10000
      if (i .gt. 9) taxon(nqtaxa) = taxon(nqtaxa) + 473
3855  continue

*--compute data for summary table if requested-------------------------

      if (idosd .eq. 1) call dostbl(staxa,sdata,spct,taxon,datum,
     +staxref)

*--set up scratch file (unit 8) with taxon names------------------------

4000  open (unit=8, status='new',     access='direct', form='formatted',
     +recl=56)

      call names (taxon,taxafile)

*--set up any tables of normalizations on scratch file (unit 9)---------

      if (regtab(1)+regtab(2)+regtab(3)+mixtab+exreg(1)+exreg(2)+
     +exreg(3)+exmix+doplot .eq. 0) go to 4001

      call tables (datum, instmx, taxon, factor, *9999)

*--write file (unit 7) for spssx if requested---------------------------

4001  if (exraw+exreg(1)+exreg(2)+exreg(3)+exmix .eq. 0) go to 4500

      call qspssx (taxon, level, datum, instmx, factor, mixvar, regvar)

*--write any tables of normalizations on printer file (unit 4)----------

4500  if (rawtab+regtab(1)+regtab(2)+regtab(3)+mixtab .eq. 0) go to 5000

*  write taxon names in vertical format for printer file tables:

4520  write (8, 4601, rec=(nqtaxa+1))
4601  format (' sample or level')
      read (8,4602,rec=(nqtaxa+1)) (vqname(i,1), i=1,16)
4602  format (16a1)

      if (rawtab .eq. 0) then
         do 4603 i=1,3
         if (regtab(i) .eq. 1) go to 4604
4603     continue
         go to 4700
      end if
4604  nscrsr = nqtaxa / 12
      if (mod(nqtaxa,12) .gt. 0) nscrsr = nscrsr + 1
      call vernam (1, taxon, instmx)

4700  if (mixtab .eq. 0) go to 4800
      nscrsm = nqtopl / 12
      if (mod(nqtopl,12) .gt. 0) nscrsm = nscrsm + 1
      call vernam (2, taxon, instmx)

*  write printer file (unit 4):

4800  call qprint (datum, level, factor, instmx)

*--set up calls to disspla for the plotfile-----------------------------

5000  if (abs(izone(1)).gt.1) then
         rewind 15
         call zontem (nzone, nqlevs)
         rewind 15
      end if
      if (c14col .eq. 1) then
         write (16,'(3i4,e14.6)') nqlevs, ndates, isize, depfac
         write (16,'(a80)') title
         write (16,5001) (level(i),i=1,nqlevs)
         write (16,5001) (c14(i,1),i=1,ndates)
         write (16,5001) (c14(i,2),i=1,ndates)
         write (16,5001) (c14(i,3),i=1,ndates)
         write (16,5001) (c14(i,4),i=1,ndates)
      end if
5001  format (6e12.6)

      if (doplot .eq. 1) call qplot (datum, qlevel, level, instmx,
     + pctgmx, bstrng, nameary, type, rep, lbl,ibar,legend,lbl2,
     + staxa, sdata, sshade,staxref, qlevell, levell, qlevelr,
     + levelr,fill,angle,density,rstrat,istrat)

*--say good-bye to user-------------------------------------------------

9999  write (6, 99999)
99999 format ('    ...and it''s a big good-bye from calpalyn!'/)
      close (9)    

      stop
      end
************************************************************************
      subroutine instrs (iprog, factax, factor, sumtax, instmx, pctgmx,
     +bstrng, nameary,type,rep,lbl,ibar,rstrat,istrat,legend,lbl2,
     +staxa, sshade, instrfile,fill,angle,density,*)


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

# 412 "" 2
      real factor(147), pctgmx(120),angle(120)

      integer sumtax(9,120), instmx(120,10),
     +factax(120), filtyp, 
     +dofact, mixtab, exmix, doplot, doname, rawtab, exraw, amdone,
     +inline(15), c14col, strcol, 
     +fill(120), staxa(6), sshade(6), density(120)
      integer type(120), rep(120), ibar(120)

      logical qsums, qcalcs

      character*8 nameary(5)
      character*30 bstrng(120),lbl2(120)
      character*30 lbl(120)
      character*30 instrfile
      character*40 legend

*                            should inquire...
c      open (2, file=instrfile)
c      open (2)
      open (2, file = 'calpalyn.instrs')
*
      nqline = 1
c|||||   instructions for qdata:                      ||||||||||||||||||
      read (2,1000,err=2000,end=2005) filtyp, dofact, depfac
1000  format (i1,1x,i1,1x,f9.0)
      if (filtyp .lt. 0 .or. filtyp .gt. 1 .or. dofact .lt. 0 .or.
     +dofact .gt. 1) go to 2010
      if (depfac .eq. 0.0) depfac = 1.0
      if (filtyp .eq. 0) go to 1001
      filtyp = 10
      go to 1002
1001  filtyp = 7
1002  if (dofact .eq. 1) go to 1020
c
1010  nqline = nqline + 1
      read (2,1011,err=2000,end=2005) amdone
1011  format (i1)
      if (amdone .lt. 0 .or. amdone .gt. 1) go to 2010
      if (amdone .eq. 1) go to 1030
      go to 1010
c
1020  nqfact = 0
1021  nqline = nqline + 1
      read (2,1022,err=2000,end=2005) amdone, thefac, (inline(i),i=1,14)
1022  format (i1,1x,f7.0,1x,14i5)
      if (amdone .lt. 0 .or. amdone .gt. 1) go to 2010
      do 1024 i=1,14
      if (inline(i) .eq. 0) go to 1024
      if (nqfact .eq. 0) go to 100
      do 1023 j=1,nqfact
1023  if (inline(i) .eq. factax(j)) go to 2020
100   nqfact = nqfact + 1
      if (nqfact .gt. 120) go to 2015
      factor (nqfact) = thefac
      factax(nqfact) = inline(i)
1024  continue
      if (amdone .eq. 0) go to 1021
c
1030  nqline = nqline + 1
      read (2,1031,err=2000,end=2005) (doqsum(i), i=1,9)
1031  format (9(i1,1x))
      if (doqsum(1) .lt. 0 .or. doqsum(1) .gt. 3) go to 2010
      do 1032 i=2,9
1032  if (doqsum(i) .lt. 0 .or. doqsum(i) .gt. 1) go to 2010
c
      do 1060 i=1,9
      if (doqsum(i) .eq. 3 .or. (i .gt. 1 .and. doqsum(i) .eq. 1)) go to
     +1050
1040  nqline = nqline + 1
      read (2,1041,err=2000,end=2005) amdone
1041  format (i1)
      if (amdone .lt. 0 .or. amdone .gt. 1) go to 2010
      if (amdone .eq. 1) go to 1060
      go to 1040
1050  nqsum(i) = 0
1051  nqline = nqline + 1
      read (2,1052,err=2000,end=2005) amdone, (inline(j), j=1,15)
1052  format (i1,1x,15i5)
      if (amdone .lt. 0 .or. amdone .gt. 1) go to 2010
      do 1054 j=1,15
      if (inline(j) .eq. 0) go to 1054
      if (nqsum(i) .eq. 0) go to 200
      do 1053 ij=1,nqsum(i)
1053  if (inline(j) .eq. sumtax(i,ij)) go to 2030
200   nqsum(i) = nqsum(i) + 1
      if (nqsum(i) .gt. 120) go to 2025
      sumtax(i,nqsum(i)) = inline(j)
1054  continue
      if (amdone .eq. 0) go to 1051
1060  continue
c
c|||||    control instructions for parts 4, 6, 7, 8   ||||||||||||||||||
      nqline = nqline + 1
      read (2,1070,err=2000,end=2005) doname
      if (doname .lt. 0 .or. doname .gt. 1) go to 2010
      nqline = nqline + 1
      read (2,1071,err=2000,end=2005) rawtab, (regtab(i), i=1,3), mixtab
      if (rawtab .lt. 0 .or. rawtab .gt. 1 .or. mixtab .lt. 0 .or.
     +mixtab .gt. 1) go to 2010
      do 1065 i=1,3
      if (regtab(i) .lt. 0 .or. regtab(i) .gt. 1) go to 2010
1065  continue
      nqline = nqline + 1
      read (2,1071,err=2000,end=2005) exraw, (exreg(i), i=1,3), exmix
      if (exraw .lt. 0 .or. exraw .gt. 1 .or. exmix .lt. 0 .or. exmix
     +.gt. 1) go to 2010
      do 1066 i=1,3
      if (exreg(i) .lt. 0 .or. exreg(i) .gt. 1) go to 2010
1066  continue
      nqline = nqline + 1
      read (2,1070,err=2000,end=2005) doplot
      if (doplot .lt. 0 .or. doplot .gt. 1) go to 2010
1070  format (i1)
1071  format (5(i1,1x))

c|||||        instructions for part 5
1100  do 1102 i=1,3
1101  format (i1,1x,5i5)
      nqline = nqline + 1
1102  read (2,1101,err=2000,end=2005) (instab(i,j), j=1,6)

      nqtopl = 0
1110  nqline = nqline + 2
      nqtopl = nqtopl + 1
      if (nqtopl .gt. 120) go to 2035
      read (2,1111,err=2000,end=2005) amdone, (instmx(nqtopl,i),i=1,10),
     +pctgmx(nqtopl),               bstrng(nqtopl)
1111  format (i1,1x,i5,1x,i1,1x,5i5,2(1x,i1),1x,i2,1x,f6.0,1x,      a30)
      read (2,1120,err=2000,end=2005) rep(nqtopl),type(nqtopl),
     +fill(nqtopl),angle(nqtopl),density(nqtopl), ibar(nqtopl),
     +lbl(nqtopl),lbl2(nqtopl)
1120  format (i1,1x,i1,1x,i1,1x,f7.0,1x,i2,1x,i1,1x,a30,a15)


      if (amdone .lt. 0 .or. amdone .gt. 1) go to 2010
      if (amdone .eq. 0) go to 1110

c|||||    instructions for part eight                 ||||||||||||||||||

      read (2,1200,err=2000,end=2005)  levlin, strcol, c14col, bigfnt,
     +(usrfnt(j),j=1,22)
1200  format (4(i1,1x),22(i2,1x))
      if (levlin .gt. 1) levlin = 0
      if (c14col .gt. 2) c14col = 0
      if (strcol .gt. 2) strcol = 0
      if (bigfnt .gt. 2) bigfnt = 0
      read (2,'(4(1x,f6.0),1x,i6)',err=2000,end=2005) yqhite, xwidth,
     +ystep, crstep, abscal
      read (2,'(5(i2,1x),5i5,2(1x,f5.0))',err=2000,end=2005) (izone(i),
     +i=1,10), azone, bzone
      read (2,'(a40)',err=2000,end=2005) lstrng
      read (2,'(a80)',err=2000,end=2005) title

*  read in instructions for c-14 column:

      irep = 0
300   irep = irep + 1
      read (2,301,end=2005) amdone, (c14(irep,j), j=1,4), isotyp(irep)
301   format (i1, 4(1x,f7.0), 1x, a8)
      c14(irep,1) = c14(irep,1) * depfac
      c14(irep,2) = c14(irep,2) * abs(depfac)
      if (amdone .eq. 0) go to 300

* line 26-a:  legend for stratigraphy column.

      read (2,302,end=2005) legend
302   format (a40)

      ndates = irep
*  read in instructions for stratigraphic column (line 27):

      irep = 0
310   irep = irep + 1
      read (2,311,end=2005) amdone, rstrat(irep), (istrat(irep,j),j=1,4)
     +, (lstrat(irep,j),j=1,3)
311   format (i1,1x,f7.0,1x,i1,3(1x,i7),3(1x,a12))
      rstrat(irep) = rstrat(irep) * depfac
      if (istrat(irep,1) .gt. 4) istrat(irep,1) = 0

      if (amdone .eq. 0) go to 310
      nstrts = irep

*  read in instructions for summary diagram (lines 28, 29):

      read(2,320,end=2005) idosd,sscale,sumlbl
 320  format (i1,1x,f6.0,1x,a30)
      isrep = 0
 321  isrep = isrep + 1
      read(2,325,end = 2005) amdone, staxa(isrep),sshade(isrep)
 325  format (i1, 1x, i5, 1x, i7)
      if (amdone .eq. 0) go to 321

*  instructions for zonation (line 30) are read from zontem.

      go to 3000
c|||||    errors for part two                         ||||||||||||||||||
c
2000  write (6,2001) nqline
2001  format ('we can''t read line', i4, ' of your instruction file; pl
     +ease fix it and we can try'/' again.'/)
      return 1
2005  backspace (2)
      write (6,2006) nqline
2006  format ('your instruction file ended prematurely after line', i4,
     +'.  we have to stop.'/)
      return 1
2010  write (6,2011) nqline
2011  format ('0a number on line', i4, ' of your instruction file makes
     +no sense.  please fix it,'/' and we can try again.'/)
      return 1
2015  write (6,2016)
2016  format ('0you''ve given us more taxa in your instruction-file list
     + (of taxa whose raw'/' values should be factored as we read them)
     +than you''re allowed for your total'/' number of taxa in the first
     +place!  give us a break;  fix that and try again.'/)
      return 1
2020  write (6,2021) inline(i)
2021  format ('0in your instruction-file list (of taxa whose raw values
     +should be factored as we'/' read them) you told us to factor taxon
     +', i5, ' two different times.  please'/' straighten that out and t
     +ry again.'/)
      return 1
2025  write (6,2026) i
2026  format ('0you''ve given us more taxa in your instruction-file list
     + (of taxa to use in'/' figuring your total or subtotal number ',
     +i1, ') than you''re allowed for your total'/' number of taxa in th
     +e first place!  give us a break;  fix that and try again.'/)
      return 1
2030  write (6,2031) i, inline(j)
2031  format ('0in your instruction-file list (of taxa to use in figurin
     +g your total or subtotal'/' number ', i1, ') you included taxon ',
     +i5, ' twice.  please straighten that out and try'/' again.'/)
      return 1
2035  write (6,2036) 120
2036  format ('0in your instruction-file list (of taxa to factor indepen
     +dently for use in your'/' mixed table and/or diagram) you''ve incl
     +uded more than ', i3, ', which is the maximum'/' without expanding
     + the program''s capacity.  we have to abort; please lower your'/'
     +sights.'/)
      return 1

3000  return
      end
************************************************************************
      function iposn (iqtax, taxon)

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

# 660 "" 2

      integer rawtab, doname, exmix, 
     +taxon(147)

      logical qsums, qcalcs
*
***be sure your code can handle iposn of 0!***
*
      if (iqtax .ne. 0) go to 100
      iposn = 0
      return
100   do 101 i=1,nqtaxa
      if (taxon(i) .ne. iqtax) go to 101
      iposn = i
      return
101   continue
      iposn = 0
      return
      end
************************************************************************
      subroutine names (taxon,taxafile)

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

# 683 "" 2

      integer rawtab, doname, mixtab, exmix, 
     +filtyp, exraw, taxon(147)

      logical qsums, qcalcs, round2

      character*4 aqline(12)
      character*30 taxafile

4000  if (doname .eq. 1) go to 4100
      do 4001 i=1,nqtaxa
4001  write (8,4002,rec=i) taxon(i), taxon(i)
4002  format (i5,46x,i5)
      go to 4600

4100  nqline = 0
c      open (3,file=taxafile)
c      open (3)
      open (3, file= 'calpalyn.taxa')
      ntaxq1 = (-10000)
4101  nqline = nqline + 1
      read (3,4102,err=4500,end=4103) ntaxq2
4102  format (i5)
      if (ntaxq2 .le. ntaxq1) go to 4510
      ntaxq1 = ntaxq2
      go to 4101

4103  rewind (3)
      nqline = 0
      round2 = .false.
4104  do 4109 i=1,nqtaxa
      if (taxon(i) .le. -9000 .and. .not. round2) then
         rewind (3)
         nqline = 0
         round2 = .true.
      end if
4105  nqline = nqline + 1
      read (3,4106,err=4500,end=4107) ntaxq1, (aqline(j), j=1,12)
4106  format (i5,3(1x,4a4))
      go to 4108
4107  ntaxq1 = 100000
4108  if (taxon(i) .gt. ntaxq1) then
         go to 4105
      else if (taxon(i) .eq. ntaxq1) then
         write (8,'(12a4,3x,i5)',rec=i) (aqline(j),j=1,12), taxon(i)
      else
         write (8,4002,rec=i) taxon(i), taxon(i)
         backspace (3)
      end if
4109  continue
      go to 4600

4500  write (6,4501) nqline
4501  format ('0oops.  we can''t read line ', i4, ' of the file of taxon
     + names.  take a look at that.'/'0meantime, we''ll just go ahead, u
     +sing the numbers.'/)
      doname = 0
      go to 4000
4510  write (6,4511) nqline, ntaxq2, ntaxq1
4511  format ('0huh...  you know, the taxon numbers in your file of taxo
     +n names need to start'/' with the littlest and go up to the bigges
     +t, and you can''t use the same number'/' twice; but here on line '
     +, i4, ' we''re looking at ', i5, ' and the last line had ', i5/ '
     +on it.     ...we''ll go on without the names.  you fix that.'/)
      doname = 0
      go to 4000

4600  close (3)
      return
      end
************************************************************************
      subroutine qdata (iprog, level, qlevel, taxon, qtaxon, datum, 
     +datafile,*)


      integer rawtab, doname, mixtab, exmix, 
     +filtyp, exraw, inline(10), taxon(147),
     +qtaxon(147)

      real level(180), qlevel(180), datum(180,147),
     +rlline(10)

      logical qsums, qcalcs, rewrit

      character*1 aqline(80), aqlist(14)
      character*14 aqhold
      character*30 datafile	

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

# 772 "" 2
      nqline = 0
      nqlevs = 0
      nqtaxa = 0
c      open (1,file=datafile)
c      open (1)
      open (1,file= 'calpalyn.data')

3001  nqline = nqline + 1
      if (filtyp .eq. 10) go to 3003
      read (1,3002,err=3190,end=3300) alevel, (inline(i), rlline(i), i=1
     +,7)
3002  format (f7.0,3x,7(i5,f5.0))
      go to 3100
3003  read (1,3004,err=3190,end=3300) alevel, (inline(i),rlline(i),i=1,
     +10)
3004  format (3x, f4.0, 10(i3,f4.0))

      if (nqline .gt. 1 .and. alevel .eq. level(iiilev)) go to 3120
3100  if (alevel .ne. 0.0) go to 3110
      do 3101 i=1,filtyp
      if (inline(i) .ne. 0) go to 3110
3101  if (rlline(i) .ne. 0.0) go to 3192
      nqline = nqline - 1
      go to 3001

3110  if (nqlevs .eq. 0) go to 3112
      do 3111 i=1,nqlevs
      iiilev = i
3111  if (alevel .eq. level(i)) go to 3120
3112  nqlevs = nqlevs + 1
      if (nqlevs .gt. 180) go to 3193
      level(nqlevs) = alevel
      iiilev = nqlevs

3120  do 3124 i=1,filtyp
      if (inline(i) .lt. -9000 .and. rlline(i) .ne. 0.0) go to 3191
      if (rlline(i) .eq. 0.0) go to 3124
      if (inline(i) .eq. 0) go to 3192
      if (nqtaxa .eq. 0) go to 3122
      do 3121 j=1,nqtaxa
      iiitax = j
3121  if (inline(i) .eq. taxon(j)) go to 3123
3122  nqtaxa = nqtaxa + 1
      if (nqtaxa .gt. 120) go to 3194
      taxon(nqtaxa) = inline(i)
      iiitax = nqtaxa
3123  if (datum (iiilev,iiitax) .lt. 1e09) go to 3195
      datum (iiilev,iiitax) = rlline(i)
3124  continue

      go to 3001
*-----------------------------------------------------------------------
3180  format ('0bummer, there''s an error in your data file.'/'0we got t
     +o (non-empty) line ', i5, ' but will have to quit.'/)
3181  format (' we couldn''t read a number.'/)
3182  format (' are you sure you specified the right file format?'/' rem
     +ember, old files are automatically re-formatted to the new format.
     +'/)
3183  format (' you used a number more negative than -9000 for a taxon,
     +but these are reserved'/' for "taxa" we generate internally.  sorr
     +y.'/)
3184  format (' you used the number zero as a taxon number.  since unuse
     +d input fields in your'/' data file are read to us as a lot of "ta
     +xon number zero''s" with counts of zero'/' each, there is no way w
     +e can check for accidental double entries, so we can''t'/' allow z
     +ero for a taxon number.'/'0sorry.'/)
3185  format (' you have included more than ', i4, ' levels, the maximum
     + we can handle.'/)
3186  format (' you have included more than ', i3, ' taxa, the maximum w
     +e can handle.'/)
3187  format (' you have entered two counts for taxon ', i5, ' on level
     +', f10.4, '.'/)
3190  nnline = nqline + 1
      write (6,3180) nnline
      write (6,3181)
      if (nqline .eq. 0) write (6,3182)
      go to 3200
3191  write (6,3180) nqline
      write (6,3183)
      go to 3200
3192  write (6,3180) nqline
      write (6,3184)
      go to 3200
3193  write (6,3180) nqline
      write (6,3185) 180
      go to 3200
3194  write (6,3180) nqline
      write (6,3186) 120
      go to 3200
3195  write (6,3180) nqline
      write (6,3187) taxon(iiitax), level(iiilev)
3200  return 1
*-----------------------------------------------------------------------
3300  do 3302 i=1,nqlevs
      do 3301 j=1,nqtaxa
3301  if (datum(i,j) .gt. 1e09) datum(i,j) = 0.0
3302  continue

      rewrit = .false.
      if (filtyp .eq. 10) rewrit = .true.

      if (depfac .lt. 0.0) then
         do 3400 i=1,nqlevs-1
3400     if (level(i) .gt. level(i+1)) go to 3410
         else
         do 3401 i=1,nqlevs-1
3401     if (level(i) .lt. level(i+1)) go to 3410
         end if
      go to 3430

3410  rewrit = .true.
      do 3411 i=1,nqlevs
3411  qlevel(i) = level(i)
      do 3413 i = 1, (nqlevs - 1)
      do 3412 j = (i + 1), nqlevs
      if (depfac .lt. 0.0) then
         if (level(i) .lt. level(j)) go to 3412
         else
         if (level(i) .gt. level(j)) go to 3412
         end if
      rqhold = level(i)
      level(i) = level(j)
      level(j) = rqhold
3412  continue
3413  continue

      do 3422 i=1,nqlevs
      do 3421 j=1,nqlevs
      if (qlevel(j) .ne. level(i)) go to 3421
      if (j .eq. i) go to 3422
      rqhold = qlevel(i)
      qlevel(i) = qlevel(j)
      qlevel(j) = rqhold
      do 3420 ij=1,nqtaxa
      rqhold = datum(i,ij)
      datum(i,ij) = datum(j,ij)
3420  datum(j,ij) = rqhold
3421  continue
3422  continue

3430  do 3431 i=1,(nqtaxa - 1)
3431  if (taxon(i) .gt. taxon(i + 1)) go to 3440
      go to 3500

3440  rewrit = .true.
      do 3441 i=1,nqtaxa
3441  qtaxon(i) = taxon(i)
      do 3443 i = 1, (nqtaxa - 1)
      do 3442 j = (i + 1), nqtaxa
      if (taxon(i) .lt. taxon(j)) go to 3442
      iqhold = taxon(i)
      taxon(i) = taxon(j)
      taxon(j) = iqhold
3442  continue
3443  continue

      do 3452 i=1,nqtaxa
      do 3451 j=1,nqtaxa
      if (qtaxon(j) .ne. taxon(i)) go to 3451
      if (j .eq. i) go to 3452
      iqhold = qtaxon(i)
      qtaxon(i) = qtaxon(j)
      qtaxon(j) = iqhold
      do 3450 ij=1,nqlevs
      rqhold = datum(ij,i)
      datum(ij,i) = datum(ij,j)
3450  datum(ij,j) = rqhold
3451  continue
3452  continue

*500  if (.not. rewrit) go to 3600
3500  go to 3600
35000 continue
      rewind 1
      do 1 i=8,10
1     aqline(i) = ' '
      do 3513 i=1,nqlevs
      write (aqhold, '(f14.6)') level(i)
      read (aqhold, '(14a1)') aqlist
      do 3501 j=1,7
      if (aqlist(j) .eq. ' ') then
            go to 3501
         else if (aqlist(j) .eq. '0') then
            aqlist(j) = ' '
         else if (aqlist(j) .eq. '-' .and. aqlist(j+1) .eq. '0') then
            aqlist(j) = ' '
            aqlist(j+1) = '-'
         else
            go to 2
         end if
3501  continue
2     do 3 j=14,7,-1
      last = j
3     if (aqlist(j) .ne. '0' .and. aqlist(j) .ne. '.') go to 3502
3502  ifrst = last - 6
      do 3503 j=0,6
3503  aqline(j+1) = aqlist(ifrst+j)
      ispace = 1
      do 3512 j=1,nqtaxa
      if (datum(i,j) .eq. 0.0) then
         if (j .lt. nqtaxa) then
            go to 3512
            else
            go to 3509
            end if
         end if
      write (aqhold, '(i5)') taxon(j)
      read (aqhold, '(5a1)') (aqline(ij), ij=10*ispace+1,10*ispace+5)
      write (aqhold, '(f10.4, 4x)') datum(i,j)
      read (aqhold, '(14a1)') aqlist
      do 4 ij=1,4
      if (aqlist(ij) .eq. ' ') then
         go to 4
      else if (aqlist(ij) .eq. '0') then
         aqlist(ij) = ' '
      else if (aqlist(ij) .eq. '-' .and. aqlist(ij+1) .eq. '0') then
         aqlist(ij) = ' '
         aqlist(ij+1) = '-'
      else
         go to 3504
      end if
4     continue
3504  do 5 ij=10,5,-1
      last = ij
5     if (aqlist(ij) .ne. '0' .and. aqlist(ij) .ne. '.') go to 3505
3505  ifrst = last - 4
      do 3506 ij=0,4
3506  aqline(10*ispace+ij+6) = aqlist(ifrst+ij)
      ispace = ispace + 1
      if (ispace .lt. 8 .and. j .lt. nqtaxa) go to 3512
      if (ispace .eq. 8) go to 3511
3509  do 3510 ij=10*ispace+1,80
3510  aqline(ij) = ' '
3511  write (1,'(80a1)') aqline
      ispace = 1
3512  continue
3513  continue
      endfile (1)

3600  close (1)

      return
      end
************************************************************************
      subroutine vernam (which, taxon, instmx)

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

# 1019 "" 2

      integer rawtab, doname, mixtab, exmix,
     +filtyp, exraw, which, posn, instmx(120,10),taxon(147)

      logical qsums, qcalcs, italic

      max = nqtaxa
      if (which .eq. 2) max = nqtopl
      nrec8 = nqtaxa
      if (which .eq. 2) nrec8 = nrec8 + (16*nscrsr)
      iiitax = 0

 98   do 102 i=2,35,3
      iiitax = iiitax + 1
      if (iiitax .le. max) go to 99
      ispace = i
      go to 103
 99   if (which .eq. 1) go to 100
      posn = instmx(iiitax,1)
      go to 102
100   posn = iiitax
101   format (48a1)
102   read(8,101,rec=posn) (vqname(j,i),j=1,16), (vqname(j,i+1),j=1,16),
     +(vqname(j,i+2),j=1,16)
      go to 106

103   do 105 i=ispace,37
      do 104 j=1,16
104   vqname(j,i) = ' '
105   continue

106   do 1 i=2,37
      if (mod(i,3) .eq. 2) italic = .false.
      do 1 j=1,16
      if (.not. italic .and. vqname(j,i) .eq. '*') then
         italic = .true.
         vqname(j,i) = ' '
      else if (italic .and. vqname(j,i) .eq. '#') then
         italic = .false.
         vqname(j,i) = ' '
      end if
1     continue

      do 111 i=2,37
      do 107 j=1,16
107   if (vqname(j,i) .ne. ' ') go to 108
      go to 111
108   do 110 j=1,15
      if (vqname(16,i) .ne. ' ') go to 111
      do 109 ij=1,15
109   vqname(17-ij,i) = vqname(16-ij,i)
110   vqname(1,i) = ' '
111   continue

      do 113 i=1,16
112   format (37a1)
113   write (8,112,rec=(nrec8+i)) (vqname(i,j),j=1,37)

      nrec8 = nrec8 + 16
      if (iiitax .lt. max) go to 98
      return
      end
************************************************************************
      subroutine tables (datum, instmx, taxon, tablin)

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

# 1085 "" 2

      real datum(180,(147)), clcdat(5), tablin(147)

      integer rawtab, doname, mixtab, exmix, 
     +dofact, doplot, 
     +filtyp, exraw, instmx(120,10),taxon(147)

      logical qsums, qcalcs


      open (9, access='direct',recl=4*(147
     +))  

5000  do 5016 i=1,3
      if (regtab(i) .eq. 0 .and. exreg(i) .eq. 0) go to 5016
      nfac = instab(i,1) + 1
      do 5007 j=2,6
      instab(i,j) = iposn (instab(i,j), taxon)
      if (instab(i,1) .lt. 9) go to 5008
5007  continue
5008  do 5015 j=1,nqlevs
      if (instab(i,1) .lt. 9) go to 5012
      do 5009 ij=1,5
      if (instab(i,ij+1) .eq. 0) then
         clcdat(ij) = 0.0
         else
         clcdat(ij) = datum(j,instab(i,(ij+1)))
         end if
5009  continue
c     do 5011 ij = 1,nqtaxa
c5011  tablin(ij) = mycalc (datum (j,ij), clcdat)
      go to 5015
5012  if (instab(i,1) .lt. 2 .or. instab(i,2) .ne. 0) go to 5013
      regtab(i) = 0
      exreg(i) = 0
      write (6, 1111) i
1111  format ('0oops--  your normalization matrix ', i1, ' depends on a
     +taxon which your data file never'/' mentions.  we''ll have to can
     +that one.'/)
      go to 5016
5013  do 5014 ij=1,nqtaxa
      go to (10,11,12,13,14,15,16,17,18) nfac
10    tablin(ij) = datum(j,ij)
      go to 5014
11    tablin(ij) = datum(j,ij) * 100.0
      go to 5014
12    if (datum(j,instab(i,2)) .ne. 0.0) then
      tablin(ij) = datum(j,ij) / datum(j,instab(i,2))
      else
      tablin(ij) = 0.0
      end if
      go to 5014
13    if (datum(j,instab(i,2)) + datum(j,ij) .ne. 0.0) then
      tablin(ij) = datum(j,ij) / (datum(j,instab(i,2)) + datum(j,ij))
      else
      tablin(ij) = 0.0
      end if
      go to 5014
14    if (datum(j,instab(i,2)) - datum(j,ij) .ne. 0.0) then
      tablin(ij) = datum(j,ij) / (datum(j,instab(i,2)) - datum(j,ij))
      else
      tablin(ij) = 0.0
      end if
      go to 5014
15    if (datum(j,instab(i,2)) .ne. 0.0) then
      tablin(ij) = (datum(j,ij) / datum(j,instab(i,2))) * 100.0
      else
      tablin(ij) = 0.0
      end if
      go to 5014
16    if (datum(j,instab(i,2)) + datum(j,ij) .ne. 0.0) then
      tablin(ij) = (datum(j,ij) / (datum(j,instab(i,2)) + datum(j,ij)))
     +* 100.0
      else
      tablin(ij) = 0.0
      end if
      go to 5014
17    if (datum(j,instab(i,2)) - datum(j,ij) .ne. 0.0) then
      tablin(ij) = (datum(j,ij) / (datum(j,instab(i,2)) - datum(j,ij)))
     +* 100.0
      else
      tablin(ij) = 0.0
      end if
      go to 5014
18    tablin(ij) = datum(j,ij) * datum(j,instab(i,2))
5014  continue
5015  write (9,rec=((i-1)*180+j)) tablin
5016  continue

5050  if (mixtab+exmix+doplot .eq. 0) go to 6000
      do 5053 i=1,nqtopl
      do 5051 j=1,7
      if (j .eq. 2) go to 5051
      instmx(i,j) = iposn(instmx(i,j), taxon)
      if (instmx(i,2) .lt. 9 .and. j .eq. 3) go to 5052
5051  continue
5052  if (instmx(i,1) .gt. 0 .and. (instmx(i,2) .lt. 3 .or. instmx(i,2)
     +.gt. 8 .or. instmx(i,3) .ne. 0)) go to 5053
      write (6,2222) i
2222  format ('0item number ', i3, ' in your list of taxa and calculatio
     +ns for your plot, mixed'/' table or mixed spssx matrix refers to a
     + taxon (either the taxon to be plotted,'/' or one used for factori
     +ng) which never shows up in your data file, so'/' we have to abort
     +, since some diagram elements depend on position.'/)
      return 1
5053  continue
      do 5056 i=1,nqlevs
      do 5055 j=1,nqtopl
      if (instmx(j,2) .lt. 9) go to 5054
      do 3333 ij=3,7
      if (instmx(j,ij) .eq. 0) then
         clcdat(ij-2) = 0.0
         else
         clcdat(ij-2) = datum(i,instmx(j,ij))
         end if
3333  continue
c      tablin(j) = mycalc (datum(i,instmx(j,1)), clcdat)
      go to 5055
5054  nfac = instmx(j,2) + 1
      go to (20,21,22,23,24,25,26,27,28) nfac
20    tablin(j) = datum(i,instmx(j,1))
      go to 5055
21    tablin(j) = datum(i,instmx(j,1)) * 100.0
      go to 5055
22    if (datum(i,instmx(j,3)) .ne. 0.0) then
      tablin(j) = datum(i,instmx(j,1)) / datum(i,instmx(j,3))
      else
      tablin(j) = 0.0
      end if
      go to 5055
23    if (datum(i,instmx(j,3)) + datum(i,instmx(j,1)) .ne. 0.0) then
      tablin(j) = datum(i,instmx(j,1)) / (datum(i,instmx(j,3)) + datum(
     +i,instmx(j,1)))
      else
      tablin(j) = 0.0
      end if
      go to 5055
24    if (datum(i,instmx(j,3)) - datum(i,instmx(j,1)) .ne. 0.0) then
      tablin(j) = datum(i,instmx(j,1)) / (datum(i,instmx(j,3)) - datum(
     +i,instmx(j,1)))
      else
      tablin(j) = 0.0
      end if
      go to 5055
25    if (datum(i,instmx(j,3)) .ne. 0.0) then
      tablin(j) = (datum(i,instmx(j,1)) / datum(i,instmx(j,3))) * 100.0
      else
      tablin(j) = 0.0
      end if
      go to 5055
26    if (datum(i,instmx(j,3)) + datum(i,instmx(j,1)) .ne. 0.0) then
      tablin(j) = (datum(i,instmx(j,1)) / (datum(i,instmx(j,3)) + datum
     +(i,instmx(j,1)))) * 100.0
      else
      tablin(j) = 0.0
      end if
      go to 5055
27    if (datum(i,instmx(j,3)) - datum(i,instmx(j,1)) .ne. 0.0) then
      tablin(j) = (datum(i,instmx(j,1)) / (datum(i,instmx(j,3)) - datum
     +(i,instmx(j,1)))) * 100.0
      else
      tablin(j) = 0.0
      end if
      go to 5055
28    tablin(j) = datum(i,instmx(j,1)) * datum(i,instmx(j,3))
5055  continue
5056  write (9,rec=(3*180+i)) tablin

6000  return
      end
************************************************************************
      subroutine qprint (datum, level, tablin, instmx)

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

# 1259 "" 2

      real datum(180,(147)), level(180), rqline(12),
     +tablin(147)

      integer rawtab, doname, mixtab, exmix, 
     +filtyp, exraw, instmx(120,10)

      logical qsums, qcalcs, italic

      character*1 aqtemp, aqlone(160)
      character*4 aqline(24)
      character*160 aqlong

      write (20,7001) title
7001  format (///// 1x, a80// ' calpalyn universal pollen conversion and
     + graphics program'// ' palynology laboratory, university of califo
     +rnia at berkeley'// ' version 1.61')

      if (rawtab .eq. 0) go to 7030
      write (20,7010) title
7010  format ('1', 15x, a80// 16x, 'table of raw data')
      if (qsums .or. qcalcs) write (20,7011)
7011  format (/'0', 15x, 'including values generated by the program.')
      call writab (nscrsr, nqtaxa, 0, datum, level, tablin)

7030  do 7035 i=1,3
      if (regtab(i) .eq. 0) go to 7035
      write (20,7033) title, i
7033  format ('1', 15x, a80// 16x, 'table', i2, ' of normalized data')
      itype = instab(i,1) + 1
      go to (100,110,40,40,40,40,40,40,40,190) itype
40    read (8,50,rec=instab(i,2)) (aqline(j), j=1,12)
50    format (12a4)
      go to (400,400,120,130,140,150,160,170,180) itype

100   write (aqlong,101)
101   format (125x, 'each value is entered as raw data. ')
      go to 400
110   write (aqlong,111)
111   format (96x, 'each value is multiplied by one hundred, to mimic a
     +percentage. ')
      go to 400
120   write (aqlong,121) (aqline(j), j=1,12)
121   format (67x, 'each value is expressed as a fraction of', 3(1x,4a4)
     +,'. ')
      go to 400
130   write (aqlong,131) (aqline(j), j=1,12)
131   format (54x, 'each value is expressed as a fraction of its sum wit
     +h', 3(1x, 4a4), '. ')
      go to 400
140   write (aqlong,141) (aqline(j), j=1,12)
141   format (47x, 'each value is expressed as a fraction of its differe
     +nce from', 3(1x, 4a4), '. ')
      go to 400
150   write (aqlong,151) (aqline(j), j=1,12)
151   format (65x, 'each value is expressed as a percentage of', 3(1x,
     +4a4), '. ')
      go to 400
160   write (aqlong,161) (aqline(j), j=1,12)
161   format (52x, 'each value is expressed as a percentage of its sum w
     +ith', 3(1x, 4a4), '. ')
      go to 400
170   write (aqlong,171) (aqline(j), j=1,12)
171   format (45x, 'each value is expressed as a percentage of its diffe
     +rence from', 3(1x, 4a4), '. ')
      go to 400
180   write (aqlong,181) (aqline(j), j=1,12)
181   format (64x, 'each value is expressed as its product with', 3(1x,
     +4a4), '. ')
      go to 400
190   write (aqlong,191) (instab(line,j), j=2,6)
191   format (58x, 'each value is calculated using your subroutine and t
     +his input: ', 3(i5, ', '), i5, ', and ', i5, '. ')

400   read (aqlong, '(160a1)') (aqlone(j), j=1,160)
      italic = .false.
      do 401 j=1,160
      if (.not. italic .and. aqlone(j) .eq. '*') then
         italic = .true.
         aqlone(j) = ' '
      else if (italic .and. aqlone(j) .eq. '#') then
         italic = .false.
         aqlone(j) = ' '
      end if
401   continue
      length = 0
      aqtemp = aqlone(1)

      do 403 j=2,160
      if (aqtemp .eq. ' ' .and. (aqlone(j) .eq. ' ' .or. aqlone(j) .eq.
     +'.')) go to 403
      length = length + 1
      aqlone(length) = aqtemp
403   aqtemp = aqlone(j)

      if (length .gt. 115) go to 405
      do 404 j=(length+1),116
404   aqlone(j) = ' '

405   write (20,421) (aqlone(j), j=1,115)
421   format (15x, 115a1)
      call writab (nscrsr, nqtaxa, i, datum, level, tablin)
7035  continue

7050  if (mixtab .eq. 0) go to 8000
      write (20,7051) title
7051  format ('1', 15x, a80// 16x, 'mixed table (of independent normaliz
     +ations)'// 16x,'if a plot is constructed, it is based on this data
     +.'/)

      do 7052 i=1,nqtopl
      itype = instmx(i,2) + 1
      read (8,250,rec=instmx(i,1))  (aqline(j), j=1,12)
      go to (300,310,240,240,240,240,240,240,240,390) itype
240   read (8,250,rec=instmx(i,3))  (aqline(j), j=13,24)
250   format (12a4)
      go to (400,400,320,330,340,350,360,370,380) itype

300   write (aqlong,301) i, (aqline(j),j=1,12)
301   format (80x, i3, '.', 3(1x,4a4), ' is entered as raw data. ')
      go to 500
310   write (aqlong,311) i, (aqline(j), j=1,12)
311   format (51x, i3, '.', 3(1x,4a4), ' is multiplied by one hundred, t
     +o mimic a percentage. ')
      go to 500
320   write (aqlong,321) i, (aqline(j), j=1,12), (aqline(j),j=13,24)
321   format (22x, i3, '.', 3(1x,4a4), ' is expressed as a fraction of|'
     +, 4a4, 2(1x,4a4), '. ')
      go to 500
330   write (aqlong,331) i, (aqline(j), j=1,12), (aqline(j),j=13,24)
331   format (9x, i3, '.', 3(1x,4a4), ' is expressed as a fraction of it
     +s sum with|', 4a4, 2(1x,4a4), '. ')
      go to 500
340   write (aqlong,341) i, (aqline(j), j=1,12), (aqline(j),j=13,24)
341   format (2x, i3, '.', 3(1x,4a4), ' is expressed as a fraction of it
     +s difference from|', 4a4, 2(1x,4a4), '. ')
      go to 500
350   write (aqlong,351) i, (aqline(j), j=1,12), (aqline(j),j=13,24)
351   format (20x, i3, '.', 3(1x,4a4), ' is expressed as a percentage of
     +|', 4a4, 2(1x,4a4), '. ')
      go to 500
360   write (aqlong,361) i, (aqline(j), j=1,12), (aqline(j),j=13,24)
361   format (7x, i3, '.', 3(1x,4a4), ' is expressed as a percentage of
     +its sum with|', 4a4, 2(1x,4a4), '. ')
      go to 500
370   write (aqlong,371) i, (aqline(j), j=1,12), (aqline(j),j=13,24)
371   format (i3, '.', 3(1x,4a4), ' is expressed as a percentage of its
     +difference from|', 4a4, 2(1x,4a4), '. ')
      go to 500
380   write (aqlong,381) i, (aqline(j), j=1,12), (aqline(j),j=13,24)
381   format (19x, i3, '.', 3(1x,4a4), ' is expressed as its product wit
     +h|', 4a4, 2(1x,4a4), '. ')
      go to 500
390   write (aqlong,391) i, (aqline(j),j=13,24), (instmx(line,j), j=
     +3,7)
391   format (13x, i3, '.', 3(1x,4a4), ' is calculated using your subrou
     +tine and these taxa:|', 3(i5,', '), i5, ', and ', i5, '. ')

500   read (aqlong, '(160a1)') (aqlone(j), j=1,160)
      italic = .false.
      do 501 j=1,160
      if (.not. italic .and. aqlone(j) .eq. '*') then
         italic = .true.
         aqlone(j) = ' '
      else if (italic .and. aqlone(j) .eq. '#') then
         italic = .false.
         aqlone(j) = ' '
      end if
501   continue
      length = 0
      aqtemp = aqlone(1)

      do 503 j=2,160
      if (aqlone(j) .ne. '|') go to 502
      aqlone(j) = ' '
      lqline = length + 1
502   if (aqtemp .eq. ' ' .and. (aqlone(j) .eq. ' ' .or. aqlone(j) .eq.
     +'.')) go to 503
      length = length + 1
      aqlone(length) = aqtemp
503   aqtemp = aqlone(j)

      if (length .gt. 159) go to 505
      do 504 j=(length+1),160
504   aqlone(j) = ' '

505   if (length .lt. 133) lqline = length
      write (20,506) (aqlone(j), j=1,lqline)
506   format (' ', 132a1)
      if (length .lt. 133) go to 7052
      write (20,507) (aqlone(j), j=lqline+2,lqline+53)
507   format (41x, 51a1)
7052  continue

      call writab (nscrsm, nqtopl, 4, datum, level, tablin)

8000  return
      end
************************************************************************
      subroutine writab (nscrns, lqline, which, datum, level, tablin)

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

# 1461 "" 2

      real datum(180,(147)), level(180), rqline(12),
     +tablin(147)

      integer which, rawtab, doname, mixtab, exmix, 
     +filtyp, exraw

      logical qsums, qcalcs

      character*1 aqline(120)
      character*12 aqhold

      if (which .eq. 0) then
         nrec8 = nqtaxa
      else if (which .eq. 4) then
         nrec8 = nqtaxa + 16*nscrsr
         nrec9 = 3 * 180
      else
         nrec8 = nqtaxa
         nrec9 = (which - 1) * 180
      end if

      do 200 i=1,nscrns

      write (20,100)
100   format (////)
      do 102 j=1,16
      read (8,'(37a1)',rec=(16*(i-1) + j + nrec8)) (aqline(ij), ij=1,37)
101   format (4x, a1, 8x, 12(2x, a1, 1x, a1, 1x, a1, 3x))
102   write (20,101) (aqline(ij), ij=1,37)
      write (20,'(/)')

      do 150 j=1,nqlevs
      nempty = 0
      if (i .lt. nscrns) go to 111
      nempty = (12 * nscrns) - lqline

111   if (which .eq. 0) go to 113
      read (9,rec=(nrec9 + j)) tablin
      do 112 ij=1,(12-nempty)
112   rqline(ij) = tablin((12*(i-1))+ij)
      go to 115

113   do 114 ij=1,(12-nempty)
114   rqline(ij) = datum(j,((12*(i-1))+ij))

115   do 118 ij=1,(12-nempty)
      if (rqline(ij) .eq. 0.0) then
         aqhold = '    -       '
         read (aqhold, '(10a1, 2x)') (aqline(ijk), ijk=10*ij-9,10*ij)
      else if (rqline(ij) .le. 99999.9 .and. rqline(ij) .ge. 0.1) then
         write (aqhold, '(f9.3,'' '',2x)') rqline(ij)
         read (aqhold, '(10a1, 2x)') (aqline(ijk), ijk=10*ij-9,10*ij)
         do 116 ijk=10*ij-1,10*ij-4,-1
         if (aqline(ijk) .ne. '0' .and. aqline(ijk) .ne. '.') go to 117
116      aqline(ijk) = ' '
117      continue
      else
         write (aqhold, '(g10.4,2x)') rqline(ij)
         read (aqhold, '(10a1, 2x)') (aqline(ijk), ijk=10*ij-9,10*ij)
      end if
118   continue
      if (level(j) .eq. 0.0) then
         aqhold = '     000    '
      else
         write (aqhold, '(g12.6)') level(j)
      end if
      write (20, '(1x,a12,120a1)') aqhold,
     +(aqline(ij),ij=1,120-10*nempty)
150   if (mod(j,6) .eq. 0 .and. j .ne. nqlevs) write (20,'(/)')

200   continue

      return
      end

*********************************************************************
      subroutine dostbl (staxa, sdata, spct, taxon, datum,staxref)

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

# 1541 "" 2

      integer rawtab, doname, mixtab, exmix, 
     +filtyp, exraw, staxa(6),taxon(147),
     +staxref(6)

      real sdata(180,6),spct(180,6),
     +datum(180,147)


*------ load data for summary diagram---------------------------------


      do 40 i=1,isrep
      do 20 j=1,nqtaxa
      if (staxa(i) .eq. taxon(j)) go to 21

20    continue
21    staxref(i) = j
      do 30 k=1,nqlevs
      sdata(k,i) = datum(k,j)
30    continue
40    continue

*------- compute relative percentages--------------------------------

      do 80 k=1,nqlevs
      itemp = 0
      do 50 i=1,isrep
      itemp = itemp + sdata(k,i)
50    continue
      do 60 i=1,isrep
      sdata(k,i) =(sdata(k,i)/itemp)*100
60    continue

80    continue

      return
      end
******************************************************june 21 1985******
      subroutine qspssx (taxon, level, datum, instmx, qdatum, mixvar,
     +regvar)

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

# 1584 "" 2

      real datum(180,(147)), level(180), qdatum(147)

      integer rawtab, doname, mixtab, exmix, 
     +filtyp, exraw, taxon(147), instmx(120,7)

      logical qsums, qcalcs, italic

      character*1 name(54), chrnam(5), char(5)
      character*5 infil, posn(6), regvar(147), mixvar(120)

      data posn(1), posn(2), posn(3), posn(4), posn(5), posn(6)/
     +' 1-13', '14-26', '27-39', '40-52', '53-65', '66-78'/
     +char(1), char(2), char(3), char(4), char(5)/ 'r','a','b','c','m'/

*        write title & linkage lines, allow lower case:

      open (7,file = 'spssx') 
      write (7,10)
10    format ('title ''calpalyn export file for spss-x'''/'file handle e
     +xport name=''calpalyn spssxsf a'''/'set case=uplow')

*        insert comments to help user distinguish variables:

      if (exraw .eq. 1) write (7, '(''comment variables labeled "r" hold
     + raw data.'')')
      if (exreg(1) .eq. 1) write (7, '(''comment variables labeled "a" a
     +re normalized per first table.'')')
      if (exreg(2) .eq. 1) write (7, '(''comment variables labeled "b" a
     +re normalized per second table.'')')
      if (exreg(3) .eq. 1) write (7, '(''comment variables labeled "c" a
     +re normalized per third table.'')')
      if (exmix .eq. 1) write (7, '(''comment variables labeled "m" are
     +normalized per mixed table.'')')

*        calculate number of data records per case (1 extra for level):

      nrecs1 = nqtaxa / 6
      if (mod(nqtaxa,6) .gt. 0) nrecs1 = nrecs1 + 1
      nrecs2 = nqtopl / 6
      if (mod(nqtopl,6) .gt. 0) nrecs2 = nrecs2 + 1
      nrecs = ((exraw + exreg(1) + exreg(2) + exreg(3)) * nrecs1) +
     +(exmix * nrecs2) + 1

*        calculate number of variables:

      nvars = ((exraw + exreg(1) + exreg(2) + exreg(3)) * nqtaxa) +
     +(exmix * nqtopl)

*        set up and begin data list:

      write (7,'(''data list notable records='', i4/''   / sample 1-13 (
     +e)'')') nrecs

*        set up array(s) of taxon numbers in char form for var names:

      do 29 ii=1,2
      if ((ii.eq.1 .and. (exraw+exreg(1)+exreg(2)+exreg(3)).eq.0) .or.
     +(ii.eq.2 .and. exmix.eq.0)) go to 29
      if (ii .eq. 1) then
         ntodo = nqtaxa
      else
         ntodo = nqtopl
      end if
      do 29 i=1,ntodo
      if (ii .eq. 1) then
         write (infil, '(i5)') taxon(i)
      else
         write (infil, '(i5)') taxon(instmx(i,1))
      end if
      read (infil,'(5a1)') (chrnam(j), j=1,5)
      do 21 j=1,5
      if (chrnam(j) .eq. ' ') then
         chrnam(j) = '0'
      else if (chrnam(j) .eq. '-') then
         chrnam(j) = 'n'
      else
         go to 22
      end if
21    continue
22    write (infil, '(5a1)') (chrnam(j), j=1,5)
      if (ii .eq. 1) then
         read (infil, '(a5)') regvar(i)
      else
         read (infil, '(a5)') mixvar(i)
      end if
29    continue

*        finish data list:

      do 39 ii = 1,5
      if ((ii.eq.1.and.exraw.eq.0).or.(ii.eq.2.and.exreg(1).eq.0).or.
     +(ii.eq.3.and.exreg(2).eq.0).or.(ii.eq.4.and.exreg(3).eq.0).or.
     +(ii.eq.5.and.exmix.eq.0)) go to 39
      if (ii .lt. 5) then
         ntodo = nqtaxa
      else
         ntodo = nqtopl
      end if
      do 39 i = 1,ntodo
      j = mod(i,6)
      if (j .eq. 0) j = 6
      if (j .eq. 1) write (7, '(''   /'')')
      if (ii .lt. 5) then
         write (7, 31) char(ii), regvar(i), posn(j)
      else
         write (7, 31) char(ii), mixvar(i), posn(j)
      end if
31    format (3x, a1, a5, 1x, a5, ' (e)')
39    continue

*        set up for variable labels:

      write (7,'(''variable labels'')')

      do 49 ii=1,5
      if ((ii.eq.1.and.exraw.eq.0).or.(ii.eq.2.and.exreg(1).eq.0).or.
     +(ii.eq.3.and.exreg(2).eq.0).or.(ii.eq.4.and.exreg(3).eq.0).or.
     +(ii.eq.5.and.exmix.eq.0)) go to 49
      if (ii .lt. 5) then
         ntodo = nqtaxa
      else
         ntodo = nqtopl
      end if
      do 49 i=1,ntodo
      if (ii .lt. 5) then
         nrec = i
      else
         nrec = instmx(i,1)
      end if

*        fill name array with taxon name & extras for variable label:

      read (8,'(48a1)',rec=nrec) (name(j), j=1,16), (name(j), j=18,33),
     +(name(j), j=35,50)
      name(17) = ' '
      name(34) = ' '
      name(51) = '('
      name(52) = char(ii)
      name(53) = ')'
      name(54) = '"'
      italic = .false.

*        clean up any stray characters:

      do 41 j=1,50
      if (name(j) .eq. '"') then
         name(j) = ''''
      else if (name(j) .eq. '*' .and. .not. italic) then
         name(j) = ' '
         italic = .true.
      else if (name(j) .eq. '#' .and. italic) then
         name(j) = ' '
         italic = .false.
      end if
41    continue

*        condense the label, trim if necessary:

      do 44 j=1,50
42    if (name(j) .eq. ' ' .and. (name(j+1) .eq. ' ' .or. j.eq.1)) then
         do 43 ij=j,53
         name(ij) = name(ij+1)
         if (name(ij) .eq. '"') then
            name(ij+1) = ' '
            length = ij
            go to 42
         end if
43       continue
      else if (name(j) .eq. '"') then
         go to 45
      end if
44    continue
45    if (length .gt. 41) then
         name(38) = '('
         name(39) = char(ii)
         name(40) = ')'
         name(41) = '"'
      end if

*        write condensed label on spssx file:

      if (ii .lt. 5) then
         write (7, 46) char(ii), regvar(i), (name(j), j=1,41)
      else
         write (7, 46) char(ii), mixvar(i), (name(j), j=1,41)
      end if
46    format (3x, a1, a5, '  "', 41a1)
49    continue

*        write out data on spssx file:

      write (7,'(''begin data'')')
51    format (6e13.6)

      do 59 i=1,nqlevs
      write (7, 51) level(i)
      if (exraw .eq. 1) write (7,51) (datum(i,j), j=1,nqtaxa)
      if (exreg(1) .eq. 1) then
         nrec = i
         read (9, rec=nrec) qdatum
         write (7, 51) (qdatum(j), j=1,nqtaxa)
      end if
      if (exreg(2) .eq. 1) then
         nrec = 180 + i
         read (9, rec=nrec) qdatum
         write (7, 51) (qdatum(j), j=1,nqtaxa)
      end if
      if (exreg(3) .eq. 1) then
         nrec = 2*180 + i
         read (9, rec=nrec) qdatum
         write (7, 51) (qdatum(j), j=1,nqtaxa)
      end if
      if (exmix .eq. 1) then
         nrec = 3*180 + i
         read (9, rec=nrec) qdatum
         write (7, 51) (qdatum(j), j=1,nqtopl)
      end if
59    continue

*        wrap up the spssx file:

      write (7,'(''end data''/''save outfile=export''/''execute'')')
      close (7)

      return
      end
