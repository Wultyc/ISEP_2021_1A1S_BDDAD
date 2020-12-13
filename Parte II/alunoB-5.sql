-- Atualização do modelo relacional
--ALTER TABLE funcionario ADD bonus NUMBER(*,0) DEFAULT 0 NOT NULL;

create table bonus(
    id_funcionario int constraint fk_bonus_funcionario references funcionario(id),
    mes INT,
    ano INT,
    bonus number(*, 2),
    CONSTRAINT pkBonus  PRIMARY KEY (id_funcionario, mes, ano)
);

SET SERVEROUTPUT ON 

-- Resolução do exercício
create or replace procedure prcAtualizarBonusCamareiras (p_mes IN INT, p_ano IN INT DEFAULT NULL) 

IS
    v_mes INT;
    v_ano INT;
    
    CURSOR c_total_consumos_reg_camareira(cp_mes INT, cp_ano INT) IS
        SELECT
            funcionario.id,
            funcionario.nome,
            sum(artigo_consumo.preco) as "total_consumos_registados",
            min(linha_conta_consumo.data_registo) as "primeiro_registo",
            max(linha_conta_consumo.data_registo) as "ultimo_registo"
        FROM camareira
            JOIN funcionario ON funcionario.id = camareira.id
            JOIN linha_conta_consumo ON camareira.id = linha_conta_consumo.id_camareira
            JOIN artigo_consumo ON linha_conta_consumo.id_artigo_consumo = artigo_consumo.id
        WHERE
            extract(year from linha_conta_consumo.DATA_REGISTO) = cp_ano AND
            extract(month from linha_conta_consumo.DATA_REGISTO) = cp_mes
        GROUP BY funcionario.id, funcionario.nome;
    
    reg_camareira_mes c_total_consumos_reg_camareira%ROWTYPE;
    
    v_percetagem_bonus NUMBER(5,2);
    v_bonus funcionario.bonus%type;
    v_n_total_consumos reg_camareira_mes."total_consumos_registados"%type;
    v_conta_registo_bonus_mes INT;
    
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
    
    OPEN c_total_consumos_reg_camareira(v_mes, v_ano);
    
    LOOP
        FETCH c_total_consumos_reg_camareira INTO reg_camareira_mes;
        EXIT when c_total_consumos_reg_camareira%notfound;
    
        v_n_total_consumos := reg_camareira_mes."total_consumos_registados";
    
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
            id_funcionario = reg_camareira_mes.id AND
            mes = v_mes AND
            ano = v_ano;
        
        IF v_conta_registo_bonus_mes > 0 THEN
            UPDATE bonus
                SET bonus = v_bonus
            WHERE
                id_funcionario = reg_camareira_mes.id AND
                mes = v_mes AND
                ano = v_ano;
        ELSE
             dbms_output.put_line('INSERT' || v_conta_registo_bonus_mes);
            INSERT INTO bonus (id_funcionario, mes, ano, bonus) VALUES (reg_camareira_mes.id, v_mes, v_ano, v_bonus);
        END IF;
        
    END LOOP; 

EXCEPTION
    WHEN mes_invalido THEN
        dbms_output.put_line('O valor do mês tem de estar entre 1 e 12');
END;
/
BEGIN
    dbms_output.put_line('Mes: 3 | Ano: 2020');
    prcAtualizarBonusCamareiras(3,2020);
END;
/
BEGIN
    dbms_output.put_line('Mes: 7 | Ano: 2020');
    prcAtualizarBonusCamareiras(7,2020);
END;
/
BEGIN
    dbms_output.put_line('Mes: 9 | Ano: ');
    prcAtualizarBonusCamareiras(9);
END;
/
BEGIN
    dbms_output.put_line('Mes: 10 | Ano: 2020');
    prcAtualizarBonusCamareiras(10,2020);
END;
/
BEGIN
    dbms_output.put_line('Mes: 92020 | Ano ');
    prcAtualizarBonusCamareiras(92020);
END;