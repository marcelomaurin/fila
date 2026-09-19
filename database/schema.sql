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
