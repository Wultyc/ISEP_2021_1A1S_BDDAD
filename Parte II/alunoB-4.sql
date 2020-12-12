SET SERVEROUTPUT ON 

CREATE OR REPLACE FUNCTION fncObterRegistoMensalCamareira (p_mes INT, p_ano INT DEFAULT NULL)
    RETURN SYS_REFCURSOR

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
    
    return c_total_consumos_reg_camareira;
    
EXCEPTION
    WHEN mes_invalido THEN
        dbms_output.put_line('O valor do mês tem de estar entre 1 e 12');
        return null;
END;

/

BEGIN
    dbms_output.put_line(FNCOBTERREGISTOMENSALCAMAREIRA(9));
    dbms_output.put_line('=====================================');
    dbms_output.put_line(FNCOBTERREGISTOMENSALCAMAREIRA(9,2020));
    dbms_output.put_line('=====================================');
    dbms_output.put_line(FNCOBTERREGISTOMENSALCAMAREIRA(91));
END;