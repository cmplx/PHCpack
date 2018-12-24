with Standard_Integer_Numbers;          use Standard_Integer_Numbers;
with C_Integer_Arrays;                  use C_Integer_Arrays;
with C_Double_Arrays;                   use C_Double_Arrays;

function use_padcon ( job : integer32;
                      a : C_intarrs.Pointer;
                      b : C_intarrs.Pointer;
                      c : C_dblarrs.Pointer ) return integer32;

-- DESCRIPTION :
--   Manages the homotopy continuatin parameter for the Pade trackers.

-- ON ENTRY :
--   job   =   0 : gives homotopy continuation parameters default values;
--   job   =   1 : clears the homotopy continuation parameters;
--   job   =   2 : given in a[0] is a number k between 1 and 12,
--                 on return in b[0] or c is the value of the k-th
--                 homotopy continuation parameter, as follows:
--                 if k = 1, then c[0] contains the real part of gamma,
--                 and c[1] contains the imaginary part of gamma;
--                 if k = 2, then b[0] is the degree of Pade numerator,
--                 if k = 3, then b[0] is the degree of Pade denominator,
--                 if k = 4, then c[0] is the maximum step size,
--                 if k = 5, then c[0] is the minimum step size,
--                 if k = 6, then c[0] is the series step factor,
--                 if k = 7, then c[0] is the pole radius step factor,
--                 if k = 8, then c[0] is the predictor residual tolerance,
--                 if k = 9, then c[0] is the corrector residual tolerance,
--                 if k = 10, then c[0] is the zero coefficient tolerance,
--                 if k = 11, then b[0] is the maximum #corrector steps,
--                 if k = 12, then b[0] is the maximum #steps on a path.
--   job   =   3 : given in a[0] is a number k between 1 and 12,
--                 and in b[0] or c the value of the k-th parameter,
--                 sets the value of the k-th parameter to c[0],
--                 if k = 1, then c[0] must contain the real part
--                 of gamma and c[1] the imaginary part of gamma,
--                 if k = 2, then b[0] is the degree of Pade numerator,
--                 if k = 3, then b[0] is the degree of Pade denominator,
--                 if k = 4, then c[0] is the maximum step size,
--                 if k = 5, then c[0] is the minimum step size,
--                 if k = 6, then c[0] is the series step factor,
--                 if k = 7, then c[0] is the pole radius step factor,
--                 if k = 8, then c[0] is the predictor residual tolerance,
--                 if k = 9, then c[0] is the corrector residual tolerance,
--                 if k = 10, then c[0] is the zero coefficient tolerance,
--                 if k = 11, then b[0] is the maximum #corrector steps,
--                 if k = 12, then b[0] is the maximum #steps on a path.
--   job   =   4 : tracks the paths with the Pade predictors,
--                 for an artificial parameter homotopy,
--                 the value of a[0] is 0, 1, 2, for double, double double,
--                 or quad double precision, with target, start system, and
--                 start solutions defined via PHCpack_Operations,
--                 in a[1] is the number of characters of the name of the
--                 output file, if a[1] is zero, then no output is written,
--                 otherwise, the characters of the output file name are
--                 defined by b, in a[2] is the value of the verbose flag;
--                 on return are the end of the solution paths in the
--                 double, double double, or quad double solutions container.
--   job   =   5 : initializes homotopy for a step-by-step execution
--                 in double, double double, or quad double precision,
--                 depending on whether a[0] is 0, 1, or 2,
--                 the verbose option is in b[0], before execution,
--                 the homotopy continuation parameters with job 0 is set,
--                 target and start system are defined in PHCpack_Operations.
--   job   =   6 : initializes next start solution in series-Pade tracker,
--                 in double, double double, or quad double precision,
--                 depending on whether a[0] is 0, 1, or 2,
--                 the index of the solution is a[1],
--                 the verbose option is in b[0],
--                 on return in a[0] is the failure code of the retrieval;
--   job   =   7 : runs the next predict-correct step in series-Pade tracker,
--                 in double, double double, or quad double precision,
--                 depending on whether a[0] is 0, 1, or 2,
--                 the verbose option is in b[0],
--                 on return in a[0] is the failure code of the next
--                 predict-correct step;
--   job   =   8 : gets the current solution at index a[1], 
--                 in double, double double, or quad double precision,
--                 depending on whether a[0] is 0, 1, or 2,
--                 the verbose option is in b[0],
--                 the current solution is placed at position index in
--                 the solutions container and the failure code of the
--                 placement is returned in a[0];
--   job   =   9 : clears the data in the series-pade tracker,
--                 in double, double double, or quad double precision,
--                 depending on whether a[0] is 0, 1, or 2.

-- ON RETURN :
--   0 if the operation was successful, otherwise something went wrong,
--   or job not in the right range.
