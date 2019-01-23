clearvars;
close('all');
fclose('all');

clear('afHostMemToDeviceMem_mex');
clear('afDeleteArray_mex');
clear('getAFmem_mex');


N = 10000;
sz = [N, N];

maxdiff = 0;

Ncycle = 5;

for ii=1:Ncycle
    a1 = rand(sz);
    %Test double Real
    fprintf('\n\nDouble Real\n');
    maxdiff = max(afArray_mem_transfer_test(a1), maxdiff);

    a1_single = single(a1);
    %Test single Real
    fprintf('\n\nSingle Real\n');
    maxdiff = max(afArray_mem_transfer_test(a1_single), maxdiff);

    a1 = a1 + 1i*rand(sz);
    %Test double Complex
    fprintf('\n\nDouble Complex\n');
    maxdiff = max(afArray_mem_transfer_test(a1), maxdiff);

    a1_single = single(a1);
    %Test single Complex
    fprintf('\n\nSingle Complex\n');
    maxdiff = max(afArray_mem_transfer_test(a1_single), maxdiff);
end

fprintf('maxdiff is %f\n', maxdiff);




