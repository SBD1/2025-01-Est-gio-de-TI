INSERT INTO Sala (id_andar, nome, descricao) VALUES
-- Subsolo 2 (Andar 11)
(11, 'Sala Central', 'Uma sala gigantesca e gelada com servidores.'),
(11, 'Data Center', 'Fileiras de servidores zumbindo.'),
(11, 'Sala de Controle', 'Monitores mostrando métricas dos servidores.'),

-- Subsolo 1 (Andar 12)
(12, 'Sala Central', 'Área principal do almoxarifado.'),
(12, 'Depósito', 'Prateleiras com equipamentos.'),
(12, 'Oficina', 'Bancadas para manutenção.'),

-- Térreo (Andar 13)
(13, 'Sala Central', 'Área principal da recepção.'),
(13, 'Recepção', 'Balcão com recepcionista.'),
(13, 'Área de Espera', 'Sofás e revistas tech.'),

-- Andar 1 (Suporte Básico)
(1, 'Sala Central', 'Central do suporte básico.'),
(1, 'Help Desk', 'Baias de atendimento.'),
(1, 'Sala de Treinamento', 'Sala com computadores em fileiras.'),

-- Andar 2 (Hardware)
(2, 'Sala Central', 'Centro da oficina de hardware.'),
(2, 'Laboratório', 'Bancadas com equipamentos.'),
(2, 'Depósito de Peças', 'Estoque organizado.'),

-- Andar 3 (Suporte Remoto)
(3, 'Sala Central', 'Central de suporte remoto.'),
(3, 'NOC', 'Sala de monitoramento.'),
(3, 'Sala de Atendimento', 'Estações de trabalho.'),

-- Andar 4 (Infraestrutura)
(4, 'Sala Central', 'Centro de infraestrutura.'),
(4, 'Sala de Servidores', 'Racks de equipamentos.'),
(4, 'Sala de Redes', 'Central de cabeamento.'),

-- Andar 5 (Redes)
(5, 'Sala Central', 'Centro de operações de rede.'),
(5, 'Sala de Monitoramento', 'Telões com métricas.'),
(5, 'Laboratório de Redes', 'Área de testes.'),

-- Andar 6 (Segurança)
(6, 'Sala Central', 'Centro de segurança.'),
(6, 'SOC', 'Centro de operações de segurança.'),
(6, 'Sala de Testes', 'Ambiente isolado para testes.'),

-- Andar 7 (Web)
(7, 'Sala Central', 'Área de desenvolvimento web.'),
(7, 'Frontend', 'Time de frontend.'),
(7, 'Design', 'Equipe de UX/UI.'),

-- Andar 8 (Backend)
(8, 'Sala Central', 'Área de backend.'),
(8, 'Desenvolvimento', 'Time de backend.'),
(8, 'Arquitetura', 'Planejamento de sistemas.'),

-- Andar 9 (DevOps)
(9, 'Sala Central', 'Centro de DevOps.'),
(9, 'CI/CD', 'Pipelines e automação.'),
(9, 'Containers', 'Orquestração e deploy.'),

-- Andar 10 (Diretoria)
(10, 'Sala Central', 'Recepção da diretoria.'),
(10, 'Sala do Chefe', 'Escritório principal.'),
(10, 'Sala de Reuniões', 'Mesa grande e tela de projeção.');


INSERT INTO ConexaoSala (id_sala_origem, id_sala_destino) VALUES
-- Subsolo 2 (Andar 11)
(1, 2), -- Sala Central -> Data Center
(2, 1), -- Data Center -> Sala Central
(1, 3), -- Sala Central -> Sala de Controle
(3, 1), -- Sala de Controle -> Sala Central

-- Subsolo 1 (Andar 12)
(4, 5), -- Sala Central -> Depósito
(5, 4), -- Depósito -> Sala Central
(4, 6), -- Sala Central -> Oficina
(6, 4), -- Oficina -> Sala Central

-- Térreo (Andar 13)
(7, 8), -- Sala Central -> Recepção
(8, 7), -- Recepção -> Sala Central
(7, 9), -- Sala Central -> Área de Espera
(9, 7), -- Área de Espera -> Sala Central

-- Andar 1 (Suporte Básico)
(10, 11), -- Sala Central -> Help Desk
(11, 10), -- Help Desk -> Sala Central
(10, 12), -- Sala Central -> Sala de Treinamento
(12, 10), -- Sala de Treinamento -> Sala Central

-- Andar 2 (Hardware)
(13, 14), -- Sala Central -> Laboratório
(14, 13), -- Laboratório -> Sala Central
(13, 15), -- Sala Central -> Depósito de Peças
(15, 13), -- Depósito de Peças -> Sala Central

-- Andar 3 (Suporte Remoto)
(16, 17), -- Sala Central -> NOC
(17, 16), -- NOC -> Sala Central
(16, 18), -- Sala Central -> Sala de Atendimento
(18, 16), -- Sala de Atendimento -> Sala Central

-- Andar 4 (Infraestrutura)
(19, 20), -- Sala Central -> Sala de Servidores
(20, 19), -- Sala de Servidores -> Sala Central
(19, 21), -- Sala Central -> Sala de Redes
(21, 19), -- Sala de Redes -> Sala Central

-- Andar 5 (Redes)
(22, 23), -- Sala Central -> Sala de Monitoramento
(23, 22), -- Sala de Monitoramento -> Sala Central
(22, 24), -- Sala Central -> Laboratório de Redes
(24, 22), -- Laboratório de Redes -> Sala Central

-- Andar 6 (Segurança)
(25, 26), -- Sala Central -> SOC
(26, 25), -- SOC -> Sala Central
(25, 27), -- Sala Central -> Sala de Testes
(27, 25), -- Sala de Testes -> Sala Central

-- Andar 7 (Web)
(28, 29), -- Sala Central -> Frontend
(29, 28), -- Frontend -> Sala Central
(28, 30), -- Sala Central -> Design
(30, 28), -- Design -> Sala Central

-- Andar 8 (Backend)
(31, 32), -- Sala Central -> Desenvolvimento
(32, 31), -- Desenvolvimento -> Sala Central
(31, 33), -- Sala Central -> Arquitetura
(33, 31), -- Arquitetura -> Sala Central

-- Andar 9 (DevOps)
(34, 35), -- Sala Central -> CI/CD
(35, 34), -- CI/CD -> Sala Central
(34, 36), -- Sala Central -> Containers
(36, 34), -- Containers -> Sala Central

-- Andar 10 (Diretoria)
(37, 38), -- Sala Central -> Sala do Chefe
(38, 37), -- Sala do Chefe -> Sala Central
(37, 39), -- Sala Central -> Sala de Reuniões
(39, 37); -- Sala de Reuniões -> Sala Central
