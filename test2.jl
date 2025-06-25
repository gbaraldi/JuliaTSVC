module TempTest
using Test
using StatsBase
using LinearAlgebra
include("functions2.jl")

function test_s275()
    dims = 10
    aa = rand(Float64, dims, dims)
    aa[1, :] .-= 0.5
    bb = rand(Float64, dims, dims)
    cc = rand(Float64, dims, dims)
    
    aa_orig = copy(aa)

    # C implementation logic
    aa_c = copy(aa_orig)
    for i in 1:dims
        if aa_c[1, i] > 0.0
            for j in 2:dims
                aa_c[j, i] = aa_c[j-1, i] + bb[j, i] * cc[j, i]
            end
        end
    end
    
    aa_julia = copy(aa_orig)
    s275(aa_julia, bb, cc)
    @test aa_julia ≈ aa_c

    aa_julia_const = copy(aa_orig)
    s275_const(aa_julia_const, bb, cc)
    @test aa_julia_const ≈ aa_c

    aa_julia_inbounds = copy(aa_orig)
    s275_inbounds(aa_julia_inbounds, bb, cc)
    @test aa_julia_inbounds ≈ aa_c
end

function test_s2275()
    dims = 10
    aa = rand(Float64, dims, dims)
    aa[1, :] .-= 0.5
    bb = rand(Float64, dims, dims)
    cc = rand(Float64, dims, dims)

    aa_orig = copy(aa)

    # C implementation logic
    aa_c = copy(aa_orig)
    for i in 1:dims
        if aa_c[1, i] > 0.0
            for j in 2:dims
                aa_c[j, i] = aa_c[j-1, i] + bb[j, i] * cc[j, i]
            end
        else
            for j in 2:dims
                aa_c[j, i] = aa_c[j-1, i] + bb[j, i] * bb[j, i]
            end
        end
    end

    aa_julia = copy(aa_orig)
    s2275(aa_julia, bb, cc)
    @test aa_julia ≈ aa_c

    aa_julia_const = copy(aa_orig)
    s2275_const(aa_julia_const, bb, cc)
    @test aa_julia_const ≈ aa_c

    aa_julia_inbounds = copy(aa_orig)
    s2275_inbounds(aa_julia_inbounds, bb, cc)
    @test aa_julia_inbounds ≈ aa_c
end

function test_s276()
    len = 10
    a = rand(Float64, len)
    b = rand(Float64, len)
    c = rand(Float64, len)
    d = rand(Float64, len)

    a_orig = copy(a)

    # C implementation logic
    a_c = copy(a_orig)
    mid = div(len, 2)
    for i in 1:len
        if i < mid
            a_c[i] += b[i] * c[i]
        else
            a_c[i] += b[i] * d[i]
        end
    end

    a_julia = copy(a_orig)
    s276(a_julia, b, c, d)
    @test a_julia ≈ a_c

    a_julia_const = copy(a_orig)
    s276_const(a_julia_const, b, c, d)
    @test a_julia_const ≈ a_c

    a_julia_inbounds = copy(a_orig)
    s276_inbounds(a_julia_inbounds, b, c, d)
    @test a_julia_inbounds ≈ a_c

    a_julia_inbounds_const = copy(a_orig)
    s276_inbounds_const(a_julia_inbounds_const, b, c, d)
    @test a_julia_inbounds_const ≈ a_c
end

function test_s277()
    len = 10
    a = rand(Float64, len) .- 0.5
    b = rand(Float64, len) .- 0.5
    c = rand(Float64, len)
    d = rand(Float64, len)
    e = rand(Float64, len)

    a_orig = copy(a)
    b_orig = copy(b)

    # C implementation logic
    a_c = copy(a_orig)
    b_c = copy(b_orig)
    for i in 1:len-1
        if a_c[i] < 0.0
            if b_c[i] < 0.0
                a_c[i] += c[i] * d[i]
            end
            b_c[i+1] = c[i] + d[i] * e[i]
        end
    end

    a_julia, b_julia = copy(a_orig), copy(b_orig)
    s277(a_julia, b_julia, c, d, e)
    @test a_julia ≈ a_c
    @test b_julia ≈ b_c

    a_julia_const, b_julia_const = copy(a_orig), copy(b_orig)
    s277_const(a_julia_const, b_julia_const, c, d, e)
    @test a_julia_const ≈ a_c
    @test b_julia_const ≈ b_c

    a_julia_inbounds, b_julia_inbounds = copy(a_orig), copy(b_orig)
    s277_inbounds(a_julia_inbounds, b_julia_inbounds, c, d, e)
    @test a_julia_inbounds ≈ a_c
    @test b_julia_inbounds ≈ b_c

    a_julia_inbounds_const, b_julia_inbounds_const = copy(a_orig), copy(b_orig)
    s277_inbounds_const(a_julia_inbounds_const, b_julia_inbounds_const, c, d, e)
    @test a_julia_inbounds_const ≈ a_c
    @test b_julia_inbounds_const ≈ b_c
end

function test_s278()
    len = 10
    a = rand(Float64, len) .- 0.5
    b = rand(Float64, len)
    c = rand(Float64, len)
    d = rand(Float64, len)
    e = rand(Float64, len)

    a_orig = copy(a)
    b_orig = copy(b)
    c_orig = copy(c)

    # C implementation logic
    a_c = copy(a_orig)
    b_c = copy(b_orig)
    c_c = copy(c_orig)
    for i in 1:len
        if a_c[i] > 0.0
            c_c[i] = -c_c[i] + d[i] * e[i]
        else
            b_c[i] = -b_c[i] + d[i] * e[i]
        end
        a_c[i] = b_c[i] + c_c[i] * d[i]
    end

    a_julia, b_julia, c_julia = copy(a_orig), copy(b_orig), copy(c_orig)
    s278(a_julia, b_julia, c_julia, d, e)
    @test a_julia ≈ a_c
    @test b_julia ≈ b_c
    @test c_julia ≈ c_c

    a_julia_const, b_julia_const, c_julia_const = copy(a_orig), copy(b_orig), copy(c_orig)
    s278_const(a_julia_const, b_julia_const, c_julia_const, d, e)
    @test a_julia_const ≈ a_c
    @test b_julia_const ≈ b_c
    @test c_julia_const ≈ c_c

    a_julia_inbounds, b_julia_inbounds, c_julia_inbounds = copy(a_orig), copy(b_orig), copy(c_orig)
    s278_inbounds(a_julia_inbounds, b_julia_inbounds, c_julia_inbounds, d, e)
    @test a_julia_inbounds ≈ a_c
    @test b_julia_inbounds ≈ b_c
    @test c_julia_inbounds ≈ c_c

    a_julia_inbounds_const, b_julia_inbounds_const, c_julia_inbounds_const = copy(a_orig), copy(b_orig), copy(c_orig)
    s278_inbounds_const(a_julia_inbounds_const, b_julia_inbounds_const, c_julia_inbounds_const, d, e)
    @test a_julia_inbounds_const ≈ a_c
    @test b_julia_inbounds_const ≈ b_c
    @test c_julia_inbounds_const ≈ c_c
end

function test_s279()
    len = 10
    a = zeros(Float64, len)
    b = rand(Float64, len)
    c = rand(Float64, len) .- 0.5
    d = rand(Float64, len)
    e = rand(Float64, len)

    a_orig = copy(a)
    
    # C implementation logic
    a_c = copy(a_orig)
    for i in 1:len
        if c[i] > 0.0
            a_c[i] = b[i] + d[i] * d[i]
        else
            a_c[i] = b[i] + e[i] * e[i]
        end
    end

    a_julia = copy(a_orig)
    s279(a_julia, b, c, d, e)
    @test a_julia ≈ a_c

    a_julia_const = copy(a_orig)
    s279_const(a_julia_const, b, c, d, e)
    @test a_julia_const ≈ a_c

    a_julia_inbounds = copy(a_orig)
    s279_inbounds(a_julia_inbounds, b, c, d, e)
    @test a_julia_inbounds ≈ a_c

    a_julia_inbounds_const = copy(a_orig)
    s279_inbounds_const(a_julia_inbounds_const, b, c, d, e)
    @test a_julia_inbounds_const ≈ a_c
end

function test_s1279()
    len = 10
    a = rand(Float64, len) .- 0.5 # To have some negative values
    b = rand(Float64, len)
    c = rand(Float64, len)
    d = rand(Float64, len)
    e = rand(Float64, len)

    # Ensure some b[i] > a[i] where a[i] is negative
    for i in 1:len
        if a[i] < 0
            b[i] = a[i] + rand() # b[i] will be > a[i]
        end
    end

    c_orig = copy(c)

    # C implementation logic
    c_c = copy(c_orig)
    for i in 1:len
        if a[i] < 0.0
            if b[i] > a[i]
                c_c[i] += d[i] * e[i]
            end
        end
    end

    c_julia = copy(c_orig)
    s1279(a, b, c_julia, d, e)
    @test c_julia ≈ c_c

    c_julia_const = copy(c_orig)
    s1279_const(a, b, c_julia_const, d, e)
    @test c_julia_const ≈ c_c

    c_julia_inbounds = copy(c_orig)
    s1279_inbounds(a, b, c_julia_inbounds, d, e)
    @test c_julia_inbounds ≈ c_c

    c_julia_inbounds_const = copy(c_orig)
    s1279_inbounds_const(a, b, c_julia_inbounds_const, d, e)
    @test c_julia_inbounds_const ≈ c_c
end

function test_s2710()
    len = 10
    a = rand(Float64, len)
    b = rand(Float64, len)
    c = rand(Float64, len)
    d = rand(Float64, len)
    e = rand(Float64, len)
    x = 1

    a_orig = copy(a)
    b_orig = copy(b)
    c_orig = copy(c)

    # C implementation logic
    a_c = copy(a_orig)
    b_c = copy(b_orig)
    c_c = copy(c_orig)
    for i in 1:len
        if a_c[i] > b_c[i]
            a_c[i] += b_c[i] * d[i]
            if len > 10
                c_c[i] += d[i] * d[i]
            else
                c_c[i] = d[i] * e[i] + 1.0
            end
        else
            b_c[i] = a_c[i] + e[i] * e[i]
            if x > 0
                c_c[i] = a_c[i] + d[i] * d[i]
            else
                c_c[i] += e[i] * e[i]
            end
        end
    end

    a_julia, b_julia, c_julia = copy(a_orig), copy(b_orig), copy(c_orig)
    s2710(a_julia, b_julia, c_julia, d, e, x)
    @test a_julia ≈ a_c
    @test b_julia ≈ b_c
    @test c_julia ≈ c_c

    a_julia_const, b_julia_const, c_julia_const = copy(a_orig), copy(b_orig), copy(c_orig)
    s2710_const(a_julia_const, b_julia_const, c_julia_const, d, e, x)
    @test a_julia_const ≈ a_c
    @test b_julia_const ≈ b_c
    @test c_julia_const ≈ c_c

    a_julia_inbounds, b_julia_inbounds, c_julia_inbounds = copy(a_orig), copy(b_orig), copy(c_orig)
    s2710_inbounds(a_julia_inbounds, b_julia_inbounds, c_julia_inbounds, d, e, x)
    @test a_julia_inbounds ≈ a_c
    @test b_julia_inbounds ≈ b_c
    @test c_julia_inbounds ≈ c_c

    a_julia_inbounds_const, b_julia_inbounds_const, c_julia_inbounds_const = copy(a_orig), copy(b_orig), copy(c_orig)
    s2710_inbounds_const(a_julia_inbounds_const, b_julia_inbounds_const, c_julia_inbounds_const, d, e, x)
    @test a_julia_inbounds_const ≈ a_c
    @test b_julia_inbounds_const ≈ b_c
    @test c_julia_inbounds_const ≈ c_c
end

function test_s2711()
    len = 10
    a = rand(Float64, len)
    b = rand(Float64, len)
    b[1] = 0.0 # Make sure some b[i] are zero
    c = rand(Float64, len)

    a_orig = copy(a)

    # C implementation logic
    a_c = copy(a_orig)
    for i in 1:len
        if b[i] != 0.0
            a_c[i] += b[i] * c[i]
        end
    end

    a_julia = copy(a_orig)
    s2711(a_julia, b, c)
    @test a_julia ≈ a_c

    a_julia_const = copy(a_orig)
    s2711_const(a_julia_const, b, c)
    @test a_julia_const ≈ a_c

    a_julia_inbounds = copy(a_orig)
    s2711_inbounds(a_julia_inbounds, b, c)
    @test a_julia_inbounds ≈ a_c

    a_julia_inbounds_const = copy(a_orig)
    s2711_inbounds_const(a_julia_inbounds_const, b, c)
    @test a_julia_inbounds_const ≈ a_c
end

function test_s2712()
    len = 10
    a = rand(Float64, len)
    b = rand(Float64, len)
    c = rand(Float64, len)

    a[1] = 1.0
    b[1] = 0.5
    
    a_orig = copy(a)

    # C implementation logic
    a_c = copy(a_orig)
    for i in 1:len
        if a_c[i] > b[i]
            a_c[i] += b[i] * c[i]
        end
    end

    a_julia = copy(a_orig)
    s2712(a_julia, b, c)
    @test a_julia ≈ a_c

    a_julia_const = copy(a_orig)
    s2712_const(a_julia_const, b, c)
    @test a_julia_const ≈ a_c

    a_julia_inbounds = copy(a_orig)
    s2712_inbounds(a_julia_inbounds, b, c)
    @test a_julia_inbounds ≈ a_c

    a_julia_inbounds_const = copy(a_orig)
    s2712_inbounds_const(a_julia_inbounds_const, b, c)
    @test a_julia_inbounds_const ≈ a_c
end

function test_s281()
    len = 10
    a = rand(Float64, len)
    b = rand(Float64, len)
    c = rand(Float64, len)
    
    a_orig = copy(a)
    b_orig = copy(b)

    # C implementation logic
    a_c = copy(a_orig)
    b_c = copy(b_orig)
    for i in 1:len
        x = a_c[len-i+1] + b_c[i] * c[i]
        a_c[i] = x - 1.0
        b_c[i] = x
    end

    a_julia, b_julia = copy(a_orig), copy(b_orig)
    s281(a_julia, b_julia, c)
    @test a_julia ≈ a_c
    @test b_julia ≈ b_c

    a_julia_const, b_julia_const = copy(a_orig), copy(b_orig)
    s281_const(a_julia_const, b_julia_const, c)
    @test a_julia_const ≈ a_c
    @test b_julia_const ≈ b_c

    a_julia_inbounds, b_julia_inbounds = copy(a_orig), copy(b_orig)
    s281_inbounds(a_julia_inbounds, b_julia_inbounds, c)
    @test a_julia_inbounds ≈ a_c
    @test b_julia_inbounds ≈ b_c

    a_julia_inbounds_const, b_julia_inbounds_const = copy(a_orig), copy(b_orig)
    s281_inbounds_const(a_julia_inbounds_const, b_julia_inbounds_const, c)
    @test a_julia_inbounds_const ≈ a_c
    @test b_julia_inbounds_const ≈ b_c
end

function test_s1281()
    len = 10
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
        x = b_c[i] * c[i] + a_c[i] * d[i] + e[i]
        a_c[i] = x - 1.0
        b_c[i] = x
    end

    a_julia, b_julia = copy(a_orig), copy(b_orig)
    s1281(a_julia, b_julia, c, d, e)
    @test a_julia ≈ a_c
    @test b_julia ≈ b_c

    a_julia_const, b_julia_const = copy(a_orig), copy(b_orig)
    s1281_const(a_julia_const, b_julia_const, c, d, e)
    @test a_julia_const ≈ a_c
    @test b_julia_const ≈ b_c

    a_julia_inbounds, b_julia_inbounds = copy(a_orig), copy(b_orig)
    s1281_inbounds(a_julia_inbounds, b_julia_inbounds, c, d, e)
    @test a_julia_inbounds ≈ a_c
    @test b_julia_inbounds ≈ b_c

    a_julia_inbounds_const, b_julia_inbounds_const = copy(a_orig), copy(b_orig)
    s1281_inbounds_const(a_julia_inbounds_const, b_julia_inbounds_const, c, d, e)
    @test a_julia_inbounds_const ≈ a_c
    @test b_julia_inbounds_const ≈ b_c
end

function test_s291()
    len = 10
    a = zeros(Float64, len)
    b = rand(Float64, len)
    
    a_orig = copy(a)

    # C implementation logic
    a_c = copy(a_orig)
    im1 = len
    for i in 1:len
        a_c[i] = (b[i] + b[im1]) * 0.5
        im1 = i
    end

    a_julia = copy(a_orig)
    s291(a_julia, b)
    @test a_julia ≈ a_c

    a_julia_const = copy(a_orig)
    s291_const(a_julia_const, b)
    @test a_julia_const ≈ a_c

    a_julia_inbounds = copy(a_orig)
    s291_inbounds(a_julia_inbounds, b)
    @test a_julia_inbounds ≈ a_c

    a_julia_inbounds_const = copy(a_orig)
    s291_inbounds_const(a_julia_inbounds_const, b)
    @test a_julia_inbounds_const ≈ a_c
end

function test_s292()
    len = 10
    a = zeros(Float64, len)
    b = rand(Float64, len)
    
    a_orig = copy(a)

    # C implementation logic
    a_c = copy(a_orig)
    im1 = len
    im2 = len - 1
    for i in 1:len
        a_c[i] = (b[i] + b[im1] + b[im2]) * 0.333
        im2 = im1
        im1 = i
    end

    a_julia = copy(a_orig)
    s292(a_julia, b)
    @test a_julia ≈ a_c

    a_julia_const = copy(a_orig)
    s292_const(a_julia_const, b)
    @test a_julia_const ≈ a_c

    a_julia_inbounds = copy(a_orig)
    s292_inbounds(a_julia_inbounds, b)
    @test a_julia_inbounds ≈ a_c

    a_julia_inbounds_const = copy(a_orig)
    s292_inbounds_const(a_julia_inbounds_const, b)
    @test a_julia_inbounds_const ≈ a_c
end

function test_s293()
    len = 10
    a = rand(Float64, len)
    
    a_orig = copy(a)

    # C implementation logic
    a_c = copy(a_orig)
    val = a_c[1]
    for i in 1:len
        a_c[i] = val
    end

    a_julia = copy(a_orig)
    s293(a_julia)
    @test a_julia ≈ a_c

    a_julia_const = copy(a_orig)
    s293_const(a_julia_const)
    @test a_julia_const ≈ a_c

    a_julia_inbounds = copy(a_orig)
    s293_inbounds(a_julia_inbounds)
    @test a_julia_inbounds ≈ a_c

    a_julia_inbounds_const = copy(a_orig)
    s293_inbounds_const(a_julia_inbounds_const)
    @test a_julia_inbounds_const ≈ a_c
end

function test_s2101()
    dims = 10
    aa = rand(Float64, dims, dims)
    bb = rand(Float64, dims, dims)
    cc = rand(Float64, dims, dims)
    
    aa_orig = copy(aa)

    # C implementation logic
    aa_c = copy(aa_orig)
    for i in 1:dims
        aa_c[i, i] += bb[i, i] * cc[i, i]
    end

    aa_julia = copy(aa_orig)
    s2101(aa_julia, bb, cc)
    @test aa_julia ≈ aa_c

    aa_julia_const = copy(aa_orig)
    s2101_const(aa_julia_const, bb, cc)
    @test aa_julia_const ≈ aa_c

    aa_julia_inbounds = copy(aa_orig)
    s2101_inbounds(aa_julia_inbounds, bb, cc)
    @test aa_julia_inbounds ≈ aa_c

    aa_julia_inbounds_const = copy(aa_orig)
    s2101_inbounds_const(aa_julia_inbounds_const, bb, cc)
    @test aa_julia_inbounds_const ≈ aa_c
end

function test_s2102()
    dims = 10
    aa = rand(Float64, dims, dims)
    
    aa_orig = copy(aa)

    # C implementation logic
    aa_c = copy(aa_orig)
    fill!(aa_c, 0.0)
    for i in 1:dims
        aa_c[i, i] = 1.0
    end

    aa_julia = copy(aa_orig)
    s2102(aa_julia)
    @test aa_julia ≈ aa_c

    aa_julia_const = copy(aa_orig)
    s2102_const(aa_julia_const)
    @test aa_julia_const ≈ aa_c

    aa_julia_inbounds = copy(aa_orig)
    s2102_inbounds(aa_julia_inbounds)
    @test aa_julia_inbounds ≈ aa_c

    aa_julia_inbounds_const = copy(aa_orig)
    s2102_inbounds_const(aa_julia_inbounds_const)
    @test aa_julia_inbounds_const ≈ aa_c
end

function test_s2111()
    dims = 10
    aa = rand(Float64, dims, dims)
    
    aa_orig = copy(aa)

    # C implementation logic
    aa_c = copy(aa_orig)
    for j in 2:dims
        for i in 2:dims
            aa_c[i, j] = (aa_c[i-1, j] + aa_c[i, j-1]) / 1.9
        end
    end

    aa_julia = copy(aa_orig)
    s2111(aa_julia)
    @test aa_julia ≈ aa_c

    aa_julia_const = copy(aa_orig)
    s2111_const(aa_julia_const)
    @test aa_julia_const ≈ aa_c

    aa_julia_inbounds = copy(aa_orig)
    s2111_inbounds(aa_julia_inbounds)
    @test aa_julia_inbounds ≈ aa_c

    aa_julia_inbounds_const = copy(aa_orig)
    s2111_inbounds_const(aa_julia_inbounds_const)
    @test aa_julia_inbounds_const ≈ aa_c
end

function test_s311()
    len = 10
    a = rand(Float64, len)
    
    # C implementation logic
    sum_c = sum(a)

    sum_julia = s311(a)
    @test sum_julia ≈ sum_c

    sum_julia_const = s311_const(a)
    @test sum_julia_const ≈ sum_c

    sum_julia_inbounds = s311_inbounds(a)
    @test sum_julia_inbounds ≈ sum_c

    sum_julia_inbounds_const = s311_inbounds_const(a)
    @test sum_julia_inbounds_const ≈ sum_c
end

function test_s312()
    len = 10
    a = rand(Float64, len)
    
    # C implementation logic
    prod_c = prod(a)

    prod_julia = s312(a)
    @test prod_julia ≈ prod_c

    prod_julia_const = s312_const(a)
    @test prod_julia_const ≈ prod_c

    prod_julia_inbounds = s312_inbounds(a)
    @test prod_julia_inbounds ≈ prod_c

    prod_julia_inbounds_const = s312_inbounds_const(a)
    @test prod_julia_inbounds_const ≈ prod_c
end

function test_s313()
    len = 10
    a = rand(Float64, len)
    b = rand(Float64, len)
    
    # C implementation logic
    dot_c = dot(a, b)

    dot_julia = s313(a, b)
    @test dot_julia ≈ dot_c

    dot_julia_const = s313_const(a, b)
    @test dot_julia_const ≈ dot_c

    dot_julia_inbounds = s313_inbounds(a, b)
    @test dot_julia_inbounds ≈ dot_c

    dot_julia_inbounds_const = s313_inbounds_const(a, b)
    @test dot_julia_inbounds_const ≈ dot_c
end

function test_s314()
    len = 10
    a = rand(Float64, len)
    
    # C implementation logic
    max_c = maximum(a)

    max_julia = s314(a)
    @test max_julia ≈ max_c

    max_julia_const = s314_const(a)
    @test max_julia_const ≈ max_c

    max_julia_inbounds = s314_inbounds(a)
    @test max_julia_inbounds ≈ max_c

    max_julia_inbounds_const = s314_inbounds_const(a)
    @test max_julia_inbounds_const ≈ max_c
end

function test_s315()
    len = 10
    a = [(i * 7) % len for i in 1:len]
    
    # C implementation logic
    max_val_c, max_idx_c = findmax(a)

    max_val_julia, max_idx_julia = s315(a)
    @test max_val_julia ≈ max_val_c
    @test max_idx_julia == max_idx_c

    max_val_julia_const, max_idx_julia_const = s315_const(a)
    @test max_val_julia_const ≈ max_val_c
    @test max_idx_julia_const == max_idx_c

    max_val_julia_inbounds, max_idx_julia_inbounds = s315_inbounds(a)
    @test max_val_julia_inbounds ≈ max_val_c
    @test max_idx_julia_inbounds == max_idx_c

    max_val_julia_inbounds_const, max_idx_julia_inbounds_const = s315_inbounds_const(a)
    @test max_val_julia_inbounds_const ≈ max_val_c
    @test max_idx_julia_inbounds_const == max_idx_c
end

function test_s316()
    len = 10
    a = rand(Float64, len)
    
    # C implementation logic
    min_c = minimum(a)

    min_julia = s316(a)
    @test min_julia ≈ min_c

    min_julia_const = s316_const(a)
    @test min_julia_const ≈ min_c

    min_julia_inbounds = s316_inbounds(a)
    @test min_julia_inbounds ≈ min_c

    min_julia_inbounds_const = s316_inbounds_const(a)
    @test min_julia_inbounds_const ≈ min_c
end

function test_s318()
    len = 10
    a = rand(Float64, len)
    inc = 2
    
    # C implementation logic
    _, max_idx_c = findmax(abs.(a[1:inc:len]))
    max_idx_c = (max_idx_c - 1) * inc + 1

    max_idx_julia = s318(a, inc)
    @test max_idx_julia == max_idx_c

    max_idx_julia_const = s318_const(a, inc)
    @test max_idx_julia_const == max_idx_c

    max_idx_julia_inbounds = s318_inbounds(a, inc)
    @test max_idx_julia_inbounds == max_idx_c

    max_idx_julia_inbounds_const = s318_inbounds_const(a, inc)
    @test max_idx_julia_inbounds_const == max_idx_c
end

function test_s319()
    len = 10
    a = zeros(Float64, len)
    b = rand(Float64, len)
    c = rand(Float64, len)
    d = rand(Float64, len)
    e = rand(Float64, len)

    a_orig = copy(a)
    b_orig = copy(b)
    
    # C implementation logic
    a_c = copy(a_orig)
    b_c = copy(b_orig)
    sum_c = 0.0
    for i in 1:len
        a_c[i] = c[i] + d[i]
        sum_c += a_c[i]
        b_c[i] = c[i] + e[i]
        sum_c += b_c[i]
    end

    a_julia, b_julia = copy(a_orig), copy(b_orig)
    sum_julia = s319(a_julia, b_julia, c, d, e)
    @test a_julia ≈ a_c
    @test b_julia ≈ b_c
    @test sum_julia ≈ sum_c

    a_julia_const, b_julia_const = copy(a_orig), copy(b_orig)
    sum_julia_const = s319_const(a_julia_const, b_julia_const, c, d, e)
    @test a_julia_const ≈ a_c
    @test b_julia_const ≈ b_c
    @test sum_julia_const ≈ sum_c

    a_julia_inbounds, b_julia_inbounds = copy(a_orig), copy(b_orig)
    sum_julia_inbounds = s319_inbounds(a_julia_inbounds, b_julia_inbounds, c, d, e)
    @test a_julia_inbounds ≈ a_c
    @test b_julia_inbounds ≈ b_c
    @test sum_julia_inbounds ≈ sum_c

    a_julia_inbounds_const, b_julia_inbounds_const = copy(a_orig), copy(b_orig)
    sum_julia_inbounds_const = s319_inbounds_const(a_julia_inbounds_const, b_julia_inbounds_const, c, d, e)
    @test a_julia_inbounds_const ≈ a_c
    @test b_julia_inbounds_const ≈ b_c
    @test sum_julia_inbounds_const ≈ sum_c
end

function test_s3110()
    dims = 10
    aa = rand(Float64, dims, dims)
    
    # C implementation logic
    max_val_c, cartesian_idx_c = findmax(aa)
    max_ix_c, max_iy_c = cartesian_idx_c[1], cartesian_idx_c[2]

    max_val_julia, max_ix_julia, max_iy_julia = s3110(aa)
    @test max_val_julia ≈ max_val_c
    @test max_ix_julia == max_ix_c
    @test max_iy_julia == max_iy_c

    max_val_julia_const, max_ix_julia_const, max_iy_julia_const = s3110_const(aa)
    @test max_val_julia_const ≈ max_val_c
    @test max_ix_julia_const == max_ix_c
    @test max_iy_julia_const == max_iy_c

    max_val_julia_inbounds, max_ix_julia_inbounds, max_iy_julia_inbounds = s3110_inbounds(aa)
    @test max_val_julia_inbounds ≈ max_val_c
    @test max_ix_julia_inbounds == max_ix_c
    @test max_iy_julia_inbounds == max_iy_c

    max_val_julia_inbounds_const, max_ix_julia_inbounds_const, max_iy_julia_inbounds_const = s3110_inbounds_const(aa)
    @test max_val_julia_inbounds_const ≈ max_val_c
    @test max_ix_julia_inbounds_const == max_ix_c
    @test max_iy_julia_inbounds_const == max_iy_c
end

function test_s3111()
    len = 10
    a = rand(Float64, len) .- 0.5
    
    # C implementation logic
    sum_c = 0.0
    for i in 1:len
        if a[i] > 0.0
            sum_c += a[i]
        end
    end

    sum_julia = s3111(a)
    @test sum_julia ≈ sum_c

    sum_julia_const = s3111_const(a)
    @test sum_julia_const ≈ sum_c

    sum_julia_inbounds = s3111_inbounds(a)
    @test sum_julia_inbounds ≈ sum_c

    sum_julia_inbounds_const = s3111_inbounds_const(a)
    @test sum_julia_inbounds_const ≈ sum_c
end

function test_s3112()
    len = 10
    a = rand(Float64, len)
    b = zeros(Float64, len)

    # C implementation logic
    b_c = zeros(Float64, len)
    sum_c = 0.0
    for i in 1:len
        sum_c += a[i]
        b_c[i] = sum_c
    end

    b_julia = zeros(Float64, len)
    sum_julia = s3112(a, b_julia)
    @test sum_julia ≈ sum_c
    @test b_julia ≈ b_c

    b_julia_const = zeros(Float64, len)
    sum_julia_const = s3112_const(a, b_julia_const)
    @test sum_julia_const ≈ sum_c
    @test b_julia_const ≈ b_c

    b_julia_inbounds = zeros(Float64, len)
    sum_julia_inbounds = s3112_inbounds(a, b_julia_inbounds)
    @test sum_julia_inbounds ≈ sum_c
    @test b_julia_inbounds ≈ b_c

    b_julia_inbounds_const = zeros(Float64, len)
    sum_julia_inbounds_const = s3112_inbounds_const(a, b_julia_inbounds_const)
    @test sum_julia_inbounds_const ≈ sum_c
    @test b_julia_inbounds_const ≈ b_c
end

function test_s3113()
    len = 100
    a = rand(Float64, len) .- 0.5

    a_orig = copy(a)

    # C implementation logic
    max_c = a_orig[1]
    for i in 1:len
        if a_orig[i] > max_c
            max_c = a_orig[i]
        end
    end

    max_julia = s3113(copy(a_orig))
    @test max_julia ≈ max_c

    max_julia_const = s3113_const(a_orig)
    @test max_julia_const ≈ max_c

    max_julia_inbounds = s3113_inbounds(a_orig)
    @test max_julia_inbounds ≈ max_c

    max_julia_inbounds_const = s3113_inbounds_const(a_orig)
    @test max_julia_inbounds_const ≈ max_c
end

function test_s321()
    len = 10
    a = ones(Float64, len)
    b = [1.0/i for i in 1:len]
    a_orig = copy(a)
    b_orig = copy(b)

    # C implementation logic
    a_c = copy(a_orig)
    for i in 2:len
        a_c[i] += a_c[i-1] * b[i]
    end

    a_julia, b_julia = copy(a_orig), copy(b_orig)
    s321(a_julia, b_julia)
    @test a_julia ≈ a_c
    @test b_julia ≈ b_orig # b is not modified

    a_julia_const, b_julia_const = copy(a_orig), copy(b_orig)
    s321_const(a_julia_const, b_julia_const)
    @test a_julia_const ≈ a_c
    @test b_julia_const ≈ b_orig

    a_julia_inbounds, b_julia_inbounds = copy(a_orig), copy(b_orig)
    s321_inbounds(a_julia_inbounds, b_julia_inbounds)
    @test a_julia_inbounds ≈ a_c
    @test b_julia_inbounds ≈ b_orig

    a_julia_inbounds_const, b_julia_inbounds_const = copy(a_orig), copy(b_orig)
    s321_inbounds_const(a_julia_inbounds_const, b_julia_inbounds_const)
    @test a_julia_inbounds_const ≈ a_c
    @test b_julia_inbounds_const ≈ b_orig
end

function test_s322()
    len = 10
    a = rand(Float64, len)
    b = rand(Float64, len)
    c = rand(Float64, len)
    a_orig = copy(a)
    b_orig = copy(b)

    # C implementation logic
    a_c = copy(a_orig)
    for i in 3:len
        a_c[i] = a_c[i] + a_c[i-1] * b[i] + a_c[i-2] * c[i]
    end

    a_julia = copy(a_orig)
    s322(a_julia, b, c)
    @test a_julia ≈ a_c

    a_julia_const = copy(a_orig)
    s322_const(a_julia_const, b, c)
    @test a_julia_const ≈ a_c

    a_julia_inbounds = copy(a_orig)
    s322_inbounds(a_julia_inbounds, b, c)
    @test a_julia_inbounds ≈ a_c

    a_julia_inbounds_const = copy(a_orig)
    s322_inbounds_const(a_julia_inbounds_const, b, c)
    @test a_julia_inbounds_const ≈ a_c
end

function test_s323()
    len = 10
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
    for i in 2:len
        a_c[i] = b_c[i-1] + c[i] * d[i]
        b_c[i] = a_c[i] + c[i] * e[i]
    end

    a_julia, b_julia = copy(a_orig), copy(b_orig)
    s323(a_julia, b_julia, c, d, e)
    @test a_julia ≈ a_c
    @test b_julia ≈ b_c

    # a_julia_const, b_julia_const = copy(a_orig), copy(b_orig)
    # s323_const(a_julia_const, b_julia_const, c, d, e)
    # @test a_julia_const ≈ a_c
    # @test b_julia_const ≈ b_c

    a_julia_inbounds, b_julia_inbounds = copy(a_orig), copy(b_orig)
    s323_inbounds(a_julia_inbounds, b_julia_inbounds, c, d, e)
    @test a_julia_inbounds ≈ a_c
    @test b_julia_inbounds ≈ b_c

    # a_julia_inbounds_const, b_julia_inbounds_const = copy(a_orig), copy(b_orig)
    # s323_inbounds_const(a_julia_inbounds_const, b_julia_inbounds_const, c, d, e)
    # @test a_julia_inbounds_const ≈ a_c
    # @test b_julia_inbounds_const ≈ b_c
end

function test_s331()
    len = 10
    a = rand(Float64, len) .- 0.5
    
    # C implementation logic
    j_c = 0
    for i in 1:len
        if a[i] < 0.0
            j_c = i
        end
    end

    j_julia = s331(a)
    @test j_julia == j_c

    j_julia_const = s331_const(a)
    @test j_julia_const == j_c

    j_julia_inbounds = s331_inbounds(a)
    @test j_julia_inbounds == j_c

    j_julia_inbounds_const = s331_inbounds_const(a)
    @test j_julia_inbounds_const == j_c
end

function test_s332()
    len = 10
    a = rand(Float64, len)
    t = 0

    # C implementation logic
    index_c = -1
    value_c = -1.0
    for i in 1:len
        if a[i] > t
            index_c = i
            value_c = a[i]
            break
        end
    end

    value_julia, index_julia = s332(a, t)
    @test value_julia ≈ value_c
    @test index_julia == index_c

    value_julia_const, index_julia_const = s332_const(a, t)
    @test value_julia_const ≈ value_c
    @test index_julia_const == index_c

    value_julia_inbounds, index_julia_inbounds = s332_inbounds(a, t)
    @test value_julia_inbounds ≈ value_c
    @test index_julia_inbounds == index_c

    value_julia_inbounds_const, index_julia_inbounds_const = s332_inbounds_const(a, t)
    @test value_julia_inbounds_const ≈ value_c
    @test index_julia_inbounds_const == index_c
end

function test_s341()
    len = 100
    a = zeros(Float64, len)
    b = rand(Float64, len) .- 0.5
    a_orig = copy(a)

    # C implementation logic
    a_c = copy(a_orig)
    j = 0
    for i in 1:len
        if b[i] > 0.0
            j += 1
            a_c[j] = b[i]
        end
    end

    a_julia = copy(a_orig)
    s341(a_julia, b)
    @test a_julia ≈ a_c

    a_julia_const = copy(a_orig)
    s341_const(a_julia_const, b)
    @test a_julia_const ≈ a_c

    a_julia_inbounds = copy(a_orig)
    s341_inbounds(a_julia_inbounds, b)
    @test a_julia_inbounds ≈ a_c

    a_julia_inbounds_const = copy(a_orig)
    s341_inbounds_const(a_julia_inbounds_const, b)
    @test a_julia_inbounds_const ≈ a_c
end

function test_s342()
    len = 100
    a = rand(Float64, len) .- 0.5
    b = rand(Float64, len)
    c = rand(1:len, len) # Index vector

    a_orig = copy(a)

    # C implementation logic (gather operation)
    a_c = copy(a_orig)
    for i in 1:len
        a_c[i] = b[c[i]]
    end

    a_julia = copy(a_orig)
    s342(a_julia, b, c)
    @test a_julia ≈ a_c

    a_julia_const = copy(a_orig)
    s342_const(a_julia_const, b, c)
    @test a_julia_const ≈ a_c

    a_julia_inbounds = copy(a_orig)
    s342_inbounds(a_julia_inbounds, b, c)
    @test a_julia_inbounds ≈ a_c

    a_julia_inbounds_const = copy(a_orig)
    s342_inbounds_const(a_julia_inbounds_const, b, c)
    @test a_julia_inbounds_const ≈ a_c
end

function test_s343()
    dims = 10
    flat_2d_array = zeros(Float64, dims * dims)
    aa = rand(Float64, dims, dims)
    bb = rand(Float64, dims, dims) .- 0.5
    flat_2d_array_orig = copy(flat_2d_array)

    # C implementation logic
    flat_2d_array_c = copy(flat_2d_array_orig)
    k = 0
    for i in 1:dims
        for j in 1:dims
            if bb[j, i] > 0.0
                k += 1
                flat_2d_array_c[k] = aa[j, i]
            end
        end
    end

    flat_2d_array_julia = copy(flat_2d_array_orig)
    s343(flat_2d_array_julia, aa, bb)
    @test flat_2d_array_julia ≈ flat_2d_array_c

    flat_2d_array_julia_const = copy(flat_2d_array_orig)
    s343_const(flat_2d_array_julia_const, aa, bb)
    @test flat_2d_array_julia_const ≈ flat_2d_array_c

    flat_2d_array_julia_inbounds = copy(flat_2d_array_orig)
    s343_inbounds(flat_2d_array_julia_inbounds, aa, bb)
    @test flat_2d_array_julia_inbounds ≈ flat_2d_array_c

    flat_2d_array_julia_inbounds_const = copy(flat_2d_array_orig)
    s343_inbounds_const(flat_2d_array_julia_inbounds_const, aa, bb)
    @test flat_2d_array_julia_inbounds_const ≈ flat_2d_array_c
end

function test_s351()
    len = 10
    a = rand(Float64, len)
    b = rand(Float64, len)
    c = rand(Float64, 1)
    a_orig = copy(a)
    alpha = c[1]

    # C implementation logic
    a_c = copy(a_orig)
    for i in 1:len
        a_c[i] += alpha * b[i]
    end

    a_julia = copy(a_orig)
    s351(a_julia, b, c)
    @test a_julia ≈ a_c

    a_julia_const = copy(a_orig)
    s351_const(a_julia_const, b, c)
    @test a_julia_const ≈ a_c

    a_julia_inbounds = copy(a_orig)
    s351_inbounds(a_julia_inbounds, b, c)
    @test a_julia_inbounds ≈ a_c

    a_julia_inbounds_const = copy(a_orig)
    s351_inbounds_const(a_julia_inbounds_const, b, c)
    @test a_julia_inbounds_const ≈ a_c
end

function test_s1351()
    len = 10
    a = rand(Float64, len)
    b = rand(Float64, len)
    c = rand(Float64, len)
    a_orig = copy(a)

    # C implementation logic
    a_c = copy(a_orig)
    for i in 1:len
        a_c[i] = b[i] + c[i]
    end

    a_julia = copy(a_orig)
    s1351(a_julia, b, c)
    @test a_julia ≈ a_c

    a_julia_const = copy(a_orig)
    s1351_const(a_julia_const, b, c)
    @test a_julia_const ≈ a_c

    a_julia_inbounds = copy(a_orig)
    s1351_inbounds(a_julia_inbounds, b, c)
    @test a_julia_inbounds ≈ a_c

    a_julia_inbounds_const = copy(a_orig)
    s1351_inbounds_const(a_julia_inbounds_const, b, c)
    @test a_julia_inbounds_const ≈ a_c
end

function test_s352()
    len = 10
    a = rand(Float64, len)
    b = rand(Float64, len)

    # C implementation logic
    dot_c = 0.0
    for i in 1:len
        dot_c += a[i] * b[i]
    end

    dot_julia = s352(a, b)
    @test dot_julia ≈ dot_c

    dot_julia_const = s352_const(a, b)
    @test dot_julia_const ≈ dot_c

    dot_julia_inbounds = s352_inbounds(a, b)
    @test dot_julia_inbounds ≈ dot_c

    dot_julia_inbounds_const = s352_inbounds_const(a, b)
    @test dot_julia_inbounds_const ≈ dot_c
end

function test_s353()
    len = 100
    a = rand(Float64, len)
    b = rand(Float64, len)
    c = rand(Float64, 1)
    ip = [( (i-1) * 7 + 3) % (len - 1) for i in 1:len]

    a_orig = copy(a)

    # C implementation logic
    a_c = copy(a_orig)
    alpha = c[1]
    for i in 1:len
        a_c[i] += alpha * b[ip[i]+1]
    end

    a_julia = copy(a_orig)
    s353(a_julia, b, c, ip)
    @test a_julia ≈ a_c

    a_julia_const = copy(a_orig)
    s353_const(a_julia_const, b, c, ip)
    @test a_julia_const ≈ a_c

    a_julia_inbounds = copy(a_orig)
    s353_inbounds(a_julia_inbounds, b, c, ip)
    @test a_julia_inbounds ≈ a_c

    a_julia_inbounds_const = copy(a_orig)
    s353_inbounds_const(a_julia_inbounds_const, b, c, ip)
    @test a_julia_inbounds_const ≈ a_c
end

function test_s421()
    len = 100
    flat_2d_array = rand(Float64, len)
    a = rand(Float64, len)
    
    flat_2d_array_orig = copy(flat_2d_array)

    # C implementation logic
    flat_2d_array_c = copy(flat_2d_array_orig)
    for i in 1:len-1
        flat_2d_array_c[i] = flat_2d_array_c[i+1] + a[i]
    end

    flat_2d_array_julia = copy(flat_2d_array_orig)
    s421(flat_2d_array_julia, a)
    @test flat_2d_array_julia ≈ flat_2d_array_c

    flat_2d_array_julia_simd = copy(flat_2d_array_orig)
    s421_simd(flat_2d_array_julia_simd, a)
    @test flat_2d_array_julia_simd ≈ flat_2d_array_c

    flat_2d_array_julia_inbounds = copy(flat_2d_array_orig)
    s421_inbounds(flat_2d_array_julia_inbounds, a)
    @test flat_2d_array_julia_inbounds ≈ flat_2d_array_c

    flat_2d_array_julia_inbounds_simd = copy(flat_2d_array_orig)
    s421_inbounds_simd(flat_2d_array_julia_inbounds_simd, a)
    @test flat_2d_array_julia_inbounds_simd ≈ flat_2d_array_c
end

function test_s1421()
    len = 100
    a = rand(Float64, len)
    b = rand(Float64, len)
    
    b_orig = copy(b)

    # C implementation logic
    b_c = copy(b_orig)
    len_2 = div(len, 2)
    for i in 1:len_2
        b_c[i] = b_c[i + len_2] + a[i]
    end

    b_julia = copy(b_orig)
    s1421(b_julia, a)
    @test b_julia ≈ b_c

    b_julia_simd = copy(b_orig)
    s1421_simd(b_julia_simd, a)
    @test b_julia_simd ≈ b_c

    b_julia_inbounds = copy(b_orig)
    s1421_inbounds(b_julia_inbounds, a)
    @test b_julia_inbounds ≈ b_c

    b_julia_inbounds_simd = copy(b_orig)
    s1421_inbounds_simd(b_julia_inbounds_simd, a)
    @test b_julia_inbounds_simd ≈ b_c
end

function test_s422()
    len = 100
    a = rand(Float64, len)
    flat_2d_array = rand(Float64, len + 8)
    
    flat_2d_array_orig = copy(flat_2d_array)

    # C implementation logic
    flat_2d_array_c = copy(flat_2d_array_orig)
    for i in 1:len
        flat_2d_array_c[i+4] = flat_2d_array_c[i+8] + a[i]
    end

    flat_2d_array_julia = copy(flat_2d_array_orig)
    s422(flat_2d_array_julia, a)
    @test flat_2d_array_julia ≈ flat_2d_array_c

    flat_2d_array_julia_simd = copy(flat_2d_array_orig)
    s422_simd(flat_2d_array_julia_simd, a)
    @test flat_2d_array_julia_simd ≈ flat_2d_array_c

    flat_2d_array_julia_inbounds = copy(flat_2d_array_orig)
    s422_inbounds(flat_2d_array_julia_inbounds, a)
    @test flat_2d_array_julia_inbounds ≈ flat_2d_array_c

    flat_2d_array_julia_inbounds_simd = copy(flat_2d_array_orig)
    s422_inbounds_simd(flat_2d_array_julia_inbounds_simd, a)
    @test flat_2d_array_julia_inbounds_simd ≈ flat_2d_array_c
end

function test_s423()
    len = 100
    a = rand(Float64, len)
    flat_2d_array = rand(Float64, len + 64)
    
    flat_2d_array_orig = copy(flat_2d_array)

    # C implementation logic
    flat_2d_array_c = copy(flat_2d_array_orig)
    for i in 1:len-1
        flat_2d_array_c[i+1] = flat_2d_array_c[i+64] + a[i]
    end

    flat_2d_array_julia = copy(flat_2d_array_orig)
    s423(flat_2d_array_julia, a)
    @test flat_2d_array_julia ≈ flat_2d_array_c

    flat_2d_array_julia_simd = copy(flat_2d_array_orig)
    s423_simd(flat_2d_array_julia_simd, a)
    @test flat_2d_array_julia_simd ≈ flat_2d_array_c

    flat_2d_array_julia_inbounds = copy(flat_2d_array_orig)
    s423_inbounds(flat_2d_array_julia_inbounds, a)
    @test flat_2d_array_julia_inbounds ≈ flat_2d_array_c

    flat_2d_array_julia_inbounds_simd = copy(flat_2d_array_orig)
    s423_inbounds_simd(flat_2d_array_julia_inbounds_simd, a)
    @test flat_2d_array_julia_inbounds_simd ≈ flat_2d_array_c
end

function test_s424()
    len = 100
    a = rand(Float64, len)
    flat_2d_array = rand(Float64, len + 64)
    
    flat_2d_array_orig = copy(flat_2d_array)

    # C implementation logic
    flat_2d_array_c = copy(flat_2d_array_orig)
    for i in 1:len-1
        flat_2d_array_c[i+64] = flat_2d_array_c[i] + a[i]
    end

    flat_2d_array_julia = copy(flat_2d_array_orig)
    s424(flat_2d_array_julia, a)
    @test flat_2d_array_julia ≈ flat_2d_array_c

    flat_2d_array_julia_simd = copy(flat_2d_array_orig)
    s424_simd(flat_2d_array_julia_simd, a)
    @test flat_2d_array_julia_simd ≈ flat_2d_array_c

    flat_2d_array_julia_inbounds = copy(flat_2d_array_orig)
    s424_inbounds(flat_2d_array_julia_inbounds, a)
    @test flat_2d_array_julia_inbounds ≈ flat_2d_array_c

    flat_2d_array_julia_inbounds_simd = copy(flat_2d_array_orig)
    s424_inbounds_simd(flat_2d_array_julia_inbounds_simd, a)
    @test flat_2d_array_julia_inbounds_simd ≈ flat_2d_array_c
end

function test_s431()
    len = 100
    a = rand(Float64, len)
    b = rand(Float64, len)
    
    a_orig = copy(a)

    # C implementation logic
    a_c = copy(a_orig)
    for i in 1:len
        a_c[i] += b[i]
    end

    a_julia = copy(a_orig)
    s431(a_julia, b)
    @test a_julia ≈ a_c

    a_julia_const = copy(a_orig)
    s431_const(a_julia_const, b)
    @test a_julia_const ≈ a_c

    a_julia_inbounds = copy(a_orig)
    s431_inbounds(a_julia_inbounds, b)
    @test a_julia_inbounds ≈ a_c

    a_julia_inbounds_const = copy(a_orig)
    s431_inbounds_const(a_julia_inbounds_const, b)
    @test a_julia_inbounds_const ≈ a_c
end

function test_s441()
    len = 100
    a = zeros(Float64, len)
    b = rand(Float64, len)
    c = rand(Float64, len)
    d = rand(Float64, len) .- 0.5 # To have positive and negative values
    
    a_orig = copy(a)

    # C implementation logic
    a_c = copy(a_orig)
    for i in 1:len
        a_c[i] = b[i] + c[i] * ifelse(d[i] > 0, 1.0, -1.0)
    end

    a_julia = copy(a_orig)
    s441(a_julia, b, c, d)
    @test a_julia ≈ a_c

    a_julia_const = copy(a_orig)
    s441_const(a_julia_const, b, c, d)
    @test a_julia_const ≈ a_c

    a_julia_inbounds = copy(a_orig)
    s441_inbounds(a_julia_inbounds, b, c, d)
    @test a_julia_inbounds ≈ a_c

    a_julia_inbounds_const = copy(a_orig)
    s441_inbounds_const(a_julia_inbounds_const, b, c, d)
    @test a_julia_inbounds_const ≈ a_c
end

function test_s442()
    len = 100
    a = rand(Float64, len)
    b = rand(Float64, len)
    c = rand(Float64, len)
    d = rand(Float64, len)
    e = rand(Float64, len)
    indx = [(i-1) % 4 + 1 for i in 1:len]
    
    a_orig = copy(a)
    b_orig = copy(b)
    c_orig = copy(c)
    d_orig = copy(d)

    # C implementation logic
    a_c = copy(a_orig)
    b_c = copy(b_orig)
    c_c = copy(c_orig)
    d_c = copy(d_orig)
    for i in 1:len
        v = indx[i]
        if v == 1
            a_c[i] = b_c[i] + d_c[i] * d_c[i]
        elseif v == 2
            b_c[i] = a_c[i] + e[i] * e[i]
        elseif v == 3
            c_c[i] = a_c[i] + b_c[i] * b_c[i]
        else # v == 4
            d_c[i] = b_c[i] + c_c[i] * c_c[i]
        end
    end

    a_julia, b_julia, c_julia, d_julia = copy(a_orig), copy(b_orig), copy(c_orig), copy(d_orig)
    s442(a_julia, b_julia, c_julia, d_julia, e, indx)
    @test a_julia ≈ a_c
    @test b_julia ≈ b_c
    @test c_julia ≈ c_c
    @test d_julia ≈ d_c

    a_julia_simd, b_julia_simd, c_julia_simd, d_julia_simd = copy(a_orig), copy(b_orig), copy(c_orig), copy(d_orig)
    s442_simd(a_julia_simd, b_julia_simd, c_julia_simd, d_julia_simd, e, indx)
    @test a_julia_simd ≈ a_c
    @test b_julia_simd ≈ b_c
    @test c_julia_simd ≈ c_c
    @test d_julia_simd ≈ d_c

    a_julia_inbounds, b_julia_inbounds, c_julia_inbounds, d_julia_inbounds = copy(a_orig), copy(b_orig), copy(c_orig), copy(d_orig)
    s442_inbounds(a_julia_inbounds, b_julia_inbounds, c_julia_inbounds, d_julia_inbounds, e, indx)
    @test a_julia_inbounds ≈ a_c
    @test b_julia_inbounds ≈ b_c
    @test c_julia_inbounds ≈ c_c
    @test d_julia_inbounds ≈ d_c

    a_julia_inbounds_simd, b_julia_inbounds_simd, c_julia_inbounds_simd, d_julia_inbounds_simd = copy(a_orig), copy(b_orig), copy(c_orig), copy(d_orig)
    s442_inbounds_simd(a_julia_inbounds_simd, b_julia_inbounds_simd, c_julia_inbounds_simd, d_julia_inbounds_simd, e, indx)
    @test a_julia_inbounds_simd ≈ a_c
    @test b_julia_inbounds_simd ≈ b_c
    @test c_julia_inbounds_simd ≈ c_c
    @test d_julia_inbounds_simd ≈ d_c
end

function test_s443()
    len = 100
    a = rand(Float64, len)
    b = rand(Float64, len)
    c = rand(Float64, len)
    d = rand(Float64, len)
    e = rand(Float64, len)

    a_orig = copy(a)
    b_orig = copy(b)
    c_orig = copy(c)
    d_orig = copy(d)
    e_orig = copy(e)

    # C implementation logic
    a_c = copy(a_orig)
    b_c = copy(b_orig)
    c_c = copy(c_orig)
    d_c = copy(d_orig)
    e_c = copy(e_orig)
    for i in 1:len 
        if d[i] < 0.0
            a_c[i] = b_c[i] + c_c[i] * e_c[i]
        else
            a_c[i] = b_c[i] + b_c[i] * c_c[i]
        end
        c_c[i] = a_c[i] + d_c[i]
    end

    a_julia, b_julia, c_julia, d_julia, e_julia = copy(a_orig), copy(b_orig), copy(c_orig), copy(d_orig), copy(e_orig)
    s443(a_julia, b_julia, c_julia, d_julia, e_julia)
    @test a_julia ≈ a_c
    @test b_julia ≈ b_c
    @test c_julia ≈ c_c
    @test d_julia ≈ d_c

    a_julia_const, b_julia_const, c_julia_const, d_julia_const, e_julia_const = copy(a_orig), copy(b_orig), copy(c_orig), copy(d_orig), copy(e_orig)
    s443_const(a_julia_const, b_julia_const, c_julia_const, d_julia_const, e_julia_const)
    @test a_julia_const ≈ a_c
    @test b_julia_const ≈ b_c
    @test c_julia_const ≈ c_c
    @test d_julia_const ≈ d_c

    a_julia_inbounds, b_julia_inbounds, c_julia_inbounds, d_julia_inbounds, e_julia_inbounds = copy(a_orig), copy(b_orig), copy(c_orig), copy(d_orig), copy(e_orig)
    s443_inbounds(a_julia_inbounds, b_julia_inbounds, c_julia_inbounds, d_julia_inbounds, e_julia_inbounds)
    @test a_julia_inbounds ≈ a_c
    @test b_julia_inbounds ≈ b_c
    @test c_julia_inbounds ≈ c_c
    @test d_julia_inbounds ≈ d_c

    a_julia_inbounds_const, b_julia_inbounds_const, c_julia_inbounds_const, d_julia_inbounds_const, e_julia_inbounds_const = copy(a_orig), copy(b_orig), copy(c_orig), copy(d_orig), copy(e_orig)
    s443_inbounds_const(a_julia_inbounds_const, b_julia_inbounds_const, c_julia_inbounds_const, d_julia_inbounds_const, e_julia_inbounds_const)
    @test a_julia_inbounds_const ≈ a_c
    @test b_julia_inbounds_const ≈ b_c
    @test c_julia_inbounds_const ≈ c_c
    @test d_julia_inbounds_const ≈ d_c
end

function test_s451()
    len = 100
    a = zeros(Float64, len)
    b = rand(Float64, len)
    c = rand(Float64, len)
    d = rand(Float64, len)

    a_orig = copy(a)

    # C implementation logic
    a_c = copy(a_orig)
    for i in 1:len
        a_c[i] = b[i] + c[i] * d[i]
    end

    a_julia = copy(a_orig)
    s451(a_julia, b, c, d)
    @test a_julia ≈ a_c

    a_julia_const = copy(a_orig)
    s451_const(a_julia_const, b, c, d)
    @test a_julia_const ≈ a_c

    a_julia_inbounds = copy(a_orig)
    s451_inbounds(a_julia_inbounds, b, c, d)
    @test a_julia_inbounds ≈ a_c

    a_julia_inbounds_const = copy(a_orig)
    s451_inbounds_const(a_julia_inbounds_const, b, c, d)
    @test a_julia_inbounds_const ≈ a_c
end

function test_s452()
    len = 100
    a = zeros(Float64, len)
    b = rand(Float64, len)
    c = rand(Float64, len)

    a_orig = copy(a)

    # C implementation logic
    a_c = copy(a_orig)
    for i in 1:len
        a_c[i] = b[i] + c[i] * i
    end

    a_julia = copy(a_orig)
    s452(a_julia, b, c)
    @test a_julia ≈ a_c

    a_julia_const = copy(a_orig)
    s452_const(a_julia_const, b, c)
    @test a_julia_const ≈ a_c

    a_julia_inbounds = copy(a_orig)
    s452_inbounds(a_julia_inbounds, b, c)
    @test a_julia_inbounds ≈ a_c

    a_julia_inbounds_const = copy(a_orig)
    s452_inbounds_const(a_julia_inbounds_const, b, c)
    @test a_julia_inbounds_const ≈ a_c
end

function test_s453()
    len = 100
    a = zeros(Float64, len)
    b = rand(Float64, len)

    a_orig = copy(a)

    # C implementation logic
    a_c = copy(a_orig)
    s = 0.0
    for i in 1:len
        s += 2.0
        a_c[i] = s * b[i]
    end

    a_julia = copy(a_orig)
    s453(a_julia, b)
    @test a_julia ≈ a_c

    a_julia_const = copy(a_orig)
    s453_const(a_julia_const, b)
    @test a_julia_const ≈ a_c

    a_julia_inbounds = copy(a_orig)
    s453_inbounds(a_julia_inbounds, b)
    @test a_julia_inbounds ≈ a_c

    a_julia_inbounds_const = copy(a_orig)
    s453_inbounds_const(a_julia_inbounds_const, b)
    @test a_julia_inbounds_const ≈ a_c
end

function test_s471()
    len = 100
    x = zeros(Float64, len)
    b = rand(Float64, len)
    c = rand(Float64, len)
    d = rand(Float64, len)
    e = rand(Float64, len)

    x_orig = copy(x)
    b_orig = copy(b)

    # C implementation logic
    x_c = copy(x_orig)
    b_c = copy(b_orig)
    for i in 1:len
        x_c[i] = b_c[i] + d[i] * d[i]
        b_c[i] = c[i] + d[i] * e[i]
    end

    x_julia, b_julia = copy(x_orig), copy(b_orig)
    s471(x_julia, b_julia, c, d, e)
    @test x_julia ≈ x_c
    @test b_julia ≈ b_c

    x_julia_const, b_julia_const = copy(x_orig), copy(b_orig)
    s471_const(x_julia_const, b_julia_const, c, d, e)
    @test x_julia_const ≈ x_c
    @test b_julia_const ≈ b_c

    x_julia_inbounds, b_julia_inbounds = copy(x_orig), copy(b_orig)
    s471_inbounds(x_julia_inbounds, b_julia_inbounds, c, d, e)
    @test x_julia_inbounds ≈ x_c
    @test b_julia_inbounds ≈ b_c

    x_julia_inbounds_const, b_julia_inbounds_const = copy(x_orig), copy(b_orig)
    s471_inbounds_const(x_julia_inbounds_const, b_julia_inbounds_const, c, d, e)
    @test x_julia_inbounds_const ≈ x_c
    @test b_julia_inbounds_const ≈ b_c
end

function test_s481()
    len = 100
    a = rand(Float64, len)
    b = rand(Float64, len)
    c = rand(Float64, len)
    d_ok = rand(Float64, len)
    d_fail = rand(Float64, len)
    d_fail[50] = -1.0

    a_orig = copy(a)

    # C implementation logic (happy path)
    a_c = copy(a_orig)
    for i in 1:len
        a_c[i] += b[i] * c[i]
    end

    # Test happy path
    a_julia = copy(a_orig)
    s481(a_julia, b, c, d_ok)
    @test a_julia ≈ a_c

    a_julia_const = copy(a_orig)
    s481_const(a_julia_const, b, c, d_ok)
    @test a_julia_const ≈ a_c

    a_julia_inbounds = copy(a_orig)
    s481_inbounds(a_julia_inbounds, b, c, d_ok)
    @test a_julia_inbounds ≈ a_c

    a_julia_inbounds_const = copy(a_orig)
    s481_inbounds_const(a_julia_inbounds_const, b, c, d_ok)
    @test a_julia_inbounds_const ≈ a_c

    # Test exception path
    @test_throws NegativeValueException s481(a, b, c, d_fail)
    @test_throws NegativeValueException s481_const(a, b, c, d_fail)
    @test_throws NegativeValueException s481_inbounds(a, b, c, d_fail)
    @test_throws NegativeValueException s481_inbounds_const(a, b, c, d_fail)
end

function test_s482()
    len = 100
    
    # Case 1: Loop completes
    a_case1 = rand(Float64, len)
    b_case1 = rand(Float64, len)
    c_case1 = b_case1 .- 0.1 # Ensure c[i] <= b[i]
    a_orig1 = copy(a_case1)

    a_c1 = copy(a_orig1)
    for i in 1:len
        a_c1[i] += b_case1[i] * c_case1[i]
    end
    
    a_julia1 = copy(a_orig1); s482(a_julia1, b_case1, c_case1); @test a_julia1 ≈ a_c1
    a_julia1_const = copy(a_orig1); s482_const(a_julia1_const, b_case1, c_case1); @test a_julia1_const ≈ a_c1
    a_julia1_inbounds = copy(a_orig1); s482_inbounds(a_julia1_inbounds, b_case1, c_case1); @test a_julia1_inbounds ≈ a_c1
    a_julia1_inbounds_const = copy(a_orig1); s482_inbounds_const(a_julia1_inbounds_const, b_case1, c_case1); @test a_julia1_inbounds_const ≈ a_c1

    # Case 2: Loop breaks early
    a_case2 = rand(Float64, len)
    b_case2 = rand(Float64, len)
    c_case2 = copy(b_case2)
    break_point = 50
    c_case2[break_point] = b_case2[break_point] + 0.1 # Ensure c[i] > b[i] at breakpoint
    a_orig2 = copy(a_case2)

    a_c2 = copy(a_orig2)
    for i in 1:len
        a_c2[i] += b_case2[i] * c_case2[i]
        if c_case2[i] > b_case2[i]
            break
        end
    end

    a_julia2 = copy(a_orig2); s482(a_julia2, b_case2, c_case2); @test a_julia2 ≈ a_c2
    a_julia2_const = copy(a_orig2); s482_const(a_julia2_const, b_case2, c_case2); @test a_julia2_const ≈ a_c2
    a_julia2_inbounds = copy(a_orig2); s482_inbounds(a_julia2_inbounds, b_case2, c_case2); @test a_julia2_inbounds ≈ a_c2
    a_julia2_inbounds_const = copy(a_orig2); s482_inbounds_const(a_julia2_inbounds_const, b_case2, c_case2); @test a_julia2_inbounds_const ≈ a_c2
end

function main()
    @testset "s275" begin
        test_s275()
    end
    @testset "s2275" begin
        test_s2275()
    end
    @testset "s276" begin
        test_s276()
    end
    @testset "s277" begin
        test_s277()
    end
    @testset "s278" begin
        test_s278()
    end
    @testset "s279" begin
        test_s279()
    end
    @testset "s1279" begin
        test_s1279()
    end
    @testset "s2710" begin
        test_s2710()
    end
    @testset "s2711" begin
        test_s2711()
    end
    @testset "s2712" begin
        test_s2712()
    end
    @testset "s281" begin
        test_s281()
    end
    @testset "s1281" begin
        test_s1281()
    end
    @testset "s291" begin
        test_s291()
    end
    @testset "s292" begin
        test_s292()
    end
    @testset "s293" begin
        test_s293()
    end
    @testset "s2101" begin
        test_s2101()
    end
    @testset "s2102" begin
        test_s2102()
    end
    @testset "s2111" begin
        test_s2111()
    end
    @testset "s311" begin
        test_s311()
    end
    @testset "s312" begin
        test_s312()
    end
    @testset "s313" begin
        test_s313()
    end
    @testset "s314" begin
        test_s314()
    end
    @testset "s315" begin
        test_s315()
    end
    @testset "s316" begin
        test_s316()
    end
    @testset "s318" begin
        test_s318()
    end
    @testset "s319" begin
        test_s319()
    end
    @testset "s3110" begin
        test_s3110()
    end
    @testset "s3111" begin
        test_s3111()
    end
    @testset "s3112" begin
        test_s3112()
    end
    @testset "s3113" begin
        test_s3113()
    end
    @testset "s321" begin
        test_s321()
    end
    @testset "s322" begin
        test_s322()
    end
    @testset "s323" begin
        test_s323()
    end
    @testset "s331" begin
        test_s331()
    end
    @testset "s332" begin
        test_s332()
    end
    @testset "s341" begin
        test_s341()
    end
    @testset "s342" begin
        test_s342()
    end
    @testset "s343" begin
        test_s343()
    end
    @testset "s351" begin
        test_s351()
    end
    @testset "s1351" begin
        test_s1351()
    end
    @testset "s352" begin
        test_s352()
    end
    @testset "s353" begin
        test_s353()
    end
    @testset "s421" begin
        test_s421()
    end
    @testset "s1421" begin
        test_s1421()
    end
    @testset "s422" begin
        test_s422()
    end
    @testset "s423" begin
        test_s423()
    end
    @testset "s424" begin
        test_s424()
    end
    @testset "s431" begin
        test_s431()
    end
    @testset "s441" begin
        test_s441()
    end
    @testset "s442" begin
        test_s442()
    end
    @testset "s443" begin
        test_s443()
    end
    
    @testset "s451" begin
        test_s451()
    end
    @testset "s452" begin
        test_s452()
    end
    @testset "s453" begin
        test_s453()
    end
    @testset "s471" begin
        test_s471()
    end
    @testset "s481" begin
        test_s481()
    end
    @testset "s482" begin
        test_s482()
    end
end

!isinteractive() && main()
end