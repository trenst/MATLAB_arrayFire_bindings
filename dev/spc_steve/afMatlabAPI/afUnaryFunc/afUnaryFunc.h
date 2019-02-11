#ifndef AFUNARYFUNC_H
#define AFUNARYFUNC_H

#include "..\afCommon\afCommon.h"

namespace afCommon {
    //	Trigonometric Function Wrappers
    af::array sin(af::array &a_in) {
        af::array out = af::sin(a_in);
        return std::move(out);
    };

    af::array asin(af::array &a_in) {
        af::array out = af::asin(a_in);
        return std::move(out);
    };

    af::array cos(af::array &a_in) {
        af::array out = af::cos(a_in);
        return std::move(out);
    };

    af::array acos(af::array &a_in) {
        af::array out = af::acos(a_in);
        return std::move(out);
    };

    af::array tan(af::array &a_in) {
        af::array out = af::tan(a_in);
        return std::move(out);
    };

    af::array atan(af::array &a_in) {
        af::array out = af::atan(a_in);
        return std::move(out);
    };

    // Hyperbolic Function Wrappers
    af::array sinh(af::array &a_in) { return std::move(af::sinh(a_in)); };
    af::array asinh(af::array &a_in) { return std::move(af::asinh(a_in)); };
    af::array cosh(af::array &a_in) { return std::move(af::cosh(a_in)); };
    af::array acosh(af::array &a_in) { return std::move(af::acosh(a_in)); };
    af::array tanh(af::array &a_in) { return std::move(af::tanh(a_in)); };
    af::array atanh(af::array &a_in) { return std::move(af::atanh(a_in)); };

    // Complex Functions Wrappers
    af::array conjg(af::array &a_in) {
        af::array out = af::conjg(a_in);
        return std::move(out);
    };

    af::array real(af::array &a_in) {
        af::array out = af::real(a_in);
        return std::move(out);
    };

    af::array imag(af::array &a_in) {
        af::array out = af::imag(a_in);
        return std::move(out);
    };

	af::array ctranspose(af::array &a_in) {
		af::array out = af::transpose(a_in, true);
		return std::move(out);
	};

	af::array transpose(af::array &a_in) {
		af::array out = af::transpose(a_in, false);
		return std::move(out);
	};

    // Exponential and logarithmic function Wrappers
    af::array sqrt(af::array &a_in) { return std::move(af::sqrt(a_in)); };
    af::array erf(af::array &a_in) { return std::move(af::erf(a_in)); };
    af::array erfc(af::array &a_in) { return std::move(af::erfc(a_in)); };
    af::array exp(af::array &a_in) { return std::move(af::exp(a_in)); };
    af::array expm1(af::array &a_in) { return std::move(af::expm1(a_in)); };
    af::array factorial(af::array &a_in) { return std::move(af::factorial(a_in)); };
    af::array tgamma(af::array &a_in) { return std::move(af::tgamma(a_in)); };
    af::array lgamma(af::array &a_in) { return std::move(af::lgamma(a_in)); };
    af::array log(af::array &a_in) { return std::move(af::log(a_in)); };
    af::array log10(af::array &a_in) { return std::move(af::log10(a_in)); };
    af::array log1p(af::array &a_in) { return std::move(af::log1p(a_in)); };

    // Numeric Function Wrappers
    af::array arg(af::array &a_in) { return std::move(af::arg(a_in)); };
    af::array abs(af::array &a_in) { return std::move(af::abs(a_in)); };
    af::array ceil(af::array &a_in) { return std::move(af::ceil(a_in)); };
    af::array floor(af::array &a_in) { return std::move(af::floor(a_in)); };
    af::array round(af::array &a_in) { return std::move(af::round(a_in)); };

	const std::map<std::string, std::function<af::array(af::array)>> unFuncMap = {
		//	Trigonometric Functions
		{ "sin", &sin },{ "asin", &asin },{ "cos", &cos },
		{ "acos", &acos },{ "tan", &tan },{ "atan", &atan },
		// Hyperbolic Functions
		{ "sinh", &sinh },{ "asinh", &asinh },{ "cosh", &cosh },
		{ "acosh", &acosh },{ "tanh", &tanh },{ "atanh", &atanh },
		// Complex Functions
		{ "conjg", &conjg },{ "real", &real },{ "imag", &imag },
		{ "ctranspose", &ctranspose } ,{"transpose", &transpose},
		// Exponential and logarithmic functions
		{ "sqrt", &sqrt },{ "erf", &erf },{ "erfc", &erfc },
		{ "exp", &exp },{ "expm1", &expm1 },{ "factorial", &factorial },
		{ "tgamma", &tgamma },{ "lgamma", &lgamma },{ "log", &log },
		{ "log10", &log10 },{ "log1p", &log1p },
		// Numeric Functions
		{ "arg", &arg },{ "abs", &abs },{ "ceil", &ceil },
		{ "floor", &floor },{ "round", &round }
	};
};



#endif