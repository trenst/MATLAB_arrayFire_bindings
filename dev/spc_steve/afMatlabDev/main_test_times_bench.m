clearvars;
close('all');
fclose('all');


if (0)
    clear('afHostMemToDeviceMem_mex');
    clear('afDeleteArray_mex');
    clear('getAFmem_mex');
    clear('afBinaryFunc_mex');
end

szRand = [5000, 5000];
Nloop = 500;

r1 = rand(szRand);% + 1i * rand(szRand);
r2 = rand(szRand);% + 1i * rand(szRand);


%complex array times complex array benchmark.
a1 = r1;
a2 = r2;

t1 = tic;
for ind = 1:Nloop
   a1 = a1 .* a2; 
end
disp(['Multiplication seconds on CPU: ', num2str(toc(t1))]);

a1n = r1;
a2 = r2;
a1AF = afArray(a1n);
a2AF = afArray(a2);

t1 = tic;
for ind = 1:Nloop
   a1AF = a1AF .* a2AF; 
end
disp(['Multiplication seconds on GPU: ', num2str(toc(t1))]);

times_mex = a1AF.getAFmem();

diff = reshape(times_mex - a1, [],1);
max_diff = max(abs(diff))

absdiff = abs(diff);
%histogram(absdiff);

