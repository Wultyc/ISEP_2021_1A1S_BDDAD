SET SERVEROUTPUT ON 

CREATE OR REPLACE TRIGGER trgCorrigirAlteracaoBonus
    BEFORE INSERT OR UPDATE ON bonus
    FOR EACH ROW
DECLARE
    CURSOR ultimo_bonus(cp_id bonus.id_camareira%type) IS
        SELECT
            *
        FROM bonus
        WHERE id_camareira = cp_id
        ORDER BY to_date(ano||'-'||mes||'-01', 'yyyy-mm-dd') DESC
        FETCH FIRST ROW ONLY;
            
    v_ultimo_bonus bonus%ROWTYPE;
    
    v_mes bonus.mes%type;
    v_ano bonus.ano%type;
BEGIN
    
    OPEN ultimo_bonus (:new.id_camareira);
    LOOP
        FETCH ultimo_bonus INTO v_ultimo_bonus;
        EXIT WHEN ultimo_bonus%notfound;
        
        IF v_ultimo_bonus.bonus > :new.bonus THEN
            raise_application_error(-20000, 'Bonus não pode ser inferior ao do mês anterior');
        END IF;
        
        IF (:new.bonus-v_ultimo_bonus.bonus)/v_ultimo_bonus.bonus > 0.5 THEN
            raise_application_error(-20000, 'Aumento não pode ser superior as 50% face o mês anterior');
        END IF;
        
    END LOOP;
    CLOSE ultimo_bonus;
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