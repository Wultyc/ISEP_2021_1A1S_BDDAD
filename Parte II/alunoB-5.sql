-- Atualização do modelo relacional
-- Devido à necessidade de armazenar os bonus das camareira, é necessário fazer uma alteração ao modelo relacional.
-- Esta alteração passa pela criação de uma tabela bonus onde fica armazenado o bonus que a camareira recebe em
-- determinado mes e ano. A decisão de criar uma nova tabela no lugar de alterar a tabela camareira baseou-se essencialmente na
-- possibilidade de um calculo de bonus de um mês anterior não afetar o unico registo que se refere ao bonus calculado atualmente.
-- EX: no mes de setembro foi feito o cálculo dos bonus sobre o mês de Agosto. Se por algum motivo for necessário refazer o
-- cálculo de maio, este valor não vai subscrever o que foi calculado sobre agosto.

create table bonus(
    id_camareira int constraint fk_bonus_camareira references camareira(id),
    mes INT,
    ano INT,
    bonus number(*, 2),
    CONSTRAINT pkBonus  PRIMARY KEY (id_camareira, mes, ano)
);

SET SERVEROUTPUT ON 

-- Resolução do exercício
-- A resolução deste exercicio foi disponibilizada em duas versões. Uma primeira onde toda a logica de resolução do exercicio
-- esta no procedure e uma segunda onde se faz uso da função definida no exercicio 4. Isto aconteceu porque este exercicio foi
-- concluido antes do exercicio 4 e quando o ex 4 foi concluido optou-se por adaptar a solução que já existia para o 5 e
-- apresentar as uas soluções.

-- Solução 1 - sem a função do EX 4
CREATE OR REPLACE PROCEDURE prcAtualizarBonusCamareiras (p_mes IN INT, p_ano IN INT DEFAULT NULL) 

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
            id_camareira = reg_camareira_mes.id AND
            mes = v_mes AND
            ano = v_ano;
        
        IF v_conta_registo_bonus_mes > 0 THEN
            UPDATE bonus
                SET bonus = v_bonus
            WHERE
                id_camareira = reg_camareira_mes.id AND
                mes = v_mes AND
                ano = v_ano;
        ELSE
            INSERT INTO bonus (id_camareira, mes, ano, bonus) VALUES (reg_camareira_mes.id, v_mes, v_ano, v_bonus);
        END IF;
        
    END LOOP; 

EXCEPTION
    WHEN mes_invalido THEN
        dbms_output.put_line('O valor do mês tem de estar entre 1 e 12');
END;
/

-- Solução 2 - com a função do EX 4
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
            id_camareira = v_id AND
            mes = v_mes AND
            ano = v_ano;
        
        IF v_conta_registo_bonus_mes > 0 THEN
            UPDATE bonus
                SET bonus = v_bonus
            WHERE
                id_camareira = v_id AND
                mes = v_mes AND
                ano = v_ano;
        ELSE
            INSERT INTO bonus (id_camareira, mes, ano, bonus) VALUES (v_id, v_mes, v_ano, v_bonus);
        END IF;
        
    END LOOP; 
    

EXCEPTION
    WHEN mes_invalido THEN
        dbms_output.put_line('O valor do mês tem de estar entre 1 e 12');
END;
/
-- Testes

SELECT * FROM bonus;

BEGIN
    DECLARE
        bonus_result SYS_REFCURSOR;
    BEGIN
        dbms_output.put_line('Mes: 3 | Ano: 2020');
        prcAtualizarBonusCamareiras(3,2020);
        OPEN bonus_result FOR SELECT * FROM bonus WHERE mes = 3 AND ano = 2020;
        DBMS_SQL.RETURN_RESULT(bonus_result);
    END;
    
    DECLARE
        bonus_result SYS_REFCURSOR;
    BEGIN
        dbms_output.put_line('Mes: 7 | Ano: 2020');
        prcAtualizarBonusCamareiras(7,2020);
        OPEN bonus_result FOR SELECT * FROM bonus WHERE mes = 7 AND ano = 2020;
        DBMS_SQL.RETURN_RESULT(bonus_result);
    END;
    
    DECLARE
        bonus_result SYS_REFCURSOR;
    BEGIN
        dbms_output.put_line('Mes: 9 | Ano: ');
        prcAtualizarBonusCamareiras(9);
        OPEN bonus_result FOR SELECT * FROM bonus WHERE mes = 9 AND ano = 2020;
        DBMS_SQL.RETURN_RESULT(bonus_result);
    END;
    
    DECLARE
        bonus_result SYS_REFCURSOR;
    BEGIN
        dbms_output.put_line('Mes: 10 | Ano: 2020');
        prcAtualizarBonusCamareiras(10,2020);
        OPEN bonus_result FOR SELECT * FROM bonus WHERE mes = 10 AND ano = 2020;
        DBMS_SQL.RETURN_RESULT(bonus_result);
    END;
    
    DECLARE
        bonus_result SYS_REFCURSOR;
    BEGIN
        dbms_output.put_line('Mes: 92020 | Ano ');
        prcAtualizarBonusCamareiras(92020);
    END;
END;