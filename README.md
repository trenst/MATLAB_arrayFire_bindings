# MATLAB API for ArrayFire

[ArrayFire](http://arrayfire.org/docs/index.htm) is a high performance software library for parallel computing with an easy-to-use API. Its array based function set makes GPGPU programming more accessible.  There are both C and C++ interfaces to ArrayFire.  The purpose of this project is to expose the ArrayFire library to MATLAB through an API using syntax familiar to the MATLAB developer.  The API introduces a new MALAB class called afArray.  An afArray object references an ArrayFire array stored on the GPU.  Inputs to ArrayFire functions are afArrays, and the output is also an afArray.  Memory I/O to/from the GPU only occurs when an explicit call is made, so the developer can optimize the code to minimize the amount of I/O which takes place.  GPU memory I/O is the main bottleneck in GPGPU processing, so giving the MATLAB programmer control over this task is vital to the success of this API.

## Status of this API

The MATLAB API is in it's infancy and this work is primarily intended to judge interest in this API.  The development was done in MATLAB R2018b and Microsoft Visual Studio 2015 and compiled for 64 bit Windows.  Although not yet compiled/tested on Linux, there are no foreseen complications of doing so.  The API can be compiled to use an openCL or a CUDA backend.  In the future, I'll likely expose this choice to the MATLAB developer because it can be made at runtime.  Likewise, if multiple GPU devices are available, it will be possible for the developer to determine how to utilize those resources.  

### Supported ArrayFire functionality 
The MATLAB API supports
+ afArray construction by copying a MATLAB array of up to 4 dimensions.
+ afArray destruction manually or automatically when the object goes out of scope.
+ single / double real and complex arrays.
+ Array indexing:
  + spanning of an entire dimension for reference (not assignment).
    + i.e.  `array(4,:,:,7)`
    + subsref supported. subsasgn is on the todo list.
  + scalar integer indexing of a dimension.
+ Binary Operations: 
    + afArray-afArray Element-wise: +, -, *, /
    + array-scalar: +, -, *, /     
        + another list item
        + one more list item
+ [approx2](http://arrayfire.org/docs/group__signal__func__approx2.htm) - 2D interpolation.
+ Unary Operations: y = f(x) Element-wise functions
    + Trigonometric Functions
        + Supports only real input
        + `sin, asin, cos, acos, tan, atan`
    + Hyperbolic Functions:
        + Supports only real input
        + `sinh, asinh, cosh, acosh, tanh, atanh`
    + Complex Functions:
        + `conj, real, imag, ctranspose, transpose`
        + MATLAB syntex for `ctranspose` and `transpose` supported... `array'` and `array.'`
    + Exponential and Logarithmic Functions:
        + `realsqrt, erf, erc, exp, expm1, factorial, gamma, gamma1n, log, log10, log1p`
    + Numeric Functions:
        + `angle, abs, ceil, floor, round`


# Requirements
ArrayFire should be [installed](http://arrayfire.org/docs/installing.htm).  
A new memory model for [complex numbers](https://www.mathworks.com/help/matlab/matlab_external/matlab-support-for-interleaved-complex.html) was introduced in MATLAB R2018a in addition to an expanded MEX API which the bindings to ArrayFire take advantage of.  Thus you'll need this version of MATLAB at a minimum.

To try it, you should have at least a 1 GB graphics card.  For using in production code, the more memory the better.  I have 8GB.

# How to Build
In order to build, 2 environment variables will need to be set.  `AF_PATH` should be defined as your ArrayFire installation folder, and `MATLAB_EXTERN` should be defined as your MATLAB extern folder (R2018 or higher).
Open the solution for Microsoft Visual Studio 2015 `afMatlabAPI/afMatlabAPI.sln`.  Select x64/release and then build.  The mex files will be built into the /afMatlabDev folder and ready for use with the MATLAB code in that folder.

# Example Usage
Create an afArray by passing a MATLAB array.
```
>> a1 = reshape(1:18,3,6);
>> a1_AF = afArray(a1)
a1_AF = 
  3×6 afArray array with properties:

    prop: [1×1 struct]
```
`a1_AF` is now a reference to an array on the GPU.  Binary operations with scalars are supported.
```
>> a2_AF = 0.1 .* a1_AF
a2_AF = 
  3×6 afArray array with properties:

    prop: [1×1 struct]
>> 
```
All of the operations on afArrays are performed on the GPU.
Here is an example of afArray-afArray addition.
```
>> a3_AF = a1_AF + a2_AF
a3_AF = 
  3×6 afArray array with properties:

    prop: [1×1 struct]
```
afArrays remain on the GPU until explicitly called with the method `afArray.getAFmem()`
```
>> a3 = a3_AF.getAFmem()
a3 =
    1.1000    4.4000    7.7000   11.0000   14.3000   17.6000
    2.2000    5.5000    8.8000   12.1000   15.4000   18.7000
    3.3000    6.6000    9.9000   13.2000   16.5000   19.8000
```
Spanning of a dimension of an array is also supported.  
```
>> row2_AF = a3_AF(2,:);
>> row2 = row2_AF.getAFmem()
row2 =
    2.2000    5.5000    8.8000   12.1000   15.4000   18.7000
```





