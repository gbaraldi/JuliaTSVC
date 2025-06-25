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

# s275 - if around inner loop, interchanging needed
function s275(aa::AbstractMatrix, bb::AbstractMatrix, cc::AbstractMatrix)
    checkbounds(aa, 1:size(aa, 1), 1:size(aa, 2))
    checkbounds(bb, 2:size(aa, 1), 1:size(aa, 2))
    checkbounds(cc, 2:size(aa, 1), 1:size(aa, 2))
    for i in 1:size(aa, 2)
        if aa[1, i] > 0.0
            for j in 2:size(aa, 1)
                aa[j, i] = aa[j-1, i] + bb[j, i] * cc[j, i]
            end
        end
    end
    return nothing
end

function s275_const(aa::AbstractMatrix, bb::AbstractMatrix, cc::AbstractMatrix)
    checkbounds(aa, 1:size(aa, 1), 1:size(aa, 2))
    checkbounds(bb, 2:size(aa, 1), 1:size(aa, 2))
    checkbounds(cc, 2:size(aa, 1), 1:size(aa, 2))
    @aliasscope for i in 1:size(aa, 2)
        if aa[1, i] > 0.0
            for j in 2:size(aa, 1)
                aa[j, i] = aa[j-1, i] + Const(bb)[j, i] * Const(cc)[j, i]
            end
        end
    end
    return nothing
end

function s275_inbounds(aa::AbstractMatrix, bb::AbstractMatrix, cc::AbstractMatrix)
    checkbounds(aa, 1:size(aa, 1), 1:size(aa, 2))
    checkbounds(bb, 2:size(aa, 1), 1:size(aa, 2))
    checkbounds(cc, 2:size(aa, 1), 1:size(aa, 2))
    for i in 1:size(aa, 2)
        if aa[1, i] > 0.0
            @inbounds for j in 2:size(aa, 1)
                aa[j, i] = aa[j-1, i] + bb[j, i] * cc[j, i]
            end
        end
    end
    return nothing
end


# TODO: This is miscompiling
# function s275_inbounds_const(aa::AbstractMatrix, bb::AbstractMatrix, cc::AbstractMatrix)
#     checkbounds(aa, 1:size(aa, 1), 1:size(aa, 2))
#     checkbounds(bb, 2:size(aa, 1), 1:size(aa, 2))
#     checkbounds(cc, 2:size(aa, 1), 1:size(aa, 2))
#     @aliasscope for i in 1:size(aa, 2)
#         if aa[1, i] > 0.0
#              @inbounds for j in 2:size(aa, 1)
#                 aa[j, i] = aa[j-1, i] + bb[j, i] * cc[j, i]
#             end
#         end
#     end
#     return nothing
# end


# s2275 - loop with if evaluation of loop variant condition
function s2275(aa::AbstractMatrix, bb::AbstractMatrix, cc::AbstractMatrix)
    checkbounds(aa, 1:size(aa, 1), 1:size(aa, 2))
    checkbounds(bb, 2:size(aa, 1), 1:size(aa, 2))
    checkbounds(cc, 2:size(aa, 1), 1:size(aa, 2))
    for i in 1:size(aa, 2)
        if aa[1, i] > 0.0
            for j in 2:size(aa, 1)
                aa[j, i] = aa[j-1, i] + bb[j, i] * cc[j, i]
            end
        else
            for j in 2:size(aa, 1)
                aa[j, i] = aa[j-1, i] + bb[j, i] * bb[j, i]
            end
        end
    end
    return nothing
end

function s2275_const(aa::AbstractMatrix, bb::AbstractMatrix, cc::AbstractMatrix)
    checkbounds(aa, 1:size(aa, 1), 1:size(aa, 2))
    checkbounds(bb, 2:size(aa, 1), 1:size(aa, 2))
    checkbounds(cc, 2:size(aa, 1), 1:size(aa, 2))
    @aliasscope for i in 1:size(aa, 2)
        if aa[1, i] > 0.0
            for j in 2:size(aa, 1)
                aa[j, i] = aa[j-1, i] + Const(bb)[j, i] * Const(cc)[j, i]
            end
        else
            for j in 2:size(aa, 1)
                aa[j, i] = aa[j-1, i] + Const(bb)[j, i] * Const(bb)[j, i]
            end
        end
    end
    return nothing
end

function s2275_inbounds(aa::AbstractMatrix, bb::AbstractMatrix, cc::AbstractMatrix)
    checkbounds(aa, 1:size(aa, 1), 1:size(aa, 2))
    checkbounds(bb, 2:size(aa, 1), 1:size(aa, 2))
    checkbounds(cc, 2:size(aa, 1), 1:size(aa, 2))
    @inbounds for i in 1:size(aa, 2)
        if aa[1, i] > 0.0
            for j in 2:size(aa, 1)
                aa[j, i] = aa[j-1, i] + bb[j, i] * cc[j, i]
            end
        else
            for j in 2:size(aa, 1)
                aa[j, i] = aa[j-1, i] + bb[j, i] * bb[j, i]
            end
        end
    end
    return nothing
end

# TODO: This is miscompiling
# function s2275_inbounds_const(aa::AbstractMatrix, bb::AbstractMatrix, cc::AbstractMatrix)
#     checkbounds(aa, 1:size(aa, 1), 1:size(aa, 2))
#     checkbounds(bb, 2:size(aa, 1), 1:size(aa, 2))
#     checkbounds(cc, 2:size(aa, 1), 1:size(aa, 2))
#     @aliasscope @inbounds for i in 1:size(aa, 2)
#         if aa[1, i] > 0.0
#             for j in 2:size(aa, 1)
#                 aa[j, i] = aa[j-1, i] + Const(bb)[j, i] * Const(cc)[j, i]
#             end
#         else
#             for j in 2:size(aa, 1)
#                 aa[j, i] = aa[j-1, i] + Const(bb)[j, i] * Const(bb)[j, i]
#             end
#         end
#     end
#     return nothing
# end

# s276 - control flow, if test using loop index
function s276(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    checkbounds(d, 1:length(a))
    mid = div(length(a), 2)
    for i in 1:length(a)
        if i < mid
            a[i] += b[i] * c[i]
        else
            a[i] += b[i] * d[i]
        end
    end
    return nothing
end

function s276_const(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    checkbounds(d, 1:length(a))
    mid = div(length(a), 2)
    @aliasscope for i in 1:length(a)
        if i < mid
            a[i] += Const(b)[i] * Const(c)[i]
        else
            a[i] += Const(b)[i] * Const(d)[i]
        end
    end
    return nothing
end

function s276_inbounds(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    checkbounds(d, 1:length(a))
    mid = div(length(a), 2)
    @inbounds for i in 1:length(a)
        if i < mid
            a[i] += b[i] * c[i]
        else
            a[i] += b[i] * d[i]
        end
    end
    return nothing
end

function s276_inbounds_const(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    checkbounds(d, 1:length(a))
    mid = div(length(a), 2)
    @aliasscope @inbounds for i in 1:length(a)
        if i < mid
            a[i] += Const(b)[i] * Const(c)[i]
        else
            a[i] += Const(b)[i] * Const(d)[i]
        end
    end
    return nothing
end

# s277 - control flow, test for dependences arising from guard variable computation
function s277(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector)
    checkbounds(a, 1:length(a)-1)
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a)-1)
    checkbounds(d, 1:length(a)-1)
    checkbounds(e, 1:length(a)-1)
    for i in 1:length(a)-1
        if a[i] < 0.0
            if b[i] < 0.0
                a[i] += c[i] * d[i]
            end
            b[i+1] = c[i] + d[i] * e[i]
        end
    end
    return nothing
end

function s277_const(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector)
    checkbounds(a, 1:length(a)-1)
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a)-1)
    checkbounds(d, 1:length(a)-1)
    checkbounds(e, 1:length(a)-1)
    @aliasscope for i in 1:length(a)-1
        if a[i] < 0.0
            if b[i] < 0.0
                a[i] += Const(c)[i] * Const(d)[i]
            end
            b[i+1] = Const(c)[i] + Const(d)[i] * Const(e)[i]
        end
    end
    return nothing
end

function s277_inbounds(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector)
    checkbounds(a, 1:length(a)-1)
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a)-1)
    checkbounds(d, 1:length(a)-1)
    checkbounds(e, 1:length(a)-1)
    @inbounds for i in 1:length(a)-1
        if a[i] < 0.0
            if b[i] < 0.0
                a[i] += c[i] * d[i]
            end
            b[i+1] = c[i] + d[i] * e[i]
        end
    end
    return nothing
end

function s277_inbounds_const(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector)
    checkbounds(a, 1:length(a)-1)
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a)-1)
    checkbounds(d, 1:length(a)-1)
    checkbounds(e, 1:length(a)-1)
    @aliasscope @inbounds for i in 1:length(a)-1
        if a[i] < 0.0
            if b[i] < 0.0
                a[i] += Const(c)[i] * Const(d)[i]
            end
            b[i+1] = Const(c)[i] + Const(d)[i] * Const(e)[i]
        end
    end
    return nothing
end

# s278 - control flow, if/goto to block if-then-else
function s278(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    checkbounds(d, 1:length(a))
    checkbounds(e, 1:length(a))
    for i in 1:length(a)
        if a[i] > 0.0
            c[i] = -c[i] + d[i] * e[i]
        else
            b[i] = -b[i] + d[i] * e[i]
        end
        a[i] = b[i] + c[i] * d[i]
    end
    return nothing
end

function s278_const(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    checkbounds(d, 1:length(a))
    checkbounds(e, 1:length(a))
    @aliasscope for i in 1:length(a)
        if a[i] > 0.0
            c[i] = -c[i] + Const(d)[i] * Const(e)[i]
        else
            b[i] = -b[i] + Const(d)[i] * Const(e)[i]
        end
        a[i] = b[i] + c[i] * Const(d)[i]
    end
    return nothing
end

function s278_inbounds(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    checkbounds(d, 1:length(a))
    checkbounds(e, 1:length(a))
    @inbounds for i in 1:length(a)
        if a[i] > 0.0
            c[i] = -c[i] + d[i] * e[i]
        else
            b[i] = -b[i] + d[i] * e[i]
        end
        a[i] = b[i] + c[i] * d[i]
    end
    return nothing
end

function s278_inbounds_const(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    checkbounds(d, 1:length(a))
    checkbounds(e, 1:length(a))
    @aliasscope @inbounds for i in 1:length(a)
        if a[i] > 0.0
            c[i] = -c[i] + Const(d)[i] * Const(e)[i]
        else
            b[i] = -b[i] + Const(d)[i] * Const(e)[i]
        end
        a[i] = b[i] + c[i] * Const(d)[i]
    end
    return nothing
end

# s279 - control flow, vector dependence testing
function s279(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    checkbounds(d, 1:length(a))
    checkbounds(e, 1:length(a))
    for i in 1:length(a)
        if c[i] > 0.0
            a[i] = b[i] + d[i] * d[i]
        else
            a[i] = b[i] + e[i] * e[i]
        end
    end
    return nothing
end

function s279_const(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    checkbounds(d, 1:length(a))
    checkbounds(e, 1:length(a))
    @aliasscope for i in 1:length(a)
        if Const(c)[i] > 0.0
            a[i] = Const(b)[i] + Const(d)[i] * Const(d)[i]
        else
            a[i] = Const(b)[i] + Const(e)[i] * Const(e)[i]
        end
    end
    return nothing
end

function s279_inbounds(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    checkbounds(d, 1:length(a))
    checkbounds(e, 1:length(a))
    @inbounds for i in 1:length(a)
        if c[i] > 0.0
            a[i] = b[i] + d[i] * d[i]
        else
            a[i] = b[i] + e[i] * e[i]
        end
    end
    return nothing
end

function s279_inbounds_const(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    checkbounds(d, 1:length(a))
    checkbounds(e, 1:length(a))
    @aliasscope @inbounds for i in 1:length(a)
        if Const(c)[i] > 0.0
            a[i] = Const(b)[i] + Const(d)[i] * Const(d)[i]
        else
            a[i] = Const(b)[i] + Const(e)[i] * Const(e)[i]
        end
    end
    return nothing
end

# s1279 - control flow, vector if/gotos
function s1279(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    checkbounds(d, 1:length(a))
    checkbounds(e, 1:length(a))
    for i in 1:length(a)
        if a[i] < 0.0
            if b[i] > a[i]
                c[i] += d[i] * e[i]
            end
        end
    end
    return nothing
end

function s1279_const(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    checkbounds(d, 1:length(a))
    checkbounds(e, 1:length(a))
    @aliasscope for i in 1:length(a)
        if Const(a)[i] < 0.0
            if Const(b)[i] > Const(a)[i]
                c[i] += Const(d)[i] * Const(e)[i]
            end
        end
    end
    return nothing
end

function s1279_inbounds(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    checkbounds(d, 1:length(a))
    checkbounds(e, 1:length(a))
    @inbounds for i in 1:length(a)
        if a[i] < 0.0
            if b[i] > a[i]
                c[i] += d[i] * e[i]
            end
        end
    end
    return nothing
end

function s1279_inbounds_const(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    checkbounds(d, 1:length(a))
    checkbounds(e, 1:length(a))
    @aliasscope @inbounds for i in 1:length(a)
        if Const(a)[i] < 0.0
            if Const(b)[i] > Const(a)[i]
                c[i] += Const(d)[i] * Const(e)[i]
            end
        end
    end
    return nothing
end

# s2710 - control flow, scalar and vector ifs
function s2710(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector, x::Int)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    checkbounds(d, 1:length(a))
    checkbounds(e, 1:length(a))
    for i in 1:length(a)
        if a[i] > b[i]
            a[i] += b[i] * d[i]
            if length(a) > 10
                c[i] += d[i] * d[i]
            else
                c[i] = d[i] * e[i] + 1.0
            end
        else
            b[i] = a[i] + e[i] * e[i]
            if x > 0
                c[i] = a[i] + d[i] * d[i]
            else
                c[i] += e[i] * e[i]
            end
        end
    end
    return nothing
end

function s2710_const(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector, x::Int)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    checkbounds(d, 1:length(a))
    checkbounds(e, 1:length(a))
    @aliasscope for i in 1:length(a)
        if a[i] > b[i]
            a[i] += b[i] * Const(d)[i]
            if length(a) > 10
                c[i] += Const(d)[i] * Const(d)[i]
            else
                c[i] = Const(d)[i] * Const(e)[i] + 1.0
            end
        else
            b[i] = a[i] + Const(e)[i] * Const(e)[i]
            if x > 0
                c[i] = a[i] + Const(d)[i] * Const(d)[i]
            else
                c[i] += Const(e)[i] * Const(e)[i]
            end
        end
    end
    return nothing
end

function s2710_inbounds(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector, x::Int)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    checkbounds(d, 1:length(a))
    checkbounds(e, 1:length(a))
    @inbounds for i in 1:length(a)
        if a[i] > b[i]
            a[i] += b[i] * d[i]
            if length(a) > 10
                c[i] += d[i] * d[i]
            else
                c[i] = d[i] * e[i] + 1.0
            end
        else
            b[i] = a[i] + e[i] * e[i]
            if x > 0
                c[i] = a[i] + d[i] * d[i]
            else
                c[i] += e[i] * e[i]
            end
        end
    end
    return nothing
end

function s2710_inbounds_const(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector, x::Int)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    checkbounds(d, 1:length(a))
    checkbounds(e, 1:length(a))
    @aliasscope @inbounds for i in 1:length(a)
        if a[i] > b[i]
            a[i] += b[i] * Const(d)[i]
            if length(a) > 10
                c[i] += Const(d)[i] * Const(d)[i]
            else
                c[i] = Const(d)[i] * Const(e)[i] + 1.0
            end
        else
            b[i] = a[i] + Const(e)[i] * Const(e)[i]
            if x > 0
                c[i] = a[i] + Const(d)[i] * Const(d)[i]
            else
                c[i] += Const(e)[i] * Const(e)[i]
            end
        end
    end
    return nothing
end

# s2711 - control flow, semantic if removal
function s2711(a::AbstractVector, b::AbstractVector, c::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    for i in 1:length(a)
        if b[i] != 0.0
            a[i] += b[i] * c[i]
        end
    end
    return nothing
end

function s2711_const(a::AbstractVector, b::AbstractVector, c::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    @aliasscope for i in 1:length(a)
        if Const(b)[i] != 0.0
            a[i] += Const(b)[i] * Const(c)[i]
        end
    end
    return nothing
end

function s2711_inbounds(a::AbstractVector, b::AbstractVector, c::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    @inbounds for i in 1:length(a)
        if b[i] != 0.0
            a[i] += b[i] * c[i]
        end
    end
    return nothing
end

function s2711_inbounds_const(a::AbstractVector, b::AbstractVector, c::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    @aliasscope @inbounds for i in 1:length(a)
        if Const(b)[i] != 0.0
            a[i] += Const(b)[i] * Const(c)[i]
        end
    end
    return nothing
end

# s2712 - control flow, if to elemental min
function s2712(a::AbstractVector, b::AbstractVector, c::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    for i in 1:length(a)
        if a[i] > b[i]
            a[i] += b[i] * c[i]
        end
    end
    return nothing
end

function s2712_const(a::AbstractVector, b::AbstractVector, c::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    @aliasscope for i in 1:length(a)
        if a[i] > b[i]
            a[i] += Const(b)[i] * Const(c)[i]
        end
    end
    return nothing
end

function s2712_inbounds(a::AbstractVector, b::AbstractVector, c::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    @inbounds for i in 1:length(a)
        if a[i] > b[i]
            a[i] += b[i] * c[i]
        end
    end
    return nothing
end

function s2712_inbounds_const(a::AbstractVector, b::AbstractVector, c::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    @aliasscope @inbounds for i in 1:length(a)
        if a[i] > b[i]
            a[i] += Const(b)[i] * Const(c)[i]
        end
    end
    return nothing
end

# s281 - crossing thresholds, index set splitting, reverse data access
function s281(a::AbstractVector, b::AbstractVector, c::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    len = length(a)
    for i in 1:len
        x = a[len-i+1] + b[i] * c[i]
        a[i] = x - 1.0
        b[i] = x
    end
    return nothing
end

function s281_const(a::AbstractVector, b::AbstractVector, c::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    len = length(a)
    @aliasscope for i in 1:len
        x = a[len-i+1] + b[i] * Const(c)[i]
        a[i] = x - 1.0
        b[i] = x
    end
    return nothing
end

function s281_inbounds(a::AbstractVector, b::AbstractVector, c::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    len = length(a)
    @inbounds for i in 1:len
        x = a[len-i+1] + b[i] * c[i]
        a[i] = x - 1.0
        b[i] = x
    end
    return nothing
end

function s281_inbounds_const(a::AbstractVector, b::AbstractVector, c::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    len = length(a)
    @aliasscope @inbounds for i in 1:len
        x = a[len-i+1] + b[i] * Const(c)[i]
        a[i] = x - 1.0
        b[i] = x
    end
    return nothing
end

# s1281 - crossing thresholds, index set splitting
function s1281(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    checkbounds(d, 1:length(a))
    checkbounds(e, 1:length(a))
    for i in 1:length(a)
        x = b[i] * c[i] + a[i] * d[i] + e[i]
        a[i] = x - one(eltype(a))
        b[i] = x
    end
    return nothing
end

function s1281_const(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    checkbounds(d, 1:length(a))
    checkbounds(e, 1:length(a))
    @aliasscope for i in 1:length(a)
        x = b[i] * Const(c)[i] + a[i] * Const(d)[i] + Const(e)[i]
        a[i] = x - one(eltype(a))
        b[i] = x
    end
    return nothing
end

function s1281_inbounds(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    checkbounds(d, 1:length(a))
    checkbounds(e, 1:length(a))
    @inbounds for i in 1:length(a)
        x = b[i] * c[i] + a[i] * d[i] + e[i]
        a[i] = x - one(eltype(a))
        b[i] = x
    end
    return nothing
end

function s1281_inbounds_const(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    checkbounds(d, 1:length(a))
    checkbounds(e, 1:length(a))
    @aliasscope @inbounds for i in 1:length(a)
        x = b[i] * Const(c)[i] + a[i] * Const(d)[i] + Const(e)[i]
        a[i] = x - one(eltype(a))
        b[i] = x
    end
    return nothing
end

# s291 - loop peeling, wrap around variable, 1 level
function s291(a::AbstractVector, b::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    len = length(a)
    im1 = len
    for i in 1:len
        a[i] = (b[i] + b[im1]) * 0.5
        im1 = i
    end
    return nothing
end

function s291_const(a::AbstractVector, b::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    len = length(a)
    im1 = len
    @aliasscope for i in 1:len
        a[i] = (Const(b)[i] + Const(b)[im1]) * 0.5
        im1 = i
    end
    return nothing
end

function s291_inbounds(a::AbstractVector, b::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    len = length(a)
    im1 = len
    @inbounds for i in 1:len
        a[i] = (b[i] + b[im1]) * 0.5
        im1 = i
    end
    return nothing
end

function s291_inbounds_const(a::AbstractVector, b::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    len = length(a)
    im1 = len
    @aliasscope @inbounds for i in 1:len
        a[i] = (Const(b)[i] + Const(b)[im1]) * 0.5
        im1 = i
    end
    return nothing
end

# s292 - loop peeling, wrap around variable, 2 levels
function s292(a::AbstractVector, b::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    len = length(a)
    im1 = len
    im2 = len - 1
    for i in 1:len
        a[i] = (b[i] + b[im1] + b[im2]) * 0.333
        im2 = im1
        im1 = i
    end
    return nothing
end

function s292_const(a::AbstractVector, b::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    len = length(a)
    im1 = len
    im2 = len - 1
    @aliasscope for i in 1:len
        a[i] = (Const(b)[i] + Const(b)[im1] + Const(b)[im2]) * 0.333
        im2 = im1
        im1 = i
    end
    return nothing
end

function s292_inbounds(a::AbstractVector, b::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    len = length(a)
    im1 = len
    im2 = len - 1
    @inbounds for i in 1:len
        a[i] = (b[i] + b[im1] + b[im2]) * 0.333
        im2 = im1
        im1 = i
    end
    return nothing
end

function s292_inbounds_const(a::AbstractVector, b::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    len = length(a)
    im1 = len
    im2 = len - 1
    @aliasscope @inbounds for i in 1:len
        a[i] = (Const(b)[i] + Const(b)[im1] + Const(b)[im2]) * 0.333
        im2 = im1
        im1 = i
    end
    return nothing
end

# s293 - loop peeling, a(i)=a(0) with actual dependence cycle, loop is vectorizable
function s293(a::AbstractVector)
    checkbounds(a, 1:length(a))
    val = a[1]
    for i in 1:length(a)
        a[i] = val
    end
    return nothing
end

function s293_const(a::AbstractVector)
    checkbounds(a, 1:length(a))
    val = a[1]
    for i in 1:length(a)
        a[i] = val
    end
    return nothing
end

function s293_inbounds(a::AbstractVector)
    checkbounds(a, 1:length(a))
    val = a[1]
    @inbounds for i in 1:length(a)
        a[i] = val
    end
    return nothing
end

function s293_inbounds_const(a::AbstractVector)
    checkbounds(a, 1:length(a))
    val = a[1]
    @inbounds for i in 1:length(a)
        a[i] = val
    end
    return nothing
end

# s2101 - diagonals, main diagonal calculation
function s2101(aa::AbstractMatrix, bb::AbstractMatrix, cc::AbstractMatrix)
    checkbounds(aa, 1:size(aa, 1), 1:size(aa, 2))
    checkbounds(bb, 1:size(bb, 1), 1:size(bb, 2))
    checkbounds(cc, 1:size(cc, 1), 1:size(cc, 2))
    for i in 1:size(aa, 1)
        aa[i, i] += bb[i, i] * cc[i, i]
    end
    return nothing
end

function s2101_const(aa::AbstractMatrix, bb::AbstractMatrix, cc::AbstractMatrix)
    checkbounds(aa, 1:size(aa, 1), 1:size(aa, 2))
    checkbounds(bb, 1:size(bb, 1), 1:size(bb, 2))
    checkbounds(cc, 1:size(cc, 1), 1:size(cc, 2))
    @aliasscope for i in 1:size(aa, 1)
        aa[i, i] += Const(bb)[i, i] * Const(cc)[i, i]
    end
    return nothing
end

function s2101_inbounds(aa::AbstractMatrix, bb::AbstractMatrix, cc::AbstractMatrix)
    checkbounds(aa, 1:size(aa, 1), 1:size(aa, 2))
    checkbounds(bb, 1:size(bb, 1), 1:size(bb, 2))
    checkbounds(cc, 1:size(cc, 1), 1:size(cc, 2))
    @inbounds for i in 1:size(aa, 1)
        aa[i, i] += bb[i, i] * cc[i, i]
    end
    return nothing
end

function s2101_inbounds_const(aa::AbstractMatrix, bb::AbstractMatrix, cc::AbstractMatrix)
    checkbounds(aa, 1:size(aa, 1), 1:size(aa, 2))
    checkbounds(bb, 1:size(bb, 1), 1:size(bb, 2))
    checkbounds(cc, 1:size(cc, 1), 1:size(cc, 2))
    @aliasscope @inbounds for i in 1:size(aa, 1)
        aa[i, i] += Const(bb)[i, i] * Const(cc)[i, i]
    end
    return nothing
end

# s2102 - diagonals, identity matrix
function s2102(aa::AbstractMatrix)
    checkbounds(aa, 1:size(aa, 1), 1:size(aa, 2))
    fill!(aa, 0.0)
    for i in 1:size(aa, 1)
        aa[i, i] = 1.0
    end
    return nothing
end

function s2102_const(aa::AbstractMatrix)
    checkbounds(aa, 1:size(aa, 1), 1:size(aa, 2))
    fill!(aa, 0.0)
    for i in 1:size(aa, 1)
        aa[i, i] = 1.0
    end
    return nothing
end

function s2102_inbounds(aa::AbstractMatrix)
    checkbounds(aa, 1:size(aa, 1), 1:size(aa, 2))
    fill!(aa, 0.0)
    @inbounds for i in 1:size(aa, 1)
        aa[i, i] = 1.0
    end
    return nothing
end

function s2102_inbounds_const(aa::AbstractMatrix)
    checkbounds(aa, 1:size(aa, 1), 1:size(aa, 2))
    fill!(aa, 0.0)
    @inbounds for i in 1:size(aa, 1)
        aa[i, i] = 1.0
    end
    return nothing
end

# s2111 - wavefronts
function s2111(aa::AbstractMatrix)
    checkbounds(aa, 1:size(aa, 1), 1:size(aa, 2))
    for j in 2:size(aa, 2)
        for i in 2:size(aa, 1)
            aa[i, j] = (aa[i-1, j] + aa[i, j-1]) / 1.9
        end
    end
    return nothing
end

function s2111_const(aa::AbstractMatrix)
    checkbounds(aa, 1:size(aa, 1), 1:size(aa, 2))
    for j in 2:size(aa, 2)
        for i in 2:size(aa, 1)
            aa[i, j] = (aa[i-1, j] + aa[i, j-1]) / 1.9
        end
    end
    return nothing
end

function s2111_inbounds(aa::AbstractMatrix)
    checkbounds(aa, 1:size(aa, 1), 1:size(aa, 2))
    @inbounds for j in 2:size(aa, 2)
        for i in 2:size(aa, 1)
            aa[i, j] = (aa[i-1, j] + aa[i, j-1]) / 1.9
        end
    end
    return nothing
end

function s2111_inbounds_const(aa::AbstractMatrix)
    checkbounds(aa, 1:size(aa, 1), 1:size(aa, 2))
    @inbounds for j in 2:size(aa, 2)
        for i in 2:size(aa, 1)
            aa[i, j] = (aa[i-1, j] + aa[i, j-1]) / 1.9
        end
    end
    return nothing
end

# s311 - reductions, sum reduction
function s311(a::AbstractVector)
    checkbounds(a, 1:length(a))
    sum_val = 0.0
    for i in 1:length(a)
        sum_val += a[i]
    end
    return sum_val
end

function s311_const(a::AbstractVector)
    checkbounds(a, 1:length(a))
    sum_val = 0.0
    @aliasscope for i in 1:length(a)
        sum_val += Const(a)[i]
    end
    return sum_val
end

function s311_inbounds(a::AbstractVector)
    checkbounds(a, 1:length(a))
    sum_val = 0.0
    @simd for i in 1:length(a)
        sum_val += a[i]
    end
    return sum_val
end

function s311_inbounds_const(a::AbstractVector)
    checkbounds(a, 1:length(a))
    sum_val = 0.0
    @aliasscope @simd for i in 1:length(a)
        sum_val += Const(a)[i]
    end
    return sum_val
end

# s312 - reductions, product reduction
function s312(a::AbstractVector)
    checkbounds(a, 1:length(a))
    prod_val = 1.0
    for i in 1:length(a)
        prod_val *= a[i]
    end
    return prod_val
end

function s312_const(a::AbstractVector)
    checkbounds(a, 1:length(a))
    prod_val = 1.0
    @aliasscope for i in 1:length(a)
        prod_val *= Const(a)[i]
    end
    return prod_val
end

function s312_inbounds(a::AbstractVector)
    checkbounds(a, 1:length(a))
    prod_val = 1.0
    @simd for i in 1:length(a)
        prod_val *= a[i]
    end
    return prod_val
end

function s312_inbounds_const(a::AbstractVector)
    checkbounds(a, 1:length(a))
    prod_val = 1.0
    @aliasscope @simd for i in 1:length(a)
        prod_val *= Const(a)[i]
    end
    return prod_val
end

# s313 - reductions, dot product
function s313(a::AbstractVector, b::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    dot_val = 0.0
    for i in 1:length(a)
        dot_val += a[i] * b[i]
    end
    return dot_val
end

function s313_const(a::AbstractVector, b::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    dot_val = 0.0
    @aliasscope for i in 1:length(a)
        dot_val += Const(a)[i] * Const(b)[i]
    end
    return dot_val
end

function s313_inbounds(a::AbstractVector, b::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    dot_val = 0.0
    @simd for i in 1:length(a)
        dot_val += a[i] * b[i]
    end
    return dot_val
end

function s313_inbounds_const(a::AbstractVector, b::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    dot_val = 0.0
    @aliasscope @simd for i in 1:length(a)
        dot_val += Const(a)[i] * Const(b)[i]
    end
    return dot_val
end

# s314 - reductions, if to max reduction
function s314(a::AbstractVector)
    checkbounds(a, 1:length(a))
    max_val = a[1]
    for i in 1:length(a)
        if a[i] > max_val
            max_val = a[i]
        end
    end
    return max_val
end

function s314_const(a::AbstractVector)
    checkbounds(a, 1:length(a))
    max_val = Const(a)[1]
    @aliasscope for i in 1:length(a)
        if Const(a)[i] > max_val
            max_val = Const(a)[i]
        end
    end
    return max_val
end

function s314_inbounds(a::AbstractVector)
    checkbounds(a, 1:length(a))
    max_val = a[1]
    @simd for i in 1:length(a)
        if a[i] > max_val
            max_val = a[i]
        end
    end
    return max_val
end

function s314_inbounds_const(a::AbstractVector)
    checkbounds(a, 1:length(a))
    max_val = Const(a)[1]
    @aliasscope @simd for i in 1:length(a)
        if Const(a)[i] > max_val
            max_val = Const(a)[i]
        end
    end
    return max_val
end

# s315 - reductions, if to max with index
function s315(a::AbstractVector)
    checkbounds(a, 1:length(a))
    max_val = a[1]
    max_idx = 1
    for i in 1:length(a)
        if a[i] > max_val
            max_val = a[i]
            max_idx = i
        end
    end
    return (max_val, max_idx)
end

function s315_const(a::AbstractVector)
    checkbounds(a, 1:length(a))
    max_val = Const(a)[1]
    max_idx = 1
    @aliasscope for i in 1:length(a)
        if Const(a)[i] > max_val
            max_val = Const(a)[i]
            max_idx = i
        end
    end
    return (max_val, max_idx)
end

function s315_inbounds(a::AbstractVector)
    checkbounds(a, 1:length(a))
    max_val = a[1]
    max_idx = 1
    @simd for i in 1:length(a)
        if a[i] > max_val
            max_val = a[i]
            max_idx = i
        end
    end
    return (max_val, max_idx)
end

function s315_inbounds_const(a::AbstractVector)
    checkbounds(a, 1:length(a))
    max_val = Const(a)[1]
    max_idx = 1
    @aliasscope @simd for i in 1:length(a)
        if Const(a)[i] > max_val
            max_val = Const(a)[i]
            max_idx = i
        end
    end
    return (max_val, max_idx)
end

# s316 - reductions, if to min reduction
function s316(a::AbstractVector)
    checkbounds(a, 1:length(a))
    min_val = a[1]
    for i in 1:length(a)
        if a[i] < min_val
            min_val = a[i]
        end
    end
    return min_val
end

function s316_const(a::AbstractVector)
    checkbounds(a, 1:length(a))
    min_val = Const(a)[1]
    @aliasscope for i in 1:length(a)
        if Const(a)[i] < min_val
            min_val = Const(a)[i]
        end
    end
    return min_val
end

function s316_inbounds(a::AbstractVector)
    checkbounds(a, 1:length(a))
    min_val = a[1]
    @simd for i in 1:length(a)
        if a[i] < min_val
            min_val = a[i]
        end
    end
    return min_val
end

function s316_inbounds_const(a::AbstractVector)
    checkbounds(a, 1:length(a))
    min_val = Const(a)[1]
    @aliasscope @simd for i in 1:length(a)
        if Const(a)[i] < min_val
            min_val = Const(a)[i]
        end
    end
    return min_val
end

# s318 - reductions, isamax
function s318(a::AbstractVector, inc::Int)
    checkbounds(a, 1:inc:length(a))
    max_val = abs(a[1])
    max_idx = 1
    for i in 1:inc:length(a)
        if abs(a[i]) > max_val
            max_val = abs(a[i])
            max_idx = i
        end
    end
    return max_idx
end

function s318_const(a::AbstractVector, inc::Int)
    checkbounds(a, 1:inc:length(a))
    max_val = abs(Const(a)[1])
    max_idx = 1
    @aliasscope for i in 1:inc:length(a)
        if abs(Const(a)[i]) > max_val
            max_val = abs(Const(a)[i])
            max_idx = i
        end
    end
    return max_idx
end

function s318_inbounds(a::AbstractVector, inc::Int)
    checkbounds(a, 1:inc:length(a))
    max_val = abs(a[1])
    max_idx = 1
    @simd for i in 1:inc:length(a)
        if abs(a[i]) > max_val
            max_val = abs(a[i])
            max_idx = i
        end
    end
    return max_idx
end

function s318_inbounds_const(a::AbstractVector, inc::Int)
    checkbounds(a, 1:inc:length(a))
    max_val = abs(Const(a)[1])
    max_idx = 1
    @aliasscope @simd for i in 1:inc:length(a)
        if abs(Const(a)[i]) > max_val
            max_val = abs(Const(a)[i])
            max_idx = i
        end
    end
    return max_idx
end

# s319 - reductions, coupled reductions
function s319(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    checkbounds(d, 1:length(a))
    checkbounds(e, 1:length(a))
    sum_val = 0.0
    for i in 1:length(a)
        a[i] = c[i] + d[i]
        sum_val += a[i]
        b[i] = c[i] + e[i]
        sum_val += b[i]
    end
    return sum_val
end

function s319_const(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    checkbounds(d, 1:length(a))
    checkbounds(e, 1:length(a))
    sum_val = 0.0
    @aliasscope for i in 1:length(a)
        a[i] = Const(c)[i] + Const(d)[i]
        sum_val += a[i]
        b[i] = Const(c)[i] + Const(e)[i]
        sum_val += b[i]
    end
    return sum_val
end

function s319_inbounds(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    checkbounds(d, 1:length(a))
    checkbounds(e, 1:length(a))
    sum_val = 0.0
    @simd for i in 1:length(a)
        a[i] = c[i] + d[i]
        sum_val += a[i]
        b[i] = c[i] + e[i]
        sum_val += b[i]
    end
    return sum_val
end

function s319_inbounds_const(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    checkbounds(d, 1:length(a))
    checkbounds(e, 1:length(a))
    sum_val = 0.0
    @aliasscope @simd for i in 1:length(a)
        a[i] = Const(c)[i] + Const(d)[i]
        sum_val += a[i]
        b[i] = Const(c)[i] + Const(e)[i]
        sum_val += b[i]
    end
    return sum_val
end

# s3110 - reductions, if to max with index 2 dimensions
function s3110(aa::AbstractMatrix)
    checkbounds(aa, 1:size(aa,1), 1:size(aa,2))
    max_val = aa[1,1]
    max_ix = 1
    max_iy = 1
    for j in 1:size(aa,2)
        for i in 1:size(aa,1)
            if aa[i,j] > max_val
                max_val = aa[i,j]
                max_ix = i
                max_iy = j
            end
        end
    end
    return (max_val, max_ix, max_iy)
end

function s3110_const(aa::AbstractMatrix)
    checkbounds(aa, 1:size(aa,1), 1:size(aa,2))
    max_val = Const(aa)[1,1]
    max_ix = 1
    max_iy = 1
    @aliasscope for j in 1:size(aa,2)
        for i in 1:size(aa,1)
            if Const(aa)[i,j] > max_val
                max_val = Const(aa)[i,j]
                max_ix = i
                max_iy = j
            end
        end
    end
    return (max_val, max_ix, max_iy)
end

function s3110_inbounds(aa::AbstractMatrix)
    checkbounds(aa, 1:size(aa,1), 1:size(aa,2))
    max_val = aa[1,1]
    max_ix = 1
    max_iy = 1
    @inbounds for j in 1:size(aa,2)
        for i in 1:size(aa,1)
            if aa[i,j] > max_val
                max_val = aa[i,j]
                max_ix = i
                max_iy = j
            end
        end
    end
    return (max_val, max_ix, max_iy)
end

function s3110_inbounds_const(aa::AbstractMatrix)
    checkbounds(aa, 1:size(aa,1), 1:size(aa,2))
    max_val = Const(aa)[1,1]
    max_ix = 1
    max_iy = 1
    @aliasscope @inbounds for j in 1:size(aa,2)
        for i in 1:size(aa,1)
            if Const(aa)[i,j] > max_val
                max_val = Const(aa)[i,j]
                max_ix = i
                max_iy = j
            end
        end
    end
    return (max_val, max_ix, max_iy)
end

# s3111 - reductions, conditional sum reduction
function s3111(a::AbstractVector)
    checkbounds(a, 1:length(a))
    sum_val = 0.0
    for i in 1:length(a)
        if a[i] > 0.0
            sum_val += a[i]
        end
    end
    return sum_val
end

function s3111_const(a::AbstractVector)
    checkbounds(a, 1:length(a))
    sum_val = 0.0
    @aliasscope for i in 1:length(a)
        if Const(a)[i] > 0.0
            sum_val += Const(a)[i]
        end
    end
    return sum_val
end

function s3111_inbounds(a::AbstractVector)
    checkbounds(a, 1:length(a))
    sum_val = 0.0
    @inbounds for i in 1:length(a)
        if a[i] > 0.0
            sum_val += a[i]
        end
    end
    return sum_val
end

function s3111_inbounds_const(a::AbstractVector)
    checkbounds(a, 1:length(a))
    sum_val = 0.0
    @aliasscope @inbounds for i in 1:length(a)
        if Const(a)[i] > 0.0
            sum_val += Const(a)[i]
        end
    end
    return sum_val
end

# s3112 - reductions, sum reduction saving running sums
function s3112(a::AbstractVector, b::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(b))
    sum_val = 0.0
    for i in 1:length(a)
        sum_val += a[i]
        b[i] = sum_val
    end
    return sum_val
end

function s3112_const(a::AbstractVector, b::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(b))
    sum_val = 0.0
    @aliasscope for i in 1:length(a)
        sum_val += Const(a)[i]
        b[i] = sum_val
    end
    return sum_val
end

function s3112_inbounds(a::AbstractVector, b::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(b))
    sum_val = 0.0
    @inbounds for i in 1:length(a)
        sum_val += a[i]
        b[i] = sum_val
    end
    return sum_val
end

function s3112_inbounds_const(a::AbstractVector, b::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(b))
    sum_val = 0.0
    @aliasscope @inbounds for i in 1:length(a)
        sum_val += Const(a)[i]
        b[i] = sum_val
    end
    return sum_val
end

# s3113 - reductions, maximum of absolute value
function s3113(a::AbstractVector)
    checkbounds(a, 1:length(a))
    max_val = a[1]
    for i in 1:length(a)
        if a[i] > max_val
            max_val = a[i]
        end
    end
    return max_val
end

function s3113_const(a::AbstractVector)
    checkbounds(a, 1:length(a))
    max_val = Const(a)[1]
    @aliasscope for i in 1:length(a)
        if Const(a)[i] > max_val
            max_val = Const(a)[i]
        end
    end
    return max_val
end

function s3113_inbounds(a::AbstractVector)
    checkbounds(a, 1:length(a))
    max_val = a[1]
    @inbounds for i in 1:length(a)
        if a[i] > max_val
            max_val = a[i]
        end
    end
    return max_val
end

function s3113_inbounds_const(a::AbstractVector)
    checkbounds(a, 1:length(a))
    max_val = Const(a)[1]
    @aliasscope @inbounds for i in 1:length(a)
        if Const(a)[i] > max_val
            max_val = Const(a)[i]
        end
    end
    return max_val
end

# s321 - recurrences, first order linear recurrence
function s321(a::AbstractVector, b::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    for i in 2:length(a)
        a[i] += a[i-1] * b[i]
    end
end

function s321_const(a::AbstractVector, b::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    @aliasscope for i in 2:length(a)
        a[i] += Const(a)[i-1] * Const(b)[i]
    end
end

function s321_inbounds(a::AbstractVector, b::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    @inbounds for i in 2:length(a)
        a[i] += a[i-1] * b[i]
    end
end

function s321_inbounds_const(a::AbstractVector, b::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    @aliasscope @inbounds for i in 2:length(a)
        a[i] += Const(a)[i-1] * Const(b)[i]
    end
end

# s322 - recurrences, second order linear recurrence
function s322(a::AbstractVector, b::AbstractVector, c::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    for i in 3:length(a)
        a[i] = a[i] + a[i-1] * b[i] + a[i-2] * c[i]
    end
end

function s322_const(a::AbstractVector, b::AbstractVector, c::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    @aliasscope for i in 3:length(a)
        a[i] = a[i] + Const(a)[i-1] * Const(b)[i] + Const(a)[i-2] * Const(c)[i]
    end
end

function s322_inbounds(a::AbstractVector, b::AbstractVector, c::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    @inbounds for i in 3:length(a)
        a[i] = a[i] + a[i-1] * b[i] + a[i-2] * c[i]
    end
end

function s322_inbounds_const(a::AbstractVector, b::AbstractVector, c::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    @aliasscope @inbounds for i in 3:length(a)
        a[i] = a[i] + Const(a)[i-1] * Const(b)[i] + Const(a)[i-2] * Const(c)[i]
    end
end

# s323 - recurrences, coupled recurrence
function s323(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    checkbounds(d, 1:length(a))
    checkbounds(e, 1:length(a))
    for i in 2:length(a)
        a[i] = b[i-1] + c[i] * d[i]
        b[i] = a[i] + c[i] * e[i]
    end
end

function s323_const(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    checkbounds(d, 1:length(a))
    checkbounds(e, 1:length(a))
    @aliasscope for i in 2:length(a)
        a[i] = Const(b)[i-1] + Const(c)[i] * Const(d)[i]
        b[i] = a[i] + Const(c)[i] * Const(e)[i]
    end
end

function s323_inbounds(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    checkbounds(d, 1:length(a))
    checkbounds(e, 1:length(a))
    @inbounds for i in 2:length(a)
        a[i] = b[i-1] + c[i] * d[i]
        b[i] = a[i] + c[i] * e[i]
    end
end

function s323_inbounds_const(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    checkbounds(d, 1:length(a))
    checkbounds(e, 1:length(a))
    @aliasscope @inbounds for i in 2:length(a)
        a[i] = Const(b)[i-1] + Const(c)[i] * Const(d)[i]
        b[i] = a[i] + Const(c)[i] * Const(e)[i]
    end
end

# s331 - search loops, if to last-1
function s331(a::AbstractVector)
    checkbounds(a, 1:length(a))
    j = 0
    for i in 1:length(a)
        if a[i] < 0.0
            j = i
        end
    end
    return j
end

function s331_const(a::AbstractVector)
    checkbounds(a, 1:length(a))
    j = 0
    @aliasscope for i in 1:length(a)
        if Const(a)[i] < 0.0
            j = i
        end
    end
    return j
end

function s331_inbounds(a::AbstractVector)
    checkbounds(a, 1:length(a))
    j = 0
    @inbounds for i in 1:length(a)
        if a[i] < 0.0
            j = i
        end
    end
    return j
end

function s331_inbounds_const(a::AbstractVector)
    checkbounds(a, 1:length(a))
    j = 0
    @aliasscope @inbounds for i in 1:length(a)
        if Const(a)[i] < 0.0
            j = i
        end
    end
    return j
end

# s332 - search loops, first value greater than threshold
function s332(a::AbstractVector, t::Int)
    checkbounds(a, 1:length(a))
    index = -1
    value = -1.0
    for i in 1:length(a)
        if a[i] > t
            index = i
            value = a[i]
            break
        end
    end
    return (value, index)
end

function s332_const(a::AbstractVector, t::Int)
    checkbounds(a, 1:length(a))
    index = -1
    value = -1.0
    @aliasscope for i in 1:length(a)
        if Const(a)[i] > t
            index = i
            value = Const(a)[i]
            break
        end
    end
    return (value, index)
end

function s332_inbounds(a::AbstractVector, t::Int)
    checkbounds(a, 1:length(a))
    index = -1
    value = -1.0
    @inbounds for i in 1:length(a)
        if a[i] > t
            index = i
            value = a[i]
            break
        end
    end
    return (value, index)
end

function s332_inbounds_const(a::AbstractVector, t::Int)
    checkbounds(a, 1:length(a))
    index = -1
    value = -1.0
    @aliasscope @inbounds for i in 1:length(a)
        if Const(a)[i] > t
            index = i
            value = Const(a)[i]
            break
        end
    end
    return (value, index)
end

# s341 - packing, pack positive values
function s341(a::AbstractVector, b::AbstractVector)
    checkbounds(a, 1:length(b))
    checkbounds(b, 1:length(b))
    j = 0
    for i in 1:length(b)
        if b[i] > 0.0
            j += 1
            a[j] = b[i]
        end
    end
    return nothing
end

function s341_const(a::AbstractVector, b::AbstractVector)
    checkbounds(a, 1:length(b))
    checkbounds(b, 1:length(b))
    j = 0
    @aliasscope for i in 1:length(b)
        if Const(b)[i] > 0.0
            j += 1
            a[j] = Const(b)[i]
        end
    end
    return nothing
end

function s341_inbounds(a::AbstractVector, b::AbstractVector)
    checkbounds(a, 1:length(b))
    checkbounds(b, 1:length(b))
    j = 0
    @inbounds for i in 1:length(b)
        if b[i] > 0.0
            j += 1
            a[j] = b[i]
        end
    end
    return nothing
end

function s341_inbounds_const(a::AbstractVector, b::AbstractVector)
    checkbounds(a, 1:length(b))
    checkbounds(b, 1:length(b))
    j = 0
    @aliasscope @inbounds for i in 1:length(b)
        if Const(b)[i] > 0.0
            j += 1
            a[j] = Const(b)[i]
        end
    end
    return nothing
end

# s342 - packing, gather/scatter with array of indices
function s342(a::AbstractVector, b::AbstractVector, c::AbstractVector{Int})
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    for i in 1:length(a)
        a[i] = b[c[i]]
    end
    return nothing
end

function s342_const(a::AbstractVector, b::AbstractVector, c::AbstractVector{Int})
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    @aliasscope for i in 1:length(a)
        a[i] = Const(b)[Const(c)[i]]
    end
    return nothing
end

function s342_inbounds(a::AbstractVector, b::AbstractVector, c::AbstractVector{Int})
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    @inbounds for i in 1:length(a)
        a[i] = b[c[i]]
    end
    return nothing
end

function s342_inbounds_const(a::AbstractVector, b::AbstractVector, c::AbstractVector{Int})
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    @aliasscope @inbounds for i in 1:length(a)
        a[i] = Const(b)[Const(c)[i]]
    end
    return nothing
end

# s343 - packing, pack 2-d array into one dimension
function s343(flat_2d_array::AbstractVector, aa::AbstractMatrix, bb::AbstractMatrix)
    checkbounds(flat_2d_array, 1:size(aa, 1) * size(aa, 2))
    checkbounds(aa, 1:size(aa, 1), 1:size(aa, 2))
    checkbounds(bb, 1:size(bb, 1), 1:size(bb, 2))
    k = 0
    for i in 1:size(aa, 2)
        for j in 1:size(aa, 1)
            if bb[j, i] > 0.0
                k += 1
                flat_2d_array[k] = aa[j, i]
            end
        end
    end
    return nothing
end

function s343_const(flat_2d_array::AbstractVector, aa::AbstractMatrix, bb::AbstractMatrix)
    checkbounds(flat_2d_array, 1:size(aa, 1) * size(aa, 2))
    checkbounds(aa, 1:size(aa, 1), 1:size(aa, 2))
    checkbounds(bb, 1:size(bb, 1), 1:size(bb, 2))
    k = 0
    @aliasscope for i in 1:size(aa, 2)
        for j in 1:size(aa, 1)
            if Const(bb)[j, i] > 0.0
                k += 1
                flat_2d_array[k] = Const(aa)[j, i]
            end
        end
    end
    return nothing
end

function s343_inbounds(flat_2d_array::AbstractVector, aa::AbstractMatrix, bb::AbstractMatrix)
    checkbounds(flat_2d_array, 1:size(aa, 1) * size(aa, 2))
    checkbounds(aa, 1:size(aa, 1), 1:size(aa, 2))
    checkbounds(bb, 1:size(bb, 1), 1:size(bb, 2))
    k = 0
    @inbounds for i in 1:size(aa, 2)
        for j in 1:size(aa, 1)
            if bb[j, i] > 0.0
                k += 1
                flat_2d_array[k] = aa[j, i]
            end
        end
    end
    return nothing
end

function s343_inbounds_const(flat_2d_array::AbstractVector, aa::AbstractMatrix, bb::AbstractMatrix)
    checkbounds(flat_2d_array, 1:size(aa, 1) * size(aa, 2))
    checkbounds(aa, 1:size(aa, 1), 1:size(aa, 2))
    checkbounds(bb, 1:size(bb, 1), 1:size(bb, 2))
    k = 0
    @aliasscope @inbounds for i in 1:size(aa, 2)
        for j in 1:size(aa, 1)
            if Const(bb)[j, i] > 0.0
                k += 1
                flat_2d_array[k] = Const(aa)[j, i]
            end
        end
    end
    return nothing
end

# s351 - loop rerolling, unrolled saxpy
function s351(a::AbstractVector, b::AbstractVector, c::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(b))
    checkbounds(c, 1)
    alpha = c[1]
    for i in 1:length(a)
        a[i] += alpha * b[i]
    end
    return nothing
end

function s351_const(a::AbstractVector, b::AbstractVector, c::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(b))
    checkbounds(c, 1)
    alpha = Const(c)[1]
    @aliasscope for i in 1:length(a)
        a[i] += alpha * Const(b)[i]
    end
    return nothing
end

function s351_inbounds(a::AbstractVector, b::AbstractVector, c::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(b))
    checkbounds(c, 1)
    alpha = c[1]
    @inbounds for i in 1:length(a)
        a[i] += alpha * b[i]
    end
    return nothing
end

function s351_inbounds_const(a::AbstractVector, b::AbstractVector, c::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(b))
    checkbounds(c, 1)
    alpha = Const(c)[1]
    @aliasscope @inbounds for i in 1:length(a)
        a[i] += alpha * Const(b)[i]
    end
    return nothing
end

# s1351 - induction pointer recognition
function s1351(a::AbstractVector, b::AbstractVector, c::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(b))
    checkbounds(c, 1:length(c))
    for i in 1:length(a)
        a[i] = b[i] + c[i]
    end
    return nothing
end

function s1351_const(a::AbstractVector, b::AbstractVector, c::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(b))
    checkbounds(c, 1:length(c))
    @aliasscope for i in 1:length(a)
        a[i] = Const(b)[i] + Const(c)[i]
    end
    return nothing
end

function s1351_inbounds(a::AbstractVector, b::AbstractVector, c::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(b))
    checkbounds(c, 1:length(c))
    @inbounds for i in 1:length(a)
        a[i] = b[i] + c[i]
    end
    return nothing
end

function s1351_inbounds_const(a::AbstractVector, b::AbstractVector, c::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(b))
    checkbounds(c, 1:length(c))
    @aliasscope @inbounds for i in 1:length(a)
        a[i] = Const(b)[i] + Const(c)[i]
    end
    return nothing
end

# s352 - loop rerolling, unrolled dot product
function s352(a::AbstractVector, b::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(b))
    dot = 0.0
    for i in 1:length(a)
        dot += a[i] * b[i]
    end
    return dot
end

function s352_const(a::AbstractVector, b::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(b))
    dot = 0.0
    @aliasscope for i in 1:length(a)
        dot += Const(a)[i] * Const(b)[i]
    end
    return dot
end

function s352_inbounds(a::AbstractVector, b::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(b))
    dot = 0.0
    @inbounds for i in 1:length(a)
        dot += a[i] * b[i]
    end
    return dot
end

function s352_inbounds_const(a::AbstractVector, b::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(b))
    dot = 0.0
    @aliasscope @inbounds for i in 1:length(a)
        dot += Const(a)[i] * Const(b)[i]
    end
    return dot
end

# s353 - loop rerolling, unrolled sparse saxpy with gather
function s353(a::AbstractVector, b::AbstractVector, c::AbstractVector, ip::AbstractVector{<:Int})
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(b))
    checkbounds(c, 1)
    checkbounds(ip, 1:length(a))
    alpha = c[1]
    for i in 1:length(a)
        a[i] += alpha * b[ip[i]+1]
    end
    return nothing
end

function s353_const(a::AbstractVector, b::AbstractVector, c::AbstractVector, ip::AbstractVector{<:Int})
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(b))
    checkbounds(c, 1)
    checkbounds(ip, 1:length(a))
    alpha = Const(c)[1]
    @aliasscope for i in 1:length(a)
        a[i] += alpha * Const(b)[Const(ip)[i]+1]
    end
    return nothing
end

function s353_inbounds(a::AbstractVector, b::AbstractVector, c::AbstractVector, ip::AbstractVector{<:Int})
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(b))
    checkbounds(c, 1)
    checkbounds(ip, 1:length(a))
    alpha = c[1]
    @inbounds for i in 1:length(a)
        a[i] += alpha * b[ip[i]+1]
    end
    return nothing
end

function s353_inbounds_const(a::AbstractVector, b::AbstractVector, c::AbstractVector, ip::AbstractVector{<:Int})
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(b))
    checkbounds(c, 1)
    checkbounds(ip, 1:length(a))
    alpha = Const(c)[1]
    @aliasscope @inbounds for i in 1:length(a)
        a[i] += alpha * Const(b)[Const(ip)[i]+1]
    end
    return nothing
end

# s421 - storage classes and equivalencing
function s421(flat_2d_array::AbstractVector, a::AbstractVector)
    checkbounds(flat_2d_array, 1:length(a))
    checkbounds(a, 1:length(a)-1)
    for i in 1:length(a)-1
        flat_2d_array[i] = flat_2d_array[i+1] + a[i]
    end
    return nothing
end

function s421_simd(flat_2d_array::AbstractVector, a::AbstractVector)
    checkbounds(flat_2d_array, 1:length(a))
    checkbounds(a, 1:length(a)-1)
    @simd for i in 1:length(a)-1
        flat_2d_array[i] = flat_2d_array[i+1] + a[i]
    end
    return nothing
end

function s421_inbounds(flat_2d_array::AbstractVector, a::AbstractVector)
    checkbounds(flat_2d_array, 1:length(a))
    checkbounds(a, 1:length(a)-1)
    @inbounds for i in 1:length(a)-1
        flat_2d_array[i] = flat_2d_array[i+1] + a[i]
    end
    return nothing
end

function s421_inbounds_simd(flat_2d_array::AbstractVector, a::AbstractVector)
    checkbounds(flat_2d_array, 1:length(a))
    checkbounds(a, 1:length(a)-1)
    @inbounds @simd for i in 1:length(a)-1
        flat_2d_array[i] = flat_2d_array[i+1] + a[i]
    end
    return nothing
end

# s1421 - storage classes and equivalencing
function s1421(b::AbstractVector, a::AbstractVector)
    len_2 = div(length(a), 2)
    checkbounds(b, 1:length(a))
    checkbounds(a, 1:len_2)
    for i in 1:len_2
        b[i] = b[i + len_2] + a[i]
    end
    return nothing
end

function s1421_simd(b::AbstractVector, a::AbstractVector)
    len_2 = div(length(a), 2)
    checkbounds(b, 1:length(a))
    checkbounds(a, 1:len_2)
    @simd for i in 1:len_2
        b[i] = b[i + len_2] + a[i]
    end
    return nothing
end

function s1421_inbounds(b::AbstractVector, a::AbstractVector)
    len_2 = div(length(a), 2)
    checkbounds(b, 1:length(a))
    checkbounds(a, 1:len_2)
    @inbounds for i in 1:len_2
        b[i] = b[i + len_2] + a[i]
    end
    return nothing
end

function s1421_inbounds_simd(b::AbstractVector, a::AbstractVector)
    len_2 = div(length(a), 2)
    checkbounds(b, 1:length(a))
    checkbounds(a, 1:len_2)
    @inbounds @simd for i in 1:len_2
        b[i] = b[i + len_2] + a[i]
    end
    return nothing
end

# s422 - anti-dependence, threshold of 4
function s422(flat_2d_array::AbstractVector, a::AbstractVector)
    checkbounds(flat_2d_array, 1:length(a)+8)
    checkbounds(a, 1:length(a))
    for i in 1:length(a)
        flat_2d_array[i+4] = flat_2d_array[i+8] + a[i]
    end
    return nothing
end

function s422_simd(flat_2d_array::AbstractVector, a::AbstractVector)
    checkbounds(flat_2d_array, 1:length(a)+8)
    checkbounds(a, 1:length(a))
    @simd for i in 1:length(a)
        flat_2d_array[i+4] = flat_2d_array[i+8] + a[i]
    end
    return nothing
end

function s422_inbounds(flat_2d_array::AbstractVector, a::AbstractVector)
    checkbounds(flat_2d_array, 1:length(a)+8)
    checkbounds(a, 1:length(a))
    @inbounds for i in 1:length(a)
        flat_2d_array[i+4] = flat_2d_array[i+8] + a[i]
    end
    return nothing
end

function s422_inbounds_simd(flat_2d_array::AbstractVector, a::AbstractVector)
    checkbounds(flat_2d_array, 1:length(a)+8)
    checkbounds(a, 1:length(a))
    @inbounds @simd for i in 1:length(a)
        flat_2d_array[i+4] = flat_2d_array[i+8] + a[i]
    end
    return nothing
end

# s423 - common and equivalenced variables - with anti-dependence
function s423(flat_2d_array::AbstractVector, a::AbstractVector)
    checkbounds(flat_2d_array, 1:length(a)+63)
    checkbounds(a, 1:length(a)-1)
    for i in 1:length(a)-1
        flat_2d_array[i+1] = flat_2d_array[i+64] + a[i]
    end
    return nothing
end

function s423_simd(flat_2d_array::AbstractVector, a::AbstractVector)
    checkbounds(flat_2d_array, 1:length(a)+63)
    checkbounds(a, 1:length(a)-1)
    @simd for i in 1:length(a)-1
        flat_2d_array[i+1] = flat_2d_array[i+64] + a[i]
    end
    return nothing
end

function s423_inbounds(flat_2d_array::AbstractVector, a::AbstractVector)
    checkbounds(flat_2d_array, 1:length(a)+63)
    checkbounds(a, 1:length(a)-1)
    @inbounds for i in 1:length(a)-1
        flat_2d_array[i+1] = flat_2d_array[i+64] + a[i]
    end
    return nothing
end

function s423_inbounds_simd(flat_2d_array::AbstractVector, a::AbstractVector)
    checkbounds(flat_2d_array, 1:length(a)+63)
    checkbounds(a, 1:length(a)-1)
    @inbounds @simd for i in 1:length(a)-1
        flat_2d_array[i+1] = flat_2d_array[i+64] + a[i]
    end
    return nothing
end

# s424 - common and equivalenced variables - overlap
function s424(flat_2d_array::AbstractVector, a::AbstractVector)
    checkbounds(flat_2d_array, 1:length(a)+63)
    checkbounds(a, 1:length(a)-1)
    for i in 1:length(a)-1
        flat_2d_array[i+64] = flat_2d_array[i] + a[i]
    end
    return nothing
end

function s424_simd(flat_2d_array::AbstractVector, a::AbstractVector)
    checkbounds(flat_2d_array, 1:length(a)+63)
    checkbounds(a, 1:length(a)-1)
    @simd for i in 1:length(a)-1
        flat_2d_array[i+64] = flat_2d_array[i] + a[i]
    end
    return nothing
end

function s424_inbounds(flat_2d_array::AbstractVector, a::AbstractVector)
    checkbounds(flat_2d_array, 1:length(a)+63)
    checkbounds(a, 1:length(a)-1)
    @inbounds for i in 1:length(a)-1
        flat_2d_array[i+64] = flat_2d_array[i] + a[i]
    end
    return nothing
end

function s424_inbounds_simd(flat_2d_array::AbstractVector, a::AbstractVector)
    checkbounds(flat_2d_array, 1:length(a)+63)
    checkbounds(a, 1:length(a)-1)
    @inbounds @simd for i in 1:length(a)-1
        flat_2d_array[i+64] = flat_2d_array[i] + a[i]
    end
    return nothing
end

# s431 - parameters
function s431(a::AbstractVector, b::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    for i in 1:length(a)
        a[i] += b[i]
    end
    return nothing
end

function s431_const(a::AbstractVector, b::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    @aliasscope for i in 1:length(a)
        a[i] += Const(b)[i]
    end
    return nothing
end

function s431_inbounds(a::AbstractVector, b::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    @inbounds @simd for i in 1:length(a)
        a[i] += b[i]
    end
    return nothing
end

function s431_inbounds_const(a::AbstractVector, b::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    @aliasscope @inbounds @simd for i in 1:length(a)
        a[i] += Const(b)[i]
    end
    return nothing
end

# s441 - non-logical if's
function s441(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    checkbounds(d, 1:length(a))
    for i in 1:length(a)
        a[i] = b[i] + c[i] * ifelse(d[i] > 0, 1.0, -1.0)
    end
    return nothing
end

function s441_const(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    checkbounds(d, 1:length(a))
    @aliasscope for i in 1:length(a)
        a[i] = Const(b)[i] + Const(c)[i] * ifelse(Const(d)[i] > 0, 1.0, -1.0)
    end
    return nothing
end

function s441_inbounds(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    checkbounds(d, 1:length(a))
    @inbounds @simd for i in 1:length(a)
        a[i] = b[i] + c[i] * ifelse(d[i] > 0, 1.0, -1.0)
    end
    return nothing
end

function s441_inbounds_const(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    checkbounds(d, 1:length(a))
    @aliasscope @inbounds @simd for i in 1:length(a)
        a[i] = Const(b)[i] + Const(c)[i] * ifelse(Const(d)[i] > 0, 1.0, -1.0)
    end
    return nothing
end

# s442 - computed goto
function s442(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector, indx::AbstractVector{<:Int})
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    checkbounds(d, 1:length(a))
    checkbounds(e, 1:length(a))
    checkbounds(indx, 1:length(a))
    for i in 1:length(a)
        v = indx[i]
        if v == 1
            a[i] = b[i] + d[i] * d[i]
        elseif v == 2
            b[i] = a[i] + e[i] * e[i]
        elseif v == 3
            c[i] = a[i] + b[i] * b[i]
        else # v == 4
            d[i] = b[i] + c[i] * c[i]
        end
    end
    return nothing
end

function s442_simd(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector, indx::AbstractVector{<:Int})
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    checkbounds(d, 1:length(a))
    checkbounds(e, 1:length(a))
    checkbounds(indx, 1:length(a))
    @simd for i in 1:length(a)
        v = indx[i]
        if v == 1
            a[i] = b[i] + d[i] * d[i]
        elseif v == 2
            b[i] = a[i] + e[i] * e[i]
        elseif v == 3
            c[i] = a[i] + b[i] * b[i]
        else # v == 4
            d[i] = b[i] + c[i] * c[i]
        end
    end
    return nothing
end

function s442_inbounds(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector, indx::AbstractVector{<:Int})
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    checkbounds(d, 1:length(a))
    checkbounds(e, 1:length(a))
    checkbounds(indx, 1:length(a))
    @inbounds for i in 1:length(a)
        v = indx[i]
        if v == 1
            a[i] = b[i] + d[i] * d[i]
        elseif v == 2
            b[i] = a[i] + e[i] * e[i]
        elseif v == 3
            c[i] = a[i] + b[i] * b[i]
        else # v == 4
            d[i] = b[i] + c[i] * c[i]
        end
    end
    return nothing
end

function s442_inbounds_simd(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector, indx::AbstractVector{<:Int})
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    checkbounds(d, 1:length(a))
    checkbounds(e, 1:length(a))
    checkbounds(indx, 1:length(a))
    @inbounds @simd for i in 1:length(a)
        v = indx[i]
        if v == 1
            a[i] = b[i] + d[i] * d[i]
        elseif v == 2
            b[i] = a[i] + e[i] * e[i]
        elseif v == 3
            c[i] = a[i] + b[i] * b[i]
        else # v == 4
            d[i] = b[i] + c[i] * c[i]
        end
    end
    return nothing
end

# s443 - if with varying condition
function s443(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector)
    checkbounds(a, 1:length(b))
    checkbounds(b, 1:length(b))
    checkbounds(c, 1:length(b))
    checkbounds(d, 1:length(b))
    checkbounds(e, 1:length(b))
    for i in 1:length(b)
        if d[i] < 0.0
            a[i] = b[i] + c[i] * e[i]
        else
            a[i] = b[i] + b[i] * c[i]
        end
        c[i] = a[i] + d[i]
    end
    return nothing
end

function s443_const(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector)
    checkbounds(a, 1:length(b))
    checkbounds(b, 1:length(b))
    checkbounds(c, 1:length(b))
    checkbounds(d, 1:length(b))
    checkbounds(e, 1:length(b))
    @aliasscope for i in 1:length(b)
        if Const(d)[i] < 0.0
            a[i] = Const(b)[i] + c[i] * Const(e)[i]
        else
            a[i] = Const(b)[i] + Const(b)[i] * c[i]
        end
        c[i] = a[i] + Const(d)[i]
    end
    return nothing
end

function s443_inbounds(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector)
    checkbounds(a, 1:length(b))
    checkbounds(b, 1:length(b))
    checkbounds(c, 1:length(b))
    checkbounds(d, 1:length(b))
    checkbounds(e, 1:length(b))
    @inbounds for i in 1:length(b)
        if d[i] < 0.0
            a[i] = b[i] + c[i] * e[i]
        else
            a[i] = b[i] + b[i] * c[i]
        end
        c[i] = a[i] + d[i]
    end
    return nothing
end

function s443_inbounds_const(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector)
    checkbounds(a, 1:length(b))
    checkbounds(b, 1:length(b))
    checkbounds(c, 1:length(b))
    checkbounds(d, 1:length(b))
    checkbounds(e, 1:length(b))
    @aliasscope @inbounds for i in 1:length(b)
        if Const(d)[i] < 0.0
            a[i] = Const(b)[i] + c[i] * Const(e)[i]
        else
            a[i] = Const(b)[i] + Const(b)[i] * c[i]
        end
        c[i] = a[i] + Const(d)[i]
    end
    return nothing
end

# s451 - vector maybe, not obvious
function s451(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    checkbounds(d, 1:length(a))
    for i in 1:length(a)
        a[i] = b[i] + c[i] * d[i]
    end
    return nothing
end

function s451_const(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    checkbounds(d, 1:length(a))
    @aliasscope for i in 1:length(a)
        a[i] = Const(b)[i] + Const(c)[i] * Const(d)[i]
    end
    return nothing
end

function s451_inbounds(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    checkbounds(d, 1:length(a))
    @inbounds for i in 1:length(a)
        a[i] = b[i] + c[i] * d[i]
    end
    return nothing
end

function s451_inbounds_const(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    checkbounds(d, 1:length(a))
    @aliasscope @inbounds for i in 1:length(a)
        a[i] = Const(b)[i] + Const(c)[i] * Const(d)[i]
    end
    return nothing
end

# s452 - intrinsic functions
function s452(a::AbstractVector, b::AbstractVector, c::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    for i in 1:length(a)
        a[i] = b[i] + c[i] * i
    end
    return nothing
end

function s452_const(a::AbstractVector, b::AbstractVector, c::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    @aliasscope for i in 1:length(a)
        a[i] = Const(b)[i] + Const(c)[i] * i
    end
    return nothing
end

function s452_inbounds(a::AbstractVector, b::AbstractVector, c::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    @inbounds for i in 1:length(a)
        a[i] = b[i] + c[i] * i
    end
    return nothing
end

function s452_inbounds_const(a::AbstractVector, b::AbstractVector, c::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    @aliasscope @inbounds for i in 1:length(a)
        a[i] = Const(b)[i] + Const(c)[i] * i
    end
    return nothing
end

# s453 - induction variable recognition
function s453(a::AbstractVector, b::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    s = 0.0
    for i in 1:length(a)
        s += 2.0
        a[i] = s * b[i]
    end
    return nothing
end

function s453_const(a::AbstractVector, b::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    s = 0.0
    @aliasscope for i in 1:length(a)
        s += 2.0
        a[i] = s * Const(b)[i]
    end
    return nothing
end

function s453_inbounds(a::AbstractVector, b::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    s = 0.0
    @inbounds for i in 1:length(a)
        s += 2.0
        a[i] = s * b[i]
    end
    return nothing
end

function s453_inbounds_const(a::AbstractVector, b::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    s = 0.0
    @aliasscope @inbounds for i in 1:length(a)
        s += 2.0
        a[i] = s * Const(b)[i]
    end
    return nothing
end

# s471 - call statements
s471s() = nothing

function s471(x::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector)
    checkbounds(x, 1:length(x))
    checkbounds(b, 1:length(x))
    checkbounds(c, 1:length(x))
    checkbounds(d, 1:length(x))
    checkbounds(e, 1:length(x))
    for i in 1:length(x)
        x[i] = b[i] + d[i] * d[i]
        s471s()
        b[i] = c[i] + d[i] * e[i]
    end
    return nothing
end

function s471_const(x::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector)
    checkbounds(x, 1:length(x))
    checkbounds(b, 1:length(x))
    checkbounds(c, 1:length(x))
    checkbounds(d, 1:length(x))
    checkbounds(e, 1:length(x))
    @aliasscope for i in 1:length(x)
        x[i] = Const(b)[i] + Const(d)[i] * Const(d)[i]
        s471s()
        b[i] = Const(c)[i] + Const(d)[i] * Const(e)[i]
    end
    return nothing
end

function s471_inbounds(x::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector)
    checkbounds(x, 1:length(x))
    checkbounds(b, 1:length(x))
    checkbounds(c, 1:length(x))
    checkbounds(d, 1:length(x))
    checkbounds(e, 1:length(x))
    @inbounds for i in 1:length(x)
        x[i] = b[i] + d[i] * d[i]
        s471s()
        b[i] = c[i] + d[i] * e[i]
    end
    return nothing
end

function s471_inbounds_const(x::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector, e::AbstractVector)
    checkbounds(x, 1:length(x))
    checkbounds(b, 1:length(x))
    checkbounds(c, 1:length(x))
    checkbounds(d, 1:length(x))
    checkbounds(e, 1:length(x))
    @aliasscope @inbounds for i in 1:length(x)
        x[i] = Const(b)[i] + Const(d)[i] * Const(d)[i]
        s471s()
        b[i] = Const(c)[i] + Const(d)[i] * Const(e)[i]
    end
    return nothing
end

# s481 - non-local goto's
struct NegativeValueException <: Exception end

function s481(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    checkbounds(d, 1:length(a))
    for i in 1:length(a)
        if d[i] < 0.0
            throw(NegativeValueException())
        end
        a[i] += b[i] * c[i]
    end
    return nothing
end

function s481_const(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    checkbounds(d, 1:length(a))
    @aliasscope for i in 1:length(a)
        if Const(d)[i] < 0.0
            throw(NegativeValueException())
        end
        a[i] += Const(b)[i] * Const(c)[i]
    end
    return nothing
end

function s481_inbounds(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    checkbounds(d, 1:length(a))
    @inbounds for i in 1:length(a)
        if d[i] < 0.0
            throw(NegativeValueException())
        end
        a[i] += b[i] * c[i]
    end
    return nothing
end

function s481_inbounds_const(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    checkbounds(d, 1:length(a))
    @aliasscope @inbounds for i in 1:length(a)
        if Const(d)[i] < 0.0
            throw(NegativeValueException())
        end
        a[i] += Const(b)[i] * Const(c)[i]
    end
    return nothing
end

# s482 - non-local goto's
function s482(a::AbstractVector, b::AbstractVector, c::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    for i in 1:length(a)
        a[i] += b[i] * c[i]
        if c[i] > b[i]
            break
        end
    end
    return nothing
end

function s482_const(a::AbstractVector, b::AbstractVector, c::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    @aliasscope for i in 1:length(a)
        a[i] += Const(b)[i] * Const(c)[i]
        if Const(c)[i] > Const(b)[i]
            break
        end
    end
    return nothing
end

function s482_inbounds(a::AbstractVector, b::AbstractVector, c::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    @inbounds for i in 1:length(a)
        a[i] += b[i] * c[i]
        if c[i] > b[i]
            break
        end
    end
    return nothing
end

function s482_inbounds_const(a::AbstractVector, b::AbstractVector, c::AbstractVector)
    checkbounds(a, 1:length(a))
    checkbounds(b, 1:length(a))
    checkbounds(c, 1:length(a))
    @aliasscope @inbounds for i in 1:length(a)
        a[i] += Const(b)[i] * Const(c)[i]
        if Const(c)[i] > Const(b)[i]
            break
        end
    end
    return nothing
end

