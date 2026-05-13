insert into profissionais (nome_completo, apelido, especialidades) values
  ('Rafael Mendonca', 'Rafa', array['Corte degrade', 'Barba modelada', 'Navalhado']),
  ('Lucas Ferreira', 'Lukas', array['Corte social', 'Progressiva', 'Hidratacao']);

insert into parametros_sistema (parametro, conteudo) values
  ('nome_barbearia', 'Corte Fino Barbearia'),
  ('hora_abertura', '09:00'),
  ('hora_fechamento', '20:00'),
  ('intervalo_minutos', '30'),
  ('whatsapp', '5563999999999'),
  ('endereco', 'Dianopolis, Tocantins'),
  ('chave_pix', ''),
  ('instagram', '@cortefino.barbearia')
on conflict (parametro) do update set conteudo = excluded.conteudo;

insert into catalogo_servicos (titulo, descricao, valor_base, tempo_execucao, posicao_exibicao) values
  ('Corte Classico', 'Corte tradicional com tesoura e maquina. Inclui lavagem e finalizacao.', 45.00, 45, 1),
  ('Corte + Barba', 'Combinacao completa: corte no cabelo e modelagem da barba com navalha.', 70.00, 75, 2),
  ('Barba Completa', 'Alinhamento, modelagem e hidratacao da barba. Toalha quente e produtos premium.', 35.00, 40, 3),
  ('Degrade Americano', 'Fade preciso com acabamento impecavel nas laterais e nuca.', 55.00, 50, 4),
  ('Hidratacao Capilar', 'Tratamento profundo com produtos de alta performance para cabelos danificados.', 40.00, 40, 5);
