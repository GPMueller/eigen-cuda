# eigen-cuda
Using the Eigen library in CUDA kernels

[Eigen](http://eigen.tuxfamily.org/) is a fantastic library, which since version 3.3 can be used inside CUDA kernels.
**This MWE** shows the calculation of a sum of dot products using a `std::vector<Eigen::Vector3d>`.
The `USE_CUDA` macro switches from the regular C++ (CPU) implementation to the CUDA implementation.
CMake is used to configure the build and `CORE_USE_CUDA` can be used to switch between implementations.
