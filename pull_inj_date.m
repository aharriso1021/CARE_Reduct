injDate = table('Size', [height(CARE21_subjinfo_GO) 3],'VariableTypes', ["double","double","datetime"], 'VariableNames', ["BASEID","INJID","InjDate"]);  

CARE21_subjinfo_GO = sortrows(CARE21_subjinfo_GO, 'SUBJECTID');

for i = 1:height(CARE21_subjinfo_GO)
    injDate.BASEID(i) = CARE21_subjinfo_GO.BASELINEEVALID(i);
    dt = CARE21_injinfo.INJURYDATE(find(CARE21_injinfo.BASELINEEVALID == CARE21_subjinfo_GO.BASELINEEVALID(i)));
    iID = CARE21_injinfo.INJURYID(find(CARE21_injinfo.BASELINEEVALID == CARE21_subjinfo_GO.BASELINEEVALID(i)));
    if length(dt) == 1
        injDate.InjDate(i) = dt;
        injDate.INJID(i) = iID;
    elseif length(dt) > 1
        if days365(dt(1), dt(2)) >= 30
           injDate.InjDate(i) = dt(1);
           injDate.INJID(i) = iID(1);
        else
            injDate.InjDate(i) = NaT;
            injDate.INJID(i) = NaN;
        end
%     else
%         fprintf('Subj ID: %d \nNumber of injuries: %d \n', CARE21_subjinfo_GO.BASELINEEVALID(i), length(dt));
%         keyboard;
%         clc;
    end
    
end
   
      