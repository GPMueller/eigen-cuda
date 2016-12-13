#pragma once
#ifndef KERNEL_H
#define KERNEL_H

#include <vector>
#include <Eigen/Core>

namespace Kernel
{
    double dot(const std::vector<Eigen::Vector3d> & v1, const std::vector<Eigen::Vector3d> & v2);
}

#endif