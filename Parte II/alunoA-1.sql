CREATE OR REPLACE FUNCTION fncGetQuartoReserva (idreserva reserva.id%type) return quarto%rowtype
is
    dataEntrada date;
    dataSaida date;
    tipoQuartoReserva int;
    andarNumero int;
    quartoCursor quarto.id%type;
    quartoReturn quarto%rowtype;
    reservarow reserva%rowtype;
    quartoInto quarto.id%type;
    
    ex_tracker varchar(20);
    
    no_value exception;
    no_reserva exception;
    quarto_associado exception;
    reserva_estado exception;
    
    CURSOR c_quartos1 (dataen date, datasa date, tipoquartofiltro int)
        IS
		select quartoid from (
		select quarto.id AS QUARTOID, andar.nr_andar, 
			CASE 
				WHEN count(reserva.data_saida) = 0 then 0
				else (SUM(reserva.DATA_SAIDA-reserva.DATA_ENTRADA))
		        end
		as dias
		from quarto
		LEFT JOIN checkin ON checkin.id_quarto = quarto.id
		LEFT JOIN reserva ON checkin.id_reserva = reserva.id
		JOIN andar ON andar.id = quarto.id_andar
		WHERE quarto.id not in (
			SELECT checkin.id_quarto FROM
				CHECKIN 
				JOIN reserva on checkin.id_reserva = reserva.id
				WHERE
				(reserva.DATA_ENTRADA < dataen AND dataen < reserva.DATA_SAIDA) 
				OR (reserva.DATA_ENTRADA < datasa  AND datasa < reserva.DATA_SAIDA)
				OR (reserva.data_entrada > dataen AND reserva.DATA_SAIDA < datasa))
				AND quarto.id_tipo_quarto = tipoquartofiltro
				GROUP By quarto.id, andar.nr_andar
				ORDER BY andar.nr_andar asc, dias asc
				FETCH FIRST ROW ONLY
       );
    BEGIN
    
    IF idreserva IS NULL THEN RAISE no_value;
    END IF;
    
    ------------------------SELECIONA A RESERVA-----------------------------
    
    ex_tracker := 'No Reserva';
    SELECT * into reservarow FROM  reserva where id = idreserva;
    
    ------------------------FAZ BIND DOS DADOS NECESSÁRIOS----------------------
    
    dataEntrada := reservarow.data_entrada;
    dataSaida := reservarow.data_saida;
    tipoQuartoReserva := reservarow.id_tipo_quarto;
    ----------------------- vai extrarir os dados à query acima ---------------
   open c_quartos1(dataEntrada, dataSaida, tipoQuartoReserva);
    FETCH  c_quartos1 into quartoInto;
    close c_quartos1; 
    SELECT * into quartoReturn FROM quarto where id = quartoInto;
    RETURN quartoReturn;
     
    EXCEPTION
        WHEN no_value THEN
            dbms_output.put_line('O parâmetro não deve ser null');
            return null;
        WHEN no_data_found THEN
         dbms_output.put_line(ex_tracker);
         return null;    
    END;
    
    select * from reserva where reserva.id = 200
    
    declare 
    resultado quarto%rowtype := fncGetQuartoReserva(108);
    begin
     dbms_output.put_line(resultado.id);
    end;
    
    INSERT into quarto (id, id_andar, nr_quarto, id_tipo_quarto, lotacao_maxima) values(22,1,22,3,2)
    INSERT into quarto (id, id_andar, nr_quarto, id_tipo_quarto, lotacao_maxima) values(23,1,23,3,2)
    INSERT into quarto (id, id_andar, nr_quarto, id_tipo_quarto, lotacao_maxima) values(24,1,24,1,2)