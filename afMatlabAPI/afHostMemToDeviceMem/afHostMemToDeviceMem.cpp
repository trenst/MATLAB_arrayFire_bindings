// afHostMemToDeviceMem.cpp : Defines the exported functions for the DLL application.
//

#include "afHostMemToDeviceMem.h"


DLL_PUBLIC void mexFunction(int nlhs, mxArray **plhs, int nrhs, const mxArray **prhs) {

    mwSize NDim = mxGetNumberOfDimensions(prhs[0]);
    const mwSize *dim = mxGetDimensions(prhs[0]);
    std::vector<dim_t> dim_ts(NDim);
    bool isComplex = mxIsComplex(prhs[0]);

    for (mwSize ii = 0; ii < NDim; ii++) { 
        dim_ts.at(ii) = dim[ii];
    };

    af::dim4 dim4_ts(static_cast<unsigned int>(NDim), dim_ts.data());

    try {
#ifdef UNIFIED_BACKEND
		af::setBackend(afCommon::af_BACKEND);
		af::setDevice(afCommon::af_DEVICE);
#endif
        af::array *ref_a{ nullptr };
        bool supportedClass = false;
        if (mxGetClassID(prhs[0]) == mxDOUBLE_CLASS) {
            supportedClass = true;
            if (isComplex) {
                void *ptr_host = mxGetComplexDoubles(prhs[0]);
                ref_a = new af::array(dim4_ts, static_cast<af::cdouble*>(ptr_host));
            }
            else {
                mxDouble *ptr_host = mxGetDoubles(prhs[0]);
                ref_a = new af::array(dim4_ts, ptr_host);
            }            
        }
        if (mxGetClassID(prhs[0]) == mxSINGLE_CLASS) {
            supportedClass = true;
            if (isComplex) {
                void *ptr_host = mxGetComplexSingles(prhs[0]);
                ref_a = new af::array(dim4_ts, static_cast<af::cfloat*>(ptr_host));
            }
            else {
                mxSingle *ptr_host = mxGetSingles(prhs[0]);
                ref_a = new af::array(dim4_ts, ptr_host);
            }
        }
        
        if (!supportedClass) {
			std::vector<size_t> sz = { 1 };
			plhs[0] = refPointer2mxStruct(sz, true, true, nullptr);
			mexErrMsgIdAndTxt("MATLAB:afArray:afHostMemToDeviceMem", "The input array type is not supported.\n");
        }
        else {

			plhs[0] = afAry2mxStruct(ref_a);
        }
    }
    catch (af::exception &exc) {
		std::vector<size_t> sz = { 1 };
		plhs[0] = refPointer2mxStruct(sz, true, true, nullptr);
		mexErrMsgIdAndTxt("MATLAB:afArray:afHostMemToDeviceMem", exc.what());
    }

	return;

}