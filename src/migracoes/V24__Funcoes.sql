CREATE OR REPLACE FUNCTION criar_personagem(
    p_nome_personagem VARCHAR(100)
) RETURNS TEXT AS $$
DECLARE
    v_sala_inicial RECORD;
    v_id_estagiario INT;
BEGIN

    SELECT id_sala, id_andar INTO v_sala_inicial
    FROM vw_sala_central --uma view
    WHERE numero_andar = 0;

    INSERT INTO Estagiario(
        nome, 
        xp, 
        nivel, 
        respeito,
        coins,
        status,
        andar_atual,
        sala_atual
    ) VALUES (
        p_nome_personagem,
        0,      
        1,    
        50,    
        100,   
        'Normal',
        v_sala_inicial.id_andar,
        v_sala_inicial.id_sala
    ) RETURNING id_personagem INTO v_id_estagiario;

    RETURN 'Estagiário "' || p_nome_personagem || '" criado com sucesso! (ID: ' || v_id_estagiario || ')';

EXCEPTION
    WHEN unique_violation THEN
        RETURN 'Erro: Já existe um estagiário com este nome.';
    WHEN OTHERS THEN
        RETURN 'Erro inesperado ao criar estagiário: ' || SQLERRM;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION descrever_local_detalhado(
    p_id_personagem INT
) RETURNS TABLE(nome_local TEXT, descricao TEXT, saidas TEXT[]) AS $$
DECLARE
    v_posicao RECORD;
BEGIN
    
    SELECT * INTO v_posicao
    FROM vw_posicao_estagiario --uma view
    WHERE id_personagem = p_id_personagem;

    RETURN QUERY
    WITH saidas_possiveis AS (
        
        SELECT 'Ir para ' || nome_sala_destino as direcao
        FROM vw_conexoes_salas
        WHERE id_sala_origem = v_posicao.sala_atual

        UNION ALL

     
        SELECT 
            CASE 
                WHEN a.numero > v_posicao.numero_andar THEN 'Subir para ' || REGEXP_REPLACE(a.nome, '.*?: ', '')
                WHEN a.numero < v_posicao.numero_andar THEN 'Descer para ' || REGEXP_REPLACE(a.nome, '.*?: ', '')
            END
        FROM Andar a
        WHERE v_posicao.nome_sala = 'Sala Central'
        AND ((a.numero = v_posicao.numero_andar + 1 AND v_posicao.numero_andar < 10)
          OR (a.numero = v_posicao.numero_andar - 1 AND v_posicao.numero_andar > -2))
    )
    SELECT 
        (v_posicao.nome_andar || E'\nSala: ' || v_posicao.nome_sala)::TEXT,
        v_posicao.descricao_sala::TEXT,
        ARRAY(
            SELECT direcao 
            FROM saidas_possiveis 
            WHERE direcao IS NOT NULL
            ORDER BY direcao
        )::TEXT[];
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION mover_personagem(
    p_id_personagem INT,
    p_direcao_texto VARCHAR(100)
) RETURNS TEXT AS $$
DECLARE
    v_posicao RECORD;
    v_novo_andar INT;
    v_nova_sala INT;
BEGIN

    SELECT * INTO v_posicao
    FROM vw_posicao_estagiario --uma view
    WHERE id_personagem = p_id_personagem;

    IF (p_direcao_texto LIKE 'Subir para%' OR p_direcao_texto LIKE 'Descer para%') THEN

        IF v_posicao.nome_sala != 'Sala Central' THEN
            RETURN 'Você só pode mudar de andar a partir da Sala Central.';
        END IF;


        SELECT sc.id_andar, sc.id_sala 
        INTO v_novo_andar, v_nova_sala
        FROM vw_sala_central sc
        JOIN Andar a ON sc.id_andar = a.id_andar
        WHERE p_direcao_texto LIKE '%' || REGEXP_REPLACE(a.nome, '.*?: ', '');

        IF v_novo_andar IS NOT NULL THEN
            UPDATE Estagiario 
            SET andar_atual = v_novo_andar,
                sala_atual = v_nova_sala
            WHERE id_personagem = p_id_personagem;
            
            RETURN 'Você mudou de andar.';
        END IF;

    ELSIF p_direcao_texto LIKE 'Ir para%' THEN

        SELECT id_sala_destino INTO v_nova_sala
        FROM vw_conexoes_salas
        WHERE id_sala_origem = v_posicao.sala_atual
        AND 'Ir para ' || nome_sala_destino = p_direcao_texto;

        IF v_nova_sala IS NOT NULL THEN
            UPDATE Estagiario 
            SET sala_atual = v_nova_sala
            WHERE id_personagem = p_id_personagem;
            
            RETURN 'Você se moveu para outra sala.';
        END IF;
    END IF;

    RETURN 'Movimento inválido.';
END;
$$ LANGUAGE plpgsql;