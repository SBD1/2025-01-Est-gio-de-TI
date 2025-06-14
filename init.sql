-- PASSO 1: CRIAR O SCHEMA
CREATE SCHEMA IF NOT EXISTS SBD1;

-- PASSO 2: CRIAR AS TABELAS DENTRO DO SCHEMA (DDL)
CREATE TABLE SBD1.Andar (
    id SERIAL PRIMARY KEY,
    numero INT NOT NULL,
    descricao VARCHAR(255)
);

CREATE TABLE SBD1.Sala (
    id SERIAL PRIMARY KEY,
    id_andar INT NOT NULL,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    FOREIGN KEY (id_andar) REFERENCES SBD1.Andar(id)
);

CREATE TABLE SBD1.Personagem (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL UNIQUE,
    id_sala_atual INT,
    FOREIGN KEY (id_sala_atual) REFERENCES SBD1.Sala(id)
);

CREATE TABLE SBD1.Conexao (
    id SERIAL PRIMARY KEY,
    id_sala_origem INT NOT NULL,
    id_sala_destino INT NOT NULL,
    nome_saida VARCHAR(100) NOT NULL,
    FOREIGN KEY (id_sala_origem) REFERENCES SBD1.Sala(id),
    FOREIGN KEY (id_sala_destino) REFERENCES SBD1.Sala(id)
);

-- PASSO 3: INSERIR OS DADOS INICIAIS (DML)
INSERT INTO SBD1.Andar (numero, descricao) VALUES (1, 'Primeiro andar'), (2, 'Segundo andar');

INSERT INTO SBD1.Sala (id, id_andar, nome, descricao) VALUES
(1, 1, 'Recepção', 'Você está na recepção. O ar cheira a café e papel antigo.'),
(2, 1, 'Cafeteria', 'Um lugar para relaxar e tomar um café.'),
(3, 1, 'Corredor 1A', 'Um corredor longo e silencioso no primeiro andar.'),
(4, 2, 'Corredor 2A', 'Corredor do segundo andar. O carpete aqui é de um vermelho berrante.'),
(5, 2, 'Escritório 201', 'Um escritório com uma grande janela de vidro.'),
(6, 2, 'Sala de Reuniões', 'Uma sala imponente com uma mesa de mogno no centro.');
-- Forçar o reinício da sequência do ID da sala para evitar problemas
SELECT setval('SBD1.Sala_id_seq', (SELECT MAX(id) FROM SBD1.Sala));


INSERT INTO SBD1.Conexao (id_sala_origem, id_sala_destino, nome_saida) VALUES
(1, 2, 'ir para a cafeteria'), (1, 3, 'seguir pelo corredor'), (1, 4, 'subir as escadas'),
(2, 1, 'voltar para a recepção'),
(3, 1, 'ir para a recepção'),
(4, 5, 'entrar no escritório 201'), (4, 6, 'ir para a sala de reuniões'), (4, 1, 'descer as escadas'), -- CORRIGIDO: Escada desce para a Recepção
(5, 4, 'sair para o corredor'),
(6, 4, 'sair para o corredor');


-- PASSO 4: CRIAR AS FUNÇÕES DO JOGO
CREATE OR REPLACE FUNCTION SBD1.criar_personagem(p_nome_personagem VARCHAR(100)) RETURNS TEXT AS $$ DECLARE v_mensagem TEXT; BEGIN INSERT INTO SBD1.Personagem(nome, id_sala_atual) VALUES (p_nome_personagem, 1) RETURNING 'Personagem "' || p_nome_personagem || '" criado com sucesso!' INTO v_mensagem; RETURN v_mensagem; EXCEPTION WHEN unique_violation THEN RETURN 'Erro: Já existe um personagem com este nome.'; WHEN OTHERS THEN RETURN 'Erro inesperado ao criar personagem.'; END; $$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION SBD1.descrever_local_atual(p_id_personagem INT) RETURNS TEXT AS $$ DECLARE v_descricao_sala TEXT; v_nome_sala_atual VARCHAR(100); v_saidas_disponiveis TEXT; v_id_sala_atual INT; BEGIN SELECT P.id_sala_atual INTO v_id_sala_atual FROM SBD1.Personagem P WHERE P.id = p_id_personagem; IF v_id_sala_atual IS NULL THEN RETURN 'Erro: Personagem não encontrado ou sem localização definida.'; END IF; SELECT S.nome, S.descricao INTO v_nome_sala_atual, v_descricao_sala FROM SBD1.Sala S WHERE S.id = v_id_sala_atual; SELECT string_agg(C.nome_saida, ', ') INTO v_saidas_disponiveis FROM SBD1.Conexao C WHERE C.id_sala_origem = v_id_sala_atual; IF v_saidas_disponiveis IS NULL THEN v_saidas_disponiveis := 'Nenhuma'; END IF; RETURN 'Você está em: ' || v_nome_sala_atual || E'\n' || v_descricao_sala || E'\n\n' || 'Saídas disponíveis: ' || v_saidas_disponiveis; END; $$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION SBD1.mover_personagem(p_id_personagem INT, p_direcao_movimento VARCHAR(100)) RETURNS TEXT AS $$ DECLARE v_id_sala_destino INT; v_id_sala_origem INT; BEGIN SELECT P.id_sala_atual INTO v_id_sala_origem FROM SBD1.Personagem P WHERE P.id = p_id_personagem; SELECT C.id_sala_destino INTO v_id_sala_destino FROM SBD1.Conexao C WHERE C.id_sala_origem = v_id_sala_origem AND lower(C.nome_saida) = lower(p_direcao_movimento); IF v_id_sala_destino IS NOT NULL THEN UPDATE SBD1.Personagem SET id_sala_atual = v_id_sala_destino WHERE id = p_id_personagem; RETURN SBD1.descrever_local_atual(p_id_personagem); ELSE RETURN 'Você não pode ir por aí.'; END IF; END; $$ LANGUAGE plpgsql;

-- Função Otimizada para o Python
-- Retorna os detalhes do local de forma estruturada: nome, descrição e um ARRAY com as saídas.
CREATE OR REPLACE FUNCTION SBD1.descrever_local_detalhado(
    p_id_personagem INT
) RETURNS TABLE(nome_sala TEXT, descricao TEXT, saidas TEXT[]) AS $$
DECLARE
    v_id_sala_atual INT;
BEGIN
    -- Encontra a localização atual do personagem
    SELECT P.id_sala_atual INTO v_id_sala_atual
    FROM SBD1.Personagem P
    WHERE P.id = p_id_personagem;

    -- Usa um 'RETURN QUERY' para retornar os resultados da consulta diretamente
    RETURN QUERY
        SELECT
            S.nome::TEXT,
            S.descricao,
            -- Usa array_agg para agrupar as saídas em uma lista de texto (array)
            array_agg(C.nome_saida)::TEXT[]
        FROM
            SBD1.Sala S
        LEFT JOIN
            SBD1.Conexao C ON S.id = C.id_sala_origem
        WHERE
            S.id = v_id_sala_atual
        GROUP BY
            S.nome, S.descricao;
END;
$$ LANGUAGE plpgsql;