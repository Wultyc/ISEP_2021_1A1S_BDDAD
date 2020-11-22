/*Ex 1 b)*/

select Distinct p.nome, r.dataReserva, e.localidade as ZonaDoPais  
 from Pessoa p, Reserva r, quarto_reserva qr,Quarto q, enderecos_pessoa ep, enderecos e  
where r.id=qr.reservaId and qr.nrQuartoReserva = q.nrQuarto and q.tipoQuarto =3 and p.nif = ep.pessoaNif  
and e.codPostal=ep.codPostal and (SELECT EXTRACT( MONTH FROM TO_DATE( r.dataReserva,  'YYYY-mm-DD' ) ) MONTH  
FROM  
  DUAL) = 5 OR (SELECT EXTRACT( MONTH FROM TO_DATE( r.dataReserva,  'YYYY-mm-DD' ) ) MONTH  
FROM  
  DUAL) = 7 
  order by nome asc

