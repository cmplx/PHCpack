with Standard_Natural_Numbers;          use Standard_Natural_Numbers;
with Standard_Complex_Poly_Systems;
with Standard_Complex_Laur_Systems;
with Standard_Complex_Solutions;

package Standard_Witness_Solutions is

-- DESCRIPTION :
--   This package stores the witness set representation for the
--   numerical irreducible decomposition of the solution set of
--   an ordinary or a Laurent polynomial system.
--   The data stored by this package is computed by the procedures
--   in the embeddings_and_cascades package, which defines the
--   blackbox solver for polynomial systems, as called by phc -B,
--   computed in standard double precision.

-- CONSTRUCTORS :

  procedure Initialize ( topdim : in natural32 );

  -- DESCRIPTION :
  --   Initialized the package with the top dimension in topdim.

  procedure Save_Embedded_System
              ( p : in Standard_Complex_Poly_Systems.Poly_Sys;
                k : in natural32 );
  procedure Save_Embedded_System
              ( p : in Standard_Complex_Laur_Systems.Laur_Sys;
                k : in natural32 );

  -- DESCRIPTION :
  --   Stores the embedded system p at position k in the sequence
  --   of the systems in the cascade used to compute all witness points.
  --   A deep copy of p is stored.

  -- REQUIRED :
  --   The procedure Initialize() was executed with top dimension topdim
  --   and k is in the range 0..topdim.

  procedure Save_Witness_Points
              ( s : in Standard_Complex_Solutions.Solution_List;
                k : in natural32 );

  -- DESCRIPTION :
  --   Stores the witness points s, which contains generic points on
  --   the solution set of dimension k and which satisfies the embedded
  --   polynomial system at dimension k.
  --   A deep copy of s is stored.

  -- REQUIRED :
  --   The procedure Initialize() was executed with top dimension topdim
  --   and k is in the range 0..topdim.

-- SELECTORS :

  function Load_Embedded_System ( k : natural32 )
              return Standard_Complex_Poly_Systems.Link_to_Poly_Sys;
  function Load_Embedded_System ( k : natural32 )
              return Standard_Complex_Laur_Systems.Link_to_Laur_Sys;

  -- DESCRIPTION :
  --   Returns the embedded system at position k in the sequence
  --   of the systems in the cascade used to compute all witness points.
  --   A pointer to the system is returned.

  -- REQUIRED :
  --   The procedure Initialize() was executed with top dimension topdim
  --   and k is in the range 0..topdim.
  --   If Save was not done at level k, then the null pointer is returned.

  function Load_Witness_Points ( k : natural32 )
              return Standard_Complex_Solutions.Solution_List;

  -- DESCRIPTION :
  --   Returns the witness points saved at position k.
  --   A pointer to the first solution in the list is returned.

  -- REQUIRED :
  --   The procedure Initialize() was executed with top dimension topdim
  --   and k is in the range 0..topdim.
  --   If Save was not done at level k, then the null pointer is returned.

-- DESTRUCTOR :

  procedure Clear;

  -- DESCRIPTION :
  --   Deallocates the data stored in the package.

end Standard_Witness_Solutions;
