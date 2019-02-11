#include "afUnaryFunc.h"


DLL_PUBLIC void mexFunction(int nlhs, mxArray **plhs, int nrhs, const mxArray **prhs) {

	
	std::string funcStr(mxArrayToString(prhs[1]));
	mxUint64 *ref = mxGetUint64s(prhs[0]);
	bool isAllocated = (*ref != 0);
	plhs[0] = nullptr;

	try {
#ifdef UNIFIED_BACKEND
		af::setBackend(afCommon::af_BACKEND);
		af::setDevice(afCommon::af_DEVICE);
		mexPrintf(af::infoString());
#endif
		if (isAllocated) {

			af::array *ary(reinterpret_cast<af::array*>(*ref));
			std::function<af::array(af::array)> unFunc = afCommon::unFuncMap.at(funcStr);
			af::array a_out = unFunc(*ary);
			af::array *p_a_out = new af::array( std::move(a_out) );
			plhs[0] = afAry2mxStruct(p_a_out);

		}
		else{
			mexErrMsgIdAndTxt("MATLAB:afArray:afUnaryFunc",
				"afUnaryFunc called when no gpu Memory is allocated.");
		}

	}
	catch (af::exception &exc) {
		std::vector<size_t> sz = { 1 };
		plhs[0] = refPointer2mxStruct(sz, true, true, nullptr);
		mexErrMsgIdAndTxt("MATLAB:afArray:afUnaryFunc", exc.what());
		return;
	}


}