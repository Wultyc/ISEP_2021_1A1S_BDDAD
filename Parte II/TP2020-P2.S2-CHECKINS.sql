SELECT
    camareira.id,
    sum(artigo_consumo.preco) as "total_consumos_registados"
FROM camareira
    JOIN linha_conta_consumo ON camareira.id = linha_conta_consumo.id_camareira
    JOIN artigo_consumo ON linha_conta_consumo.id_artigo_consumo = artigo_consumo.id
GROUP BY camareira.id;