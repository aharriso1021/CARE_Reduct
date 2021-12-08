PI_dat = CARE21_postinj;
SI_dat = CARE21_subjinfo_GO;

for i = 1:height(PI_dat)
    if isnan(PI_dat.BASELINEEVALID(i))
        if ~ismember(PI_dat.INJURYID(i), SI_dat.INJID)
            PI_dat.SUBJECTID(i) = NaN;
        end
    else
       if ~ismember(PI_dat.BASELINEEVALID(i), SI_dat.BASELINEEVALID)
           PI_dat.SUBJECTID(i) = NaN;
       end
    end
    
end

CARE21_postinj_GO = PI_dat(~isnan(PI_dat.SUBJECTID),:);