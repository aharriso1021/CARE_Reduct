%%--------------------------------------------------------------------------------------------------------------------------%%
%                                                     CARE_cleaning                                                          %
%%--------------------------------------------------------------------------------------------------------------------------%%
clear; clc;
cd('H:\DATA\CARE21_mat\')
addpath(genpath(pwd));

%% 1. VERIFY INJURIES
if ~exist('CARE_SUPPL-1.INJVERIF.mat', 'file')
   load CARE21_data_raw.mat;
% LOAD RAW DATA SET
SUBJ_INFO = CARE21_subjinfo(:,1:height(CARE_baseline_dict));
    SUBJ_INFO(:,CARE_baseline_dict.xVariable == '1') = [];
INJR_INFO = CARE21_injinfo(:,1:height(CARE_injinfo_dict));
processing_compl_status = [];

% Initialize Variables
prci = 0;
VERIFY_INJ = nan([height(SUBJ_INFO) 1]);
INJRY_ID = nan([height(SUBJ_INFO) 1]);
INJRY_DT = NaT([height(SUBJ_INFO) 1]);
% 
    for subji = 1:height(CARE21_subjinfo)
        injIDX = find(INJR_INFO.BASELINEEVALID == SUBJ_INFO.BASELINEEVALID(subji));
        if ~isempty(injIDX) % ONLY GRABBING 1st INJURY
            VERIFY_INJ(subji) = 1;
            INJRY_ID(subji) = INJR_INFO.INJURYID(injIDX(1));
            INJRY_DT(subji) = INJR_INFO.INJURYDATE(injIDX(1));
        else
        end    
    end
SUBJ_INFO = addvars(SUBJ_INFO, INJRY_ID, INJRY_DT, 'After', 'BASELINEEVALID', 'NewVariableNames', {'INJRY_ID', 'INJURY_DATE'});
% CUT NON-INJURED
SUBJ_INFO(isnan(SUBJ_INFO.INJRY_ID),:) = [];
%
processing_compl_status{1} = 'Injury Verification';
clearvars injIDX VERIFY_INJ INJRY_DT INJRY_ID subji
save('CARE_SUPPL-1.INJVERIF.mat')
end % INJURY VERIFICATION

%% 2. GROUPING [SUPPLEMENTS]
if ~exist('CARE_SUPPL-2.GRPING.mat', 'file')
% LOAD INJVERIF DATA
    load CARE_SUPPL-1.INJVERIF.mat;
% INITIALIZE
si = 1;
SUPPL = [];
SUPPL_nSUMM = [];
prci = prci + 1;

while si < height(SUBJ_INFO)
[SUPPL, si] = SUPPL_GROUPING(SUBJ_INFO, si, SUPPL);
    keyboard;
end
%
CRTN = categorical(double(SUPPL.CRTidx));
BETA = categorical(double(SUPPL.BTAidx));
BCAA = categorical(double(SUPPL.BCAidx));
OMEGA = categorical(double(SUPPL.DHAidx));
PRWK = categorical(double(SUPPL.PWKidx));
CAFF = categorical(double(SUPPL.CAFidx));

% ADD LOGICAL GROUPINGS TO SUBJ INFO TBL
SUBJ_INFO = addvars(SUBJ_INFO, CRTN, BETA, BCAA, OMEGA, PRWK, CAFF, 'AFTER', 'INJRY_ID', 'NewVariableNames',...
    {'CRTN' 'BETA' 'BCAA' 'OMEGA' 'PRWK' 'CAFF'});
% SUMMARY COUNTS
SUPPL_nSUMM(prci).ProcStep = 'GRPING';
SUPPL_nSUMM(prci).nXSUP = sum(~any(SUBJ_INFO{:,[7:12]} == '1', 2));
SUPPL_nSUMM(prci).nCRTN = sum(SUBJ_INFO.CRTN == '1');
SUPPL_nSUMM(prci).nBCAA = sum(SUBJ_INFO.BCAA == '1');
SUPPL_nSUMM(prci).nBETA = sum(SUBJ_INFO.BETA == '1');
SUPPL_nSUMM(prci).nPRWK = sum(SUBJ_INFO.PRWK == '1');
SUPPL_nSUMM(prci).nOMEG = sum(SUBJ_INFO.OMEGA == '1');
SUPPL_nSUMM(prci).nCAFF = sum(SUBJ_INFO.CAFF == '1');
%
processing_compl_status{2} = 'Supplement Grouping';
clearvars si SUPPL CRTN BETA BCAA OMEGA PRWK CAFF
save('CARE_SUPPL-2.GRPING.mat');
end % GROUPING

%% APPLY EXCLUSION CRITERIA
if ~exist('CARE_SUPPL-3.EXCLD.mat', 'file')
    load CARE_SUPPL-2.GRPING.mat;
% INITIALIZE & DEF EXCL Criteria [_baseline_dict.EXCL]
excl_vars = CARE_baseline_dict.Variable([CARE_baseline_dict.EXCL{:}] == 1);
excl_summ = struct();
prci = prci + 1;
for xi = 1:length(excl_vars)
    excl_summ(xi).VARIABLE = excl_vars(xi);
        exclIdx = SUBJ_INFO.(excl_vars(xi)) == 'Yes';
    excl_summ(xi).nXSUP = sum(~any(SUBJ_INFO{:,[7:12]} == '1', 2) & exclIdx);
    excl_summ(xi).nCRTN = sum(SUBJ_INFO.CRTN == '1' & exclIdx);
    excl_summ(xi).nBCAA = sum(SUBJ_INFO.BCAA == '1' & exclIdx);
    excl_summ(xi).nBETA = sum(SUBJ_INFO.BETA == '1' & exclIdx);
    excl_summ(xi).nPRWK = sum(SUBJ_INFO.PRWK == '1' & exclIdx); 
    excl_summ(xi).nOMEG = sum(SUBJ_INFO.OMEGA == '1' & exclIdx);
    excl_summ(xi).nCAFF = sum(SUBJ_INFO.CAFF == '1' & exclIdx);
% CUT EXCLUDED
SUBJ_INFO(exclIdx,:) = []; 
end

% EXCL INJURIES PRIOR TO BASELINE
days_b2i = days(SUBJ_INFO.INJURY_DATE - SUBJ_INFO.EVALDATE);
    inj_prior = days_b2i < 1;
    excl_summ(xi+1).VARIABLE = "INJURY_PIOR_TO_BASELINE";
    excl_summ(xi+1).nXSUP = sum(~any(SUBJ_INFO{:,[7:12]} == '1', 2) & inj_prior);
    excl_summ(xi+1).nCRTN = sum(SUBJ_INFO.CRTN == '1' & inj_prior);
    excl_summ(xi+1).nBCAA = sum(SUBJ_INFO.BCAA == '1' & inj_prior);
    excl_summ(xi+1).nBETA = sum(SUBJ_INFO.BETA == '1' & inj_prior);
    excl_summ(xi+1).nPRWK = sum(SUBJ_INFO.PRWK == '1' & inj_prior); 
    excl_summ(xi+1).nOMEG = sum(SUBJ_INFO.OMEGA == '1' & inj_prior);
    excl_summ(xi+1).nCAFF = sum(SUBJ_INFO.CAFF == '1' & inj_prior);
% CUT EXCLUDED
SUBJ_INFO(inj_prior,:) = [];

% SUMMARY COUNTS
SUPPL_nSUMM(prci).ProcStep = 'EXCLUSION';
SUPPL_nSUMM(prci).nXSUP = sum(~any(SUBJ_INFO{:,[7:12]} == '1', 2));
SUPPL_nSUMM(prci).nCRTN = sum(SUBJ_INFO.CRTN == '1');
SUPPL_nSUMM(prci).nBCAA = sum(SUBJ_INFO.BCAA == '1');
SUPPL_nSUMM(prci).nBETA = sum(SUBJ_INFO.BETA == '1');
SUPPL_nSUMM(prci).nPRWK = sum(SUBJ_INFO.PRWK == '1');
SUPPL_nSUMM(prci).nOMEG = sum(SUBJ_INFO.OMEGA == '1');
SUPPL_nSUMM(prci).nCAFF = sum(SUBJ_INFO.CAFF == '1');
%
processing_compl_status{3} = 'Exclusion';
clearvars xi days_b2i exclIdx inj_prior
save('CARE_SUPPL-3.EXCLD.mat');

end % EXCLUSION