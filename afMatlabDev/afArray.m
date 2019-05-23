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
            if nargout > 1
                error('\n%s\n','memory output from afArray can only be stored in one variable.  Incorrect number of outputs.');
            end
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
%% overloading MATLAB functions
        function varargout = size(obj, dim)
            varargout = cell(nargout,1);
            switch nargin
                case 1
                    if (nargout <= 1)
                        varargout{1} = obj.prop.sz;
                    else
                        varargout = num2cell(obj.prop.sz);
                    end
                case 2
                    [varargout{:}] = obj.prop.sz(dim);
                otherwise
                    error('\n%s\n','Improper call of afArray.size().');
            end
        end
        function bool = isreal(obj)
            bool = obj.prop.isReal;
        end
                
%% Unary Operations
        % Trigonometric Functions
        function out = sin(obj)
            out = afArray( afUnaryFunc_mex(obj.prop.Pgpu, 'sin') );
        end
        function out = asin(obj)
            out = afArray( afUnaryFunc_mex(obj.prop.Pgpu, 'asin') );
        end      
        function out = cos(obj)
            out = afArray( afUnaryFunc_mex(obj.prop.Pgpu, 'cos') );
        end   
        function out = acos(obj)
            out = afArray( afUnaryFunc_mex(obj.prop.Pgpu, 'acos') );
        end
        function out = tan(obj)
            out = afArray( afUnaryFunc_mex(obj.prop.Pgpu, 'tan') );
        end   
        function out = atan(obj)
            out = afArray( afUnaryFunc_mex(obj.prop.Pgpu, 'atan') );
        end
        % Hyperbolic Functions
        % ArrayFire Supports Real Inputs only to hyperbolic functions
        function out = sinh(obj)
            out = afArray( afUnaryFunc_mex(obj.prop.Pgpu, 'sinh') );
        end
        function out = asinh(obj)
            out = afArray( afUnaryFunc_mex(obj.prop.Pgpu, 'asinh') );
        end      
        function out = cosh(obj)
            out = afArray( afUnaryFunc_mex(obj.prop.Pgpu, 'cosh') );
        end   
        function out = acosh(obj)
            out = afArray( afUnaryFunc_mex(obj.prop.Pgpu, 'acosh') );
        end
        function out = tanh(obj)
            out = afArray( afUnaryFunc_mex(obj.prop.Pgpu, 'tanh') );
        end   
        function out = atanh(obj)
            out = afArray( afUnaryFunc_mex(obj.prop.Pgpu, 'atanh') );
        end
        % Complex Functions
        function out = conj(obj)
            out = afArray( afUnaryFunc_mex(obj.prop.Pgpu, 'conjg') );
        end 
        function out = real(obj)
            out = afArray( afUnaryFunc_mex(obj.prop.Pgpu, 'real') );
        end   
        function out = imag(obj)
            out = afArray( afUnaryFunc_mex(obj.prop.Pgpu, 'imag') );
        end  
        function out = ctranspose(obj)
            out = afArray( afUnaryFunc_mex(obj.prop.Pgpu, 'ctranspose') );
        end  
        function out = transpose(obj)
            out = afArray( afUnaryFunc_mex(obj.prop.Pgpu, 'transpose') );
        end  
        % Exponential and logarithmic functions
        function out = realsqrt(obj)
            % ArrayFire does not support sqrt of complex numbers
            out = afArray( afUnaryFunc_mex(obj.prop.Pgpu, 'sqrt') );
        end  
        function out = erf(obj)
            out = afArray( afUnaryFunc_mex(obj.prop.Pgpu, 'erf') );
        end
        function out = erfc(obj)
            out = afArray( afUnaryFunc_mex(obj.prop.Pgpu, 'erfc') );
        end   
        function out = exp(obj)
            out = afArray( afUnaryFunc_mex(obj.prop.Pgpu, 'exp') );
        end 
        function out = expm1(obj)
            out = afArray( afUnaryFunc_mex(obj.prop.Pgpu, 'expm1') );
        end  
        function out = factorial(obj)
            out = afArray( afUnaryFunc_mex(obj.prop.Pgpu, 'factorial') );
        end   
        function out = gamma(obj)
            out = afArray( afUnaryFunc_mex(obj.prop.Pgpu, 'tgamma') );
        end  
        function out = gammaln(obj)
            out = afArray( afUnaryFunc_mex(obj.prop.Pgpu, 'lgamma') );
        end    
        function out = log(obj)
            out = afArray( afUnaryFunc_mex(obj.prop.Pgpu, 'log') );
        end
        function out = log10(obj)
            out = afArray( afUnaryFunc_mex(obj.prop.Pgpu, 'log10') );
        end
        function out = log1p(obj)
            out = afArray( afUnaryFunc_mex(obj.prop.Pgpu, 'log1p') );
        end
        % Numeric Functions
        function out = angle(obj)
            out = afArray( afUnaryFunc_mex(obj.prop.Pgpu, 'arg') );
        end
        function out = abs(obj)
            out = afArray( afUnaryFunc_mex(obj.prop.Pgpu, 'abs') );
        end   
        function out = ceil(obj)
            out = afArray( afUnaryFunc_mex(obj.prop.Pgpu, 'ceil') );
        end    
        function out = floor(obj)
            out = afArray( afUnaryFunc_mex(obj.prop.Pgpu, 'floor') );
        end  
        function out = round(obj)
            out = afArray( afUnaryFunc_mex(obj.prop.Pgpu, 'round') );
        end                
%% Unary Operations Inplace
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
            % Deal with methods and properties here.
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
                    Ndim = 1;  % If obj.prop.sz is M x 1  or   1 x N, then the array is 1D.
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
                
                varargout{1} = afArray( afIndexRef_mex(obj.prop.Pgpu, isSpan, isScalar, indsScalar) );
                                                
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
            %is af a matlab scalar?
            isS = @(af) isscalar(af) && ~isa(af, 'afArray');
            isScalarAF = [isS(af1), isS(af2)];     
            %is af a matlab array?...  not a 1x1 scalar?
            isM = @(af) ~isscalar(af) && ~isa(af, 'afArray');
            if ( isM(af1)  || isM(af2) )
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