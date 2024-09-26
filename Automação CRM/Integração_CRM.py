import requests
import mysql.connector
import re
from datetime import datetime, time as dt_time
import time  # Import necessário para o sleep

# Token de autenticação da API do Pipefy
PIPEFY_API_TOKEN = 'eyJhbGciOiJIUzUxMiJ9.eyJpc3MiOiJQaXBlZnkiLCJpYXQiOjE3MjcxMjA2MTYsImp0aSI6ImQwNjU2YzM1LWVlZmUtNDU0My1hMTEzLTI5YjRjMTBjZjJlOCIsInN1YiI6MzA1MTI4Mjk4LCJ1c2VyIjp7ImlkIjozMDUxMjgyOTgsImVtYWlsIjoibWFyY29zLmZldUBzcHRlY2guc2Nob29sIn19.MQc2LOxS9woi6UPCTjql5bkXff4Lw-iT3T4Kahb1LnViV3JoAZQFRdaXprWNe7ok4ttkrJUQZvlCuXSe26mafA'

# Cabeçalhos de autorização para acessar a API do Pipefy
headers = {
    'Authorization': f'Bearer {PIPEFY_API_TOKEN}'
}

# Função para buscar leads do Pipefy
def get_leads_from_pipefy(pipe_id):
    url = "https://api.pipefy.com/graphql"
    query = """
    {
        pipe(id: %d) {
            phases {
                name
                cards {
                    edges {
                        node {
                            id
                            title
                            created_at
                            fields {
                                name
                                value
                            }
                        }
                    }
                }
            }
        }
    }
    """ % pipe_id

    response = requests.post(url, json={'query': query}, headers=headers)

    try:
        data = response.json()

        # Verifica se há erros na resposta
        if 'errors' in data:
            print(f"Erros retornados pela API do Pipefy: {data['errors']}")
            return []

        # Verifica se a chave 'data' está presente na resposta
        if 'data' in data and 'pipe' in data['data']:
            return data['data']['pipe']['phases']
        else:
            print("A resposta não contém os dados esperados:", data)
            return []

    except ValueError:
        print(f"Erro ao processar a resposta JSON. Resposta recebida: {response.text}")
        return []

def clean_telefone(telefone):
    # Remove todos os caracteres que não sejam numéricos
    return re.sub(r'\D', '', telefone)

def validate_data(dt_nasc):
    # Verifica se a data é 'N/A' ou está vazia
    if dt_nasc in ['N/A', None, '']:
        return None

    # Tenta converter a data em vários formatos
    for date_format in ("%d-%m-%Y", "%d/%m/%Y", "%m/%d/%Y"):
        try:
            return datetime.strptime(dt_nasc, date_format).strftime("%Y-%m-%d")
        except ValueError:
            continue
    
    # Retorna None se nenhum formato foi válido
    return None
    

def lead_exists(cpf):
    """Verifica se um lead com o CPF já existe no banco de dados."""
    conn = mysql.connector.connect(
        host="localhost",
        user="root",
        password="sptech",  # Altere para sua senha
        database="multiclinics"
    )
    
    cursor = conn.cursor()
    
    # Consulta para verificar se o CPF já existe
    select_query = "SELECT COUNT(*) FROM possivel_cliente WHERE cpf = %s"
    cursor.execute(select_query, (cpf,))
    result = cursor.fetchone()
    
    cursor.close()
    conn.close()

    # Se o resultado for maior que 0, o lead já existe
    return result[0] > 0

def insert_lead_into_mysql(nome, sobrenome, email, cpf, telefone, dt_nasc, tipo_de_contato, fase):
    cpf = cpf[:14]  # Trunca o CPF para no máximo 14 caracteres
    telefone = clean_telefone(telefone)[:15]  # Limpa e trunca o telefone para no máximo 15 caracteres
    
    # Valida a data de nascimento
    dt_nasc = validate_data(dt_nasc)

    # Verifica se o lead já existe
    if lead_exists(cpf):
        print(f"Lead com CPF {cpf} já existe. Não será inserido novamente.")
        return

    # Conecta ao banco de dados
    conn = mysql.connector.connect(
        host="localhost",
        user="root",
        password="sptech",  # Altere para sua senha
        database="multiclinics"
    )

    cursor = conn.cursor()

    # SQL para inserir os dados no MySQL
    insert_query = """
    INSERT INTO possivel_cliente (nome, sobrenome, email, cpf, telefone, dt_nasc, tipo_de_contato, fase)
    VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
    """
    
    # Executa a inserção dos dados
    cursor.execute(insert_query, (nome, sobrenome, email, cpf, telefone, dt_nasc, tipo_de_contato, fase))
    conn.commit()
    
    print(f"Lead {nome} {sobrenome} inserido com sucesso no banco de dados.")
    
    cursor.close()
    conn.close()

# Função principal para sincronizar leads do Pipefy com o MySQL
def sync_pipefy_leads_to_mysql(pipe_id):
    phases = get_leads_from_pipefy(pipe_id)
    
    for phase in phases:
        fase = phase['name']  # Define a fase atual
        print(f"Fase: {fase}")
        for card_edge in phase['cards']['edges']:
            card = card_edge['node']
            fields = {field['name']: field['value'] for field in card['fields']}
            
            nome = fields.get('Nome', 'N/A')
            sobrenome = fields.get('Sobrenome', 'N/A')
            email = fields.get('Email', 'N/A')
            cpf = fields.get('CPF', 'N/A')
            telefone = fields.get('Telefone', 'N/A')
            dt_nasc = fields.get('Date', 'N/A')
            tipo_de_contato = 1  # Supondo que seja sempre "Inicial"

            # Insere ou atualiza o lead no MySQL com a fase
            insert_lead_into_mysql(nome, sobrenome, email, cpf, telefone, dt_nasc, tipo_de_contato, fase)

# Sincronizar leads de tempos em tempos (Exemplo: 5 horas)
while True:
    sync_pipefy_leads_to_mysql(304633201)  # ID do pipeline
    print("Sincronização completa. Aguardando 5 horas para a próxima execução...")
    time.sleep(5 * 60 * 60)  # Pausa por 5 horas
