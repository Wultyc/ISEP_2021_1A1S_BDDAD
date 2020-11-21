SELECT pessoa.nome,pessoa.nif, concelho.nome AS concelho
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
    WHERE estadoreserva.sigla = 'finalizada' AND quarto_reserva.IdQuartoReserva IN
    (SELECT IdQuartoReserva FROM quarto_reserva
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
