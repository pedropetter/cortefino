insert into profissionais (nome_completo, apelido, especialidades) values
  ('Rafael Mendonca', 'Rafa', array['Corte degrade', 'Barba modelada', 'Navalhado']);

insert into parametros_sistema (parametro, conteudo) values
  ('nome_barbearia', 'Corte Fino Barbearia'),
  ('hora_abertura', '09:00'),
  ('hora_fechamento', '20:00'),
  ('intervalo_minutos', '30'),
  ('whatsapp', '5563999999999'),
  ('endereco', 'Rua das Magnolias, 298 - Cidade Alegria, Resende - RJ, 27525-120'),
  ('chave_pix', ''),
  ('instagram', '@cortefino.barbearia')
on conflict (parametro) do update set conteudo = excluded.conteudo;

insert into catalogo_servicos (titulo, descricao, valor_base, tempo_execucao, posicao_exibicao) values
  ('Corte Degrade', 'Degrade limpo, transicao suave e acabamento alinhado.', 35.00, 45, 1),
  ('Corte + Barba', 'Corte completo com barba modelada, navalha e finalizacao.', 55.00, 60, 2),
  ('Corte Infantil', 'Corte infantil com cuidado, paciencia e acabamento estiloso.', 35.00, 35, 3),
  ('Corte + Pigmentacao', 'Corte alinhado com pigmentacao para realce e acabamento.', 45.00, 60, 4),
  ('Barba', 'Barba desenhada, alinhada e finalizada com precisao.', 25.00, 30, 5),
  ('Corte Tesoura', 'Corte na tesoura para caimento natural e acabamento classico.', 40.00, 45, 6),
  ('Corte + Luzes', 'Corte com luzes masculinas, contraste e textura.', 80.00, 90, 7),
  ('Platinado', 'Platinado masculino com controle de tom e finalizacao premium.', 90.00, 120, 8);

