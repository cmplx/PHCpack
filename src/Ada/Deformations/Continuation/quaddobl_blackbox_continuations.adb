with Timing_Package;                     use Timing_Package;
with File_Scanning;                      use File_Scanning;
with Standard_Natural_Numbers;           use Standard_Natural_Numbers;
with Standard_Natural_Numbers_io;        use Standard_Natural_Numbers_io;
with Standard_Integer_Numbers_io;        use Standard_Integer_Numbers_io;
with Quad_Double_Numbers;                use Quad_Double_Numbers;
with QuadDobl_Complex_Numbers_io;        use QuadDobl_Complex_Numbers_io;
with QuadDobl_Random_Numbers;            use QuadDobl_Random_Numbers;
with Standard_Integer_Vectors;
with QuadDobl_Complex_Vectors;
with QuadDobl_Complex_Vector_Norms;      use QuadDobl_Complex_Vector_Norms;
with QuadDobl_Complex_Polynomials;       use QuadDobl_Complex_Polynomials;
with QuadDobl_Complex_Poly_Systems_io;   use QuadDobl_Complex_Poly_Systems_io;
with QuadDobl_Complex_Poly_SysFun;       use QuadDobl_Complex_Poly_SysFun;
with QuadDobl_Complex_Solutions_io;      use QuadDobl_Complex_Solutions_io;
with QuadDobl_Scaling;                   use QuadDobl_Scaling;
with Continuation_Parameters;
with Continuation_Parameters_io;
with QuadDobl_Homotopy;
with QuadDobl_Coefficient_Homotopy;
with QuadDobl_Laurent_Homotopy;
with QuadDobl_Stable_Homotopies;         use QuadDobl_Stable_Homotopies;
with Process_io;                         use Process_io;
with QuadDobl_IncFix_Continuation;       use QuadDobl_IncFix_Continuation;
with QuadDobl_Root_Refiners;             use QuadDobl_Root_Refiners;
with Multitasking_Continuation;          use Multitasking_Continuation;
with Multitasking_Root_Refiners;         use Multitasking_Root_Refiners;

package body QuadDobl_BlackBox_Continuations is

-- AUXILIARY ROUTINES :

  procedure Scan_Input
              ( infile,outfile : in file_type; p,q : in out Link_to_Poly_Sys;
                sols : in out Solution_List; arti : out boolean ) is

  -- DESCRIPTION :
  --   Scans the input file for target system and, if the homotopy is 
  --   artificial (in that case arti = true, otherwise arti = false),
  --   for a start system.  In both cases, start solutions are required.

    found,artificial : boolean;

  begin
    get(infile,p);
    put(outfile,p.all);
    artificial := (Number_of_Unknowns(p(p'first)) = natural32(p'last));
    if artificial then
      Scan_and_Skip(infile,"START SYSTEM",found);
      if found then
        get(infile,q);
        new_line(outfile);
        put_line(outfile,"THE START SYSTEM : ");
        new_line(outfile);
        put_line(outfile,q.all);
      end if;
    end if;
    Scan_and_Skip(infile,"SOLUTIONS",found);
    if found then
      get(infile,sols);
      new_line(outfile);
      put_line(outfile,"THE START SOLUTIONS : ");
      new_line(outfile);
      put(outfile,Length_Of(sols),natural32(Head_Of(sols).n),sols);
      new_line(outfile);
    end if;
    arti := artificial;
  end Scan_Input;

  procedure Scan_Input
                ( targetfile,startfile,outfile : in file_type;
                  p,q : in out Link_to_Poly_Sys;
                  sols : in out Solution_List ) is

  -- DESCRIPTION :
  --   Scans the targetfile for a target system and the startfile
  --   for a start system and start solutions.

    found : boolean;

  begin
    get(targetfile,p);
    put(outfile,p.all);
    get(startfile,q);
    new_line(outfile);
    put_line(outfile,"THE START SYSTEM : ");
    new_line(outfile);
    put_line(outfile,q.all);
    Scan_and_Skip(startfile,"SOLUTIONS",found);
    if found then
      get(startfile,sols);
      new_line(outfile);
      put_line(outfile,"THE START SOLUTIONS : ");
      new_line(outfile);
      put(outfile,Length_Of(sols),natural32(Head_Of(sols).n),sols);
      new_line(outfile);
    end if;
  end Scan_Input;

  procedure Write_Homotopy_Parameters
               ( file : in file_type; k : in natural32;
                 gamma,t : in Complex_Number; prt : in boolean ) is

  -- DESCRIPTION :
  --   Writes the settings for the homotopy parameters to file.

  begin
    new_line(file);
    put_line(file,"HOMOTOPY PARAMETERS :");
    put(file,"      k : "); put(file,k,2);   new_line(file);
    put(file,"  gamma : "); put(file,gamma); new_line(file);
    put(file,"      t : "); put(file,t);     new_line(file);
    if prt
     then put_line(file,"  projective transformation");
     else put_line(file,"  no projective transformation");
    end if;
  end Write_Homotopy_Parameters;

  procedure Set_Homotopy_Parameters
               ( file : in file_type; k : out natural32;
                 a,t : out Complex_Number; prt : out boolean ) is

  -- DESCRIPTION :
  --   Sets the default values for the homotopy parameters
  --   and writes these values to file.

    one : constant quad_double := create(1.0);

  begin
    k := 2;
    a := Random1;
    t := Create(one);
    prt := false;
    Write_Homotopy_Parameters(file,k,a,t,prt);
  end Set_Homotopy_Parameters;

  procedure Tune_Continuation_Parameters ( outfile : in file_type ) is

  -- DESCRIPTION :
  --   Scans the input file for continuation parameters and the
  --   output parameter.

  begin
   -- Continuation_Parameters.Tune(2);  -- too restrictive !!
    Continuation_Parameters.Tune(0,64); -- 64 decimal places
    new_line(outfile);
    put_line(outfile,"****************** CURRENT CONTINUATION PARAMETERS "
      & "*****************");
    Continuation_Parameters_io.put(outfile);
    put_line(outfile,"***************************************************"
      & "*****************");
    Process_io.Set_Output_Code(nil);
  end Tune_Continuation_Parameters;

  procedure Reporting_Black_Box_Refine
              ( outfile : in file_type; p : in Poly_Sys;
                sols : in out Solution_List ) is

  -- DESCRIPTION :
  --   Refines the roots in sols w.r.t. the system p.
  --   By default, deflation is applied.

    epsxa,epsfa : constant quad_double := create(1.0E-8);
    tolsing : constant quad_double := create(1.0E-8);
    nb : natural32 := 0;
    deflate : boolean := true;

  begin
    if Length_Of(sols) > 0 then
      Reporting_Root_Refiner(outfile,p,sols,epsxa,epsfa,nb,5,false);
      --Reporting_Root_Refiner
      --  (outfile,p,sols,ref_sols,epsxa,epsfa,tolsing,nb,5,deflate,false);
      null;
    end if;
    Clear(sols);
  --exception
  --  when others =>
  --    put_line("exception in the calling of reporting root refiner...");
  --    raise;
  end Reporting_Black_Box_Refine;

  procedure Reporting_Black_Box_Refine
              ( outfile : in file_type; nt : in integer32;
                p : in Poly_Sys; sols : in out Solution_List ) is

  -- DESCRIPTION :
  --   Refines the roots in sols w.r.t. the system p, with nt tasks.
  --   With multitasking, deflation is not yet available...

    epsxa,epsfa : constant quad_double := create(1.0E-8);
    tolsing : constant quad_double := create(1.0E-8);
   -- ref_sols : Solution_List;
    nb : natural32 := 0;
    deflate : boolean := true;

  begin
    if Length_Of(sols) > 0 then
      Reporting_Root_Refiner(outfile,p,sols,epsxa,epsfa,nb,5,false);
     -- note that Silent means no writing concerning job scheduling
     -- Silent_Multitasking_Root_Refiner
     --   (outfile,nt,p,sols,epsxa,epsfa,tolsing,nb,5,deflate);
      null;
    end if;
  --exception
  --  when others =>
  --    put_line("exception in the calling of reporting root refiner...");
  --    raise;
  end Reporting_Black_Box_Refine;

  procedure Reporting_Black_Box_Refine
              ( outfile : in file_type; p : in Laur_Sys;
                sols : in out Solution_List ) is

  -- DESCRIPTION :
  --   Refines the roots in sols w.r.t. the system p.
  --   Deflation is not yet available for Laurent systems.

    epsxa,epsfa : constant quad_double := create(1.0E-8);
    tolsing : constant quad_double := create(1.0E-8);
    ref_sols : Solution_List;
    nb : natural32 := 0;

  begin
    if Length_Of(sols) > 0 then
      Reporting_Root_Refiner(outfile,p,sols,epsxa,epsfa,nb,5,false);
      -- Reporting_Root_Refiner
      --   (outfile,p,sols,ref_sols,epsxa,epsfa,tolsing,nb,5,false);
      null;
    end if;
    Clear(sols);
    sols := ref_sols;
  end Reporting_Black_Box_Refine;

  procedure Reporting_Black_Box_Refine
              ( outfile : in file_type; nt : in integer32;
                p : in Laur_Sys; sols : in out Solution_List ) is

  -- DESCRIPTION :
  --   Refines the roots in sols w.r.t. the system p with nt tasks.
  --   Deflation is not yet available for Laurent systems.

    epsxa,epsfa : constant quad_double := create(1.0E-8);
    tolsing : constant quad_double := create(1.0E-8);
   -- ref_sols : Solution_List;
    deflate : boolean := false;
    nb : natural32 := 0;

  begin
    if Length_Of(sols) > 0 then
      Reporting_Root_Refiner(outfile,p,sols,epsxa,epsfa,nb,5,false);
      --Silent_Multitasking_Root_Refiner
      --  (outfile,nt,p,sols,epsxa,epsfa,tolsing,nb,5,deflate);
      null;
    end if;
  end Reporting_Black_Box_Refine;

  procedure Silent_Black_Box_Refine
              ( p : in Poly_Sys; sols : in out Solution_List ) is

  -- DESCRIPTION :
  --   Refines the roots in sols w.r.t. the system p,
  --   without output written to file.
  --   By default, deflation is applied.

    epsxa,epsfa : constant quad_double := create(1.0E-8);
    nb : natural32 := 0;

  begin
    if Length_Of(sols) > 0 then
      Silent_Root_Refiner(p,sols,epsxa,epsfa,nb,5);
    end if;
  --exception 
  --  when others => put_line("exception raised in silent black box refine");
  --                 raise;
  end Silent_Black_Box_Refine;

  procedure Silent_Black_Box_Refine
              ( p : in Laur_Sys; sols : in out Solution_List ) is

  -- DESCRIPTION :
  --   Refines the roots in sols w.r.t. the system p,
  --   without output written to file.
  --   For Laurent systems, deflation is not yet available.

    epsxa,epsfa : constant quad_double := create(1.0E-8);
    nb : natural32 := 0;

  begin
    if Length_Of(sols) > 0 then
      Silent_Root_Refiner(p,sols,epsxa,epsfa,nb,5);
    end if;
  end Silent_Black_Box_Refine;

-- TARGET PROCEDURES :
-- ALL IS SCANNED FROM FILES :

  procedure Black_Box_Polynomial_Continuation
                ( targetfile,startfile,outfile : in file_type;
                  pocotime : out duration ) is

    p,q : Link_to_Poly_Sys;
    sols : Solution_List;
    timer : timing_widget;
    k : natural32 := 0;
    a,target : Complex_Number;
    proj : boolean := false;

    procedure Cont is
      new Reporting_Continue(Max_Norm,
                             QuadDobl_Coefficient_Homotopy.Eval,
                             QuadDobl_Homotopy.Diff,
                             QuadDobl_Coefficient_Homotopy.Diff);

  begin
    Scan_Input(targetfile,startfile,outfile,p,q,sols);
    Set_Homotopy_Parameters(outfile,k,a,target,proj);
    QuadDobl_Homotopy.Create(p.all,q.all,k,a);
    QuadDobl_Coefficient_Homotopy.Create(q.all,p.all,k,a);
    Tune_Continuation_Parameters(outfile);
    tstart(timer);
    Cont(outfile,sols,target);
    tstop(timer);
    new_line(outfile);
    print_times(outfile,timer,"continuation");
    pocotime := Elapsed_User_Time(timer);
    flush(outfile);
    Reporting_Black_Box_Refine(outfile,p.all,sols);
  end Black_Box_Polynomial_Continuation;

  procedure Black_Box_Polynomial_Continuation
                 ( infile,outfile : in file_type; pocotime : out duration ) is

    p,q,sp : Link_to_Poly_Sys;
    sols : Solution_List;
    timer : timing_widget;
    k : natural32 := 0;
    a,target : Complex_Number;
    proj,artificial : boolean := false;
    rcond : quad_double;
    scalecoeff : QuadDobl_Complex_Vectors.Link_to_Vector;

    procedure Cont is
      new Reporting_Continue(Max_Norm,
                             QuadDobl_Coefficient_Homotopy.Eval,
                             QuadDobl_Homotopy.Diff,
                             QuadDobl_Coefficient_Homotopy.Diff);

  begin
    Scan_Input(infile,outfile,p,q,sols,artificial);
    scalecoeff := new QuadDobl_Complex_Vectors.Vector(1..2*p'length);
    sp := new Poly_Sys(p'range);
    Copy(p.all,sp.all);
    Scale(sp.all,2,false,rcond,scalecoeff.all);
    Set_Homotopy_Parameters(outfile,k,a,target,proj);
    if artificial then
      QuadDobl_Homotopy.Create(sp.all,q.all,k,a);
      QuadDobl_Coefficient_Homotopy.Create(q.all,sp.all,k,a);
    else
      QuadDobl_Homotopy.Create(sp.all,integer32(k));
      target := a;
    end if;
    Tune_Continuation_Parameters(outfile);
    new_line(outfile);
    put_line(outfile,"THE SCALED SOLUTIONS :");
    new_line(outfile);
    tstart(timer);
    Cont(outfile,sols,target);
    tstop(timer);
    new_line(outfile);
    print_times(outfile,timer,"continuation");
    pocotime := Elapsed_User_Time(timer);
    Scale(2,scalecoeff.all,sols);
    Clear(sp);
    flush(outfile);
    Reporting_Black_Box_Refine(outfile,p.all,sols);
  end Black_Box_Polynomial_Continuation;

-- STABLE POLYNOMIAL CONTINUATION :

  procedure Stable_Poly_Continuation
              ( p,q : in Poly_Sys; gamma : in Complex_Number;
                sol : in out Solution ) is

  -- DESCRIPTION :
  --   All zeroes have already been removed from p, q, and sol.

    k : constant natural32 := 2;
    one : constant quad_double := create(1.0);
    target :  constant Complex_Number := Create(one);
    proj :  constant boolean := false;
    sols : Solution_List;

    procedure Cont is
      new Silent_Continue(Max_Norm,
                          QuadDobl_Coefficient_Homotopy.Eval,
                          QuadDobl_Homotopy.Diff,
                          QuadDobl_Coefficient_Homotopy.Diff);

  begin
    QuadDobl_Homotopy.Create(p,q,k,gamma);
    QuadDobl_Coefficient_Homotopy.Create(q,p,k,gamma);
    Add(sols,sol);
    Cont(sols,target);
    sol := Head_Of(sols).all;
    Deep_Clear(sols);
    QuadDobl_Homotopy.Clear;
    QuadDobl_Coefficient_Homotopy.Clear;
  end Stable_Poly_Continuation;

  procedure Stable_Poly_Continuation
              ( file : in file_type;
                p,q : in Poly_Sys; gamma : in Complex_Number;
                sol : in out Solution ) is

  -- DESCRIPTION :
  --   All zeroes have already been removed from p, q, and sol.

    k : constant natural32 := 2;
    one : constant quad_double := create(1.0);
    target : constant Complex_Number := Create(one);
    proj : constant boolean := false;
    sols : Solution_List;

    procedure Cont is
      new Reporting_Continue
            (Max_Norm,QuadDobl_Coefficient_Homotopy.Eval,
             QuadDobl_Homotopy.Diff,QuadDobl_Coefficient_Homotopy.Diff);

  begin
    QuadDobl_Homotopy.Create(p,q,k,gamma);
    QuadDobl_Coefficient_Homotopy.Create(q,p,k,gamma);
    Add(sols,sol);
    Cont(file,sols,target);
    sol := Head_Of(sols).all;
    Deep_Clear(sols);
    QuadDobl_Homotopy.Clear;
    QuadDobl_Coefficient_Homotopy.Clear;
  end Stable_Poly_Continuation;

  procedure Black_Box_Stable_Poly_Continuation
              ( p,q : in Poly_Sys; gamma : in Complex_Number;
                sol : in out Solution ) is

    z : Standard_Integer_Vectors.Vector(sol.v'range);
    nz : integer32;

  begin
    Zero_Type(sol.v,nz,z);
    if nz < sol.n then
      declare
        rs : Solution(sol.n-nz) := Remove_Zeroes(sol,nz,z);
        sp : Poly_Sys(p'range) := Substitute_Zeroes(p,z,nz);
        sq : Poly_Sys(q'range) := Substitute_Zeroes(q,z,nz);
        rp : constant Poly_Sys(p'first..p'last-nz) := Filter(sp);
        rq : constant Poly_Sys(q'first..q'last-nz) := Filter(sq);
      begin
        Stable_Poly_Continuation(rp,rq,gamma,rs);
        sol := Insert_Zeroes(rs,z);
        Clear(sp); Clear(sq);
      end;
    end if;
  end Black_Box_Stable_Poly_Continuation;

  procedure Black_Box_Stable_Poly_Continuation
              ( file : in file_type;
                p,q : in Poly_Sys; gamma : in Complex_Number;
                sol : in out Solution ) is

    z : Standard_Integer_Vectors.Vector(sol.v'range);
    nz : integer32;

  begin
    Zero_Type(sol.v,nz,z);
    if nz < sol.n then
      declare
        rs : Solution(sol.n-nz) := Remove_Zeroes(sol,nz,z);
        sp : Poly_Sys(p'range) := Substitute_Zeroes(p,z,nz);
        sq : Poly_Sys(q'range) := Substitute_Zeroes(q,z,nz);
        rp : constant Poly_Sys(p'first..p'last-nz) := Filter(sp);
        rq : constant Poly_Sys(q'first..q'last-nz) := Filter(sq);
      begin
        Stable_Poly_Continuation(file,rp,rq,gamma,rs);
        Clear(sp); Clear(sq);
        sol := Insert_Zeroes(rs,z);
      end;
    end if;
  end Black_Box_Stable_Poly_Continuation;

  procedure Black_Box_Stable_Poly_Continuation
                  ( p,q : in Poly_Sys; gamma : in Complex_Number;
                    sols : in out Solution_List;
                    pocotime : out duration ) is

    timer : timing_widget;
    tmp : Solution_List := sols;
    ls : Link_to_Solution;

  begin
    Continuation_Parameters.Tune(0,64);
    tstart(timer);
    while not Is_Null(tmp) loop
      ls := Head_Of(tmp);
      Black_Box_Stable_Poly_Continuation(p,q,gamma,ls.all);
      Set_Head(tmp,ls);
      tmp := Tail_Of(tmp);
    end loop;
    Silent_Black_Box_Refine(p,sols);
    tstop(timer);
    pocotime := Elapsed_User_Time(timer);
  end Black_Box_Stable_Poly_Continuation;

  procedure Black_Box_Stable_Poly_Continuation
               ( file : in file_type;
                 p,q : in Poly_Sys; gamma : in Complex_Number;
                 sols : in out Solution_List;
                 pocotime : out duration ) is

    timer : timing_widget;
    tmp : Solution_List := sols;
    ls : Link_to_Solution;

  begin
    Tune_Continuation_Parameters(file);
   -- new_line(file);
   -- put_line(file,"THE SOLUTIONS :");
   -- put(file,Length_Of(sols),1);
   -- put(file," "); put(file,Head_Of(sols).n,1);
   -- new_line(file);
    tstart(timer);
    while not Is_Null(tmp) loop
      ls := Head_Of(tmp);
      Black_Box_Stable_Poly_Continuation(file,p,q,gamma,ls.all);
      Set_Head(tmp,ls);
      tmp := Tail_Of(tmp);
    end loop;
    flush(file);
    Reporting_Black_Box_Refine(file,p,sols);
    tstop(timer);
    new_line(file);
    print_times(file,timer,"stable continuation");
    pocotime := Elapsed_User_Time(timer);
  end Black_Box_Stable_Poly_Continuation;

-- GENERAL POLYNOMIAL CONTINUATION :

  procedure Black_Box_Polynomial_Continuation
               ( p,q : in Poly_Sys; sols : in out Solution_List;
                 pocotime : out duration ) is

    gamma : constant Complex_Number := Random1;

  begin
    Black_Box_Polynomial_Continuation(p,q,gamma,sols,pocotime);
  end Black_Box_Polynomial_Continuation;

  procedure Black_Box_Polynomial_Continuation
               ( nt : in integer32;
                 p,q : in Poly_Sys; sols : in out Solution_List;
                 pocotime : out duration ) is

    gamma : constant Complex_Number := Random1;

  begin
    Black_Box_Polynomial_Continuation(nt,p,q,gamma,sols,pocotime);
  end Black_Box_Polynomial_Continuation;

  procedure Black_Box_Polynomial_Continuation
               ( file : in file_type; 
                 p,q : in Poly_Sys; sols : in out Solution_List;
                 pocotime : out duration ) is

    gamma : constant Complex_Number := Random1;

  begin
    Black_Box_Polynomial_Continuation(file,p,q,gamma,sols,pocotime);
  end Black_Box_Polynomial_Continuation;

  procedure Black_Box_Polynomial_Continuation
               ( file : in file_type; nt : in integer32;
                 p,q : in Poly_Sys; sols : in out Solution_List;
                 pocotime : out duration ) is

    gamma : constant Complex_Number := Random1;

  begin
    Black_Box_Polynomial_Continuation(file,nt,p,q,gamma,sols,pocotime);
  end Black_Box_Polynomial_Continuation;

  procedure Black_Box_Polynomial_Continuation
               ( p,q : in Poly_Sys; gamma : in Complex_Number;
                 sols : in out Solution_List;
                 pocotime : out duration ) is

    timer : timing_widget;
    k : constant natural32 := 2;
    one : constant quad_double := create(1.0);
    target : constant Complex_Number := Create(one);
    proj : constant boolean := false;

    procedure Cont is
      new Silent_Continue
            (Max_Norm,QuadDobl_Coefficient_Homotopy.Eval,
             QuadDobl_Homotopy.Diff,QuadDobl_Coefficient_Homotopy.Diff);

  begin
    QuadDobl_Homotopy.Create(p,q,k,gamma);
    QuadDobl_Coefficient_Homotopy.Create(q,p,k,gamma);
    Continuation_Parameters.Tune(0,64);
    tstart(timer);
    Cont(sols,target);
    tstop(timer);
    pocotime := Elapsed_User_Time(timer);
    Silent_Black_Box_Refine(p,sols);
    QuadDobl_Homotopy.Clear;
    QuadDobl_Coefficient_Homotopy.Clear;
  --exception  
  --  when others =>
  --    put_line("exception raised in first black box poly continuation");
  --    raise;
  end Black_Box_Polynomial_Continuation;

  procedure Black_Box_Polynomial_Continuation
               ( nt : in integer32;
                 p,q : in Poly_Sys; gamma : in Complex_Number;
                 sols : in out Solution_List;
                 pocotime : out duration ) is

    timer : timing_widget;
    k : constant natural32 := 2;

  begin
    QuadDobl_Homotopy.Create(p,q,k,gamma);
    QuadDobl_Coefficient_Homotopy.Create(q,p,k,gamma);
    Continuation_Parameters.Tune(0,64);
    tstart(timer);
    Silent_Multitasking_Path_Tracker(sols,nt);
    tstop(timer);
    pocotime := Elapsed_User_Time(timer);
    Silent_Black_Box_Refine(p,sols);
    QuadDobl_Homotopy.Clear;
    QuadDobl_Coefficient_Homotopy.Clear;
  end Black_Box_Polynomial_Continuation;

  procedure Black_Box_Polynomial_Continuation
               ( file : in file_type;
                 p,q : in Poly_Sys; gamma : in Complex_Number;
                 sols : in out Solution_List;
                 pocotime : out duration ) is

    timer : timing_widget;
    k : constant natural32 := 2;
    one : constant quad_double := create(1.0);
    target : constant Complex_Number := Create(one);
    proj : constant boolean := false;

    procedure Cont is
      new Reporting_Continue
            (Max_Norm,QuadDobl_Coefficient_Homotopy.Eval,
             QuadDobl_Homotopy.Diff,QuadDobl_Coefficient_Homotopy.Diff);

  begin
    Write_Homotopy_Parameters(file,k,gamma,target,proj);
    QuadDobl_Homotopy.Create(p,q,k,gamma);
    QuadDobl_Coefficient_Homotopy.Create(q,p,k,gamma);
    Tune_Continuation_Parameters(file);
   -- new_line(file);
   -- put_line(file,"THE SOLUTIONS :");
   -- put(file,Length_Of(sols),1);
   -- put(file," "); put(file,Head_Of(sols).n,1);
   -- new_line(file);
    tstart(timer);
    Cont(file,sols,target);
    tstop(timer);
    new_line(file);
    print_times(file,timer,"continuation");
    pocotime := Elapsed_User_Time(timer);
    flush(file);
    declare
    begin
      Reporting_Black_Box_Refine(file,p,sols);
   -- exception
   --   when others => 
   --     put_line("exception when calling Reporting_Black_Box_Refine...");
   --     raise;    
    end;
    QuadDobl_Homotopy.Clear;
    QuadDobl_Coefficient_Homotopy.Clear;
  --exception
  --  when others => put_line("exception in this routine..."); raise;
  end Black_Box_Polynomial_Continuation;

  procedure Black_Box_Polynomial_Continuation
               ( file : in file_type; nt : in integer32;
                 p,q : in Poly_Sys; gamma : in Complex_Number;
                 sols : in out Solution_List;
                 pocotime : out duration ) is

    timer : timing_widget;
    k : constant natural32 := 2;
    one : constant quad_double := create(1.0);
    target : constant Complex_Number := Create(one);
    proj : constant boolean := false;

  begin
    Write_Homotopy_Parameters(file,k,gamma,target,proj);
    QuadDobl_Homotopy.Create(p,q,k,gamma);
    QuadDobl_Coefficient_Homotopy.Create(q,p,k,gamma);
    Tune_Continuation_Parameters(file);
   -- new_line(file);
   -- put_line(file,"THE SOLUTIONS :");
   -- put(file,Length_Of(sols),1);
   -- put(file," "); put(file,Head_Of(sols).n,1);
   -- new_line(file);
    tstart(timer);
    Silent_Multitasking_Path_Tracker(sols,nt);
    tstop(timer);
    new_line(file);
    print_times(file,timer,"continuation");
    pocotime := Elapsed_User_Time(timer);
    flush(file);
    Reporting_Black_Box_Refine(file,nt,p,sols);
    QuadDobl_Homotopy.Clear;
    QuadDobl_Coefficient_Homotopy.Clear;
  end Black_Box_Polynomial_Continuation;

-- GENERAL AND STABLE CONTINUATION :

  procedure Black_Box_Polynomial_Continuation
               ( p,q : in Poly_Sys; sols,sols0 : in out Solution_List;
                 pocotime : out duration ) is

    gamma : constant Complex_Number := Random1;

  begin
    Black_Box_Polynomial_Continuation(p,q,gamma,sols,sols0,pocotime);
  end Black_Box_Polynomial_Continuation;

  procedure Black_Box_Polynomial_Continuation
               ( nt : in integer32;
                 p,q : in Poly_Sys; sols,sols0 : in out Solution_List;
                 pocotime : out duration ) is

    gamma : constant Complex_Number := Random1;

  begin
    Black_Box_Polynomial_Continuation(nt,p,q,gamma,sols,sols0,pocotime);
  end Black_Box_Polynomial_Continuation;

  procedure Black_Box_Polynomial_Continuation
               ( file : in file_type; 
                 p,q : in Poly_Sys; sols,sols0 : in out Solution_List;
                 pocotime : out duration ) is

    gamma : constant Complex_Number := Random1;

  begin
    Black_Box_Polynomial_Continuation(file,p,q,gamma,sols,sols0,pocotime);
  end Black_Box_Polynomial_Continuation;

  procedure Black_Box_Polynomial_Continuation
               ( file : in file_type; nt : in integer32;
                 p,q : in Poly_Sys; sols,sols0 : in out Solution_List;
                 pocotime : out duration ) is

    gamma : constant Complex_Number := Random1;

  begin
    Black_Box_Polynomial_Continuation(file,nt,p,q,gamma,sols,sols0,pocotime);
  end Black_Box_Polynomial_Continuation;

  procedure Black_Box_Polynomial_Continuation
               ( p,q : in Poly_Sys; gamma : in Complex_Number;
                 sols,sols0 : in out Solution_List;
                 pocotime : out duration ) is

    t1,t2 : duration;

  begin
    if not Is_Null(sols0) then
      Black_Box_Stable_Poly_Continuation(p,q,gamma,sols0,t1);
    else
      t1 := 0.0;
    end if;
    if not Is_Null(sols) then
      Black_Box_Polynomial_Continuation(p,q,gamma,sols,t2);
    else
      t2 := 0.0;
    end if;
    pocotime := t1 + t2;
  --exception
  --  when others =>
  --    put_line("Exception raised in black box polynomial continuation 1");
  --    raise;
  end Black_Box_Polynomial_Continuation;

  procedure Black_Box_Polynomial_Continuation
               ( nt : in integer32;
                 p,q : in Poly_Sys; gamma : in Complex_Number;
                 sols,sols0 : in out Solution_List;
                 pocotime : out duration ) is

    t1,t2 : duration;

  begin
    if not Is_Null(sols0) then
      Black_Box_Stable_Poly_Continuation(p,q,gamma,sols0,t1);
    else
      t1 := 0.0;
    end if;
    if not Is_Null(sols) then
      Black_Box_Polynomial_Continuation(nt,p,q,gamma,sols,t2);
    else
      t2 := 0.0;
    end if;
    pocotime := t1 + t2;
 -- exception
 --   when others =>
 --     put_line("Exception raised in black box polynomial continuation");
 --     raise;
  end Black_Box_Polynomial_Continuation;

  procedure Black_Box_Polynomial_Continuation
               ( file : in file_type; 
                 p,q : in Poly_Sys; gamma : in Complex_Number;
                 sols,sols0 : in out Solution_List;
                 pocotime : out duration ) is

    t1,t2 : duration;

  begin
    if not Is_Null(sols0) then
      Black_Box_Stable_Poly_Continuation(file,p,q,gamma,sols0,t1);
    else
      t1 := 0.0;
    end if;
    if not Is_Null(sols) then
      Black_Box_Polynomial_Continuation(file,p,q,gamma,sols,t2);
    else
      t2 := 0.0;
    end if;
    pocotime := t1 + t2;
  --exception
  --  when others =>
  --    put_line("Exception raised in black box polynomial continuation 2");
  --    raise;
  end Black_Box_Polynomial_Continuation;

  procedure Black_Box_Polynomial_Continuation
               ( file : in file_type; nt : in integer32;
                 p,q : in Poly_Sys; gamma : in Complex_Number;
                 sols,sols0 : in out Solution_List;
                 pocotime : out duration ) is

    t1,t2 : duration;

  begin
    if not Is_Null(sols0) then
      Black_Box_Stable_Poly_Continuation(file,p,q,gamma,sols0,t1);
    else
      t1 := 0.0;
    end if;
    if not Is_Null(sols) then
      Black_Box_Polynomial_Continuation(file,nt,p,q,gamma,sols,t2);
    else
      t2 := 0.0;
    end if;
    pocotime := t1 + t2;
 -- exception
 --   when others =>
 --     put_line("Exception raised in black box polynomial continuation");
 --     raise;
  end Black_Box_Polynomial_Continuation;

-- for Laurent polynomial systems :

  procedure Black_Box_Polynomial_Continuation
               ( p,q : in Laur_Sys; sols : in out Solution_List;
                 pocotime : out duration ) is

    k : constant natural32 := 2;
    gamma : constant Complex_Number := Random1;
    one : constant quad_double := create(1.0);
    target : constant Complex_Number := Create(one);
    proj : constant boolean := false;
    timer : Timing_Widget;

    procedure Cont is
      new Silent_Continue
            (Max_Norm,QuadDobl_Laurent_Homotopy.Eval,
             QuadDobl_Laurent_Homotopy.Diff,QuadDobl_Laurent_Homotopy.Diff);

  begin
    QuadDobl_Laurent_Homotopy.Create(p,q,k,gamma);
    Continuation_Parameters.Tune(0,64);
    tstart(timer);
    Cont(sols,target);
    tstop(timer);
    pocotime := Elapsed_User_Time(timer);
    Silent_Black_Box_Refine(p,sols);
    QuadDobl_Laurent_Homotopy.Clear;
  end black_Box_Polynomial_Continuation;

  procedure Black_Box_Polynomial_Continuation
               ( nt : in integer32;
                 p,q : in Laur_Sys; sols : in out Solution_List;
                 pocotime : out duration ) is

    k : constant natural32 := 2;
    gamma : constant Complex_Number := Random1;
    timer : Timing_Widget;

  begin
    QuadDobl_Laurent_Homotopy.Create(p,q,k,gamma);
    Continuation_Parameters.Tune(0,64);
    tstart(timer);
    Silent_Multitasking_Laurent_Path_Tracker(sols,nt);
    tstop(timer);
    pocotime := Elapsed_User_Time(timer);
    Silent_Black_Box_Refine(p,sols);
    QuadDobl_Laurent_Homotopy.Clear;
  end black_Box_Polynomial_Continuation;

  procedure Black_Box_Polynomial_Continuation
               ( file : in file_type; 
                 p,q : in Laur_Sys; sols : in out Solution_List;
                 pocotime : out duration ) is

    k : constant natural32 := 2;
    gamma : constant Complex_Number := Random1;
    one : constant quad_double := create(1.0);
    target : constant Complex_Number := Create(one);
    proj : constant boolean := false;
    timer : Timing_Widget;

    procedure Cont is
      new Reporting_Continue
            (Max_Norm,QuadDobl_Laurent_Homotopy.Eval,
             QuadDobl_Laurent_Homotopy.Diff,QuadDobl_Laurent_Homotopy.Diff);

  begin
    QuadDobl_Laurent_Homotopy.Create(p,q,k,gamma);
    Tune_Continuation_Parameters(file);
    tstart(timer);
    Cont(file,sols,target);
    tstop(timer);
    pocotime := Elapsed_User_Time(timer);
    Reporting_Black_Box_Refine(file,p,sols);
    QuadDobl_Laurent_Homotopy.Clear;
  end Black_Box_Polynomial_Continuation;

  procedure Black_Box_Polynomial_Continuation
               ( file : in file_type; nt : in integer32;
                 p,q : in Laur_Sys; sols : in out Solution_List;
                 pocotime : out duration ) is

    k : constant natural32 := 2;
    gamma : constant Complex_Number := Random1;
    timer : Timing_Widget;

  begin
    QuadDobl_Laurent_Homotopy.Create(p,q,k,gamma);
    Tune_Continuation_Parameters(file);
    tstart(timer);
    Silent_Multitasking_Laurent_Path_Tracker(sols,nt);
    tstop(timer);
    pocotime := Elapsed_User_Time(timer);
    Reporting_Black_Box_Refine(file,nt,p,sols);
    QuadDobl_Laurent_Homotopy.Clear;
  end Black_Box_Polynomial_Continuation;

end QuadDobl_BlackBox_Continuations;
