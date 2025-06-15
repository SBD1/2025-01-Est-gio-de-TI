CREATE TABLE IF NOT EXISTS Andar (
    id_andar SERIAL PRIMARY KEY,
    id_mundo INT NOT NULL, 
    FOREIGN KEY (id_mundo) REFERENCES Mundo(id_mundo),
    numero SMALLINT NOT NULL, -- -2 = Subsolo 2, -1 = Subsolo 1, 0 = Térreo, 1~10 = Andares
    nome VARCHAR(100) NOT NULL
    
);

