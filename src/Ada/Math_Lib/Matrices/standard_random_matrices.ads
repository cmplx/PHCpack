with Standard_Natural_Numbers;           use Standard_Natural_Numbers;
with Standard_Integer_Numbers;           use Standard_Integer_Numbers;
with Standard_Floating_Numbers;          use Standard_Floating_Numbers;
with Boolean_Matrices;
with Standard_Integer_Matrices;
with Standard_Integer64_Matrices;
with Standard_Floating_Matrices;
with Standard_Complex_Matrices;

package Standard_Random_Matrices is

-- DESCRIPTION :
--   Offers routines to generate random Boolean, standard integer,
--   floating and complex matrices.

  function Random_Matrix
             ( dim : natural32; prb : double_float := 0.5 )
             return Boolean_Matrices.Matrix;

  -- DESCRIPTION :
  --   Returns a square Boolean matrix with randomly generated
  --   Boolean values, occurring with probability prb,
  --   as the result of dim*dim flips with a loaded coin.
  --   The value of prb is the probability of getting true.
  --   Setting prb to 1.0 will result in a matrix of true values,
  --   setting prb to 0.0 will result in a matrix of false values.

  function Random_Matrix
             ( rows,cols : natural32; prb : double_float := 0.5 )
             return Boolean_Matrices.Matrix;

  -- DESCRIPTION :
  --   Given in rows and cols the number of rows and columns
  --   respectively, returns a Boolean matrix with the given number
  --   of rows and columns.  The entries in the matrix are 
  --   randomly generated Boolean values, generated with
  --   probability prb, generated by flipping a loaded coin.
  --   The value of prb is the probability of getting true.
  --   Setting prb to 1.0 will result in a matrix of true values,
  --   setting prb to 0.0 will result in a matrix of false values.

  function Random_Matrix ( n,m : natural32; low,upp : integer32 )
                         return Standard_Integer_Matrices.Matrix;
  function Random_Matrix ( n,m : natural32; low,upp : integer64 )
                         return Standard_Integer64_Matrices.Matrix;

  -- DESCRIPTION : 
  --   Returns a matrix of range 1..n,1..m with entries between low and upp.

  function Random_Matrix ( n,m : natural32 )
                         return Standard_Floating_Matrices.Matrix;

  -- DESCRIPTION :
  --   Returns a matrix of range 1..n,1..m with random floating numbers.

  function Orthogonalize ( mat : Standard_Floating_Matrices.Matrix )
                         return Standard_Floating_Matrices.Matrix;

  -- DESCRIPTION :
  --   Returns the orthogonal matrix with the same column span as mat.

  function Random_Orthogonal_Matrix
                ( n,m : natural32 ) return Standard_Floating_Matrices.Matrix;

  -- DESCRIPTION :
  --   Returns a matrix of range 1..n,1..m with random floating numbers,
  --   where the columns are orthogonal w.r.t. each other.

  function Random_Matrix ( n,m : natural32 )
                         return Standard_Complex_Matrices.Matrix;

  -- DESCRIPTION :
  --   Returns a matrix of range 1..n,1..m with random complex numbers.

  function Random_Matrix ( low_row,upp_row,low_col,upp_col : integer32 )
                         return Standard_Complex_Matrices.Matrix;

  -- DESCRIPTION :
  --   Returns a random matrix with row range low_row..upp_row,
  --   and column range low_col..upp_col.

  function Orthogonalize ( mat : Standard_Complex_Matrices.Matrix )
                         return Standard_Complex_Matrices.Matrix;

  -- DESCRIPTION :
  --   Returns the orthogonal matrix with the same column span as mat.

  function Random_Orthogonal_Matrix
                ( n,m : natural32 ) return Standard_Complex_Matrices.Matrix;

  -- DESCRIPTION :
  --   Returns a matrix of range 1..n,1..m with random complex numbers,
  --   where the columns are orthogonal w.r.t. each other.

end Standard_Random_Matrices;
