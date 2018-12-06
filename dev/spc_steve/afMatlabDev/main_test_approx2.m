clearvars;
close('all');
fclose('all');


if (1)
    clear('afHostMemToDeviceMem_mex');
    clear('afDeleteArray_mex');
    clear('getAFmem_mex');
    clear('approx2_mex');
end


addpath(fullfile('..','Interp2'));

NptsX = 2;
NptsY = 2;

Xmax = 1;
Xmin = -Xmax;
Ymax = 1;
Ymin = -Ymax;
Xv = linspace(Xmin,Xmax,NptsX);
Yv = linspace(Ymin,Ymax,NptsY).';

rlprtProp = prtProp_C(Xv, Yv, [4, 7]);
Zv_rl = rlprtProp.gen_prt(Xv, Yv);

imagprtProp = prtProp_C(Xv, Yv, [9, 3]);
Zv_im = imagprtProp.gen_prt(Xv, Yv);

Zv = complex(Zv_rl, Zv_im);
[Xmesh, Ymesh] = meshgrid(Xv, Yv);

%{
figure
imagesc(Xv,Yv,real(Zv))
colorbar

figure
imagesc(Xv,Yv,imag(Zv))
colorbar
%}

%Nrand = 1000000;
szRand = [4, 1];
Xrand = (Xmax - Xmin)*rand(szRand) + Xmin;
Yrand = (Ymax - Ymin)*rand(szRand) + Ymin;
%Expand the points to interpolate to outside of the function to test
%zeroing out data
%Xrand = 1.1*Xrand;
%Yrand = 1.1*Yrand;    

[Xrand_1, Yrand_1] = scale_interp2_grid(Xmesh, Ymesh, Xrand, Yrand);

Zi = interp2(Zv, Xrand_1, Yrand_1, 'linear', 0.);
%Zi_hmmm = interp2(Xmesh, Ymesh, Zv, Xrand, Yrand, 'linear', 0.);

%diff_zmat = max(abs(Zi(:) - Zi_hmmm(:)))

ZvAF = afArray(Zv);

[Xrand_0, Yrand_0] = scale_interp2_grid(Xmesh, Ymesh, Xrand, Yrand, true);
XrandAF = afArray(Xrand_0);
YrandAF = afArray(Yrand_0);

ZiAF = afFunct.approx2(ZvAF, XrandAF, YrandAF);
Zi2 = ZiAF.getAFmem();

diffz = Zi - Zi2;

maxdiff = max(abs(diffz(:)))


%hmmm = afFunct.approx2(44, 22, 333)