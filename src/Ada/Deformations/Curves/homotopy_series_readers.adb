with text_io;                            use text_io;
with Communications_with_User;           use Communications_with_User;
with Standard_Random_Numbers;
with DoblDobl_Random_Numbers;
with QuadDobl_Random_Numbers;
with Standard_Integer_Vectors;
with Standard_Homotopy;
with Standard_Coefficient_Homotopy;
with DoblDobl_Homotopy;
with DoblDobl_Coefficient_Homotopy;
with QuadDobl_Homotopy;
with QuadDobl_Coefficient_Homotopy;
with Artificial_Parameter_Homotopy_io;
with Projective_Transformations;         use Projective_Transformations;
with Multi_Projective_Transformations;   use Multi_Projective_Transformations;
with Homogenization;                     use Homogenization;
with Standard_CSeries_Poly_Systems;
with DoblDobl_CSeries_Poly_Systems;
with QuadDobl_CSeries_Poly_Systems;
with Standard_Parameter_Systems;
with DoblDobl_Parameter_Systems;
with QuadDobl_Parameter_Systems;
with Series_and_Homotopies;
with Series_and_Predictors;
with Jacobian_Rabinowitsch_Trick;        use Jacobian_Rabinowitsch_Trick;

package body Homotopy_Series_Readers is

  procedure Standard_Projective_Transformation
              ( target,start
                 : in out Standard_Complex_Poly_Systems.Link_to_Poly_Sys ) is

    ptar : Standard_Complex_Poly_Systems.Poly_Sys(target'first..target'last+1);
    pstr : Standard_Complex_Poly_Systems.Poly_Sys(start'first..start'last+1);

  begin
    Projective_Transformation(target.all);
    Projective_Transformation(start.all);
    ptar := Add_Random_Hyperplanes(target.all,1,false);
    pstr := Add_Standard_Hyperplanes(start.all,1);
    Standard_Complex_Poly_Systems.Clear(target);
    target := new Standard_Complex_Poly_Systems.Poly_Sys'(ptar);
    Standard_Complex_Poly_Systems.Clear(start);
    start := new Standard_Complex_Poly_Systems.Poly_Sys'(pstr);
  end Standard_Projective_Transformation;

  procedure DoblDobl_Projective_Transformation
              ( target,start
                 : in out DoblDobl_Complex_Poly_Systems.Link_to_Poly_Sys ) is

    ptar : DoblDobl_Complex_Poly_Systems.Poly_Sys(target'first..target'last+1);
    pstr : DoblDobl_Complex_Poly_Systems.Poly_Sys(start'first..start'last+1);

  begin
    Projective_Transformation(target.all);
    Projective_Transformation(start.all);
    ptar := Add_Random_Hyperplanes(target.all,1,false);
    pstr := Add_Standard_Hyperplanes(start.all,1);
    DoblDobl_Complex_Poly_Systems.Clear(target);
    target := new DoblDobl_Complex_Poly_Systems.Poly_Sys'(ptar);
    DoblDobl_Complex_Poly_Systems.Clear(start);
    start := new DoblDobl_Complex_Poly_Systems.Poly_Sys'(pstr);
  end DoblDobl_Projective_Transformation;

  procedure QuadDobl_Projective_Transformation
              ( target,start
                 : in out QuadDobl_Complex_Poly_Systems.Link_to_Poly_Sys ) is

    ptar : QuadDobl_Complex_Poly_Systems.Poly_Sys(target'first..target'last+1);
    pstr : QuadDobl_Complex_Poly_Systems.Poly_Sys(start'first..start'last+1);

  begin
    Projective_Transformation(target.all);
    Projective_Transformation(start.all);
    ptar := Add_Random_Hyperplanes(target.all,1,false);
    pstr := Add_Standard_Hyperplanes(start.all,1);
    QuadDobl_Complex_Poly_Systems.Clear(target);
    target := new QuadDobl_Complex_Poly_Systems.Poly_Sys'(ptar);
    QuadDobl_Complex_Poly_Systems.Clear(start);
    start := new QuadDobl_Complex_Poly_Systems.Poly_Sys'(pstr);
  end QuadDobl_Projective_Transformation;

  procedure Standard_Projective_Transformation
              ( target : in out Standard_Complex_Poly_Systems.Link_to_Poly_Sys;
                start : in out Standard_Complex_Poly_Systems.Link_to_Poly_Sys;
                sols : in out Standard_Complex_Solutions.Solution_List ) is
  begin
    Standard_Projective_Transformation(target,start);
    Projective_Transformation(sols);
  end Standard_Projective_Transformation;

  procedure DoblDobl_Projective_Transformation
              ( target : in out DoblDobl_Complex_Poly_Systems.Link_to_Poly_Sys;
                start : in out DoblDobl_Complex_Poly_Systems.Link_to_Poly_Sys;
                sols : in out DoblDobl_Complex_Solutions.Solution_List ) is
  begin
    DoblDobl_Projective_Transformation(target,start);
    Projective_Transformation(sols);
  end DoblDobl_Projective_Transformation;

  procedure QuadDobl_Projective_Transformation
              ( target : in out QuadDobl_Complex_Poly_Systems.Link_to_Poly_Sys;
                start : in out QuadDobl_Complex_Poly_Systems.Link_to_Poly_Sys;
                sols : in out QuadDobl_Complex_Solutions.Solution_List ) is
  begin
    QuadDobl_Projective_Transformation(target,start);
    Projective_Transformation(sols);
  end QuadDobl_Projective_Transformation;

  procedure Standard_Multi_Projective_Transformation
              ( target,start
                  : in out Standard_Complex_Poly_Systems.Link_to_Poly_Sys;
                m : in natural32; z : in Partition ) is

    p : constant Standard_Complex_Poly_Systems.Poly_Sys
      := Multi_Projective_Transformation(target.all,m,z);
    q : constant Standard_Complex_Poly_Systems.Poly_Sys
      := Multi_Projective_Transformation(start.all,m,z,true);

  begin
    Standard_Complex_Poly_Systems.Clear(target);
    target := new Standard_Complex_Poly_Systems.Poly_Sys'(p);
    Standard_Complex_Poly_Systems.Clear(start);
    start := new Standard_Complex_Poly_Systems.Poly_Sys'(q);
  end Standard_Multi_Projective_Transformation;

  procedure DoblDobl_Multi_Projective_Transformation
              ( target,start
                  : in out DoblDobl_Complex_Poly_Systems.Link_to_Poly_Sys;
                m : in natural32; z : in Partition ) is

    p : constant DoblDobl_Complex_Poly_Systems.Poly_Sys
      := Multi_Projective_Transformation(target.all,m,z);
    q : constant DoblDobl_Complex_Poly_Systems.Poly_Sys
      := Multi_Projective_Transformation(start.all,m,z,true);

  begin
    DoblDobl_Complex_Poly_Systems.Clear(target);
    target := new DoblDobl_Complex_Poly_Systems.Poly_Sys'(p);
    DoblDobl_Complex_Poly_Systems.Clear(start);
    start := new DoblDobl_Complex_Poly_Systems.Poly_Sys'(q);
  end DoblDobl_Multi_Projective_Transformation;

  procedure QuadDobl_Multi_Projective_Transformation
              ( target,start
                  : in out QuadDobl_Complex_Poly_Systems.Link_to_Poly_Sys;
                m : in natural32; z : in Partition ) is

    p : constant QuadDobl_Complex_Poly_Systems.Poly_Sys
      := Multi_Projective_Transformation(target.all,m,z);
    q : constant QuadDobl_Complex_Poly_Systems.Poly_Sys
      := Multi_Projective_Transformation(start.all,m,z,true);

  begin
    QuadDobl_Complex_Poly_Systems.Clear(target);
    target := new QuadDobl_Complex_Poly_Systems.Poly_Sys'(p);
    QuadDobl_Complex_Poly_Systems.Clear(start);
    start := new QuadDobl_Complex_Poly_Systems.Poly_Sys'(q);
  end QuadDobl_Multi_Projective_Transformation;

  procedure Standard_Multi_Projective_Transformation
              ( target : in out Standard_Complex_Poly_Systems.Link_to_Poly_Sys;
                start : in out Standard_Complex_Poly_Systems.Link_to_Poly_Sys;
                sols : in out Standard_Complex_Solutions.Solution_List;
                m : in natural32; z : in Partition ) is
  begin
    Standard_Multi_Projective_Transformation(target,start,m,z);
    Add_Ones(sols,m);
  end Standard_Multi_Projective_Transformation;

  procedure DoblDobl_Multi_Projective_Transformation
              ( target : in out DoblDobl_Complex_Poly_Systems.Link_to_Poly_Sys;
                start : in out DoblDobl_Complex_Poly_Systems.Link_to_Poly_Sys;
                sols : in out DoblDobl_Complex_Solutions.Solution_List;
                m : in natural32; z : in Partition ) is
  begin
    DoblDobl_Multi_Projective_Transformation(target,start,m,z);
    Add_Ones(sols,m);
  end DoblDobl_Multi_Projective_Transformation;

  procedure QuadDobl_Multi_Projective_Transformation
              ( target : in out QuadDobl_Complex_Poly_Systems.Link_to_Poly_Sys;
                start : in out QuadDobl_Complex_Poly_Systems.Link_to_Poly_Sys;
                sols : in out QuadDobl_Complex_Solutions.Solution_List;
                m : in natural32; z : in Partition ) is
  begin
    QuadDobl_Multi_Projective_Transformation(target,start,m,z);
    Add_Ones(sols,m);
  end QuadDobl_Multi_Projective_Transformation;

  procedure Standard_Reader
              ( nbequ : out integer32;
                sols : out Standard_Complex_Solutions.Solution_List;
                tpow : in natural32;
                gamma : in Standard_Complex_Numbers.Complex_Number;
                homcrd,rabin : in boolean := false ) is

    target,start : Standard_Complex_Poly_Systems.Link_to_Poly_Sys;
    ans : character;

  begin
    Artificial_Parameter_Homotopy_io.get(target,start,sols);
    if not rabin then
      if homcrd then
        Standard_Projective_Transformation(target,start,sols);
      end if;
      nbequ := target'last;
      if not homcrd then
        Standard_Homotopy.Create(target.all,start.all,tpow,gamma);
      else -- set the value for tpow to one if homcrd
        Standard_Homotopy.Create(target.all,start.all,1,gamma);
        Standard_Coefficient_Homotopy.Create(start.all,target.all,1,gamma);
      end if;
    else
      new_line;
      put("Apply Rabinowitsch trick to put singularities at infinity ? (y/n) ");
      Ask_Yes_or_No(ans);
      if ans /= 'y' then
        nbequ := target'last;
        Standard_Homotopy.Create(target.all,start.all,tpow,gamma);
      else
        declare
          jrbtarget : constant Standard_Complex_Poly_Systems.Poly_Sys
                    := Jacobian_Rabinowitsch(target.all);
          jrbstart : constant Standard_Complex_Poly_Systems.Poly_Sys
                   := Jacobian_Rabinowitsch(start.all);
          jrbsols : constant Standard_Complex_Solutions.Solution_List
                  := Jacobian_Rabinowitsch(sols);
        begin
          nbequ := jrbtarget'last;
          Standard_Homotopy.Create(jrbtarget,jrbstart,tpow,gamma);
          Standard_Complex_Solutions.Deep_Clear(sols);
          sols := jrbsols;
        end;
      end if;
    end if;
  end Standard_Reader;

  procedure DoblDobl_Reader
              ( nbequ : out integer32;
                sols : out DoblDobl_Complex_Solutions.Solution_List;
                tpow : in natural32;
                gamma : in DoblDobl_Complex_Numbers.Complex_Number;
                homcrd,rabin : in boolean := false ) is

    target,start : DoblDobl_Complex_Poly_Systems.Link_to_Poly_Sys;
    ans : character;

  begin
    Artificial_Parameter_Homotopy_io.get(target,start,sols);
    if not rabin then
      if homcrd
       then DoblDobl_Projective_Transformation(target,start,sols);
      end if;
      nbequ := target'last;
      if not homcrd then
        DoblDobl_Homotopy.Create(target.all,start.all,tpow,gamma);
      else -- set tpow to one for homogeneous coordinates
        DoblDobl_Homotopy.Create(target.all,start.all,1,gamma);
        DoblDobl_Coefficient_Homotopy.Create(start.all,target.all,1,gamma);
      end if;
    else
      new_line;
      put("Apply Rabinowitsch trick to put singularities at infinity ? (y/n) ");
      Ask_Yes_or_No(ans);
      if ans /= 'y' then
        nbequ := target'last;
        DoblDobl_Homotopy.Create(target.all,start.all,tpow,gamma);
      else
        declare
          jrbtarget : constant DoblDobl_Complex_Poly_Systems.Poly_Sys
                    := Jacobian_Rabinowitsch(target.all);
          jrbstart : constant DoblDobl_Complex_Poly_Systems.Poly_Sys
                   := Jacobian_Rabinowitsch(start.all);
          jrbsols : constant DoblDobl_Complex_Solutions.Solution_List
                  := Jacobian_Rabinowitsch(sols);
        begin
          nbequ := jrbtarget'last;
          DoblDobl_Homotopy.Create(jrbtarget,jrbstart,tpow,gamma);
          DoblDobl_Complex_Solutions.Deep_Clear(sols);
          sols := jrbsols;
        end;
      end if;
    end if;
  end DoblDobl_Reader;

  procedure QuadDobl_Reader
              ( nbequ : out integer32;
                sols : out QuadDobl_Complex_Solutions.Solution_List;
                tpow : in natural32;
                gamma : in QuadDobl_Complex_Numbers.Complex_Number;
                homcrd,rabin : in boolean := false ) is

    target,start : QuadDobl_Complex_Poly_Systems.Link_to_Poly_Sys;
    ans : character;

  begin
    Artificial_Parameter_Homotopy_io.get(target,start,sols);
    if not rabin then
      if homcrd
       then QuadDobl_Projective_Transformation(target,start,sols);
      end if;
      nbequ := target'last;
      if not homcrd then
        QuadDobl_Homotopy.Create(target.all,start.all,tpow,gamma);
      else -- set tpow to one for homogeneous coordinates
        QuadDobl_Homotopy.Create(target.all,start.all,1,gamma);
        QuadDobl_Coefficient_Homotopy.Create(start.all,target.all,1,gamma);
      end if;
    else
      new_line;
      put("Apply Rabinowitsch trick to put singularities at infinity ? (y/n) ");
      Ask_Yes_or_No(ans);
      if ans /= 'y' then
        nbequ := target'last;
        QuadDobl_Homotopy.Create(target.all,start.all,tpow,gamma);
      else
        declare
          jrbtarget : constant QuadDobl_Complex_Poly_Systems.Poly_Sys
                    := Jacobian_Rabinowitsch(target.all);
          jrbstart : constant QuadDobl_Complex_Poly_Systems.Poly_Sys
                   := Jacobian_Rabinowitsch(start.all);
          jrbsols : constant QuadDobl_Complex_Solutions.Solution_List
                  := Jacobian_Rabinowitsch(sols);
        begin
          nbequ := jrbtarget'last;
          QuadDobl_Homotopy.Create(jrbtarget,jrbstart,tpow,gamma);
          QuadDobl_Complex_Solutions.Deep_Clear(sols);
          sols := jrbsols;
        end;
      end if;
    end if;
  end QuadDobl_Reader;

  procedure Standard_Reader
              ( nbequ : out integer32;
                sols : out Standard_Complex_Solutions.Solution_List;
                tpow : in natural32 := 2;
                homcrd,rabin : in boolean := false ) is

    gamma : constant Standard_Complex_Numbers.Complex_Number
          := Standard_Random_Numbers.Random1;

  begin
    Standard_Reader(nbequ,sols,tpow,gamma,homcrd,rabin);
  end Standard_Reader;

  procedure DoblDobl_Reader
              ( nbequ : out integer32;
                sols : out DoblDobl_Complex_Solutions.Solution_List;
                tpow : in natural32 := 2;
                homcrd,rabin : in boolean := false ) is

    gamma : constant DoblDobl_Complex_Numbers.Complex_Number
          := DoblDobl_Random_Numbers.Random1;

  begin
    DoblDobl_Reader(nbequ,sols,tpow,gamma,homcrd,rabin);
  end DoblDobl_Reader;

  procedure QuadDobl_Reader
              ( nbequ : out integer32;
                sols : out QuadDobl_Complex_Solutions.Solution_List;
                tpow : in natural32 := 2;
                homcrd,rabin : in boolean := false ) is

    gamma : constant QuadDobl_Complex_Numbers.Complex_Number
          := QuadDobl_Random_Numbers.Random1;

  begin
    QuadDobl_Reader(nbequ,sols,tpow,gamma,homcrd,rabin);
  end QuadDobl_Reader;

  procedure Standard_Parameter_Reader
              ( nbequ,nbvar,idxpar : out integer32;
                sols : out Standard_Complex_Solutions.Solution_List ) is

    use Standard_Parameter_Systems;

    lp : Standard_Complex_Poly_Systems.Link_to_Poly_Sys;
    nbpar : integer32;

  begin
    Read_Parameter_Homotopy(lp,sols,nbequ,nbvar,nbpar);
    declare
      par : Standard_Integer_Vectors.Vector(1..nbpar);
    begin
      par := Define_Parameters(nbequ,nbvar,nbpar);
      idxpar := par(1);
    end;
    Standard_Homotopy.Create(lp.all,idxpar);
  end Standard_Parameter_Reader;

  procedure DoblDobl_Parameter_Reader
              ( nbequ,nbvar,idxpar : out integer32;
                sols : out DoblDobl_Complex_Solutions.Solution_List ) is

    use DoblDobl_Parameter_Systems;

    lp : DoblDobl_Complex_Poly_Systems.Link_to_Poly_Sys;
    nbpar : integer32;

  begin
    Read_Parameter_Homotopy(lp,sols,nbequ,nbvar,nbpar);
    declare
      par : Standard_Integer_Vectors.Vector(1..nbpar);
    begin
      par := Define_Parameters(nbequ,nbvar,nbpar);
      idxpar := par(1);
    end;
    DoblDobl_Homotopy.Create(lp.all,idxpar);
  end DoblDobl_Parameter_Reader;

  procedure QuadDobl_Parameter_Reader
              ( nbequ,nbvar,idxpar : out integer32;
                sols : out QuadDobl_Complex_Solutions.Solution_List ) is

    use QuadDobl_Parameter_Systems;

    lp : QuadDobl_Complex_Poly_Systems.Link_to_Poly_Sys;
    nbpar : integer32;

  begin
    Read_Parameter_Homotopy(lp,sols,nbequ,nbvar,nbpar);
    declare
      par : Standard_Integer_Vectors.Vector(1..nbpar);
    begin
      par := Define_Parameters(nbequ,nbvar,nbpar);
      idxpar := par(1);
    end;
    QuadDobl_Homotopy.Create(lp.all,idxpar);
  end QuadDobl_Parameter_Reader;

  procedure Standard_Series_Newton
              ( sol : in Standard_Complex_Vectors.Vector;
                idx,nbequ : in integer32; nbterms,nbiters : in natural32;
                srv,eva : out Standard_Complex_Series_Vectors.Vector ) is

    hom : constant Standard_Complex_Poly_Systems.Poly_Sys(1..nbequ)
        := Standard_Homotopy.Homotopy_System;
    sys : Standard_CSeries_Poly_Systems.Poly_Sys(1..nbequ)
        := Series_and_Homotopies.Create(hom,idx);
    maxdeg : constant integer32 := integer32(nbterms);
    nit : constant integer32 := integer32(nbiters);

  begin
    Series_and_Predictors.Newton_Prediction(maxdeg,nit,sys,sol,srv,eva);
   -- Standard_Complex_Poly_Systems.Clear(hom); -- sharing, do not clear!
    Standard_CSeries_Poly_Systems.Clear(sys);
  end Standard_Series_Newton;

  procedure Standard_Series_Newton
              ( sol : in Standard_Complex_Solutions.Solution;
                idx,nbequ : in integer32; nbterms,nbiters : in natural32;
                srv,eva : out Standard_Complex_Series_Vectors.Vector ) is
  begin
    Standard_Series_Newton(sol.v,idx,nbequ,nbterms,nbiters,srv,eva);
  end Standard_Series_Newton;

  procedure DoblDobl_Series_Newton
              ( sol : in DoblDobl_Complex_Vectors.Vector;
                idx,nbequ : in integer32; nbterms,nbiters : in natural32;
                srv,eva : out DoblDobl_Complex_Series_Vectors.Vector ) is

    hom : constant DoblDobl_Complex_Poly_Systems.Poly_Sys(1..nbequ)
        := DoblDobl_Homotopy.Homotopy_System;
    sys : DoblDobl_CSeries_Poly_Systems.Poly_Sys(1..nbequ)
        := Series_and_Homotopies.Create(hom,idx);
    maxdeg : constant integer32 := integer32(nbterms);
    nit : constant integer32 := integer32(nbiters);

  begin
    Series_and_Predictors.Newton_Prediction(maxdeg,nit,sys,sol,srv,eva);
   -- DoblDobl_Complex_Poly_Systems.Clear(hom); -- sharing, do not clear!
    DoblDobl_CSeries_Poly_Systems.Clear(sys);
  end DoblDobl_Series_Newton;

  procedure DoblDobl_Series_Newton
              ( sol : in DoblDobl_Complex_Solutions.Solution;
                idx,nbequ : in integer32; nbterms,nbiters : in natural32;
                srv,eva : out DoblDobl_Complex_Series_Vectors.Vector ) is
  begin
    DoblDobl_Series_Newton(sol.v,idx,nbequ,nbterms,nbiters,srv,eva);
  end DoblDobl_Series_Newton;

  procedure QuadDobl_Series_Newton
              ( sol : in QuadDobl_Complex_Vectors.Vector;
                idx,nbequ : in integer32; nbterms,nbiters : in natural32;
                srv,eva : out QuadDobl_Complex_Series_Vectors.Vector ) is

    hom : constant QuadDobl_Complex_Poly_Systems.Poly_Sys(1..nbequ)
        := QuadDobl_Homotopy.Homotopy_System;
    sys : QuadDobl_CSeries_Poly_Systems.Poly_Sys(1..nbequ)
        := Series_and_Homotopies.Create(hom,idx);
    maxdeg : constant integer32 := integer32(nbterms);
    nit : constant integer32 := integer32(nbiters);

  begin
    Series_and_Predictors.Newton_Prediction(maxdeg,nit,sys,sol,srv,eva);
   -- QuadDobl_Complex_Poly_Systems.Clear(hom); -- sharing, do not clear!
    QuadDobl_CSeries_Poly_Systems.Clear(sys);
  end QuadDobl_Series_Newton;

  procedure QuadDobl_Series_Newton
              ( sol : in QuadDobl_Complex_Solutions.Solution;
                idx,nbequ : in integer32; nbterms,nbiters : in natural32;
                srv,eva : out QuadDobl_Complex_Series_Vectors.Vector ) is
  begin
    QuadDobl_Series_Newton(sol.v,idx,nbequ,nbterms,nbiters,srv,eva);
  end QuadDobl_Series_Newton;

end Homotopy_Series_Readers;
