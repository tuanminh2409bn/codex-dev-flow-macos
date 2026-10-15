# C and C++ (CMake, Meson, Make, Native FFI)

Use only for the affected C or C++ target.

## Discover narrowly

Read `CMakeLists.txt`, `CMakePresets.json`, `meson.build`, `Makefile`, `BUILD.bazel`, `conanfile.*`, or `vcpkg.json`. Detect the C/C++ standard (`C11`/`C17`, `C++17`/`C++20`/`C++23`), compiler toolchain, existing out-of-source build directory (`build/`, `out/`), and test runner (`ctest`, `gtest`, `catch2`, `doctest`). Ignore build output directories, object/archive files, generated IDL/Protobuf headers, and third-party vendor trees.

Reuse the existing configured build directory; do not run in-source builds or hardcode host-specific compiler paths into build definitions.

## Preserve ABI, headers, and build boundaries

- Keep public headers minimal: prefer forward declarations where valid, preserve `#pragma once` or include guards, and never add `using namespace` at header scope.
- Preserve C ABI (`extern "C"`), struct packing/alignment, symbol visibility, and calling conventions across shared libraries and FFI bridges (Dart `dart:ffi`, Python ctypes/pybind11, JNI, Node N-API).
- Never let C++ exceptions escape across `extern "C"`, callback, or FFI boundaries.
- Guard platform-specific system calls and intrinsics with portable preprocessor checks rather than assuming macOS/POSIX everywhere.

## Memory, lifetime, and concurrency safety

- Use RAII and smart pointers (`std::unique_ptr`, `std::shared_ptr`) in C++; in C, ensure every allocation, file descriptor, or lock has deterministic cleanup on every error return path.
- Verify lifetime validity when returning or storing `std::string_view`, `std::span`, raw pointers, or references captured in lambdas/threads.
- Guard against out-of-bounds indexing, signed/unsigned overflow, uninitialized reads, use-after-move, and data races on shared state (`std::mutex`, `std::atomic`).

## Verification ladder

Use configured presets or build targets. Run only applicable stages:

1. `clang-format` or `clang-tidy` on changed translation units and headers.
2. Incremental target build (`cmake --build <build-dir> --target <target>` or `ninja -C <build-dir> <target>`) with compiler warnings clean.
3. Focused test execution (`ctest --test-dir <build-dir> -R <pattern> --output-on-failure` or direct test binary filter).
4. Sanitizer run (`AddressSanitizer`, `UndefinedBehaviorSanitizer`, or `ThreadSanitizer`) when pointer, memory, lifetime, or threading logic changed and toolchain supports it.
5. Downstream link or FFI binding smoke test when public headers or exported symbols changed.
