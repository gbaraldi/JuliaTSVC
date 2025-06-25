using Printf
using Statistics
using InteractiveUtils

import Base.Experimental: Const, @aliasscope


# Const is applied to arrays that are not modified in the loop
# Always checkbounds at function entry
# single argument functions don't need consts
# Functions with _const in the name have Const applied to the arrays that aren't modified in the loop
# Functions with _inbounds in the name have @inbounds applied to the loop
# Functions with _inbounds_const have both Const and @inbounds applied to the loop
# Always traverse remembering column major order in the inner loops, i.e first index moves fastest
# ============================================================================
# LINEAR DEPENDENCE TESTING - Section 1
# ============================================================================

# s000 - linear dependence testing, no dependence - vectorizable
function s000(a::AbstractArray, b::AbstractArray)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    for i in 1:length(a)
        a[i] = b[i] + 1
    end
    return nothing
end

function s000_const(a::AbstractArray, b::AbstractArray)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    @aliasscope for i in 1:length(a)
        a[i] = Const(b)[i] + 1
    end
    return nothing
end

function s000_inbounds(a::AbstractArray, b::AbstractArray)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    @inbounds for i in 1:length(a)
        a[i] = b[i] + 1
    end
    return nothing
end

function s000_inbounds_const(a::AbstractArray, b::AbstractArray)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    @aliasscope @inbounds for i in 1:length(a)
        a[i] = Const(b)[i] + 1
    end
    return nothing
end

# s111 - linear dependence testing, no dependence - vectorizable
function s111(a::AbstractArray, b::AbstractArray)
    checkbounds(a, 1:length(a))
    checkbounds(b, 2:2:length(a))
    for i in 2:2:length(a)
        a[i] = a[i-1] + b[i]
    end
    return nothing
end

function s111_const(a::AbstractArray, b::AbstractArray)
    checkbounds(a, 1:length(a))
    checkbounds(b, 2:2:length(a))
    @aliasscope for i in 2:2:length(a)
        a[i] = a[i-1] + Const(b)[i]
    end
    return nothing
end

function s111_inbounds(a::AbstractArray, b::AbstractArray)
    checkbounds(a, 1:length(a))
    checkbounds(b, 2:2:length(a))
    @inbounds for i in 2:2:length(a)
        a[i] = a[i-1] + b[i]
    end
    return nothing
end

function s111_inbounds_const(a::AbstractArray, b::AbstractArray)
    checkbounds(a, 1:length(a))
    checkbounds(b, 2:2:length(a))
    @aliasscope @inbounds for i in 2:2:length(a)
        a[i] = a[i-1] + Const(b)[i]
    end
    return nothing
end

# s1111 - no dependence - vectorizable, jump in data access
function s1111(a::AbstractArray, b::AbstractArray, c::AbstractArray, d::AbstractArray)
    checkbounds(a, 1:2:length(a))
    checkbounds(b, 1:div(length(a), 2))
    checkbounds(c, 1:div(length(a), 2))
    checkbounds(d, 1:div(length(a), 2))
    for i in 1:div(length(a), 2)
        a[2*i-1] = c[i] * b[i] + d[i] * b[i] + c[i] * c[i] + d[i] * b[i] + d[i] * c[i]
    end
    return nothing
end

function s1111_const(a::AbstractArray, b::AbstractArray, c::AbstractArray, d::AbstractArray)
    checkbounds(a, 1:2:length(a))
    checkbounds(b, 1:div(length(a), 2))
    checkbounds(c, 1:div(length(a), 2))
    checkbounds(d, 1:div(length(a), 2))
    @aliasscope for i in 1:div(length(a), 2)
        a[2*i-1] = Const(c)[i] * Const(b)[i] + Const(d)[i] * Const(b)[i] + Const(c)[i] * Const(c)[i] + Const(d)[i] * Const(b)[i] + Const(d)[i] * Const(c)[i]
    end
    return nothing
end

function s1111_inbounds(a::AbstractArray, b::AbstractArray, c::AbstractArray, d::AbstractArray)
    checkbounds(a, 1:2:length(a))
    checkbounds(b, 1:div(length(a), 2))
    checkbounds(c, 1:div(length(a), 2))
    checkbounds(d, 1:div(length(a), 2))
    @inbounds for i in 1:div(length(a), 2)
        a[2*i-1] = c[i] * b[i] + d[i] * b[i] + c[i] * c[i] + d[i] * b[i] + d[i] * c[i]
    end
    return nothing
end

function s1111_inbounds_const(a::AbstractArray, b::AbstractArray, c::AbstractArray, d::AbstractArray)
    checkbounds(a, 1:2:length(a))
    checkbounds(b, 1:div(length(a), 2))
    checkbounds(c, 1:div(length(a), 2))
    checkbounds(d, 1:div(length(a), 2))
    @aliasscope @inbounds for i in 1:div(length(a), 2)
        a[2*i-1] = Const(c)[i] * Const(b)[i] + Const(d)[i] * Const(b)[i] + Const(c)[i] * Const(c)[i] + Const(d)[i] * Const(b)[i] + Const(d)[i] * Const(c)[i]
    end
    return nothing
end

# s112 - loop reversal
function s112(a::AbstractArray, b::AbstractArray)
    checkbounds(a, length(a):-1:1)
    checkbounds(b, length(a):-1:1)
    for i in length(a)-1:-1:1
        a[i+1] = a[i] + b[i]
    end
    return nothing
end

function s112_const(a::AbstractArray, b::AbstractArray)
    checkbounds(a, length(a):-1:1)
    checkbounds(b, length(a):-1:1)
    @aliasscope for i in length(a)-1:-1:1
        a[i+1] = a[i] + Const(b)[i]
    end
    return nothing
end

function s112_inbounds(a::AbstractArray, b::AbstractArray)
    checkbounds(a, length(a):-1:1)
    checkbounds(b, length(a):-1:1)
    @inbounds for i in length(a)-1:-1:1
        a[i+1] = a[i] + b[i]
    end
    return nothing
end

function s112_inbounds_const(a::AbstractArray, b::AbstractArray)
    checkbounds(a, length(a):-1:1)
    checkbounds(b, length(a):-1:1)
    @aliasscope @inbounds for i in length(a)-1:-1:1
        a[i+1] = a[i] + Const(b)[i]
    end
    return nothing
end

# s1112 - loop reversal, no dependence
function s1112(a::AbstractArray, b::AbstractArray)
    checkbounds(a, length(a):-1:1)
    checkbounds(b, length(a):-1:1)
    for i in length(a):-1:1
        a[i] = b[i] + 1
    end
    return nothing
end

function s1112_const(a::AbstractArray, b::AbstractArray)
    checkbounds(a, length(a):-1:1)
    checkbounds(b, length(a):-1:1)
    @aliasscope for i in length(a):-1:1
        a[i] = Const(b)[i] + 1.0
    end
    return nothing
end

function s1112_inbounds(a::AbstractArray, b::AbstractArray)
    checkbounds(a, length(a):-1:1)
    checkbounds(b, length(a):-1:1)
    @inbounds for i in length(a):-1:1
        a[i] = b[i] + 1.0
    end
    return nothing
end

function s1112_inbounds_const(a::AbstractArray, b::AbstractArray)
    checkbounds(a, length(a):-1:1)
    checkbounds(b, length(a):-1:1)
    @aliasscope @inbounds for i in length(a):-1:1
        a[i] = Const(b)[i] + 1.0
    end
    return nothing
end

# s113 - a[i] = a[1] but no actual dependence cycle
function s113(a::AbstractArray, b::AbstractArray)
    checkbounds(a, 1:length(a))
    checkbounds(b, 2:length(a))
    for i in 2:length(a)
        a[i] = a[1] + b[i]
    end
    return nothing
end

function s113_const(a::AbstractArray, b::AbstractArray)
    checkbounds(a, 1:length(a))
    checkbounds(b, 2:length(a))
    @aliasscope for i in 2:length(a)
        a[i] = a[1] + Const(b)[i]
    end
    return nothing
end

function s113_inbounds(a::AbstractArray, b::AbstractArray)
    checkbounds(a, 1:length(a))
    checkbounds(b, 2:length(a))
    @inbounds for i in 2:length(a)
        a[i] = a[1] + b[i]
    end
    return nothing
end

function s113_inbounds_const(a::AbstractArray, b::AbstractArray)
    checkbounds(a, 1:length(a))
    checkbounds(b, 2:length(a))
    @aliasscope @inbounds for i in 2:length(a)
        a[i] = a[1] + Const(b)[i]
    end
    return nothing
end

# s1113 - one iteration dependency on a[div(length(a), 2)] but still vectorizable
function s1113(a::AbstractArray, b::AbstractArray)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    for i in 1:length(a)
        a[i] = a[div(length(a), 2)+1] + b[i]
    end
    return nothing
end

function s1113_const(a::AbstractArray, b::AbstractArray)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    @aliasscope for i in 1:length(a)
        a[i] = a[div(length(a), 2)+1] + Const(b)[i]
    end
    return nothing
end

function s1113_inbounds(a::AbstractArray, b::AbstractArray)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    @inbounds for i in 1:length(a)
        a[i] = a[div(length(a), 2)+1] + b[i]
    end
    return nothing
end

# function s1113_inbounds_const(a::AbstractArray, b::AbstractArray)
#     checkbounds(a, 1:length(a))
#     checkbounds(b, 1:length(a))
#     @inbounds for i in 1:length(a)
#         a[i] = a[div(length(a), 2)+1] + Const(b)[i]
#     end
#     return nothing
# end

# s114 - transpose vectorization, jump in data access - not vectorizable
function s114(aa::AbstractMatrix, bb::AbstractMatrix)
    R, C = size(aa)
    checkbounds(aa, 1:R, 1:C)
    checkbounds(bb, 1:R, 1:C)
    for j in 1:C
        for i in j+1:R
            aa[i, j] = aa[j, i] + bb[i, j]
        end
    end
    return nothing
end

function s114_const(aa::AbstractMatrix, bb::AbstractMatrix)
    R, C = size(aa)
    checkbounds(aa, 1:R, 1:C)
    checkbounds(bb, 1:R, 1:C)
    @aliasscope for j in 1:C
        for i in j+1:R
            aa[i, j] = aa[j, i] + Const(bb)[i, j]
        end
    end
    return nothing
end

function s114_inbounds(aa::AbstractMatrix, bb::AbstractMatrix)
    R, C = size(aa)
    checkbounds(aa, 1:R, 1:C)
    checkbounds(bb, 1:R, 1:C)
    @inbounds for j in 1:C
        for i in j+1:R
            aa[i, j] = aa[j, i] + bb[i, j]
        end
    end
    return nothing
end

function s114_inbounds_const(aa::AbstractMatrix, bb::AbstractMatrix)
    R, C = size(aa)
    checkbounds(aa, 1:R, 1:C)
    checkbounds(bb, 1:R, 1:C)
    @aliasscope @inbounds for j in 1:C
        for i in j+1:R
            aa[i, j] = aa[j, i] + Const(bb)[i, j]
        end
    end
    return nothing
end

# s115 - triangular saxpy loop
function s115(a::AbstractVector, aa::AbstractMatrix)
    checkbounds(a, 1:size(aa, 1))
    checkbounds(aa, 1:size(aa, 1), 1:size(aa, 2))
    for j in 1:size(aa, 2)
        for i in j+1:size(aa, 1)
            a[i] -= aa[j, i] * a[j]
        end
    end
    return nothing
end

function s115_const(a::AbstractVector, aa::AbstractMatrix)
    checkbounds(a, 1:size(aa, 1))
    checkbounds(aa, 1:size(aa, 1), 1:size(aa, 2))
    @aliasscope for j in 1:size(aa, 2)
        for i in j+1:size(aa, 1)
            a[i] -= Const(aa)[j, i] * a[j]
        end
    end
    return nothing
end

function s115_inbounds(a::AbstractVector, aa::AbstractMatrix)
    checkbounds(a, 1:size(aa, 1))
    checkbounds(aa, 1:size(aa, 1), 1:size(aa, 2))
    @inbounds for j in 1:size(aa, 2)
        for i in j+1:size(aa, 1)
            a[i] -= aa[j, i] * a[j]
        end
    end
    return nothing
end

function s115_inbounds_const(a::AbstractVector, aa::AbstractMatrix)
    checkbounds(a, 1:size(aa, 1))
    checkbounds(aa, 1:size(aa, 1), 1:size(aa, 2))
    @aliasscope @inbounds for j in 1:size(aa, 2)
        for i in j+1:size(aa, 1)
            a[i] -= Const(aa)[j, i] * a[j]
        end
    end
    return nothing
end

# s1115 - triangular saxpy loop
function s1115(aa::AbstractMatrix, bb::AbstractMatrix, cc::AbstractMatrix)
    checkbounds(aa, 1:size(aa, 1), 1:size(aa, 2))
    checkbounds(bb, 1:size(bb, 1), 1:size(bb, 2))
    checkbounds(cc, 1:size(cc, 1), 1:size(cc, 2))
    for j in 1:size(aa, 2)
        for i in 1:size(aa, 1)
            aa[i, j] = aa[i, j] * cc[j, i] + bb[i, j]
        end
    end
    return nothing
end

function s1115_const(aa::AbstractMatrix, bb::AbstractMatrix, cc::AbstractMatrix)
    checkbounds(aa, 1:size(aa, 1), 1:size(aa, 2))
    checkbounds(bb, 1:size(bb, 1), 1:size(bb, 2))
    checkbounds(cc, 1:size(cc, 1), 1:size(cc, 2))
    @aliasscope for j in 1:size(aa, 2)
        for i in 1:size(aa, 1)
            aa[i, j] = aa[i, j] * Const(cc)[j, i] + Const(bb)[i, j]
        end
    end
    return nothing
end

function s1115_inbounds(aa::AbstractMatrix, bb::AbstractMatrix, cc::AbstractMatrix)
    checkbounds(aa, 1:size(aa, 1), 1:size(aa, 2))
    checkbounds(bb, 1:size(bb, 1), 1:size(bb, 2))
    checkbounds(cc, 1:size(cc, 1), 1:size(cc, 2))
    @inbounds for j in 1:size(aa, 2)
        for i in 1:size(aa, 1)
            aa[i, j] = aa[i, j] * cc[j, i] + bb[i, j]
        end
    end
    return nothing
end

function s1115_inbounds_const(aa::AbstractMatrix, bb::AbstractMatrix, cc::AbstractMatrix)
    checkbounds(aa, 1:size(aa, 1), 1:size(aa, 2))
    checkbounds(bb, 1:size(bb, 1), 1:size(bb, 2))
    checkbounds(cc, 1:size(cc, 1), 1:size(cc, 2))
    @aliasscope @inbounds for j in 1:size(aa, 2)
        for i in 1:size(aa, 1)
            aa[i, j] = aa[i, j] * Const(cc)[j, i] + Const(bb)[i, j]
        end
    end
    return nothing
end

# No const because it's single argument
# s116 - linear dependence testing
function s116(a::AbstractVector)
    checkbounds(a, 1:length(a))
    for i in 1:5:length(a)-5
        a[i] = a[i+1] * a[i]
        a[i+1] = a[i+2] * a[i+1]
        a[i+2] = a[i+3] * a[i+2]
        a[i+3] = a[i+4] * a[i+3]
        a[i+4] = a[i+5] * a[i+4]
    end
    return nothing
end

function s116_inbounds(a::AbstractVector)
    checkbounds(a, 1:length(a))
    @inbounds for i in 1:5:length(a)-5
        a[i] = a[i+1] * a[i]
        a[i+1] = a[i+2] * a[i+1]
        a[i+2] = a[i+3] * a[i+2]
        a[i+3] = a[i+4] * a[i+3]
        a[i+4] = a[i+5] * a[i+4]
    end
    return nothing
end

# s118 - potential dot product recursion
function s118(a::AbstractVector, bb::AbstractMatrix)
    checkbounds(a, 1:size(bb, 2))
    checkbounds(bb, 1:size(bb, 1), 1:size(bb, 2))
    for i in 2:size(bb, 2)
        for j in 1:i-1
            a[i] += bb[j, i] * a[i-j]
        end
    end
    return nothing
end

function s118_const(a::AbstractVector, bb::AbstractMatrix)
    checkbounds(a, 1:size(bb, 2))
    checkbounds(bb, 1:size(bb, 1), 1:size(bb, 2))
    @aliasscope for i in 2:size(bb, 2)
        for j in 1:i-1
            a[i] += Const(bb)[j, i] * a[i-j]
        end
    end
    return nothing
end

function s118_inbounds(a::AbstractVector, bb::AbstractMatrix)
    checkbounds(a, 1:size(bb, 2))
    checkbounds(bb, 1:size(bb, 1), 1:size(bb, 2))
    @inbounds for i in 2:size(bb, 2)
        for j in 1:i-1
            a[i] += bb[j, i] * a[i-j]
        end
    end
    return nothing
end

function s118_inbounds_const(a::AbstractVector, bb::AbstractMatrix)
    checkbounds(a, 1:size(bb, 2))
    checkbounds(bb, 1:size(bb, 1), 1:size(bb, 2))
    @aliasscope @inbounds for i in 2:size(bb, 2)
        for j in 1:i-1
            a[i] += Const(bb)[j, i] * a[i-j]
        end
    end
    return nothing
end

# s119 - no dependence - vectorizable
function s119(aa::AbstractMatrix, bb::AbstractMatrix)
    checkbounds(aa, 1:size(aa, 1), 1:size(aa, 2))
    checkbounds(bb, 1:size(bb, 1), 1:size(bb, 2))
    for j in 2:size(aa, 2)
        for i in 2:size(aa, 1)
            aa[i, j] = aa[i-1, j-1] + bb[i, j]
        end
    end
    return nothing
end

function s119_const(aa::AbstractMatrix, bb::AbstractMatrix)
    checkbounds(aa, 1:size(aa, 1), 1:size(aa, 2))
    checkbounds(bb, 1:size(bb, 1), 1:size(bb, 2))
    @aliasscope for j in 2:size(aa, 2)
        for i in 2:size(aa, 1)
            aa[i, j] = aa[i-1, j-1] + Const(bb)[i, j]
        end
    end
    return nothing
end

function s119_inbounds(aa::AbstractMatrix, bb::AbstractMatrix)
    checkbounds(aa, 1:size(aa, 1), 1:size(aa, 2))
    checkbounds(bb, 1:size(bb, 1), 1:size(bb, 2))
    @inbounds for j in 2:size(aa, 2)
        for i in 2:size(aa, 1)
            aa[i, j] = aa[i-1, j-1] + bb[i, j]
        end
    end
    return nothing
end

function s119_inbounds_const(aa::AbstractMatrix, bb::AbstractMatrix)
    checkbounds(aa, 1:size(aa, 1), 1:size(aa, 2))
    checkbounds(bb, 1:size(bb, 1), 1:size(bb, 2))
    @aliasscope @inbounds for j in 2:size(aa, 2)
        for i in 2:size(aa, 1)
            aa[i, j] = aa[i-1, j-1] + Const(bb)[i, j]
        end
    end
    return nothing
end

# s1119 - no dependence - vectorizable
function s1119(aa::AbstractMatrix, bb::AbstractMatrix)
    checkbounds(aa, 1:size(aa, 1), 1:size(aa, 2))
    checkbounds(bb, 1:size(bb, 1), 1:size(bb, 2))
    for j in 1:size(aa, 2)
        for i in 2:size(aa, 1)
            aa[i, j] = aa[i-1, j] + bb[i, j]
        end
    end
    return nothing
end

function s1119_const(aa::AbstractMatrix, bb::AbstractMatrix)
    checkbounds(aa, 1:size(aa, 1), 1:size(aa, 2))
    checkbounds(bb, 1:size(bb, 1), 1:size(bb, 2))
    @aliasscope for j in 1:size(aa, 2)
        for i in 2:size(aa, 1)
            aa[i, j] = aa[i-1, j] + Const(bb)[i, j]
        end
    end
    return nothing
end

function s1119_inbounds(aa::AbstractMatrix, bb::AbstractMatrix)
    checkbounds(aa, 1:size(aa, 1), 1:size(aa, 2))
    checkbounds(bb, 1:size(bb, 1), 1:size(bb, 2))
    @inbounds for j in 1:size(aa, 2)
        for i in 2:size(aa, 1)
            aa[i, j] = aa[i-1, j] + bb[i, j]
        end
    end
    return nothing
end

function s1119_inbounds_const(aa::AbstractMatrix, bb::AbstractMatrix)
    checkbounds(aa, 1:size(aa, 1), 1:size(aa, 2))
    checkbounds(bb, 1:size(bb, 1), 1:size(bb, 2))
    @aliasscope @inbounds for j in 1:size(aa, 2)
        for i in 2:size(aa, 1)
            aa[i, j] = aa[i-1, j] + Const(bb)[i, j]
        end
    end
    return nothing
end

# s121 - loop with possible ambiguity because of scalar store
function s121(a::AbstractVector, b::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a)-1)
    for i in 1:length(a)-1
        j = i + 1
        a[i] = a[j] + b[i]
    end
    return nothing
end

function s121_const(a::AbstractVector, b::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a)-1)
    @aliasscope for i in 1:length(a)-1
        j = i + 1
        a[i] = a[j] + Const(b)[i]
    end
    return nothing
end

function s121_inbounds(a::AbstractVector, b::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a)-1)
    @inbounds for i in 1:length(a)-1
        j = i + 1
        a[i] = a[j] + b[i]
    end
    return nothing
end

function s121_inbounds_const(a::AbstractVector, b::AbstractArray)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a)-1)
    @aliasscope @inbounds for i in 1:length(a)-1
        j = i + 1
        a[i] = a[j] + Const(b)[i]
    end
    return nothing
end

# s122 - variable lower and upper bound, and stride, reverse data access and jump in data access
function s122(a::AbstractVector, b::AbstractVector, n1::Int, n3::Int)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    j = 1
    k = 0
    for i in n1:n3:length(a)
        k += j
        a[i] += b[length(a)-k+1]
    end
    return nothing
end

function s122_const(a::AbstractVector, b::AbstractVector, n1::Int, n3::Int)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    j = 1
    k = 0
    @aliasscope for i in n1:n3:length(a)
        k += j
        a[i] += Const(b)[length(a)-k+1]
    end
    return nothing
end

function s122_inbounds(a::AbstractVector, b::AbstractVector, n1::Int, n3::Int)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    j = 1
    k = 0
    @inbounds for i in n1:n3:length(a)
        k += j
        a[i] += b[length(a)-k+1]
    end
    return nothing
end

function s122_inbounds_const(a::AbstractVector, b::AbstractVector, n1::Int, n3::Int)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    j = 1
    k = 0
    @aliasscope @inbounds for i in n1:n3:length(a)
        k += j
        a[i] += Const(b)[length(a)-k+1]
    end
    return nothing
end

# s123 - induction variable under an if, not vectorizable, the condition cannot be speculated
function s123(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:div(length(a), 2))
    checkbounds(c, 1:div(length(a), 2))
    checkbounds(d, 1:div(length(a), 2))
    checkbounds(e, 1:div(length(a), 2))
    j = 0
    for i in 1:div(length(a), 2)
        j += 1
        a[j] = b[i] + d[i] * e[i]
        if c[i] > 0.0
            j += 1
            a[j] = c[i] + d[i] * e[i]
        end
    end
    return nothing
end

function s123_const(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:div(length(a), 2))
    checkbounds(c, 1:div(length(a), 2))
    checkbounds(d, 1:div(length(a), 2))
    checkbounds(e, 1:div(length(a), 2))
    j = 0
    @aliasscope for i in 1:div(length(a), 2)
        j += 1
        a[j] = Const(b)[i] + Const(d)[i] * Const(e)[i]
        if Const(c)[i] > 0.0
            j += 1
            a[j] = Const(c)[i] + Const(d)[i] * Const(e)[i]
        end
    end
    return nothing
end

function s123_inbounds(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:div(length(a), 2))
    checkbounds(c, 1:div(length(a), 2))
    checkbounds(d, 1:div(length(a), 2))
    checkbounds(e, 1:div(length(a), 2))
    j = 0
    @inbounds for i in 1:div(length(a), 2)
        j += 1
        a[j] = b[i] + d[i] * e[i]
        if c[i] > 0.0
            j += 1
            a[j] = c[i] + d[i] * e[i]
        end
    end
    return nothing
end

function s123_inbounds_const(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:div(length(a), 2))
    checkbounds(c, 1:div(length(a), 2))
    checkbounds(d, 1:div(length(a), 2))
    checkbounds(e, 1:div(length(a), 2))
    j = 0
    @aliasscope @inbounds for i in 1:div(length(a), 2)
        j += 1
        a[j] = Const(b)[i] + Const(d)[i] * Const(e)[i]
        if Const(c)[i] > 0.0
            j += 1
            a[j] = Const(c)[i] + Const(d)[i] * Const(e)[i]
        end
    end
    return nothing
end

# s124 - induction variable under both sides of if (same value)
function s124(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    checkbounds(d, 1:length(a))
    checkbounds(e, 1:length(a))
    j = 0
    for i in 1:length(a)
        j += 1
        if b[i] > 0.0
            a[j] = b[i] + d[i] * e[i]
        else
            a[j] = c[i] + d[i] * e[i]
        end
    end
    return nothing
end

function s124_const(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    checkbounds(d, 1:length(a))
    checkbounds(e, 1:length(a))
    j = 0
    @aliasscope for i in 1:length(a)
        j += 1
        if Const(b)[i] > 0.0
            a[j] = Const(b)[i] + Const(d)[i] * Const(e)[i]
        else
            a[j] = Const(c)[i] + Const(d)[i] * Const(e)[i]
        end
    end
    return nothing
end

function s124_inbounds(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    checkbounds(d, 1:length(a))
    checkbounds(e, 1:length(a))
    j = 0
    @inbounds for i in 1:length(a)
        j += 1
        if b[i] > 0.0
            a[j] = b[i] + d[i] * e[i]
        else
            a[j] = c[i] + d[i] * e[i]
        end
    end
    return nothing
end

function s124_inbounds_const(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    checkbounds(d, 1:length(a))
    checkbounds(e, 1:length(a))
    j = 0
    @aliasscope @inbounds for i in 1:length(a)
        j += 1
        if Const(b)[i] > 0.0
            a[j] = Const(b)[i] + Const(d)[i] * Const(e)[i]
        else
            a[j] = Const(c)[i] + Const(d)[i] * Const(e)[i]
        end
    end
    return nothing
end

# s125 - induction variable in two loops; collapsing possible
function s125(flat_2d_array::AbstractVector, aa::AbstractMatrix, bb::AbstractMatrix, cc::AbstractMatrix)
    checkbounds(flat_2d_array, 1:size(aa, 1)*size(aa, 2))
    checkbounds(aa, 1:size(aa, 1), 1:size(aa, 2))
    checkbounds(bb, 1:size(aa, 1), 1:size(aa, 2))
    checkbounds(cc, 1:size(aa, 1), 1:size(aa, 2))
    k = 0
    for i in 1:size(aa, 2)
        for j in 1:size(aa, 1)
            k += 1
            flat_2d_array[k] = aa[j, i] + bb[j, i] * cc[j, i]
        end
    end
    return nothing
end

function s125_const(flat_2d_array::AbstractVector, aa::AbstractMatrix, bb::AbstractMatrix, cc::AbstractMatrix)
    checkbounds(flat_2d_array, 1:size(aa, 1)*size(aa, 2))
    checkbounds(aa, 1:size(aa, 1), 1:size(aa, 2))
    checkbounds(bb, 1:size(aa, 1), 1:size(aa, 2))
    checkbounds(cc, 1:size(aa, 1), 1:size(aa, 2))
    k = 0
    @aliasscope for i in 1:size(aa, 2)
        for j in 1:size(aa, 1)
            k += 1
            flat_2d_array[k] = Const(aa)[j, i] + Const(bb)[j, i] * Const(cc)[j, i]
        end
    end
    return nothing
end

function s125_inbounds(flat_2d_array::AbstractVector, aa::AbstractMatrix, bb::AbstractMatrix, cc::AbstractMatrix)
    checkbounds(flat_2d_array, 1:size(aa, 1)*size(aa, 2))
    checkbounds(aa, 1:size(aa, 1), 1:size(aa, 2))
    checkbounds(bb, 1:size(aa, 1), 1:size(aa, 2))
    checkbounds(cc, 1:size(aa, 1), 1:size(aa, 2))
    k = 0
    @inbounds for i in 1:size(aa, 2)
        for j in 1:size(aa, 1)
            k += 1
            flat_2d_array[k] = aa[j, i] + bb[j, i] * cc[j, i]
        end
    end
    return nothing
end

function s125_inbounds_const(flat_2d_array::AbstractVector, aa::AbstractMatrix, bb::AbstractMatrix, cc::AbstractMatrix)
    checkbounds(flat_2d_array, 1:size(aa, 1)*size(aa, 2))
    checkbounds(aa, 1:size(aa, 1), 1:size(aa, 2))
    checkbounds(bb, 1:size(aa, 1), 1:size(aa, 2))
    checkbounds(cc, 1:size(aa, 1), 1:size(aa, 2))
    k = 0
    @aliasscope @inbounds for i in 1:size(aa, 2)
        for j in 1:size(aa, 1)
            k += 1
            flat_2d_array[k] = Const(aa)[j, i] + Const(bb)[j, i] * Const(cc)[j, i]
        end
    end
    return nothing
end

# s126 - induction variable in two loops; recurrence in inner loop
function s126(flat_2d_array::AbstractVector, bb::AbstractMatrix, cc::AbstractMatrix)
    checkbounds(flat_2d_array, 1:size(bb, 1)*size(bb, 2))
    checkbounds(bb, 1:size(bb, 1), 1:size(bb, 2))
    checkbounds(cc, 1:size(cc, 1), 1:size(cc, 2))
    k = 1
    for i in 1:size(bb, 2)
        for j in 2:size(bb, 1)
            bb[j, i] = bb[j-1, i] + flat_2d_array[k] * cc[j, i]
            k += 1
        end
        k += 1
    end
    return nothing
end

function s126_const(flat_2d_array::AbstractVector, bb::AbstractMatrix, cc::AbstractMatrix)
    checkbounds(flat_2d_array, 1:size(bb, 1)*size(bb, 2))
    checkbounds(bb, 1:size(bb, 1), 1:size(bb, 2))
    checkbounds(cc, 1:size(cc, 1), 1:size(cc, 2))
    k = 1
    @aliasscope for i in 1:size(bb, 2)
        for j in 2:size(bb, 1)
            bb[j, i] = bb[j-1, i] + Const(flat_2d_array)[k] * Const(cc)[j, i]
            k += 1
        end
        k += 1
    end
    return nothing
end

function s126_inbounds(flat_2d_array::AbstractVector, bb::AbstractMatrix, cc::AbstractMatrix)
    checkbounds(flat_2d_array, 1:size(bb, 1)*size(bb, 2))
    checkbounds(bb, 1:size(bb, 1), 1:size(bb, 2))
    checkbounds(cc, 1:size(cc, 1), 1:size(cc, 2))
    k = 1
    @inbounds for i in 1:size(bb, 2)
        for j in 2:size(bb, 1)
            bb[j, i] = bb[j-1, i] + flat_2d_array[k] * cc[j, i]
            k += 1
        end
        k += 1
    end
    return nothing
end

function s126_inbounds_const(flat_2d_array::AbstractVector, bb::AbstractMatrix, cc::AbstractMatrix)
    checkbounds(flat_2d_array, 1:size(bb, 1)*size(bb, 2))
    checkbounds(bb, 1:size(bb, 1), 1:size(bb, 2))
    checkbounds(cc, 1:size(cc, 1), 1:size(cc, 2))
    k = 1
    @aliasscope @inbounds for i in 1:size(bb, 2)
        for j in 2:size(bb, 1)
            bb[j, i] = bb[j-1, i] + Const(flat_2d_array)[k] * Const(cc)[j, i]
            k += 1
        end
        k += 1
    end
    return nothing
end

# s127 - induction variable with multiple increments
function s127(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:div(length(a), 2))
    checkbounds(c, 1:div(length(a), 2))
    checkbounds(d, 1:div(length(a), 2))
    checkbounds(e, 1:div(length(a), 2))
    j = 0
    for i in 1:div(length(a), 2)
        j += 1
        a[j] = b[i] + c[i] * d[i]
        j += 1
        a[j] = b[i] + d[i] * e[i]
    end
    return nothing
end

function s127_const(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:div(length(a), 2))
    checkbounds(c, 1:div(length(a), 2))
    checkbounds(d, 1:div(length(a), 2))
    checkbounds(e, 1:div(length(a), 2))
    j = 0
    @aliasscope for i in 1:div(length(a), 2)
        j += 1
        a[j] = Const(b)[i] + Const(c)[i] * Const(d)[i]
        j += 1
        a[j] = Const(b)[i] + Const(d)[i] * Const(e)[i]
    end
    return nothing
end

function s127_inbounds(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:div(length(a), 2))
    checkbounds(c, 1:div(length(a), 2))
    checkbounds(d, 1:div(length(a), 2))
    checkbounds(e, 1:div(length(a), 2))
    j = 0
    @inbounds for i in 1:div(length(a), 2)
        j += 1
        a[j] = b[i] + c[i] * d[i]
        j += 1
        a[j] = b[i] + d[i] * e[i]
    end
    return nothing
end

function s127_inbounds_const(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:div(length(a), 2))
    checkbounds(c, 1:div(length(a), 2))
    checkbounds(d, 1:div(length(a), 2))
    checkbounds(e, 1:div(length(a), 2))
    j = 0
    @aliasscope @inbounds for i in 1:div(length(a), 2)
        j += 1
        a[j] = Const(b)[i] + Const(c)[i] * Const(d)[i]
        j += 1
        a[j] = Const(b)[i] + Const(d)[i] * Const(e)[i]
    end
    return nothing
end

# s128 - coupled induction variables, jump in data access
function s128(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector)
    checkbounds(a, 1:div(length(a), 2))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    checkbounds(d, 1:div(length(a), 2))
    j = 0
    for i in 1:div(length(a), 2)
        k = j + 1
        a[i] = b[k] - d[i]
        j = k + 1
        b[k] = a[i] + c[k]
    end
    return nothing
end

function s128_const(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector)
    checkbounds(a, 1:div(length(a), 2))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    checkbounds(d, 1:div(length(a), 2))
    j = 0
    @aliasscope for i in 1:div(length(a), 2)
        k = j + 1
        a[i] = Const(b)[k] - Const(d)[i]
        j = k + 1
        b[k] = a[i] + Const(c)[k]
    end
    return nothing
end

function s128_inbounds(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector)
    checkbounds(a, 1:div(length(a), 2))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    checkbounds(d, 1:div(length(a), 2))
    j = 0
    @inbounds for i in 1:div(length(a), 2)
        k = j + 1
        a[i] = b[k] - d[i]
        j = k + 1
        b[k] = a[i] + c[k]
    end
    return nothing
end

function s128_inbounds_const(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector)
    checkbounds(a, 1:div(length(a), 2))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    checkbounds(d, 1:div(length(a), 2))
    j = 0
    @aliasscope @inbounds for i in 1:div(length(a), 2)
        k = j + 1
        a[i] = Const(b)[k] - Const(d)[i]
        j = k + 1
        b[k] = a[i] + Const(c)[k]
    end
    return nothing
end

# s131 - forward substitution
function s131(a::AbstractVector, b::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a)-1)
    m = 1
    for i in 1:length(a)-1
        a[i] = a[i+m] + b[i]
    end
    return nothing
end

function s131_const(a::AbstractVector, b::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a)-1)
    m = 1
    @aliasscope for i in 1:length(a)-1
        a[i] = a[i+m] + Const(b)[i]
    end
    return nothing
end

function s131_inbounds(a::AbstractVector, b::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a)-1)
    m = 1
    @inbounds for i in 1:length(a)-1
        a[i] = a[i+m] + b[i]
    end
    return nothing
end

function s131_inbounds_const(a::AbstractVector, b::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a)-1)
    m = 1
    @aliasscope @inbounds for i in 1:length(a)-1
        a[i] = a[i+m] + Const(b)[i]
    end
    return nothing
end

# s132 - loop with multiple dimension ambiguous subscripts
function s132(aa::AbstractMatrix, b::AbstractVector, c::AbstractVector)
    checkbounds(aa, 1:2, 1:size(aa, 2))
    checkbounds(b, 2:size(aa, 2))
    checkbounds(c, 2)
    m = 0
    j = m + 1
    k = m + 2
    for i in 2:size(aa, 2)
        aa[j, i] = aa[k, i-1] + b[i] * c[2]
    end
    return nothing
end

function s132_const(aa::AbstractMatrix, b::AbstractVector, c::AbstractVector)
    checkbounds(aa, 1:2, 1:size(aa, 2))
    checkbounds(b, 2:size(aa, 2))
    checkbounds(c, 2)
    m = 0
    j = m + 1
    k = m + 2
    @aliasscope for i in 2:size(aa, 2)
        aa[j, i] = aa[k, i-1] + Const(b)[i] * Const(c)[2]
    end
    return nothing
end

function s132_inbounds(aa::AbstractMatrix, b::AbstractVector, c::AbstractVector)
    checkbounds(aa, 1:2, 1:size(aa, 2))
    checkbounds(b, 2:size(aa, 2))
    checkbounds(c, 2)
    m = 0
    j = m + 1
    k = m + 2
    @inbounds for i in 2:size(aa, 2)
        aa[j, i] = aa[k, i-1] + b[i] * c[2]
    end
    return nothing
end

function s132_inbounds_const(aa::AbstractMatrix, b::AbstractVector, c::AbstractVector)
    checkbounds(aa, 1:2, 1:size(aa, 2))
    checkbounds(b, 2:size(aa, 2))
    checkbounds(c, 2)
    m = 0
    j = m + 1
    k = m + 2
    @aliasscope @inbounds for i in 2:size(aa, 2)
        aa[j, i] = aa[k, i-1] + Const(b)[i] * Const(c)[2]
    end
    return nothing
end

# s141 - walk a row in a symmetric packed array, element a(i,j) for (j>i) stored in location j*(j-1)/2+i
function s141(flat_2d_array::AbstractVector, bb::AbstractMatrix)
    checkbounds(flat_2d_array, 1:length(flat_2d_array))
    checkbounds(bb, 1:size(bb, 1), 1:size(bb, 2))
    for i in 1:size(bb, 2)
        k = div((i) * ((i) - 1), 2) + i
        for j in i:size(bb, 1)
            flat_2d_array[k] += bb[j, i]
            k += j + 1
        end
    end
    return nothing
end

function s141_const(flat_2d_array::AbstractVector, bb::AbstractMatrix)
    checkbounds(flat_2d_array, 1:length(flat_2d_array))
    checkbounds(bb, 1:size(bb, 1), 1:size(bb, 2))
    @aliasscope for i in 1:size(bb, 2)
        k = div((i) * ((i) - 1), 2) + i
        for j in i:size(bb, 1)
            flat_2d_array[k] += Const(bb)[j, i]
            k += j + 1
        end
    end
    return nothing
end

function s141_inbounds(flat_2d_array::AbstractVector, bb::AbstractMatrix)
    checkbounds(flat_2d_array, 1:length(flat_2d_array))
    checkbounds(bb, 1:size(bb, 1), 1:size(bb, 2))
    @inbounds for i in 1:size(bb, 2)
        k = div((i) * ((i) - 1), 2) + i
        for j in i:size(bb, 1)
            flat_2d_array[k] += bb[j, i]
            k += j + 1
        end
    end
    return nothing
end

function s141_inbounds_const(flat_2d_array::AbstractVector, bb::AbstractMatrix)
    checkbounds(flat_2d_array, 1:length(flat_2d_array))
    checkbounds(bb, 1:size(bb, 1), 1:size(bb, 2))
    @aliasscope @inbounds for i in 1:size(bb, 2)
        k = div((i) * ((i) - 1), 2) + i
        for j in i:size(bb, 1)
            flat_2d_array[k] += Const(bb)[j, i]
            k += j + 1
        end
    end
    return nothing
end

# s151 - passing parameter information into a subroutine
function s151s(a::AbstractVector, b::AbstractVector, m::Int)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a)-m)
    for i in 1:length(a)-m
        a[i] = a[i+m] + b[i]
    end
    return nothing
end

function s151(a::AbstractVector, b::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(b))
    s151s(a, b, 1)
    return nothing
end

function s151_const(a::AbstractVector, b::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(b))
    s151s(a, Const(b), 1)
    return nothing
end

function s151_inbounds(a::AbstractVector, b::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(b))
    s151s(a, b, 1)
    return nothing
end

function s151_inbounds_const(a::AbstractVector, b::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(b))
    s151s(a, Const(b), 1)
    return nothing
end

# s152 - collecting information from a subroutine
function s152s(a::AbstractVector, b::AbstractVector, c::AbstractVector, i::Int)
    checkbounds(a, i)
    checkbounds(b, i)
    checkbounds(c, i)
    a[i] += b[i] * c[i]
    return nothing
end

function s152(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    checkbounds(d, 1:length(a))
    checkbounds(e, 1:length(a))
    for i in 1:length(a)
        b[i] = d[i] * e[i]
        s152s(a, b, c, i)
    end
    return nothing
end

function s152_const(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    checkbounds(d, 1:length(a))
    checkbounds(e, 1:length(a))
    @aliasscope for i in 1:length(a)
        b[i] = Const(d)[i] * Const(e)[i]
        s152s(a, b, c, i)
    end
    return nothing
end

function s152_inbounds(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    checkbounds(d, 1:length(a))
    checkbounds(e, 1:length(a))
    @inbounds for i in 1:length(a)
        b[i] = d[i] * e[i]
        s152s(a, b, c, i)
    end
    return nothing
end

function s152_inbounds_const(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    checkbounds(d, 1:length(a))
    checkbounds(e, 1:length(a))
    @aliasscope @inbounds for i in 1:length(a)
        b[i] = Const(d)[i] * Const(e)[i]
        s152s(a, b, c, i)
    end
    return nothing
end

# s161 - tests for recognition of loop independent dependences between statements in mutually exclusive regions.
function s161(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a)-1)
    checkbounds(c, 1:length(a))
    checkbounds(d, 1:length(a)-1)
    checkbounds(e, 1:length(a)-1)
    for i in 1:length(a)-1
        if b[i] < 0.0
            c[i+1] = a[i] + d[i] * d[i]
        else
            a[i] = c[i] + d[i] * e[i]
        end
    end
    return nothing
end

function s161_const(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a)-1)
    checkbounds(c, 1:length(a))
    checkbounds(d, 1:length(a)-1)
    checkbounds(e, 1:length(a)-1)
    @aliasscope for i in 1:length(a)-1
        if Const(b)[i] < 0.0
            c[i+1] = a[i] + Const(d)[i] * Const(d)[i]
        else
            a[i] = c[i] + Const(d)[i] * Const(e)[i]
        end
    end
    return nothing
end

function s161_inbounds(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a)-1)
    checkbounds(c, 1:length(a))
    checkbounds(d, 1:length(a)-1)
    checkbounds(e, 1:length(a)-1)
    @inbounds for i in 1:length(a)-1
        if b[i] < 0.0
            c[i+1] = a[i] + d[i] * d[i]
        else
            a[i] = c[i] + d[i] * e[i]
        end
    end
    return nothing
end

function s161_inbounds_const(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a)-1)
    checkbounds(c, 1:length(a))
    checkbounds(d, 1:length(a)-1)
    checkbounds(e, 1:length(a)-1)
    @aliasscope @inbounds for i in 1:length(a)-1
        if Const(b)[i] < 0.0
            c[i+1] = a[i] + Const(d)[i] * Const(d)[i]
        else
            a[i] = c[i] + Const(d)[i] * Const(e)[i]
        end
    end
    return nothing
end

# s1161 - tests for recognition of loop independent dependences between statements in mutually exclusive regions.
function s1161(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(b))
    checkbounds(c, 1:length(c))
    checkbounds(d, 1:length(d))
    checkbounds(e, 1:length(e))
    for i in 1:length(a)
        if c[i] < 0.0
            b[i] = a[i] + d[i] * d[i]
        else
            a[i] = c[i] + d[i] * e[i]
        end
    end
    return nothing
end

function s1161_const(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(b))
    checkbounds(c, 1:length(c))
    checkbounds(d, 1:length(d))
    checkbounds(e, 1:length(e))
    @aliasscope for i in 1:length(a)
        if Const(c)[i] < 0.0
            b[i] = a[i] + Const(d)[i] * Const(d)[i]
        else
            a[i] = Const(c)[i] + Const(d)[i] * Const(e)[i]
        end
    end
    return nothing
end

function s1161_inbounds(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(b))
    checkbounds(c, 1:length(c))
    checkbounds(d, 1:length(d))
    checkbounds(e, 1:length(e))
    @inbounds for i in 1:length(a)
        if c[i] < 0.0
            b[i] = a[i] + d[i] * d[i]
        else
            a[i] = c[i] + d[i] * e[i]
        end
    end
    return nothing
end

function s1161_inbounds_const(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(b))
    checkbounds(c, 1:length(c))
    checkbounds(d, 1:length(d))
    checkbounds(e, 1:length(e))
    @aliasscope @inbounds for i in 1:length(a)
        if Const(c)[i] < 0.0
            b[i] = a[i] + Const(d)[i] * Const(d)[i]
        else
            a[i] = Const(c)[i] + Const(d)[i] * Const(e)[i]
        end
    end
    return nothing
end

# s162 - deriving assertions
function s162(a::AbstractVector, b::AbstractVector, c::AbstractVector, k::Int)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a)-k)
    checkbounds(c, 1:length(a)-k)
    if k > 0
        for i in 1:length(a)-k
            a[i] = a[i+k] + b[i] * c[i]
        end
    end
    return nothing
end

function s162_const(a::AbstractVector, b::AbstractVector, c::AbstractVector, k::Int)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a)-k)
    checkbounds(c, 1:length(a)-k)
    if k > 0
        @aliasscope for i in 1:length(a)-k
            a[i] = a[i+k] + Const(b)[i] * Const(c)[i]
        end
    end
    return nothing
end

function s162_inbounds(a::AbstractVector, b::AbstractVector, c::AbstractVector, k::Int)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a)-k)
    checkbounds(c, 1:length(a)-k)
    if k > 0
        @inbounds for i in 1:length(a)-k
            a[i] = a[i+k] + b[i] * c[i]
        end
    end
    return nothing
end

function s162_inbounds_const(a::AbstractVector, b::AbstractVector, c::AbstractVector, k::Int)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a)-k)
    checkbounds(c, 1:length(a)-k)
    if k > 0
        @aliasscope @inbounds for i in 1:length(a)-k
            a[i] = a[i+k] + Const(b)[i] * Const(c)[i]
        end
    end
    return nothing
end

# s171 - symbolic dependence tests
function s171(a::AbstractVector, b::AbstractVector, inc::Int)
    checkbounds(b, 1:length(b))
    checkbounds(a, (length(b)-1)÷inc+1)
    for i in 1:length(b)÷inc
        a[(i-1)*inc+1] += b[i]
    end
    return nothing
end

function s171_const(a::AbstractVector, b::AbstractVector, inc::Int)
    checkbounds(b, 1:length(b))
    checkbounds(a, (length(b)-1)÷inc+1)
    @aliasscope for i in 1:length(b)÷inc
        a[(i-1)*inc+1] += Const(b)[i]
    end
    return nothing
end

function s171_inbounds(a::AbstractVector, b::AbstractVector, inc::Int)
    checkbounds(b, 1:length(b))
    checkbounds(a, (length(b)-1)÷inc+1)
    @inbounds for i in 1:length(b)÷inc
        a[(i-1)*inc+1] += b[i]
    end
    return nothing
end

function s171_inbounds_const(a::AbstractVector, b::AbstractVector, inc::Int)
    checkbounds(b, 1:length(b))
    checkbounds(a, (length(b)-1)÷inc+1)
    @aliasscope @inbounds for i in 1:length(b)÷inc
        a[(i-1)*inc+1] += Const(b)[i]
    end
    return nothing
end

# s172 - symbolic dependence tests, vectorizable if n3 != 0
function s172(a::AbstractVector, b::AbstractVector, n1::Int, n3::Int)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    for i in n1:n3:length(a)
        a[i] += b[i]
    end
    return nothing
end

function s172_const(a::AbstractVector, b::AbstractVector, n1::Int, n3::Int)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    @aliasscope for i in n1:n3:length(a)
        a[i] += Const(b)[i]
    end
    return nothing
end

function s172_inbounds(a::AbstractVector, b::AbstractVector, n1::Int, n3::Int)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    @inbounds for i in n1:n3:length(a)
        a[i] += b[i]
    end
    return nothing
end

function s172_inbounds_const(a::AbstractVector, b::AbstractVector, n1::Int, n3::Int)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    @aliasscope @inbounds for i in n1:n3:length(a)
        a[i] += Const(b)[i]
    end
    return nothing
end

# s173 - expression in loop bounds and subscripts
function s173(a::AbstractVector, b::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:div(length(a), 2))
    k = div(length(a), 2)
    for i in 1:div(length(a), 2)
        a[i+k] = a[i] + b[i]
    end
    return nothing
end

function s173_const(a::AbstractVector, b::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:div(length(a), 2))
    k = div(length(a), 2)
    @aliasscope for i in 1:div(length(a), 2)
        a[i+k] = a[i] + Const(b)[i]
    end
    return nothing
end

function s173_inbounds(a::AbstractVector, b::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:div(length(a), 2))
    k = div(length(a), 2)
    @inbounds for i in 1:div(length(a), 2)
        a[i+k] = a[i] + b[i]
    end
    return nothing
end

function s173_inbounds_const(a::AbstractVector, b::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:div(length(a), 2))
    k = div(length(a), 2)
    @aliasscope @inbounds for i in 1:div(length(a), 2)
        a[i+k] = a[i] + Const(b)[i]
    end
    return nothing
end

# s174 - loop with subscript that may seem ambiguous
function s174(a::AbstractVector, b::AbstractVector, M::Int)
    checkbounds(a, 1:2*M)
    checkbounds(b, 1:M)
    for i in 1:M
        a[i+M] = a[i] + b[i]
    end
    return nothing
end

function s174_const(a::AbstractVector, b::AbstractVector, M::Int)
    checkbounds(a, 1:2*M)
    checkbounds(b, 1:M)
    @aliasscope for i in 1:M
        a[i+M] = a[i] + Const(b)[i]
    end
    return nothing
end

function s174_inbounds(a::AbstractVector, b::AbstractVector, M::Int)
    checkbounds(a, 1:2*M)
    checkbounds(b, 1:M)
    @inbounds for i in 1:M
        a[i+M] = a[i] + b[i]
    end
    return nothing
end

function s174_inbounds_const(a::AbstractVector, b::AbstractVector, M::Int)
    checkbounds(a, 1:2*M)
    checkbounds(b, 1:M)
    @aliasscope @inbounds for i in 1:M
        a[i+M] = a[i] + Const(b)[i]
    end
    return nothing
end

# s175 - symbolic dependence tests
function s175(a::AbstractVector, b::AbstractVector, inc::Int)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    for i in 1:inc:length(a)-inc
        a[i] = a[i+inc] + b[i]
    end
    return nothing
end

function s175_const(a::AbstractVector, b::AbstractVector, inc::Int)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    @aliasscope for i in 1:inc:length(a)-inc
        a[i] = a[i+inc] + Const(b)[i]
    end
    return nothing
end

function s175_inbounds(a::AbstractVector, b::AbstractVector, inc::Int)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    @inbounds for i in 1:inc:length(a)-inc
        a[i] = a[i+inc] + b[i]
    end
    return nothing
end

function s175_inbounds_const(a::AbstractVector, b::AbstractVector, inc::Int)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    @aliasscope @inbounds for i in 1:inc:length(a)-inc
        a[i] = a[i+inc] + Const(b)[i]
    end
    return nothing
end

# s176 - convolution
function s176(a::AbstractVector, b::AbstractVector, c::AbstractVector)
    m = div(length(a), 2)
    checkbounds(a, 1:m)
    checkbounds(b, 1:length(a)-1)
    checkbounds(c, 1:m)
    for j in 1:m
        for i in 1:m
            a[i] += b[i+m-j] * c[j]
        end
    end
    return nothing
end

function s176_const(a::AbstractVector, b::AbstractVector, c::AbstractVector)
    m = div(length(a), 2)
    checkbounds(a, 1:m)
    checkbounds(b, 1:length(a)-1)
    checkbounds(c, 1:m)
    @aliasscope for j in 1:m
        for i in 1:m
            a[i] += Const(b)[i+m-j] * Const(c)[j]
        end
    end
    return nothing
end

function s176_inbounds(a::AbstractVector, b::AbstractVector, c::AbstractVector)
    m = div(length(a), 2)
    checkbounds(a, 1:m)
    checkbounds(b, 1:length(a)-1)
    checkbounds(c, 1:m)
    @inbounds for j in 1:m
        for i in 1:m
            a[i] += b[i+m-j] * c[j]
        end
    end
    return nothing
end


function s176_inbounds_const(a::AbstractVector, b::AbstractVector, c::AbstractVector)
    m = div(length(a), 2)
    checkbounds(a, 1:m)
    checkbounds(b, 1:length(a)-1)
    checkbounds(c, 1:m)
    @aliasscope @inbounds for j in 1:m
        for i in 1:m
            a[i] += Const(b)[i+m-j] * Const(c)[j]
        end
    end
    return nothing
end
# ============================================================================
# VECTORIZATION - Section 2
# ============================================================================

# s211 - statement reordering allows vectorization
function s211(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 2:length(a)-1)
    checkbounds(d, 2:length(a)-1)
    checkbounds(e, 2:length(a)-1)
    for i in 2:length(a)-1
        a[i] = b[i-1] + c[i] * d[i]
        b[i] = b[i+1] - e[i] * d[i]
    end
    return nothing
end

# const causes miscompilation
# function s211_const(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector)
#     checkbounds(a, 1:length(a))
#     checkbounds(b, 1:length(a))
#     checkbounds(c, 2:length(a)-1)
#     checkbounds(d, 2:length(a)-1)
#     checkbounds(e, 2:length(a)-1)
#     @aliasscope for i in 2:length(a)-1
#         a[i] = b[i-1] + Const(c)[i] * Const(d)[i]
#         b[i] = b[i+1] - Const(e)[i] * Const(d)[i]
#     end
#     return nothing
# end

function s211_inbounds(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 2:length(a)-1)
    checkbounds(d, 2:length(a)-1)
    checkbounds(e, 2:length(a)-1)
    @inbounds for i in 2:length(a)-1
        a[i] = b[i-1] + c[i] * d[i]
        b[i] = b[i+1] - e[i] * d[i]
    end
    return nothing
end

# function s211_inbounds_const(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector)
#     checkbounds(a, 1:length(a))
#     checkbounds(b, 1:length(a))
#     checkbounds(c, 2:length(a)-1)
#     checkbounds(d, 2:length(a)-1)
#     checkbounds(e, 2:length(a)-1)
#     @aliasscope @inbounds for i in 2:length(a)-1
#         a[i] = b[i-1] + Const(c)[i] * Const(d)[i]
#         b[i] = b[i+1] - Const(e)[i] * Const(d)[i]
#     end
#     return nothing
# end

# s212 - dependency needing temporary
function s212(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a)-1)
    checkbounds(c, 1:length(a)-1)
    checkbounds(d, 1:length(a)-1)
    for i in 1:length(a)-1
        a[i] *= c[i]
        b[i] += a[i+1] * d[i]
    end
    return nothing
end

function s212_const(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a)-1)
    checkbounds(c, 1:length(a)-1)
    checkbounds(d, 1:length(a)-1)
    @aliasscope for i in 1:length(a)-1
        a[i] *= Const(c)[i]
        b[i] += a[i+1] * Const(d)[i]
    end
    return nothing
end

function s212_inbounds(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a)-1)
    checkbounds(c, 1:length(a)-1)
    checkbounds(d, 1:length(a)-1)
    @inbounds for i in 1:length(a)-1
        a[i] *= c[i]
        b[i] += a[i+1] * d[i]
    end
    return nothing
end

function s212_inbounds_const(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a)-1)
    checkbounds(c, 1:length(a)-1)
    checkbounds(d, 1:length(a)-1)
    @aliasscope @inbounds for i in 1:length(a)-1
        a[i] *= Const(c)[i]
        b[i] += a[i+1] * Const(d)[i]
    end
    return nothing
end

# s1213 - dependency needing temporary
function s1213(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a)-1)
    checkbounds(c, 2:length(a)-1)
    checkbounds(d, 2:length(a)-1)
    @inbounds for i in 2:length(a)-1
        a[i] = b[i-1] + c[i]
        b[i] = a[i+1] * d[i]
    end
    return nothing
end

function s1213_const(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a)-1)
    checkbounds(c, 2:length(a)-1)
    checkbounds(d, 2:length(a)-1)
    @aliasscope for i in 2:length(a)-1
        a[i] = Const(b)[i-1] + Const(c)[i]
        b[i] = a[i+1] * Const(d)[i]
    end
    return nothing
end

function s1213_inbounds(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a)-1)
    checkbounds(c, 2:length(a)-1)
    checkbounds(d, 2:length(a)-1)
    @inbounds for i in 2:length(a)-1
        a[i] = b[i-1] + c[i]
        b[i] = a[i+1] * d[i]
    end
    return nothing
end

function s1213_inbounds_const(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a)-1)
    checkbounds(c, 2:length(a)-1)
    checkbounds(d, 2:length(a)-1)
    @aliasscope @inbounds for i in 2:length(a)-1
        a[i] = Const(b)[i-1] + Const(c)[i]
        b[i] = a[i+1] * Const(d)[i]
    end
    return nothing
end

# s221 - loop that is partially recursive
function s221(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 2:length(a))
    checkbounds(d, 2:length(a))
    for i in 2:length(a)
        a[i] += c[i] * d[i]
        b[i] = b[i-1] + a[i] + d[i]
    end
    return nothing
end

function s221_const(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 2:length(a))
    checkbounds(d, 2:length(a))
    @aliasscope for i in 2:length(a)
        a[i] += Const(c)[i] * Const(d)[i]
        b[i] = b[i-1] + a[i] + Const(d)[i]
    end
    return nothing
end

function s221_inbounds(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 2:length(a))
    checkbounds(d, 2:length(a))
    @inbounds for i in 2:length(a)
        a[i] += c[i] * d[i]
        b[i] = b[i-1] + a[i] + d[i]
    end
    return nothing
end

function s221_inbounds_const(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 2:length(a))
    checkbounds(d, 2:length(a))
    @aliasscope @inbounds for i in 2:length(a)
        a[i] += Const(c)[i] * Const(d)[i]
        b[i] = b[i-1] + a[i] + Const(d)[i]
    end
    return nothing
end

# s1221 - run-time symbolic resolution
function s1221(a::AbstractVector, b::AbstractVector)
    checkbounds(a, 5:length(a))
    checkbounds(b, 1:length(a))
    for i in 5:length(a)
        b[i] = b[i-4] + a[i]
    end
    return nothing
end

function s1221_const(a::AbstractVector, b::AbstractVector)
    checkbounds(a, 5:length(a))
    checkbounds(b, 1:length(a))
    @aliasscope for i in 5:length(a)
        b[i] = b[i-4] + Const(a)[i]
    end
    return nothing
end

function s1221_inbounds(a::AbstractVector, b::AbstractVector)
    checkbounds(a, 5:length(a))
    checkbounds(b, 1:length(a))
    @inbounds for i in 5:length(a)
        b[i] = b[i-4] + a[i]
    end
    return nothing
end

# const causes miscompilation
# function s1221_inbounds_const(a::AbstractVector, b::AbstractVector)
#     checkbounds(a, 5:length(a))
#     checkbounds(b, 1:length(a))
#     @aliasscope @inbounds for i in 5:length(a)
#         b[i] = b[i-4] + Const(a)[i]
#     end
#     return nothing
# end

# s222 - partial loop vectorization recurrence in middle
function s222(a::AbstractVector, b::AbstractVector, c::AbstractVector, e::AbstractVector)
    checkbounds(a, 2:length(a))
    checkbounds(b, 2:length(a))
    checkbounds(c, 2:length(a))
    checkbounds(e, 1:length(a))
    for i in 2:length(a)
        a[i] += b[i] * c[i]
        e[i] = e[i-1] * e[i-1]
        a[i] -= b[i] * c[i]
    end
    return nothing
end

function s222_const(a::AbstractVector, b::AbstractVector, c::AbstractVector, e::AbstractVector)
    checkbounds(a, 2:length(a))
    checkbounds(b, 2:length(a))
    checkbounds(c, 2:length(a))
    checkbounds(e, 1:length(a))
    @aliasscope for i in 2:length(a)
        a[i] += Const(b)[i] * Const(c)[i]
        e[i] = e[i-1] * e[i-1]
        a[i] -= Const(b)[i] * Const(c)[i]
    end
    return nothing
end

function s222_inbounds(a::AbstractVector, b::AbstractVector, c::AbstractVector, e::AbstractVector)
    checkbounds(a, 2:length(a))
    checkbounds(b, 2:length(a))
    checkbounds(c, 2:length(a))
    checkbounds(e, 1:length(a))
    @inbounds for i in 2:length(a)
        a[i] += b[i] * c[i]
        e[i] = e[i-1] * e[i-1]
        a[i] -= b[i] * c[i]
    end
    return nothing
end

function s222_inbounds_const(a::AbstractVector, b::AbstractVector, c::AbstractVector, e::AbstractVector)
    checkbounds(a, 2:length(a))
    checkbounds(b, 2:length(a))
    checkbounds(c, 2:length(a))
    checkbounds(e, 1:length(a))
    @aliasscope @inbounds for i in 2:length(a)
        a[i] += Const(b)[i] * Const(c)[i]
        e[i] = e[i-1] * e[i-1]
        a[i] -= Const(b)[i] * Const(c)[i]
    end
    return nothing
end

# s231 - loop interchange, loop with data dependency
function s231(aa::AbstractMatrix, bb::AbstractMatrix)
    checkbounds(aa, 1:size(aa, 1), 1:size(aa, 2))
    checkbounds(bb, 1:size(bb, 1), 1:size(bb, 2))
    for j in 1:size(aa, 2)
        for i in 2:size(aa, 1)
            aa[i, j] = aa[i-1, j] + bb[i, j]
        end
    end
    return nothing
end

function s231_const(aa::AbstractMatrix, bb::AbstractMatrix)
    checkbounds(aa, 1:size(aa, 1), 1:size(aa, 2))
    checkbounds(bb, 1:size(bb, 1), 1:size(bb, 2))
    @aliasscope for j in 1:size(aa, 2)
        for i in 2:size(aa, 1)
            aa[i, j] = aa[i-1, j] + Const(bb)[i, j]
        end
    end
    return nothing
end

function s231_inbounds(aa::AbstractMatrix, bb::AbstractMatrix)
    checkbounds(aa, 1:size(aa, 1), 1:size(aa, 2))
    checkbounds(bb, 1:size(bb, 1), 1:size(bb, 2))
    @inbounds for j in 1:size(aa, 2)
        for i in 2:size(aa, 1)
            aa[i, j] = aa[i-1, j] + bb[i, j]
        end
    end
    return nothing
end

function s231_inbounds_const(aa::AbstractMatrix{T}, bb::AbstractMatrix{T}) where {T}
    checkbounds(aa, 1:size(aa, 1), 1:size(aa, 2))
    checkbounds(bb, 1:size(bb, 1), 1:size(bb, 2))
    @aliasscope @inbounds for j in 1:size(aa, 2)
        for i in 2:size(aa, 1)
            aa[i, j] = aa[i-1, j] + Const(bb)[i, j]
        end
    end
    return nothing
end

# s232 - loop interchange, interchanging of triangular loops
function s232(aa::AbstractMatrix, bb::AbstractMatrix)
    checkbounds(aa, 1:size(aa, 1), 1:size(aa, 2))
    checkbounds(bb, 1:size(bb, 1), 1:size(bb, 2))
    for j in 2:size(aa, 1)
        for i in 2:j
            aa[j, i] = aa[j, i-1] * aa[j, i-1] + bb[j, i]
        end
    end
    return nothing
end

function s232_const(aa::AbstractMatrix, bb::AbstractMatrix)
    checkbounds(aa, 1:size(aa, 1), 1:size(aa, 2))
    checkbounds(bb, 1:size(bb, 1), 1:size(bb, 2))
    @aliasscope for j in 2:size(aa, 1)
        for i in 2:j
            aa[j, i] = aa[j, i-1] * aa[j, i-1] + Const(bb)[j, i]
        end
    end
    return nothing
end

function s232_inbounds(aa::AbstractMatrix, bb::AbstractMatrix)
    checkbounds(aa, 1:size(aa, 1), 1:size(aa, 2))
    checkbounds(bb, 1:size(bb, 1), 1:size(bb, 2))
    @inbounds for j in 2:size(aa, 1)
        for i in 2:j
            aa[j, i] = aa[j, i-1] * aa[j, i-1] + bb[j, i]
        end
    end
    return nothing
end

function s232_inbounds_const(aa::AbstractMatrix, bb::AbstractMatrix)
    checkbounds(aa, 1:size(aa, 1), 1:size(aa, 2))
    checkbounds(bb, 1:size(bb, 1), 1:size(bb, 2))
    @aliasscope @inbounds for j in 2:size(aa, 1)
        for i in 2:j
            aa[j, i] = aa[j, i-1] * aa[j, i-1] + Const(bb)[j, i]
        end
    end
    return nothing
end

# s1232 - loop interchange, interchanging of triangular loops
function s1232(aa::AbstractMatrix, bb::AbstractMatrix, cc::AbstractMatrix)
    checkbounds(aa, 1:size(aa, 1), 1:size(aa, 2))
    checkbounds(bb, 1:size(bb, 1), 1:size(bb, 2))
    checkbounds(cc, 1:size(cc, 1), 1:size(cc, 2))
    for j in 1:size(aa, 2)
        for i in j:size(aa, 1)
            aa[i, j] = bb[i, j] + cc[i, j]
        end
    end
    return nothing
end

function s1232_const(aa::AbstractMatrix, bb::AbstractMatrix, cc::AbstractMatrix)
    checkbounds(aa, 1:size(aa, 1), 1:size(aa, 2))
    checkbounds(bb, 1:size(bb, 1), 1:size(bb, 2))
    checkbounds(cc, 1:size(cc, 1), 1:size(cc, 2))
    @aliasscope for j in 1:size(aa, 2)
        for i in j:size(aa, 1)
            aa[i, j] = Const(bb)[i, j] + Const(cc)[i, j]
        end
    end
    return nothing
end

function s1232_inbounds(aa::AbstractMatrix, bb::AbstractMatrix, cc::AbstractMatrix)
    checkbounds(aa, 1:size(aa, 1), 1:size(aa, 2))
    checkbounds(bb, 1:size(bb, 1), 1:size(bb, 2))
    checkbounds(cc, 1:size(cc, 1), 1:size(cc, 2))
    @inbounds for j in 1:size(aa, 2)
        for i in j:size(aa, 1)
            aa[i, j] = bb[i, j] + cc[i, j]
        end
    end
    return nothing
end

function s1232_inbounds_const(aa::AbstractMatrix, bb::AbstractMatrix, cc::AbstractMatrix)
    checkbounds(aa, 1:size(aa, 1), 1:size(aa, 2))
    checkbounds(bb, 1:size(bb, 1), 1:size(bb, 2))
    checkbounds(cc, 1:size(cc, 1), 1:size(cc, 2))
    @aliasscope @inbounds for j in 1:size(aa, 2)
        for i in j:size(aa, 1)
            aa[i, j] = Const(bb)[i, j] + Const(cc)[i, j]
        end
    end
    return nothing
end

# s233 - loop interchange, interchanging with one of two inner loops
function s233(aa::AbstractMatrix, bb::AbstractMatrix, cc::AbstractMatrix)
    checkbounds(aa, 1:size(aa, 1), 1:size(aa, 2))
    checkbounds(bb, 1:size(bb, 1), 1:size(bb, 2))
    checkbounds(cc, 1:size(cc, 1), 1:size(cc, 2))
    for j in 2:size(aa, 2)
        for i in 2:size(aa, 1)
            aa[i, j] = aa[i-1, j] + cc[i, j]
        end
        for i in 2:size(bb, 1)
            bb[i, j] = bb[i, j-1] + cc[i, j]
        end
    end
    return nothing
end

function s233_const(aa::AbstractMatrix, bb::AbstractMatrix, cc::AbstractMatrix)
    checkbounds(aa, 1:size(aa, 1), 1:size(aa, 2))
    checkbounds(bb, 1:size(bb, 1), 1:size(bb, 2))
    checkbounds(cc, 1:size(cc, 1), 1:size(cc, 2))
    @aliasscope for j in 2:size(aa, 2)
        for i in 2:size(aa, 1)
            aa[i, j] = aa[i-1, j] + Const(cc)[i, j]
        end
        for i in 2:size(bb, 1)
            bb[i, j] = bb[i, j-1] + Const(cc)[i, j]
        end
    end
    return nothing
end

function s233_inbounds(aa::AbstractMatrix, bb::AbstractMatrix, cc::AbstractMatrix)
    checkbounds(aa, 1:size(aa, 1), 1:size(aa, 2))
    checkbounds(bb, 1:size(bb, 1), 1:size(bb, 2))
    checkbounds(cc, 1:size(cc, 1), 1:size(cc, 2))
    @inbounds for j in 2:size(aa, 2)
        for i in 2:size(aa, 1)
            aa[i, j] = aa[i-1, j] + cc[i, j]
        end
        for i in 2:size(bb, 1)
            bb[i, j] = bb[i, j-1] + cc[i, j]
        end
    end
    return nothing
end

# const causes miscompilation
# function s233_inbounds_const(aa::AbstractMatrix, bb::AbstractMatrix, cc::AbstractMatrix)
#     checkbounds(aa, 1:size(aa, 1), 1:size(aa, 2))
#     checkbounds(bb, 1:size(bb, 1), 1:size(bb, 2))
#     checkbounds(cc, 1:size(cc, 1), 1:size(cc, 2))
#     @aliasscope @inbounds for j in 2:size(aa, 2)
#         for i in 2:size(aa, 1)
#             aa[i, j] = aa[i-1, j] + Const(cc)[i, j]
#         end
#         for i in 2:size(bb, 1)
#             bb[i, j] = bb[i, j-1] + Const(cc)[i, j]
#         end
#     end
#     return nothing
# end

# s2233 - loop interchange
function s2233(aa::AbstractMatrix, bb::AbstractMatrix, cc::AbstractMatrix)
    checkbounds(aa, 1:size(aa, 1), 1:size(aa, 2))
    checkbounds(bb, 1:size(bb, 1), 1:size(bb, 2))
    checkbounds(cc, 1:size(cc, 1), 1:size(cc, 2))
    for j in 2:size(aa, 2)
        for i in 2:size(aa, 1)
            aa[i, j] = aa[i-1, j] + cc[i, j]
        end
    end
    for j in 2:size(bb, 2)
        for i in 2:size(bb, 1)
            bb[i, j] = bb[i-1, j] + cc[i, j]
        end
    end
    return nothing
end

function s2233_const(aa::AbstractMatrix, bb::AbstractMatrix, cc::AbstractMatrix)
    checkbounds(aa, 1:size(aa, 1), 1:size(aa, 2))
    checkbounds(bb, 1:size(bb, 1), 1:size(bb, 2))
    checkbounds(cc, 1:size(cc, 1), 1:size(cc, 2))
    @aliasscope for j in 2:size(aa, 2)
        for i in 2:size(aa, 1)
            aa[i, j] = aa[i-1, j] + Const(cc)[i, j]
        end
    end
    @aliasscope for j in 2:size(bb, 2)
        for i in 2:size(bb, 1)
            bb[i, j] = bb[i-1, j] + Const(cc)[i, j]
        end
    end
    return nothing
end

function s2233_inbounds(aa::AbstractMatrix, bb::AbstractMatrix, cc::AbstractMatrix)
    checkbounds(aa, 1:size(aa, 1), 1:size(aa, 2))
    checkbounds(bb, 1:size(bb, 1), 1:size(bb, 2))
    checkbounds(cc, 1:size(cc, 1), 1:size(cc, 2))
    @inbounds for j in 2:size(aa, 2)
        for i in 2:size(aa, 1)
            aa[i, j] = aa[i-1, j] + cc[i, j]
        end
    end
    @inbounds for j in 2:size(bb, 2)
        for i in 2:size(bb, 1)
            bb[i, j] = bb[i-1, j] + cc[i, j]
        end
    end
    return nothing
end

function s2233_inbounds_const(aa::AbstractMatrix, bb::AbstractMatrix, cc::AbstractMatrix)
    checkbounds(aa, 1:size(aa, 1), 1:size(aa, 2))
    checkbounds(bb, 1:size(bb, 1), 1:size(bb, 2))
    checkbounds(cc, 1:size(cc, 1), 1:size(cc, 2))
    @aliasscope @inbounds for j in 2:size(aa, 2)
        for i in 2:size(aa, 1)
            aa[i, j] = aa[i-1, j] + Const(cc)[i, j]
        end
    end
    @aliasscope @inbounds for j in 2:size(bb, 2)
        for i in 2:size(bb, 1)
            bb[i, j] = bb[i-1, j] + Const(cc)[i, j]
        end
    end
    return nothing
end

# s235 - loop interchanging, imperfectly nested loops
function s235(a::AbstractVector, b::AbstractVector, c::AbstractVector, aa::AbstractMatrix, bb::AbstractMatrix)
    checkbounds(a, 1:size(aa, 2))
    checkbounds(b, 1:size(aa, 2))
    checkbounds(c, 1:size(aa, 2))
    checkbounds(aa, 1:size(aa,1), 1:size(aa,2))
    checkbounds(bb, 1:size(bb,1), 1:size(bb,2))

    for i in 1:size(aa, 2)
        a[i] += b[i] * c[i]
        for j in 2:size(aa, 1)
            aa[j, i] = aa[j-1, i] + bb[j, i] * a[i]
        end
    end
    return nothing
end

function s235_const(a::AbstractVector, b::AbstractVector, c::AbstractVector, aa::AbstractMatrix, bb::AbstractMatrix)
    checkbounds(a, 1:size(aa, 2))
    checkbounds(b, 1:size(aa, 2))
    checkbounds(c, 1:size(aa, 2))
    checkbounds(aa, 1:size(aa,1), 1:size(aa,2))
    checkbounds(bb, 1:size(bb,1), 1:size(bb,2))

    @aliasscope for i in 1:size(aa, 2)
        a[i] += Const(b)[i] * Const(c)[i]
        for j in 2:size(aa, 1)
            aa[j, i] = aa[j-1, i] + Const(bb)[j, i] * a[i]
        end
    end
    return nothing
end

function s235_inbounds(a::AbstractVector, b::AbstractVector, c::AbstractVector, aa::AbstractMatrix, bb::AbstractMatrix)
    checkbounds(a, 1:size(aa, 2))
    checkbounds(b, 1:size(aa, 2))
    checkbounds(c, 1:size(aa, 2))
    checkbounds(aa, 1:size(aa,1), 1:size(aa,2))
    checkbounds(bb, 1:size(bb,1), 1:size(bb,2))

    @inbounds for i in 1:size(aa, 2)
        a[i] += b[i] * c[i]
        for j in 2:size(aa, 1)
            aa[j, i] = aa[j-1, i] + bb[j, i] * a[i]
        end
    end
    return nothing
end

function s235_inbounds_const(a::AbstractVector, b::AbstractVector, c::AbstractVector, aa::AbstractMatrix, bb::AbstractMatrix)
    checkbounds(a, 1:size(aa, 2))
    checkbounds(b, 1:size(aa, 2))
    checkbounds(c, 1:size(aa, 2))
    checkbounds(aa, 1:size(aa,1), 1:size(aa,2))
    checkbounds(bb, 1:size(bb,1), 1:size(bb,2))

    @aliasscope @inbounds for i in 1:size(aa, 2)
        a[i] += Const(b)[i] * Const(c)[i]
        for j in 2:size(aa, 1)
            aa[j, i] = aa[j-1, i] + Const(bb)[j, i] * a[i]
        end
    end
    return nothing
end

# s241 - node splitting
function s241(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(b))
    checkbounds(c, 1:length(c))
    checkbounds(d, 1:length(d))

    for i in 1:length(a)-1
        a[i] = b[i] * c[i] * d[i]
        b[i] = a[i] * a[i+1] * d[i]
    end
    return nothing
end

function s241_const(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(b))
    checkbounds(c, 1:length(c))
    checkbounds(d, 1:length(d))

    @aliasscope for i in 1:length(a)-1
        a[i] = Const(b)[i] * Const(c)[i] * Const(d)[i]
        b[i] = a[i] * a[i+1] * Const(d)[i]
    end
    return nothing
end

function s241_inbounds(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(b))
    checkbounds(c, 1:length(c))
    checkbounds(d, 1:length(d))

    @inbounds for i in 1:length(a)-1
        a[i] = b[i] * c[i] * d[i]
        b[i] = a[i] * a[i+1] * d[i]
    end
    return nothing
end

function s241_inbounds_const(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(b))
    checkbounds(c, 1:length(c))
    checkbounds(d, 1:length(d))

    @aliasscope @inbounds for i in 1:length(a)-1
        a[i] = Const(b)[i] * Const(c)[i] * Const(d)[i]
        b[i] = a[i] * a[i+1] * Const(d)[i]
    end
    return nothing
end

# s242 - node splitting
function s242(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, s1::Number, s2::Number)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(b))
    checkbounds(c, 1:length(c))
    checkbounds(d, 1:length(d))

    for i in 2:length(a)
        a[i] = a[i - 1] + s1 + s2 + b[i] + c[i] + d[i]
    end
    return nothing
end

function s242_const(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, s1::Number, s2::Number)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(b))
    checkbounds(c, 1:length(c))
    checkbounds(d, 1:length(d))

    @aliasscope for i in 2:length(a)
        a[i] = a[i - 1] + s1 + s2 + Const(b)[i] + Const(c)[i] + Const(d)[i]
    end
    return nothing
end

function s242_inbounds(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, s1::Number, s2::Number)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(b))
    checkbounds(c, 1:length(c))
    checkbounds(d, 1:length(d))

    @inbounds for i in 2:length(a)
        a[i] = a[i - 1] + s1 + s2 + b[i] + c[i] + d[i]
    end
    return nothing
end

function s242_inbounds_const(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, s1::Number, s2::Number)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(b))
    checkbounds(c, 1:length(c))
    checkbounds(d, 1:length(d))

    @aliasscope @inbounds for i in 2:length(a)
        a[i] = a[i - 1] + s1 + s2 + Const(b)[i] + Const(c)[i] + Const(d)[i]
    end
    return nothing
end

# s243 - node splitting, false dependence cycle breaking
function s243(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(b))
    checkbounds(c, 1:length(c))
    checkbounds(d, 1:length(d))
    checkbounds(e, 1:length(e))

    for i in 1:length(a)-1
        a[i] = b[i] + c[i] * d[i]
        b[i] = a[i] + d[i] * e[i]
        a[i] = b[i] + a[i+1] * d[i]
    end
    return nothing
end

function s243_const(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(b))
    checkbounds(c, 1:length(c))
    checkbounds(d, 1:length(d))
    checkbounds(e, 1:length(e))

    @aliasscope for i in 1:length(a)-1
        a[i] = Const(b)[i] + Const(c)[i] * Const(d)[i]
        b[i] = a[i] + Const(d)[i] * Const(e)[i]
        a[i] = b[i] + a[i+1] * Const(d)[i]
    end
    return nothing
end

function s243_inbounds(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(b))
    checkbounds(c, 1:length(c))
    checkbounds(d, 1:length(d))
    checkbounds(e, 1:length(e))

    @inbounds for i in 1:length(a)-1
        a[i] = b[i] + c[i] * d[i]
        b[i] = a[i] + d[i] * e[i]
        a[i] = b[i] + a[i+1] * d[i]
    end
    return nothing
end

function s243_inbounds_const(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(b))
    checkbounds(c, 1:length(c))
    checkbounds(d, 1:length(d))
    checkbounds(e, 1:length(e))

    @aliasscope @inbounds for i in 1:length(a)-1
        a[i] = Const(b)[i] + Const(c)[i] * Const(d)[i]
        b[i] = a[i] + Const(d)[i] * Const(e)[i]
        a[i] = b[i] + a[i+1] * Const(d)[i]
    end
    return nothing
end

# s244 - node splitting, false dependence cycle breaking
function s244(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(b))
    checkbounds(c, 1:length(c))
    checkbounds(d, 1:length(d))

    for i in 1:length(a)-1
        a[i] = b[i] + c[i] * d[i]
        b[i] = c[i] + b[i]
        a[i+1] = b[i] + a[i+1] * d[i]
    end
    return nothing
end

function s244_const(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(b))
    checkbounds(c, 1:length(c))
    checkbounds(d, 1:length(d))

    @aliasscope for i in 1:length(a)-1
        a[i] = Const(b)[i] + Const(c)[i] * Const(d)[i]
        b[i] = Const(c)[i] + Const(b)[i]
        a[i+1] = b[i] + a[i+1] * Const(d)[i]
    end
    return nothing
end

function s244_inbounds(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(b))
    checkbounds(c, 1:length(c))
    checkbounds(d, 1:length(d))

    @inbounds for i in 1:length(a)-1
        a[i] = b[i] + c[i] * d[i]
        b[i] = c[i] + b[i]
        a[i+1] = b[i] + a[i+1] * d[i]
    end
    return nothing
end

function s244_inbounds_const(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(b))
    checkbounds(c, 1:length(c))
    checkbounds(d, 1:length(d))

    @aliasscope @inbounds for i in 1:length(a)-1
        a[i] = Const(b)[i] + Const(c)[i] * Const(d)[i]
        b[i] = Const(c)[i] + Const(b)[i]
        a[i+1] = b[i] + a[i+1] * Const(d)[i]
    end
    return nothing
end

# s1244 - node splitting, cycle with true and anti dependency
function s1244(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(b))
    checkbounds(c, 1:length(c))
    checkbounds(d, 1:length(d))

    for i in 1:length(a)-1
        a[i] = b[i] + c[i] * c[i] + b[i] * b[i] + c[i]
        d[i] = a[i] + a[i+1]
    end
    return nothing
end

function s1244_const(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(b))
    checkbounds(c, 1:length(c))
    checkbounds(d, 1:length(d))

    @aliasscope for i in 1:length(a)-1
        a[i] = Const(b)[i] + Const(c)[i] * Const(c)[i] + Const(b)[i] * Const(b)[i] + Const(c)[i]
        d[i] = a[i] + a[i+1]
    end
    return nothing
end

function s1244_inbounds(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(b))
    checkbounds(c, 1:length(c))
    checkbounds(d, 1:length(d))

    @inbounds for i in 1:length(a)-1
        a[i] = b[i] + c[i] * c[i] + b[i] * b[i] + c[i]
        d[i] = a[i] + a[i+1]
    end
    return nothing
end

function s1244_inbounds_const(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(b))
    checkbounds(c, 1:length(c))
    checkbounds(d, 1:length(d))

    @aliasscope @inbounds for i in 1:length(a)-1
        a[i] = Const(b)[i] + Const(c)[i] * Const(c)[i] + Const(b)[i] * Const(b)[i] + Const(c)[i]
        d[i] = a[i] + a[i+1]
    end
    return nothing
end

# s2244 - node splitting, cycle with true and anti dependency
function s2244(a::AbstractVector, b::AbstractVector, c::AbstractVector, e::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(b))
    checkbounds(c, 1:length(c))
    checkbounds(e, 1:length(e))

    for i in 1:length(a)-1
        a[i+1] = b[i] + e[i]
        a[i] = b[i] + c[i]
    end
    return nothing
end

function s2244_const(a::AbstractVector, b::AbstractVector, c::AbstractVector, e::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(b))
    checkbounds(c, 1:length(c))
    checkbounds(e, 1:length(e))

    @aliasscope for i in 1:length(a)-1
        a[i+1] = Const(b)[i] + Const(e)[i]
        a[i] = Const(b)[i] + Const(c)[i]
    end
    return nothing
end

function s2244_inbounds(a::AbstractVector, b::AbstractVector, c::AbstractVector, e::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(b))
    checkbounds(c, 1:length(c))
    checkbounds(e, 1:length(e))

    @inbounds for i in 1:length(a)-1
        a[i+1] = b[i] + e[i]
        a[i] = b[i] + c[i]
    end
    return nothing
end

function s2244_inbounds_const(a::AbstractVector, b::AbstractVector, c::AbstractVector, e::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(b))
    checkbounds(c, 1:length(c))
    checkbounds(e, 1:length(e))

    @aliasscope @inbounds for i in 1:length(a)-1
        a[i+1] = Const(b)[i] + Const(e)[i]
        a[i] = Const(b)[i] + Const(c)[i]
    end
    return nothing
end

# s251 - scalar and array expansion, scalar expansion
function s251(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(b))
    checkbounds(c, 1:length(c))
    checkbounds(d, 1:length(d))

    for i in 1:length(a)
        s = b[i] + c[i] * d[i]
        a[i] = s * s
    end
    return nothing
end

function s251_const(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(b))
    checkbounds(c, 1:length(c))
    checkbounds(d, 1:length(d))

    @aliasscope for i in 1:length(a)
        s = Const(b)[i] + Const(c)[i] * Const(d)[i]
        a[i] = s * s
    end
    return nothing
end

function s251_inbounds(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(b))
    checkbounds(c, 1:length(c))
    checkbounds(d, 1:length(d))

    @inbounds for i in 1:length(a)
        s = b[i] + c[i] * d[i]
        a[i] = s * s
    end
    return nothing
end

function s251_inbounds_const(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(b))
    checkbounds(c, 1:length(c))
    checkbounds(d, 1:length(d))

    @aliasscope @inbounds for i in 1:length(a)
        s = Const(b)[i] + Const(c)[i] * Const(d)[i]
        a[i] = s * s
    end
    return nothing
end

# s1251 - scalar and array expansion, scalar expansion
function s1251(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(b))
    checkbounds(c, 1:length(c))
    checkbounds(d, 1:length(d))
    checkbounds(e, 1:length(e))

    for i in 1:length(a)
        s = b[i] + c[i]
        b[i] = a[i] + d[i]
        a[i] = s * e[i]
    end
    return nothing
end

function s1251_const(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(b))
    checkbounds(c, 1:length(c))
    checkbounds(d, 1:length(d))
    checkbounds(e, 1:length(e))

    @aliasscope for i in 1:length(a)
        s = Const(b)[i] + Const(c)[i]
        b[i] = a[i] + Const(d)[i]
        a[i] = s * Const(e)[i]
    end
    return nothing
end

function s1251_inbounds(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(b))
    checkbounds(c, 1:length(c))
    checkbounds(d, 1:length(d))
    checkbounds(e, 1:length(e))

    @inbounds for i in 1:length(a)
        s = b[i] + c[i]
        b[i] = a[i] + d[i]
        a[i] = s * e[i]
    end
    return nothing
end

function s1251_inbounds_const(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(b))
    checkbounds(c, 1:length(c))
    checkbounds(d, 1:length(d))
    checkbounds(e, 1:length(e))

    @aliasscope @inbounds for i in 1:length(a)
        s = Const(b)[i] + Const(c)[i]
        b[i] = a[i] + Const(d)[i]
        a[i] = s * Const(e)[i]
    end
    return nothing
end

# s2251 - scalar and array expansion, scalar expansion
function s2251(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(b))
    checkbounds(c, 1:length(c))
    checkbounds(d, 1:length(d))
    checkbounds(e, 1:length(e))

    s = 0.0
    for i in 1:length(a)
        a[i] = s * e[i]
        s = b[i] + c[i]
        b[i] = a[i] + d[i]
    end
    return nothing
end

function s2251_const(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(b))
    checkbounds(c, 1:length(c))
    checkbounds(d, 1:length(d))
    checkbounds(e, 1:length(e))

    s = 0.0
    @aliasscope for i in 1:length(a)
        a[i] = s * Const(e)[i]
        s = Const(b)[i] + Const(c)[i]
        b[i] = a[i] + Const(d)[i]
    end
    return nothing
end

function s2251_inbounds(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(b))
    checkbounds(c, 1:length(c))
    checkbounds(d, 1:length(d))
    checkbounds(e, 1:length(e))

    s = 0.0
    @inbounds for i in 1:length(a)
        a[i] = s * e[i]
        s = b[i] + c[i]
        b[i] = a[i] + d[i]
    end
    return nothing
end

function s2251_inbounds_const(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(b))
    checkbounds(c, 1:length(c))
    checkbounds(d, 1:length(d))
    checkbounds(e, 1:length(e))

    s = 0.0
    @aliasscope @inbounds for i in 1:length(a)
        a[i] = s * Const(e)[i]
        s = Const(b)[i] + Const(c)[i]
        b[i] = a[i] + Const(d)[i]
    end
    return nothing
end

# s3251 - scalar and array expansion, scalar expansion
function s3251(a::AbstractArray, b::AbstractArray, c::AbstractArray, d::AbstractArray, e::AbstractArray)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a)-1)
    checkbounds(c, 1:length(a)-1)
    checkbounds(d, 1:length(a)-1)
    checkbounds(e, 1:length(a)-1)
    for i in 1:length(a)-1
        a[i+1] = b[i]+c[i]
        b[i]   = c[i]*e[i]
        d[i]   = a[i]*e[i]
    end
    return nothing
end

function s3251_const(a::AbstractArray, b::AbstractArray, c::AbstractArray, d::AbstractArray, e::AbstractArray)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a)-1)
    checkbounds(c, 1:length(a)-1)
    checkbounds(d, 1:length(a)-1)
    checkbounds(e, 1:length(a)-1)
    @aliasscope for i in 1:length(a)-1
        a[i+1] = b[i] + Const(c)[i]
        b[i]   = Const(c)[i] * Const(e)[i]
        d[i]   = a[i] * Const(e)[i]
    end
    return nothing
end

function s3251_inbounds(a::AbstractArray, b::AbstractArray, c::AbstractArray, d::AbstractArray, e::AbstractArray)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a)-1)
    checkbounds(c, 1:length(a)-1)
    checkbounds(d, 1:length(a)-1)
    checkbounds(e, 1:length(a)-1)
    @inbounds for i in 1:length(a)-1
        a[i+1] = b[i]+c[i]
        b[i]   = c[i]*e[i]
        d[i]   = a[i]*e[i]
    end
    return nothing
end

function s3251_inbounds_const(a::AbstractArray, b::AbstractArray, c::AbstractArray, d::AbstractArray, e::AbstractArray)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a)-1)
    checkbounds(c, 1:length(a)-1)
    checkbounds(d, 1:length(a)-1)
    checkbounds(e, 1:length(a)-1)
    @aliasscope @inbounds for i in 1:length(a)-1
        a[i+1] = b[i] + Const(c)[i]
        b[i]   = Const(c)[i] * Const(e)[i]
        d[i]   = a[i] * Const(e)[i]
    end
    return nothing
end

# s252 - scalar and array expansion, loop with ambiguous scalar temporary
function s252(a::AbstractArray, b::AbstractArray, c::AbstractArray)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    t = 0.0
    for i in 1:length(a)
        s = b[i] * c[i]
        a[i] = s + t
        t = s
    end
    return nothing
end

function s252_const(a::AbstractArray, b::AbstractArray, c::AbstractArray)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    t = 0.0
    @aliasscope for i in 1:length(a)
        s = Const(b)[i] * Const(c)[i]
        a[i] = s + t
        t = s
    end
    return nothing
end

function s252_inbounds(a::AbstractArray, b::AbstractArray, c::AbstractArray)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    t = 0.0
    @inbounds for i in 1:length(a)
        s = b[i] * c[i]
        a[i] = s + t
        t = s
    end
    return nothing
end

function s252_inbounds_const(a::AbstractArray, b::AbstractArray, c::AbstractArray)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    t = 0.0
    @aliasscope @inbounds for i in 1:length(a)
        s = Const(b)[i] * Const(c)[i]
        a[i] = s + t
        t = s
    end
    return nothing
end

# s253 - scalar and array expansion, scalar expansion assigned under if
function s253(a::AbstractArray, b::AbstractArray, c::AbstractArray, d::AbstractArray)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    checkbounds(d, 1:length(a))
    for i in 1:length(a)
        if a[i] > b[i]
            s = a[i] - b[i] * d[i]
            c[i] += s
            a[i] = s
        end
    end
    return nothing
end

function s253_const(a::AbstractArray, b::AbstractArray, c::AbstractArray, d::AbstractArray)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    checkbounds(d, 1:length(a))
    @aliasscope for i in 1:length(a)
        if a[i] > Const(b)[i]
            s = a[i] - Const(b)[i] * Const(d)[i]
            c[i] += s
            a[i] = s
        end
    end
    return nothing
end

function s253_inbounds(a::AbstractArray, b::AbstractArray, c::AbstractArray, d::AbstractArray)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    checkbounds(d, 1:length(a))
    @inbounds for i in 1:length(a)
        if a[i] > b[i]
            s = a[i] - b[i] * d[i]
            c[i] += s
            a[i] = s
        end
    end
    return nothing
end

function s253_inbounds_const(a::AbstractArray, b::AbstractArray, c::AbstractArray, d::AbstractArray)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    checkbounds(d, 1:length(a))
    @aliasscope @inbounds for i in 1:length(a)
        if a[i] > Const(b)[i]
            s = a[i] - Const(b)[i] * Const(d)[i]
            c[i] += s
            a[i] = s
        end
    end
    return nothing
end

# s254 - scalar and array expansion, carry around variable
function s254(a::AbstractArray, b::AbstractArray)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    x = b[length(a)]
    for i in 1:length(a)
        a[i] = (b[i] + x) * 0.5
        x = b[i]
    end
    return nothing
end

function s254_const(a::AbstractArray, b::AbstractArray)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    x = b[length(a)]
    @aliasscope for i in 1:length(a)
        a[i] = (Const(b)[i] + x) * 0.5
        x = Const(b)[i]
    end
    return nothing
end

function s254_inbounds(a::AbstractVector, b::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(b))
    x = b[end]
    @inbounds for i in 1:length(a)
        a[i] = (b[i] + x) * 0.5
        x = b[i]
    end
    return nothing
end

function s254_inbounds_const(a::AbstractVector, b::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(b))
    x = Const(b)[end]
    @aliasscope @inbounds for i in 1:length(a)
        a[i] = (Const(b)[i] + x) * 0.5
        x = Const(b)[i]
    end
    return nothing
end

# s255 - scalar and array expansion, carry around variables, 2 levels
function s255(a::AbstractArray, b::AbstractArray)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    x = b[length(a)]
    y = b[length(a)-1]
    for i in 1:length(a)
        a[i] = (b[i] + x + y) * 0.333
        y = x
        x = b[i]
    end
    return nothing
end

function s255_const(a::AbstractArray, b::AbstractArray)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    x = b[length(a)]
    y = b[length(a)-1]
    @aliasscope for i in 1:length(a)
        a[i] = (Const(b)[i] + x + y) * 0.333
        y = x
        x = Const(b)[i]
    end
    return nothing
end

function s255_inbounds(a::AbstractArray, b::AbstractArray)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    @inbounds x = b[length(a)]
    @inbounds y = b[length(a)-1]
    @inbounds for i in 1:length(a)
        a[i] = (b[i] + x + y) * 0.333
        y = x
        x = b[i]
    end
    return nothing
end

function s255_inbounds_const(a::AbstractArray, b::AbstractArray)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    @inbounds x = b[length(a)]
    @inbounds y = b[length(a)-1]
    @aliasscope @inbounds for i in 1:length(a)
        a[i] = (Const(b)[i] + x + y) * 0.333
        y = x
        x = Const(b)[i]
    end
    return nothing
end

# s256 - scalar and array expansion, array expansion
function s256(a::AbstractVector, aa::AbstractMatrix, bb::AbstractMatrix, d::AbstractVector)
    m, n = size(aa)
    @assert length(a) == m "length(a) must equal first dimension of aa"
    @assert size(bb) == size(aa) "bb must be same size as aa"
    @assert length(d) == m "length(d) must equal first dimension of aa"
    checkbounds(a, 1:m)
    checkbounds(aa, 1:m, 1:n)
    checkbounds(bb, 1:m, 1:n)
    checkbounds(d, 1:m)
    for i in 1:n
        for j in 2:m
            a[j] = 1.0 - a[j-1]
            aa[j, i] = a[j] + bb[j, i] * d[j]
        end
    end
    return nothing
end

function s256_const(a::AbstractVector, aa::AbstractMatrix, bb::AbstractMatrix, d::AbstractVector)
    m, n = size(aa)
    @assert length(a) == m && size(bb) == size(aa) && length(d) == m
    checkbounds(a, 1:m)
    checkbounds(aa, 1:m, 1:n)
    checkbounds(bb, 1:m, 1:n)
    checkbounds(d, 1:m)
    @aliasscope for i in 1:n
        for j in 2:m
            a[j] = 1.0 - a[j-1]
            aa[j, i] = a[j] + Const(bb)[j, i] * Const(d)[j]
        end
    end
    return nothing
end

function s256_inbounds(a::AbstractVector, aa::AbstractMatrix, bb::AbstractMatrix, d::AbstractVector)
    m, n = size(aa)
    @assert length(a) == m && size(bb) == size(aa) && length(d) == m
    checkbounds(a, 1:m)
    checkbounds(aa, 1:m, 1:n)
    checkbounds(bb, 1:m, 1:n)
    checkbounds(d, 1:m)
    @inbounds for i in 1:n
        for j in 2:m
            a[j] = 1.0 - a[j-1]
            aa[j, i] = a[j] + bb[j, i] * d[j]
        end
    end
    return nothing
end

function s256_inbounds_const(a::AbstractVector, aa::AbstractMatrix, bb::AbstractMatrix, d::AbstractVector)
    m, n = size(aa)
    @assert length(a) == m && size(bb) == size(aa) && length(d) == m
    checkbounds(a, 1:m)
    checkbounds(aa, 1:m, 1:n)
    checkbounds(bb, 1:m, 1:n)
    checkbounds(d, 1:m)
    @aliasscope @inbounds for i in 1:n
        for j in 2:m
            a[j] = 1.0 - a[j-1]
            aa[j, i] = a[j] + Const(bb)[j, i] * Const(d)[j]
        end
    end
    return nothing
end

# s257 - scalar and array expansion, array expansion
function s257(a::AbstractVector, aa::AbstractMatrix, bb::AbstractMatrix)
    m, n = size(aa)
    @assert length(a) == n "length(a) must equal number of columns of aa"
    @assert size(bb) == size(aa) "bb must be same size as aa"
    checkbounds(a, 1:n)
    checkbounds(aa, 1:m, 1:n)
    checkbounds(bb, 1:m, 1:n)
    for i in 2:n
        for j in 1:m
            a[i] = aa[j, i] - a[i-1]
            aa[j, i] = a[i] + bb[j, i]
        end
    end
    return nothing
end

function s257_const(a::AbstractVector, aa::AbstractMatrix, bb::AbstractMatrix)
    m, n = size(aa)
    @assert length(a) == n && size(bb) == size(aa)
    checkbounds(a, 1:n)
    checkbounds(aa, 1:m, 1:n)
    checkbounds(bb, 1:m, 1:n)
    @aliasscope for i in 2:n
        for j in 1:m
            a[i] = aa[j, i] - a[i-1]
            aa[j, i] = a[i] + Const(bb)[j, i]
        end
    end
    return nothing
end

function s257_inbounds(a::AbstractVector, aa::AbstractMatrix, bb::AbstractMatrix)
    m, n = size(aa)
    @assert length(a) == n && size(bb) == size(aa)
    checkbounds(a, 1:n)
    checkbounds(aa, 1:m, 1:n)
    checkbounds(bb, 1:m, 1:n)
    @inbounds for i in 2:n
        for j in 1:m
            a[i] = aa[j, i] - a[i-1]
            aa[j, i] = a[i] + bb[j, i]
        end
    end
    return nothing
end

function s257_inbounds_const(a::AbstractVector, aa::AbstractMatrix, bb::AbstractMatrix)
    m, n = size(aa)
    @assert length(a) == n && size(bb) == size(aa)
    checkbounds(a, 1:n)
    checkbounds(aa, 1:m, 1:n)
    checkbounds(bb, 1:m, 1:n)
    @aliasscope @inbounds for i in 2:n
        for j in 1:m
            a[i] = aa[j, i] - a[i-1]
            aa[j, i] = a[i] + Const(bb)[j, i]
        end
    end
    return nothing
end

# s258 - scalar and array expansion, wrap-around scalar under an if
function s258(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector, aa::AbstractMatrix)
    n = length(a)
    @assert length(b)==n && length(c)==n && length(d)==n && length(e)==n "all vectors must have same length"
    @assert size(aa, 2) >= n "aa must have at least n columns"
    checkbounds(a, 1:n)
    checkbounds(b, 1:n)
    checkbounds(c, 1:n)
    checkbounds(d, 1:n)
    checkbounds(e, 1:n)
    checkbounds(aa, 1, 1:n)
    s = 0.0
    for i in 1:n
        if a[i] > 0.0
            s = d[i] * d[i]
        end
        b[i] = s * c[i] + d[i]
        e[i] = (s + 1.0) * aa[1, i]
    end
    return nothing
end

function s258_const(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector, aa::AbstractMatrix)
    n = length(a)
    @assert length(b)==n && length(c)==n && length(d)==n && length(e)==n && size(aa,2) >= n
    checkbounds(a, 1:n)
    checkbounds(b, 1:n)
    checkbounds(c, 1:n)
    checkbounds(d, 1:n)
    checkbounds(e, 1:n)
    checkbounds(aa, 1, 1:n)
    s = 0.0
    @aliasscope for i in 1:n
        if Const(a)[i] > 0.0
            s = Const(d)[i] * Const(d)[i]
        end
        b[i] = s * Const(c)[i] + Const(d)[i]
        e[i] = (s + 1.0) * Const(aa)[1, i]
    end
    return nothing
end

function s258_inbounds(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector, aa::AbstractMatrix)
    n = length(a)
    @assert length(b)==n && length(c)==n && length(d)==n && length(e)==n && size(aa,2) >= n
    checkbounds(a, 1:n)
    checkbounds(b, 1:n)
    checkbounds(c, 1:n)
    checkbounds(d, 1:n)
    checkbounds(e, 1:n)
    checkbounds(aa, 1, 1:n)
    s = 0.0
    @inbounds for i in 1:n
        if a[i] > 0.0
            s = d[i] * d[i]
        end
        b[i] = s * c[i] + d[i]
        e[i] = (s + 1.0) * aa[1, i]
    end
    return nothing
end

function s258_inbounds_const(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector, aa::AbstractMatrix)
    n = length(a)
    @assert length(b)==n && length(c)==n && length(d)==n && length(e)==n && size(aa,2) >= n
    checkbounds(a, 1:n)
    checkbounds(b, 1:n)
    checkbounds(c, 1:n)
    checkbounds(d, 1:n)
    checkbounds(e, 1:n)
    checkbounds(aa, 1, 1:n)
    s = 0.0
    @aliasscope @inbounds for i in 1:n
        if Const(a)[i] > 0.0
            s = Const(d)[i] * Const(d)[i]
        end
        b[i] = s * Const(c)[i] + Const(d)[i]
        e[i] = (s + 1.0) * Const(aa)[1, i]
    end
    return nothing
end

# s261 - scalar and array expansion, wrap-around scalar under an if
function s261(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector)
    n = length(a)
    @assert length(b)==n && length(c)==n && length(d)==n
    checkbounds(a, 2:n)
    checkbounds(b, 2:n)
    checkbounds(c, 1:n-1)
    checkbounds(d, 2:n)
    for i in 2:n
        t = a[i] + b[i]
        a[i] = t + c[i-1]
        t = c[i] * d[i]
        c[i] = t
    end
    return nothing
end

function s261_const(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector)
    n = length(a)
    @assert length(b)==n && length(c)==n && length(d)==n
    checkbounds(a, 2:n)
    checkbounds(b, 2:n)
    checkbounds(c, 1:n-1)
    checkbounds(d, 2:n)
    @aliasscope for i in 2:n
        t = a[i] + Const(b)[i]
        a[i] = t + c[i-1]
        t = c[i] * Const(d)[i]
        c[i] = t
    end
    return nothing
end

function s261_inbounds(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector)
    n = length(a)
    @assert length(b)==n && length(c)==n && length(d)==n
    checkbounds(a, 2:n)
    checkbounds(b, 2:n)
    checkbounds(c, 1:n-1)
    checkbounds(d, 2:n)
    @inbounds for i in 2:n
        t = a[i] + b[i]
        a[i] = t + c[i-1]
        t = c[i] * d[i]
        c[i] = t
    end
    return nothing
end

function s261_inbounds_const(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector)
    n = length(a)
    @assert length(b)==n && length(c)==n && length(d)==n
    checkbounds(a, 2:n)
    checkbounds(b, 2:n)
    checkbounds(c, 1:n-1)
    checkbounds(d, 2:n)
    @aliasscope @inbounds for i in 2:n
        t = a[i] + Const(b)[i]
        a[i] = t + c[i-1]
        t = c[i] * Const(d)[i]
        c[i] = t
    end
    return nothing
end

# s271 - loop with singularity handling
function s271(a::AbstractVector, b::AbstractVector, c::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    for i in 1:length(a)
        if b[i] > 0.0
            a[i] += b[i] * c[i]
        end
    end
    return nothing
end

function s271_const(a::AbstractVector, b::AbstractVector, c::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    @aliasscope for i in 1:length(a)
        if Const(b)[i] > 0.0
            a[i] += Const(b)[i] * Const(c)[i]
        end
    end
    return nothing
end

function s271_inbounds(a::AbstractVector, b::AbstractVector, c::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    @inbounds for i in 1:length(a)
        if b[i] > 0.0
            a[i] += b[i] * c[i]
        end
    end
    return nothing
end

function s271_inbounds_const(a::AbstractVector, b::AbstractVector, c::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    @aliasscope @inbounds for i in 1:length(a)
        if Const(b)[i] > 0.0
            a[i] += Const(b)[i] * Const(c)[i]
        end
    end
    return nothing
end

# s272 - loop with independent conditional
function s272(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector, t::Number)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    checkbounds(d, 1:length(a))
    checkbounds(e, 1:length(a))
    for i in 1:length(a)
        if e[i] >= t
            a[i] += c[i] * d[i]
            b[i] += c[i] * c[i]
        end
    end
    return nothing
end

function s272_const(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector, t::Number)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    checkbounds(d, 1:length(a))
    checkbounds(e, 1:length(a))
    @aliasscope for i in 1:length(a)
        if Const(e)[i] >= t
            a[i] += Const(c)[i] * Const(d)[i]
            b[i] += Const(c)[i] * Const(c)[i]
        end
    end
    return nothing
end

function s272_inbounds(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector, t::Number)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    checkbounds(d, 1:length(a))
    checkbounds(e, 1:length(a))
    @inbounds for i in 1:length(a)
        if e[i] >= t
            a[i] += c[i] * d[i]
            b[i] += c[i] * c[i]
        end
    end
    return nothing
end

function s272_inbounds_const(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector, t::Number)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    checkbounds(d, 1:length(a))
    checkbounds(e, 1:length(a))
    @aliasscope @inbounds for i in 1:length(a)
        if Const(e)[i] >= t
            a[i] += Const(c)[i] * Const(d)[i]
            b[i] += Const(c)[i] * Const(c)[i]
        end
    end
    return nothing
end

# s273 - simple loop with dependent conditional
function s273(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    checkbounds(d, 1:length(a))
    checkbounds(e, 1:length(a))
    for i in 1:length(a)
        a[i] += d[i] * e[i]
        if a[i] < 0.0
            b[i] += d[i] * e[i]
        end
        c[i] += a[i] * d[i]
    end
    return nothing
end

function s273_const(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    checkbounds(d, 1:length(a))
    checkbounds(e, 1:length(a))
    @aliasscope for i in 1:length(a)
        a[i] += Const(d)[i] * Const(e)[i]
        if a[i] < 0.0
            b[i] += Const(d)[i] * Const(e)[i]
        end
        c[i] += a[i] * Const(d)[i]
    end
    return nothing
end

function s273_inbounds(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    checkbounds(d, 1:length(a))
    checkbounds(e, 1:length(a))
    @inbounds for i in 1:length(a)
        a[i] += d[i] * e[i]
        if a[i] < 0.0
            b[i] += d[i] * e[i]
        end
        c[i] += a[i] * d[i]
    end
    return nothing
end

function s273_inbounds_const(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    checkbounds(d, 1:length(a))
    checkbounds(e, 1:length(a))
    @aliasscope @inbounds for i in 1:length(a)
        a[i] += Const(d)[i] * Const(e)[i]
        if a[i] < 0.0
            b[i] += Const(d)[i] * Const(e)[i]
        end
        c[i] += a[i] * Const(d)[i]
    end
    return nothing
end

# s274 - complex loop with dependent conditional
function s274(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    checkbounds(d, 1:length(a))
    checkbounds(e, 1:length(a))
    for i in 1:length(a)
        a[i] = c[i] + e[i] * d[i]
        if a[i] > 0.0
            b[i] = a[i] + b[i]
        else
            a[i] = d[i] * e[i]
        end
    end
    return nothing
end

function s274_const(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    checkbounds(d, 1:length(a))
    checkbounds(e, 1:length(a))
    @aliasscope for i in 1:length(a)
        a[i] = Const(c)[i] + Const(e)[i] * Const(d)[i]
        if a[i] > 0.0
            b[i] = a[i] + Const(b)[i]
        else
            a[i] = Const(d)[i] * Const(e)[i]
        end
    end
    return nothing
end

function s274_inbounds(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    checkbounds(d, 1:length(a))
    checkbounds(e, 1:length(a))
    @inbounds for i in 1:length(a)
        a[i] = c[i] + e[i] * d[i]
        if a[i] > 0.0
            b[i] = a[i] + b[i]
        else
            a[i] = d[i] * e[i]
        end
    end
    return nothing
end

function s274_inbounds_const(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    checkbounds(d, 1:length(a))
    checkbounds(e, 1:length(a))
    @aliasscope @inbounds for i in 1:length(a)
        a[i] = Const(c)[i] + Const(e)[i] * Const(d)[i]
        if a[i] > 0.0
            b[i] = a[i] + Const(b)[i]
        else
            a[i] = Const(d)[i] * Const(e)[i]
        end
    end
    return nothing
end
