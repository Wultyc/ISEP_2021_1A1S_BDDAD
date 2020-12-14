create or replace trigger trgAtualizaCliente
    after insert or update on reserva
    for each row
    declare
    n_id_cliente reserva.ID_CLIENTE%type;
    n_nif reserva.NIF%type;
    n_email reserva.EMAIL%type;
    n_telefone reserva.TELEFONE%type;
    
    CURSOR nifs is
        SELECT ID, NIF, EMAIL, TELEFONE FROM cliente where ID =:new.ID_Cliente;
    begin
    open nifs;
    FETCH nifs into n_id_cliente, n_nif, n_email, n_telefone;
    
    INSERT INTO reserva
   ( ID,
     ID_CLIENTE,
     NOME,
     NIF,
     EMAIL,
     TELEFONE,
     ID_TIPO_QUARTO,
     DATA,
     DATA_ENTRADA,
     DATA_SAIDA,
     NR_PESSOAS,
     PRECO,
     ID_ESTADO_RESERVA,
     CUSTO_CANCELAMENTO,
     CUSTO_EXTRA)
   VALUES
   ( :new.id,
     n_ID_CLIENTE,
     :new.nome,
     n_nif,
     n_email,
     n_telefone,
     :new.ID_TIPO_QUARTO,
     :new.DATA,
     :new.DATA_ENTRADA,
     :new.DATA_SAIDA,
     :new.NR_PESSOAS,
     :new.PRECO,
     :new.ID_ESTADO_RESERVA,
     :new.CUSTO_CANCELAMENTO,
     :new.CUSTO_EXTRA);
     close nifs;
     end;
 
 ALTER TABLE reserva
ENABLE ALL TRIGGERS;

select * from reserva;

      insert into reserva(id, id_cliente, nome, nif, email, telefone, id_tipo_quarto, data, data_entrada, data_saida, nr_pessoas, preco, id_estado_reserva,CUSTO_CANCELAMENTO,CUSTO_EXTRA)
      values(16, 76, 'Cliente', null, null, null, 1, '10-JAN-20', '12-JAN-20', '13-JAN-20', 1,1000, 2, 3, 4);
    


