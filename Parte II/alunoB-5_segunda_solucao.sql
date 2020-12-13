-- Atualização do modelo relacional

create table bonus(
    id_funcionario int constraint fk_bonus_funcionario references funcionario(id),
    mes INT,
    ano INT,
    bonus number(*, 2),
    CONSTRAINT pkBonus  PRIMARY KEY (id_funcionario, mes, ano)
);

SET SERVEROUTPUT ON 

-- Resolução do exercício
CREATE OR REPLACE PROCEDURE prcAtualizarBonusCamareiras (p_mes IN INT, p_ano IN INT DEFAULT NULL) 

IS
    v_mes INT;
    v_ano INT;
    
    c_total_consumos_reg_camareira SYS_REFCURSOR;
        
    v_percetagem_bonus NUMBER(5,2);
    v_bonus funcionario.bonus%type;
    v_n_total_consumos linha_conta_consumo.preco_unitario%TYPE;
    v_conta_registo_bonus_mes INT;
    v_id camareira.id%type;
    v_nome funcionario.nome%type;
    v_primeiro_registo linha_conta_consumo.data_registo%TYPE;
    v_ultimo_registo linha_conta_consumo.data_registo%TYPE;
    
    mes_invalido EXCEPTION;


BEGIN
    IF p_mes < 1 OR p_mes > 12 THEN
        raise  mes_invalido;
    ELSE
        v_mes := p_mes;
    END IF;
    
    IF p_ano IS NULL THEN
        select extract(year from sysdate) INTO v_ano from dual; 
    ELSE
        v_ano := p_ano;
    END IF;
    
    c_total_consumos_reg_camareira := fncObterRegistoMensalCamareira(v_mes,v_ano);
    
    LOOP
        FETCH c_total_consumos_reg_camareira INTO v_id,v_nome,v_n_total_consumos,v_primeiro_registo,v_ultimo_registo;
        EXIT WHEN c_total_consumos_reg_camareira%notfound;
    
        CASE
           WHEN v_n_total_consumos >= 1000 THEN v_percetagem_bonus := 0.15;
           WHEN v_n_total_consumos >= 500 AND v_n_total_consumos < 1000 THEN v_percetagem_bonus := 0.10;
           WHEN v_n_total_consumos >= 100 AND v_n_total_consumos < 500 THEN  v_percetagem_bonus := 0.05;
           ELSE v_percetagem_bonus := 0;
        END CASE;
        
        v_bonus := v_n_total_consumos * v_percetagem_bonus;
        
        SELECT count(*) INTO v_conta_registo_bonus_mes
        FROM bonus
        WHERE
            id_funcionario = v_id AND
            mes = v_mes AND
            ano = v_ano;
        
        IF v_conta_registo_bonus_mes > 0 THEN
            dbms_output.put_line('[UPDATE] ID: ' || v_id || ' Mes: ' || v_mes || ' Ano: ' || v_ano);
            UPDATE bonus
                SET bonus = v_bonus
            WHERE
                id_funcionario = v_id AND
                mes = v_mes AND
                ano = v_ano;
        ELSE
            dbms_output.put_line('[INSERT] ID: ' || v_id || ' Mes: ' || v_mes || ' Ano: ' || v_ano);
            INSERT INTO bonus (id_funcionario, mes, ano, bonus) VALUES (v_id, v_mes, v_ano, v_bonus);
        END IF;
        
    END LOOP; 
    

EXCEPTION
    WHEN mes_invalido THEN
        dbms_output.put_line('O valor do mês tem de estar entre 1 e 12');
END;
/
-- Testes
BEGIN
    BEGIN
        dbms_output.put_line('Mes: 3 | Ano: 2020');
        prcAtualizarBonusCamareiras(3,2020);
    END;
    
    BEGIN
        dbms_output.put_line('Mes: 7 | Ano: 2020');
        prcAtualizarBonusCamareiras(7,2020);
    END;
    
    BEGIN
        dbms_output.put_line('Mes: 9 | Ano: ');
        prcAtualizarBonusCamareiras(9);
    END;
    
    BEGIN
        dbms_output.put_line('Mes: 10 | Ano: 2020');
        prcAtualizarBonusCamareiras(10,2020);
    END;
    
    BEGIN
        dbms_output.put_line('Mes: 10 | Ano: 2020');
        prcAtualizarBonusCamareiras(10,2020);
    END;
    
    BEGIN
        dbms_output.put_line('Mes: 92020 | Ano ');
        prcAtualizarBonusCamareiras(92020);
    END;
END;