create or replace trigger trgAtualizaCliente 
    before insert or update on reserva 
    for each row 
    declare 
    n_id_cliente reserva.ID_CLIENTE%type; 
    n_nif reserva.NIF%type;
    n_email reserva.email%type;
    n_telefone reserva.telefone%type;
    begin
        SELECT c.nif into n_nif FROM cliente c where c.id = :new.id_Cliente;
        :new.nif := n_nif;
 dbms_output.put_line('NIF ::=' ||n_nif);
 end;


 ALTER TABLE reserva 
ENABLE ALL TRIGGERS

  insert into reserva(id, id_cliente, nome,id_tipo_quarto, data, data_entrada, data_saida, nr_pessoas, preco, id_estado_reserva) 
      values(12622, 80, 'Cliente' ,1, '10-JAN-20', '12-JAN-20', '13-JAN-20', 1,1000, 2);10-JAN-20', '12-JAN-20', '13-JAN-20', 1,1000, 2)