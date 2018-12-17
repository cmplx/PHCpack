with Standard_Integer_Numbers_io;       use Standard_Integer_Numbers_io;
with QuadDobl_Monomial_Vectors;         use QuadDobl_Monomial_Vectors;
with QuadDobl_Monomial_Vectors_io;      use QuadDobl_Monomial_Vectors_io;

package body QuadDobl_Polynomial_Vectors_io is

  procedure put ( v : in Polynomial_Vector ) is
  begin
    put(standard_output,v);
  end put;

  procedure put ( file : in file_type; v : in Polynomial_Vector ) is
  begin
    for i in v'range loop
      if v(i) /= null then
        put(file,"-> polynomial "); put(file,i,1); put_line(file," :");
        put(file,v(i).all);
      end if;
    end loop;
  end put;

  procedure put ( v : in Link_to_Polynomial_Vector ) is
  begin
    put(standard_output,v);
  end put;

  procedure put ( file : in file_type; v : in Link_to_Polynomial_Vector ) is
  begin
    if v /= null then
      for i in v'range loop
        if v(i) /= null then
          put(file,"-> polynomial "); put(file,i,1); put_line(file," :");
          put(file,v(i).all);
        end if;
      end loop;
    end if;
  end put;

end QuadDobl_Polynomial_Vectors_io;
