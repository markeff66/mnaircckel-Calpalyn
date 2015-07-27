# 1 "" 
#1 "" 
**************************************************************************
*||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||*
************************************************************************
                                                                        
      subroutine dendro (nlevs, ymin, ymax, depth, yhite, depfac,       
     ~ veclen, izone, azone, bzone, level, level2, xscale, yscale)                      
                                                                        
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
     ~ tbxl(2), tbxr(2), tby(2), vec(80), xscale, yscale                       
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
                                                                        
999   continue                                                                        

                                                                        
      write(*,1001) nvecs
1001  format (I7)	
      call drawthatpup(vec,ivtype,nvecs,veclen,
     + yscale,xscale,ymin,yhite)

      return                                                            
      end                                                               
