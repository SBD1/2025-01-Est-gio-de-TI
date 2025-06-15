import os
import time
from database import call_db_function, get_all_characters
from database import call_db_function, get_all_characters, get_location_details

def clear_screen():
    """Limpa a tela do terminal."""
    os.system('cls' if os.name == 'nt' else 'clear')

def criar_personagem():
    """Lida com a lógica de criação de personagem."""
    clear_screen()
    print("--- CRIAÇÃO DE PERSONAGEM ---\n")
    nome = input("Digite o nome do seu personagem: ").strip()

    if not nome:
        print("\nO nome não pode ser vazio. Tente novamente.")
        time.sleep(2)
        return

    # Chama a função SQL para criar o personagem
    mensagem = call_db_function('criar_personagem', nome)
    print(f"\n{mensagem}")
    time.sleep(3)

def iniciar_jogo():
    """Lida com a seleção de personagem e o início do loop do jogo."""
    clear_screen()
    print("--- INICIAR JOGO ---\n")
    print("Selecione um personagem para continuar:\n")

    personagens = get_all_characters()

    if not personagens:
        print("Nenhum personagem criado ainda.")
        print("Por favor, crie um personagem no menu principal primeiro.")
        time.sleep(3)
        return

    for char_id, char_name in personagens:
        print(f"[{char_id}] - {char_name}")

    try:
        escolha = int(input("\nDigite o ID do personagem: "))
        # Verifica se a escolha é um ID válido
        personagem_selecionado = next((p for p in personagens if p[0] == escolha), None)

        if not personagem_selecionado:
            raise ValueError

        game_loop(personagem_selecionado[0], personagem_selecionado[1])

    except (ValueError, IndexError):
        print("\nOpção inválida. Retornando ao menu principal.")
        time.sleep(2)

def game_loop(personagem_id, personagem_nome):
    """O loop principal do jogo, com menu de opções numérico."""
    clear_screen()
    print(f"Iniciando o jogo com {personagem_nome}...")
    time.sleep(2)

    while True:
        clear_screen()
        
        # 1. Pega os detalhes estruturados do local atual
        location_details = get_location_details(personagem_id)

        if not location_details:
            print("Erro ao carregar o local. Voltando ao menu.")
            time.sleep(3)
            break
        
        nome_sala, descricao_sala, saidas_disponiveis = location_details

        # 2. Exibe as informações do local
        print(f"--- {personagem_nome} ---")
        print(f"Você está no: {nome_sala}")
        print(descricao_sala)
        print("\n--------------------")
        print("O que você faz?\n")

        # Garante que 'saidas_disponiveis' não seja None. Se for, é uma lista vazia.
        saidas_disponiveis = saidas_disponiveis or []
        
        # 3. Exibe o menu de opções numerado
        for i, saida in enumerate(saidas_disponiveis, start=1):
            print(f"  [{i}] {saida}")
        
        # Adiciona a opção de sair
        print(f"  [{len(saidas_disponiveis) + 1}] Voltar ao menu principal")
        print("\n--------------------")

        # 4. Pega e processa a escolha do jogador
        try:
            escolha_str = input("Sua escolha: ").strip()
            if not escolha_str: continue # Se o usuário só apertar Enter, repete o loop

            escolha_num = int(escolha_str)
            
            # Opção de sair do jogo
            if escolha_num == len(saidas_disponiveis) + 1:
                print("\nVoltando ao menu principal...")
                time.sleep(2)
                break
            
            # Opção de movimento válida
            elif 1 <= escolha_num <= len(saidas_disponiveis):
                # Pega o nome da saída escolhida da lista
                direcao_escolhida = saidas_disponiveis[escolha_num - 1]
                
                # Chama a função de movimento original
                print(f"\nTentando: {direcao_escolhida}...")
                call_db_function('mover_personagem', personagem_id, direcao_escolhida)
                time.sleep(1) # Pequena pausa para o jogador ler
            
            else:
                print("\nOpção inválida. Tente novamente.")
                time.sleep(2)

        except ValueError:
            print("\nPor favor, digite um número. Tente novamente.")
            time.sleep(2)


def main_menu():
    """Exibe o menu principal e gerencia a navegação."""
    while True:
        clear_screen()
        print("========================================")
        print("      BEM-VINDO AO JOGO DE TERMINAL     ")
        print("========================================")
        print("\nEscolha uma opção:")
        print("  [1] Criar Novo Personagem")
        print("  [2] Iniciar Jogo")
        print("  [3] Sair")
        print("\n----------------------------------------")

        escolha = input("Sua escolha: ").strip()

        if escolha == '1':
            criar_personagem()
        elif escolha == '2':
            iniciar_jogo()
        elif escolha == '3':
            print("\nObrigado por jogar! Até a próxima.")
            break
        else:
            print("\nOpção inválida. Tente novamente.")
            time.sleep(2)

if __name__ == "__main__":
    # Garante que o Docker está rodando antes de começar
    conn_test = get_all_characters()
    if conn_test is not None:
        main_menu()