classdef afArray < handle
    properties
        prop
        %test_in
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
        
        %{
        function testInput1(obj, in)
            obj.test_in = in;
        end
        function [out] = testInput2(obj, in)
            obj.test_in = in;
            out = 999;
        end        
        function [out1, out2] = testInput3(obj, in1, in2)
            obj.test_in = {in1, in2};
            out1 = 999;
            out2 = in2;
        end
        %}
        
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
%% Indexing
        function varargout = subsref(obj, subs)
            if strcmp(subs(1).type,'.')
                if strcmp(subs(1).subs, 'prop')
                    varargout = cell(1);
                    if numel(subs) > 1
                        varargout{1} = obj.prop.(subs(2).subs);
                    else
                        varargout{1} = obj.prop;
                    end
                    return;
                end
                varargout = cell(nargout,1);                
                [varargout{:}] = builtin('subsref', obj, subs);
                return;
            end
            if numel(subs) > 1
                error('\n%s\n','afArray indexing cannot be perfomed in conjunction with other operations');
            end
            if strcmp(subs(1).type, '()')
                Nsubs = numel(subs.subs);
                Ndim = size(obj.prop.sz, 2);
                if (Ndim == 2) && any(obj.prop.sz == 1)
                    Ndim = 1;  % If obj.prop.sz is M x 1  or   1 x N, then the array in 1D.
                end
                varargout = cell(1);
                
                if Nsubs ~= Ndim
                    error('\n%s\n','afArray indexing api currently handles case when number of subscripts equals number of dimensions of array');
                end
                
                isSpan = false(Nsubs, 1);
                %to do
                %{
                isSeq = false(1, Nsubs);
                isArray = false(1, Nsubs);  % This will be an afArray.
                %}
                isScalar = false(Nsubs, 1);
                indsScalar = zeros(Nsubs, 1, 'int32');
                
                for ii = 1:Nsubs
                    sbb = subs.subs{ii};
                    if ischar(sbb) && strcmp(sbb, ':')
                        isSpan(ii) = true;                    
                    elseif isscalar(sbb)
                        indsScalar(ii) = sbb - 1;
                        isScalar(ii) = true;
                    else
                        error('\n%s\n','afArray indexing for now can only handle spanning of a diminision (i.e. '':'') or a scalar index');
                    end
                end
                
                if (all(isSpan))
                    error('\n%s\n','Don''t span all the dimensions... just use the array variable.');
                end
                
                struct_tmp = afIndexRef_mex(obj.prop.Pgpu, isSpan, isScalar, indsScalar);
                varargout{1} = afArray( struct_tmp );
                                
                
            else
                error('\n%s\n','afArray indexing uses parenthesis... obj(index)');
            end
            return;
        end
        function ind = end(obj, k, n)
            if n == numel(obj.prop.sz)
                ind = obj.prop.sz(k);
            else
                error('\n%s\n','afArray indexing api currently handles case when number of subscripts equals number of dimensions of array');
            end
            %todo...  code up case of linear (single subcripting) indexing.
            %That is...  n == 1
            %disp(n);
        end
    
    end


    methods(Static)
    %%Static Methods        
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