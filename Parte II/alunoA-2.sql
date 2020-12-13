--------------------PROCEDURE------------------------------------
create or replace procedure prcCheckOut (linhaReserva reserva%ROWTYPE) 

IS

parametro_invalido EXCEPTION;
idRC int;
dataCheckout date;
observacoes varchar(255);
valorExtra number(8,2);
idContaConsumo int;
linhaConta linha_conta_consumo%rowtype;
cliente int;
somaValor int;
valor int;
reservaEpoca1 epoca%rowtype;
reservaEpoca2 epoca%rowtype;
precoEpocaTipoQuarto1 number(8,2);
precoEpocaTipoQuarto2 number(8,2);
precoTotal number (8,2);

valorReserva int;

incremental int := 0;

CURSOR c_linha (idContaConsumo1 int)
IS
    select * from linha_conta_consumo where id_conta_consumo = idContaConsumo1;


CURSOR c_epoca (dataInicio date)
IS
    select * from epoca where data_ini < dataInicio AND data_fim > dataInicio;

BEGIN
    if (linhaReserva.id is null or linhaReserva.id_cliente is null or linhaReserva.data_saida is null) then raise parametro_invalido;
    end if;
    
    idRC := linhaReserva.id;
    cliente := linhaReserva.id_cliente;
    dataCheckout := linhaReserva.data_saida;
    valorExtra := linhaReserva.custo_cancelamento + linhaReserva.custo_extra;
    observacoes := 'CHECKOUT DA RESERVA COM ID: '||idRC ;

    insert into checkout(id_reserva, data, observacoes,valor_extra) values(idRC, dataCheckout, observacoes, valorExtra);

    insert into fatura(id, numero, data, id_cliente, id_reserva, valor_faturado_reserva, valor_faturado_consumo) values(idRC, idRC+1000, dataCheckout, cliente, idRC, null, null);

    select id into idContaConsumo from conta_consumo where id_reserva = idRC;
    OPEN c_linha(idContaConsumo);
    LOOP
        FETCH c_linha into linhaConta;
        EXIT WHEN c_linha%notfound;
        incremental := incremental + 1;
        valor := (linhaConta.quantidade*linhaConta.preco_unitario);
        insert into linha_fatura(id_fatura,linha,id_conta_consumo, linha_conta_Consumo, valor_consumo) values(idRC,incremental,idContaConsumo, linhaConta.linha, valor);
    END LOOP;
    CLOSE c_linha;
    select sum(valor_consumo) into somaValor from linha_fatura where id_fatura = idRC;
   
   if (valorExtra is null) then
        valorExtra := 0;
    end if;    

    update fatura SET
    VALOR_FATURADO_CONSUMO = somaValor,
    VALOR_FATURADO_RESERVA = (linhaReserva.preco + valorExtra)
    where id = idRC;
    update reserva SET
     id_estado_reserva = 3
    where id = idRC;

    
    EXCEPTION
    WHEN parametro_invalido THEN
    dbms_output.put_line('Parametro não pode ser nulo');

END;

declare linha reserva%ROWTYPE;

begin
    select * into linha from reserva where id = 306;
    prcCheckOut(linha);
end;

select * from preco_epoca_tipo_quarto


delete from checkout;
delete from linha_fatura;
delete from fatura;


select * from conta_consumo where id_reserva = 306
select * from linha_conta_consumo where id_conta_consumo = 306
select * from linha_fatura;
select * from linha_conta_consumo where id_conta_consumo = 196;
select * from fatura where id_reserva = 306;
select * from reserva where id = 306;


