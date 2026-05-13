create extension if not exists "uuid-ossp";

do $$
begin
  if not exists (select 1 from pg_type where typname = 'status_agendamento') then
    create type status_agendamento as enum (
      'aguardando',
      'confirmado',
      'em_atendimento',
      'concluido',
      'ausente',
      'cancelado'
    );
  end if;
end $$;

create table if not exists profissionais (
  uid uuid primary key default uuid_generate_v4(),
  nome_completo text not null,
  apelido text,
  avatar_url text,
  especialidades text[],
  ativo boolean not null default true,
  criado_em timestamptz not null default now()
);

create table if not exists catalogo_servicos (
  uid uuid primary key default uuid_generate_v4(),
  titulo text not null,
  descricao text,
  valor_base numeric(10,2) not null,
  tempo_execucao integer not null,
  imagem_url text,
  visivel boolean not null default true,
  posicao_exibicao integer not null default 0,
  criado_em timestamptz not null default now()
);

create table if not exists agenda (
  uid uuid primary key default uuid_generate_v4(),
  profissional_uid uuid not null references profissionais(uid) on delete restrict,
  servico_uid uuid not null references catalogo_servicos(uid) on delete restrict,
  nome_cliente text not null,
  fone_cliente text not null,
  data_agendamento date not null,
  hora_inicio time not null,
  situacao status_agendamento not null default 'aguardando',
  nota_interna text,
  valor_final numeric(10,2),
  criado_em timestamptz not null default now()
);

create table if not exists bloqueios_agenda (
  uid uuid primary key default uuid_generate_v4(),
  profissional_uid uuid references profissionais(uid) on delete cascade,
  data_bloqueio date not null,
  hora_inicio time,
  hora_fim time,
  dia_inteiro boolean not null default false,
  descricao text,
  criado_em timestamptz not null default now()
);

create table if not exists parametros_sistema (
  uid uuid primary key default uuid_generate_v4(),
  parametro text unique not null,
  conteudo text not null,
  atualizado_em timestamptz not null default now()
);

create index if not exists idx_agenda_data on agenda(data_agendamento);
create index if not exists idx_agenda_profissional on agenda(profissional_uid);
create index if not exists idx_agenda_situacao on agenda(situacao);
create index if not exists idx_bloqueios_data on bloqueios_agenda(data_bloqueio);

alter table profissionais enable row level security;
alter table catalogo_servicos enable row level security;
alter table agenda enable row level security;
alter table bloqueios_agenda enable row level security;
alter table parametros_sistema enable row level security;

drop policy if exists "leitura_publica_servicos" on catalogo_servicos;
create policy "leitura_publica_servicos"
  on catalogo_servicos for select
  using (visivel = true);

drop policy if exists "gestao_servicos" on catalogo_servicos;
create policy "gestao_servicos"
  on catalogo_servicos for all
  using (auth.role() = 'authenticated')
  with check (auth.role() = 'authenticated');

drop policy if exists "leitura_publica_profissionais" on profissionais;
create policy "leitura_publica_profissionais"
  on profissionais for select
  using (ativo = true);

drop policy if exists "gestao_profissionais" on profissionais;
create policy "gestao_profissionais"
  on profissionais for all
  using (auth.role() = 'authenticated')
  with check (auth.role() = 'authenticated');

drop policy if exists "inserir_agendamento_publico" on agenda;
create policy "inserir_agendamento_publico"
  on agenda for insert
  with check (true);

drop policy if exists "leitura_agenda_autenticado" on agenda;
create policy "leitura_agenda_autenticado"
  on agenda for select
  using (auth.role() = 'authenticated');

drop policy if exists "atualizar_agenda_autenticado" on agenda;
create policy "atualizar_agenda_autenticado"
  on agenda for update
  using (auth.role() = 'authenticated')
  with check (auth.role() = 'authenticated');

drop policy if exists "deletar_agenda_autenticado" on agenda;
create policy "deletar_agenda_autenticado"
  on agenda for delete
  using (auth.role() = 'authenticated');

drop policy if exists "gestao_bloqueios" on bloqueios_agenda;
create policy "gestao_bloqueios"
  on bloqueios_agenda for all
  using (auth.role() = 'authenticated')
  with check (auth.role() = 'authenticated');

drop policy if exists "leitura_parametros_publicos" on parametros_sistema;
create policy "leitura_parametros_publicos"
  on parametros_sistema for select
  using (parametro in ('nome_barbearia', 'whatsapp', 'endereco', 'hora_abertura', 'hora_fechamento'));

drop policy if exists "gestao_parametros" on parametros_sistema;
create policy "gestao_parametros"
  on parametros_sistema for all
  using (auth.role() = 'authenticated')
  with check (auth.role() = 'authenticated');

insert into storage.buckets (id, name, public)
values ('fotos-servicos', 'fotos-servicos', true)
on conflict (id) do update set public = excluded.public;

drop policy if exists "upload_fotos_autenticado" on storage.objects;
create policy "upload_fotos_autenticado"
  on storage.objects for insert
  with check (bucket_id = 'fotos-servicos' and auth.role() = 'authenticated');

drop policy if exists "leitura_fotos_publica" on storage.objects;
create policy "leitura_fotos_publica"
  on storage.objects for select
  using (bucket_id = 'fotos-servicos');
