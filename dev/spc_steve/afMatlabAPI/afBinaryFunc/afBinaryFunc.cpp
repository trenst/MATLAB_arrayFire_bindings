#include "afBinaryFunc.h"


DLL_PUBLIC void mexFunction(int nlhs, mxArray **plhs, int nrhs, const mxArray **prhs) {

	bool *isScalarAF( mxGetLogicals(prhs[2]) );
	std::string operationStr(mxArrayToString(prhs[3]));
	afCommon::opType operation = afCommon::opTypeMap.at(operationStr);


	af::array *out_ptr{nullptr};

	try {
#ifdef UNIFIED_BACKEND
		af::setBackend(afCommon::af_BACKEND);
		af::setDevice(afCommon::af_DEVICE);
		mexPrintf(af::infoString());
#endif
		if (!isScalarAF[0]) {
			mxUint64 *left_mx(mxGetUint64s(prhs[0]));
			af::array *left(reinterpret_cast<af::array*>(*left_mx));
			const mxArray *right_Mary = prhs[1];
			if (!isScalarAF[1]) {
				//array op array
				mxUint64 *right_mx{ mxGetUint64s(right_Mary) };
				af::array *right(reinterpret_cast<af::array*>(*right_mx));
				out_ptr = binary_op(left, right, operation);
			}
			else {
				bool isComplex = mxIsComplex(right_Mary);
				if (mxGetClassID(right_Mary) == mxSINGLE_CLASS) {
					if (isComplex) {
						//array op complex single scalar
						void *right = mxGetComplexSingles(right_Mary);
						out_ptr = binary_op(left, static_cast<af::cfloat*>(right), operation);
						mexPrintf("//array op complex single scalar\n");
					}
					else {
						//array op real single scalar
						float *right = mxGetSingles(right_Mary);
						out_ptr = binary_op(left, right, operation);
					}
				} else if (mxGetClassID(right_Mary) == mxDOUBLE_CLASS) {
					if (isComplex) {
						//array op complex double scalar
						void *right = mxGetComplexDoubles(right_Mary);
						out_ptr = binary_op(left, static_cast<af::cdouble*>(right), operation);
					}
					else {
						//array op real double scalar
						double *right = mxGetDoubles(right_Mary);
						out_ptr = binary_op(left, right, operation);
						mexPrintf("//array op real double scalar\n");
					}
				}
			}
		}
		else {
			mxUint64 *right_mx(mxGetUint64s(prhs[1]));
			af::array *right(reinterpret_cast<af::array*>(*right_mx));
			const mxArray *left_Mary = prhs[0];

			bool isComplex = mxIsComplex(left_Mary);
			if (mxGetClassID(left_Mary) == mxSINGLE_CLASS) {
				if (isComplex) {
					//complex single scalar op array
					void *left = mxGetComplexSingles(left_Mary);
					out_ptr = binary_op(static_cast<af::cfloat*>(left), right, operation);
				}
				else {
					//real single scalar op array
					float *left = mxGetSingles(left_Mary);
					out_ptr = binary_op(left, right, operation);
				}
			} else if (mxGetClassID(left_Mary) == mxDOUBLE_CLASS) {
				if (isComplex) {
					//complex double scalar op array
					void *left = mxGetComplexDoubles(left_Mary);
					out_ptr = binary_op(static_cast<af::cdouble*>(left), right, operation);
				}
				else {
					//real double scalar op array
					double *left = mxGetDoubles(left_Mary);
					out_ptr = binary_op(left, right, operation);
				}
			}

		}

	}
	catch (af::exception &exc) {
		std::vector<size_t> sz = { 1 };
		plhs[0] = refPointer2mxStruct(sz, true, true, nullptr);
		mexErrMsgIdAndTxt("MATLAB:afArray:afBinaryFunc", exc.what());
		return;
	}

	if (!out_ptr) {
		std::vector<size_t> sz = { 1 };
		plhs[0] = refPointer2mxStruct(sz, true, true, nullptr);
		mexErrMsgIdAndTxt("MATLAB:afArray:afBinaryFunc", "Only doubles and singles scalars"
			" are supported for afBinarayFunc\n");
		return;
	}

	plhs[0] = afAry2mxStruct(out_ptr);


}