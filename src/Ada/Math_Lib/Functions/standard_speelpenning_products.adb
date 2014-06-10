with Standard_Complex_Numbers;            use Standard_Complex_Numbers;

package body Standard_Speelpenning_Products is

  function Straight_Speel
             ( x : Standard_Complex_Vectors.Vector )
             return Standard_Complex_Vectors.Vector is

    n : constant integer32 := x'last;
    res : Standard_Complex_Vectors.Vector(0..n);

  begin
    res(0) := x(1);
    res(n) := x(1);
    for i in 2..(n-1) loop   -- does 2*(n-1) multiplications
      res(0) := res(0)*x(i);
      res(n) := res(n)*x(i);
    end loop;
    res(0) := res(0)*x(n);   -- 2*(n-1) + 1 = 2*n - 1
    for i in 1..(n-1) loop
      res(i) := x(n);
      for j in 1..n-1 loop   -- does n*(n-2) multiplications
        if i /= j
         then res(i) := res(i)*x(j);
        end if;
      end loop;
    end loop;
    return res;
  end Straight_Speel;

  function Straight_Speel
             ( e : Standard_Natural_Vectors.Vector;
               x : Standard_Complex_Vectors.Vector )
             return Standard_Complex_Vectors.Vector is

    n : constant integer32 := x'last;
    res : Standard_Complex_Vectors.Vector(0..n);

  begin
    if e(1) = 0
     then res(0) := Create(1.0);
     else res(0) := x(1);
    end if;
    for i in 2..(n-1) loop   -- does |e|-1 multiplications
      if e(i) > 0
       then res(0) := res(0)*x(i);
      end if;
    end loop;
    if e(n) = 0 then
      res(n) := Create(0.0);
    else
      res(0) := res(0)*x(n);
      if e(1) = 0
       then res(n) := Create(1.0);
       else res(n) := x(1);
      end if;
      for i in 2..(n-1) loop
        if e(i) > 0
         then res(n) := res(n)*x(i);
        end if;
      end loop;
    end if;
    for i in 1..(n-1) loop
      if e(i) = 0 then
        res(i) := Create(0.0);
      else
        if e(n) = 0
         then res(i) := Create(1.0);
         else res(i) := x(n);
        end if;
        for j in 1..n-1 loop   -- does n*(n-2) multiplications
          if i /= j then
            if e(j) > 0
             then res(i) := res(i)*x(j);
            end if;
          end if;
        end loop;
      end if;
    end loop;
    return res;
  end Straight_Speel;

  function Reverse_Speel
             ( x : Standard_Complex_Vectors.Vector )
             return Standard_Complex_Vectors.Vector is

    n : constant integer32 := x'last;
    res : Standard_Complex_Vectors.Vector(0..n);
    fwd : Standard_Complex_Vectors.Vector(1..n);
    back : Complex_Number;

  begin
    fwd(1) := x(1);              -- fwd (forward) accumulates products
    for i in 2..n loop                     -- of consecutive variables
      fwd(i) := fwd(i-1)*x(i);             -- does n-1 multiplications
    end loop;
    res(0) := fwd(n);
    res(n) := fwd(n-1);
    back := x(n);                -- back accumulates backward products
    for i in reverse 2..n-1 loop       -- does 2*(n-2) multiplications
      res(i) := fwd(i-1)*back;
      back := x(i)*back;
    end loop;
    res(1) := back;
    return res;
  end Reverse_Speel;

  function Number_of_Nonzeroes
             ( e : Standard_Natural_Vectors.Vector ) return natural32 is

    res : natural32 := 0;

  begin
    for i in e'range loop
      if e(i) /= 0
       then res := res + 1;
      end if;
    end loop;
    return res;
  end Number_of_Nonzeroes;

  procedure Nonzeroes
             ( e : in Standard_Natural_Vectors.Vector;
               x : in Standard_Complex_Vectors.Vector;
               idx : out Standard_Integer_Vectors.Vector;
               enz : out Standard_Natural_Vectors.Vector;
               xnz : out Standard_Complex_Vectors.Vector ) is

    ind : integer32 := e'first-1;

  begin
    for i in e'range loop
      if e(i) /= 0 then
        ind := ind + 1;
        idx(ind) := i;
        enz(ind) := e(i);
        xnz(ind) := x(i);
      end if;
    end loop;
  end Nonzeroes;

  function Nonzero_Index
             ( e : Standard_Natural_Vectors.Vector ) return integer32 is
  begin
    for i in e'range loop
      if e(i) /= 0
       then return i;
      end if;
    end loop;
    return e'first-1;
  end Nonzero_Index;

  function Indexed_Speel
             ( nx,nz : integer32;
               indnz : Standard_Integer_Vectors.Vector;
               x : Standard_Complex_Vectors.Vector )
             return Standard_Complex_Vectors.Vector is

    res : Standard_Complex_Vectors.Vector(0..nx);
    nzx : Standard_Complex_Vectors.Vector(1..nz);
    eva : Standard_Complex_Vectors.Vector(0..nz);

  begin
    for k in 1..nz loop
      nzx(k) := x(indnz(k));
    end loop;
    eva := Reverse_Speel(nzx);
    res(0) := eva(0);
    res(1..nx) := (1..nx => Create(0.0));
    for i in 1..nz loop
      res(indnz(i)) := eva(i);
    end loop;
    return res;
  end Indexed_Speel;

  function Reverse_Speel
             ( e : Standard_Natural_Vectors.Vector;
               x : Standard_Complex_Vectors.Vector )
             return Standard_Complex_Vectors.Vector is

    n : constant integer32 := x'last;
    cntnz : integer32 := 0;         -- counts nonzero exponents in e
    res : Standard_Complex_Vectors.Vector(0..n);
    fwd : Standard_Complex_Vectors.Vector(1..n);
    idx : Standard_Integer_Vectors.Vector(1..n);
    ind : integer32 := 0;
    back : Complex_Number;

  begin
    for i in e'range loop             -- initialize forward products
      if e(i) /= 0
       then fwd(1) := x(i); ind := i+1; idx(1) := i; exit; 
      end if;
    end loop;
    res(1..n) := (1..n => Create(0.0));
    if ind = 0 then              -- case of a constant: all e(i) = 0
      res(0) := Create(1.0);
    else
      cntnz := 1;
      for i in ind..e'last loop             -- make forward products
        if e(i) /= 0 then             -- skipping the zero exponents
          cntnz := cntnz + 1; idx(cntnz) := i;
          fwd(cntnz) := fwd(cntnz-1)*x(i);
        end if;
      end loop;
      if cntnz = 1 then
        res(0) := x(ind-1);
        res(1..n) := (1..n => Create(0.0));
        res(ind-1) := Create(1.0);
      else
        res(0) := fwd(cntnz);                   -- value of monomial
        res(idx(cntnz)) := fwd(cntnz-1);          -- last derivative
        back := x(idx(cntnz));      -- accumulates backward products
        for i in reverse 2..cntnz-1 loop   
          res(idx(i)) := fwd(i-1)*back;
          back := x(idx(i))*back;
        end loop;
        res(idx(1)) := back;
      end if;
    end if;
    return res;
  end Reverse_Speel;

end Standard_Speelpenning_Products;
