with text_io;                           use text_io;
with Communications_with_User;          use Communications_with_User;
with Timing_Package;                    use Timing_Package;
with Standard_Natural_Numbers;          use Standard_Natural_Numbers;
with Standard_Natural_Numbers_io;       use Standard_Natural_Numbers_io;
with Standard_Integer_Numbers;          use Standard_Integer_Numbers;
with Standard_Integer_Numbers_io;       use Standard_Integer_Numbers_io;
with Standard_Floating_Numbers;         use Standard_Floating_Numbers;
with Standard_Complex_Poly_Systems;
with QuadDobl_Complex_Poly_Systems;
with QuadDobl_Polynomial_Convertors;    use QuadDobl_Polynomial_Convertors;
with Standard_Complex_Solutions;
with QuadDobl_Complex_Solutions;
with Standard_System_and_Solutions_io;
with QuadDobl_System_and_Solutions_io;
with Root_Refining_Parameters;          use Root_Refining_Parameters;
with Multitasked_DD_QD_Refiners;        use Multitasked_DD_QD_Refiners;

procedure ts_mtqdref is

-- DESCRIPTION :
--   Test on multitasking a solution list of a polynomial system
--   with double double complex arithmetic.

  procedure Refine ( file : in file_type;
                     n : in integer32; output : in boolean;
                     p : in Standard_Complex_Poly_Systems.Poly_Sys;
                     s : in Standard_Complex_Solutions.Solution_List;
                     epsxa,epsfa : in double_float; maxit : in natural32 ) is

  -- DESCRIPTION :
  --   Refines the solutions s of p with complex quad double arithmetic,
  --   using n threads.

    qd_p : QuadDobl_Complex_Poly_Systems.Poly_Sys(p'range)
         := Standard_Poly_Sys_to_QuadDobl_Complex(p);
    qd_s : QuadDobl_Complex_Solutions.Solution_List
         := QuadDobl_Complex_Solutions.Create(s);
    timer : Timing_Widget;

  begin
    tstart(timer);
    Multitasking_Refinement(qd_p,qd_s,n,output,epsxa,epsfa,maxit);
    tstop(timer);
    QuadDobl_System_and_Solutions_io.put(file,qd_p,qd_s);
    new_line(file);
    print_times(file,timer,"multitasking refinement with quad doubles");
    QuadDobl_Complex_Poly_Systems.Clear(qd_p);
    QuadDobl_Complex_Solutions.Clear(qd_s);
  end Refine;

  procedure Main is

  -- DESCRIPTION :
  --   Prompts the user for a polynomial system, solutions,
  --   and the number of threads.

    p : Standard_Complex_Poly_Systems.Link_to_Poly_Sys;
    s : Standard_Complex_Solutions.Solution_List;
    n : integer32 := 0;
    file : file_type;
    ans : character;
    epsxa,epsfa,tolsing : double_float;
    maxit : natural32 := 0;
    deflate,wout : boolean;

  begin
    new_line;
    put_line("Test on multitasking refinement ...");
    new_line;
    put_line("Reading a system and its solutions ...");
    Standard_System_and_Solutions_io.get(p,s);
    new_line;
    put("Read "); put(Standard_Complex_Solutions.Length_Of(s),1);
    put_line(" solutions.");
    new_line;
    put_line("Reading the name of the output file...");
    Read_Name_and_Create_File(file);
    QuadDobl_Default_Root_Refining_Parameters
      (epsxa,epsfa,tolsing,maxit,deflate,wout);
    Standard_Menu_Root_Refining_Parameters
      (file,epsxa,epsfa,tolsing,maxit,deflate,wout);
    new_line;
    put("Give the number of threads : "); get(n); skip_line;
    new_line;
    put("Do you want to monitor the progress of the refinement ? (y/n) ");
    Ask_Yes_or_No(ans);
    wout := (ans = 'y');
    new_line;
    Refine(file,n,wout,p.all,s,epsxa,epsfa,maxit);
  end Main;

begin
  Main;
end ts_mtqdref;
