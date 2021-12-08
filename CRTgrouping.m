function TBL_OUT = SUPPL_GROUPING(TBL_IN)
clc;
%% MAKES SURE TBL IS ALWAYS SORTED BY SAME FACTOR %% 
TBL_IN = sortrows(TBL_IN, 'SUBJECTID');
%% 
CRTidx = TBL_IN.SUPPLEMENTSCREATINE == 'Yes';
BCAidx = TBL_IN.SUPPLEMENTSPROTEIN == 'Yes';
SUPPLOTHR = TBL_IN.SUPPLEMENTSOTHER == 'Yes';
%%
if ~exist('si', 'var')
    si = 1;
    BTAidx = zeros([height(TBL_IN),1]);
    DHAidx = zeros([height(TBL_IN),1]);
 end
starti = si; 
BTAlist = {'Beta-Alanine' 'Beta Alanine' 'beta alanine' 'BETA-ALANINE' 'BETA ALANINE'};
DHAlist = {'FISH OIL' 'Fish Oil' 'fish oil' 'Cod Oil' 'COD OIL' 'KRILL OIL' 'Krill Oil'};
BCAlist = {'BCAAS' 'BCAA' 'bcaas' 'BRANCHED CHAIN AMINO ACIDS' 'Branched Chain Amino Acids' 'AMINO ACIDS' 'AMINOS' 'Protein' 'PROTEIN'};
CRTlist = {'CREATINE' 'Creatine' 'KRE ALKALYN' 'PREWORKOUT' 'Pre-Workout' 'PRE-WORKOUT' 'C4'};

for si = starti:height(TBL_IN)
    if SUPPLOTHR(si) == true
        if contains(TBL_IN.SUPPLEMENTSOTHERTXT(si), CRTlist)
            CRTidx(si) = 1;
        end
        if contains(TBL_IN.SUPPLEMENTSOTHERTXT(si), BTAlist)
            BTAidx(si) = 1;
        else
            fprintf('%s\n\n', TBL_IN.SUPPLEMENTSOTHERTXT(si));
            ui = input('Does list contain Beta-Alanine? '); clc;
            if ui == 1
                BTAidx(si) = 1;
            elseif ui == 99
                break
            end
        end
        if contains(TBL_IN.SUPPLEMENTSOTHERTXT(si), DHAlist)
            DHAidx(si) = 1;
        else
            fprintf('%s\n\n', TBL_IN.SUPPLEMENTSOTHERTXT(si));
            ui = input('Does list contain DHA/AHA? '); clc;
            if ui == 1
                DHAidx(si) = 1;
            elseif ui == 99
                break
            end
        end
        if contains(TBL_IN.SUPPLEMENTSOTHERTXT(si), BCAlist)
            BCAidx(si) = 1;
        else
            fprintf('%s\n\n', TBL_IN.SUPPLEMENTSOTHERTXT(si));
            ui = input('Does list contain BCAAs? '); clc;
            if ui == 1
                BCAidx(si) = 1;
            elseif ui == 99
                break
            end
        end
    end
end
TBL_OUT = addvars(TBL_IN, 
end

