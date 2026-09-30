---
name: cpp-skill
description: Full C++ development aid with emphasis on memory safety and cross-platform programming. Use when the user wants to create, edit, build, run, debug, or test C++ source files, headers, or CMake projects. Scaffolds files with proper headers, enforces modern C++ best practices, memory-safe idioms, cross-platform CMake builds, and assists with debugging and testing.
allowed-tools: Read, Write, Edit, Grep, Glob, Bash
argument-hint: [action or filename]
---

# C++ Development Skill (Memory-Safe, Cross-Platform)

Assist with all aspects of modern C++ development with a strong emphasis on memory safety and cross-platform portability. This includes creating files, writing code, building projects, running executables, debugging, and testing.

## Creating New Files

When creating a new C++ source file (`.cpp`) or header (`.hpp`/`.h`), always add the header using `file-header-skill` with its `/* */` comment template. In a header, put `#pragma once` directly after the header comment.

Prefer `.hpp`/`.cpp` extensions for C++ files. Use `#pragma once` instead of `#ifndef` include guards.

## C++ Standard

- Target **C++23** as the default standard unless the project specifies otherwise
- Set the standard in CMake: `set(CMAKE_CXX_STANDARD 23)` with `set(CMAKE_CXX_STANDARD_REQUIRED ON)`

## Memory Safety (Critical)

Memory safety is the top priority. Apply these rules strictly:

### Ownership and Lifetime

- **Never use raw `new`/`delete`** — use smart pointers or containers instead
- **`std::unique_ptr`** for single-owner resources (default choice)
- **`std::shared_ptr`** only when shared ownership is genuinely needed
- **`std::weak_ptr`** to break reference cycles with `shared_ptr`
- Use **`std::make_unique`** and **`std::make_shared`** — never construct smart pointers from raw `new`
- Apply **RAII** (Resource Acquisition Is Initialization) for all resource management: files, locks, sockets, handles

### Containers and References

- Use **`std::vector`**, **`std::array`**, **`std::string`**, **`std::string_view`** instead of raw arrays and C strings
- Use **`std::span`** (C++20) for non-owning views over contiguous data
- Use **`std::optional`** instead of nullable raw pointers for optional values
- Use **`std::variant`** instead of unions
- Prefer **references** over pointers when null is not a valid state
- Prefer **`const&`** for read-only access to non-trivial types

### Array and Buffer Safety

- Bounds-check in development builds with standard-library hardening, enabled by the `ENABLE_SANITIZERS` block: `_LIBCPP_HARDENING_MODE_DEBUG` (libc++, macOS) and `_GLIBCXX_ASSERTIONS` (libstdc++, Linux) make `operator[]`, `front()`, `back()`, and iterators abort on out-of-range access
- Use **`std::ranges`** algorithms instead of raw pointer iteration
- Never perform pointer arithmetic on raw pointers — use `std::span` or iterators
- Always validate sizes before buffer operations

### Concurrency Safety

- Use **`std::mutex`** with **`std::lock_guard`** or **`std::scoped_lock`** — never manual lock/unlock
- Use **`std::atomic`** for lock-free shared state
- Use **`std::jthread`** (C++20) over `std::thread` for automatic joining
- Prefer **`std::async`** / **`std::future`** for simple parallelism

### Error Handling

- Use **exceptions** for exceptional conditions or **`std::expected`** (C++23) / **`std::optional`** for expected failures
- Never ignore return values — use `[[nodiscard]]` on functions whose return value must be checked
- Avoid **`std::terminate`** / **`std::abort`** in library code
- Use **`static_assert`** for compile-time invariants

### Casts and Type Safety

- **Never use C-style casts** — use `static_cast`, `dynamic_cast`, `const_cast`, or `reinterpret_cast`
- Minimize use of `reinterpret_cast` and `const_cast` — both are code smells
- Use **`enum class`** instead of plain `enum`
- Use **`std::byte`** for raw byte manipulation instead of `char*` or `unsigned char*`

## Cross-Platform Development (Critical)

### CMake (Required Build System)

Always use CMake for cross-platform builds. Minimum CMakeLists.txt:

```cmake
cmake_minimum_required(VERSION 3.20)
project(ProjectName LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

option(ENABLE_SANITIZERS "Enable ASan and UBSan" ON)
if(ENABLE_SANITIZERS)
    add_compile_options(-fsanitize=address,undefined -fno-omit-frame-pointer)
    add_link_options(-fsanitize=address,undefined)
    add_compile_definitions(
        _LIBCPP_HARDENING_MODE=_LIBCPP_HARDENING_MODE_DEBUG
        _GLIBCXX_ASSERTIONS
    )
endif()

add_library(${PROJECT_NAME}_lib src/my_module.cpp)
target_include_directories(${PROJECT_NAME}_lib PUBLIC include)

add_executable(${PROJECT_NAME} src/main.cpp)
target_link_libraries(${PROJECT_NAME} PRIVATE ${PROJECT_NAME}_lib)
```

Keep everything except `main()` in the library so the test executable can link the same code.

Key CMake practices:
- Always set `CMAKE_CXX_EXTENSIONS OFF` to disable compiler-specific extensions
- Use `target_*` commands instead of global `include_directories()` or `add_definitions()`
- Use `FetchContent` or `find_package` for dependencies
- Export `compile_commands.json` for tooling: `set(CMAKE_EXPORT_COMPILE_COMMANDS ON)`

### Platform Abstraction

- Use **`std::filesystem`** for all path and file operations (not POSIX APIs)
- Use **`std::chrono`** for all time operations
- Use **`<cstdint>`** fixed-width types: `int32_t`, `uint64_t`, `size_t`, `ptrdiff_t`
- Use **`std::thread`** / **`std::jthread`** for threading (not pthreads)
- Use **`std::format`** (C++20) for string formatting
- Avoid platform-specific headers (`<unistd.h>`) unless isolated behind abstractions

### When Platform-Specific Code Is Needed

```cpp
#if defined(__APPLE__)
    // macOS/iOS-specific code
#elif defined(__linux__)
    // Linux-specific code
#else
    #error "Unsupported platform"
#endif
```

Isolate platform-specific code into dedicated source files with a common interface header.

### Portability Rules

- Never assume endianness — use `std::endian` (C++20) and `std::byteswap` (C++23) when needed
- Never assume `sizeof(int)` or pointer sizes — use fixed-width types
- Avoid compiler-specific attributes — use C++ standard `[[attributes]]`
- Use `std::source_location` (C++20) instead of `__FILE__`/`__LINE__` macros
- Avoid `#pragma` directives other than `#pragma once`

## Building and Running

### Building with CMake

```bash
cmake -S . -B build -DCMAKE_BUILD_TYPE=Debug
cmake --build build
```

Build types:
- **Debug**: `-DCMAKE_BUILD_TYPE=Debug` — full debug info, no optimization
- **Release**: `-DCMAKE_BUILD_TYPE=Release` — optimized, no debug info
- **RelWithDebInfo**: `-DCMAKE_BUILD_TYPE=RelWithDebInfo` — optimized with debug info

### Running

```bash
./build/ProjectName
```

### Sanitizer Builds (Essential for Memory Safety)

ASan and UBSan come from the `ENABLE_SANITIZERS` option in the minimum `CMakeLists.txt` above. Keep the option block before any `add_executable`/`add_library`, since `add_compile_options` only affects targets defined after it. When a project's `CMakeLists.txt` lacks the block, add it.

Sanitizers are on by default. Turn them off only for release builds:

```bash
cmake -B build-release -DENABLE_SANITIZERS=OFF -DCMAKE_BUILD_TYPE=Release
cmake --build build-release
```

Available sanitizers (Clang/GCC):
- **AddressSanitizer (ASan)**: `-fsanitize=address` — buffer overflows, use-after-free; memory leaks on Linux only (Apple Clang's ASan has no LeakSanitizer — use `leaks --atExit -- ./build/ProjectName` on macOS)
- **UndefinedBehaviorSanitizer (UBSan)**: `-fsanitize=undefined` — signed overflow, null dereference, alignment
- **ThreadSanitizer (TSan)**: `-fsanitize=thread` — data races (cannot combine with ASan)
- **MemorySanitizer (MSan)**: `-fsanitize=memory` — uninitialized reads (Clang on Linux only, cannot combine with ASan)

Always run the test suite under ASan+UBSan before considering code complete.

## Code Quality

### Modern C++ Idioms

- Use structured bindings: `auto [key, value] = *map.begin();`
- Use `if constexpr` for compile-time branching
- Use concepts (C++20) to constrain templates
- Use `auto` for complex types but be explicit for readability at interfaces
- Use `constexpr` and `consteval` aggressively for compile-time computation
- Use designated initializers (C++20): `Point{.x = 1, .y = 2}`
- Use range-based `for` with structured bindings: `for (const auto& [k, v] : map)`
- Mark single-argument constructors `explicit`
- Follow the **Rule of Zero**: rely on compiler-generated special members by using smart pointers and standard containers
- If you must define one special member function, follow the **Rule of Five**

### Naming Conventions

- `PascalCase` for types and classes
- `snake_case` for functions, variables, and namespaces
- `UPPER_SNAKE_CASE` for constants and macros
- `m_` prefix for private member variables
- Avoid Hungarian notation

### Header Hygiene

- Include what you use — do not rely on transitive includes
- Use forward declarations where possible to reduce compile times
- Order includes: own header first, project headers, third-party headers, standard library
- Keep headers self-contained (every header compiles on its own)

## Debugging

### LLDB (primary on macOS)

- Launch: `lldb ./build/ProjectName`
- Key commands:
  - `r` (run), `n` (next), `s` (step into), `c` (continue), `finish` (step out)
  - `b <function>` or `b <file>:<line>` (set breakpoint)
  - `br list` (list breakpoints), `br del <n>` (delete breakpoint)
  - `p <expr>` (print), `po <expr>` (print object/formatted)
  - `bt` (backtrace), `frame variable` (show locals)
  - `watchpoint set variable <var>` (data breakpoint)
  - `q` (quit)

### GDB (primary on Linux)

- Launch: `gdb ./build/ProjectName`
- Key commands:
  - `r` (run), `n` (next), `s` (step into), `c` (continue), `finish` (step out)
  - `b <function>` or `b <file>:<line>` (set breakpoint)
  - `info b` (list breakpoints), `d <n>` (delete breakpoint)
  - `p <expr>` (print), `bt` (backtrace), `info locals`
  - `watch <expr>` (data breakpoint)
  - `q` (quit)

### Valgrind (Linux)

- Memory error detection: `valgrind --leak-check=full ./build/ProjectName`
- Detailed: `valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes ./build/ProjectName`

## Formatting

- Format with **uncrustify**: `uncrustify --no-backup <files>`
- Honor the project's `uncrustify.cfg` if present: `uncrustify -c uncrustify.cfg --no-backup <files>`
- Verify without changing: add `--check`
- Pass only the paths you changed — never run it across the whole tree

## Static Analysis

### cppcheck

- Pass only the files you changed — never run it across the whole tree:
  `cppcheck --enable=warning,style,performance,portability --std=c++23 --suppress=missingIncludeSystem -Iinclude <files>`
- Don't use `--enable=all` on a subset of files: it turns on `unusedFunction`, which reports false positives unless the whole program is checked

### Compiler Warnings (Always Enable)

Add to CMakeLists.txt:

```cmake
if(CMAKE_CXX_COMPILER_ID MATCHES "Clang|GNU")
    target_compile_options(${PROJECT_NAME}_lib PRIVATE
        -Wall -Wextra -Wpedantic -Werror
        -Wconversion -Wsign-conversion
        -Wnon-virtual-dtor -Wold-style-cast
        -Wcast-align -Wunused -Woverloaded-virtual
        -Wshadow -Wnull-dereference
        -Wdouble-promotion -Wformat=2
        -Wimplicit-fallthrough
    )
endif()
```

## Testing

### Google Test (recommended)

Add via CMake FetchContent:

```cmake
include(FetchContent)
FetchContent_Declare(
    googletest
    GIT_REPOSITORY https://github.com/google/googletest.git
    GIT_TAG        v1.15.2
)
FetchContent_MakeAvailable(googletest)

enable_testing()
add_executable(tests tests/test_main.cpp)
target_link_libraries(tests PRIVATE ${PROJECT_NAME}_lib GTest::gtest_main)
include(GoogleTest)
gtest_discover_tests(tests)
```

Test file structure:

```cpp
#include <gtest/gtest.h>
#include "my_module.hpp"

TEST(MyModuleTest, BasicOperation) {
    auto result = my_function(1, 2);
    EXPECT_EQ(result, 3);
}

TEST(MyModuleTest, EdgeCase) {
    EXPECT_THROW(my_function(-1, 0), std::invalid_argument);
}

TEST(MyModuleTest, CreatesResource) {
    auto ptr = create_resource();
    ASSERT_NE(ptr, nullptr);
}
```

Run tests:

```bash
cmake --build build
ctest --test-dir build --output-on-failure
```

## Dependency Management

Prefer the standard library (e.g. `std::format` over `fmt`) before adding a dependency.
When one is needed, use FetchContent pinned to a release tag:

```cmake
FetchContent_Declare(
    <name>
    GIT_REPOSITORY https://github.com/<owner>/<repo>.git
    GIT_TAG        <release-tag>
)
FetchContent_MakeAvailable(<name>)
target_link_libraries(${PROJECT_NAME} PRIVATE <name>::<name>)
```

## Argument Handling

- If `$ARGUMENTS` is a filename ending in `.cpp`, `.hpp`, `.h`, or `.cc`, work with that file
- If `$ARGUMENTS` is "new <filename>", scaffold a new file with proper headers
- If `$ARGUMENTS` is "build", configure and build the CMake project
- If `$ARGUMENTS` is "run", build and run the project executable
- If `$ARGUMENTS` is "test", build and run the test suite
- If `$ARGUMENTS` is "check", run cppcheck on the files you changed
- If `$ARGUMENTS` is "sanitize", build with ASan+UBSan and run the test suite
- Otherwise, treat `$ARGUMENTS` as a general C++ development request
