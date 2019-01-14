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

sz = [1];

a1 = rand(sz);
a1AF = afArray(a1);
s1AF = a1AF(1);
s1 = s1AF.getAFmem();
t1 = a1(1);
sizeEqual = all(size(s1) == size(t1))
sizeEqual2 = all(size(s1) == s1AF.prop.sz)
diff_max = max(abs(s1(:) - t1(:)))
checkAll = checkAll && sizeEqual && sizeEqual2 && (diff_max == 0)

sz = [7, 1];
a1 = rand(sz);
a1AF = afArray(a1);
s1AF = a1AF(3);
s1 = s1AF.getAFmem();
t1 = a1(3);
sizeEqual = all(s1 == t1)
sizeEqual2 = all(size(s1) == s1AF.prop.sz)
diff_max = max(abs(s1(:) - t1(:)))
checkAll = checkAll && sizeEqual && sizeEqual2 && (diff_max == 0)


sz = [1, 7];
a1 = rand(sz);
a1AF = afArray(a1);
s1AF = a1AF(3);
s1 = s1AF.getAFmem();
t1 = a1(3);
sizeEqual = all(s1 == t1)
sizeEqual2 = all(size(s1) == s1AF.prop.sz)
diff_max = max(abs(s1(:) - t1(:)))
checkAll = checkAll && sizeEqual && sizeEqual2 && (diff_max == 0)


sz = [71, 19];
a1 = rand(sz);
a1AF = afArray(a1);
s1AF = a1AF(3);
s1 = s1AF.getAFmem();
t1 = a1(3);
sizeEqual = all(s1 == t1)
sizeEqual2 = all(size(s1) == s1AF.prop.sz)
diff_max = max(abs(s1(:) - t1(:)))
checkAll = checkAll && sizeEqual && sizeEqual2 && (diff_max == 0)




