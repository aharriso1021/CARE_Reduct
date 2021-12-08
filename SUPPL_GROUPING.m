function [supp_strct, si] = SUPPL_GROUPING(TBL_IN, si, supp_strct)
clc;
%% MAKES SURE TBL IS ALWAYS SORTED BY SAME FACTOR %% 
TBL_IN = sortrows(TBL_IN, 'SUBJECTID');
%% 

SUPPLOTHR = TBL_IN.SUPPLEMENTSOTHER == 'Yes';
%%
if si == 1
    starti = 1;
    supp_strct = struct();
    supp_strct.CRTidx = TBL_IN.SUPPLEMENTSCREATINE == 'Yes';
    supp_strct.BCAidx = TBL_IN.SUPPLEMENTSPROTEIN == 'Yes';
    supp_strct.BTAidx = zeros([height(TBL_IN),1]);
    supp_strct.DHAidx = zeros([height(TBL_IN),1]);
    supp_strct.CAFidx = zeros([height(TBL_IN),1]);
    supp_strct.PWKidx = zeros([height(TBL_IN),1]);
else
    starti = si;
end

BTAlist = {'Beta-Alanine' 'Beta Alanine' 'beta alanine' 'BETA-ALANINE' 'BETA ALANINE'};
DHAlist = {'FISH OIL' 'Fish Oil' 'fish oil' 'Cod Oil' 'COD OIL' 'KRILL OIL' 'Krill Oil' 'OMEGA-3' 'Omega-3'};
BCAlist = {'BCAAS' 'BCAA' 'bcaas' 'BRANCHED CHAIN AMINO ACIDS' 'Branched Chain Amino Acids' 'AMINO ACIDS' 'AMINOS' 'Protein' 'PROTEIN' 'BOOST' 'Boost'...
    'Glutamine' 'GLUTAMINE' 'Lysine' 'LYSINE' 'ARGININE'};
CRTlist = {'CREATINE' 'Creatine' 'KRE ALKALYN'};
PWKlist = {'PREWORKOUT' 'Pre-Workout' 'PRE-WORKOUT' 'PRE WORKOUT' 'C4' 'NO-EXPLODE' 'NO-XPLODE' 'HYDE'};
CAFlist = {'CAFFEINE' 'Caffeine' 'Tea' 'TEA'};

for si = starti:height(TBL_IN)
    if SUPPLOTHR(si) == true

        % CREATINE 
        if contains(TBL_IN.SUPPLEMENTSOTHERTXT(si), CRTlist)
            supp_strct.CRTidx(si) = 1;
        else
            fprintf('%s\n\n', TBL_IN.SUPPLEMENTSOTHERTXT(si));
            ui = input('Does list contain Creatine? '); clc;
            if ui == 1
                supp_strct.CRTidx(si) = 1;
            elseif ui == 99
                break
            end     
        end
        % BETA-ALANINE
        if contains(TBL_IN.SUPPLEMENTSOTHERTXT(si), BTAlist)
            supp_strct.BTAidx(si) = 1;
        else
            fprintf('%s\n\n', TBL_IN.SUPPLEMENTSOTHERTXT(si));
            ui = input('Does list contain Beta-Alanine? '); clc;
            if ui == 1
                supp_strct.BTAidx(si) = 1;
            elseif ui == 99
                break
            end
        end
        % OMEGAS
        if contains(TBL_IN.SUPPLEMENTSOTHERTXT(si), DHAlist)
            supp_strct.DHAidx(si) = 1;
        else
            fprintf('%s\n\n', TBL_IN.SUPPLEMENTSOTHERTXT(si));
            ui = input('Does list contain DHA/AHA? '); clc;
            if ui == 1
                supp_strct.DHAidx(si) = 1;
            elseif ui == 99
                break
            end
        end
        % BCAAs
        if contains(TBL_IN.SUPPLEMENTSOTHERTXT(si), BCAlist)
            supp_strct.BCAidx(si) = 1;
        else
            fprintf('%s\n\n', TBL_IN.SUPPLEMENTSOTHERTXT(si));
            ui = input('Does list contain BCAAs? '); clc;
            if ui == 1
                supp_strct.BCAidx(si) = 1;
            elseif ui == 99
                break
            end
        end
        % PRE-WORKOUT
        if contains(TBL_IN.SUPPLEMENTSOTHERTXT(si), PWKlist)
            supp_strct.PWKidx(si) = 1;
        else
            fprintf('%s\n\n', TBL_IN.SUPPLEMENTSOTHERTXT(si));
            ui = input('Does list contain PRE-WORKOUT? '); clc;
            if ui == 1
                supp_strct.PWKidx(si) = 1;
            elseif ui == 99
                break
            end
        end
        % CAFFEINE
        if contains(TBL_IN.SUPPLEMENTSOTHERTXT(si), CAFlist)
            supp_strct.CAFidx(si) = 1;
        else
            fprintf('%s\n\n', TBL_IN.SUPPLEMENTSOTHERTXT(si));
            ui = input('Does list contain CAFFEINE? '); clc;
            if ui == 1
                supp_strct.CAFidx(si) = 1;
            elseif ui == 99
                break
            end
        end
        
    else

    end % SUPPL LIST LOOP
end % SUBJ LOOP
end

