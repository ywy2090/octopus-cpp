
#include "usage.h"
#include "BuildInfo.h"
#include <iostream>

// using namespace initializer;

void initializer::printVersion()
{
    std::cout << "Project Version    : " << PROJECT_PROJECT_VERSION << std::endl;
    std::cout << "Build Time         : " << PROJECT_BUILD_TIME << std::endl;
    std::cout << "Build Type         : " << PROJECT_BUILD_PLATFORM << "/" << PROJECT_BUILD_TYPE
              << std::endl;
    std::cout << "Git Branch         : " << PROJECT_BUILD_BRANCH << std::endl;
    std::cout << "Git Commit         : " << PROJECT_COMMIT_HASH << std::endl;
}