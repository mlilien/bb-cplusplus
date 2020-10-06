<img src="https://raw.githubusercontent.com/elbb/bb-buildingblock/master/.assets/logo.png" height="200">

# # (e)mbedded (l)inux (b)uilding (b)locks - containerized C++ build and runtime environment

This building block provides a way to build, run, debug, test, perform static code analysis and generate documentation of any C++ project in a containerized manner and offers:

-   local and CI/CD build system
-   C++ Static Code Analyzer
-   C++ Unit Test with doctest
-   generation of documentation with doxygen
-   debugging hello world service with gdbserver

There is also an example that shows the usage with a 'hello world' application.

# Build

It is highly recommended to modify this building block for your needs. For the integration
into your project you should modify the builder and runtime Dockerfiles.

The images can be created locally manually or e.g. via dobi (<https://github.com/dnephin/dobi>) or via concourse CI.

## Using dobi for local build

### Prerequisites

-   dobi (<https://github.com/dnephin/dobi>)
-   docker (<https://docs.docker.com/install/>)
-   JFrog Artifactory Community Edition for C/C++ (<https://bintray.com/jfrog/product/JFrog-Artifactory-Cpp-CE/view>) (also available in dev environment <https://github.com/elbb/elbb-dev-environment>) (optional for dobi, mandatory for usage of the concourse ci/cd pipeline)

### Using dobi

dobi should only be used via the `dobi.sh` script, because there important variables are set and the right scripts are included.

Predifined resources were provided for these building block and are listed below: 

```sh
./dobi.sh build    # build the building block
./dobi.sh test     # run all tests
./dobi.sh analyze  # perform static code analyze of the building block
./dobi.sh version  # generate version informations
./dobi.sh doxygen  # generate documentation with doxygen
./dobi.sh debug    # start gdbserver for debugging
```

#### Using dobi for build

The alias `build` in this building block calls all dobi c++ build jobs. These c++ build jobs use conan to cross compile artifacts. Conan builds necessary dependent artifacts. By default these build jobs use a docker container connected to the `elbb-dev` docker network running the builder image. These build jobs try to upload dependent artifacts to a conan artifactory in this docker network. E.g. you can use the dev environment (<https://github.com/elbb/elbb-dev-environment>) to use a local conan artifactory. This is an optional feature though, the build job will not fail if uploading fails.

If you want to use the optional conan artifactory, you can configure it via the following environment variables:

```sh
NETWORK=yourDockerNetwork CONAN_REMOTE=yourConanArtifactoryURL CONAN_LOGIN_USERNAME=yourUsername CONAN_PASSWORD=yourPassword CONAN_SSL_VERIFICATION=false ./dobi.sh build
```

A more convenient way is to set these environment variables in a `local.env` file. Copy `local.env.template` to `local.env` and adapt `local.env` accordingly.


#### Using dobi for static code analysis

This building block offers the possibility to perform a static code analysis. The following tools and analyzers are used for the execution.

- CodeChecker
- Clang- Tidy
- Clang- Static Analyzer

The results are automatically provided to a CodeChecker web server for analysis. It is recommended to use the dev environment (<https://github.com/elbb/elbb-dev-environment>) provided by elbb.

**Notice:** Before start the code analysis, be sure that the CodeChecker Web Server is up and running.

With the following dobi command, the analysis of the sample code can be started:

```sh
./dobi.sh analyze
```

If you don't use the elbb dev environment, you can change the default CodeChecker URL of storing the analyze results with the following dobi command:

```sh
CODECHECKER_URL=http://codechecker-web:8001/Default ./dobi.sh analyze
```

By default the `analyze` job is started in a docker container connected to `elbb-dev` docker network used in the dev environment (<https://github.com/elbb/elbb-dev-environment>). If you use an own codechecker instance in another docker network, you have to adapt it via:

```sh
CODECHECKER_URL=http://codechecker-web:8001/Default NETWORK=yourDockerNetwork ./dobi.sh analyze
```

A more convenient way is to set this environment variable in a `local.env` file. Copy `local.env.template` to `local.env` and adapt `local.env` accordingly.


#### Using dobi for unit test

This building block offers the possibility to perform a unit test of your source code. The following tool is used for the execution.

<https://github.com/onqtam/doctest>

With the following dobi command, a example unit test of a sample code can be started:

```sh
./dobi.sh test
```

#### Using dobi for doxygen documentation

This building block offers the possibility to generate documentation of your source code. The following tool is used for the execution.

<https://www.doxygen.nl/index.html>

With the following dobi command, the generation of the documentation of the sample code can be started:

```sh
./dobi.sh doxygen
```

Results can be found in subfolder: gen/doxygen

##### doxygen configuration

This building block provides a doxygen configuration file `service/Doxyfile`. Use this file to configure doxygen for your use.

For further information how to configure doxygen, see:

<https://www.doxygen.nl/manual/config.html>


#### Using dobi to start debugging

This building block provide a setup to debug a x86 C++ component via remote debugging with a gdbserver.

For this purpose a dobi job is provided to do the startup of a gdb server. For demonstration purposes the Hello World service was used as test application. To start the debug session, the following command can be used.

```sh
./dobi.sh debug
```

The navigation through the code, display of variables, setting breakpoints, etc., can be done with Visual Studio code or similar IDEs. 

##### Host precondition

To be able to connect to the gdbserver running in the container, the host system shall be installed the "gdb-multiarch" debugger.

You can install the gdb-multiarch tool with:

```sh
sudo apt-get update
sudo apt-get install -y gdb-multiarch
```

##### Setup - IDE (vscode)

Before debugging C++ code in Visual Studio Code (vscode) you have to install the extension 'Native Debug` by WebFreak <https://github.com/WebFreak001/code-debug>

##### Debug configuration - launch.json
This section describes the process of connecting to a remote gdb session via vscode.
In order to make a remote gdb connection to the gdbserver running in the container you have to configure your launch.json.

An example launch.json (.vscode/launch.json) for application cplusplus_service could look like this.

- name: hello-world-x86_64 (remote gdb)

- program: ${workspaceRoot}/gen/cplusplus-service-x86_64-dev/cplusplus_service

- miDebuggerPath: "/usr/bin/gdb-multiarch"<br>
location of the gdb-multiarch debugger of your host system

- miDebuggerServerAddress: localhost:1234<br>
The Docker container starts a gdbserver at port 1234 and maps it to localhosts port 1234

- sourceFileMap:
The docker container mounts the C++ sources from  service to  /source in the container.

Therefore a mapping from  /source to  service must be setup in the sourceFileMap.

```sh
{
    // Use IntelliSense to learn about possible attributes.
    // Hover to view descriptions of existing attributes.
    // For more information, visit: https://go.microsoft.com/fwlink/?linkid=830387
    "version": "0.2.0",
    "configurations": [
        {
            "name": "hello-world-x86_64 (remote gdb)",
            "type": "cppdbg",
            "request": "launch",
            "program": "${workspaceRoot}/gen/cplusplus-service-x86_64-dev/cplusplus_service",
            "stopAtEntry": true,
            "cwd": "${workspaceRoot}",
            "environment": [],
            "externalConsole": true,
            "MIMode": "gdb",
            "miDebuggerPath": "/usr/bin/gdb-multiarch",            
            "miDebuggerServerAddress": "localhost:1234",
            "sourceFileMap": {
                "/source/": "${workspaceFolder}/service/"
            },
            "setupCommands": [
                {
                    "description": "Enable pretty-printing for gdb",
                    "text": "-enable-pretty-printing",
                    "ignoreFailures": true
                }
            ]
        },
    ]
}
```

#### Remote target debugging

This building block provides also a cross-compiled "service hello world example" for aarch64 and armv7 architecture. 

The next steps are exemplary for the aarch64 architecture and show the way to remote debugging on the target.

 **at host system**
- generate with dobi a service build docker image

```sh
./dobi.sh cplusplus-service-build-aarch64-dev
```
**at target system**
- store the docker image on your target

- start the docker image on your target

```sh
docker run --rm -it --privileged --entrypoint /bin/bash -p 1234:1234 xxXXxxXX/bb-cplusplus-service-aarch64-dev
```

- start gdbserver in running target container

```sh
gdbserver :1234 /usr/local/bin/cplusplus_service
```
**at host system**

This buildblock provide a visual studio code example debug file (.vscode/launch.json).

- open launch.json

- see chapter "name": "hello-world-aarch64 (remote gdb)"

- adjust ip address of element "miDebuggerServerAddress"

- start debug session "hello-world-aarch64 (remote gdb)"


## Using concourse CI for a CI/CD build

The pipeline file must be uploaded to concourse CI via `fly`.
Enter the build users ssh private key into the file `ci/credentials.template.yaml` and rename it to `ci/credentials.yaml`.
Copy the file `ci/email.template.yaml` to `ci/email.yaml` and enter the email server configuration and email addresses.

**Note: `credentials.yaml` and `email.yaml` are ignored by `.gitignore` and will not be checked in.**

In further releases there will be a key value store to keep track of the users credentials.
Before setting the pipeline you might login first to your concourse instance `fly -t <target> login --concourse-url http://<concourse>:<port>`. See the [fly documentation](https://concourse-ci.org/fly.html) for more help.
Upload the pipeline file with fly:

    $ fly -t <target> set-pipeline -n -p bb-cplusplus -l ci/config.yaml -l ci/credentials.yaml -l ci/email.yaml -c pipeline.yaml

After successfully uploading the pipeline to concourse CI login and unpause it. After that the pipeline should be triggered by new commits on the master branch (or new tags if enabled in `pipeline.yaml`).

### Email notification

The concourse ci environment automatically sends an e-mail notification about the current build status.
For further information how to configure the email notification, see:

<https://github.com/pivotal-cf/email-resource>

# What is embedded linux building blocks

embedded linux building blocks is a project to create reusable and
adoptable blueprints for highly recurrent issues in building an internet
connected embedded linux system.

# License

Licensed under either of

-   Apache License, Version 2.0, (./LICENSE-APACHE or <http://www.apache.org/licenses/LICENSE-2.0>)
-   MIT license (./LICENSE-MIT or <http://opensource.org/licenses/MIT>)

at your option.

# Contribution

Unless you explicitly state otherwise, any contribution intentionally
submitted for inclusion in the work by you, as defined in the Apache-2.0
license, shall be dual licensed as above, without any additional terms or
conditions.

Copyright (c) 2020 conplement AG
