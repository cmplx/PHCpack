with Standard_Integer_Numbers;          use Standard_Integer_Numbers;
with C_Integer_Arrays;                  use C_Integer_Arrays;
with C_Double_Arrays;                   use C_Double_Arrays;

function use_c2fac ( job : integer32;
                     a : C_intarrs.Pointer;
		     b : C_intarrs.Pointer;
                     c : C_dblarrs.Pointer ) return integer32;

-- DESCRIPTION :
--   Provides a gateway from C to the operations in PHCpack
--   to factor pure dimensional solution sets of polynomial systems,
--   using monodromy certified by linear traces.

-- ON ENTRY :
--   job    =  0 : display the menu of all available options;
--   job    =  1 : prompts for a witness set in standard double precision,
--                 stores the system in the standard systems container,
--                 and its solutions in the standard solutions container,
--                 and returns in a the dimension of the ambient space
--                 and in b the following two numbers:
--                   b[0] : dimension of the solution set;
--                   b[1] : degree of the solution set.
--   job    =  2 : takes the system and the solutions from the containers
--                 in standard double precision,
--                 and initializes the sampling machine, on input,
--                 the dimension of the witness set must be in a;
--   job    =  3 : assigns the coefficient c[0] + c[1]*I to the
--                 b-th coefficient of the a-th slice;
--   job    =  4 : stores the c[0] + c[1]*I as random gamma constant
--                 for the a-th equation, in standard double precision;
--   job    =  5 : compute a new standard witness set on the new slices;
--   job    =  6 : swaps standard slices and solution sets to turn back;
--   job    =  7 : copy embedded system from sampler to systems container,
--                 for coefficients in standard double precision;
--   job    =  8 : copy first standard solution list to container;
--   job    =  9 : put solutions with index in a from monodromy grid
--                 in the solutions container (companion to job = 11);
--   job    = 10 : initializes Monodromy_Permutations with two numbers:
--                   a[0] : number of monodromy loops,
--                   b[0] : degree of the solution component to factor;
--   job    = 11 : store solutions in container in standard double
--                 precision to Standard_Monodromy_Permutations;
--   job    = 12 : compute permutation by last stored solution list,
--                 in standard double precision,
--                 and return this new permutation in b;
--   job    = 13 : updates decomposition with a new permutation,
--                 computed on data in standard double precision,
--                 a[0] must contain the dimension and b the permutation;
--   job    = 14 : writes the standard double precision decomposition;
--          = 15 : applies the linear trace to certify the decomposition,
--                 in standard double precision;
--   job    = 16 : returns in c the diagnostics of the standard trace grid;
--          = 17 : returns in c difference between trace and actual sum,
--                 computed in standard double precision;
--   job    = 18 : finds the index of a solution label in a slice,
--                 in standard double precision,
--                 on entry: a[0] is label to a solution,
--                           a[1] is the number of a slice;
--                 on return: b is index to solution if label occurs,
--                            otherwise, b is zero;
--   job    = 19 : initialize number of slices in Standard_Sampling_Operations
--                 with the content of a;
--   job    = 20 : adds a new slice to Sampling_Operations, 
--                 where a[0] = total number of doubles in the slices;
--                       a[1] = dimension of the solution set;
--                       a[2] = the ambient dimension;
--                 the coefficients are in c.
--   job    = 21 : returns in c the coefficients of a slice,
--                 where a[0] = total number of doubles in the slices;
--                       a[1] = dimension of the solution set;
--                       a[2] = the ambient dimension;
--                 the index to the slice is in b;
--   job    = 22 : sets the target slices to the a-th slice stored 
--                 in Standard_Sampling_Operations.
--   job    = 23 : completes one loop, sampling from one solution,
--                 in standard double precision,
--                 where a[0] = index for the starting hyperplane sections;
--                       a[1] = index for the target hyperplanes sections;
--                   and b = label of the start solution;
--                 on return b contains the label of the matching solution
--                 in the list at the target hyperplane sections.
--   job    = 24 : reads a witness set in standard double precision from file,
--                 on input in b is the file name, and in a the
--                          number of characters in the file name,
--                 stores the system in the systems container,
--                 and its solutions in the solutions container,
--                 and returns in a the dimension of the ambient space
--                 and in b the following two numbers:
--                   b[0] : dimension of the solution set;
--                   b[1] : degree of the solution set;
--   job    = 25 : writes a witness set in standard double precision to file,
--                 on input in b is the file name, and in a the
--                          number of characters in the file name,
--                 the system and the solutions are taken from containers.
--   job    = 26 : returns in a the number of irreducible factors in the
--                 the irreducible decomposition, in standard double preicsion;
--   job    = 27 : given in a an index k to an irreducible component,
--                 returns in a the degree of the k-th component and
--                 in b the labels of the points that span the k-th
--                 component in the standard irreducible decomposition;
--   job    = 28 : makes the factorization with standard doubles go silent;
--   job    = 29 : returns in c the real and imaginary parts of
--                 a randomly generated complex number of modulus one,
--                 generated in standard double precision.
--   job    = 30 : makes the factorization with standard doubles go verbose.
--
-- ANALOGUE OPERATIONS FOR DOUBLE DOUBLE PRECISION :
--
--   job    = 31 : prompts for a witness set in double double precision
--                 stores the system in the dobldobl systems container,
--                 and its solutions in the dobldobl solutions container,
--                 and returns in a the dimension of the ambient space
--                 and in b the following two numbers:
--                   b[0] : dimension of the solution set;
--                   b[1] : degree of the solution set.
--   job    = 32 : takes the system and the solutions from the containers
--                 for double double precision
--                 and initializes the sampling machine, on input,
--                 the dimension of the witness set must be in a.
--   job    = 33 : assigns the double double coefficient, stored in the first
--                 four doubles in c, the real and imaginary parts, to the
--                 b-th coefficient of the a-th slice;
--   job    = 34 : uses the data in c to store the random gamma constant
--                 for the a-th equation, in double double precision;
--   job    = 35 : compute a new dobldobl witness set on the new slices;
--          = 36 : swaps dobldobl slices and solution sets to turn back;
--          = 37 : copy embedded system from sampler to systems container,
--                 for coefficients in double double precision;
--   job    = 38 : copy first dobldobl solution list to container;
--          = 39 : put solutions with index in a from monodromy grid
--                 in the dobldobl solutions container (companion to job = 11);
--   job    = 40 : init DoblDobl_Monodromy_Permutations with two numbers:
--                   a[0] : number of monodromy loops,
--                   b[0] : degree of the solution component to factor;
--   job    = 41 : store solutions in container in double double
--                 precision to DoblDobl_Monodromy_Permutations;
--   job    = 42 : compute permutation by last stored solution list,
--                 in double double precision,
--                 and return this new permutation in b;
--   job    = 43 : updates decomposition with a new permutation,
--                 computed on data in double double precision,
--                 a[0] must contain the dimension and b the permutation;
--   job    = 44 : writes the double double precision decomposition;
--          = 45 : applies the linear trace to certify the decomposition,
--                 in double double precision;
--   job    = 46 : returns in c the diagnostics of the dobldobl trace grid;
--          = 47 : returns in c difference between trace and actual sum,
--                 computed in double double precision;
--   job    = 48 : finds the index of a solution label in a slice,
--                 in double double precision,
--                 on entry: a[0] is label to a solution,
--                           a[1] is the number of a slice;
--                 on return: b is index to solution if label occurs,
--                            otherwise, b is zero;
--   job    = 49 : initialize number of slices in DoblDobl_Sampling_Operations
--                 with the content of a;
--   job    = 52 : sets the target slices to the a-th slice stored 
--                 in DoblDobl_Sampling_Operations.
--   job    = 53 : completes one loop, sampling from one solution,
--                 in double double precision,
--                 where a[0] = index for the starting hyperplane sections;
--                       a[1] = index for the target hyperplanes sections;
--                   and b = label of the start solution;
--                 on return b contains the label of the matching solution
--                 in the list at the target hyperplane sections.
--   job    = 54 : reads a witness set in double double precision from file,
--                 on input in b is the file name, and in a the
--                          number of characters in the file name,
--                 stores the system in the systems container,
--                 and its solutions in the solutions container,
--                 and returns in a the dimension of the ambient space
--                 and in b the following two numbers:
--                   b[0] : dimension of the solution set;
--                   b[1] : degree of the solution set;
--   job    = 55 : writes a witness set in double double precision to file,
--                 on input in b is the file name, and in a the
--                          number of characters in the file name,
--                 the system and the solutions are taken from containers.
--   job    = 56 : returns in a the number of irreducible factors in the
--                 the irreducible decomposition, in double double preicsion;
--   job    = 57 : given in a an index k to an irreducible component,
--                 returns in a the degree of the k-th component and
--                 in b the labels of the points that span the k-th
--                 component in the dobldobl irreducible decomposition.
--   job    = 58 : makes the factorization with double doubles go silent;
--   job    = 59 : returns in c the real and imaginary parts of
--                 a randomly generated complex number of modulus one,
--                 generated in double double precision;
--   job    = 60 : makes the factorization with double doubles go verbose.
--
-- ANALOGUE OPERATIONS FOR QUAD DOUBLE PRECISION :
--
--   job    = 61 : prompts for a witness set in quad double precision,
--                 stores the system in the quaddobl systems container,
--                 and its solutions in the quaddobl solutions container,
--                 and returns in a the dimension of the ambient space
--                 and in b the following two numbers:
--                   b[0] : dimension of the solution set;
--                   b[1] : degree of the solution set.
--   job    = 62 : takes the system and the solutions from the containers
--                 for quad double precision
--                 and initializes the sampling machine, on input,
--                 the dimension of the witness set must be in a.
--   job    = 63 : assigns the quad double coefficient, stored in the first
--                 eight doubles in c, the real and imaginary parts, to the
--                 b-th coefficient of the a-th slice;
--   job    = 64 : uses the data in c to store the random gamma constant
--                 for the a-th equation, in quad double precision;
--   job    = 65 : compute a new quaddobl witness set on the new slices;
--   job    = 66 : swaps quaddobl slices and solution sets to turn back;
--   job    = 67 : copy embedded system from sampler to systems container,
--                 for coefficients in quad double precision;
--   job    = 68 : copy first quaddobl solution list to container;
--          = 69 : put solutions with index in a from monodromy grid
--                 in the quaddobl solutions container (companion to job = 11);
--   job    = 70 : init QuadDobl_Monodromy_Permutations with two numbers:
--                   a[0] : number of monodromy loops,
--                   b[0] : degree of the solution component to factor;
--   job    = 71 : store solutions in container in quad double
--                 precision to QuadDobl_Monodromy_Permutations;
--   job    = 72 : compute permutation by last stored solution list,
--                 in quad double precision,
--                 and return this new permutation in b;
--   job    = 73 : updates decomposition with a new permutation,
--                 computed on data in quad double precision,
--                 a[0] must contain the dimension and b the permutation;
--   job    = 74 : writes the quad double precision decomposition;
--   job    = 75 : applies the linear trace to certify the decomposition,
--                 in quad double precision;
--   job    = 76 : returns in c the diagnostics of the quaddobl trace grid;
--          = 77 : returns in c difference between trace and actual sum,
--                 computed in quad double precision;
--   job    = 78 : finds the index of a solution label in a slice,
--                 in quad double precision,
--                 on entry: a[0] is label to a solution,
--                           a[1] is the number of a slice;
--                 on return: b is index to solution if label occurs,
--                            otherwise, b is zero;
--   job    = 79 : initialize number of slices in QuadDobl_Sampling_Operations
--                 with the content of a;
--   job    = 82 : sets the target slices to the a-th slice stored 
--                 in QuadDobl_Sampling_Operations.
--   job    = 83 : completes one loop, sampling from one solution,
--                 in quad double precision,
--                 where a[0] = index for the starting hyperplane sections;
--                       a[1] = index for the target hyperplanes sections;
--                   and b = label of the start solution;
--                 on return b contains the label of the matching solution
--                 in the list at the target hyperplane sections.
--   job    = 84 : reads a witness set in quad double precision from file,
--                 on input in b is the file name, and in a the
--                          number of characters in the file name,
--                 stores the system in the systems container,
--                 and its solutions in the solutions container,
--                 and returns in a the dimension of the ambient space
--                 and in b the following two numbers:
--                   b[0] : dimension of the solution set;
--                   b[1] : degree of the solution set;
--   job    = 85 : writes a witness set in quad double precision to file,
--                 on input in b is the file name, and in a the
--                          number of characters in the file name,
--                 the system and the solutions are taken from containers.
--   job    = 86 : returns in a the number of irreducible factors in the
--                 the irreducible decomposition, in quad double preicsion;
--   job    = 87 : given in a an index k to an irreducible component,
--                 returns in a the degree of the k-th component and
--                 in b the labels of the points that span the k-th
--                 component in the quaddobl irreducible decomposition.
--   job    = 88 : makes the factorization with quad doubles go silent;
--   job    = 89 : returns in c the real and imaginary parts of
--                 a randomly generated complex number of modulus one,
--                 generated in quad double precision;
--   job    = 90 : makes the factorization with quad doubles go verbose.
--
-- ANALOGUE OPERATIONS FOR WITNESS SETS DEFINED BY LAURENT SYSTEMS :
--
--   job    = 91 : prompts for a witness set in standard double precision,
--                 defined by a Laurent polynomial system, stores the
--                 system in the standard Laurent systems container,
--                 and its solutions in the standard solutions container,
--                 and returns in a the dimension of the ambient space
--                 and in b the following two numbers:
--                   b[0] : dimension of the solution set;
--                   b[1] : degree of the solution set.
--          = 92 : prompts for a witness set in double double precision,
--                 defined by a Laurent polynomial system, stores the
--                 system in the dobldobl Laurent systems container,
--                 and its solutions in the dobldobl solutions container,
--                 and returns in a the dimension of the ambient space
--                 and in b the following two numbers:
--                   b[0] : dimension of the solution set;
--                   b[1] : degree of the solution set.
--          = 93 : prompts for a witness set in quad double precision,
--                 defined by a Laurent polynomial system, stores the
--                 system in the quaddobl Laurent systems container,
--                 and its solutions in the quaddobl solutions container,
--                 and returns in a the dimension of the ambient space
--                 and in b the following two numbers:
--                   b[0] : dimension of the solution set;
--                   b[1] : degree of the solution set.
--          = 94 : reads a witness set defined by a Laurent system
--                 in standard double precision from file,
--                 on input in b is the file name, and in a the
--                          number of characters in the file name,
--                 stores the system in the Laurent systems container,
--                 and its solutions in the solutions container,
--                 and returns in a the dimension of the ambient space
--                 and in b the following two numbers:
--                   b[0] : dimension of the solution set;
--                   b[1] : degree of the solution set;
--          = 95 : reads a witness set defined by a Laurent system
--                 in double double precision from file,
--                 on input in b is the file name, and in a the
--                          number of characters in the file name,
--                 stores the system in the Laurent systems container,
--                 and its solutions in the solutions container,
--                 and returns in a the dimension of the ambient space
--                 and in b the following two numbers:
--                   b[0] : dimension of the solution set;
--                   b[1] : degree of the solution set;
--          = 96 : reads a witness set defined by a Laurent system
--                 in quad double precision from file,
--                 on input in b is the file name, and in a the
--                          number of characters in the file name,
--                 stores the system in the Laurent systems container,
--                 and its solutions in the solutions container,
--                 and returns in a the dimension of the ambient space
--                 and in b the following two numbers:
--                   b[0] : dimension of the solution set;
--                   b[1] : degree of the solution set;
--
-- ON RETURN :
--   0 if the operation was successful, otherwise something went wrong,
--   e.g.: job not in the right range.
