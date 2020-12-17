
create or replace function fncDisponibilidadeReserva(p_id_quarto int, p_data date, p_duracao int, p_num_pessoas int) return boolean
is
available Boolean:= true;
numDias Number := 0;
new_date DATE := SYSDATE;
BEGIN
    -- is available?
SELECT (TO_DATE(p_data)) into new_date FROM DUAL;
WHILE numDias <= p_duracao
LOOP
available :=isQuartoIndisponivel(p_id_quarto, new_date);
if available = false then
EXIT;   
   ELSE
   dbms_output.put_line('Chegou');
   new_date := new_date +1;
   numDias := numDias+1;
    
      END IF;
      
END LOOP;
if available = TRUE then
    dbms_output.put_line('TRUE');
  else
    dbms_output.put_line('FALSE');
  end if;
    RETURN available;
END;


declare 
resultado boolean;
begin
    resultado := fncDisponibilidadeReserva(1, to_date('11/01/2020', 'dd/mm/yyyy'), 1, 1);
end;
