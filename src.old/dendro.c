************************************************************************
*||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||*
************************************************************************
                                                                        
      subroutine dendro (nlevs, ymin, ymax, depth, yhite, depfac,       
     ~ veclen, izone, azone, bzone, level, level2)                      
                                                                        
*  temporary, version 3.  k orvis, april 2 1987.                        
*  when called, draws in pollen zones, either at user-defined positions 
*  written at end of unit 2, or using output from zontem together with  
*  controls azone and bzone (for zones and subzones, respectively).     
*  can also draw dendrogram graphic or reverse "dendrogram shadow"      
*  graphic from zontem data.                                            
                                                                        
      common /params/ maxtax, maxlev                                    
                                                                        
*  written for maximum of 80 levels, to agree with zontem.              
*        izone: instrs line 23 items a through g,g.                     
*        vec, ivtype: vectors & zone/subzn flags from line 28 or zontem.
*        level: reference holding sample levels; 2 = trashable copy.    
*        xval: zontem output; xbase: left or right side of graphic.     
*        tbxx: top & bottom fillers for ends of graphic.                
                                                                        
      integer izone(10), ivtype(80)                                     
      real*4 level(maxlev), level2(maxlev), xval(80), xbase(80),        
     ~ tbxl(2), tbxr(2), tby(2), vec(80)                                
      character*1 lzone                                                 
                                                                        
*  control variables.  izon1, izon2 = line 23 items a & b respectively. 
                                                                        
      izon1 = izone(1)                                                  
      izon2 = izone(2)                                                  
                                                                        
*  read in zontem data (inter-group similarities as % of possible).     
                                                                        
      if (abs(izon1) .gt. 1) then                                       
         if (nlevs .gt. 80) return                                      
         do 1 i=1,(nlevs-1)                                             
            read (15,'(5x,e14.6)') xval(i)                              
            level2(i) = (level(i) + level(i+1)) / 2.0                   
1        continue                                                       
                                                                        
*  zone boundaries if from zontem data:                                 
                                                                        
         if (izon1 .gt. 1) then                                         
            splast = -1.0                                               
            istart = 1                                                  
            if (azone .eq. 0.0) then                                    
               bndry1 = 50.0                                            
            else if (azone .gt. 0.0) then                               
               bndry1 = azone                                           
            else                                                        
               istop = int(abs(azone))                                  
               do 15 i=1,istop                                          
                  bndry1 = 101.0                                        
                  do 10 j=1,(nlevs-1)                                   
                     if (xval(j).gt.splast .and. xval(j).lt.bndry1)     
     ~                bndry1 = xval(j)                                  
10                continue                                              
                  if (bndry1 .eq. 101.0) then                           
                     bndry1 = splast                                    
                     if (bzone .lt. 0.0) bzone = 0.0                    
                     go to 16                                           
                  end if                                                
                  splast = bndry1                                       
                  istart = i + 1                                        
15             continue                                                 
            end if                                                      
                                                                        
*  subzone boundaries as above:                                         
                                                                        
16          if (bzone .eq. 0.0) then                                    
               if (azone .eq. 0.0) then                                 
                  bndry2 = 66.6667                                      
               else                                                     
                  bndry2 = bndry1                                       
               end if                                                   
            else if (bzone .gt. 0.0) then                               
               bndry2 = max(bzone, bndry1)                              
            else                                                        
               istop = int(abs(bzone))                                  
               do 25 i=istart,istop                                     
                  bndry2 = 101.0                                        
                  do 20 j=1,(nlevs-1)                                   
                     if (xval(j).gt.splast .and. xval(j).lt.bndry2)     
     ~                bndry2 = xval(j)                                  
20                continue                                              
                  if (bndry2 .eq. 101.0) then                           
                     bndry2 = splast                                    
                     go to 26                                           
                  end if                                                
                  splast = bndry2                                       
25             continue                                                 
26          bndry2 = max(bndry1, bndry2)                                
            end if                                                      
         end if                                                         
      end if                                                            
                                                                        
*  parameters for zone divisions and zonation column; veclen=plot width.
                                                                        
      veclen = -1.8 - veclen                                            
      vecl2 = veclen + 1.0                                              
      xmess1 = veclen + 0.46                                            
      xmess2 = vecl2 + 0.22                                             
      if (izon2 .lt. 0) then                                            
         zonend = 0.0                                                   
         zend2 = 0.0                                                    
      else                                                              
         zonend = yhite                                                 
         zend2 = yhite                                                  
      end if                                                            
      nzon1 = 1                                                         
      nzon2 = 129                                                       
                                                                        
*  set up graphical frame of reference.                                 
                                                                        
      call area2d (3.5, yhite)                                          
      call angle (45.0)                                                 
      call messag (        'zone', 4 , (veclen+1.25),(yhite+0.14))      
*     call messag ('zonation', 8, (veclen+1.14), (yhite+0.14))          
*     if (izon1 .lt. 2) then                                            
*        call messag ('(by author)', 11, (veclen+1.44), (yhite+0.14))   
*     else                                                              
*        call messag ('(automated)', 11, (veclen+1.44), (yhite+0.14))   
*     end if                                                            
      if (abs(izon1) .eq. 1) then                                       
         call reset ('xname')                                           
         xmin = 0.0                                                     
         xmax = 100.0                                                   
      else                                                              
         call xticks (5)                                                
         xmin = 101.00                                                  
         xmax = -1.0                                                    
         call messag ('conslink', 8, 0.14, (yhite+0.14))                
         if (abs(izon2) .eq. 1) then                                    
            call xname ('percent possible similarity', 27)              
            call messag ('similarity', 10, 0.44, (yhite+0.14))          
            call messag ('curve', 5, 0.74, (yhite+0.14))                
         else                                                           
            call reset ('xname')                                        
            call messag ('dissimilarity', 13, 0.44, (yhite+0.14))       
            call messag ('dendrogram', 10, 0.74, (yhite+0.14))          
            do 30 i=1,nlevs                                             
               xval(i) = 100.0 - xval(i)                                
30          continue                                                    
            bndry1 = 100.0 - bndry1                                     
            bndry2 = 100.0 - bndry2                                     
         end if                                                         
                                                                        
*  set up frame for zontem results graphic (or dummy).                  
                                                                        
         do 35 i=1,nlevs-1                                              
            if (xval(i) .lt. xmin) xmin = xval(i)                       
            if (xval(i) .gt. xmax) xmax = xval(i)                       
35       continue                                                       
         xmin = 10.0 * aint(xmin/10.0)                                  
         if (amod(xmax,10.0) .gt. 0.0) xmax = xmax + 10.0               
         xmax = 10.0 * aint(xmax/10.0)                                  
         if (abs(izon2) .eq. 1) then                                    
            do 40 i=1,(nlevs-1)                                         
               xbase(i) = xmax                                          
40          continue                                                    
         else                                                           
            xval(nlevs) = xmax                                          
            do 45 i=1,nlevs                                             
               xbase(i) = xmin                                          
45          continue                                                    
         end if                                                         
      end if                                                            
      call reset ('angle')                                              
      call graf (xmin, 10.0, xmax, ymin, depth, ymax)                   
                                                                        
*  exit here for izon1 = 1.                                             
                                                                        
      if (izon1 .eq. 1) go to 999                                       
                                                                        
*  read in (exit if too many) or set up arrays for zone, subzone bounds.
                                                                        
      nvecs = 0                                                         
      iend = 1                                                          
      do 50 i=1,(nlevs-1)                                               
         if (izon1 .lt. 0) then                                         
            read (2,'(i1,1x,f7.0,1x,i1)') iend, vec(i), ivtype(i)       
            vec(i) = vec(i) * depfac                                    
            nvecs = i                                                   
            if (iend .gt. 0) go to 51                                   
         else if (abs(izon2) .eq. 1) then                               
            if (xval(i) .le. bndry2) then                               
               nvecs = nvecs + 1                                        
               vec(nvecs) = level2(i)                                   
               if (xval(i) .le. bndry1) then                            
                  ivtype(nvecs) = 1                                     
               else                                                     
                  ivtype(nvecs) = 2                                     
               end if                                                   
            end if                                                      
         else                                                           
            if (xval(i) .ge. bndry2) then                               
               nvecs = nvecs + 1                                        
               vec(nvecs) = level2(i)                                   
               if (xval(i) .ge. bndry1) then                            
                  ivtype(nvecs) = 1                                     
               else                                                     
                  ivtype(nvecs) = 2                                     
               end if                                                   
            end if                                                      
         end if                                                         
50    continue                                                          
51    if (iend .eq. 0) then                                             
         write (4,'(//'' you have listed too many zones.'')')           
         go to 999                                                      
      end if                                                            
                                                                        
*  iteration variables: top-to-bottom vs bottom-to-top zonation.        
                                                                        
      if (izon2 .lt. 0) then                                            
         istart = nvecs                                                 
         istop = 1                                                      
         istep = -1                                                     
      else                                                              
         istart = 1                                                     
         istop = nvecs                                                  
         istep = 1                                                      
      end if                                                            
                                                                        
*  zonation loop:                                                       
                                                                        
      xmess2 = xmess1 + .87                                             
      xmess1 = xmess1 + .75                                             
                                                                        
      do 60 i=istart,istop,istep                                        
      vecht = yposn(0.0, vec(i))                                        
                                                                        
*  draw zone:                                                           
      if (ivtype(i) .eq. 1) then                                        
         call thkcrv( 0.10)                                             
         call vector (0, vecht, (veclen+1),vecht,0)                     
         call reset ('thkcrv')                                          
c        call vector (xmess1,vecht,veclen,vecht,0)                      
c        call vector (3.5, vecht, veclen, vecht, 0)                     
         if (izon2 .lt. 0) then                                         
            hmess1 = (vecht - 0.07) - ((vecht - zonend) / 2.0)          
            hmess2 = (vecht - 0.07) - ((vecht - zend2) / 2.0)           
         else                                                           
            hmess1 = (vecht - 0.07) + ((zonend - vecht) / 2.0)          
            hmess2 = (vecht - 0.07) + ((zend2 - vecht) / 2.0)           
         end if                                                         
         lzone = char(nzon2)                                            
         if (i .eq. istart ) then                                       
*           if (ivtype(i+istep)  .eq. 1) then                           
            call intno (nzon1,  xmess1, hmess2)                         
*           else                                                        
*              call intno (nzon1, xmess1, hmess2)                       
*              call messag (lzone, 1, xmess2, hmess2)                   
*           endif                                                       
*        else if (i .eq. istop) then                                    
*           if (lzone .eq. 'a') then                                    
*           call intno (nzon1, xmess1, hmess2)                          
*           else                                                        
*              call intno (nzon1, xmess1, hmess2)                       
*              call messag (lzone, 1, xmess2, hmess2)                   
*           endif                                                       
         else                                                           
            if (ivtype(i-istep) .eq. 1) then                            
               call intno (nzon1, xmess1, hmess2)                       
            else                                                        
               call intno (nzon1, xmess1, hmess2)                       
               call messag (lzone, 1, xmess2, hmess2)                   
            endif                                                       
         endif                                                          
         zonend = vecht                                                 
         zend2 = vecht                                                  
         nzon2 = 129                                                    
         nzon1 = nzon1 + 1                                              
                                                                        
*  draw subzone:                                                        
                                                                        
      else                                                              
         call dash                                                      
         call vector (0, vecht, (veclen+1),vecht, 0)                    
c        call vector (xmess1, vecht,veclen,vecht, 0)                    
c        call vector (1.5, vecht, veclen,vecht, 0)                      
         call reset ('dash')                                            
         if (izon2 .lt. 0) then                                         
            hmess2 = (vecht - 0.07) - ((vecht - zend2) / 2.0)           
         else                                                           
            hmess2 = (vecht - 0.07) + ((zend2 - vecht) / 2.0)           
         end if                                                         
         lzone = char(nzon2)                                            
         call intno (nzon1, xmess1,hmess2)                              
         call messag (lzone, 1, xmess2, hmess2)                         
                                                                        
         zend2 = vecht                                                  
         if (nzon2 .eq. 137) then                                       
            nzon2 = 145                                                 
         else if (nzon2 .eq. 153) then                                  
            nzon2 = 162                                                 
         else if (nzon2 .eq. 169) then                                  
            nzon2 = 129                                                 
         else                                                           
            nzon2 = nzon2 + 1                                           
         end if                                                         
      end if                                                            
60    continue                                                          
                                                                        
*  finish up trailing segments:                                         
                                                                        
      if (izon2 .lt. 0) then                                            
         hmess1 = (yhite - 0.07) - (yhite - zonend) / 2.0               
         hmess2 = (yhite - 0.07) - (yhite - zend2) / 2.0                
      else                                                              
         hmess1 = zonend / 2.0 - 0.07                                   
         hmess2 = zend2 / 2.0 - 0.07                                    
      end if                                                            
      lzone = char(nzon2)                                               
      if (nzon2 .eq. 129) then                                          
         call intno (nzon1, xmess1, hmess2)                             
      else                                                              
         call messag (lzone, 1, xmess2, hmess2)                         
         call intno (nzon1, xmess1, hmess2)                             
      endif                                                             
*  exit if no zontem graphic is called for.                             
                                                                        
      if (izon1 .eq. -1) go to 999                                      
                                                                        
*  draw inter-group percent-of-possible-similarity curve:               
                                                                        
      if (abs(izon2) .eq. 1) then                                       
         call shdpat (45120)                                            
         call vector (0.0, 0.0, 3.5, 0.0, 0)                            
         call vector (3.5, 0.0, 3.5, yhite, 0)                          
         call vector (3.5, yhite, 0.0, yhite, 0)                        
         call curve (xval, level2, (nlevs-1), 0)                        
         call shdcrv (xval, level2, (nlevs-1), xbase, level2, (nlevs-1))
         call shdpat (45121)                                            
         tbxr(1) = xmax                                                 
         tbxr(2) = xmax                                                 
         tbxl(1) = xmin                                                 
         tbxl(2) = xval(1)                                              
         tby(1) = ymax                                                  
         tby(2) = level2(1)                                             
         call curve (tbxl, tby, 2, 0)                                   
         call shdcrv (tbxl, tby, 2, tbxr, tby, 2)                       
         tbxl(1) = xval(nlevs-1)                                        
         tbxl(2) = xmin                                                 
         tby(1) = level2(nlevs-1)                                       
         tby(2) = ymin                                                  
         call curve (tbxl, tby, 2, 0)                                   
         call shdcrv (tbxl, tby, 2, tbxr, tby, 2)                       
         call xnonum                                                    
         call xgraxs (xmin, 10.0, xmax, 3.5, ' ', -1, 0.0, yhite)       
         call reset ('xnonum')                                          
                                                                        
*  draw inter-group percent-of-possible-dissimilarity dendrogram:       
                                                                        
      else                                                              
*  transfer to trashable addresses, draw slightly lowered scale.        
         nlines = nlevs                                                 
         do 70 i=1,nlevs                                                
            level2(i) = level(i)                                        
70       continue                                                       
         call xgraxs (xmin, 10.0, xmax, 3.5, 'percent possible dissimila
     ~rity', 30, 0.0, -0.05)                                            
*  loop back to here:                                                   
75       xmin = 5.0e+15                                                 
*  find next lowest branch.                                             
         do 80 i=1,nlines                                               
            if (xval(i) .lt. xmin) then                                 
               xmin = xval(i)                                           
               ilevt = i                                                
            end if                                                      
80       continue                                                       
*  find bottom closure of particular low-branch group.                  
         do 85 i=(ilevt+1),nlines                                       
            if (xval(i) .gt. xval(ilevt)) then                          
               ilevb = i                                                
               go to 86                                                 
            end if                                                      
85       continue                                                       
*  draw dendrogram branch group.                                        
86       if (xval(ilevt) .gt. xbase(ilevt)) then                        
            do 90 i=ilevt,ilevb                                         
               call rlvec (xbase(i),level2(i),xval(ilevt),level2(i),0)  
90          continue                                                    
         end if                                                         
         call rlvec (xval(ilevt), level2(ilevt), xval(ilevt), level2    
     ~    (ilevb), 0)                                                   
*  reset address representing group, delete tributaries.                
         level2(ilevt) = (level2(ilevt) + level2(ilevb)) / 2.0          
         xbase(ilevt) = xval(ilevt)                                     
         xval(ilevt) = xval(ilevb)                                      
         if (ilevt .lt. nlines-1) then                                  
            do 95 i=ilevt+1,nlines                                      
               level2(i) = level2(i + (ilevb - ilevt))                  
               xbase(i) = xbase(i + (ilevb - ilevt))                    
               xval(i) = xval(i + (ilevb - ilevt))                      
95          continue                                                    
         end if                                                         
         nlines = nlines - (ilevb - ilevt)                              
*  loop if dendrogram incomplete.                                       
         if (nlines .gt. 1) go to 75                                    
*  finish up.                                                           
         call rlvec (xbase(1), level2(1), xval(1), level2(1), 0)        
      end if                                                            
                                                                        
*  get out.                                                             
                                                                        
      call orel (3.5, 0.0)                                              
999   call endgr (0)                                                    
                                                                        
      return                                                            
      end                                                               
