# include "afDeleteArray.h"

DLL_PUBLIC void mexFunction(int nlhs, mxArray **plhs, int nrhs, const mxArray **prhs) {


    mxUint64 *ref = mxGetUint64s(prhs[0]);
    bool isAllocated = (*ref != 0);

    
    mxUint64 *ref_out = refPointer2mxUint64(plhs[0]);
	*ref_out = 999999;


    try {
#ifdef UNIFIED_BACKEND
		af::setBackend(afCommon::af_BACKEND);
		af::setDevice(afCommon::af_DEVICE);
#endif

        if (isAllocated) {
            af::array *ref_a = reinterpret_cast<af::array*>(*ref);
#ifdef PRINTPOINTERDELETEINFO
            mexPrintf("Deleting pointer %llu.\n", *ref);
#endif
            delete ref_a;
            *ref_out = 0;
        }
        else {
            mexPrintf("afDeleteArray called when no gpu Memory is allocated.");
        }
    }

    catch (af::exception &exc) {
        mexPrintf("%s\n", exc.what());
        return;
    }

}