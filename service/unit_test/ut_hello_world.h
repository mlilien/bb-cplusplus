#include "hello_world.h"

TEST_CASE("testing the HelloWorld function") {
    CHECK(HelloWorldReturn::ReturnHelloWorld() == "Hello World");
}