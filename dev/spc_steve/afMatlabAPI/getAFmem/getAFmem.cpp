#include "getAFmem.h"


DLL_PUBLIC void mexFunction(int nlhs, mxArray **plhs, int nrhs, const mxArray **prhs) {

    mxUint64 *ref = mxGetUint64s(prhs[0]);
    bool isAllocated = (*ref != 0);


    mxUint64 *ref_out = refPointer2mxUint64(plhs[0]);


    try {
#ifdef UNIFIED_BACKEND
		af::setBackend(afM_BACKEND);
#endif
        if (isAllocated) {
            af::array *ref_a = reinterpret_cast<af::array*>(*ref);

			mexPrintf("ref_a backend: %d\n", af::getBackendId(*ref_a));

            mxClassID classID4mx = ref_a->isdouble() ? mxDOUBLE_CLASS : mxSINGLE_CLASS;
            mxComplexity complexity4mx = ref_a->iscomplex() ? mxCOMPLEX : mxREAL;
            size_t NDim = ref_a->numdims();
            af::dim4 dims = ref_a->dims();
            std::vector<size_t> dims_szt(NDim);
            for (unsigned int ii = 0; ii < NDim; ii++) { dims_szt.at(ii) = dims[ii]; }
            plhs[0] = mxCreateUninitNumericArray(NDim, dims_szt.data(), classID4mx, complexity4mx);
            void *p_host = mxGetData(plhs[0]);
            ref_a->host(p_host);
            *ref_out = reinterpret_cast<mxUint64>(ref_a);

        }
        else {
            mexPrintf("getAFmem called when no gpu Memory is allocated.");
        }
    }

    catch (af::exception &exc) {
        mexPrintf("%s\n", exc.what());
        return;
    }

}