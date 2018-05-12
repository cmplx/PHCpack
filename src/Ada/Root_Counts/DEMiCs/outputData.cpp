/* This file "outputData.cpp" contains the definitions of the operations
 * to process the output of DEMiCs. */

#include "outputData.h"

int allocate_lifting ( int nbrsup, int* crdsup )
{
   int fail;
   double *c;

   fail = _ada_use_c2phc(834,&nbrsup,crdsup,c);

   return fail;
}

int assign_lifting ( int idxsup, int idxpnt, double value )
{
   int fail;

   fail = _ada_use_c2phc(835,&idxsup,&idxpnt,&value);

   return fail;
}

int retrieve_lifting ( int idxsup, int idxpnt, double* value )
{
   int fail;

   fail = _ada_use_c2phc(836,&idxsup,&idxpnt,value);

   return fail;
}

int clear_lifting ( void )
{
   int *a,*b,fail;
   double *c;

   fail = _ada_use_c2phc(837,a,b,c);

   return fail;
}

int append_cell_indices ( std::string strcell )
{
   int fail;
   double *c;

   int lenstrcell = strcell.length();

   int cellchars[lenstrcell];

   for(int k=0; k<lenstrcell; k++)
      cellchars[k] = (int) strcell[k];

   fail = _ada_use_c2phc(838,&lenstrcell,cellchars,c);

   return 0;
}

int clear_cell_indices ( void )
{
   int *a,*b,fail;
   double *c;

   fail = _ada_use_c2phc(839,a,b,c);

   return fail;
}
