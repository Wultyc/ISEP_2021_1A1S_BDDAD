/*Ex 1 a)*/

select * from IntervencaoQuarto iq , Manutencao man 
where iq.id = man.intervencaoQuartoId  
and man.nrFuncionario in (select nrFuncionario from IntervencaoQuarto iq, manutencao man  where iq.id = man.intervencaoQuartoId  
 and (sysdate-2 ) > iq.dataIntervencao and nrfuncionario not in(select nrFuncionario from IntervencaoQuarto iq, manutencao man  
 where iq.id = man.intervencaoQuartoId  
 and (sysdate-2 ) < iq.dataIntervencao));

//Validacao 1, novo valor deve aparecer na tabela

Insert into Pessoa(nif, nome, email, telefone) values(410,'Nuno','Nuno@gmail','23454321');

Insert into Funcionario(nrFuncionario, nifFuncionario, telefoneProfissional) values(1150, 410, '987654321');

Insert into funcionarioManuntencao (nrFuncionario) values (1150);

Insert into IntervencaoQuarto(id, nrQuarto, dataIntervencao, concluido) values(6500, 1006,DATE  '2020-11-15', 'Y');

Insert into Manutencao (nrFuncionario, intervencaoQuartoId ,descricao) values(1150,6500,'Manutencao 4');

//Validacao 2, novo valor nao deve aparecer na tabela

Insert into Pessoa(nif, nome, email, telefone) values(420,'Nuno','Nuno@gmail','23454321');

Insert into Funcionario(nrFuncionario, nifFuncionario, telefoneProfissional) values(1160, 420, '987654321');

Insert into funcionarioManuntencao (nrFuncionario) values (1160);

Insert into IntervencaoQuarto(id, nrQuarto, dataIntervencao, concluido) values(7500, 1007,DATE  '2020-11-21', 'Y');

//Validacao 3,250 deve desaparecer da tabela.

Insert into IntervencaoQuarto(id, nrQuarto, dataIntervencao, concluido) values(7600, 1008,DATE  '2020-11-21', 'Y');

Insert into Manutencao (nrFuncionario, intervencaoQuartoId ,descricao) values(250,7600,'Manutencao 4');
