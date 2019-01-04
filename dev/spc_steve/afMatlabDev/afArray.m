classdef afArray < handle
    properties
        prop
    end    
    methods
%% Constructor -->  "overloaded" to take in an array or an afArray.prop struct
        function obj = afArray(array)
            if (isnumeric(array))
                sz = size(array);
                if (numel(sz) > 4)
                    error('ArrayFire cannot handle arrays with dimensions greater than 4.');
                end
                obj.prop = afHostMemToDeviceMem_mex(array);
            elseif (isstruct(array))
                if afArray.checkStruct(array)
                    obj.prop = array;
                else
                    error('\n%s\n', 'afArray property structure has invalid fields.');
                end
            else
                obj.prop.Pgpu = uint64(0);    
                error('\n%s\n', 'afArray can only be instantiated with either an array (doubles/singles) or a pointer struct.');
            end
        end
%% Copy memory from device to host.
        function out = getAFmem(obj)
            [out, obj.prop] = getAFmem_mex(obj.prop.Pgpu);
        end
%% Destructor
        function delete(obj)
            if (obj.prop.Pgpu)
                Pgpu = afDeleteArray_mex(obj.prop.Pgpu);
                obj.prop.Pgpu = Pgpu;
            else
                error('\n%s\n','Pointer for afArray is nullptr.');
            end
            if (Pgpu)
                error('\n%s\n','afArray was not proplerly deleted.');
            end
        end
        
%% Binary Operations
        function out = plus(af1, af2)      
            out = afArray.afBinaryFunc(af1, af2, 'plus');
        end
        function out = minus(af1, af2)
            out = afArray.afBinaryFunc(af1, af2, 'minus');
        end
        function out = times(af1, af2)
            out = afArray.afBinaryFunc(af1, af2, 'times');
        end
        function out = rdivide(af1, af2)
            out = afArray.afBinaryFunc(af1, af2, 'rdivide');
        end             
    end
    
    methods(Static)
        function af_struct = buildStruct(sz, dtype, isReal, Pgpu)
            fieldTypes = afArray.getFieldTypes();
            af_struct = struct(fieldTypes{1}, sz, fieldTypes{2}, dtype, fieldTypes{3}, isReal, fieldTypes{4}, Pgpu);
        end
        function valid = checkStruct(strct)
            fieldTypes = afArray.getFieldTypes();
            valid = all(isfield(strct, fieldTypes));
        end
        function fieldTypes = getFieldTypes()
            fieldTypes = {'sz', 'dtype', 'isReal', 'Pgpu'};
        end
        function out = afBinaryFunc(af1, af2, operation)
            isS = @(af) isscalar(af) && ~isa((af), 'afArray');
            isScalarAF = [isS(af1), isS(af2)];     
            isMArray = ~isscalar(af1)  || ~isscalar(af2);
            if isMArray
                error('afArray binary operations can only be performed on 2 afArray''s or on an afArray and a scalar');
            end
            if any(isScalarAF)
                if isScalarAF(1) 
                    out = afArray(afBinaryFunc_mex(af1, af2.prop.Pgpu, isScalarAF, operation));
                else
                    out = afArray(afBinaryFunc_mex(af1.prop.Pgpu, af2, isScalarAF, operation));
                end
            else
                out = afArray(afBinaryFunc_mex(af1.prop.Pgpu, af2.prop.Pgpu, isScalarAF, operation));
            end            
        end        
    end

end