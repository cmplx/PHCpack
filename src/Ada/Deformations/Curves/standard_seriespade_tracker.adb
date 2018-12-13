with Standard_Natural_Numbers;           use Standard_Natural_Numbers;
with Standard_Complex_Numbers;           use Standard_Complex_Numbers;
with Standard_Homotopy;

package body Standard_SeriesPade_Tracker is

-- INTERNAL DATA :

  homconpars : Homotopy_Continuation_Parameters.Link_to_Parameters;
  current : Link_to_Solution;

-- CONSTRUCTORS :

  procedure Init ( pars : in Homotopy_Continuation_Parameters.Parameters ) is
  begin
    homconpars := new Homotopy_Continuation_Parameters.Parameters'(pars);
  end Init;

  procedure Init ( p,q : in Link_to_Poly_Sys ) is

    tpow : constant natural32 := 2;
    gamma : constant Complex_Number := homconpars.gamma;

  begin
    Standard_Homotopy.Create(p.all,q.all,tpow,gamma);
  end Init;

  procedure Init ( s : in Link_to_Solution ) is
  begin
    current := s;
  end Init;

-- SELECTORS :

  function Get_Parameters
    return Homotopy_Continuation_Parameters.Link_to_Parameters is

  begin
    return homconpars;
  end Get_Parameters;

-- DESTRUCTOR :

  procedure Clear is
  begin
    Homotopy_Continuation_Parameters.Clear(homconpars);
  end Clear;

end Standard_SeriesPade_Tracker;
