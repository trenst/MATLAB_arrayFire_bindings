#include "approx2.h"

DLL_PUBLIC void mexFunction(int nlhs, mxArray **plhs, int nrhs, const mxArray **prhs) {

	mxUint64 *in_mx{ mxGetUint64s(prhs[0]) };
	mxUint64 *pos0_mx{ mxGetUint64s(prhs[1])};
	mxUint64 *pos1_mx{ mxGetUint64s(prhs[2]) };
	bool isAllocated = (*in_mx != 0) && (*pos0_mx != 0) && (*pos1_mx != 0);

	try {
#ifdef UNIFIED_BACKEND
		af::setBackend(afCommon::af_BACKEND);
		af::setDevice(afCommon::af_DEVICE);
		mexPrintf(af::infoString());
#endif
		if (isAllocated) {

			af::array *in( reinterpret_cast<af::array*>(*in_mx) );
			af::array *pos0(reinterpret_cast<af::array*>(*pos0_mx));
			af::array *pos1(reinterpret_cast<af::array*>(*pos1_mx));

			std::string itpType(mxArrayToString(prhs[3]));
			mxDouble *offGrid(mxGetDoubles(prhs[4]));
			af::interpType method = afCommon::interpTypeMap.at(itpType);

			af::array out = af::approx2(*in, *pos0, *pos1, method,
				static_cast<float>(*offGrid));

			af::array *out_ptr = new af::array(std::move(out));
			plhs[0] = afAry2mxStruct(out_ptr);

		}
		else {
			mexPrintf("approx2 called when no gpu Memory is allocated.");
			std::vector<size_t> sz = {1};
			plhs[0] = refPointer2mxStruct(sz, true, true, nullptr);
		}
	}

	catch (af::exception &exc) {
		mexPrintf("%s\n", exc.what());
		std::vector<size_t> sz = { 1 };
		plhs[0] = refPointer2mxStruct(sz, true, true, nullptr);
		return;
	}

	return;

}


