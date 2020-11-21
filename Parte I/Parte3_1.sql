SELECT andar_of_max         AS nrAndar, 
       tipoquarto_internal  AS TipoQuartoId, 
       cnt_of_max           AS Cnt 
FROM   (SELECT nrandar  AS andar_of_max, 
               Max(cnt) AS cnt_of_max 
        FROM   (SELECT nrandar, 
                       Count(*) AS cnt 
                FROM   quarto_reserva 
                       JOIN reserva 
                         ON quarto_reserva.reservaid = reserva.id 
                       JOIN quarto 
                         ON quarto_reserva.nrquartoreserva = quarto.nrquarto 
                WHERE  reserva.estadoreservasigla <> 'cancelada' 
                GROUP  BY tipoquarto, 
                          nrandar) 
        GROUP  BY nrandar) mytab
       JOIN (SELECT nrandar    AS andar_internal, 
                         tipoquarto AS tipoQuarto_internal, 
                         Count(*)   AS cnt 
                  FROM   quarto_reserva 
                         JOIN reserva 
                           ON quarto_reserva.reservaid = reserva.id 
                         JOIN quarto 
                           ON quarto_reserva.nrquartoreserva = quarto.nrquarto 
                  WHERE  reserva.estadoreservasigla <> 'cancelada' 
                  GROUP  BY tipoquarto, 
                            nrandar) 
              ON andar_of_max = andar_internal 
                 AND cnt_of_max = cnt 