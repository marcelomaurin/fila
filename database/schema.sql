-- Projeto Fila - esquema SQLite do núcleo de atendimento

CREATE TABLE IF NOT EXISTS senha (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  codigo TEXT NOT NULL,
  fila_id INTEGER NOT NULL,
  prioridade INTEGER NOT NULL DEFAULT 0,
  status TEXT NOT NULL,
  emitida_em TEXT NOT NULL,
  chamada_em TEXT,
  inicio_atendimento_em TEXT,
  fim_atendimento_em TEXT,
  guiche TEXT,
  operador TEXT,
  motivo_fim TEXT,
  origem TEXT NOT NULL DEFAULT 'FILA'
);

CREATE INDEX IF NOT EXISTS idx_senha_fila_status
  ON senha(fila_id, status, id);

CREATE TABLE IF NOT EXISTS evento (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  senha_id INTEGER,
  codigo TEXT,
  fila_id INTEGER,
  guiche TEXT,
  tipo TEXT NOT NULL,
  detalhes TEXT,
  criado_em TEXT NOT NULL,
  FOREIGN KEY(senha_id) REFERENCES senha(id)
);

CREATE INDEX IF NOT EXISTS idx_evento_data
  ON evento(criado_em);


-- Administração central dos painéis Android/TV
CREATE TABLE IF NOT EXISTS painel (
  painel_id TEXT PRIMARY KEY,
  nome TEXT,
  unidade TEXT,
  ip TEXT,
  versao TEXT,
  porta INTEGER,
  tcp_status TEXT,
  uptime_seg INTEGER NOT NULL DEFAULT 0,
  call_count INTEGER NOT NULL DEFAULT 0,
  ultima_senha TEXT,
  ultimo_guiche TEXT,
  ultimo_erro TEXT,
  last_seen TEXT,
  tts_enabled INTEGER NOT NULL DEFAULT 1,
  chime_enabled INTEGER NOT NULL DEFAULT 1,
  ads_url TEXT NOT NULL DEFAULT '',
  desired_port INTEGER,
  desired_tts INTEGER,
  desired_chime INTEGER,
  desired_ads_url TEXT
);

CREATE TABLE IF NOT EXISTS painel_comando (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  painel_id TEXT NOT NULL,
  tipo TEXT NOT NULL,
  payload TEXT,
  status TEXT NOT NULL DEFAULT 'PENDENTE',
  criado_em TEXT NOT NULL,
  enviado_em TEXT,
  concluido_em TEXT,
  resultado TEXT
);

CREATE INDEX IF NOT EXISTS idx_painel_comando_estado
  ON painel_comando(painel_id, status, id);
