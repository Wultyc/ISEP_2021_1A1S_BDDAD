WITH count_tipoQuarto_per_floor AS (
    SELECT 
        nrandar, 
        tipoquarto, 
        Count(*)   AS cnt 
    FROM   quarto_reserva 
         JOIN reserva 
           ON quarto_reserva.reservaid = reserva.id 
         JOIN quarto 
           ON quarto_reserva.nrquartoreserva = quarto.nrquarto 
    WHERE  reserva.estadoreservasigla <> 'cancelada' 
    GROUP  BY tipoquarto, 
            nrandar
),

max_per_floor AS (
    SELECT
        max(cnt) AS cnt,
        nrandar
    FROM count_tipoQuarto_per_floor
    GROUP BY NRANDAR
),

max_per_type_per_floor AS (
    SELECT
        count_tipoQuarto_per_floor.*
    FROM max_per_floor
        JOIN count_tipoQuarto_per_floor
            ON      count_tipoQuarto_per_floor.nrandar = max_per_floor.nrandar
                AND count_tipoQuarto_per_floor.cnt = max_per_floor.cnt
)

SELECT
    max_per_type_per_floor.nrandar,
    max_per_type_per_floor.tipoquarto,
    tipoquarto.descricao,
    max_per_type_per_floor.cnt
FROM max_per_type_per_floor
    JOIN tipoQuarto
        ON tipoQuarto.idTipoQuarto = max_per_type_per_floor.tipoquarto;