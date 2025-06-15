
-- Views para funcoes e triggers

CREATE VIEW vw_posicao_estagiario AS
SELECT 
    e.id_personagem,
    e.andar_atual,
    e.sala_atual,
    a.numero as numero_andar,
    a.nome as nome_andar,
    s.nome as nome_sala,
    s.descricao as descricao_sala
FROM Estagiario e
JOIN Andar a ON e.andar_atual = a.id_andar
JOIN Sala s ON e.sala_atual = s.id_sala;



CREATE VIEW vw_conexoes_salas AS
SELECT 
    cs.id_sala_origem,
    cs.id_sala_destino,
    s.nome as nome_sala_destino,
    s.id_andar as andar_destino,
    a.numero as numero_andar_destino
FROM ConexaoSala cs
JOIN Sala s ON cs.id_sala_destino = s.id_sala
JOIN Andar a ON s.id_andar = a.id_andar;

-- View para obter a Sala Central de cada andar
CREATE VIEW vw_sala_central AS
SELECT 
    s.id_sala,
    s.id_andar,
    a.numero as numero_andar
FROM Sala s
JOIN Andar a ON s.id_andar = a.id_andar
WHERE s.nome = 'Sala Central';