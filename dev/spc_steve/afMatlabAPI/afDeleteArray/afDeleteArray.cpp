# include "afDeleteArray.h"

DLL_PUBLIC void mexFunction(int nlhs, mxArray **plhs, int nrhs, const mxArray **prhs) {


    mxUint64 *ref = mxGetUint64s(prhs[0]);
    bool isAllocated = (*ref != 0);

    
    mxUint64 *ref_out = refPointer2mxUint64(plhs[0]);


    try {
#ifdef UNIFIED_BACKEND
		af::setBackend(afM_BACKEND);
#endif

        if (isAllocated) {
            *ref_out = 0;
            af::array *ref_a = reinterpret_cast<af::array*>(*ref);
            mexPrintf("Deleting pointer %llu.\n", *ref);
			/*if (ref_a->isLocked()) {
				ref_a->unlock();
			}*/
            delete ref_a;
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