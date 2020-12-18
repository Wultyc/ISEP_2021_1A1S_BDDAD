SET SERVEROUTPUT ON 

CREATE OR REPLACE TRIGGER trgCorrigirAlteracaoBonus
    BEFORE INSERT OR UPDATE ON bonus
    FOR EACH ROW
DECLARE        
    v_query_cursor SYS_REFCURSOR;
            
    v_ultimo_bonus bonus%ROWTYPE;
    
    v_mes bonus.mes%type;
    v_ano bonus.ano%type;
BEGIN
    IF :new.mes = 1 THEN
        v_mes := 12;
        v_ano := :new.ano-1;
    ELSE
        v_mes := :new.mes;
        v_ano := :new.ano;
    END IF;
    
    OPEN v_query_cursor FOR
        SELECT
            *
        FROM bonus
        WHERE   id_camareira = :new.id_camareira
            AND mes = v_mes
            AND ano = v_ano;
     
    IF v_query_cursor%ROWCOUNT < 1 THEN
        CLOSE v_query_cursor;
        OPEN v_query_cursor FOR
            SELECT
                *
            FROM bonus
            WHERE id_camareira = :new.id_camareira
            ORDER BY to_date(ano||'-'||mes||'-01', 'yyyy-mm-dd') DESC
            FETCH FIRST ROW ONLY;
    END IF;
    
    LOOP
        FETCH v_query_cursor INTO v_ultimo_bonus;
        EXIT WHEN v_query_cursor%notfound;
        
        IF v_ultimo_bonus.bonus > :new.bonus THEN
            raise_application_error(-20000, 'Bonus não pode ser inferior ao do mês anterior');
        END IF;
        
        IF (:new.bonus-v_ultimo_bonus.bonus)/v_ultimo_bonus.bonus > 0.5 THEN
            raise_application_error(-20000, 'Aumento não pode ser superior as 50% face o mês anterior');
        END IF;
        
    END LOOP;
    CLOSE v_query_cursor;
END;
/
BEGIN
    INSERT INTO bonus (id_camareira, mes, ano, bonus) VALUES (11,11,2020,8);
END;
/
BEGIN
    INSERT INTO bonus (id_camareira, mes, ano, bonus) VALUES (12,11,2020,8);
END;
/
BEGIN
    INSERT INTO bonus (id_camareira, mes, ano, bonus) VALUES (13,11,2020,5);
END;
/
BEGIN
    INSERT INTO bonus (id_camareira, mes, ano, bonus) VALUES (14,11,2020,10);
END;