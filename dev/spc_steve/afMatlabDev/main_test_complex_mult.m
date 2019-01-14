clearvars;
close('all');
fclose('all');


Nrand = 5000;

m1 = rand(Nrand) + 1i*rand(Nrand);
m2 = rand(Nrand) + 1i*rand(Nrand);

tic
m3 = m1 * m2;
toc

