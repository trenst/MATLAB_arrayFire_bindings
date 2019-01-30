function [xq1, yq1] = scale_interp2_grid(XX, YY, xq, yq, isZeroBasedIndexing)
%   scale_interp2_grid rescales the input query points so that 
%   the mesh grid indicies vary from 1:1:M, 1:1:N (Row, Col) where M, N is the
%   number of rows, cols (y, x).
%   Input:
%       XX:  x coordinate of the 2D grid (a matrix)
%       YY:  y coordinate of the 2D grid (a matrix)
%       xq:  x coordinate of the query point...  This can be an array or
%       matrix
%       yq:  y coordinate of the query point... this can be a matrix/array
%       isZeroBasedIndexing: boolean indicating if indicies start with 1
%           (Matlab) or 0 (C++).
%
%   Output:
%       xq1:  The scaled query points x coordinate (for all points inside grid, 1 <= xq1 < N).  
%                                                                            or 0 <= xq1 < N - 1
%       yq1:  The scaled query points y coordinate (for all points inside grid, 1 <= yq1 < M).
%                                                                            or 0 <= yq1 < M - 1
%
%  Assumptions that must be true:
%       XX, YY must be constructable by 
%       [XX, YY] = meshgrid(xx, yy)
%   where xx and yy are 1D vectors defining the grid points
%   The grid spacing must be constant although deltaX can
%   differ from deltaY.  xx and yy must be real increasing vectors
%   that are constructable by 
%       xx = minX : deltaX : maxX


    if (nargin==4)
        isZeroBasedIndexing = false;
    end
    
    [XX_11, YY_11, deltaX, deltaY] = scale_interp2_grid_initialize(XX, YY);
        
    xq1 = (xq - XX_11)/deltaX;
    yq1 = (yq - YY_11)/deltaY;       
    
    if ~isZeroBasedIndexing
        xq1 = xq1 + 1;
        yq1 = yq1 + 1;
    end

    
end
