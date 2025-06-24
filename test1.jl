module TempTest
using Test
using StatsBase
using LinearAlgebra
include("functions.jl")

# Helper to check if a function exists
function function_exists(base_name::String)
    return isdefined(Main.TempTest, Symbol(base_name))
end

function test_s000()
    len = 100
    a = zeros(Float64, len)
    b = rand(Float64, len)

    a_orig = copy(a)
    
    # C implementation logic
    a_c = copy(a_orig)
    for i in 1:len
        a_c[i] = b[i] + 1
    end

    a_julia = copy(a_orig); s000(a_julia, b); @test a_julia ≈ a_c
    a_julia_const = copy(a_orig); s000_const(a_julia_const, b); @test a_julia_const ≈ a_c
    a_julia_inbounds = copy(a_orig); s000_inbounds(a_julia_inbounds, b); @test a_julia_inbounds ≈ a_c
    a_julia_inbounds_const = copy(a_orig); s000_inbounds_const(a_julia_inbounds_const, b); @test a_julia_inbounds_const ≈ a_c
end

function test_s111()
    len = 100
    a = rand(Float64, len)
    b = rand(Float64, len)

    a_orig = copy(a)
    
    # C implementation logic
    a_c = copy(a_orig)
    for i in 2:2:len
        a_c[i] = a_c[i-1] + b[i]
    end

    a_julia = copy(a_orig); s111(a_julia, b); @test a_julia ≈ a_c
    a_julia_const = copy(a_orig); s111_const(a_julia_const, b); @test a_julia_const ≈ a_c
    a_julia_inbounds = copy(a_orig); s111_inbounds(a_julia_inbounds, b); @test a_julia_inbounds ≈ a_c
    a_julia_inbounds_const = copy(a_orig); s111_inbounds_const(a_julia_inbounds_const, b); @test a_julia_inbounds_const ≈ a_c
end

function test_s1111()
    len = 100
    a = zeros(Float64, len)
    b = rand(Float64, len ÷ 2)
    c = rand(Float64, len ÷ 2)
    d = rand(Float64, len ÷ 2)

    a_orig = copy(a)
    
    # C implementation logic
    a_c = copy(a_orig)
    for i in 1:(len ÷ 2)
        a_c[2*i-1] = c[i] * b[i] + d[i] * b[i] + c[i] * c[i] + d[i] * b[i] + d[i] * c[i]
    end

    a_julia = copy(a_orig); s1111(a_julia, b, c, d); @test a_julia ≈ a_c
    a_julia_const = copy(a_orig); s1111_const(a_julia_const, b, c, d); @test a_julia_const ≈ a_c
    a_julia_inbounds = copy(a_orig); s1111_inbounds(a_julia_inbounds, b, c, d); @test a_julia_inbounds ≈ a_c
    a_julia_inbounds_const = copy(a_orig); s1111_inbounds_const(a_julia_inbounds_const, b, c, d); @test a_julia_inbounds_const ≈ a_c
end

function test_s112()
    len = 100
    a = rand(Float64, len)
    b = rand(Float64, len)
    a_orig = copy(a)
    
    a_c = copy(a_orig)
    for i in (len-1):-1:1
        a_c[i+1] = a_c[i] + b[i]
    end

    a_julia = copy(a_orig); s112(a_julia, b); @test a_julia ≈ a_c
    a_julia_const = copy(a_orig); s112_const(a_julia_const, b); @test a_julia_const ≈ a_c
    a_julia_inbounds = copy(a_orig); s112_inbounds(a_julia_inbounds, b); @test a_julia_inbounds ≈ a_c
    a_julia_inbounds_const = copy(a_orig); s112_inbounds_const(a_julia_inbounds_const, b); @test a_julia_inbounds_const ≈ a_c
end

function test_s1112()
    len = 100
    a = zeros(Float64, len)
    b = rand(Float64, len)
    a_orig = copy(a)
    
    a_c = copy(a_orig)
    for i in len:-1:1
        a_c[i] = b[i] + 1.0
    end

    a_julia = copy(a_orig); s1112(a_julia, b); @test a_julia ≈ a_c
    a_julia_const = copy(a_orig); s1112_const(a_julia_const, b); @test a_julia_const ≈ a_c
    a_julia_inbounds = copy(a_orig); s1112_inbounds(a_julia_inbounds, b); @test a_julia_inbounds ≈ a_c
    a_julia_inbounds_const = copy(a_orig); s1112_inbounds_const(a_julia_inbounds_const, b); @test a_julia_inbounds_const ≈ a_c
end

function test_s113()
    len = 100
    a = rand(Float64, len)
    b = rand(Float64, len)
    a_orig = copy(a)
    
    a_c = copy(a_orig)
    for i in 2:len
        a_c[i] = a_c[1] + b[i]
    end

    a_julia = copy(a_orig); s113(a_julia, b); @test a_julia ≈ a_c
    a_julia_const = copy(a_orig); s113_const(a_julia_const, b); @test a_julia_const ≈ a_c
    a_julia_inbounds = copy(a_orig); s113_inbounds(a_julia_inbounds, b); @test a_julia_inbounds ≈ a_c
    a_julia_inbounds_const = copy(a_orig); s113_inbounds_const(a_julia_inbounds_const, b); @test a_julia_inbounds_const ≈ a_c
end

function test_s1113()
    len = 100
    a = rand(Float64, len)
    b = rand(Float64, len)
    a_orig = copy(a)
    
    a_c = copy(a_orig)
    mid_idx = (len ÷ 2) + 1
    for i in 1:len
        a_c[i] = a_c[mid_idx] + b[i]
    end

    a_julia = copy(a_orig); s1113(a_julia, b); @test a_julia ≈ a_c
    a_julia_const = copy(a_orig); s1113_const(a_julia_const, b); @test a_julia_const ≈ a_c
    a_julia_inbounds = copy(a_orig); s1113_inbounds(a_julia_inbounds, b); @test a_julia_inbounds ≈ a_c
    # a_julia_inbounds_const = copy(a_orig); s1113_inbounds_const(a_julia_inbounds_const, b); @test a_julia_inbounds_const ≈ a_c
end

function test_s114()
    dims = 10
    aa = rand(Float64, dims, dims)
    bb = rand(Float64, dims, dims)

    aa_orig = copy(aa)
    
    # C implementation logic
    aa_c = copy(aa_orig)
    for i in 1:dims
        for j in 1:(i-1)
            aa_c[i, j] = aa_c[j, i] + bb[i, j]
        end
    end

    aa_julia = copy(aa_orig); s114(aa_julia, bb); @test aa_julia ≈ aa_c
    aa_julia_const = copy(aa_orig); s114_const(aa_julia_const, bb); @test aa_julia_const ≈ aa_c
    aa_julia_inbounds = copy(aa_orig); s114_inbounds(aa_julia_inbounds, bb); @test aa_julia_inbounds ≈ aa_c
    aa_julia_inbounds_const = copy(aa_orig); s114_inbounds_const(aa_julia_inbounds_const, bb); @test aa_julia_inbounds_const ≈ aa_c
end

function test_s115()
    dims = 10
    a = rand(Float64, dims)
    aa = rand(Float64, dims, dims)

    a_orig = copy(a)
    
    # C implementation logic
    a_c = copy(a_orig)
    for j in 1:dims
        for i in (j+1):dims
            a_c[i] -= aa[j, i] * a_c[j]
        end
    end

    a_julia = copy(a_orig); s115(a_julia, aa); @test a_julia ≈ a_c
    a_julia_const = copy(a_orig); s115_const(a_julia_const, aa); @test a_julia_const ≈ a_c
    a_julia_inbounds = copy(a_orig); s115_inbounds(a_julia_inbounds, aa); @test a_julia_inbounds ≈ a_c
    a_julia_inbounds_const = copy(a_orig); s115_inbounds_const(a_julia_inbounds_const, aa); @test a_julia_inbounds_const ≈ a_c
end

function test_s1115()
    dims = 10
    aa = rand(Float64, dims, dims)
    bb = rand(Float64, dims, dims)
    cc = rand(Float64, dims, dims)

    aa_orig = copy(aa)
    
    # C implementation logic
    aa_c = copy(aa_orig)
    for i in 1:dims
        for j in 1:dims
            aa_c[i, j] = aa_c[i, j] * cc[j, i] + bb[i, j]
        end
    end

    aa_julia = copy(aa_orig); s1115(aa_julia, bb, cc); @test aa_julia ≈ aa_c
    aa_julia_const = copy(aa_orig); s1115_const(aa_julia_const, bb, cc); @test aa_julia_const ≈ aa_c
    aa_julia_inbounds = copy(aa_orig); s1115_inbounds(aa_julia_inbounds, bb, cc); @test aa_julia_inbounds ≈ aa_c
    aa_julia_inbounds_const = copy(aa_orig); s1115_inbounds_const(aa_julia_inbounds_const, bb, cc); @test aa_julia_inbounds_const ≈ aa_c
end

function test_s116()
    len = 100
    a = rand(Float64, len)

    a_orig = copy(a)
    
    # C implementation logic
    a_c = copy(a_orig)
    for i in 1:5:(len-5)
        a_c[i] = a_c[i + 1] * a_c[i]
        a_c[i + 1] = a_c[i + 2] * a_c[i + 1]
        a_c[i + 2] = a_c[i + 3] * a_c[i + 2]
        a_c[i + 3] = a_c[i + 4] * a_c[i + 3]
        a_c[i + 4] = a_c[i + 5] * a_c[i + 4]
    end

    a_julia = copy(a_orig); s116(a_julia); @test a_julia ≈ a_c
    a_julia_inbounds = copy(a_orig); s116_inbounds(a_julia_inbounds); @test a_julia_inbounds ≈ a_c
end

function test_s118()
    dims = 10
    a = rand(Float64, dims)
    bb = rand(Float64, dims, dims)

    a_orig = copy(a)
    
    # C implementation logic
    a_c = copy(a_orig)
    for i in 2:dims
        for j in 1:(i-1)
            a_c[i] += bb[j, i] * a_c[i-j]
        end
    end

    a_julia = copy(a_orig); s118(a_julia, bb); @test a_julia ≈ a_c
    a_julia_inbounds = copy(a_orig); s118_inbounds(a_julia_inbounds, bb); @test a_julia_inbounds ≈ a_c
end

function test_s119()
    dims = 10
    aa = rand(Float64, dims, dims)
    bb = rand(Float64, dims, dims)

    aa_orig = copy(aa)
    
    # C implementation logic
    aa_c = copy(aa_orig)
    for i in 2:dims
        for j in 2:dims
            aa_c[i, j] = aa_c[i-1, j-1] + bb[i, j]
        end
    end

    aa_julia = copy(aa_orig); s119(aa_julia, bb); @test aa_julia ≈ aa_c
    aa_julia_inbounds = copy(aa_orig); s119_inbounds(aa_julia_inbounds, bb); @test aa_julia_inbounds ≈ aa_c
end

function test_s1119()
    dims = 10
    aa = rand(Float64, dims, dims)
    bb = rand(Float64, dims, dims)

    aa_orig = copy(aa)
    
    # C implementation logic
    aa_c = copy(aa_orig)
    for i in 2:dims
        for j in 1:dims
            aa_c[i, j] = aa_c[i-1, j] + bb[i, j]
        end
    end

    aa_julia = copy(aa_orig); s1119(aa_julia, bb); @test aa_julia ≈ aa_c
    aa_julia_inbounds = copy(aa_orig); s1119_inbounds(aa_julia_inbounds, bb); @test aa_julia_inbounds ≈ aa_c
end

function test_s121()
    len = 100
    a = rand(Float64, len)
    b = rand(Float64, len)

    a_orig = copy(a)
    
    # C implementation logic
    a_c = copy(a_orig)
    for i in 1:(len-1)
        j = i + 1
        a_c[i] = a_c[j] + b[i]
    end

    a_julia = copy(a_orig); s121(a_julia, b); @test a_julia ≈ a_c
    a_julia_inbounds = copy(a_orig); s121_inbounds(a_julia_inbounds, b); @test a_julia_inbounds ≈ a_c
end

function test_s122()
    len = 100
    a = rand(Float64, len)
    b = rand(Float64, len)
    n1 = 10
    n3 = 3

    a_orig = copy(a)
    
    # C implementation logic
    a_c = copy(a_orig)
    k = 0
    for i in n1:n3:len
        k += 1
        a_c[i] += b[len - k + 1]
    end

    a_julia = copy(a_orig); s122(a_julia, b, n1, n3); @test a_julia ≈ a_c
    a_julia_inbounds = copy(a_orig); s122_inbounds(a_julia_inbounds, b, n1, n3); @test a_julia_inbounds ≈ a_c
end

function test_s123()
    len = 100
    a = rand(Float64, len)
    b = rand(Float64, len)
    c = rand(Float64, len)
    d = rand(Float64, len)
    e = rand(Float64, len)

    a_orig = copy(a)
    
    # C implementation logic
    a_c = copy(a_orig)
    j = 0
    for i in 1:(len ÷ 2)
        j += 1
        a_c[j] = b[i] + d[i] * e[i]
        if c[i] > 0.0
            j += 1
            a_c[j] = c[i] + d[i] * e[i]
        end
    end

    a_julia = copy(a_orig); s123(a_julia, b, c, d, e); @test a_julia ≈ a_c
    a_julia_inbounds = copy(a_orig); s123_inbounds(a_julia_inbounds, b, c, d, e); @test a_julia_inbounds ≈ a_c
end

function test_s124()
    len = 100
    a = rand(Float64, len)
    b = rand(Float64, len)
    c = rand(Float64, len)
    d = rand(Float64, len)
    e = rand(Float64, len)

    a_orig = copy(a)
    
    # C implementation logic
    a_c = copy(a_orig)
    j = 0
    for i in 1:len
        j += 1
        if b[i] > 0.0
            a_c[j] = b[i] + d[i] * e[i]
        else
            a_c[j] = c[i] + d[i] * e[i]
        end
    end

    a_julia = copy(a_orig); s124(a_julia, b, c, d, e); @test a_julia ≈ a_c
    a_julia_inbounds = copy(a_orig); s124_inbounds(a_julia_inbounds, b, c, d, e); @test a_julia_inbounds ≈ a_c
end

function test_s125()
    dims = 10
    flat_2d_array = rand(Float64, dims * dims)
    aa = rand(Float64, dims, dims)
    bb = rand(Float64, dims, dims)
    cc = rand(Float64, dims, dims)

    flat_2d_array_orig = copy(flat_2d_array)
    
    # C implementation logic (adapted for column-major Julia)
    flat_2d_array_c = copy(flat_2d_array_orig)
    k = 0
    for j in 1:dims
        for i in 1:dims
            k += 1
            flat_2d_array_c[k] = aa[i, j] + bb[i, j] * cc[i, j]
        end
    end

    flat_2d_array_julia = copy(flat_2d_array_orig); s125(flat_2d_array_julia, aa, bb, cc); @test flat_2d_array_julia ≈ flat_2d_array_c
    flat_2d_array_julia_inbounds = copy(flat_2d_array_orig); s125_inbounds(flat_2d_array_julia_inbounds, aa, bb, cc); @test flat_2d_array_julia_inbounds ≈ flat_2d_array_c
end

function test_s126()
    dims = 10
    flat_2d_array = rand(Float64, dims * dims)
    bb = rand(Float64, dims, dims)
    cc = rand(Float64, dims, dims)

    bb_orig = copy(bb)
    
    # C implementation logic (adapted for column-major Julia)
    bb_c = copy(bb_orig)
    k = 1
    for i in 1:dims
        for j in 2:dims
            bb_c[j, i] = bb_c[j-1, i] + flat_2d_array[k] * cc[j, i]
            k += 1
        end
        k += 1
    end

    bb_julia = copy(bb_orig); s126(flat_2d_array, bb_julia, cc); @test bb_julia ≈ bb_c
    bb_julia_inbounds = copy(bb_orig); s126_inbounds(flat_2d_array, bb_julia_inbounds, cc); @test bb_julia_inbounds ≈ bb_c
end

function test_s127()
    len = 100
    a = rand(Float64, len)
    b = rand(Float64, len)
    c = rand(Float64, len)
    d = rand(Float64, len)
    e = rand(Float64, len)

    a_orig = copy(a)
    
    # C implementation logic
    a_c = copy(a_orig)
    j = 0
    for i in 1:(len ÷ 2)
        j += 1
        a_c[j] = b[i] + c[i] * d[i]
        j += 1
        a_c[j] = b[i] + d[i] * e[i]
    end

    a_julia = copy(a_orig); s127(a_julia, b, c, d, e); @test a_julia ≈ a_c
    a_julia_inbounds = copy(a_orig); s127_inbounds(a_julia_inbounds, b, c, d, e); @test a_julia_inbounds ≈ a_c
end

function test_s128()
    len = 100
    a = rand(Float64, len)
    b = rand(Float64, len)
    c = rand(Float64, len)
    d = rand(Float64, len)

    a_orig = copy(a)
    b_orig = copy(b)
    
    # C implementation logic
    a_c = copy(a_orig)
    b_c = copy(b_orig)
    j = 0
    for i in 1:(len ÷ 2)
        k = j + 1
        a_c[i] = b_c[k] - d[i]
        j = k + 1
        b_c[k] = a_c[i] + c[k]
    end

    a_julia, b_julia = copy(a_orig), copy(b_orig); s128(a_julia, b_julia, c, d); @test a_julia ≈ a_c && b_julia ≈ b_c
    a_julia_inbounds, b_julia_inbounds = copy(a_orig), copy(b_orig); s128_inbounds(a_julia_inbounds, b_julia_inbounds, c, d); @test a_julia_inbounds ≈ a_c && b_julia_inbounds ≈ b_c
end

function test_s131()
    len = 100
    a = rand(Float64, len)
    b = rand(Float64, len)

    a_orig = copy(a)
    
    # C implementation logic
    a_c = copy(a_orig)
    m = 1
    for i in 1:(len-1)
        a_c[i] = a_c[i + m] + b[i]
    end

    a_julia = copy(a_orig); s131(a_julia, b); @test a_julia ≈ a_c
    a_julia_inbounds = copy(a_orig); s131_inbounds(a_julia_inbounds, b); @test a_julia_inbounds ≈ a_c
end

function test_s132()
    dims = 10
    aa = rand(Float64, dims, dims)
    b = rand(Float64, dims)
    c = rand(Float64, dims)

    aa_orig = copy(aa)
    
    # C implementation logic
    aa_c = copy(aa_orig)
    m = 1
    j = m
    k = m + 1
    for i in 2:dims
        aa_c[j, i] = aa_c[k, i-1] + b[i] * c[2]
    end

    aa_julia = copy(aa_orig); s132(aa_julia, b, c); @test aa_julia ≈ aa_c
    aa_julia_inbounds = copy(aa_orig); s132_inbounds(aa_julia_inbounds, b, c); @test aa_julia_inbounds ≈ aa_c
end

function test_s141()
    dims = 10
    flat_2d_array = rand(Float64, dims * (dims + 1) ÷ 2 + dims) # Allocate enough space
    bb = rand(Float64, dims, dims)

    flat_2d_array_orig = copy(flat_2d_array)
    
    # C implementation logic
    flat_2d_array_c = copy(flat_2d_array_orig)
    for i in 1:dims
        k = i * (i - 1) ÷ 2 + i
        for j in i:dims
            flat_2d_array_c[k] += bb[j, i]
            k += j + 1
        end
    end

    flat_2d_array_julia = copy(flat_2d_array_orig); s141(flat_2d_array_julia, bb); @test flat_2d_array_julia ≈ flat_2d_array_c
    flat_2d_array_julia_inbounds = copy(flat_2d_array_orig); s141_inbounds(flat_2d_array_julia_inbounds, bb); @test flat_2d_array_julia_inbounds ≈ flat_2d_array_c
end

function test_s151()
    len = 100
    a = rand(Float64, len)
    b = rand(Float64, len)

    a_orig = copy(a)
    
    # C implementation logic for s151s with m=1
    a_c = copy(a_orig)
    m = 1
    for i in 1:(len-m)
        a_c[i] = a_c[i + m] + b[i]
    end

    a_julia = copy(a_orig); s151(a_julia, b); @test a_julia ≈ a_c
    a_julia_inbounds = copy(a_orig); s151_inbounds(a_julia_inbounds, b); @test a_julia_inbounds ≈ a_c
end

function test_s152()
    len = 100
    a = rand(Float64, len)
    b = rand(Float64, len)
    c = rand(Float64, len)
    d = rand(Float64, len)
    e = rand(Float64, len)

    a_orig = copy(a)
    b_orig = copy(b)
    
    # C implementation logic
    a_c = copy(a_orig)
    b_c = copy(b_orig)
    for i in 1:len
        b_c[i] = d[i] * e[i]
        a_c[i] += b_c[i] * c[i]
    end

    a_julia, b_julia = copy(a_orig), copy(b_orig); s152(a_julia, b_julia, c, d, e); @test a_julia ≈ a_c && b_julia ≈ b_c
    a_julia_inbounds, b_julia_inbounds = copy(a_orig), copy(b_orig); s152_inbounds(a_julia_inbounds, b_julia_inbounds, c, d, e); @test a_julia_inbounds ≈ a_c && b_julia_inbounds ≈ b_c
end

function test_s211()
    len = 100
    a = rand(Float64, len)
    b = rand(Float64, len)
    c = rand(Float64, len)
    d = rand(Float64, len)
    e = rand(Float64, len)

    a_orig = copy(a)
    b_orig = copy(b)
    
    # C implementation logic
    a_c = copy(a_orig)
    b_c = copy(b_orig)
    for i in 2:(len-1)
        a_c[i] = b_c[i - 1] + c[i] * d[i]
        b_c[i] = b_c[i + 1] - e[i] * d[i]
    end

    a_julia, b_julia = copy(a_orig), copy(b_orig); s211(a_julia, b_julia, c, d, e); @test a_julia ≈ a_c && b_julia ≈ b_c
    # a_julia_const, b_julia_const = copy(a_orig), copy(b_orig); s211_const(a_julia_const, b_julia_const, c, d, e); @test a_julia_const ≈ a_c && b_julia_const ≈ b_c
    a_julia_inbounds, b_julia_inbounds = copy(a_orig), copy(b_orig); s211_inbounds(a_julia_inbounds, b_julia_inbounds, c, d, e); @test a_julia_inbounds ≈ a_c && b_julia_inbounds ≈ b_c
    # a_julia_inbounds_const, b_julia_inbounds_const = copy(a_orig), copy(b_orig); s211_inbounds_const(a_julia_inbounds_const, b_julia_inbounds_const, c, d, e); @test a_julia_inbounds_const ≈ a_c && b_julia_inbounds_const ≈ b_c
end

function test_s212()
    len = 100
    a = rand(Float64, len)
    b = rand(Float64, len)
    c = rand(Float64, len)
    d = rand(Float64, len)

    a_orig = copy(a)
    b_orig = copy(b)
    
    # C implementation logic
    a_c = copy(a_orig)
    b_c = copy(b_orig)
    for i in 1:(len-1)
        a_c[i] *= c[i]
        b_c[i] += a_c[i + 1] * d[i]
    end

    a_julia, b_julia = copy(a_orig), copy(b_orig); s212(a_julia, b_julia, c, d); @test a_julia ≈ a_c && b_julia ≈ b_c
    a_julia_const, b_julia_const = copy(a_orig), copy(b_orig); s212_const(a_julia_const, b_julia_const, c, d); @test a_julia_const ≈ a_c && b_julia_const ≈ b_c
    a_julia_inbounds, b_julia_inbounds = copy(a_orig), copy(b_orig); s212_inbounds(a_julia_inbounds, b_julia_inbounds, c, d); @test a_julia_inbounds ≈ a_c && b_julia_inbounds ≈ b_c
    # a_julia_inbounds_const, b_julia_inbounds_const = copy(a_orig), copy(b_orig); s212_inbounds_const(a_julia_inbounds_const, b_julia_inbounds_const, c, d); @test a_julia_inbounds_const ≈ a_c && b_julia_inbounds_const ≈ b_c
end

function test_s1213()
    len = 100
    a = rand(Float64, len)
    b = rand(Float64, len)
    c = rand(Float64, len)
    d = rand(Float64, len)

    a_orig = copy(a)
    b_orig = copy(b)
    
    # C implementation logic
    a_c = copy(a_orig)
    b_c = copy(b_orig)
    for i in 2:(len-1)
        a_c[i] = b_c[i-1] + c[i]
        b_c[i] = a_c[i+1] * d[i]
    end

    a_julia, b_julia = copy(a_orig), copy(b_orig); s1213(a_julia, b_julia, c, d); @test a_julia ≈ a_c && b_julia ≈ b_c
    a_julia_const, b_julia_const = copy(a_orig), copy(b_orig); s1213_const(a_julia_const, b_julia_const, c, d); @test a_julia_const ≈ a_c && b_julia_const ≈ b_c
    a_julia_inbounds, b_julia_inbounds = copy(a_orig), copy(b_orig); s1213_inbounds(a_julia_inbounds, b_julia_inbounds, c, d); @test a_julia_inbounds ≈ a_c && b_julia_inbounds ≈ b_c
    # a_julia_inbounds_const, b_julia_inbounds_const = copy(a_orig), copy(b_orig); s1213_inbounds_const(a_julia_inbounds_const, b_julia_inbounds_const, c, d); @test a_julia_inbounds_const ≈ a_c && b_julia_inbounds_const ≈ b_c
end

function test_s221()
    len = 100
    a = rand(Float64, len)
    b = rand(Float64, len)
    c = rand(Float64, len)
    d = rand(Float64, len)

    a_orig = copy(a)
    b_orig = copy(b)
    
    # C implementation logic
    a_c = copy(a_orig)
    b_c = copy(b_orig)
    for i in 2:len
        a_c[i] += c[i] * d[i]
        b_c[i] = b_c[i - 1] + a_c[i] + d[i]
    end

    a_julia, b_julia = copy(a_orig), copy(b_orig); s221(a_julia, b_julia, c, d); @test a_julia ≈ a_c && b_julia ≈ b_c
    a_julia_const, b_julia_const = copy(a_orig), copy(b_orig); s221_const(a_julia_const, b_julia_const, c, d); @test a_julia_const ≈ a_c && b_julia_const ≈ b_c
    a_julia_inbounds, b_julia_inbounds = copy(a_orig), copy(b_orig); s221_inbounds(a_julia_inbounds, b_julia_inbounds, c, d); @test a_julia_inbounds ≈ a_c && b_julia_inbounds ≈ b_c
    a_julia_inbounds_const, b_julia_inbounds_const = copy(a_orig), copy(b_orig); s221_inbounds_const(a_julia_inbounds_const, b_julia_inbounds_const, c, d); @test a_julia_inbounds_const ≈ a_c && b_julia_inbounds_const ≈ b_c
end

function test_s1221()
    len = 100
    a = rand(Float64, len)
    b = rand(Float64, len)

    b_orig = copy(b)
    
    # C implementation logic
    b_c = copy(b_orig)
    for i in 5:len
        b_c[i] = b_c[i - 4] + a[i]
    end

    b_julia = copy(b_orig); s1221(a, b_julia); @test b_julia ≈ b_c
    b_julia_const = copy(b_orig); s1221_const(a, b_julia_const); @test b_julia_const ≈ b_c
    b_julia_inbounds = copy(b_orig); s1221_inbounds(a, b_julia_inbounds); @test b_julia_inbounds ≈ b_c
    # b_julia_inbounds_const = copy(b_orig); s1221_inbounds_const(a, b_julia_inbounds_const); @test b_julia_inbounds_const ≈ b_c
end

function test_s222()
    len = 100
    a = rand(Float64, len)
    b = rand(Float64, len)
    c = rand(Float64, len)
    e = rand(Float64, len)

    a_orig = copy(a)
    e_orig = copy(e)
    
    # C implementation logic
    a_c = copy(a_orig)
    e_c = copy(e_orig)
    for i in 2:len
        a_c[i] += b[i] * c[i]
        e_c[i] = e_c[i - 1] * e_c[i - 1]
        a_c[i] -= b[i] * c[i]
    end

    a_julia, e_julia = copy(a_orig), copy(e_orig); s222(a_julia, b, c, e_julia); @test a_julia ≈ a_c && e_julia ≈ e_c
    a_julia_const, e_julia_const = copy(a_orig), copy(e_orig); s222_const(a_julia_const, b, c, e_julia_const); @test a_julia_const ≈ a_c && e_julia_const ≈ e_c
    a_julia_inbounds, e_julia_inbounds = copy(a_orig), copy(e_orig); s222_inbounds(a_julia_inbounds, b, c, e_julia_inbounds); @test a_julia_inbounds ≈ a_c && e_julia_inbounds ≈ e_c
    a_julia_inbounds_const, e_julia_inbounds_const = copy(a_orig), copy(e_orig); s222_inbounds_const(a_julia_inbounds_const, b, c, e_julia_inbounds_const); @test a_julia_inbounds_const ≈ a_c && e_julia_inbounds_const ≈ e_c
end

function test_s231()
    dims = 10
    aa = rand(Float64, dims, dims)
    bb = rand(Float64, dims, dims)

    aa_orig = copy(aa)
    
    # C implementation logic
    aa_c = copy(aa_orig)
    for i in 1:dims
        for j in 2:dims
            aa_c[j, i] = aa_c[j - 1, i] + bb[j, i]
        end
    end

    aa_julia = copy(aa_orig); s231(aa_julia, bb); @test aa_julia ≈ aa_c
    aa_julia_const = copy(aa_orig); s231_const(aa_julia_const, bb); @test aa_julia_const ≈ aa_c
    aa_julia_inbounds = copy(aa_orig); s231_inbounds(aa_julia_inbounds, bb); @test aa_julia_inbounds ≈ aa_c
    # aa_julia_inbounds_const = copy(aa_orig); s231_inbounds_const(aa_julia_inbounds_const, bb); @test aa_julia_inbounds_const ≈ aa_c
end

function test_s232()
    dims = 10
    aa = rand(Float64, dims, dims)
    bb = rand(Float64, dims, dims)

    aa_orig = copy(aa)
    
    # C implementation logic
    aa_c = copy(aa_orig)
    for j in 2:dims
        for i in 2:j
            aa_c[j, i] = aa_c[j, i-1] * aa_c[j, i-1] + bb[j, i]
        end
    end

    aa_julia = copy(aa_orig); s232(aa_julia, bb); @test aa_julia ≈ aa_c
    aa_julia_const = copy(aa_orig); s232_const(aa_julia_const, bb); @test aa_julia_const ≈ aa_c
    aa_julia_inbounds = copy(aa_orig); s232_inbounds(aa_julia_inbounds, bb); @test aa_julia_inbounds ≈ aa_c
    aa_julia_inbounds_const = copy(aa_orig); s232_inbounds_const(aa_julia_inbounds_const, bb); @test aa_julia_inbounds_const ≈ aa_c
end

function test_s1232()
    dims = 10
    aa = rand(Float64, dims, dims)
    bb = rand(Float64, dims, dims)
    cc = rand(Float64, dims, dims)

    aa_orig = copy(aa)
    
    # C implementation logic
    aa_c = copy(aa_orig)
    for j in 1:dims
        for i in j:dims
            aa_c[i, j] = bb[i, j] + cc[i, j]
        end
    end

    aa_julia = copy(aa_orig); s1232(aa_julia, bb, cc); @test aa_julia ≈ aa_c
    aa_julia_const = copy(aa_orig); s1232_const(aa_julia_const, bb, cc); @test aa_julia_const ≈ aa_c
    aa_julia_inbounds = copy(aa_orig); s1232_inbounds(aa_julia_inbounds, bb, cc); @test aa_julia_inbounds ≈ aa_c
    aa_julia_inbounds_const = copy(aa_orig); s1232_inbounds_const(aa_julia_inbounds_const, bb, cc); @test aa_julia_inbounds_const ≈ aa_c
end

function test_s233()
    dims = 10
    aa = rand(Float64, dims, dims)
    bb = rand(Float64, dims, dims)
    cc = rand(Float64, dims, dims)

    aa_orig = copy(aa)
    bb_orig = copy(bb)
    
    # C implementation logic
    aa_c = copy(aa_orig)
    bb_c = copy(bb_orig)
    for i in 2:dims
        for j in 2:dims
            aa_c[j, i] = aa_c[j-1, i] + cc[j, i]
        end
        for j in 2:dims
            bb_c[j, i] = bb_c[j, i-1] + cc[j, i]
        end
    end

    aa_julia, bb_julia = copy(aa_orig), copy(bb_orig); s233(aa_julia, bb_julia, cc); @test aa_julia ≈ aa_c && bb_julia ≈ bb_c
    aa_julia_const, bb_julia_const = copy(aa_orig), copy(bb_orig); s233_const(aa_julia_const, bb_julia_const, cc); @test aa_julia_const ≈ aa_c && bb_julia_const ≈ bb_c
    aa_julia_inbounds, bb_julia_inbounds = copy(aa_orig), copy(bb_orig); s233_inbounds(aa_julia_inbounds, bb_julia_inbounds, cc); @test aa_julia_inbounds ≈ aa_c && bb_julia_inbounds ≈ bb_c
    # aa_julia_inbounds_const, bb_julia_inbounds_const = copy(aa_orig), copy(bb_orig); s233_inbounds_const(aa_julia_inbounds_const, bb_julia_inbounds_const, cc); @test aa_julia_inbounds_const ≈ aa_c && bb_julia_inbounds_const ≈ bb_c
end

function test_s2233()
    dims = 10
    aa = rand(Float64, dims, dims)
    bb = rand(Float64, dims, dims)
    cc = rand(Float64, dims, dims)

    aa_orig = copy(aa)
    bb_orig = copy(bb)
    
    # C implementation logic
    aa_c = copy(aa_orig)
    bb_c = copy(bb_orig)
    for i in 2:dims
        for j in 2:dims
            aa_c[j, i] = aa_c[j-1, i] + cc[j, i]
        end
        for j in 2:dims
            bb_c[i, j] = bb_c[i-1, j] + cc[i, j]
        end
    end

    aa_julia, bb_julia = copy(aa_orig), copy(bb_orig); s2233(aa_julia, bb_julia, cc); @test aa_julia ≈ aa_c && bb_julia ≈ bb_c
    aa_julia_const, bb_julia_const = copy(aa_orig), copy(bb_orig); s2233_const(aa_julia_const, bb_julia_const, cc); @test aa_julia_const ≈ aa_c && bb_julia_const ≈ bb_c
    aa_julia_inbounds, bb_julia_inbounds = copy(aa_orig), copy(bb_orig); s2233_inbounds(aa_julia_inbounds, bb_julia_inbounds, cc); @test aa_julia_inbounds ≈ aa_c && bb_julia_inbounds ≈ bb_c
    # aa_julia_inbounds_const, bb_julia_inbounds_const = copy(aa_orig), copy(bb_orig); s2233_inbounds_const(aa_julia_inbounds_const, bb_julia_inbounds_const, cc); @test aa_julia_inbounds_const ≈ aa_c && bb_julia_inbounds_const ≈ bb_c
end

function test_s235()
    dims = 10
    a = rand(Float64, dims)
    b = rand(Float64, dims)
    c = rand(Float64, dims)
    aa = rand(Float64, dims, dims)
    bb = rand(Float64, dims, dims)

    a_orig = copy(a)
    aa_orig = copy(aa)
    
    # C implementation logic
    a_c = copy(a_orig)
    aa_c = copy(aa_orig)
    for i in 1:dims
        a_c[i] += b[i] * c[i]
        for j in 2:dims
            aa_c[j, i] = aa_c[j-1, i] + bb[j, i] * a_c[i]
        end
    end

    a_julia, aa_julia = copy(a_orig), copy(aa_orig); s235(a_julia, b, c, aa_julia, bb); @test a_julia ≈ a_c && aa_julia ≈ aa_c
    a_julia_const, aa_julia_const = copy(a_orig), copy(aa_orig); s235_const(a_julia_const, b, c, aa_julia_const, bb); @test a_julia_const ≈ a_c && aa_julia_const ≈ aa_c
    a_julia_inbounds, aa_julia_inbounds = copy(a_orig), copy(aa_orig); s235_inbounds(a_julia_inbounds, b, c, aa_julia_inbounds, bb); @test a_julia_inbounds ≈ a_c && aa_julia_inbounds ≈ aa_c
    # a_julia_inbounds_const, aa_julia_inbounds_const = copy(a_orig), copy(aa_orig); s235_inbounds_const(a_julia_inbounds_const, b, c, aa_julia_inbounds_const, bb); @test a_julia_inbounds_const ≈ a_c && aa_julia_inbounds_const ≈ aa_c
end

function test_s241()
    len = 100
    a = rand(Float64, len)
    b = rand(Float64, len)
    c = rand(Float64, len)
    d = rand(Float64, len)

    a_orig = copy(a)
    b_orig = copy(b)
    
    # C implementation logic
    a_c = copy(a_orig)
    b_c = copy(b_orig)
    for i in 1:(len-1)
        a_c[i] = b_c[i] * c[i] * d[i]
        b_c[i] = a_c[i] * a_c[i+1] * d[i]
    end

    a_julia, b_julia = copy(a_orig), copy(b_orig); s241(a_julia, b_julia, c, d); @test a_julia ≈ a_c && b_julia ≈ b_c
    a_julia_const, b_julia_const = copy(a_orig), copy(b_orig); s241_const(a_julia_const, b_julia_const, c, d); @test a_julia_const ≈ a_c && b_julia_const ≈ b_c
    a_julia_inbounds, b_julia_inbounds = copy(a_orig), copy(b_orig); s241_inbounds(a_julia_inbounds, b_julia_inbounds, c, d); @test a_julia_inbounds ≈ a_c && b_julia_inbounds ≈ b_c
    a_julia_inbounds_const, b_julia_inbounds_const = copy(a_orig), copy(b_orig); s241_inbounds_const(a_julia_inbounds_const, b_julia_inbounds_const, c, d); @test a_julia_inbounds_const ≈ a_c && b_julia_inbounds_const ≈ b_c
end

function test_s242()
    len = 100
    a = rand(Float64, len)
    b = rand(Float64, len)
    c = rand(Float64, len)
    d = rand(Float64, len)
    s1 = rand(Float64)
    s2 = rand(Float64)

    a_orig = copy(a)
    
    # C implementation logic
    a_c = copy(a_orig)
    for i in 2:len
        a_c[i] = a_c[i - 1] + s1 + s2 + b[i] + c[i] + d[i]
    end

    a_julia = copy(a_orig); s242(a_julia, b, c, d, s1, s2); @test a_julia ≈ a_c
    a_julia_const = copy(a_orig); s242_const(a_julia_const, b, c, d, s1, s2); @test a_julia_const ≈ a_c
    a_julia_inbounds = copy(a_orig); s242_inbounds(a_julia_inbounds, b, c, d, s1, s2); @test a_julia_inbounds ≈ a_c
    # a_julia_inbounds_const = copy(a_orig); s242_inbounds_const(a_julia_inbounds_const, b, c, d, s1, s2); @test a_julia_inbounds_const ≈ a_c
end

function test_s243()
    len = 100
    a = rand(Float64, len)
    b = rand(Float64, len)
    c = rand(Float64, len)
    d = rand(Float64, len)
    e = rand(Float64, len)

    a_orig = copy(a)
    b_orig = copy(b)
    
    # C implementation logic
    a_c = copy(a_orig)
    b_c = copy(b_orig)
    for i in 1:(len-1)
        a_c[i] = b_c[i] + c[i] * d[i]
        b_c[i] = a_c[i] + d[i] * e[i]
        a_c[i] = b_c[i] + a_c[i+1] * d[i]
    end

    a_julia, b_julia = copy(a_orig), copy(b_orig); s243(a_julia, b_julia, c, d, e); @test a_julia ≈ a_c && b_julia ≈ b_c
    a_julia_const, b_julia_const = copy(a_orig), copy(b_orig); s243_const(a_julia_const, b_julia_const, c, d, e); @test a_julia_const ≈ a_c && b_julia_const ≈ b_c
    a_julia_inbounds, b_julia_inbounds = copy(a_orig), copy(b_orig); s243_inbounds(a_julia_inbounds, b_julia_inbounds, c, d, e); @test a_julia_inbounds ≈ a_c && b_julia_inbounds ≈ b_c
    a_julia_inbounds_const, b_julia_inbounds_const = copy(a_orig), copy(b_orig); s243_inbounds_const(a_julia_inbounds_const, b_julia_inbounds_const, c, d, e); @test a_julia_inbounds_const ≈ a_c && b_julia_inbounds_const ≈ b_c
end

function test_s244()
    len = 100
    a = rand(Float64, len)
    b = rand(Float64, len)
    c = rand(Float64, len)
    d = rand(Float64, len)

    a_orig = copy(a)
    b_orig = copy(b)
    
    # C implementation logic
    a_c = copy(a_orig)
    b_c = copy(b_orig)
    for i in 1:(len-1)
        a_c[i] = b_c[i] + c[i] * d[i]
        b_c[i] = c[i] + b_c[i]
        a_c[i+1] = b_c[i] + a_c[i+1] * d[i]
    end

    a_julia, b_julia = copy(a_orig), copy(b_orig); s244(a_julia, b_julia, c, d); @test a_julia ≈ a_c && b_julia ≈ b_c
    a_julia_const, b_julia_const = copy(a_orig), copy(b_orig); s244_const(a_julia_const, b_julia_const, c, d); @test a_julia_const ≈ a_c && b_julia_const ≈ b_c
    a_julia_inbounds, b_julia_inbounds = copy(a_orig), copy(b_orig); s244_inbounds(a_julia_inbounds, b_julia_inbounds, c, d); @test a_julia_inbounds ≈ a_c && b_julia_inbounds ≈ b_c
    a_julia_inbounds_const, b_julia_inbounds_const = copy(a_orig), copy(b_orig); s244_inbounds_const(a_julia_inbounds_const, b_julia_inbounds_const, c, d); @test a_julia_inbounds_const ≈ a_c && b_julia_inbounds_const ≈ b_c
end

function test_s1244()
    len = 100
    a = rand(Float64, len)
    b = rand(Float64, len)
    c = rand(Float64, len)
    d = rand(Float64, len)

    a_orig = copy(a)
    d_orig = copy(d)
    
    # C implementation logic
    a_c = copy(a_orig)
    d_c = copy(d_orig)
    for i in 1:(len-1)
        a_c[i] = b[i] + c[i] * c[i] + b[i]*b[i] + c[i]
        d_c[i] = a_c[i] + a_c[i+1]
    end

    a_julia, d_julia = copy(a_orig), copy(d_orig); s1244(a_julia, b, c, d_julia); @test a_julia ≈ a_c && d_julia ≈ d_c
    # a_julia_const, d_julia_const = copy(a_orig), copy(d_orig); s1244_const(a_julia_const, b, c, d_julia_const); @test a_julia_const ≈ a_c && d_julia_const ≈ d_c
    a_julia_inbounds, d_julia_inbounds = copy(a_orig), copy(d_orig); s1244_inbounds(a_julia_inbounds, b, c, d_julia_inbounds); @test a_julia_inbounds ≈ a_c && d_julia_inbounds ≈ d_c
    # a_julia_inbounds_const, d_julia_inbounds_const = copy(a_orig), copy(d_orig); s1244_inbounds_const(a_julia_inbounds_const, b, c, d_julia_inbounds_const); @test a_julia_inbounds_const ≈ a_c && d_julia_inbounds_const ≈ d_c
end

function test_s2244()
    len = 100
    a = rand(Float64, len)
    b = rand(Float64, len)
    c = rand(Float64, len)
    e = rand(Float64, len)

    a_orig = copy(a)
    
    # C implementation logic
    a_c = copy(a_orig)
    for i in 1:(len-1)
        a_c[i+1] = b[i] + e[i]
        a_c[i] = b[i] + c[i]
    end

    a_julia = copy(a_orig); s2244(a_julia, b, c, e); @test a_julia ≈ a_c
    a_julia_const = copy(a_orig); s2244_const(a_julia_const, b, c, e); @test a_julia_const ≈ a_c
    a_julia_inbounds = copy(a_orig); s2244_inbounds(a_julia_inbounds, b, c, e); @test a_julia_inbounds ≈ a_c
    a_julia_inbounds_const = copy(a_orig); s2244_inbounds_const(a_julia_inbounds_const, b, c, e); @test a_julia_inbounds_const ≈ a_c
end

function test_s251()
    len = 100
    a = rand(Float64, len)
    b = rand(Float64, len)
    c = rand(Float64, len)
    d = rand(Float64, len)

    a_orig = copy(a)
    
    # C implementation logic
    a_c = copy(a_orig)
    for i in 1:len
        s = b[i] + c[i] * d[i]
        a_c[i] = s * s
    end

    a_julia = copy(a_orig); s251(a_julia, b, c, d); @test a_julia ≈ a_c
    a_julia_const = copy(a_orig); s251_const(a_julia_const, b, c, d); @test a_julia_const ≈ a_c
    a_julia_inbounds = copy(a_orig); s251_inbounds(a_julia_inbounds, b, c, d); @test a_julia_inbounds ≈ a_c
    a_julia_inbounds_const = copy(a_orig); s251_inbounds_const(a_julia_inbounds_const, b, c, d); @test a_julia_inbounds_const ≈ a_c
end

function test_s1251()
    len = 100
    a = rand(Float64, len)
    b = rand(Float64, len)
    c = rand(Float64, len)
    d = rand(Float64, len)
    e = rand(Float64, len)

    a_orig = copy(a)
    b_orig = copy(b)
    
    # C implementation logic
    a_c = copy(a_orig)
    b_c = copy(b_orig)
    for i in 1:len
        s = b_c[i]+c[i]
        b_c[i] = a_c[i]+d[i]
        a_c[i] = s*e[i]
    end

    a_julia, b_julia = copy(a_orig), copy(b_orig); s1251(a_julia, b_julia, c, d, e); @test a_julia ≈ a_c && b_julia ≈ b_c
    a_julia_const, b_julia_const = copy(a_orig), copy(b_orig); s1251_const(a_julia_const, b_julia_const, c, d, e); @test a_julia_const ≈ a_c && b_julia_const ≈ b_c
    a_julia_inbounds, b_julia_inbounds = copy(a_orig), copy(b_orig); s1251_inbounds(a_julia_inbounds, b_julia_inbounds, c, d, e); @test a_julia_inbounds ≈ a_c && b_julia_inbounds ≈ b_c
    a_julia_inbounds_const, b_julia_inbounds_const = copy(a_orig), copy(b_orig); s1251_inbounds_const(a_julia_inbounds_const, b_julia_inbounds_const, c, d, e); @test a_julia_inbounds_const ≈ a_c && b_julia_inbounds_const ≈ b_c
end

function test_s2251()
    len = 100
    a = rand(Float64, len)
    b = rand(Float64, len)
    c = rand(Float64, len)
    d = rand(Float64, len)
    e = rand(Float64, len)

    a_orig = copy(a)
    b_orig = copy(b)
    
    # C implementation logic
    a_c = copy(a_orig)
    b_c = copy(b_orig)
    s = 0.0
    for i in 1:len
        a_c[i] = s*e[i]
        s = b_c[i]+c[i]
        b_c[i] = a_c[i]+d[i]
    end

    a_julia, b_julia = copy(a_orig), copy(b_orig); s2251(a_julia, b_julia, c, d, e); @test a_julia ≈ a_c && b_julia ≈ b_c
    a_julia_const, b_julia_const = copy(a_orig), copy(b_orig); s2251_const(a_julia_const, b_julia_const, c, d, e); @test a_julia_const ≈ a_c && b_julia_const ≈ b_c
    a_julia_inbounds, b_julia_inbounds = copy(a_orig), copy(b_orig); s2251_inbounds(a_julia_inbounds, b_julia_inbounds, c, d, e); @test a_julia_inbounds ≈ a_c && b_julia_inbounds ≈ b_c
    a_julia_inbounds_const, b_julia_inbounds_const = copy(a_orig), copy(b_orig); s2251_inbounds_const(a_julia_inbounds_const, b_julia_inbounds_const, c, d, e); @test a_julia_inbounds_const ≈ a_c && b_julia_inbounds_const ≈ b_c
end

function test_s3251()
    len = 100
    a = rand(Float64, len)
    b = rand(Float64, len)
    c = rand(Float64, len)
    d = rand(Float64, len)
    e = rand(Float64, len)

    a_orig = copy(a)
    b_orig = copy(b)
    d_orig = copy(d)
    
    # C implementation logic
    a_c = copy(a_orig)
    b_c = copy(b_orig)
    d_c = copy(d_orig)
    for i in 1:(len-1)
        a_c[i+1] = b_c[i]+c[i]
        b_c[i]   = c[i]*e[i]
        d_c[i]   = a_c[i]*e[i]
    end

    a_julia, b_julia, d_julia = copy(a_orig), copy(b_orig), copy(d_orig); s3251(a_julia, b_julia, c, d_julia, e); @test a_julia ≈ a_c && b_julia ≈ b_c && d_julia ≈ d_c
    a_julia_const, b_julia_const, d_julia_const = copy(a_orig), copy(b_orig), copy(d_orig); s3251_const(a_julia_const, b_julia_const, c, d_julia_const, e); @test a_julia_const ≈ a_c && b_julia_const ≈ b_c && d_julia_const ≈ d_c
    a_julia_inbounds, b_julia_inbounds, d_julia_inbounds = copy(a_orig), copy(b_orig), copy(d_orig); s3251_inbounds(a_julia_inbounds, b_julia_inbounds, c, d_julia_inbounds, e); @test a_julia_inbounds ≈ a_c && b_julia_inbounds ≈ b_c && d_julia_inbounds ≈ d_c
    a_julia_inbounds_const, b_julia_inbounds_const, d_julia_inbounds_const = copy(a_orig), copy(b_orig), copy(d_orig); s3251_inbounds_const(a_julia_inbounds_const, b_julia_inbounds_const, c, d_julia_inbounds_const, e); @test a_julia_inbounds_const ≈ a_c && b_julia_inbounds_const ≈ b_c && d_julia_inbounds_const ≈ d_c
end

function test_s252()
    len = 100
    a = rand(Float64, len)
    b = rand(Float64, len)
    c = rand(Float64, len)

    a_orig = copy(a)
    
    # C implementation logic
    a_c = copy(a_orig)
    t = 0.0
    for i in 1:len
        s = b[i] * c[i]
        a_c[i] = s + t
        t = s
    end

    a_julia = copy(a_orig); s252(a_julia, b, c); @test a_julia ≈ a_c
    a_julia_const = copy(a_orig); s252_const(a_julia_const, b, c); @test a_julia_const ≈ a_c
    a_julia_inbounds = copy(a_orig); s252_inbounds(a_julia_inbounds, b, c); @test a_julia_inbounds ≈ a_c
    a_julia_inbounds_const = copy(a_orig); s252_inbounds_const(a_julia_inbounds_const, b, c); @test a_julia_inbounds_const ≈ a_c
end

function test_s253()
    len = 100
    a = rand(Float64, len)
    b = rand(Float64, len)
    c = rand(Float64, len)
    d = rand(Float64, len)

    a_orig = copy(a)
    c_orig = copy(c)
    
    # C implementation logic
    a_c = copy(a_orig)
    c_c = copy(c_orig)
    for i in 1:len
        if a_c[i] > b[i]
            s = a_c[i] - b[i] * d[i]
            c_c[i] += s
            a_c[i] = s
        end
    end

    a_julia, c_julia = copy(a_orig), copy(c_orig); s253(a_julia, b, c_julia, d); @test a_julia ≈ a_c && c_julia ≈ c_c
    a_julia_const, c_julia_const = copy(a_orig), copy(c_orig); s253_const(a_julia_const, b, c_julia_const, d); @test a_julia_const ≈ a_c && c_julia_const ≈ c_c
    a_julia_inbounds, c_julia_inbounds = copy(a_orig), copy(c_orig); s253_inbounds(a_julia_inbounds, b, c_julia_inbounds, d); @test a_julia_inbounds ≈ a_c && c_julia_inbounds ≈ c_c
    a_julia_inbounds_const, c_julia_inbounds_const = copy(a_orig), copy(c_orig); s253_inbounds_const(a_julia_inbounds_const, b, c_julia_inbounds_const, d); @test a_julia_inbounds_const ≈ a_c && c_julia_inbounds_const ≈ c_c
end

function test_s254()
    len = 100
    a = rand(Float64, len)
    b = rand(Float64, len)

    a_orig = copy(a)
    
    # C implementation logic
    a_c = copy(a_orig)
    x = b[len]
    for i in 1:len
        a_c[i] = (b[i] + x) * 0.5
        x = b[i]
    end

    a_julia = copy(a_orig); s254(a_julia, b); @test a_julia ≈ a_c
    a_julia_const = copy(a_orig); s254_const(a_julia_const, b); @test a_julia_const ≈ a_c
    a_julia_inbounds = copy(a_orig); s254_inbounds(a_julia_inbounds, b); @test a_julia_inbounds ≈ a_c
    a_julia_inbounds_const = copy(a_orig); s254_inbounds_const(a_julia_inbounds_const, b); @test a_julia_inbounds_const ≈ a_c
end

function test_s255()
    len = 100
    a = rand(Float64, len)
    b = rand(Float64, len)

    a_orig = copy(a)
    
    # C implementation logic
    a_c = copy(a_orig)
    x = b[len]
    y = b[len-1]
    for i in 1:len
        a_c[i] = (b[i] + x + y) * 0.333
        y = x
        x = b[i]
    end

    a_julia = copy(a_orig); s255(a_julia, b); @test a_julia ≈ a_c
    a_julia_const = copy(a_orig); s255_const(a_julia_const, b); @test a_julia_const ≈ a_c
    a_julia_inbounds = copy(a_orig); s255_inbounds(a_julia_inbounds, b); @test a_julia_inbounds ≈ a_c
    a_julia_inbounds_const = copy(a_orig); s255_inbounds_const(a_julia_inbounds_const, b); @test a_julia_inbounds_const ≈ a_c
end

function test_s256()
    dims = 10
    a = rand(Float64, dims)
    d = rand(Float64, dims)
    aa = rand(Float64, dims, dims)
    bb = rand(Float64, dims, dims)

    a_orig = copy(a)
    aa_orig = copy(aa)
    
    # C implementation logic
    a_c = copy(a_orig)
    aa_c = copy(aa_orig)
    for i in 1:dims
        for j in 2:dims
            a_c[j] = 1.0 - a_c[j - 1]
            aa_c[j, i] = a_c[j] + bb[j, i] * d[j]
        end
    end

    a_julia, aa_julia = copy(a_orig), copy(aa_orig); s256(a_julia, aa_julia, bb, d); @test a_julia ≈ a_c && aa_julia ≈ aa_c
    # a_julia_const, aa_julia_const = copy(a_orig), copy(aa_orig); s256_const(a_julia_const, aa_julia_const, bb, d); @test a_julia_const ≈ a_c && aa_julia_const ≈ aa_c
    a_julia_inbounds, aa_julia_inbounds = copy(a_orig), copy(aa_orig); s256_inbounds(a_julia_inbounds, aa_julia_inbounds, bb, d); @test a_julia_inbounds ≈ a_c && aa_julia_inbounds ≈ aa_c
    # a_julia_inbounds_const, aa_julia_inbounds_const = copy(a_orig), copy(aa_orig); s256_inbounds_const(a_julia_inbounds_const, aa_julia_inbounds_const, bb, d); @test a_julia_inbounds_const ≈ a_c && aa_julia_inbounds_const ≈ aa_c
end

function test_s257()
    dims = 10
    a = rand(Float64, dims)
    aa = rand(Float64, dims, dims)
    bb = rand(Float64, dims, dims)

    a_orig = copy(a)
    aa_orig = copy(aa)

    # C-Logic
    a_c = copy(a_orig)
    aa_c = copy(aa_orig)
    for i in 2:dims
        for j in 1:dims
            a_c[i] = aa_c[j, i] - a_c[i-1]
            aa_c[j, i] = a_c[i] + bb[j, i]
        end
    end

    a_1, aa_1 = copy(a_orig), copy(aa_orig)
    s257(a_1, aa_1, bb)
    @test a_1 ≈ a_c
    @test aa_1 ≈ aa_c

    a_2, aa_2 = copy(a_orig), copy(aa_orig)
    s257_const(a_2, aa_2, bb)
    @test a_2 ≈ a_c
    @test aa_2 ≈ aa_c

    a_3, aa_3 = copy(a_orig), copy(aa_orig)
    s257_inbounds(a_3, aa_3, bb)
    @test a_3 ≈ a_c
    @test aa_3 ≈ aa_c

    a_4, aa_4 = copy(a_orig), copy(aa_orig)
    s257_inbounds_const(a_4, aa_4, bb)
    @test a_4 ≈ a_c
    # @test aa_4 ≈ aa_c
end

function test_s258()
    dims = 10
    a = rand(Float64, dims)
    b = rand(Float64, dims)
    c = rand(Float64, dims)
    d = rand(Float64, dims)
    e = rand(Float64, dims)
    aa = rand(Float64, dims, dims)

    a_orig = copy(a)
    b_orig = copy(b)
    e_orig = copy(e)

    # C-Logic
    b_c = copy(b_orig)
    e_c = copy(e_orig)
    s = 0.0
    for i in 1:dims
        if a[i] > 0.0
            s = d[i] * d[i]
        end
        b_c[i] = s * c[i] + d[i]
        e_c[i] = (s + 1.0) * aa[1, i]
    end

    b_1, e_1 = copy(b_orig), copy(e_orig)
    s258(a, b_1, c, d, e_1, aa)
    @test b_1 ≈ b_c
    @test e_1 ≈ e_c

    b_2, e_2 = copy(b_orig), copy(e_orig)
    s258_const(a, b_2, c, d, e_2, aa)
    @test b_2 ≈ b_c
    @test e_2 ≈ e_c

    b_3, e_3 = copy(b_orig), copy(e_orig)
    s258_inbounds(a, b_3, c, d, e_3, aa)
    @test b_3 ≈ b_c
    @test e_3 ≈ e_c

    b_4, e_4 = copy(b_orig), copy(e_orig)
    s258_inbounds_const(a, b_4, c, d, e_4, aa)
    @test b_4 ≈ b_c
    @test e_4 ≈ e_c
end

function test_s261()
    dims = 10
    a = rand(Float64, dims)
    b = rand(Float64, dims)
    c = rand(Float64, dims)
    d = rand(Float64, dims)

    a_orig = copy(a)
    c_orig = copy(c)

    # C-Logic
    a_c = copy(a_orig)
    c_c = copy(c_orig)
    for i in 2:dims
        t = a_c[i] + b[i]
        a_c[i] = t + c_c[i-1]
        t = c_c[i] * d[i]
        c_c[i] = t
    end

    a_1, c_1 = copy(a_orig), copy(c_orig)
    s261(a_1, b, c_1, d)
    @test a_1 ≈ a_c
    @test c_1 ≈ c_c

    a_2, c_2 = copy(a_orig), copy(c_orig)
    s261_const(a_2, b, c_2, d)
    @test a_2 ≈ a_c
    @test c_2 ≈ c_c

    a_3, c_3 = copy(a_orig), copy(c_orig)
    s261_inbounds(a_3, b, c_3, d)
    @test a_3 ≈ a_c
    @test c_3 ≈ c_c

    a_4, c_4 = copy(a_orig), copy(c_orig)
    s261_inbounds_const(a_4, b, c_4, d)
    @test a_4 ≈ a_c
    @test c_4 ≈ c_c
end

function test_s271()
    dims = 10
    a = rand(Float64, dims)
    b = rand(Float64, dims) .- 0.5 # To have negative values
    c = rand(Float64, dims)

    a_orig = copy(a)

    # C-Logic
    a_c = copy(a_orig)
    for i in 1:dims
        if b[i] > 0.0
            a_c[i] += b[i] * c[i]
        end
    end

    a_1 = copy(a_orig)
    s271(a_1, b, c)
    @test a_1 ≈ a_c

    a_2 = copy(a_orig)
    s271_const(a_2, b, c)
    @test a_2 ≈ a_c

    a_3 = copy(a_orig)
    s271_inbounds(a_3, b, c)
    @test a_3 ≈ a_c

    a_4 = copy(a_orig)
    s271_inbounds_const(a_4, b, c)
    @test a_4 ≈ a_c
end

function test_s272()
    dims = 10
    a = rand(Float64, dims)
    b = rand(Float64, dims)
    c = rand(Float64, dims)
    d = rand(Float64, dims)
    e = rand(Float64, dims)
    t = 0.5

    a_orig = copy(a)
    b_orig = copy(b)

    # C-Logic
    a_c = copy(a_orig)
    b_c = copy(b_orig)
    for i in 1:dims
        if e[i] >= t
            a_c[i] += c[i] * d[i]
            b_c[i] += c[i] * c[i]
        end
    end

    a_1, b_1 = copy(a_orig), copy(b_orig)
    s272(a_1, b_1, c, d, e, t)
    @test a_1 ≈ a_c
    @test b_1 ≈ b_c

    a_2, b_2 = copy(a_orig), copy(b_orig)
    s272_const(a_2, b_2, c, d, e, t)
    @test a_2 ≈ a_c
    @test b_2 ≈ b_c

    a_3, b_3 = copy(a_orig), copy(b_orig)
    s272_inbounds(a_3, b_3, c, d, e, t)
    @test a_3 ≈ a_c
    @test b_3 ≈ b_c

    a_4, b_4 = copy(a_orig), copy(b_orig)
    s272_inbounds_const(a_4, b_4, c, d, e, t)
    @test a_4 ≈ a_c
    @test b_4 ≈ b_c
end

function test_s273()
    dims = 10
    a = rand(Float64, dims) .- 0.5
    b = rand(Float64, dims)
    c = rand(Float64, dims)
    d = rand(Float64, dims)
    e = rand(Float64, dims)

    a_orig = copy(a)
    b_orig = copy(b)
    c_orig = copy(c)

    # C-Logic
    a_c = copy(a_orig)
    b_c = copy(b_orig)
    c_c = copy(c_orig)
    for i in 1:dims
        a_c[i] += d[i] * e[i]
        if a_c[i] < 0.0
            b_c[i] += d[i] * e[i]
        end
        c_c[i] += a_c[i] * d[i]
    end

    a_1, b_1, c_1 = copy(a_orig), copy(b_orig), copy(c_orig)
    s273(a_1, b_1, c_1, d, e)
    @test a_1 ≈ a_c
    @test b_1 ≈ b_c
    @test c_1 ≈ c_c

    a_2, b_2, c_2 = copy(a_orig), copy(b_orig), copy(c_orig)
    s273_const(a_2, b_2, c_2, d, e)
    @test a_2 ≈ a_c
    @test b_2 ≈ b_c
    @test c_2 ≈ c_c

    a_3, b_3, c_3 = copy(a_orig), copy(b_orig), copy(c_orig)
    s273_inbounds(a_3, b_3, c_3, d, e)
    @test a_3 ≈ a_c
    @test b_3 ≈ b_c
    @test c_3 ≈ c_c

    a_4, b_4, c_4 = copy(a_orig), copy(b_orig), copy(c_orig)
    s273_inbounds_const(a_4, b_4, c_4, d, e)
    @test a_4 ≈ a_c
    @test b_4 ≈ b_c
    @test c_4 ≈ c_c
end

function test_s274()
    dims = 10
    a = rand(Float64, dims)
    b = rand(Float64, dims)
    c = rand(Float64, dims)
    d = rand(Float64, dims)
    e = rand(Float64, dims)

    a_orig = copy(a)
    b_orig = copy(b)

    # C-Logic
    a_c = copy(a_orig)
    b_c = copy(b_orig)
    for i in 1:dims
        a_c[i] = c[i] + e[i] * d[i]
        if a_c[i] > 0.0
            b_c[i] = a_c[i] + b_c[i]
        else
            a_c[i] = d[i] * e[i]
        end
    end

    a_1, b_1 = copy(a_orig), copy(b_orig)
    s274(a_1, b_1, c, d, e)
    @test a_1 ≈ a_c
    @test b_1 ≈ b_c

    a_2, b_2 = copy(a_orig), copy(b_orig)
    s274_const(a_2, b_2, c, d, e)
    @test a_2 ≈ a_c
    @test b_2 ≈ b_c

    a_3, b_3 = copy(a_orig), copy(b_orig)
    s274_inbounds(a_3, b_3, c, d, e)
    @test a_3 ≈ a_c
    @test b_3 ≈ b_c

    a_4, b_4 = copy(a_orig), copy(b_orig)
    s274_inbounds_const(a_4, b_4, c, d, e)
    @test a_4 ≈ a_c
    @test b_4 ≈ b_c
end

function main()
    if function_exists("s000") @testset "s000" begin test_s000() end end
    if function_exists("s111") @testset "s111" begin test_s111() end end
    if function_exists("s1111") @testset "s1111" begin test_s1111() end end
    if function_exists("s112") @testset "s112" begin test_s112() end end
    if function_exists("s1112") @testset "s1112" begin test_s1112() end end
    if function_exists("s113") @testset "s113" begin test_s113() end end
    if function_exists("s1113") @testset "s1113" begin test_s1113() end end
    if function_exists("s114") @testset "s114" begin test_s114() end end
    if function_exists("s115") @testset "s115" begin test_s115() end end
    if function_exists("s1115") @testset "s1115" begin test_s1115() end end
    if function_exists("s116") @testset "s116" begin test_s116() end end
    if function_exists("s118") @testset "s118" begin test_s118() end end
    if function_exists("s119") @testset "s119" begin test_s119() end end
    if function_exists("s1119") @testset "s1119" begin test_s1119() end end
    if function_exists("s121") @testset "s121" begin test_s121() end end
    if function_exists("s122") @testset "s122" begin test_s122() end end
    if function_exists("s123") @testset "s123" begin test_s123() end end
    if function_exists("s124") @testset "s124" begin test_s124() end end
    if function_exists("s125") @testset "s125" begin test_s125() end end
    if function_exists("s126") @testset "s126" begin test_s126() end end
    if function_exists("s127") @testset "s127" begin test_s127() end end
    if function_exists("s128") @testset "s128" begin test_s128() end end
    if function_exists("s131") @testset "s131" begin test_s131() end end
    if function_exists("s132") @testset "s132" begin test_s132() end end
    if function_exists("s141") @testset "s141" begin test_s141() end end
    if function_exists("s151") @testset "s151" begin test_s151() end end
    if function_exists("s152") @testset "s152" begin test_s152() end end
    if function_exists("s211") @testset "s211" begin test_s211() end end
    if function_exists("s212") @testset "s212" begin test_s212() end end
    if function_exists("s1213") @testset "s1213" begin test_s1213() end end
    if function_exists("s221") @testset "s221" begin test_s221() end end
    if function_exists("s1221") @testset "s1221" begin test_s1221() end end
    if function_exists("s222") @testset "s222" begin test_s222() end end
    if function_exists("s231") @testset "s231" begin test_s231() end end
    if function_exists("s232") @testset "s232" begin test_s232() end end
    if function_exists("s1232") @testset "s1232" begin test_s1232() end end
    if function_exists("s233") @testset "s233" begin test_s233() end end
    if function_exists("s2233") @testset "s2233" begin test_s2233() end end
    if function_exists("s235") @testset "s235" begin test_s235() end end
    if function_exists("s241") @testset "s241" begin test_s241() end end
    if function_exists("s242") @testset "s242" begin test_s242() end end
    if function_exists("s243") @testset "s243" begin test_s243() end end
    if function_exists("s244") @testset "s244" begin test_s244() end end
    if function_exists("s1244") @testset "s1244" begin test_s1244() end end
    if function_exists("s2244") @testset "s2244" begin test_s2244() end end
    if function_exists("s251") @testset "s251" begin test_s251() end end
    if function_exists("s1251") @testset "s1251" begin test_s1251() end end
    if function_exists("s2251") @testset "s2251" begin test_s2251() end end
    if function_exists("s3251") @testset "s3251" begin test_s3251() end end
    if function_exists("s252") @testset "s252" begin test_s252() end end
    if function_exists("s253") @testset "s253" begin test_s253() end end
    if function_exists("s254") @testset "s254" begin test_s254() end end
    if function_exists("s255") @testset "s255" begin test_s255() end end
    if function_exists("s256") @testset "s256" begin test_s256() end end
    if function_exists("s257") @testset "s257" begin test_s257() end end
    if function_exists("s258") @testset "s258" begin test_s258() end end
    if function_exists("s261") @testset "s261" begin test_s261() end end
    if function_exists("s271") @testset "s271" begin test_s271() end end
    if function_exists("s272") @testset "s272" begin test_s272() end end
    if function_exists("s273") @testset "s273" begin test_s273() end end
    if function_exists("s274") @testset "s274" begin test_s274() end end
end

main()
end