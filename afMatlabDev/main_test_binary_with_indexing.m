clearvars;
close('all');
fclose('all');

if (0)
    clear('afHostMemToDeviceMem_mex');
    clear('afDeleteArray_mex');
    clear('getAFmem_mex');
    clear('afBinaryFunc_mex');
    clear('afIndexRef_mex');
end

checkAll = true;

sz = [34, 21, 29, 80];

a1 = rand(sz);

a2 = rand(sz);

a1AF = afArray(a1);
a2AF = afArray(a2);
[w1, w2, w3, w4] = size(a1AF);

t6 = 3+ size(a1AF);


%{
s1AF = a1AF(1,:,:,:) + a2AF(7,:,:,:);
s1 = s1AF.getAFmem();
t1 = a1(1,:,:,:) + a2(7,:,:,:);
equalSize = all(size(s1) == size(t1))
maxDiff = max(abs(s1(:) - t1(:)))
checkAll = checkAll && equalSize && (maxDiff == 0)

sz = [44,22,10];
a1 = rand(sz);
a2 = rand(sz(1:2));
a1AF = afArray(a1);
a2AF = afArray(a2);
s1AF = a1AF(:,:,3) ./ a2AF;
s1 = s1AF.getAFmem();
t1 = a1(:,:,3) ./ a2;
equalSize = all(size(s1) == size(t1))
maxDiff = max(abs(s1(:) - t1(:)))
checkAll = checkAll && equalSize && (maxDiff == 0)


sz = [44,22,10, 19];
a1 = rand(sz);
a1AF = afArray(a1);
s1AF = a1(3,4,2,2) - a1AF;
s1 = s1AF.getAFmem();
t1 = a1(3,4,2,2) - a1;
equalSize = all(size(s1) == size(t1))
maxDiff = max(abs(s1(:) - t1(:)))
checkAll = checkAll && equalSize && (maxDiff == 0)

%benchmark indexing
sz = [330,78450];
a1 = rand(sz);
Nloop = 10000;
t1 = tic;
for ii=1:Nloop
    tmp = a1(4,:);
end
disp(['Indexing seconds on CPU: ', num2str(toc(t1))]);
a1AF = afArray(a1);
t1 = tic;
for ii=1:Nloop
    tmpAF = a1AF(4,:);
end
disp(['Indexing seconds on GPU: ', num2str(toc(t1))]);
%}





