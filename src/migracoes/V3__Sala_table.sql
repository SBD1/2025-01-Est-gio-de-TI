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


    PRIMARY KEY (id_sala_origem, id_sala_destino),
    CHECK (id_sala_origem != id_sala_destino)
);

