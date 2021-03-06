#!/usr/bin/env julia
#GSL Julia wrapper
#(c) 2013 Jiahao Chen <jiahao@mit.edu>
#############################################
# 20.12 The Levy alpha-Stable Distributions #
#############################################
export ran_levy




# This function returns a random variate from the Levy symmetric stable
# distribution with scale c and exponent alpha.  The symmetric stable
# probability distribution is defined by a Fourier transform,
# p(x) = {1 \over 2 \pi} \int_{-\infty}^{+\infty} dt \exp(-it x - |c t|^alpha)
# There is no explicit solution for the form of p(x) and the library does not
# define a corresponding pdf function.  For \alpha = 1 the distribution reduces
# to the Cauchy distribution.  For \alpha = 2 it is a Gaussian distribution
# with  \sigma = \sqrt{2} c.  For \alpha < 1 the tails of the distribution
# become extremely wide.          The algorithm only works for  0 < alpha <= 2.
# 
#   Returns: Cdouble
function ran_levy(r::Ref{gsl_rng}, c::Real, alpha::Real)
    ccall( (:gsl_ran_levy, libgsl), Cdouble, (Ref{gsl_rng}, Cdouble,
        Cdouble), r, c, alpha )
end
