with text_io;                            use text_io;
with Standard_Integer_Numbers;           use Standard_Integer_Numbers;
with Standard_Floating_Numbers;          use Standard_Floating_Numbers;
with Double_Double_Numbers;              use Double_Double_Numbers;
with Quad_Double_Numbers;                use Quad_Double_Numbers;
with Standard_Complex_Numbers;
with DoblDobl_Complex_Numbers;
with QuadDobl_Complex_Numbers;
with Standard_Complex_Vectors;
with Standard_Complex_VecVecs;
with DoblDobl_Complex_Vectors;
with DoblDobl_Complex_VecVecs;
with QuadDobl_Complex_Vectors;
with QuadDobl_Complex_VecVecs;

package Convergence_Radius_Estimates is

-- DESCRIPTION :
--   According to the ratio theorem of Fabry, the ratio of the coefficients
--   of a power series gives the convergence radius for the series
--   and also the location of the singularity.

  function Is_Zero ( z : Standard_Complex_Numbers.Complex_Number )
                   return boolean;
  function Is_Zero ( z : DoblDobl_Complex_Numbers.Complex_Number )
                   return boolean;
  function Is_Zero ( z : QuadDobl_Complex_Numbers.Complex_Number )
                   return boolean;

  -- DESCRIPTION :
  --   Returns true if both the real and imaginary part of z are zero,
  --   or less than the machine precision.

  procedure Fabry ( c : in Standard_Complex_Vectors.Vector;
                    z : out Standard_Complex_Numbers.Complex_Number;
                    e : out double_float; fail : out boolean;
                    offset : in integer32 := 0 );
  procedure Fabry ( c : in DoblDobl_Complex_Vectors.Vector;
                    z : out DoblDobl_Complex_Numbers.Complex_Number;
                    e : out double_double; fail : out boolean;
                    offset : in integer32 := 0 );
  procedure Fabry ( c : in QuadDobl_Complex_Vectors.Vector;
                    z : out QuadDobl_Complex_Numbers.Complex_Number;
                    e : out quad_double; fail : out boolean;
                    offset : in integer32 := 0 );

  -- DESCRIPTION :
  --   Applies the ratio theorem of Fabry to return the singular point
  --   of the series with coefficients given in c.

  -- REQUIRED : c'last >= 2.

  -- ON ENTRY:
  --   c            the coefficients of a power series, starting at index 0
  --                and ending at the degree of truncation;
  --   offset       by default 0, but for longer series, to coincide
  --                with the pole in the Pade approximants for a linear
  --                denominator, offset should be set to 2, in particular:
  --                for [L,1], the pole is c(L)/c(L+1), while the degree
  --                of truncation is L+1+2 (L+M+2 in general),
  --                so z = c(c'last-3)/c(c'last-2), if c(c'last-2) /= 0.

  -- ON RETURN :
  --   z            the quotient of c(c'last-1-offset)/c(c'last-offset),
  --                if c(c'last-offset) /= zero;
  --   e            error estimate of the difference between
  --                |c(c'last-1)/c(c'last) - c(c'last-2)/c(c'last-1)|,
  --                only if fail is false;
  --   fail         true if c(c'last-offset) equals zero, false otherwise.

  procedure Fabry ( c : in Standard_Complex_VecVecs.VecVec;
                    z : out Standard_Complex_Numbers.Complex_Number;
                    r : out double_float;
                    e : out double_float; fail : out boolean;
                    offset : in integer32 := 0;
                    verbose : in boolean := true );
  procedure Fabry ( file : in file_type;
                    c : in Standard_Complex_VecVecs.VecVec;
                    z : out Standard_Complex_Numbers.Complex_Number;
                    r : out double_float;
                    e : out double_float; fail : out boolean;
                    offset : in integer32 := 0;
                    verbose : in boolean := true );
  procedure Fabry ( c : in DoblDobl_Complex_VecVecs.VecVec;
                    z : out DoblDobl_Complex_Numbers.Complex_Number;
                    r : out double_double;
                    e : out double_double; fail : out boolean;
                    offset : in integer32 := 0;
                    verbose : in boolean := true );
  procedure Fabry ( file : in file_type;
                    c : in DoblDobl_Complex_VecVecs.VecVec;
                    z : out DoblDobl_Complex_Numbers.Complex_Number;
                    r : out double_double;
                    e : out double_double; fail : out boolean;
                    offset : in integer32 := 0;
                    verbose : in boolean := true );
  procedure Fabry ( c : in QuadDobl_Complex_VecVecs.VecVec;
                    z : out QuadDobl_Complex_Numbers.Complex_Number;
                    r : out quad_double;
                    e : out quad_double; fail : out boolean;
                    offset : in integer32 := 0;
                    verbose : in boolean := true );
  procedure Fabry ( file : in file_type;
                    c : in QuadDobl_Complex_VecVecs.VecVec;
                    z : out QuadDobl_Complex_Numbers.Complex_Number;
                    r : out quad_double;
                    e : out quad_double; fail : out boolean;
                    offset : in integer32 := 0;
                    verbose : in boolean := true );

  -- DESCRIPTION :
  --   Applies the ratio theorem of Fabry to return the smallest singular
  --   point of the series vector with coefficients given in c.

  -- REQUIRED : for all k in c'range: c(k)'last >= 2.

  -- ON ENTRY:
  --   file         for write results to if verbose;
  --   c            the coefficients of a vector of power series;
  --   offset       by default 0, but for longer series, to coincide
  --                with the pole in the Pade approximants for a linear
  --                denominator, offset should be set to 1;
  --   verbose      writes all results for all series if true,
  --                to file or to standard output if no file provided.

  -- ON RETURN :
  --   z            the smallest quotient over all series in c,
  --                if fail is false;
  --   r            the radius of z if fail is false;
  --   e            the difference between two consecutive ratios;
  --                only if fail is false;
  --   fail         true if the last coefficient of all series in c is zero,
  --                false otherwise.

end Convergence_Radius_Estimates;
