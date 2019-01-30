function [XX_11, YY_11, deltaX, deltaY] = scale_interp2_grid_initialize(XX, YY)

    [Ny, Nx] = size(XX);
    XX_11 = XX(1,1);
    YY_11 = YY(1,1);
    deltaX = (XX(1, end) - XX_11) / (Nx-1);
    deltaY = (YY(end, 1) - YY_11) / (Ny-1);

end