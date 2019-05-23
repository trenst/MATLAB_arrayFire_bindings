#ifndef AFCOMMON_H
#define AFCOMMON_H


#include <functional>
#include "mex.h"
#include "arrayfire.h"
#include <map>

#ifdef __GNUC__
#define DLL_PUBLIC_AT __attribute__ ((visibility ("default")))
#define DLL_PUBLIC extern "C" DLL_PUBLIC_AT
#else
#define DLL_PUBLIC
#endif

//#define PRINTPOINTERDELETEINFO
#undef PRINTPOINTERDELETEINFO

//#define UNIFIED_BACKEND
#undef UNIFIED_BACKEND


namespace afCommon {
	const size_t dims_11[2]{ 1,1 };
	typedef long long int llint;
	typedef unsigned long long int ullint;
	std::map<std::string, af::interpType> interpTypeMap = {
		{ "AF_INTERP_NEAREST", AF_INTERP_NEAREST },
		{ "AF_INTERP_LINEAR", AF_INTERP_LINEAR },
		{ "AF_INTERP_BILINEAR", AF_INTERP_BILINEAR },
		{ "AF_INTERP_CUBIC", AF_INTERP_CUBIC },
		{ "AF_INTERP_LOWER", AF_INTERP_LOWER }
#if AF_API_VERSION >= 34
		,{ "AF_INTERP_LINEAR_COSINE", AF_INTERP_LINEAR_COSINE },
		{ "AF_INTERP_BILINEAR_COSINE", AF_INTERP_BILINEAR_COSINE },
		{ "AF_INTERP_BICUBIC", AF_INTERP_BICUBIC },
		{ "AF_INTERP_CUBIC_SPLINE", AF_INTERP_CUBIC_SPLINE },
		{ "AF_INTERP_BICUBIC_SPLINE", AF_INTERP_BICUBIC_SPLINE }
#endif
	};

static af::Backend af_BACKEND = AF_BACKEND_CUDA;
static int af_DEVICE = 0;

}



mxUint64 *refPointer2mxUint64(mxArray* &mary) {
    mary = mxCreateNumericArray(2, afCommon::dims_11, mxUINT64_CLASS, mxREAL);
    return mxGetUint64s(mary);
}

mxArray *refPointer2mxStruct(const std::vector<size_t> &sz, bool isDouble, bool isReal, void *Pgpu) {

	size_t size_4_size = (sz.size() == 1) ? 2 : sz.size();
	mxArray *sz_ary{ mxCreateDoubleMatrix(1, size_4_size, mxREAL) };
	mxDouble *sz_d{ mxGetDoubles(sz_ary) };
	for (size_t ii = 0; ii < sz.size(); ii++) {
		sz_d[ii] = static_cast<mxDouble>(sz.at(ii));
	}
	if (sz.size() == 1) {
		sz_d[1] = 1.;
	}

	std::string dtype = isDouble ? "double" : "single";

	mxArray *dtype_ary{ mxCreateString(dtype.c_str()) };
	mxArray *isReal_ary{ mxCreateLogicalScalar(isReal) };
	mxArray *Pgpu_ary;
	mxUint64 *Pgpu_uint64 = refPointer2mxUint64(Pgpu_ary);
	*Pgpu_uint64 = reinterpret_cast<mxUint64>(Pgpu);


	const char *fieldnames[] = {"sz", "dtype", "isReal", "Pgpu"};
	mxArray *mary{mxCreateStructMatrix(1,1,4,fieldnames)};
	mxSetField(mary, 0, fieldnames[0], sz_ary);
	mxSetField(mary, 0, fieldnames[1], dtype_ary);
	mxSetField(mary, 0, fieldnames[2], isReal_ary);
	mxSetField(mary, 0, fieldnames[3], Pgpu_ary);

	return mary;


}

mxArray *afAry2mxStruct(af::array *af_ptr) {

	dim_t *dim_sz = af_ptr->dims().get();
	std::vector<size_t> sz(dim_sz, dim_sz + af_ptr->numdims());
	return refPointer2mxStruct(sz, af_ptr->isdouble(), af_ptr->isreal(),
		static_cast<void*>(af_ptr)); 

}


#endif