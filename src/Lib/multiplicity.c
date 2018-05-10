/* The file multiplicity.c contains the definitions of the functions
 * declared in multiplicity.h. */

#include "multiplicity.h"

int standard_multiplicity_structure
 ( int order, int verbose, double tol, int *multiplicity, int *hilbert )
{
   int fail = 0;

   *multiplicity = order;
   hilbert[0] = verbose;

   fail = _ada_use_c2phc(732,multiplicity,hilbert,&tol);

   return fail;
}

int dobldobl_multiplicity_structure
 ( int order, int verbose, double tol, int *multiplicity, int *hilbert )
{
   int fail = 0;

   *multiplicity = order;
   hilbert[0] = verbose;

   fail = _ada_use_c2phc(733,multiplicity,hilbert,&tol);

   return fail;
}

int quaddobl_multiplicity_structure
 ( int order, int verbose, double tol, int *multiplicity, int *hilbert )
{
   int fail = 0;

   *multiplicity = order;
   hilbert[0] = verbose;

   fail = _ada_use_c2phc(734,multiplicity,hilbert,&tol);

   return fail;
}