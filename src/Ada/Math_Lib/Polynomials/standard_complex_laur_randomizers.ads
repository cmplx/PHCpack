with Standard_Complex_Laurentials;       use Standard_Complex_Laurentials;
with Standard_Complex_Laur_Systems;      use Standard_Complex_Laur_Systems;

package Standard_Complex_Laur_Randomizers is

-- DESCRIPTION :
--   This package offers routines for `randomizing' polynomials:
--   the monomial structure remains the same,
--   but random complex coefficients will be generated.

  function Complex_Randomize ( p : Poly ) return Poly;
  function Complex_Randomize ( p : Laur_Sys ) return Laur_Sys;

  -- DESCRIPTION :
  --   The real and imaginary parts of the complex random coefficients 
  --   lie in [-1.0,1.0].

  function Complex_Randomize1 ( p : Poly ) return Poly;
  function Complex_Randomize1 ( p : Laur_Sys ) return Laur_Sys;

  -- DESCRIPTION :
  --   The generated random complex coefficients have modulus 1.

end Standard_Complex_Laur_Randomizers;
