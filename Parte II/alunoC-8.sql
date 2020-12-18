create or replace procedure prcCheckOut (id_tipo_quarto int, data_entrada date, data_saida date, nr_pessoas int, id_cliente INT DEFAULT NULL,
nome varchar DEFAULT NULL, nif varchar DEFAULT NULL, telefone varchar DEFAULT NULL, email varchar DEFAULT NULL)

IS
n_id int;
n_id_tipo_quarto int;
n_id_cliente int;
n_data_entrada date;
n_data_saida date;
n_nr_pessoas int;
n_nome varchar(250);
n_nif varchar(20);
n_telefone varchar(200);
n_email varchar(20);
nome_invalido EXCEPTION;
BEGIN

SELECT (MAX(ID)+1) into n_id FROM Reserva;
n_id_tipo_quarto := id_tipo_quarto;
n_id_cliente :=id_cliente;
n_data_entrada :=data_entrada;
n_data_saida :=data_saida;
n_nr_pessoas :=nr_pessoas;

    IF id_cliente IS NULL THEN
       IF nome is Null then 
       raise nome_invalido;
       else
       n_nome:= nome;
       n_nif:= nif;
       n_email:= email;
       n_telefone := telefone;
        end if;
    ELSE
       n_nome:= null;
       n_nif:= null;
       n_email:= null;
       n_telefone := null;

    END IF;
    insert into reserva(id, id_cliente, nome, nif, email, telefone, id_tipo_quarto,data_entrada, data_saida, nr_pessoas) 
      values(n_id,n_id_cliente, n_nome, n_nif, n_email, n_telefone, n_id_tipo_quarto,n_data_entrada, n_data_saida, n_nr_pessoas);
      dbms_output.put_line('Id do cliente: ' || n_id);
      
    EXCEPTION
    WHEN nome_invalido THEN
        dbms_output.put_line('O nome e o id do cliente não podem ser ambos invalidos.');
    
END;
/

    BEGIN
        prcCheckOut(1, '12-JAN-20', '13-JAN-20', 1, 80,'Diogo');
    END;

select * from reserva where id = 3651;

SELECT (MAX(ID)+1) FROM Reserva;