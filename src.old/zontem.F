c**********************************************************************q
c
      subroutine zontem (nzone, nqlevs)
c
c  **** shortened algorithm tacked on to calpalyn version 1.60 ****
c  fortran 77, version of may 29 1979, as listed in appendix a of
c  birks, harry john betteley, and gordon, a d, numerical methods in
c  quaternary pollen analysis, academic press, london, 1985, pp 265-72.
c  transcribed by k. orvis march 21 1987 with expanded comments.
c
c  maximum of 80 samples, 18 pollen types.
c
c  input (unit 15):
c     line set(s) 1 (npol sets of lines, k=1,npol):
c  (20f4.0) (perct(k,i),i=1,nsam)
c     perct = counts in order down the core.
c
      integer t
      character*1 splurg
c
      common npol, nsam, perct(18,99),dc(5000),
     ~nbit(100), diag(100), splurg(100), least(100),
     ~ncount, nlev, nclust, tiny, huge, t(100), dend(100), prev
c
      npol = nzone
      nsam = nqlevs
      call prep
      call cslink
      return
      end
c
c**********************************************************************q
c||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||q
c**********************************************************************q
c
      subroutine prep
c
c  reads in the pollen counts, and carries out some preliminary
c  manipulations of the data.
c
      integer t
      character*1 splurg, bl
c
c
      common npol, nsam, perct(18,99),dc(5000),
     ~nbit(100), diag(100), splurg(100), least(100),
     ~ncount, nlev, nclust, tiny, huge, t(100), dend(100), prev
c
      data bl /' '/
c
c  read in pollen counts.
c
      do 1 i=1,npol
1     read (15,502) (perct(i,j),j=1,nsam)
502   format (13f6.0)

*** added to standardize pollen taxa:

      do 710 i=1,nsam
         do 705 j=1,npol
            if (i .eq. 1) diag(j) = 0.0
            diag(j) = diag(j) + perct(j,i)
705      continue
710   continue

      do 720 i=1,nsam
         do 715 j=1,npol
            perct(j,i) = perct(j,i) / diag(j)
715      continue
720   continue

*** end segment

c
c  convert data to proportions.
c
      do 3 j=1,nsam
       sum    = 0.0
      do 2 i=1,npol
2      sum    =  sum    + perct(i,j)
*** added to protect from zilch levels.
      if (sum .gt. 0.0) then
         x = 1.0 / sum
      else
         go to 3
      end if
      do 4 i=1,npol
4     perct(i,j) = x * perct(i,j)
3     continue
c
c  construct dissimilarity matrix for conslink.
c
      kk = 0
      do 5 i=2,nsam
      i1 = i - 1
      do 6 j=1,i1
      j1 = j + kk
      tot = 0.0
      do 7 k=1,npol
      x = perct(k,i) - perct(k,j)
7     tot = tot + abs(x)
6     dc(j1) = tot
5     kk = kk + i1
c
      return
c
c
      end
c
c**********************************************************************q
c||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||q
c**********************************************************************q
c
      subroutine cslink
c
c  carries out a constrained single link analysis of the data (see
c  section 3.3, birks and gordon 1985).
c
      integer t
      character*1 splurg
c
c
      common npol, nsam, perct(18,99),dc(5000),
     ~nbit(100), diag(100), splurg(100), least(100),
     ~ncount, nlev, nclust, tiny, huge, t(100), dend(100), prev
c
c  constrained single link analysis.
c
      rewind 15
      call setup
      nsam1 = nsam - 1
      do 1 number=1,nsam1
      call minim
      call group
      if (nclust - 1) 2, 2, 1
1     continue
2     continue
c
      return
c
601   format ('1results of conslink' //)
c
      end
c
c**********************************************************************q
c----------------------------------------------------------------------q
c
      subroutine setup
c
      integer t
      character*1 splurg, star, slash, blank
c
c
      common npol, nsam, perct(18,99),dc(5000),
     ~nbit(100), diag(100), splurg(100), least(100),
     ~ncount, nlev, nclust, tiny, huge, t(100), dend(100), prev
c
      data star, slash, blank /'*', '/', ' '/
c
c  preliminaries to constrained single link analysis.
c  (group boundaries held in the array nbit)
c
      huge = 0.0
      k = 0
      do 1 i=2,nsam
      i1 = i - 1
      t(i) = k
      k1 = k + 1
      ki1 = k + i1
      diag(i1) = dc(ki1)
      splurg(i1) = slash
      nbit(i1) = 0
      huge = huge + diag(i1)
1     k = ki1
      nbit(nsam) = 0
      prev = 0.0
      nclust = nsam
      nlev = 0
c
      return
      end
c
c**********************************************************************q
c----------------------------------------------------------------------q
c
      subroutine minim
c
      integer t
      character*1 splurg
c
c
      common npol, nsam, perct(18,99),dc(5000),
     ~nbit(100), diag(100), splurg(100), least(100),
     ~ncount, nlev, nclust, tiny, huge, t(100), dend(100), prev
c
c  identifies next amalgamation(s).
c
      nsam1 = nsam - 1
      ncount = 1
      least(1) = 1
      tiny = diag(1)
      do 1 i=2,nsam1
      if (tiny - diag(i)) 1, 2, 3
3     ncount = 1
      tiny = diag(i)
      least(1) = i
      go to 1
2     ncount = ncount + 1
      least(ncount) = i
1     continue
c
      return
      end
c
c**********************************************************************q
c----------------------------------------------------------------------q
c
      subroutine group
c
      integer t
      character*1 splurg, star, slash, blank
c
c
      common npol, nsam, perct(18,99),dc(5000),
     ~nbit(100), diag(100), splurg(100), least(100),
     ~ncount, nlev, nclust, tiny, huge, t(100), dend(100), prev
c
      data star, slash, blank /'*', '/', ' '/
c
c  carries out next amalgamation(s), updating arrays.
c
      do 8 i=1,ncount
      j = least(i)
      splurg(j) = star
      diag(j) = huge
      if (nbit(j)) 999, 2, 3
2     nbit(j) = 1
      j1 = j
      go to 5
3     nbit(j) = 0
      do 4 k=1,j
      j1 = j - k
      if(nbit(j1)) 999, 4, 5
4     continue
      go to 999
5     j11 = j1 - 1
      jj = j + 1
      if (nbit(jj)) 999, 12, 13
12    nbit(jj) = 1
      j2 = jj
      go to 15
13    nbit(jj) = 0
      nsamj = nsam - jj
      do 14 k=1,nsamj
      j2 = jj + k
      if (nbit(j2)) 999, 14, 15
14    continue
      go to 999
15    j21 = j2 + 1
      if (j11) 999, 21, 22
22    do 23 num=jj,j2
      iwt = t(num) + j11
      d = dc(iwt)
      if (d - diag(j11)) 24, 23, 23
24    diag(j11) = d
23    continue
21    if (j2 - nsam) 25, 1, 999
25    do 27 num=j1,j
      jwt = t(j21) + num
      d = dc(jwt)
      if (d - diag(j2)) 28, 27, 27
28    diag(j2) = d
27    continue
1     continue
      if (tiny - prev) 6, 7, 7
6     dend(j) = prev
      go to 8
7     dend(j) = tiny
8     continue
      nsam1 = nsam - 1
      nlev = nlev + 1
      nclust = nclust - ncount
c
c  detailed information on amalgamation(s).
c
      do 26 i=1,ncount
      j = least(i)
26    splurg(j) = blank
16    if (nclust - 1) 999, 31, 32
31    continue
c
c  print branches of single link dendrogram.
c
*** altered to print absolute percentage of possible similarity:

      varmax = 2.0

      do 9 i=1,nsam1
      dend(i) = (1.0 - dend(i) / varmax) * 100.0
9     write (15,605) i, dend(i), dend(i)
      varmax = 100.0
      write (15,605) nsam, varmax, varmax
*** end added segment.
      return
32    continue
      if (prev - tiny) 10, 10, 11
10    prev = tiny
11    continue
999   return
c
605   format (i4, 1x, e14.6, f7.2)
c
      end
