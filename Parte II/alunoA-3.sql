SET SERVEROUTPUT ON 

create or replace trigger trgEpocasNaoSobrepostas
    before insert or update on EPOCA
    for each row
    declare
    d_data_ini epoca.DATA_INI%type;
    d_data_fim epoca.DATA_FIM%type;
    CURSOR datas is
        SELECT DATA_INI, DATA_FIM FROM EPOCA;
    begin
    open datas;
    LOOP
    FETCH datas into d_data_ini, d_data_fim;
    if ( (:new.DATA_INI > d_data_ini AND :new.DATA_INI < d_data_fim) OR
    (:new.DATA_INI < d_data_ini AND :new.DATA_FIM > d_data_fim) OR
    (:new.DATA_INI > d_data_ini AND :new.DATA_FIM < d_data_fim) OR
    (:new.DATA_FIM > d_data_ini AND :new.DATA_FIM < d_data_fim) OR
    (:new.DATA_INI = d_data_ini AND :new.DATA_FIM = d_data_fim)
    ) then
        raise_application_error(-20000,'SOBREPOSIÇÂO DE DATAS - ESCOLHA DATAS QUE NÂO SE SOBREPONHAM A OUTRAS DATAS');
    end if;
    EXIT WHEN datas%notfound;  
    END LOOP;
    close datas;
end;
    
SELECT DATA_INI, DATA_FIM FROM EPOCA;

insert into epoca(id, nome, data_ini, data_fim) values(10, 'Época 9', to_date('2020-12-12', 'yyyy-mm-dd'), to_date('2021-04-30', 'yyyy-mm-dd'));

insert into epoca(id, nome, data_ini, data_fim) values(13, 'Época X', to_date('2021-01-31', 'yyyy-mm-dd'), to_date('2021-04-30', 'yyyy-mm-dd'));
    


