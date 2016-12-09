#ifdef USE_CUDA

#include <kernel.hpp>
#include <Eigen/Core>

// CUDA Version
namespace Kernel
{
    __global__ void cu_dot(Eigen::Vector3d *a, Eigen::Vector3d *b, double *out, size_t N)
    {
        int idx = blockIdx.x * blockDim.x + threadIdx.x;
        if(idx < N)
        {
            int i = 3 * idx;
            out[i]   += a[i].dot(b[i]);
        }
        return;
    }

    // TODO: memcpy and malloc
    double dot(std::vector<Eigen::Vector3d> v1, std::vector<Eigen::Vector3d> v2)
    {
        double* ret = new double[v1.size()];
        int n = v1.size();

        cu_dot<<<(n+1023)/1024, 1024>>>(v1.data(), v2.data(), ret, n);
        
        return ret[0];
    }
}

#endif