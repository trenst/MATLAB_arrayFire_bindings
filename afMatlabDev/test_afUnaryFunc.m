classdef test_afUnaryFunc < handle
    methods(Static)
        function max_diff = run_test(xx, unFunc, testSinglePrecision)
            if nargin == 2
                testSinglePrecision = false;
            end
            if testSinglePrecision
                xx = single(xx);
            end
            rslt1 = unFunc(xx);
            a1_AF = afArray(xx);
            rslt1_AF = unFunc(a1_AF);
            rslt2 = rslt1_AF.getAFmem();
            rslt_diff = rslt1 - rslt2;
            pcnt_diff = 2 .* rslt_diff ./ (rslt1 + rslt2);
            max_diff = max(abs(pcnt_diff(:)));            
        end
    end    
end