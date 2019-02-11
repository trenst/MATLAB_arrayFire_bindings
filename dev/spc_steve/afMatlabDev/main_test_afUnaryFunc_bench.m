clearvars;
close('all');
fclose('all');


if (0)
    clear('afHostMemToDeviceMem_mex');
    clear('afDeleteArray_mex');
    clear('getAFmem_mex');
    clear('afBinaryFunc_mex');
    clear('afUnaryFunc_mex');
end


Nloop = 10;
szArray = [300, 3000, 3E4, 3E5, 3E6, 3E7, 3E8];
%szArray = 3E5;
runRatio = zeros( size(szArray)  );

for ss = 1:length(szArray)
    sz = szArray(ss);
    szRand = [sz, 1];
    a1 = (rand(szRand) - 0.5) * 10 * pi;
    memSize = prod(szRand) * 8 /1024/1024;
    fprintf('Memory size for array is %f MBytes.\n', memSize);
    
    start = tic;
  
    for ii=1:Nloop
    r1 = sin(a1);  
    end
    tocCPU = toc(start);
    
    fprintf('CPU runtime was %f seconds.\n', tocCPU);

    a1_AF = afArray(a1);

    start = tic;   

    for ii=1:Nloop        
    r1_AF = sin(a1_AF);
    end
    tocGPU = toc(start);

    fprintf('GPU runtime was %f seconds.\n', tocGPU);
    runRatio(ss) = tocCPU/tocGPU;

    fprintf('GPU runtime was %f times faster.\n', runRatio(ss));

    clearvars('a1');
    r2 = r1_AF.getAFmem();
    diff_all = r1 - r2;
    clearvars('r1', 'r2');
    
    maxDiff = max(abs( diff_all(:) ))
end