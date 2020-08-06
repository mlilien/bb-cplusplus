#define DOCTEST_CONFIG_IMPLEMENT_WITH_MAIN
#include "doctest.h"

std::string HelloWorld()
{
    return "Hello World";
}

TEST_CASE("testing the HelloWorld function") {
    CHECK(HelloWorld() == "Hello_World");
}