[![Build status](https://ci.appveyor.com/api/projects/status/d9ahvu9u77qjhx9r/branch/master?svg=true)](https://ci.appveyor.com/project/lahma/quartznet-6fcn8/branch/master)
[![NuGet](http://img.shields.io/nuget/v/Quartz.svg)](https://www.nuget.org/packages/Quartz/)
[![NuGet](http://img.shields.io/nuget/vpre/Quartz.svg)](https://www.nuget.org/packages/Quartz/)
[![Join the chat at https://gitter.im/quartznet/quartznet](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/quartznet/quartznet?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

# Quartz.NET - Job Scheduler for the .NET Platform

[http://www.quartz-scheduler.net/](http://www.quartz-scheduler.net/)

## Introduction

This is the README file for Quartz.NET, .NET port of Java Quartz. It supports .NET Core/netstandard 2.0 and .NET Framework 4.5.2 and later.

Quartz.NET is an opensource project aimed at creating a
free-for-commercial use Job Scheduler, with 'enterprise' features.

## Building

* You can build the code by running `build.cmd` (Windows) or `build.sh` (*nix platform)
* You need MSBuild 15 and .NET Core SDK 2.0 to build - easiest to [download Visual Studio 2017 Community](https://www.visualstudio.com/downloads/)
* You need Visual Studio 2017 to open the solution, [Community version](https://www.visualstudio.com/downloads/) should suffice


## Acknowledgements

Following components are being used by core Quartz:

* [LibLog](https://github.com/damianh/LibLog) (MIT) as bridge between different logging frameworks


## License

Licensed under the Apache License, Version 2.0 (the "License"); you may not 
use this file except in compliance with the License. You may obtain a copy 
of the License [here](http://www.apache.org/licenses/LICENSE-2.0).

For API documentation, please refer to [Quartz.NET site](http://quartznet.sourceforge.net/apidoc/3.0/html/).
