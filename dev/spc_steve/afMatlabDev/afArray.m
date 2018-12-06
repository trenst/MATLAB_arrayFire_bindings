classdef afArray < handle
    properties
        prop
    end    
    methods
        function obj = afArray(array)
            if (isnumeric(array))
                sz = size(array);
                if (numel(sz) > 4)
                    error('ArrayFire cannot handle arrays with dimensions greater than 4.');
                end
                dtype = class(array);
                isReal = isreal(array);
                Pgpu = afHostMemToDeviceMem_mex(array);
                obj.prop = afArray.buildStruct(sz, dtype, isReal, Pgpu);
            elseif (isstruct(array))
                obj.prop = array;
            else
                error('afArray can only be instantiated with either an array or a pointer struct.');
            end
        end
        
        function out = getAFmem(obj)
            out = getAFmem_mex(obj.prop.Pgpu);
        end

        function delete(obj)            
            Pgpu = afDeleteArray_mex(obj.prop.Pgpu);
            obj.prop.Pgpu = Pgpu;
            if (Pgpu)
                disp('afArray was not proplerly deleted.');
            end
        end

    end
    methods(Static)
        function af_struct = buildStruct(sz, dtype, isReal, Pgpu)
            af_struct = struct('sz', sz, 'dtype', dtype, 'isReal', isReal, 'Pgpu', Pgpu);
        end
    end

end