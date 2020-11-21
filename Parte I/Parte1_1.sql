/*Ex 1 a)*/

(select nrFuncionario from IntervencaoQuarto iq,Manutencao man where iq.id = man.intervencaoQuartoId 
 and sysdate > iq.dataIntervencao and iq.concluido = 'N');