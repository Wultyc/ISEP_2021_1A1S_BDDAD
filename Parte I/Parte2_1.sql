SELECT DISTINCT pessoa.nome, enderecos.localidade, concelho.nome AS concelho
FROM pessoa
INNER JOIN cliente              ON cliente.nifCliente = pessoa.nif
INNER JOIN enderecos_pessoa     ON enderecos_pessoa.pessoaNif = pessoa.nif
INNER JOIN enderecos            ON enderecos.codpostal = enderecos_pessoa.CodPostal
INNER JOIN concelho             ON enderecos.idConcelho = concelho.idConcelho
WHERE cliente.nrcliente 
    IN (
    SELECT nrcliente FROM 
    reserva 
    INNER JOIN quarto_reserva ON quarto_reserva.reservaid = reserva.id
    INNER JOIN estadoreserva ON estadoreserva.sigla = reserva.EstadoReservaSigla
    WHERE estadoreserva.sigla = 'finalizada' AND quarto_reserva.nrQuartoReserva IN
    (SELECT nrQuartoReserva FROM quarto_reserva
INNER JOIN reserva on quarto_reserva.reservaid = reserva.id 
INNER JOIN cliente on cliente.nrCliente = reserva.nrCliente
INNER JOIN EstadoReserva on EstadoReserva.sigla = reserva.EstadoReservaSigla
JOIN pessoa ON pessoa.nif = cliente.nifCliente
WHERE estadoreserva.sigla = 'finalizada' AND pessoa.Nome = 'Jose Silva'
AND cliente.nifCliente IN 
(SELECT enderecos_pessoa.pessoaNif FROM enderecos_pessoa  
    INNER JOIN enderecos on enderecos_pessoa.codPostal = enderecos.codPostal
    INNER JOIN concelho on enderecos.idConcelho = concelho.idconcelho
    WHERE concelho.distrito = 'Vila Real'))
)
--|---------------------------------Using with to improve the above query to not have 'Jose Silva' included--  FINAL QUERY FOR PART 2 -- EXERCISE 1-----------------------------------------|--



--|------------------------------------------------------------------------------------------------------------------------------------------------------------------|--
WITH quartos_cliente AS (
SELECT nrQuartoReserva , pessoa.nif AS nif FROM quarto_reserva
INNER JOIN reserva on quarto_reserva.reservaid = reserva.id 
INNER JOIN cliente on cliente.nrCliente = reserva.nrCliente
JOIN pessoa ON pessoa.nif = cliente.nifCliente
WHERE reserva.EstadoReservaSigla = 'finalizada' AND pessoa.Nome = 'Jose Silva'
AND cliente.nifCliente IN 
(SELECT enderecos_pessoa.pessoaNif FROM enderecos_pessoa  
    INNER JOIN enderecos on enderecos_pessoa.codPostal = enderecos.codPostal
    INNER JOIN concelho on enderecos.idConcelho = concelho.idconcelho
    WHERE concelho.distrito = 'Vila Real'))    
SELECT pessoa.nome, enderecos.localidade, concelho.nome AS concelho
FROM pessoa
INNER JOIN cliente              ON cliente.nifCliente = pessoa.nif
INNER JOIN enderecos_pessoa     ON enderecos_pessoa.pessoaNif = pessoa.nif
INNER JOIN enderecos            ON enderecos.codpostal = enderecos_pessoa.CodPostal
INNER JOIN concelho             ON enderecos.idConcelho = concelho.idConcelho
WHERE cliente.nifCliente != (SELECT DISTINCT nif FROM quartos_cliente) AND cliente.nrcliente 
    IN (
    SELECT nrcliente FROM 
    reserva 
    INNER JOIN quarto_reserva ON quarto_reserva.reservaid = reserva.id
    INNER JOIN estadoreserva ON estadoreserva.sigla = reserva.EstadoReservaSigla
    WHERE estadoreserva.sigla = 'finalizada' AND quarto_reserva.nrQuartoReserva IN (select quartos_cliente.nrquartoreserva FROM quartos_cliente))


--|------------------------------------------------------------------------------------------------------------------------------------------------------------------|--


--|---------------------------INSERTS FOR THE EXERCISE--------------------------------------------------------------------------------------------------------------|--
Insert into IntervencaoQuarto(id, nrQuarto, dataIntervencao, concluido) values(24000, 1016, DATE  '2020-11-15', 'Y');
Insert into Limpeza (nrFuncionario, intervencaoQuartoId ) values(350,24000);

Insert into IntervencaoQuarto(id, nrQuarto, dataIntervencao, concluido) values(24000, 1016, DATE  '2020-11-15', 'Y');
Insert into Limpeza (nrFuncionario, intervencaoQuartoId ) values(350,24000);

 
Insert into IntervencaoQuarto(id, nrQuarto, dataIntervencao, concluido) values(26000, 1016, DATE  '2020-09-12', 'Y');
Insert into Limpeza (nrFuncionario, intervencaoQuartoId ) values(350,26000);

Insert into IntervencaoQuarto(id, nrQuarto, dataIntervencao, concluido) values(27000, 1016, DATE  '2020-09-12', 'Y');
Insert into Limpeza (nrFuncionario, intervencaoQuartoId ) values(350,27000);

Insert into IntervencaoQuarto(id, nrQuarto, dataIntervencao, concluido) values(28000, 1016, DATE  '2020-03-12', 'Y');
Insert into Limpeza (nrFuncionario, intervencaoQuartoId ) values(350,28000);

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
            WHERE quarto.tipoquarto = quarto_tipo_avg.tipo)),
 count_limpeza AS(
    SELECT COUNT(intervencaoquartoid) as limpeza_Count, nrfuncionario, EXTRACT (MONTH FROM intervencaoquarto.dataintervencao) AS Limpeza_Month 
    FROM limpeza
    INNER JOIN intervencaoquarto ON intervencaoquarto.id = limpeza.intervencaoquartoid
    INNER JOIN quarto_reserva ON quarto_reserva.nrQuartoReserva = intervencaoquarto.nrQuarto
    WHERE intervencaoquarto.nrquarto IN (SELECT nrquarto FROM quartos) AND intervencaoquarto.dataintervencao >= add_months(sysdate, -6)
  GROUP BY limpeza.nrfuncionario, EXTRACT (MONTH FROM intervencaoquarto.dataintervencao)
    )
 SELECT * FROM count_limpeza