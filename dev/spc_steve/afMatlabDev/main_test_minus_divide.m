clearvars;
close('all');
fclose('all');


if (0)
    clear('afHostMemToDeviceMem_mex');
    clear('afDeleteArray_mex');
    clear('getAFmem_mex');
    clear('afBinaryFunc_mex');
end

szRand = [100, 679];
scalar = 6.334;
r1 = rand(szRand) + 1i * rand(szRand);
r2 = rand(szRand) + 1i * rand(szRand);
%r1 = 10000*r1;
%r2 = 10000*r2;

%Array minus array
a1 = r1;
a2 = r2;
%a2 = true;

minus_mat = a1 - a2;

a1AF = afArray(a1);
a2AF = afArray(a2);

minus_mexAF = a1AF - a2AF;
minus_mex = minus_mexAF.getAFmem();

max_diff = max(abs(reshape(minus_mat - minus_mex, [], 1)))

%double scalar minus array
a1 = 4.;
a2 = r2;

minus_mat = a1 - a2;

a2AF = afArray(a2);

minus_mexAF = a1 - a2AF;
minus_mex = minus_mexAF.getAFmem();

max_diff = max(abs(reshape(minus_mat - minus_mex, [], 1)))

%single scalar minus array
a1 = single(4.);
a2 = r2;

minus_mat = a1 - a2;

a2AF = afArray(a2);

minus_mexAF = a1 - a2AF;
minus_mex = minus_mexAF.getAFmem();

max_diff = max(abs(reshape(minus_mat - minus_mex, [], 1)))

%double complex scalar minus array
a1 = 4. + 2.8893i;
a2 = r2;

minus_mat = a1 - a2;

a2AF = afArray(a2);

minus_mexAF = a1 - a2AF;
minus_mex = minus_mexAF.getAFmem();

max_diff = max(abs(reshape(minus_mat - minus_mex, [], 1)))

%single complex scalar minus array
a1 = single(4. + 2.8893i);
a2 = r2;

minus_mat = a1 - a2;

a2AF = afArray(a2);

minus_mexAF = a1 - a2AF;
minus_mex = minus_mexAF.getAFmem();

max_diff = max(abs(reshape(minus_mat - minus_mex, [], 1)))

%double complex scalar minus single array

a1 = 4. + 2.8893i;
a2 = single(r2);

minus_mat = a1 - a2;
minus_mat2 = a1 - double(a2);
max_diff_mat_mat2 = max(abs(reshape(minus_mat - minus_mat2, [], 1)))

a2AF = afArray(a2);

minus_mexAF = a1 - a2AF;
minus_mex = minus_mexAF.getAFmem();

max_diff = max(abs(reshape(minus_mat - minus_mex, [], 1)))

max_diff_mex_mat2 = max(abs(reshape(minus_mat2 - minus_mex, [], 1)))


%array rdivide array
a1 = r1;
a2 = r2;
divide_mat = a1./a2;

a1AF = afArray(a1);
a2AF = afArray(a2);

divide_mexAF = a1AF ./ a2AF;
divide_mex = divide_mexAF.getAFmem();

max_diff = max(abs(reshape(divide_mat - divide_mex, [], 1)))

%array rdivide array
a1 = single(r1);
a2 = single(r2);
divide_mat = a1./a2;

a1AF = afArray(a1);
a2AF = afArray(a2);

divide_mexAF = a1AF ./ a2AF;
divide_mex = divide_mexAF.getAFmem();

max_diff = max(abs(reshape(divide_mat - divide_mex, [], 1)))

%array rdivide array
a1 = r1;
a2 = r2;
divide_mat = a1./a2;

a1AF = afArray(a1);
a2AF = afArray(a2);

divide_mexAF = a1AF ./ a2AF;
divide_mex = divide_mexAF.getAFmem();

max_diff = max(abs(reshape(divide_mat - divide_mex, [], 1)))

%complex double rdivide array
a1 = 2.2377423+ 2.6672373i;
a2 = r2;
divide_mat = a1./a2;

%a1AF = afArray(a1);
a2AF = afArray(a2);

divide_mexAF = a1 ./ a2AF;
divide_mex = divide_mexAF.getAFmem();

max_diff = max(abs(reshape(divide_mat - divide_mex, [], 1)))

