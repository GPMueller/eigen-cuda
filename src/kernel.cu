#ifdef USE_CUDA

///// Eigen Workaround Stuff
// See http://eigen.tuxfamily.org/dox/TopicCUDA.html
// and http://eigen.tuxfamily.org/index.php?title=3.3#Experimental_CUDA_support
#define EIGEN_DEFAULT_DENSE_INDEX_TYPE int
// workaround issue between gcc >= 4.7 and cuda 5.5
#if (defined __GNUC__) && (__GNUC__>4 || __GNUC_MINOR__>=7)
  #undef _GLIBCXX_ATOMIC_BUILTINS
  #undef _GLIBCXX_USE_INT128
#endif
/////////////////////////////

#include <kernel.hpp>
#include <Eigen/Core>

#include <iostream>
#include <stdio.h>


static void HandleError( cudaError_t err, const char *file, int line ) {
	// CUDA error handeling from the "CUDA by example" book
	if (err != cudaSuccess) {
		printf( "%s in %s at line %d\n", cudaGetErrorString( err ),
				file, line );
		exit( EXIT_FAILURE );
	}
}

#define HANDLE_ERROR( err ) (HandleError( err, __FILE__, __LINE__ ))

// CUDA Version
namespace Kernel
{
    // TODO: Get this working
    __global__ void cu_dot(Eigen::Vector3d *v1, Eigen::Vector3d *v2, double *out, size_t N)
    {
        int idx = blockIdx.x * blockDim.x + threadIdx.x;
        if(idx < N)
        {
            out[idx] = v1[idx].dot(v2[idx]);
        }
        return;
        // int idx = blockIdx.x * blockDim.x + threadIdx.x;
        // if(idx < N)
        // {
        //     out[idx] = 33.0;
        // }
    }

    // The wrapper for the calling of the actual kernel
    double dot(std::vector<Eigen::Vector3d> v1, std::vector<Eigen::Vector3d> v2)
    {        
        int n = v1.size();
        double *ret = new double[n];

        // Allocate device arrays
        Eigen::Vector3d *dev_v1, *dev_v2;
        HANDLE_ERROR(cudaMalloc((void **)&dev_v1, sizeof(Eigen::Vector3d)*n));
        HANDLE_ERROR(cudaMalloc((void **)&dev_v2, sizeof(Eigen::Vector3d)*n));
        double* dev_ret;
        HANDLE_ERROR(cudaMalloc((void **)&dev_ret, sizeof(double)*n));

        // Copy to device
        HANDLE_ERROR(cudaMemcpy(dev_v1, v1.data(), sizeof(Eigen::Vector3d)*n, cudaMemcpyHostToDevice));
        HANDLE_ERROR(cudaMemcpy(dev_v2, v2.data(), sizeof(Eigen::Vector3d)*n, cudaMemcpyHostToDevice));

        // Dot product
        cu_dot<<<(n+1023)/1024, 1024>>>(v1.data(), v2.data(), dev_ret, n);
        
        // Copy to host
        HANDLE_ERROR(cudaMemcpy(ret, dev_ret, sizeof(double)*n, cudaMemcpyDeviceToHost));

        // Return
        // std::cerr << "ret =";
        // for (int i=0; i<n; ++i)
        // {
        //     std::cerr << "  " << ret[i];
        // }
        // std::cerr << std::endl;
        return ret[0];
    }
}

#endif