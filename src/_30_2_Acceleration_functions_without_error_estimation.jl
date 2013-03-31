#!/usr/bin/env julia
#GSL Julia wrapper
#(c) 2013 Jiahao Chen <jiahao@mit.edu>
########################################################
# 30.2 Acceleration functions without error estimation #
########################################################
export gsl_sum_levin_utrunc_alloc, gsl_sum_levin_utrunc_free,
       gsl_sum_levin_utrunc_accel


# This function allocates a workspace for a Levin u-transform of n terms,
# without error estimation.  The size of the workspace is O(3n).
# 
#   Returns: Ptr{Void}
#XXX Unknown output type Ptr{gsl_sum_levin_utrunc_workspace}
#XXX Coerced type for output Ptr{Void}
function gsl_sum_levin_utrunc_alloc{gsl_int<:Integer}(n::gsl_int)
    ccall( (:gsl_sum_levin_utrunc_alloc, :libgsl), Ptr{Void}, (Csize_t, ),
        n )
end


# This function frees the memory associated with the workspace w.
# 
#   Returns: Void
#XXX Unknown input type w::Ptr{gsl_sum_levin_utrunc_workspace}
#XXX Coerced type for w::Ptr{Void}
function gsl_sum_levin_utrunc_free(w::Ptr{Void})
    ccall( (:gsl_sum_levin_utrunc_free, :libgsl), Void, (Ptr{Void}, ), w )
end


# This function takes the terms of a series in array of size array_size and
# computes the extrapolated limit of the series using a Levin u-transform.
# Additional working space must be provided in w.  The extrapolated sum is
# stored in sum_accel.  The actual term-by-term sum is returned in
# w->sum_plain. The algorithm terminates when the difference between two
# successive extrapolations reaches a minimum or is sufficiently small. The
# difference between these two values is used as estimate of the error and is
# stored in abserr_trunc.  To improve the reliability of the algorithm the
# extrapolated values are replaced by moving averages when calculating the
# truncation error, smoothing out any fluctuations.
# 
#   Returns: Cint
#XXX Unknown input type w::Ptr{gsl_sum_levin_utrunc_workspace}
#XXX Coerced type for w::Ptr{Void}
function gsl_sum_levin_utrunc_accel{gsl_int<:Integer}(array::Ptr{Cdouble}, array_size::gsl_int, w::Ptr{Void})
    sum_accel = convert(Ptr{Cdouble}, Array(Cdouble, 1))
    abserr_trunc = convert(Ptr{Cdouble}, Array(Cdouble, 1))
    gsl_errno = ccall( (:gsl_sum_levin_utrunc_accel, :libgsl), Cint,
        (Ptr{Cdouble}, Csize_t, Ptr{Void}, Ptr{Cdouble}, Ptr{Cdouble}), array,
        array_size, w, sum_accel, abserr_trunc )
    if gsl_errno!= 0 throw(GSL_ERROR(gsl_errno)) end
    return unsafe_ref(sum_accel) ,unsafe_ref(abserr_trunc)
end