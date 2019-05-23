#ifndef AFBINARYFUNC_H
#define AFBINARYFUNC_H

#include "..\afCommon\afCommon.h"

namespace afCommon {
	enum struct opType { plus, minus, times, rdivide };
	const std::map<std::string, opType> opTypeMap = {
		{ "plus", opType::plus },{ "minus", opType::minus },{ "times", opType::times },{ "rdivide", opType::rdivide }
	};
};


template <typename T1, typename T2>
af::array *binary_op(T1* left, T2 *right, afCommon::opType operation) {

	af::array out;

	switch (operation) {
		case afCommon::opType::plus:
			out = *left + *right; break;
		case afCommon::opType::minus:
			out = *left - *right; break;
		case afCommon::opType::times:
			out = *left * *right; break;
		case afCommon::opType::rdivide:
			out = *left / *right; break;
	}

	return new af::array(std::move(out));

}

#endif