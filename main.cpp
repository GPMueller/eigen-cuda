#include <test.hpp>
#include <iostream>

// Main
int main(int argc, char ** argv)
{
    double x = Test::testfunction();

    std::cerr << ">> Testfunction returned: " << x << std::endl;

	return 0;
}