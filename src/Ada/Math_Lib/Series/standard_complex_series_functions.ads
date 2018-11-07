with Standard_Integer_Numbers;          use Standard_Integer_Numbers;
with Standard_Floating_Numbers;         use Standard_Floating_Numbers;
with Standard_Complex_Numbers;          use Standard_Complex_Numbers;
with Standard_Complex_Series;           use Standard_Complex_Series;

package Standard_Complex_Series_Functions is

-- DESCRIPTION :
--   Functions are provided to evaluate and shift series 
--   in standard double precision.

  function Eval ( s : Series; t : double_float ) return Complex_Number;
  function Eval ( s : Series; t : Complex_Number ) return Complex_Number;

  -- DESCRIPTION :
  --   Returns the value c(0) + c(1)*t + .. + c(s.deg)*t**s.deg,
  --   where c abbreviates the coefficient vector s.cff.

  function Eval ( s : Link_to_Series;
                  t : double_float ) return Complex_Number;
  function Eval ( s : Link_to_Series;
                  t : Complex_Number ) return Complex_Number;

  -- DESCRIPTION :
  --   Returns zero if s is null, otherwise,
  --   returns the value c(0) + c(1)*t + .. + c(s.deg)*t**s.deg,
  --   where c abbreviates the coefficient vector s.cff.

  function Eval ( s : Series; t : double_float;
                  a,b : integer32 ) return Complex_Number;
  function Eval ( s : Series; t : Complex_Number;
                  a,b : integer32 ) return Complex_Number;

  -- DESCRIPTION :
  --   Evaluates the series using a as the numerator and b as the
  --   numerator of the power for t, so the series starts with
  --   c(0)*t**(a/b) + c(1)*t**((1+a)/b) + ...

  -- REQUIRED : b /= 0 and t /= 0.0 if a < 0.

  function Eval ( s : Link_to_Series; t : double_float;
                  a,b : integer32 ) return Complex_Number;
  function Eval ( s : Link_to_Series; t : Complex_Number;
                  a,b : integer32 ) return Complex_Number;

  -- DESCRIPTION :
  --   Returns zero if s is null, otherwise,
  --   evaluates the series using a as the numerator and b as the
  --   numerator of the power for t, so the series starts with
  --   c(0)*t**(a/b) + c(1)*t**((1+a)/b) + ...

  -- REQUIRED : b /= 0 and t /= 0.0 if a < 0.

-- ORDER and FILTER :

  function Order ( s : Series; tol : double_float := 0.0 ) return integer32;
  function Order ( s : Link_to_Series;
                   tol : double_float := 0.0 ) return integer32;

  -- DESCRIPTION :
  --   Returns the smallest integer k in the range 0..s.deg
  --   for which AbsVal(s.cff(k)) > tol.
  --   If all coefficients are less than tol, then s.deg+1 is returned.
  --   If the s = null, then -1 is returned.

  procedure Filter ( s : in out Series; tol : in double_float );
  procedure Filter ( s : in out Link_to_Series; tol : in double_float );

  -- DESCRIPTION :
  --   All coefficients of s that are less than tol in magnitude 
  --   are set to zero.

-- SHIFT OPERATORS :

  function Shift ( s : Series; c : double_float ) return Series;
  function Shift ( s : Series; c : Complex_Number ) return Series;

  -- DESCRIPTION :
  --   The series on return has the coefficients of the series s,
  --   where the series parameter is replaced by t-c.

  function Shift ( s : Link_to_Series;
                   c : double_float ) return Link_to_Series;
  function Shift ( s : Link_to_Series;
                   c : Complex_Number ) return Link_to_Series;

  -- DESCRIPTION :
  --   if s is null, then null is returned, otherwise,
  --   the series on return has the coefficients of the series s,
  --   where the series parameter is replaced by t-c.

  procedure Shift ( s : in out Series; c : in double_float );
  procedure Shift ( s : in out Series; c : in Complex_Number );

  -- DESCRIPTION :
  --   On return, s = Shift(s,c).

  procedure Shift ( s : in out Link_to_Series; c : in double_float );
  procedure Shift ( s : in out Link_to_Series; c : in Complex_Number );

  -- DESCRIPTION :
  --   On return, s = Shift(s,c).

end Standard_Complex_Series_Functions;
