function MyMatlab1(InFile1, InFile2, InFile3, InFile4, ...
                          TimeLimitInSeconds, ScoringMethod, NetworkModel)
%MYMATLAB1 Version1 Script. This script generates solution1.txt
%
% Input Arguments:
% TimeLimitInSeconds and ScoringMethod are not used yet, the algorithm acts
% as it would for ScoringMethod = 0.
% InFile1: CON file
% InFile2: INL file
% InFile3: RAW file
% InFile4: ROP file


[mpc,contingencies] = convert2mpc(InFile3,InFile4,...
                                                   InFile2,InFile1);
try
    parpool(22)
catch M
    switch M.identifier
        case 'parallel:cluster:LocalProfileNumWorkersExceeded'
            disp(feature('numcores'))
            parpool(feature('numcores'))
        case 'parallel:convenience:ConnectionOpen'
            delete(gcp())
            parpool(feature('numcores'))
        otherwise
            rethrow(M)
    end
end
[mpcOPF, pfs] = solveSCOPF(mpc,contingencies);
create_solution1(mpcOPF,1)
create_solution2(pfs,contingencies,1)
end

