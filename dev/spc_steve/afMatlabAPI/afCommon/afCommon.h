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

#define PRINTTIMINGINFOFLAG
#define PRINTTIMINGKERNELINFOFLAG

//#define UNIFIED_BACKEND
#undef UNIFIED_BACKEND


namespace afCommon {
	const size_t dims_11[2]{ 1,1 };
	typedef long long int llint;
	typedef unsigned long long int ullint;
	std::map<std::u16string, af::interpType> interpTypeMap = {
		{ u"AF_INTERP_NEAREST", AF_INTERP_NEAREST },
		{ u"AF_INTERP_LINEAR", AF_INTERP_LINEAR },
		{ u"AF_INTERP_BILINEAR", AF_INTERP_BILINEAR },
		{ u"AF_INTERP_CUBIC", AF_INTERP_CUBIC },
		{ u"AF_INTERP_LOWER", AF_INTERP_LOWER }
#if AF_API_VERSION >= 34
		,{ u"AF_INTERP_LINEAR_COSINE", AF_INTERP_LINEAR_COSINE },
		{ u"AF_INTERP_BILINEAR_COSINE", AF_INTERP_BILINEAR_COSINE },
		{ u"AF_INTERP_BICUBIC", AF_INTERP_BICUBIC },
		{ u"AF_INTERP_CUBIC_SPLINE", AF_INTERP_CUBIC_SPLINE },
		{ u"AF_INTERP_BICUBIC_SPLINE", AF_INTERP_BICUBIC_SPLINE }
#endif
	};
}



mxUint64 *refPointer2mxUint64(mxArray* &mary) {
    mary = mxCreateNumericArray(2, afCommon::dims_11, mxUINT64_CLASS, mxREAL);
    return mxGetUint64s(mary);
}

mxArray *refPointer2mxStruct(const std::vector<size_t> &sz, bool isDouble, bool isReal, void *Pgpu) {

	mxArray *sz_ary{ mxCreateDoubleMatrix(1, sz.size(), mxREAL) };
	mxDouble *sz_d{ mxGetDoubles(sz_ary) };
	for (size_t ii = 0; ii < sz.size(); ii++) {
		mexPrintf("%d of %d.\n", ii, sz.size());
		sz_d[ii] = static_cast<mxDouble>(sz.at(ii));
	};

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

static af::Backend afM_BACKEND = AF_BACKEND_CUDA;

#endif