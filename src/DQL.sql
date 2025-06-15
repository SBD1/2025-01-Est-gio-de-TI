-- ==========================
-- 1. Estrutura Física
-- ==========================


SELECT * FROM Mundo;

SELECT * FROM Andar WHERE id_mundo = 1 ORDER BY numero;

SELECT * FROM Sala WHERE id_andar = 1;



-- ==========================
-- 2. Personagens
-- ==========================

SELECT * FROM Estagiario;



-- Listar todos os chefes finais
SELECT ChefeFinal.*, Personagem.nome
FROM ChefeFinal
JOIN Personagem ON ChefeFinal.id_personagem = Personagem.id_personagem;


-- ==========================
-- 3. Itens e Inventário
-- ==========================

-- Listar todos os itens
SELECT * FROM Item;

-- Listar todos os itens em uma sala específica
SELECT InstanciaItem.*, Item.nome
FROM InstanciaItem
JOIN Item ON InstanciaItem.id_item = Item.id_item
WHERE id_sala = 4;

-- Listar todos os itens no inventário de um estagiário
SELECT InstanciaItem.*, Item.nome
FROM InstanciaItem
JOIN Item ON InstanciaItem.id_item = Item.id_item
WHERE id_estagiario = 1;

-- Listar inventários existentes
SELECT * FROM Inventario;


-- ==========================
-- 4. Missões e Progresso
-- ==========================

-- Listar todas as missões
SELECT * FROM Missao;

-- Listar missões de um andar específico
SELECT Missao.* FROM Missao WHERE andar = 1;

-- Listar missões concluídas por um estagiário
SELECT MissaoConcluida.*, Missao.nome
FROM MissaoConcluida
JOIN Missao ON MissaoConcluida.id_missao = Missao.id_missao
WHERE id_estagiario = 1;

-- Listar missões disponíveis em determinado andar
SELECT Missao.*
FROM MissaoAndar
JOIN Missao ON MissaoAndar.id_missao = Missao.id_missao
WHERE MissaoAndar.id_andar = 1;


-- ==========================
-- 5. Demandas (Sidequests)
-- ==========================

-- Listar todas as demandas
SELECT * FROM Demanda;

-- Listar demandas concluídas por estagiário
SELECT DemandaConcluida.*, Demanda.nome
FROM DemandaConcluida
JOIN Demanda ON DemandaConcluida.id_demanda = Demanda.id_demanda
WHERE id_estagiario = 1;

-- Demandas abertas (não concluídas) para um estagiário
SELECT D.*
FROM Demanda D
LEFT JOIN DemandaConcluida DC ON D.id_demanda = DC.id_demanda AND DC.id_estagiario = 1
WHERE DC.id_demanda IS NULL;


-- ==========================
-- 6. Interações e Eventos
-- ==========================

-- Listar todos os diálogos de um personagem
SELECT * FROM Dialogo WHERE id_personagem = 2;

-- Listar todas as transações realizadas por um estagiário
SELECT * FROM Transacao WHERE id_estagiario = 1;

-- Listar todos os combates de um estagiário
SELECT * FROM Combate WHERE id_estagiario = 1;


-- ==========================
-- 7. Especializações de Itens
-- ==========================

-- Listar todos os consumíveis e seus efeitos
SELECT Consumivel.*, Item.nome
FROM Consumivel
JOIN Item ON Consumivel.id_item = Item.id_item;

-- Listar todos os power-ups
SELECT PowerUp.*, Item.nome
FROM PowerUp
JOIN Item ON PowerUp.id_item = Item.id_item;

-- Listar todas as chaves
SELECT Chave.*, Item.nome
FROM Chave
JOIN Item ON Chave.id_item = Item.id_item;

-- Listar todos os grimórios
SELECT Grimorio.*, Item.nome
FROM Grimorio
JOIN Item ON Grimorio.id_item = Item.id_item;

-- Listar todas as histórias
SELECT Historia.*, Item.nome
FROM Historia
JOIN Item ON Historia.id_item = Item.id_item;


-- ==========================
-- 8. Checkpoints e Progresso
-- ==========================

-- Listar todos os checkpoints de um estagiário
SELECT * FROM Checkpoint WHERE id_estagiario = 1;


-- ==========================
-- 9. Conexões entre Salas
-- ==========================

-- Listar todas as conexões de uma sala
SELECT * FROM ConexaoSala WHERE id_sala_origem = 4 OR id_sala_destino = 4;


-- ==========================
-- 10. Loja da Cafeteria
-- ==========================

-- Listar todos os itens à venda na cafeteria
SELECT LojaCafeteria.*, Item.nome
FROM LojaCafeteria
JOIN Item ON LojaCafeteria.id_item = Item.id_item;

-- Listar todos os itens de uma cafeteria específica
SELECT LojaCafeteria.*, Item.nome
FROM LojaCafeteria
JOIN Item ON LojaCafeteria.id_item = Item.id_item
WHERE id_cafeteria = 1;


-- ==========================
-- 11. Consultas Avançadas e Relatórios
-- ==========================

-- Quantidade de missões/demandas concluídas por estagiário
SELECT
    P.nome,
    COUNT(DISTINCT MC.id_missao) AS missoes_concluidas,
    COUNT(DISTINCT DC.id_demanda) AS demandas_concluidas
FROM Personagem P
LEFT JOIN Estagiario E ON P.id_personagem = E.id_personagem
LEFT JOIN MissaoConcluida MC ON MC.id_estagiario = E.id_personagem
LEFT JOIN DemandaConcluida DC ON DC.id_estagiario = E.id_personagem
WHERE E.id_personagem IS NOT NULL
GROUP BY P.nome;

-- Ranking de estagiários por XP
SELECT P.nome, E.xp, E.nivel
FROM Estagiario E
JOIN Personagem P ON E.id_personagem = P.id_personagem
ORDER BY E.xp DESC, E.nivel DESC;

-- Itens mais presentes no inventário dos estagiários
SELECT Item.nome, SUM(InstanciaItem.quantidade) AS total
FROM InstanciaItem
JOIN Item ON InstanciaItem.id_item = Item.id_item
GROUP BY Item.nome
ORDER BY total DESC;

-- Itens disponíveis em cada sala
SELECT S.nome AS sala, I.nome AS item, II.quantidade
FROM InstanciaItem II
JOIN Sala S ON II.id_sala = S.id_sala
JOIN Item I ON II.id_item = I.id_item
ORDER BY S.nome, I.nome;

-- Missões e demandas pendentes de um estagiário
SELECT 'Missao' AS tipo, M.nome, M.descricao
FROM Missao M
LEFT JOIN MissaoConcluida MC ON M.id_missao = MC.id_missao AND MC.id_estagiario = 1
WHERE MC.id_missao IS NULL
UNION ALL
SELECT 'Demanda' AS tipo, D.nome, D.descricao
FROM Demanda D
LEFT JOIN DemandaConcluida DC ON D.id_demanda = DC.id_demanda AND DC.id_estagiario = 1
WHERE DC.id_demanda IS NULL;


