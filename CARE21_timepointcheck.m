EVALcheck = table();
IDdat = CARE21_subjinfo_GO;
evdat = EVALS_COMPL;

for i = 1:height(IDdat)
   ei = 0;
warning off
   IDi = IDdat.BASELINEEVALID(i);
EVALcheck.BASEID(i) = IDi;
EVALcheck.INJID(i) = IDdat.INJID(i);
%% EVAL COMPLETE CHECK -- ADD VARIABLE CHECK
    if ismember(IDi, evdat.baseline.BASELINEEVALID)
        ei = ei + 1;
    end
    
    if ismember(IDi, evdat.postinj.BASELINEEVALID)
        ei = ei + 2;
    end
    
    if ismember(IDi, evdat.twentyfour.BASELINEEVALID)
        ei = ei + 4;
    end
    
    if ismember(IDi, evdat.asympt.BASELINEEVALID)
        ei = ei + 8;
    end
    
    if ismember(IDi, evdat.unRTP.BASELINEEVALID)
        ei = ei + 16;
    end
    
    if ismember(IDi, evdat.sixmo.BASELINEEVALID)
       ei = ei + 32; 
    end
    
EVALcheck.EvalIdx(i) = ei;    
   
end
