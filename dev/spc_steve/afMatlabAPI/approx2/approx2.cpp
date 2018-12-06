#include "approx2.h"

DLL_PUBLIC void mexFunction(int nlhs, mxArray **plhs, int nrhs, const mxArray **prhs) {

	mxUint64 *in_mx{ mxGetUint64s(prhs[0]) };
	mxUint64 *pos0_mx{ mxGetUint64s(prhs[1])};
	mxUint64 *pos1_mx{ mxGetUint64s(prhs[2]) };
	bool isAllocated = (*in_mx != 0) && (*pos0_mx != 0) && (*pos1_mx != 0);

	try {
#ifdef UNIFIED_BACKEND
		af::setBackend(afM_BACKEND);
#endif
		if (isAllocated) {

			af::array *in( reinterpret_cast<af::array*>(*in_mx) );
			af::array *pos0(reinterpret_cast<af::array*>(*pos0_mx));
			af::array *pos1(reinterpret_cast<af::array*>(*pos1_mx));
			std::u16string itpType(mxArrayToString(prhs[3]));
			mxDouble *offGrid(mxGetDoubles(prhs[4]));

			mexPrintf("itpType: %s\n", itpType.c_str());

			af::interpType method = afCommon::interpTypeMap[itpType];

			/*std::string out_ptr_str( af::toString("in", *in, 10) );
			mexPrintf(out_ptr_str.c_str());

			out_ptr_str = af::toString("pos0", *pos0, 10);
			mexPrintf(out_ptr_str.c_str());

			out_ptr_str = af::toString("pos1", *pos1, 10);
			mexPrintf(out_ptr_str.c_str());*/

			mexPrintf("method: %d\n", method);
			mexPrintf("offGrid: %f\n", *offGrid);

			af::array out = af::approx2(*in, *pos0, *pos1, method,
				static_cast<float>(*offGrid));

			af::array *out_ptr = new af::array(std::move(out));

			//out_ptr->lock();

			//af_array *out_ptr2 = new af_array;
			//af_approx2(out_ptr2, in->get(), pos0->get(), pos1->get(), method, static_cast<float>(*offGrid));
			//af::array *out_ptr = new af::array(out_ptr2);

			//out_ptr->set(out.get());

			dim_t *dim_sz = out_ptr->dims().get();
			std::vector<size_t> sz(dim_sz, dim_sz + out_ptr->numdims());

			//mexPrintf("out owns the pointer? %d\n", af::isOwner(out));
			//mexPrintf("out pointer: %p\n", static_cast<void*>(&out));
			mexPrintf("out_ptr owns the pointer? %d\n", af::isOwner(*out_ptr));
			mexPrintf("out_ptr pointer: %p\n", static_cast<void*>(out_ptr));
			mexPrintf("out_ptr backend: %d\n", af::getBackendId(*out_ptr));

			plhs[0] = refPointer2mxStruct(sz, out_ptr->isdouble(), out_ptr->isreal(), 
				static_cast<void*>(out_ptr));		

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


