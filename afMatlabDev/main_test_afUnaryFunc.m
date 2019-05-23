clearvars;
close('all');
fclose('all');


if (0)
    clear('afHostMemToDeviceMem_mex');
    clear('afDeleteArray_mex');
    clear('getAFmem_mex');
    clear('afBinaryFunc_mex');
    clear('afUnaryFunc_mex');
end

for testSinglePrecision = [false, true]
    
    szRand = [4,8,3,44];
    a1 = (rand(szRand) - 0.5) * 10 * pi;
    if (testSinglePrecision)
        singleStr = 'single precision';
    else
        singleStr = 'double precision';
    end
    
    unFuncCell = {@sin, @cos};
    for cii = 1:length(unFuncCell)
        unFunc = unFuncCell{cii};
        max_diff = test_afUnaryFunc.run_test(a1, unFunc, testSinglePrecision);
        fprintf('%s maximum percent difference of %s() is %20.12e\n', singleStr, func2str(unFunc), max_diff);
    end
    
    
    a1 = (rand(szRand) - 0.5) * 2;
    unFuncCell = {@asin, @acos, @atan};
    for cii = 1:length(unFuncCell)
        unFunc = unFuncCell{cii};
        max_diff = test_afUnaryFunc.run_test(a1, unFunc, testSinglePrecision);
        fprintf('%s maximum percent difference of %s() is %20.12e\n', singleStr, func2str(unFunc), max_diff);
    end
    
    a1 = (rand(szRand) - 0.5) * 2 * 1;
    unFuncCell = {@sinh, @cosh, @tanh, @asinh, @acosh, @atanh, @tan};
    for cii = 1:length(unFuncCell)
        unFunc = unFuncCell{cii};
        if cii==5
            max_diff = test_afUnaryFunc.run_test((rand(szRand) + 1) * 20, unFunc);
        else
            max_diff = test_afUnaryFunc.run_test(a1, unFunc, testSinglePrecision);
        end
        
        fprintf('%s maximum percent difference of %s() is %20.12e\n', singleStr, func2str(unFunc), max_diff);
    end
    
    
    szRand = [198,33];
    a1 = complex( (rand(szRand) - 0.5) * 10 * pi, (rand(szRand) - 0.5) * 10 * pi);
    unFuncCell = {@conj, @real, @imag, @ctranspose, @transpose};
    for cii = 1:length(unFuncCell)
        unFunc = unFuncCell{cii};
        max_diff = test_afUnaryFunc.run_test(a1, unFunc, testSinglePrecision);
        fprintf('%s maximum percent difference of %s() is %20.12e\n', singleStr, func2str(unFunc), max_diff);
    end
    
    szRand = [4,8,3,44];
    a1 = (rand(szRand) - 0.5) * 2;
    unFuncCell = {@erf, @erfc, @exp, @expm1};
    for cii = 1:length(unFuncCell)
        unFunc = unFuncCell{cii};
        max_diff = test_afUnaryFunc.run_test(a1, unFunc, testSinglePrecision);
        fprintf('%s maximum percent difference of %s() is %20.12e\n', singleStr, func2str(unFunc), max_diff);
    end
    
    a1 = rand(szRand)*10 + 0.01;
    unFuncCell = {@realsqrt, @gamma, @gammaln, @log, @log10, @log1p};
    for cii = 1:length(unFuncCell)
        unFunc = unFuncCell{cii};
        max_diff = test_afUnaryFunc.run_test(a1, unFunc, testSinglePrecision);
        fprintf('%s maximum percent difference of %s() is %20.12e\n', singleStr, func2str(unFunc), max_diff);
    end
    
    
    szRand = [19,33,42,18];
    a1 = (rand(szRand)-0.5)*10 + 20i*(rand(szRand)-0.5);
    unFuncCell = {@angle, @abs};
    for cii = 1:length(unFuncCell)
        unFunc = unFuncCell{cii};
        max_diff = test_afUnaryFunc.run_test(a1, unFunc, testSinglePrecision);
        fprintf('%s maximum percent difference of %s() is %20.12e\n', singleStr, func2str(unFunc), max_diff);
    end
    
    szRand = [19,33,42,18];
    a1 = (rand(szRand)-0.5)*10;
    unFuncCell = {@floor, @ceil, @round};
    for cii = 1:length(unFuncCell)
        unFunc = unFuncCell{cii};
        max_diff = test_afUnaryFunc.run_test(a1, unFunc, testSinglePrecision);
        fprintf('%s maximum percent difference of %s() is %20.12e\n', singleStr, func2str(unFunc), max_diff);
    end
    
    a1 = randi(8,szRand);
    unFuncCell = {@factorial};
    for cii = 1:length(unFuncCell)
        unFunc = unFuncCell{cii};
        max_diff = test_afUnaryFunc.run_test(a1, unFunc, testSinglePrecision);
        fprintf('%s maximum percent difference of %s() is %20.12e\n', singleStr, func2str(unFunc), max_diff);
    end
    
end


