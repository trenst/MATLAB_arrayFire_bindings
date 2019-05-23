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

%Array plus array
a1 = r1;
a2 = single(r2);
plus_mat = a1 + a2;

a1AF = afArray(a1);
a2AF = afArray(a2);

plus_mexAF = a1AF + a2AF;
plus_mex = plus_mexAF.getAFmem();

max_diff = max(abs(reshape(plus_mat - plus_mex, [], 1)))

%Single Array plus single array
a1 = single(r1);
a2 = single(r2);
plus_mat = a1 + a2;

a1AF = afArray(a1);
a2AF = afArray(a2);

plus_mexAF = a1AF + a2AF;
plus_mex = plus_mexAF.getAFmem();

max_diff = max(abs(reshape(plus_mat - plus_mex, [], 1)))

%Array plus single array
a1 = r1;
a2 = single(r2);
plus_mat = a1 + a2;

a1AF = afArray(a1);
a2AF = afArray(a2);

plus_mexAF = a1AF + a2AF;
plus_mex = plus_mexAF.getAFmem();

max_diff = max(abs(reshape(plus_mat - plus_mex, [], 1)))

%real Array plus array
a1 = real(r1);
a2 = r2;
plus_mat = a1 + a2;

a1AF = afArray(a1);
a2AF = afArray(a2);

plus_mexAF = a1AF + a2AF;
plus_mex = plus_mexAF.getAFmem();

max_diff = max(abs(reshape(plus_mat - plus_mex, [], 1)))

%real Array plus scalar double
a1 = real(r1);
a2 = 6.;
plus_mat = a1 + a2;

a1AF = afArray(a1);

plus_mexAF = a1AF + a2;
plus_mex = plus_mexAF.getAFmem();

max_diff = max(abs(reshape(plus_mat - plus_mex, [], 1)))

%complex Array plus scalar single
a1 = r1;
a2 = single(6.);
plus_mat = a1 + a2;

a1AF = afArray(a1);

plus_mexAF = a1AF + a2;
plus_mex = plus_mexAF.getAFmem();

max_diff = max(abs(reshape(plus_mat - plus_mex, [], 1)))

%complex single Array plus scalar single
a1 = single(r1);
a2 = single(6.);
plus_mat = a1 + a2;

a1AF = afArray(a1);

plus_mexAF = a1AF + a2;
plus_mex = plus_mexAF.getAFmem();

max_diff = max(abs(reshape(plus_mat - plus_mex, [], 1)))

%complex Array plus scalar double
a1 = r1;
a2 = 6.;
plus_mat = a1 + a2;

a1AF = afArray(a1);

plus_mexAF = a1AF + a2;
plus_mex = plus_mexAF.getAFmem();

max_diff = max(abs(reshape(plus_mat - plus_mex, [], 1)))

%complex single Array plus scalar double
a1 = single(r1);
a2 = 6.;
plus_mat = a1 + a2;

a1AF = afArray(a1);

plus_mexAF = a1AF + a2;
plus_mex = plus_mexAF.getAFmem();

max_diff = max(abs(reshape(plus_mat - plus_mex, [], 1)))

%complex Array plus scalar complex double
a1 = r1;
a2 = 6.333  - 2939.445i;
plus_mat = a1 + a2;

a1AF = afArray(a1);

plus_mexAF = a1AF + a2;
plus_mex = plus_mexAF.getAFmem();

max_diff = max(abs(reshape(plus_mat - plus_mex, [], 1)))

%complex Array plus scalar complex single
a1 = r1;
a2 = single(6.333  - 2996.445i);
plus_mat = a1 + a2;

a1AF = afArray(a1);

plus_mexAF = a1AF + a2;
plus_mex = plus_mexAF.getAFmem();

diff_mat = plus_mat - single(plus_mex);
max_diff = max(abs(reshape(diff_mat, [], 1)))


%complex scalar double plus complex array
a1 = 2.12365 - 1.23658i;
a2 = r2;
plus_mat = a1 + a2;

a2AF = afArray(a2);

plus_mexAF = a1 + a2AF;
plus_mex = plus_mexAF.getAFmem();

max_diff = max(abs(reshape(plus_mat - plus_mex, [], 1)))

%real scalar double plus complex array
a1 = 2.12365;
a2 = r2;
plus_mat = a1 + a2;

a2AF = afArray(a2);

plus_mexAF = a1 + a2AF;
plus_mex = plus_mexAF.getAFmem();

max_diff = max(abs(reshape(plus_mat - plus_mex, [], 1)))

%real scalar single plus complex array
a1 = single(2.12365);
a2 = r2;
plus_mat = a1 + a2;

a2AF = afArray(a2);

plus_mexAF = a1 + a2AF;
plus_mex = plus_mexAF.getAFmem();

max_diff = max(abs(reshape(plus_mat - plus_mex, [], 1)))

%complex scalar single plus complex array
a1 = single(2.12365 - 2.399483i);
a2 = r2;
plus_mat = a1 + a2;

a2AF = afArray(a2);

plus_mexAF = a1 + a2AF;
plus_mex = plus_mexAF.getAFmem();

max_diff = max(abs(reshape(plus_mat - plus_mex, [], 1)))

%complex scalar double plus complex array
a1 = 2.12365 - 2.399483i;
a2 = single(r2);
plus_mat = a1 + a2;

a2AF = afArray(a2);

plus_mexAF = a1 + a2AF;
plus_mex = plus_mexAF.getAFmem();

max_diff = max(abs(reshape(plus_mat - plus_mex, [], 1)))


