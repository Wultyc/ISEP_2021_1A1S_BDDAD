SET SERVEROUTPUT ON 

CREATE OR REPLACE FUNCTION fncObterRegistoMensalCamareira (p_mes INT, p_ano INT DEFAULT NULL)
    RETURN SYS_REFCURSOR

IS
    v_mes INT;
    v_ano INT;
    
    c_total_consumos_reg_camareira SYS_REFCURSOR;        
    
    mes_invalido EXCEPTION;

BEGIN

    IF p_mes < 1 OR p_mes > 12 THEN
        raise  mes_invalido;
    ELSE
        v_mes := p_mes;
    END IF;
    
    IF p_ano IS NULL THEN
        select extract(year from sysdate)-1 INTO v_ano from dual; 
    ELSE
        v_ano := p_ano;
    END IF;
    
    OPEN c_total_consumos_reg_camareira FOR
        SELECT
            funcionario.id,
            funcionario.nome,
            sum(linha_conta_consumo.preco_unitario*linha_conta_consumo.quantidade) as "total_consumos_registados",
            min(linha_conta_consumo.data_registo) as "primeiro_registo",
            max(linha_conta_consumo.data_registo) as "ultimo_registo"
        FROM camareira
            JOIN funcionario ON funcionario.id = camareira.id
            JOIN linha_conta_consumo ON camareira.id = linha_conta_consumo.id_camareira
        WHERE
            extract(year from linha_conta_consumo.DATA_REGISTO) = v_ano AND
            extract(month from linha_conta_consumo.DATA_REGISTO) = p_mes
        GROUP BY funcionario.id, funcionario.nome;
    
    return c_total_consumos_reg_camareira;
    
EXCEPTION
    WHEN mes_invalido THEN
        dbms_output.put_line('O valor do mês tem de estar entre 1 e 12');
        return null;
END;

/
BEGIN
    DECLARE
        cur1 SYS_REFCURSOR;
    BEGIN
    --Mes: 9 | Ano: default
    cur1 := fncObterRegistoMensalCamareira(9);
    DBMS_SQL.RETURN_RESULT(cur1);
    END;
    
    DECLARE
        cur2 SYS_REFCURSOR;
    BEGIN
        --Mes: 10 | Ano: 2020
        cur2 := fncObterRegistoMensalCamareira(10,2020);
        DBMS_SQL.RETURN_RESULT(cur2);
    END;
    
    DECLARE
        cur3 SYS_REFCURSOR;
    BEGIN
        --Mes: 92020 | Ano: default - simulação de erro
        cur3 := fncObterRegistoMensalCamareira(92020);
        DBMS_SQL.RETURN_RESULT(cur3);
    END;
END;