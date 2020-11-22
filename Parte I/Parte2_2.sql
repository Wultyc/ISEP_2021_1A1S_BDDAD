--|---------------------------INSERTS FOR THE EXERCISE--------------------------------------------------------------------------------------------------------------|--
--Insert into IntervencaoQuarto(id, nrQuarto, dataIntervencao, concluido) values(24000, 1016, DATE  '2020-11-15', 'Y');
--Insert into Limpeza (nrFuncionario, intervencaoQuartoId ) values(350,24000);
--
--Insert into IntervencaoQuarto(id, nrQuarto, dataIntervencao, concluido) values(24000, 1016, DATE  '2020-11-15', 'Y');
--Insert into Limpeza (nrFuncionario, intervencaoQuartoId ) values(350,24000);
--
-- 
--Insert into IntervencaoQuarto(id, nrQuarto, dataIntervencao, concluido) values(26000, 1016, DATE  '2020-09-12', 'Y');
--Insert into Limpeza (nrFuncionario, intervencaoQuartoId ) values(350,26000);
--
--Insert into IntervencaoQuarto(id, nrQuarto, dataIntervencao, concluido) values(27000, 1016, DATE  '2020-09-12', 'Y');
--Insert into Limpeza (nrFuncionario, intervencaoQuartoId ) values(350,27000);
--
--Insert into IntervencaoQuarto(id, nrQuarto, dataIntervencao, concluido) values(28000, 1016, DATE  '2020-03-12', 'Y');
--Insert into Limpeza (nrFuncionario, intervencaoQuartoId ) values(350,28000);


--|-------------------------------------------QUERY FOR PART 2 EXERCISE 2 -----------------------------------------------------------------------------------------------------------------------|--
WITH quarto_tipo_avg AS (
  SELECT (sum((reserva.datafim-reserva.dataInicio))*60*24/count(*)) AS media, quarto.tipoquarto AS tipo
                FROM reserva
                INNER JOIN quarto_reserva on quarto_reserva.reservaid = reserva.id
                INNER JOIN quarto on quarto_reserva.nrQuartoReserva = quarto.nrQuarto
                GROUP BY quarto.tipoQuarto 
                ),
    quartos AS (
            SELECT nrQuarto FROM quarto
            JOIN Quarto_Reserva ON Quarto_Reserva.nrQuartoReserva = quarto.nrQuarto
            INNER JOIN reserva ON quarto_reserva.reservaid = reserva.id
            WHERE (reserva.datafim-reserva.dataInicio)*60*24 > 
            (SELECT media FROM quarto_tipo_avg 
            WHERE quarto.tipoquarto = quarto_tipo_avg.tipo) AND (reserva.estadoreservasigla = 'ativa' OR reserva.estadoreservasigla = 'finalizada')),
 count_limpeza AS(
    SELECT COUNT(intervencaoquartoid) as limpeza_Count, nrfuncionario, EXTRACT (MONTH FROM intervencaoquarto.dataintervencao) AS Limpeza_Month 
    FROM limpeza
    INNER JOIN intervencaoquarto ON intervencaoquarto.id = limpeza.intervencaoquartoid
    INNER JOIN quarto_reserva ON quarto_reserva.nrQuartoReserva = intervencaoquarto.nrQuarto
    WHERE intervencaoquarto.nrquarto IN (SELECT nrquarto FROM quartos) AND intervencaoquarto.dataintervencao >= add_months(sysdate, -6)
  GROUP BY limpeza.nrfuncionario, EXTRACT (MONTH FROM intervencaoquarto.dataintervencao)
    )

SELECT
    limpeza_count,
    limpeza_month,
    nrfuncionario
FROM (
    SELECT
        limpeza_count,
        limpeza_month,
        nrfuncionario
    FROM count_limpeza
) JOIN (
    SELECT
        max(limpeza_count) AS mx_limpeza_count,
        limpeza_month AS mx_limpeza_month
    FROM count_limpeza group by limpeza_month) ON limpeza_count = mx_limpeza_count AND limpeza_month = mx_limpeza_month
