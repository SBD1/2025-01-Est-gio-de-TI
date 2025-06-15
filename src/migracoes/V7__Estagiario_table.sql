CREATE TABLE IF NOT EXISTS Estagiario (
    id_personagem SERIAL PRIMARY KEY,
    

    nome VARCHAR(100),

    xp INT NOT NULL CHECK (xp BETWEEN 0 AND 10000),
    nivel INT NOT NULL CHECK (nivel >= 1 AND nivel <= 100),
    respeito INT DEFAULT 0 CHECK (respeito >= 0 AND respeito <= 100),
    coins INT NOT NULL DEFAULT 0,
    status VARCHAR(20) NOT NULL CHECK (status IN ('Normal', 'Confuso', 'Estressado', 'Motivado')),

    andar_atual INT,
    sala_atual INT,
    FOREIGN KEY (andar_atual) REFERENCES Andar(id_andar),
    FOREIGN KEY (sala_atual) REFERENCES Sala(id_sala),
    CONSTRAINT UQ_Estagiario_Nome UNIQUE(nome)
);