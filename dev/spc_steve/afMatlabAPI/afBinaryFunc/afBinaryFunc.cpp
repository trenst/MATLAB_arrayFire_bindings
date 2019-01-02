#include "afBinaryFunc.h"

DLL_PUBLIC void mexFunction(int nlhs, mxArray **plhs, int nrhs, const mxArray **prhs) {

	mxUint64 *left_mx( mxGetUint64s(prhs[0]) );
	bool *isScalar( mxGetLogicals(prhs[2]) );
	std::string operation(mxArrayToString(prhs[3]));


	if (*isScalar) {


	}
	else {
		mxUint64 *right_mx{ mxGetUint64s(prhs[1]) };
		bool isAllocated = (*left_mx != 0) && (*right_mx != 0);

		if (isAllocated) {
			try {
#ifdef UNIFIED_BACKEND
				af::setBackend(afCommon::af_BACKEND);
				af::setDevice(afCommon::af_DEVICE);
				mexPrintf(af::infoString());
#endif
				af::array *left(reinterpret_cast<af::array*>(*left_mx));
				af::array *right(reinterpret_cast<af::array*>(*right_mx));
				af::array out;

				if (operation == "plus") out = *left + *right;				
				if (operation == "minus") out = *left - *right;				
				if (operation == "times") out = *left * *right;
				if (operation == "rdivide") out = *left / *right;
				if (operation == "power") out =  af::pow(*left,*right);

				af::array *out_ptr = new af::array(std::move(out));
				plhs[0] = afAry2mxStruct(out_ptr);

			}
			catch (af::exception &exc) {
				mexPrintf("%s\n", exc.what());
				std::vector<size_t> sz = { 1 };
				plhs[0] = refPointer2mxStruct(sz, true, true, nullptr);
				return;
			}
		}
		else {
			mexPrintf("afBinaryFunc called when no gpu Memory is allocated.");
			std::vector<size_t> sz = { 1 };
			plhs[0] = refPointer2mxStruct(sz, true, true, nullptr);
		}

	}


	



}