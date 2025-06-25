include("functions.jl")

using InteractiveUtils

const DEFAULT_ARRAY_SIZE = 1000
const DEFAULT_MATRIX_SIZE = 1000
const DEFAULT_VECTOR_SIZE = 1000 * 1000
const ELEMENT_TYPES = (Float64, Float32, Int64, Int32)

function get_array_types()
    if VERSION >= v"1.11"
        return (Matrix, Vector, Memory)
    else
        return (Matrix, Vector)
    end
end

#Check if the function is compatible with the array type
function is_array_type_compatible(func, ArrayType)
    method_sig = methods(func)[1].sig
    argtypes = method_sig.parameters[2:end]
    for argtype in argtypes
        if (argtype <: AbstractArray) && !(ArrayType <: argtype)
            return false
        end
    end
    return true
end

function should_skip_test(func_name::String, ArrayType)
    if VERSION >= v"1.11"
        return ArrayType == Memory && contains(func_name, "_const")
    else
        return false
    end
end


function get_all_functions(mod::Module)
    name = names(mod, all=true)
    return filter(x->x isa Function, map(x->getglobal(mod, x), name))[3:end]
end
# Simple type signature function
function get_type_signature(func, T, ArrayType)
    method_sig = methods(func)[1].sig
    argtypes = method_sig.parameters[2:end]
    concrete_types = []
    for argtype in argtypes
        if !(argtype <: AbstractArray) && isconcretetype(argtype)
            #scalar
            push!(concrete_types, argtype)
        elseif argtype <: AbstractArray && ArrayType <: argtype
            push!(concrete_types, ArrayType{T})
        else
            error("Unsupported type: $argtype for function $func with element type $T and array type $ArrayType")
        end
    end
    return Tuple(concrete_types)
end

function get_llvm_for_function(func, T, ArrayType)
    is_array_type_compatible(func, ArrayType) || return nothing
    type_sig = get_type_signature(func, T, ArrayType)
    io = IOBuffer()
    code_llvm(io, func, type_sig, raw=true, dump_module=true)
    code = String(take!(io))
    return code
end

function build_args_for_function(func, T, ArrayType)
    is_array_type_compatible(func, ArrayType) || return nothing
    type_sig = get_type_signature(func, T, ArrayType)
    vector_size = DEFAULT_VECTOR_SIZE
    matrix_size = DEFAULT_MATRIX_SIZE
    args = []
    for type in type_sig
        if type <: AbstractArray
            if type <: AbstractMatrix
                push!(args, ArrayType{T}(undef, DEFAULT_MATRIX_SIZE, DEFAULT_MATRIX_SIZE))
            else
                push!(args, ArrayType{T}(undef, DEFAULT_VECTOR_SIZE))
            end
        else
            if type <: Int
                push!(args, rand(1:3))
            else
                push!(args, rand(type))
            end
        end
    end
    return Tuple(args)
end

#this doesn't test if the function does what it's supposed to do, just that it runs
function test_function(func, T, ArrayType)
    args = build_args_for_function(func, T, ArrayType)
    func(args...)
end

function is_vectorized(llvm_ir::String)
    ir_lower = lowercase(llvm_ir)

    # Check for vector types (e.g., <4 x double>, <8 x float>, <2 x i64>)
    vector_type_pattern = r"<\d+\s+x\s+\w+>"
    has_vector_types = occursin(vector_type_pattern, ir_lower)

    # Check for vector instructions
    vector_instructions = [
        "shufflevector", "extractelement", "insertelement",
        "llvm.vector", "llvm.masked", "llvm.vp.",
        "llvm.experimental.vector", "llvm.loop.vectorize"
    ]
    has_vector_instructions = any(instr -> occursin(instr, ir_lower), vector_instructions)

    # Check for SIMD intrinsics
    simd_patterns = [
        "llvm.x86.avx", "llvm.x86.sse", "llvm.x86.avx2", "llvm.x86.avx512",
        "llvm.aarch64.neon", "llvm.arm.neon"
    ]
    has_simd = any(pattern -> occursin(pattern, ir_lower), simd_patterns)

    # Check for loop vectorization metadata
    has_loop_metadata = occursin("llvm.loop", ir_lower) || occursin("!llvm.loop", ir_lower)

    return has_vector_types || has_vector_instructions || has_simd || has_loop_metadata
end

# Print version information
function print_version_info()
    println("Julia version: ", VERSION)
    if VERSION >= v"1.11"
        println("Memory type testing enabled")
        println("Note: _const variants will be skipped for Memory arrays (Const() not supported)")
    else
        println("Memory type testing disabled (requires Julia 1.11+)")
    end
end

# Smoke test for all functions
function run_smoke_tests()
    functions = get_all_functions(Functions)
    for func in functions
        for T in ELEMENT_TYPES
            for ArrayType in get_array_types()
                if should_skip_test(string(func), ArrayType) || is_array_type_compatible(func, ArrayType) == false
                    continue
                end
                test_function(func, T, ArrayType)
                println("$func($T, $ArrayType): PASS")
            end
        end
    end
end

function run_correctness_tests()
    println("Running correctness tests for functions1.jl")
    println("="^80)
    include("test1.jl")
    println("\nRunning correctness tests for functions2.jl")
    println("="^80)
    include("test2.jl")
end

function analyze_vectorization()
    output_file = "vectorization_analysis_results.txt"

    open(output_file, "w") do file
        println(file, "TSVC Vectorization Analysis Results")
        println(file, "=" ^ 80)
        print_version_info()
        if VERSION >= v"1.11"
            println(file, "NOTE: Memory type testing enabled (Julia 1.11+)")
            println(file, "      _const variants skipped for Memory (Const() not supported)")
            println(file, "=" ^ 80)
        end
        println(file, "Function\t\t\tType\t\tArray Type\tVectorized")
        println(file, "=" ^ 80)

        functions = get_all_functions(Functions)
        element_types = ELEMENT_TYPES
        array_types = get_array_types()

        total_tests = 0
        vectorized_count = 0

        for func in functions

            for T in element_types
                for ArrayType in array_types
                    if should_skip_test(string(func), ArrayType) || is_array_type_compatible(func, ArrayType) == false
                        continue
                    end
                    test_function(func, T, ArrayType)
                    total_tests += 1

                    try
                        llvm_ir = get_llvm_for_function(func, T, ArrayType)
                        vectorized = is_vectorized(llvm_ir)

                        if vectorized
                            vectorized_count += 1
                        end

                        array_type_str = string(ArrayType)
                        status = vectorized ? "YES" : "NO"
                        func_name_padded = rpad(string(func), 25)

                        println(file, "$func_name_padded\t$T\t\t$array_type_str{$T}\t$status")
                        println("$func($T, $array_type_str): $status")

                    catch e
                        println(file, "$func\t\t$T\t\t$ArrayType{$T}\tERROR: $e")
                        println("$func($T, $ArrayType): ERROR - $e")
                    end
                end
            end
            println(file, "-" ^ 40)
        end


        println(file, "\nOVERALL SUMMARY:")
        println(file, "=" ^ 80)
        println(file, "Total tests: $total_tests")
        println(file, "Vectorized: $vectorized_count")
        println(file, "Not vectorized: $(total_tests - vectorized_count)")
        println(file, "Overall vectorization rate: $(round(vectorized_count/total_tests * 100, digits=2))%")

        # Print to console
        println("\n" * "=" ^ 80)

        println("\nOVERALL SUMMARY:")
        println("Total tests: $total_tests")
        println("Vectorized: $vectorized_count")
        println("Not vectorized: $(total_tests - vectorized_count)")
        println("Overall vectorization rate: $(round(vectorized_count/total_tests * 100, digits=2))%")
    end

    println("\nResults written to $output_file")
end

# Parse command line arguments
# --vectorize to run the vectorization analysis
# --smoke to run the tests
# --correctness to run correctness tests
if !isinteractive()
    if "--vectorize" in ARGS
        analyze_vectorization()
    elseif "--smoke" in ARGS
        run_smoke_tests()
    elseif "--correctness" in ARGS
        run_correctness_tests()
    end
end