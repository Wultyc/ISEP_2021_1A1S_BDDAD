WITH produtos_mais_consumidos AS (
    SELECT
        consumosFrigobar.idProdutoFrigobar,
        count(*) as cnt
    FROM consumosFrigobar
    WHERE consumosFrigobar.dataRegisto > (select sysdate -365*2 from dual)
    GROUP BY consumosFrigobar.idProdutoFrigobar
    ORDER BY cnt DESC
    FETCH FIRST 2 ROWS ONLY
)

SELECT
    Pessoa.*,
    Reserva.id AS ReservaID,
    ContaConsumos.VALOR AS ValorConsumos
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
    AND ConsumosFrigobar.idProdutoFrigobar IN (SELECT IDPRODUTOFRIGOBAR FROM produtos_mais_consumidos)
ORDER BY ContaConsumos.VALOR DESC;