# Coding Style Guideline
This document is a short guide on coding style guidelines. While the following
guide will be targeted at C++, its advices should be applicable for most other
projects as well.

## Source files
All the functionality must be put into one or more .cpp and .hpp files and into
an appropriate folder or module beneath the source folder. A new folder or
module might be created if it doesn't fit in any existing one:

* All the file names are written in lower case for better compatibility with
POSIX based operating systems (e.g. `foobar_factory.cpp`)
* C++ interface headers have `.hpp` extension
* Implementation files have `.cpp` extension
* The implementation and header file is put to `src/<module_name>`, a public
interface is added to the header files in
`include/<project_name>/<modul_name>.hpp`
* Tests are put to test/ with the suffix `_test` in the actual filename.

## Header files
* Don't include unneeded headers. If a file isn't using the symbols from some
header, remove the header
* Forward declare classes instead of including its headers whenever possible.
This helps to reduce build times.

## File Structure
Every source and header file, including tests, start with the following template

    // Copyright (c) <year>, <optional author>. All rights reserved.
    // For the licensing terms see LICENSE file in the root directory. For the
    // list of contributors see the AUTHORS file in the same directory

Other rules for both header and implementation files include:

* All the functionality must be put into an appropriate namespace, or possibly,
some nested namespace, e.g. `myproject::mymodule` or better anonymous namespace.
* Code lines should not be very long. Normally, they should be limited to 80
characters
* No tabulation should be used. Set your editor to use spaces instead
* Only English text is allowed. Do not put comments or string literals in other
languages
* Indentation is 4 spaces
* Header files must use guarding macros, protecting the files from repeated
inclusion

        #ifndef PROJECT_YOUR_HEADER_NAME_HPP
        #define PROJECT_YOUR_HEADER_NAME_HPP
        ...
        #endif

## Naming conventions
* Use camel-case style identifier for external functions, types and class
methods
* Class names start with a capital letter
* methods' and functions' names start with a small letter
* member variables are lower case and end with an underline (e.g. `foo_`)
* Macros and enumeration constants are written with all capital letters. Words
are separated by underscore

## Designing functions and class interfaces
It is important to design a function interface in a way, which is consistent
with the rest of the project. The elements of a function interface include:

* Functionality
* Name
* Return value
* Number of arguments
* Type of arguments
* Order of arguments
* Default values for some arguments

### Functionality
The functionality must be well defined and non-redundant. The function should be
easily embeddable into different processing pipelines that use other project
functions

### Name
The name should basically reflect the function purpose. A common naming pattern
includes:

* `<actionName><Object><Modifiers>`, e.g. `getBasename`, `appendWhenWriting`

### Return value
It should be chosen to simplify function usage. Generally, a function that
creates/computes a value should return it. Functions should not use return value
for signaling a critical error, such as null pointers, division by zero etc. On
the other hand, it is recommended to use a return value for signalizing about
quite normal run-time situations that can happen in a correctly working system
(e.g. a file could not be found etc.).

### Number of arguments
The ideal number of function arguments is zero (niladic). The next one is one
argument (monadic), followed by two arguments (dyadic). There is rarely the case
for functions which take three arguments (triadic). Functions which take three
or more arguments should be avoided whenever possible.

### Types of arguments
Argument types are preferably chosen from the already existing set of types
defined in your project: For example File for files, Directory for Directories
etc. Standard smart pointers as well as non-owning raw pointers are ok. For
passing complex objects int functions and methods, please consider using C++11
smart pointers.

A consistent argument order is important because it becomes easier to remember
the order and it helps programmers to avoid errors, connecting with wrong
argument oder. The usual oder is:
`<input parameters>, <output parameters>, <flags and optional parameters>`.

Input parameters usually have const qualifiers. Large objects are normally
passed by a constant reference; primitive types and small structures such as:
`int`, `double` etc. are passed by value.

Optional arguments often simplify function usage. Because C++ allows optional
arguments in the end of parameters list only, it also may affect decisions on
argument order -- the most important flags go first and less important -- after.

## Writing documentation on functions
The documentation is build with Doxygen. Normally, each function or method
description includes:

* the declaration in C++
* short description
* all the parametes explained; e.g. specify, which types and variants are
accepted, what would be the recommended values for the parameter and how they
affect the algorithm etc.

## Implementing tests
* For tests we use the GoogleTest framework. Please, check the documentation at
the project site
* All the test code is put into a project namespace
* Declare your Google tests as following:

        TEST(<module_name>_<tested_class_or_function>, <test_type>) { <test_body> }

## Appendix

### References
This document is not a complete style guide and a living document. Changes might
happen.

### The brief list of rules
* Filenames are written in lower case letters
* Member variables are lower case with an underline suffix
* Headers have `.hpp` extension
* Implementation files have `.cpp` extension
* Every source and header includes the mentioned license in the beginning
* Do not use tabs. Indentation is 4 spaces. Lines should not be longer than 80
characters
* Keep consistent formatting style in each particular source
* The code is put into a namespace or nested namespace
* Only English should be used in comments and string literals
* External functions names and data type names are written in camel-case. Classes
start with capital letter, functions start with small letter. External macros
are written in upper case
* Do not use conditional compilation in headers
* Keep the external interface as compact as possible. Do not export internal-use
classes or functions which are not essential and could be hidden
* Be compliant with C++ standards. Avoid compiler-dependent and
platform-dependent constructions
* Try not to use new and delete directly. Use RAII and smart pointers instead
* Provide GTest-based tests for your code
* Provide documentation for your code as Doxygen comments
