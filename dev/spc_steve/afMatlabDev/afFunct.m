classdef afFunct < handle
   
    methods(Static)
        function out = approx2(in, pos0, pos1, method, offGrid)
            if (nargin < 3)
                error('approx2 requires at least 3 input parameters.')
            end
            if (nargin < 5)
                offGrid = 0.;
            end
            if (nargin <4)
                %{ 
                Possible values of method:
                AF_INTERP_NEAREST, AF_INTERP_LINEAR, AF_INTERP_BILINEAR,
                AF_INTERP_CUBIC, AF_INTERP_LOWER, AF_INTERP_LINEAR_COSINE,
                AF_INTERP_BILINEAR_COSINE, AF_INTERP_BICUBIC,
                AF_INTERP_CUBIC_SPLINE, AF_INTERP_BICUBIC_SPLINE
                %}      
                method = 'AF_INTERP_LINEAR';
            end
            %out = approx2_mex(in.prop.Pgpu, pos0.prop.Pgpu, pos1.prop.Pgpu, method, offGrid);
            out = afArray( approx2_mex(in.prop.Pgpu, pos0.prop.Pgpu, pos1.prop.Pgpu, method, offGrid) );
            %out = afArray(out);
            
        end
        function out = interp2()
            
            out = 0;
            
        end
    end
end


