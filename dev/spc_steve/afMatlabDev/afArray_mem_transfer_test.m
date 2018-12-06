function maxdiff = afArray_mem_transfer_test(a1)

t1 = tic;
g1 = afArray(a1);
disp(['Time to transfer host->device: ', num2str(toc(t1))]);
g1.prop
t1 = tic;
a2 = g1.getAFmem();
disp(['Time to transfer device->host: ', num2str(toc(t1))]);
maxdiff = max(a1(:) - a2(:));
disp(['Maximum difference: ', num2str(maxdiff) ]);


end