/*Ex 1 b)*/

select Distinct p.nome, r.dataReserva, e.localidade as ZonaDoPais
 from Pessoa p, Reserva r, Cliente c, quarto_reserva qr
where  p.nif = c.nifCliente and c.nrCliente = r.nrCliente and (SELECT EXTRACT( MONTH FROM TO_DATE( r.dataReserva,  'YYYY-mm-DD' ) ) MONTH
FROM
  DUAL) = 5 OR (SELECT EXTRACT( MONTH FROM TO_DATE( r.dataReserva,  'YYYY-mm-DD' ) ) MONTH
FROM
  DUAL) = 7;

