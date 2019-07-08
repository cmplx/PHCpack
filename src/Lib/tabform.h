/* This file "tabform.h" contains the prototypes of the operations
 * concerning the tableau format of polynomial systems.
 * By default, compilation with gcc is assumed.
 * To compile with a C++ compiler such as g++, the flag compilewgpp must
 * be defined as "g++ -Dcompilewgpp=1." */

#ifndef __TABFORM_H__
#define __TABFORM_H__

#ifdef compilewgpp
extern "C" void adainit( void );
extern "C" int _ada_use_c2phc4c ( int task, int *a, int *b, double *c );
extern "C" void adafinal( void );
#else
extern void adainit( void );
extern int _ada_use_c2phc4c ( int task, int *a, int *b, double *c );
extern void adafinal( void );
#endif

int number_of_standard_terms
 ( int neq, int *nbterms, int *nbtsum, int verbose );
/*
 * DESCRIPTION :
 *   Computes the number of terms of each polynomial in the container
 *   for systems with standard double precision coefficients.
 *   Returns the failure code of the calls to retrieve the number of terms.
 *
 * ON ENTRY :
 *   neq      the number of equations of the system in the container;
 *   nbterms  space allocated for neq integers;
 *   verbose  if > 0, then additional output is written to screen,
 *            otherwise, the function remains silent.
 *
 * ON RETURN :
 *   nbtsum   sum of the number of elements in nbterms,
 *            equals the total number of terms in the system. */

int standard_tableau_form
 ( int neq, int nvr, int *nbterms, double *coefficients, int *exponents,
   int verbose );
/*
 * DESCRIPTION :
 *   Given allocated data structures, defines the coefficients and exponents
 *   of the tableau form of the system stored in the container for systems
 *   with standard double precision coefficients.
 *   Returns the failure code of the term retrievals.
 *
 * ON ENTRY :
 *   neq            number of equations of the system;
 *   nvr            number of variables of the system;
 *   nbterms        array of size neq, nbterms[k] contains the number
 *                  of terms in the (k+1)-th equation in the system;
 *   coefficients   allocated for 2 times the total number of terms;
 *   exponents      allocated for nvr times the total number of terms;
 *   verbose        if > 0, then the tableau form is written,
 *                  if = 0, then the function remains silent.
 *
 * ON RETURN :
 *   coefficients   coefficients of the system;
 *   exponents      exponents of the system. */

void write_standard_tableau_form
 ( int neq, int nvr, int *nbterms, double *coefficients, int *exponents );
/*
 * DESCRIPTION :
 *   Writes the tableau form of the system to screen.
 *
 * ON ENTRY :
 *   neq            number of equations of the system;
 *   nvr            number of variables of the system;
 *   nbterms        array of size neq, nbterms[k] contains the number
 *                  of terms in the (k+1)-th equation in the system;
 *   coefficients   coefficients of the system;
 *   exponents      exponents of the system. */

#endif
