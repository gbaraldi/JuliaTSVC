# Julia TSVC Implementation

This project contains a Julia implementation of the TSVC (Test Suite for Vectorizing Compilers), with the primary goal of testing and optimizing compiler performance for various loop vectorization scenarios. The implementation was developed with the assistance of an AI pair programmer.

## Usage

The `main.jl` script is the main entry point for running the test suite. It accepts the following command-line arguments to control its behavior:

- **`--correctness`**: Runs the full correctness test suite (`test1.jl` and `test2.jl`). This verifies the logical correctness of the ported Julia functions by comparing their output against the original C implementation's logic.

- **`--vectorize`**: Performs a static analysis of the compiled LLVM IR for each function to check for vectorization. It generates a detailed report in `vectorization_analysis_results.txt` showing which function variants were successfully vectorized by the compiler.

- **`--smoke`**: Executes a basic "smoke test" for all function variants. This test ensures that each function can be called with the expected argument types without throwing an immediate error. It does not verify the correctness of the results.

### Examples

Run the correctness tests:
```bash
julia main.jl --correctness
```

Run the vectorization analysis:
```bash
julia main.jl --vectorize
```

## About

This code is based on the C-language TSVC benchmark suite. The Julia port was created to explore and benchmark the performance of the Julia compiler's auto-vectorization capabilities. 