#include <kernel.hpp>
#include <Eigen/Core>

namespace Kernel
{
    double testfunction()
    {
        Eigen::Vector3d v1{ 1.0, 1.0, 1.0 };
        Eigen::Vector3d v2{ -1.0, 1.0, 1.0 };
        double x = v1.dot(v2);
        return x;
    } 
}