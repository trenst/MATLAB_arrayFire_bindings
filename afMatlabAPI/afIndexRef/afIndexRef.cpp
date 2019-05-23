#include "afIndexRef.h"

DLL_PUBLIC void mexFunction(int nlhs, mxArray **plhs, int nrhs, const mxArray **prhs) {

	mxUint64 *ref = mxGetUint64s(prhs[0]);
	bool *isSpan(mxGetLogicals(prhs[1]));
	bool *isScalar(mxGetLogicals(prhs[2]));
	mxInt32 *indsScalar(mxGetInt32s(prhs[3]));

	bool isAllocated = (*ref != 0);
	if (!isAllocated) {
		mexErrMsgIdAndTxt("MATLAB:afArray:afIndexRef", "afIndexRef called"
		" with no gpu memory allocated.");
		return;
	}



	size_t NDim = mxGetM(prhs[1]);

	std::vector<af::index> indv(NDim);

	for (size_t nn = 0; nn < NDim; nn++) {
		if (isSpan[nn]) {
			indv[nn] = af::index(af::span);
		}
		else if (isScalar[nn]) {
			indv[nn] = af::index(indsScalar[nn]);
		}
	}

	try {
		af::array *ary(reinterpret_cast<af::array*>(*ref));
		af::array *a_out;

		if (NDim == 1) {
			a_out = new af::array( (*ary)(indv[0]) );
		}
		else if (NDim == 2) {
			a_out = new af::array( (*ary)(indv[0], indv[1]) );
		}
		else if (NDim == 3) {
			a_out = new af::array( (*ary)(indv[0], indv[1], indv[2]) );
		}
		else if (NDim == 4) {
			a_out = new af::array( (*ary)(indv[0], indv[1], indv[2], indv[3]) );
		}
		 
		plhs[0] = afAry2mxStruct(a_out);

		return;
	
	}
	catch (af::exception &exc) {
		std::vector<size_t> sz = { 1 };
		plhs[0] = refPointer2mxStruct(sz, true, true, nullptr);
		mexErrMsgIdAndTxt("MATLAB:afArray:afIndexRef", exc.what());
		return;
	}


}