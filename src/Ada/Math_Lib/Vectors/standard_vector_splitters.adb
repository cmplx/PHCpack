with Standard_Complex_Numbers;

package body Standard_Vector_Splitters is

-- FUNCTIONS WITH MEMORY ALLOCATIONS :

  function Real_Part ( x : Standard_Complex_Vectors.Vector )
                     return Standard_Floating_Vectors.Vector is

    res : Standard_Floating_Vectors.Vector(x'range);

  begin
    for k in x'range loop
      res(k) := Standard_Complex_Numbers.REAL_PART(x(k));
    end loop;
    return res;
  end Real_Part;

  function Real_Part ( x : Standard_Complex_Vectors.Link_to_Vector )
                     return Standard_Floating_Vectors.Link_to_Vector is

    res : Standard_Floating_Vectors.Link_to_Vector;
    rpx : Standard_Floating_Vectors.Vector(x'range);

  begin
    for k in x'range loop
      rpx(k) := Standard_Complex_Numbers.REAL_PART(x(k));
    end loop;
    res := new Standard_Floating_Vectors.Vector'(rpx);
    return res;
  end Real_Part;

  function Real_Part ( x : Standard_Complex_VecVecs.Link_to_VecVec )
                     return Standard_Floating_VecVecs.Link_to_VecVec is

    res : Standard_Floating_VecVecs.Link_to_VecVec;
    rpx : Standard_Floating_VecVecs.VecVec(x'range);

  begin
    for k in x'range loop
      rpx(k) := Real_Part(x(k));
    end loop;
    res := new Standard_Floating_VecVecs.VecVec'(rpx);
    return res;
  end Real_Part;

  function Imag_Part ( x : Standard_Complex_Vectors.Vector )
                     return Standard_Floating_Vectors.Vector is

    res : Standard_Floating_Vectors.Vector(x'range);

  begin
    for k in x'range loop
      res(k) := Standard_Complex_Numbers.IMAG_PART(x(k));
    end loop;
    return res;
  end Imag_Part;

  function Imag_Part ( x : Standard_Complex_Vectors.Link_to_Vector )
                     return Standard_Floating_Vectors.Link_to_Vector is

    res : Standard_Floating_Vectors.Link_to_Vector;
    ipx : Standard_Floating_Vectors.Vector(x'range);

  begin
    for k in x'range loop
      ipx(k) := Standard_Complex_Numbers.IMAG_PART(x(k));
    end loop;
    res := new Standard_Floating_Vectors.Vector'(ipx);
    return res;
  end Imag_Part;

  function Imag_Part ( x : Standard_Complex_VecVecs.Link_to_VecVec )
                     return Standard_Floating_VecVecs.Link_to_VecVec is

    res : Standard_Floating_VecVecs.Link_to_VecVec;
    ipx : Standard_Floating_VecVecs.VecVec(x'range);

  begin
    for k in x'range loop
      ipx(k) := Imag_Part(x(k));
    end loop;
    res := new Standard_Floating_VecVecs.VecVec'(ipx);
    return res;
  end Imag_Part;

  function Make_Complex
             ( rpx,ipx : Standard_Floating_Vectors.Vector )
             return Standard_Complex_Vectors.Vector is

    res : Standard_Complex_Vectors.Vector(rpx'range);

  begin
    for k in res'range loop
      res(k) := Standard_Complex_Numbers.Create(rpx(k),ipx(k));
    end loop;
    return res;
  end Make_Complex;

  function Make_Complex
             ( rpx,ipx : Standard_Floating_Vectors.Link_to_Vector )
             return Standard_Complex_Vectors.Link_to_Vector is

    res : Standard_Complex_Vectors.Link_to_Vector;
    cvx : Standard_Complex_Vectors.Vector(rpx'range);

  begin
    for k in cvx'range loop
      cvx(k) := Standard_Complex_Numbers.Create(rpx(k),ipx(k));
    end loop;
    res := new Standard_Complex_Vectors.Vector'(cvx);
    return res;
  end Make_Complex;

  function Make_Complex
             ( rpx,ipx : Standard_Floating_VecVecs.Link_to_VecVec )
             return Standard_Complex_VecVecs.Link_to_VecVec is

    res : Standard_Complex_VecVecs.Link_to_VecVec;
    cvx : Standard_Complex_VecVecs.VecVec(rpx'range);

  begin
    for k in cvx'range loop
      cvx(k) := Make_Complex(rpx(k),ipx(k));
    end loop;
    res := new Standard_Complex_VecVecs.VecVec'(cvx);
    return res;
  end Make_Complex;

  function Make_Complex
             ( rpx,ipx : Standard_Floating_VecVecs.VecVec )
             return Standard_Complex_VecVecs.VecVec is

    res : Standard_Complex_VecVecs.VecVec(rpx'range);

  begin
    for k in res'range loop
      res(k) := Make_Complex(rpx(k),ipx(k));
    end loop;
    return res;
  end Make_Complex;

  procedure Split_Complex
              ( x : in Standard_Complex_Vectors.Vector;
                rpx,ipx : out Standard_Floating_Vectors.Vector ) is

  begin
    for k in x'range loop
      rpx(k) := Standard_Complex_Numbers.REAL_PART(x(k));
      ipx(k) := Standard_Complex_Numbers.IMAG_PART(x(k));
    end loop;
  end Split_Complex;

  procedure Split_Complex
              ( x : in Standard_Complex_Vectors.Vector;
                rpx,ipx : out Standard_Floating_Vectors.Link_to_Vector ) is

    rx,ix : Standard_Floating_Vectors.Vector(x'range);

  begin
    for k in x'range loop
      rx(k) := Standard_Complex_Numbers.REAL_PART(x(k));
      ix(k) := Standard_Complex_Numbers.IMAG_PART(x(k));
    end loop;
    rpx := new Standard_Floating_Vectors.Vector'(rx);
    ipx := new Standard_Floating_Vectors.Vector'(ix);
  end Split_Complex;

  procedure Split_Complex
              ( x : in Standard_Complex_Vectors.Link_to_Vector;
                rpx,ipx : out Standard_Floating_Vectors.Link_to_Vector ) is

    rx,ix : Standard_Floating_Vectors.Vector(x'range);

  begin
    for k in x'range loop
      rx(k) := Standard_Complex_Numbers.REAL_PART(x(k));
      ix(k) := Standard_Complex_Numbers.IMAG_PART(x(k));
    end loop;
    rpx := new Standard_Floating_Vectors.Vector'(rx);
    ipx := new Standard_Floating_Vectors.Vector'(ix);
  end Split_Complex;

  procedure Split_Complex
              ( x : in Standard_Complex_VecVecs.VecVec;
                rpx,ipx : out Standard_Floating_VecVecs.VecVec ) is

    use Standard_Complex_Vectors;

  begin
    for k in x'range loop
      if x(k) /= null
       then Split_Complex(x(k),rpx(k),ipx(k));
      end if;
    end loop;
  end Split_Complex;

  procedure Split_Complex
              ( x : in Standard_Complex_VecVecs.Link_to_VecVec;
                rpx,ipx : out Standard_Floating_VecVecs.Link_to_VecVec ) is


    use Standard_Complex_VecVecs;

  begin
    if x /= null then
      declare
        rx,ix : Standard_Floating_VecVecs.VecVec(x'range);
      begin
        Split_Complex(x.all,rx,ix);
        rpx := new Standard_Floating_VecVecs.VecVec'(rx);
        ipx := new Standard_Floating_VecVecs.VecVec'(ix);
      end;
    end if;
  end Split_Complex;

-- MEMORY ALLOCATORS :

  function Allocate_Floating_Coefficients
             ( deg : integer32 )
             return Standard_Floating_Vectors.Link_to_Vector is

    cff : constant Standard_Floating_Vectors.Vector(0..deg) := (0..deg => 0.0);
    res : constant Standard_Floating_Vectors.Link_to_Vector
        := new Standard_Floating_Vectors.Vector'(cff);

  begin
    return res;
  end Allocate_Floating_Coefficients;

  function Allocate_Complex_Coefficients
             ( deg : integer32 )
             return Standard_Complex_Vectors.Link_to_Vector is

    zero : constant Standard_Complex_Numbers.Complex_Number
         := Standard_Complex_Numbers.Create(0.0);
    cff : constant Standard_Complex_Vectors.Vector(0..deg) := (0..deg => zero);
    res : constant Standard_Complex_Vectors.Link_to_Vector
        := new Standard_Complex_Vectors.Vector'(cff);

  begin
    return res;
  end Allocate_Complex_Coefficients;

  function Allocate_Floating_Coefficients
             ( dim,deg : integer32 )
             return Standard_Floating_VecVecs.VecVec is

    res : Standard_Floating_VecVecs.VecVec(1..dim);

  begin
    for k in res'range loop
      res(k) := Allocate_Floating_Coefficients(deg);
    end loop;
    return res;
  end Allocate_Floating_Coefficients;

  function Allocate_Floating_Coefficients
             ( dim,deg : integer32 )
             return Standard_Floating_VecVecs.Link_to_VecVec is

    res : Standard_Floating_VecVecs.Link_to_VecVec;
    cff : constant Standard_Floating_VecVecs.VecVec(1..dim)
        := Allocate_Floating_Coefficients(dim,deg);

  begin
    res := new Standard_Floating_VecVecs.VecVec'(cff);
    return res;
  end Allocate_Floating_Coefficients;

  function Allocate_Complex_Coefficients
             ( dim,deg : integer32 )
             return Standard_Complex_VecVecs.VecVec is

    res : Standard_Complex_VecVecs.VecVec(1..dim);

  begin
    for k in res'range loop
      res(k) := Allocate_Complex_Coefficients(deg);
    end loop;
    return res;
  end Allocate_Complex_Coefficients;

  function Allocate_Complex_Coefficients
             ( dim,deg : integer32 )
             return Standard_Complex_VecVecs.Link_to_VecVec is

    res : Standard_Complex_VecVecs.Link_to_VecVec;
    cff : constant Standard_Complex_VecVecs.VecVec(1..dim)
        := Allocate_Complex_Coefficients(dim,deg);

  begin
    res := new Standard_Complex_VecVecs.VecVec'(cff);
    return res;
  end Allocate_Complex_Coefficients;

-- PROCEDURES TO PART AND MERGE :

  procedure Complex_Parts
              ( x : in Standard_Complex_Vectors.Link_to_Vector;
                rpx,ipx : in Standard_Floating_Vectors.Link_to_Vector ) is
  begin
    for k in x'range loop
      rpx(k) := Standard_Complex_Numbers.REAL_PART(x(k));
      ipx(k) := Standard_Complex_Numbers.IMAG_PART(x(k));
    end loop;
  end Complex_Parts;

  procedure Complex_Parts
              ( x : in Standard_Complex_Vectors.Vector;
                rpx,ipx : in Standard_Floating_Vectors.Link_to_Vector ) is
  begin
    for k in x'range loop
      rpx(k) := Standard_Complex_Numbers.REAL_PART(x(k));
      ipx(k) := Standard_Complex_Numbers.IMAG_PART(x(k));
    end loop;
  end Complex_Parts;

  procedure Complex_Parts
              ( x : in Standard_Complex_VecVecs.VecVec;
                rpx,ipx : in Standard_Floating_VecVecs.Link_to_VecVec ) is
  begin
    for k in x'range loop
      Split_Complex(x(k),rpx(k),ipx(k));
    end loop;
  end Complex_Parts;

  procedure Complex_Parts
              ( x : in Standard_Complex_VecVecs.Link_to_VecVec;
                rpx,ipx : in Standard_Floating_VecVecs.Link_to_VecVec ) is
  begin
    for k in x'range loop
      Split_Complex(x(k),rpx(k),ipx(k));
    end loop;
  end Complex_Parts;

  procedure Complex_Merge
             ( rpx,ipx : in Standard_Floating_Vectors.Link_to_Vector;
               cvx : in Standard_Complex_Vectors.Link_to_Vector ) is
  begin
    for k in cvx'range loop
      cvx(k) := Standard_Complex_Numbers.Create(rpx(k),ipx(k));
    end loop;
  end Complex_Merge;

  procedure Complex_Merge
             ( rpx,ipx : in Standard_Floating_Vectors.Link_to_Vector;
               cvx : out Standard_Complex_Vectors.Vector ) is
  begin
    for k in cvx'range loop
      cvx(k) := Standard_Complex_Numbers.Create(rpx(k),ipx(k));
    end loop;
  end Complex_Merge;

  procedure Complex_Merge
             ( rpx,ipx : in Standard_Floating_VecVecs.Link_to_VecVec;
               cvx : in Standard_Complex_VecVecs.VecVec ) is
  begin
    for k in cvx'range loop
      Complex_Merge(rpx(k),ipx(k),cvx(k));
    end loop;
  end Complex_Merge;

  procedure Complex_Merge
             ( rpx,ipx : in Standard_Floating_VecVecs.Link_to_VecVec;
               cvx : in Standard_Complex_VecVecs.Link_to_VecVec ) is
  begin
    for k in cvx'range loop
      Complex_Merge(rpx(k),ipx(k),cvx(k));
    end loop;
  end Complex_Merge;

end Standard_Vector_Splitters;
