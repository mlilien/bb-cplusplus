#include <chrono>
#include <iostream>
#include <thread>

#include <boost/asio.hpp>
#include <boost/exception/diagnostic_information.hpp>

#include <elbb/version.h>
#include "hello_world.h"

void asyncWaitForSignal(boost::asio::signal_set& signalSet, std::atomic<bool>& running)
{
    try
    {
        signalSet.async_wait( [&signalSet, &running] (const boost::system::error_code &ec, int signal) {
            if (!ec) {
                if (SIGTERM == signal || SIGINT == signal)
                {
                    std::cout << "Catched Signal: " << strsignal(signal) << std::endl;
                    running=false;
                }
            }
            else
            {
                throw std::runtime_error(ec.message());
            }
        });
    }
    catch(const std::exception& e)
    {
        std::cerr << e.what() << std::endl;
        throw;
    }
}

int main(int argc, char *argv[])
{
    //register signal handler
    boost::asio::io_context iocSignalHandler;
    boost::asio::signal_set signalSet(iocSignalHandler, SIGINT, SIGTERM);
    std::atomic<bool> running{true};
    auto schedTask = std::async(std::launch::async, [&running, &iocSignalHandler]() {
        try
        {
            boost::system::error_code ec;

            while (running)
            {
                iocSignalHandler.run_one();
                std::this_thread::yield();
            }
        }
        catch (const boost::exception &e)
        {
            std::cerr << boost::diagnostic_information(e) << std::endl;
        }
    });
    asyncWaitForSignal(signalSet, running);

    //main app
    while (running)
    {
        std::cout << HelloWorldReturn::ReturnHelloWorld() << std::endl;
        std::cout << "Waiting to be terminated." << std::endl;
        std::cout << "FullSemVer: " << elbb::version::FullSemVer << std::endl;
        std::cout << "InformationalVersion: " << elbb::version::InformationalVersion
                  << std::endl;
        std::this_thread::sleep_for(std::chrono::seconds(5));
    }

    return 0;
}