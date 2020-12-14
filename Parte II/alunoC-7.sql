create or replace function fncDisponibilidadeReserva(p_id_quarto int, p_data date, p_duracao int, p_num_pessoas int) return boolean
is
available Boolean:= true;
numDias Number := 0;
BEGIN
    -- is available?

WHILE numDias <= p_duracao
LOOP
if not isQuartoIndisponivel(p_id_quarto, p_data) then
   SELECT TO_DATE(p_data) + 1 FROM DUAL;
   numDias := numDias +1;
   ELSE
      available := False;
END LOOP;
    RETURN available;
END;
