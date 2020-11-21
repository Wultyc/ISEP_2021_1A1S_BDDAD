WITH produtos_mais_consumidos AS (
    SELECT
        produtosFrigoBar.idProduto,
        count(*) as cnt
    FROM consumosFrigobar
        JOIN produtosFrigoBar
            ON produtosFrigoBar.idProduto = consumosFrigobar.idProdutoFrigobar
    WHERE consumosFrigobar.dataRegisto > (select sysdate -365*2 from dual)
    GROUP BY produtosFrigoBar.idProduto
    ORDER BY cnt
    FETCH FIRST 2 ROWS ONLY
)

SELECT
    Pessoa.*,
    Reserva.id,
    Reserva.DATARESERVA,
    Reserva.DATAINICIO,
    Reserva.DATAFIM,
    Reserva.ESTADORESERVASIGLA,
    Reserva.NRPESSOAS,
    Reserva.NRCONTACONSUMOS,
    Reserva.CUSTORESERVA,
    Reserva.CUSTOCANCELAMENTO,
    ContaConsumos.DATAABERTURA,
    ContaConsumos.VALOR
FROM Cliente
    JOIN Pessoa ON Cliente.nifCliente = Pessoa.nif
    JOIN Reserva ON Reserva.nrCliente = Cliente.nrCliente
    JOIN Quarto_Reserva ON Reserva.id = Quarto_Reserva.ReservaId
    JOIN Quarto ON Quarto.nrQuarto = Quarto_Reserva.nrquartoreserva
    JOIN ContaConsumos ON ContaConsumos.nrConta = Reserva.nrContaConsumos
    JOIN ConsumosFrigobar ON ConsumosFrigobar.nrContaConsumos = ContaConsumos.nrConta
WHERE   quarto.tipoQuarto = (SELECT idTipoQuarto FROM TipoQuarto WHERE descricao = 'Suite')
    AND (
            (
                
                (
                    EXTRACT (MONTH FROM reserva.datainicio) >= EXTRACT (MONTH FROM (SELECT datainicio FROM EpocaAno WHERE descricao = 'Epoca Alta'))
                    AND
                    EXTRACT (DAY FROM reserva.datainicio) >= EXTRACT (DAY FROM (SELECT datainicio FROM EpocaAno WHERE descricao = 'Epoca Alta'))
                )
                AND 
                (
                    EXTRACT (MONTH FROM reserva.datainicio) <= EXTRACT (MONTH FROM (SELECT datafim FROM EpocaAno WHERE descricao = 'Epoca Alta'))
                    AND
                    EXTRACT (DAY FROM reserva.datainicio) <= EXTRACT (DAY FROM (SELECT datafim FROM EpocaAno WHERE descricao = 'Epoca Alta'))
                )
                
            )
            OR
            ( 
                (
                    EXTRACT (MONTH FROM reserva.datafim) >= EXTRACT (MONTH FROM (SELECT datainicio FROM EpocaAno WHERE descricao = 'Epoca Alta'))
                    AND
                    EXTRACT (DAY FROM reserva.datafim) >= EXTRACT (DAY FROM (SELECT datainicio FROM EpocaAno WHERE descricao = 'Epoca Alta'))
                )
                AND
                (
                    EXTRACT (MONTH FROM reserva.datafim) <= EXTRACT (MONTH FROM (SELECT datafim FROM EpocaAno WHERE descricao = 'Epoca Alta'))
                    AND
                    EXTRACT (DAY FROM reserva.datafim) <= EXTRACT (DAY FROM (SELECT datafim FROM EpocaAno WHERE descricao = 'Epoca Alta'))
                )
            
            )
        )
    AND ConsumosFrigobar.idProdutoFrigobar IN (SELECT IDPRODUTO FROM produtos_mais_consumidos);