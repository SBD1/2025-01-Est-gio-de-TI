CREATE TABLE IF NOT EXISTS Sala (
    id_sala SERIAL PRIMARY KEY,
    id_andar INT NOT NULL,
    bloqueada BOOLEAN NOT NULL DEFAULT false,
    FOREIGN KEY (id_andar) REFERENCES Andar(id_andar),
    nome VARCHAR(200) NOT NULL,
    descricao TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS ConexaoSala (

    id_sala_origem INT NOT NULL,
    FOREIGN KEY (id_sala_origem) REFERENCES Sala(id_sala),
    
    id_sala_destino INT NOT NULL,
    FOREIGN KEY (id_sala_destino) REFERENCES Sala(id_sala),

    direcao VARCHAR(10) NOT NULL CHECK (direcao IN ('Norte', 'Sul', 'Leste', 'Oeste')),
    descricao VARCHAR(200),

    PRIMARY KEY (id_sala_origem, direcao),
    UNIQUE (id_sala_origem, id_sala_destino)
);