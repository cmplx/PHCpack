with Standard_Natural_Numbers_io;        use Standard_Natural_Numbers_io;
with Standard_Floating_Numbers_io;       use Standard_Floating_Numbers_io;
with Standard_Complex_Numbers;
with Standard_Complex_Numbers_io;        use Standard_Complex_Numbers_io;
with Standard_Complex_VecVecs;
with Standard_Complex_Vector_Norms;
with Standard_Homotopy;
with Standard_Complex_Series_Vectors;
with Standard_CSeries_Vector_Functions;
with Standard_Pade_Approximants;
with Homotopy_Pade_Approximants;
with Homotopy_Mixed_Residuals;
with Homotopy_Newton_Steps;
with Series_and_Homotopies;
with Series_and_Predictors;

package body Standard_Pade_Trackers is

  function Minimum ( a, b : in double_float ) return double_float is
  begin
    if a < b
     then return a;
     else return b;
    end if;
  end Minimum;

  procedure Set_Step
              ( t,step : in out double_float;
                maxstep,target : in double_float ) is

    update : double_float;

  begin
    if step > maxstep
     then step := maxstep;
    end if;
    update := t + step;
    if update <= target then
      t := update;
    else
      step := target - t;
      t := target; 
    end if;
  end Set_Step;

  procedure Update_Step_Sizes
              ( minsize,maxsize : in out double_float;
                step : in double_float ) is
  begin
    if step < minsize then
      minsize := step;
    elsif step > maxsize then
      maxsize := step;
    end if;
  end Update_Step_Sizes;

  function Residual_Prediction
              ( sol : Standard_Complex_Vectors.Vector;
                t : double_float ) return double_float is

    res : double_float;
    cmplxt : constant Standard_Complex_Numbers.Complex_Number
           := Standard_Complex_Numbers.Create(t);
    val : constant Standard_Complex_Vectors.Vector
       := Standard_Homotopy.Eval(sol,cmplxt);

  begin
    res := Standard_Complex_Vector_Norms.Max_Norm(val);
    return res;
  end Residual_Prediction;

  function Residual_Prediction
              ( abh : Standard_Complex_Poly_SysFun.Eval_Poly_Sys;
                sol : Standard_Complex_Vectors.Vector;
                t : double_float ) return double_float is

    res : double_float;
    cmplxt : constant Standard_Complex_Numbers.Complex_Number
           := Standard_Complex_Numbers.Create(t);

  begin
    res := Homotopy_mixed_Residuals.Residual(abh,sol,cmplxt);
    return res;
  end Residual_Prediction;

  function Residual_Prediction
              ( file : file_type;
                abh : Standard_Complex_Poly_SysFun.Eval_Poly_Sys;
                sol : Standard_Complex_Vectors.Vector;
                t : double_float ) return double_float is

    res : double_float;
    cmplxt : constant Standard_Complex_Numbers.Complex_Number
           := Standard_Complex_Numbers.Create(t);

  begin
    res := Homotopy_mixed_Residuals.Residual(file,abh,sol,cmplxt);
    return res;
  end Residual_Prediction;

  procedure Track_One_Path
              ( abh : in Standard_Complex_Poly_SysFun.Eval_Poly_Sys;
                jm : in Standard_Complex_Jaco_Matrices.Link_to_Jaco_Mat;
                hs : in Standard_Complex_Hessians.Link_to_Array_of_Hessians;
                hom : in Standard_CSeries_Poly_Systems.Poly_Sys;
                sol : in out Standard_Complex_Solutions.Solution;
                pars : in Homotopy_Continuation_Parameters.Parameters;
                nbrsteps,nbrcorrs,cntfail : out natural32;
                minsize,maxsize : out double_float;
                vrblvl : in integer32 := 0 ) is

    wrk : Standard_CSeries_Poly_Systems.Poly_Sys(hom'range);
   -- nbq : constant integer32 := hom'last;
    numdeg : constant integer32 := integer32(pars.numdeg);
    dendeg : constant integer32 := integer32(pars.dendeg);
    maxdeg : constant integer32 := numdeg + dendeg + 2; -- + 1; -- + 2;
    nit : constant integer32 := integer32(pars.corsteps+2);
    srv : Standard_Complex_Series_Vectors.Vector(1..sol.n);
    eva : Standard_Complex_Series_Vectors.Vector(hom'range);
    pv : Standard_Pade_Approximants.Pade_Vector(srv'range)
       := Standard_Pade_Approximants.Allocate(sol.n,numdeg,dendeg);
    poles : Standard_Complex_VecVecs.VecVec(pv'range)
          := Homotopy_Pade_Approximants.Allocate_Standard_Poles(sol.n,dendeg);
   -- tolcff : constant double_float := pars.epsilon;
    alpha : constant double_float := pars.alpha;
    tolres : constant double_float := pars.tolres;
    dbeta : constant double_float := pars.cbeta;
    maxit : constant natural32 := 50;
    extra : constant natural32 := maxit/10;
    fail : boolean;
    t,step,dstep : double_float := 0.0;
    max_steps : constant natural32 := pars.maxsteps;
    wrk_sol : Standard_Complex_Vectors.Vector(1..sol.n) := sol.v;
    onetarget : constant double_float := 1.0;
    err,rco,res,frp,predres : double_float;
    cfp : Standard_Complex_Numbers.Complex_Number;
    nbrit : natural32 := 0;

  begin
    if vrblvl > 0
     then put_line("-> in standard_pade_trackers.Track_One_Path 1 ...");
    end if;
    minsize := 1.0; maxsize := 0.0;
    Standard_CSeries_Poly_Systems.Copy(hom,wrk);
    nbrcorrs := 0; cntfail := 0;
    nbrsteps := max_steps;
    for k in 1..max_steps loop
      Series_and_Predictors.Newton_Prediction(maxdeg,nit,wrk,wrk_sol,srv,eva);
      Series_and_Predictors.Pade_Approximants(srv,pv,poles,frp,cfp);
     -- step := Series_and_Predictors.Set_Step_Size(eva,tolcff,alpha);
     -- step := pars.sbeta*step;
      Standard_Complex_Series_Vectors.Clear(eva);
     -- dstep := Series_and_Predictors.Step_Distance
     --            (maxdeg,dbeta,t,jm,hs,wrk_sol,srv,pv);
     -- step := Series_and_Predictors.Cap_Step_Size(step,frp,pars.pbeta);
     -- step := Minimum(step,dstep); -- ignore series step
      dstep := pars.maxsize; -- ignore Hessian step size
      step := Series_and_Predictors.Cap_Step_Size(dstep,frp,pars.pbeta);
      Set_Step(t,step,pars.maxsize,onetarget);
      loop
        loop
          wrk_sol := Series_and_Predictors.Predicted_Solution(pv,step);
         -- predres := Residual_Prediction(wrk_sol,t);
          predres := Residual_Prediction(abh,wrk_sol,t);
          exit when (predres <= alpha);
          t := t - step; step := step/2.0; t := t + step;
         -- exit when (step < pars.minsize);
          exit when (step <= alpha);
        end loop;
        Update_Step_Sizes(minsize,maxsize,step);
        exit when ((step < pars.minsize) and (predres > alpha));
        Homotopy_Newton_Steps.Correct
          (abh,t,tolres,maxit,nbrit,wrk_sol,err,rco,res,fail,extra);
         -- (nbq,t,tolres,maxit,nbrit,wrk_sol,err,rco,res,fail,extra);
        nbrcorrs := nbrcorrs + nbrit;
        exit when (not fail);
        step := step/2.0; cntfail := cntfail + 1;
        exit when (step < pars.minsize);
      end loop;
      Standard_Complex_Series_Vectors.Clear(srv);
      if t = 1.0 then        -- converged and reached the end
        nbrsteps := k; exit;
      elsif (fail and (step < pars.minsize)) then -- diverged
        nbrsteps := k; exit;
      end if;
      Series_and_Homotopies.Shift(wrk,-step);
    end loop;
    Standard_Pade_Approximants.Clear(pv);
    Standard_Complex_VecVecs.Clear(poles);
    Standard_CSeries_Poly_Systems.Clear(wrk);
    wrk := Series_and_Homotopies.Shift(hom,-1.0);
    Homotopy_Newton_Steps.Correct
      (abh,1.0,tolres,pars.corsteps,nbrit,wrk_sol,err,rco,res,fail,extra);
     -- (nbq,1.0,tolres,pars.corsteps,nbrit,wrk_sol,err,rco,res,fail,extra);
    nbrcorrs := nbrcorrs + nbrit;
    sol.t := Standard_Complex_Numbers.Create(t);
    sol.v := wrk_sol;
    sol.err := err; sol.rco := rco; sol.res := res;
    Standard_CSeries_Poly_Systems.Clear(wrk);
  end Track_One_Path;

  procedure Track_One_Path
              ( file : in file_type;
                abh : in Standard_Complex_Poly_SysFun.Eval_Poly_Sys;
                jm : in Standard_Complex_Jaco_Matrices.Link_to_Jaco_Mat;
                hs : in Standard_Complex_Hessians.Link_to_Array_of_Hessians;
                hom : in Standard_CSeries_Poly_Systems.Poly_Sys;
                sol : in out Standard_Complex_Solutions.Solution;
                pars : in Homotopy_Continuation_Parameters.Parameters;
                nbrsteps,nbrcorrs,cntfail : out natural32;
                minsize,maxsize : out double_float;
                verbose : in boolean := false;
                vrblvl : in integer32 := 0 ) is

    wrk : Standard_CSeries_Poly_Systems.Poly_Sys(hom'range);
   -- nbq : constant integer32 := hom'last;
    nit : constant integer32 := integer32(pars.corsteps+2);
    numdeg : constant integer32 := integer32(pars.numdeg);
    dendeg : constant integer32 := integer32(pars.dendeg);
    maxdeg : constant integer32 := numdeg + dendeg + 2; -- + 1; -- + 2;
    srv : Standard_Complex_Series_Vectors.Vector(1..sol.n);
    eva : Standard_Complex_Series_Vectors.Vector(hom'range);
    pv : Standard_Pade_Approximants.Pade_Vector(srv'range)
       := Standard_Pade_Approximants.Allocate(sol.n,numdeg,dendeg);
    poles : Standard_Complex_VecVecs.VecVec(pv'range)
          := Homotopy_Pade_Approximants.Allocate_Standard_Poles(sol.n,dendeg);
    tolcff : constant double_float := pars.epsilon;
    alpha : constant double_float := pars.alpha;
    tolres : constant double_float := pars.tolres;
    dbeta : constant double_float := pars.cbeta;
    maxit : constant natural32 := 50;
    extra : constant natural32 := maxit/10;
    fail : boolean;
    t,step,dstep,pstep : double_float := 0.0;
    max_steps : constant natural32 := pars.maxsteps;
    wrk_sol : Standard_Complex_Vectors.Vector(1..sol.n) := sol.v;
    onetarget : constant double_float := 1.0;
    err,rco,res,frp,predres : double_float;
    cfp : Standard_Complex_Numbers.Complex_Number;
    nbrit : natural32 := 0;

  begin
    if vrblvl > 0
     then put_line("-> in standard_pade_trackers.Track_One_Path 2 ...");
    end if;
    minsize := 1.0; maxsize := 0.0;
    Standard_CSeries_Poly_Systems.Copy(hom,wrk);
    nbrcorrs := 0; cntfail := 0;
    nbrsteps := max_steps;
    for k in 1..max_steps loop
      if verbose then
        put(file,"Step "); put(file,k,1); put(file," : ");
      end if;
      Series_and_Predictors.Newton_Prediction
        (file,maxdeg,nit,wrk,wrk_sol,srv,eva,false); -- verbose);
      Series_and_Predictors.Pade_Approximants(srv,pv,poles,frp,cfp);
      if verbose then
        put(file,"Smallest pole radius :");
        put(file,frp,3); new_line(file);
        put(file,"Closest pole :"); put(file,cfp); new_line(file);
      end if;
      step := Series_and_Predictors.Set_Step_Size
                (file,eva,tolcff,alpha,verbose);
      step := pars.sbeta*step;
     -- step := Series_and_Predictors.Cap_Step_Size(step,frp,pars.pbeta);
     -- ignore series step
      if verbose then
        put(file,"series step : "); put(step,2); 
      end if;
      dstep := Series_and_Predictors.Step_Distance
                 (maxdeg,dbeta,t,jm,hs,wrk_sol,srv,pv);
      if verbose then
        put(file,"  Hessian step : "); put(file,dstep,2);
        pstep := frp*pars.pbeta;
        put(file,"  pole step : "); put(file,pstep,2);
        new_line(file);
      end if;
      dstep := pars.maxsize; -- ignore Hessian step
      step := Series_and_Predictors.Cap_Step_Size(dstep,frp,pars.pbeta);
     -- step := Minimum(step,dstep);
      Standard_Complex_Series_Vectors.Clear(eva);
      Set_Step(t,step,pars.maxsize,onetarget);
      if verbose then
        put(file,"Step size : "); put(file,step,3);
        put(file," t = "); put(file,t,3);
      end if;
      loop
        loop
          wrk_sol := Series_and_Predictors.Predicted_Solution(pv,step);
         -- predres := Residual_Prediction(wrk_sol,t);
          predres := Residual_Prediction(abh,wrk_sol,t);
          if verbose
           then put(file,"  residual : "); put(file,predres,3); new_line(file);
          end if;
          exit when (predres <= alpha);
          t := t - step; step := step/2.0; t := t + step;
          if verbose then
            put(file,"Step size : "); put(file,step,3);
            put(file," t = "); put(file,t,3);
          end if;
         -- exit when (step < pars.minsize);
          exit when (step <= alpha);
        end loop;
        Update_Step_Sizes(minsize,maxsize,step);
        exit when ((step < pars.minsize) and (predres > alpha));
        Homotopy_Newton_Steps.Correct
          (file,abh,t,tolres,maxit,nbrit,wrk_sol,err,rco,res,fail,
           extra,verbose);
         -- (file,nbq,t,tolres,maxit,nbrit,wrk_sol,err,rco,res,fail,
         --  extra,verbose);
        nbrcorrs := nbrcorrs + nbrit;
        exit when (not fail);
        step := step/2.0; cntfail := cntfail + 1;
        exit when (step < pars.minsize);
      end loop;
      Standard_Complex_Series_Vectors.Clear(srv);
      if t = 1.0 then        -- converged and reached the end
        nbrsteps := k; exit;
      elsif (fail and (step < pars.minsize)) then -- diverged
        nbrsteps := k; exit;
      end if;
      Series_and_Homotopies.Shift(wrk,-step);
    end loop;
    Standard_Pade_Approximants.Clear(pv);
    Standard_Complex_VecVecs.Clear(poles);
    Standard_CSeries_Poly_Systems.Clear(wrk);
    Homotopy_Newton_Steps.Correct
      (file,abh,1.0,tolres,pars.corsteps,nbrit,wrk_sol,err,rco,res,fail,
       extra,verbose);
     -- (file,nbq,1.0,tolres,pars.corsteps,nbrit,
     --  wrk_sol,err,rco,res,fail,extra,verbose);
    nbrcorrs := nbrcorrs + nbrit;
    sol.t := Standard_Complex_Numbers.Create(t);
    sol.v := wrk_sol;
    sol.err := err; sol.rco := rco; sol.res := res;
  end Track_One_Path;

-- VERSIONS ON COEFFICIENT-PARAMETER HOMOTOPIES :

  procedure Track_One_Path
              ( abh : in Standard_Complex_Poly_SysFun.Eval_Poly_Sys;
                jm : in Standard_Complex_Jaco_Matrices.Link_to_Jaco_Mat;
                hs : in Standard_Complex_Hessians.Link_to_Array_of_Hessians;
                fhm : in Standard_CSeries_Poly_SysFun.Eval_Coeff_Poly_Sys;
                fcf : in Standard_Complex_Series_VecVecs.VecVec;
                ejm : in Standard_CSeries_Jaco_Matrices.Eval_Coeff_Jaco_Mat;
                mlt : in Standard_CSeries_Jaco_Matrices.Mult_Factors;
                sol : in out Standard_Complex_Solutions.Solution;
                pars : in Homotopy_Continuation_Parameters.Parameters;
                nbrsteps,nbrcorrs,cntfail : out natural32;
                minsize,maxsize : out double_float;
                vrblvl : in integer32 := 0 ) is

   -- nbq : constant integer32 := fhm'last;
    numdeg : constant integer32 := integer32(pars.numdeg);
    dendeg : constant integer32 := integer32(pars.dendeg);
    maxdeg : constant integer32 := numdeg + dendeg + 2; -- + 1; -- + 2;
    nit : constant integer32 := integer32(pars.corsteps+2);
    srv : Standard_Complex_Series_Vectors.Vector(1..sol.n);
    eva : Standard_Complex_Series_Vectors.Vector(fhm'range);
    pv : Standard_Pade_Approximants.Pade_Vector(srv'range)
       := Standard_Pade_Approximants.Allocate(sol.n,numdeg,dendeg);
    poles : Standard_Complex_VecVecs.VecVec(pv'range)
          := Homotopy_Pade_Approximants.Allocate_Standard_Poles(sol.n,dendeg);
   -- tolcff : constant double_float := pars.epsilon;
    alpha : constant double_float := pars.alpha;
    tolres : constant double_float := pars.tolres;
    dbeta : constant double_float := pars.cbeta;
    maxit : constant natural32 := 50;
    extra : constant natural32 := maxit/10;
    fail : boolean;
    t,step,dstep : double_float := 0.0;
    max_steps : constant natural32 := pars.maxsteps;
    wrk_sol : Standard_Complex_Vectors.Vector(1..sol.n) := sol.v;
    onetarget : constant double_float := 1.0;
    err,rco,res,frp,predres : double_float;
    cfp : Standard_Complex_Numbers.Complex_Number;
    nbrit : natural32 := 0;
    wrk_fcf : Standard_Complex_Series_VecVecs.VecVec(fcf'range);

  begin
    if vrblvl > 0
     then put_line("-> in standard_pade_trackers.Track_One_Path 3 ...");
    end if;
    minsize := 1.0; maxsize := 0.0;
    nbrcorrs := 0; cntfail := 0;
    nbrsteps := max_steps;
    wrk_fcf := Standard_CSeries_Vector_Functions.Make_Deep_Copy(fcf);
    for k in 1..max_steps loop
      Series_and_Predictors.Newton_Prediction
        (maxdeg,nit,fhm,wrk_fcf,ejm,mlt,wrk_sol,srv,eva);
      Series_and_Predictors.Pade_Approximants(srv,pv,poles,frp,cfp);
     -- step := Series_and_Predictors.Set_Step_Size(eva,tolcff,alpha);
     -- step := pars.sbeta*step;
      Standard_Complex_Series_Vectors.Clear(eva);
     -- step := Series_and_Predictors.Cap_Step_Size(step,frp,pars.pbeta);
     -- dstep := Series_and_Predictors.Step_Distance
     --            (maxdeg,dbeta,t,jm,hs,wrk_sol,srv,pv);
     -- step := Minimum(step,dstep); -- ignore series step
      dstep := pars.maxsize; -- ignore Hessian step
      step := Series_and_Predictors.Cap_Step_Size(dstep,frp,pars.pbeta);
      Set_Step(t,step,pars.maxsize,onetarget);
      loop
        loop
          wrk_sol := Series_and_Predictors.Predicted_Solution(pv,step);
         -- predres := Residual_Prediction(wrk_sol,t);
          predres := Residual_Prediction(abh,wrk_sol,t);
          exit when (predres <= alpha);
          t := t - step; step := step/2.0; t := t + step;
         -- exit when (step < pars.minsize);
          exit when (step <= alpha);
        end loop;
        Update_Step_Sizes(minsize,maxsize,step);
        exit when ((step < pars.minsize) and (predres > alpha));
        Homotopy_Newton_Steps.Correct
          (abh,t,tolres,maxit,nbrit,wrk_sol,err,rco,res,fail,extra);
         -- (nbq,t,tolres,maxit,nbrit,wrk_sol,err,rco,res,fail,extra);
        nbrcorrs := nbrcorrs + nbrit;
        exit when (not fail);
        step := step/2.0; cntfail := cntfail + 1;
        exit when (step < pars.minsize);
      end loop;
      Standard_Complex_Series_Vectors.Clear(srv);
      if t = 1.0 then        -- converged and reached the end
        nbrsteps := k; exit;
      elsif (fail and (step < pars.minsize)) then -- diverged
        nbrsteps := k; exit;
      end if;
      Standard_CSeries_Vector_Functions.Shift(wrk_fcf,-step);
    end loop;
    Standard_Pade_Approximants.Clear(pv);
    Standard_Complex_VecVecs.Clear(poles);
    Homotopy_Newton_Steps.Correct
      (abh,1.0,tolres,pars.corsteps,nbrit,wrk_sol,err,rco,res,fail,extra);
     -- (nbq,1.0,tolres,pars.corsteps,nbrit,wrk_sol,err,rco,res,fail,extra);
    nbrcorrs := nbrcorrs + nbrit;
    sol.t := Standard_Complex_Numbers.Create(t);
    sol.v := wrk_sol;
    sol.err := err; sol.rco := rco; sol.res := res;
    Standard_CSeries_Vector_Functions.Deep_Clear(wrk_fcf);
  end Track_One_Path;

  procedure Track_One_Path
              ( file : in file_type;
                abh : in Standard_Complex_Poly_SysFun.Eval_Poly_Sys;
                jm : in Standard_Complex_Jaco_Matrices.Link_to_Jaco_Mat;
                hs : in Standard_Complex_Hessians.Link_to_Array_of_Hessians;
                fhm : in Standard_CSeries_Poly_SysFun.Eval_Coeff_Poly_Sys;
                fcf : in Standard_Complex_Series_VecVecs.VecVec;
                ejm : in Standard_CSeries_Jaco_Matrices.Eval_Coeff_Jaco_Mat;
                mlt : in Standard_CSeries_Jaco_Matrices.Mult_Factors;
                sol : in out Standard_Complex_Solutions.Solution;
                pars : in Homotopy_Continuation_Parameters.Parameters;
                nbrsteps,nbrcorrs,cntfail : out natural32;
                minsize,maxsize : out double_float;
                verbose : in boolean := false;
                vrblvl : in integer32 := 0 ) is

   -- nbq : constant integer32 := fhm'last;
    nit : constant integer32 := integer32(pars.corsteps+2);
    numdeg : constant integer32 := integer32(pars.numdeg);
    dendeg : constant integer32 := integer32(pars.dendeg);
    maxdeg : constant integer32 := numdeg + dendeg +2; -- + 1; -- + 2;
    srv : Standard_Complex_Series_Vectors.Vector(1..sol.n);
    eva : Standard_Complex_Series_Vectors.Vector(fhm'range);
    pv : Standard_Pade_Approximants.Pade_Vector(srv'range)
       := Standard_Pade_Approximants.Allocate(sol.n,numdeg,dendeg);
    poles : Standard_Complex_VecVecs.VecVec(pv'range)
          := Homotopy_Pade_Approximants.Allocate_Standard_Poles(sol.n,dendeg);
    tolcff : constant double_float := pars.epsilon;
    alpha : constant double_float := pars.alpha;
    tolres : constant double_float := pars.tolres;
    dbeta : constant double_float := pars.cbeta;
    maxit : constant natural32 := 50;
    extra : constant natural32 := maxit/10;
    fail : boolean;
    t,step,dstep,pstep : double_float := 0.0;
    max_steps : constant natural32 := pars.maxsteps;
    wrk_sol : Standard_Complex_Vectors.Vector(1..sol.n) := sol.v;
    onetarget : constant double_float := 1.0;
    err,rco,res,frp,predres : double_float;
    cfp : Standard_Complex_Numbers.Complex_Number;
    nbrit : natural32 := 0;
    wrk_fcf : Standard_Complex_Series_VecVecs.VecVec(fcf'range);

  begin
    if vrblvl > 0
     then put_line("-> in standard_pade_trackers.Track_One_Path 4 ...");
    end if;
    minsize := 1.0; maxsize := 0.0;
    nbrcorrs := 0; cntfail := 0;
    nbrsteps := max_steps;
    wrk_fcf := Standard_CSeries_Vector_Functions.Make_Deep_Copy(fcf);
    for k in 1..max_steps loop
      if verbose then
        put(file,"Step "); put(file,k,1); put(file," : ");
      end if;
      Series_and_Predictors.Newton_Prediction -- no verbose flag set
        (file,maxdeg,nit,fhm,wrk_fcf,ejm,mlt,wrk_sol,srv,eva,false);
      Series_and_Predictors.Pade_Approximants(srv,pv,poles,frp,cfp);
      if verbose then
        put(file,"Smallest pole radius :");
        put(file,frp,3); new_line(file);
        put(file,"Closest pole :"); put(file,cfp); new_line(file);
      end if;
      step := Series_and_Predictors.Set_Step_Size
                (file,eva,tolcff,alpha,verbose);
      step := pars.sbeta*step;
      if verbose then
        put(file,"series step : "); put(file,step,2);
      end if;
     -- step := Series_and_Predictors.Cap_Step_Size(step,frp,pars.pbeta);
      Standard_Complex_Series_Vectors.Clear(eva);
      dstep := Series_and_Predictors.Step_Distance
                 (maxdeg,dbeta,t,jm,hs,wrk_sol,srv,pv);
      if verbose then
        put(file,"  Hessian step : "); put(file,dstep,2);
        pstep := frp*pars.pbeta;
        put(file,"  pole step : "); put(file,pstep,2); new_line(file);
      end if;
     -- step := Series_and_Predictors.Cap_Step_Size(dstep,frp,pars.pbeta);
      dstep := pars.maxsize; -- ignore Hessian step
      step := Minimum(dstep,pstep);
      Set_Step(t,step,pars.maxsize,onetarget);
      if verbose then
        put(file,"Step size : "); put(file,step,3);
        put(file," t = "); put(file,t,3);
      end if;
      loop
        loop
          wrk_sol := Series_and_Predictors.Predicted_Solution(pv,step);
         -- predres := Residual_Prediction(wrk_sol,t);
          if not verbose then
           -- predres := Residual_Prediction(wrk_sol,t);
            predres := Residual_Prediction(abh,wrk_sol,t);
          else
           -- predres := Residual_Prediction(wrk_sol,t);
            predres := Residual_Prediction(file,abh,wrk_sol,t);
            put(file,"  residual : "); put(file,predres,3); new_line(file);
          end if;
          exit when (predres <= alpha);
          t := t - step; step := step/2.0; t := t + step;
          if verbose then
            put(file,"Step size : "); put(file,step,3);
            put(file," t = "); put(file,t,3);
          end if;
          exit when (step < pars.minsize);
         -- exit when (step <= alpha);
        end loop;
        Update_Step_Sizes(minsize,maxsize,step);
        exit when ((step < pars.minsize) and (predres > alpha));
        Homotopy_Newton_Steps.Correct
          (file,abh,t,tolres,maxit,nbrit,wrk_sol,err,rco,res,fail,
           extra,verbose);
         -- (file,nbq,t,tolres,maxit,nbrit,wrk_sol,err,rco,res,fail,
         --  extra,verbose);
        if verbose then
          if fail
           then put_line(file,"The correct stage failed."); fail := false;
           else put_line(file,"The correct stage succeeded.");
          end if;
        end if;
        nbrcorrs := nbrcorrs + nbrit;
        exit when (not fail);
        step := step/2.0; cntfail := cntfail + 1;
        exit when (step < pars.minsize);
      end loop;
      Standard_Complex_Series_Vectors.Clear(srv);
      if t = 1.0 then        -- converged and reached the end
        nbrsteps := k; exit;
      elsif (fail and (step < pars.minsize)) then -- diverged
        nbrsteps := k; exit;
      end if;
      Standard_CSeries_Vector_Functions.Shift(wrk_fcf,-step);
    end loop;
    Standard_Pade_Approximants.Clear(pv);
    Standard_Complex_VecVecs.Clear(poles);
    Homotopy_Newton_Steps.Correct
      (file,abh,1.0,tolres,pars.corsteps,nbrit,wrk_sol,err,rco,res,fail,
       extra,verbose);
     -- (file,nbq,1.0,tolres,pars.corsteps,nbrit,wrk_sol,err,rco,res,fail,
     --  extra,verbose);
    nbrcorrs := nbrcorrs + nbrit;
    sol.t := Standard_Complex_Numbers.Create(t);
    sol.v := wrk_sol;
    sol.err := err; sol.rco := rco; sol.res := res;
    Standard_CSeries_Vector_Functions.Deep_Clear(wrk_fcf);
  end Track_One_Path;

end Standard_Pade_Trackers;