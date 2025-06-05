"""
Código do Chatbot para a plataforma Alugaai

Este programa implementa um chatbot utilizando Flask para criar uma API REST
que recebe perguntas dos usuários e retorna respostas relacionadas à plataforma Alugaai,
um serviço que conecta estudantes buscando moradia compartilhada.
"""

# Importação das bibliotecas necessárias
from flask import Flask, request, jsonify  # Framework web para criar a API
from transformers import pipeline  # Biblioteca para modelos de IA de processamento de linguagem natural
from flask_cors import CORS  # Extensão para lidar com Cross-Origin Resource Sharing
import random  # Para selecionar respostas aleatórias do banco de conhecimento

# Inicialização da aplicação Flask
app = Flask(__name__)
CORS(app)  # Habilita CORS para permitir requisições de diferentes origens

# Tenta carregar o modelo de linguagem DialoGPT para geração de texto
try:
    modelo_ia = pipeline("text-generation", model="microsoft/DialoGPT-medium")
except Exception as e:
    print(f"Aviso: Não foi possível carregar o modelo DialoGPT ({e}). O chatbot funcionará apenas com respostas pré-definidas.")
    modelo_ia = None

# Base de conhecimento: dicionário contendo categorias de intenção e respostas pré-definidas
base_conhecimento = {
    "boas_vindas": [
        "Olá! Eu sou o assistente virtual da Alugaai. Estou aqui para te ajudar a encontrar a moradia ideal. Como posso ajudar?",
        "Bem-vindo ao Alugaai! Sou seu assistente virtual. Está procurando um lugar para morar ou deseja cadastrar uma propriedade?",
        "Oi! Sou o bot do Alugaai. Vamos encontrar a acomodação perfeita pra você?"
    ],
    
    "cadastro": [
        "Para se cadastrar, clique no botão 'Criar conta' na tela inicial. Você precisará informar seus dados pessoais, incluindo CPF para verificação, e selecionar a universidade de interesse.",
    ],

    # Outras categorias com respostas específicas para cada tópico da plataforma
    "busca_estudantes": [
        "No feed principal, você verá perfis de estudantes interessados na mesma universidade. Deslize para direita para demonstrar interesse ou para esquerda para passar.",
    ],

    "mapa": [
        "O mapa exibe universidades e propriedades disponíveis. Clique em uma universidade para ver estudantes interessados nela ou em uma propriedade para ver detalhes.",
    ],

    "filtros_feed": [
        "Acesse as configurações de filtro no feed, selecione 'Curso' e escolha a opção desejada. Você também pode filtrar por idade, interesses e preferências de moradia.",
    ],

    "conexoes": [
        "Quando duas pessoas se conectam, abrimos um chat privado para vocês conversarem sobre possibilidades de moradia compartilhada.",
    ],

    "seguranca": [
        "Todos os usuários passam por verificação de CPF. Também temos um sistema de avaliações e recomendamos encontros iniciais em locais públicos.",
    ],

    "proprietarios": [
        "Quando um estudante se interessa pelo seu imóvel, você recebe uma notificação e pode iniciar uma conversa pelo chat da plataforma.",
    ],
    
    "travamento": [
        "Primeiro, tente fechar e abrir novamente o aplicativo. Se o problema persistir, vá em 'Configurações > Suporte > Relatar problema' para enviar um relatório detalhado.",
    ],

    "problemas": [
        "Se estiver enfrentando problemas com o app, tente reiniciar. Caso continue, entre em contato pelo e-mail suporte@alugaai.com.",
        "Você pode relatar qualquer erro ou bug diretamente pelo menu 'Ajuda' no app.",
        "Problemas técnicos? Estamos aqui para ajudar! Acesse o suporte no aplicativo ou envie um e-mail para nossa equipe."
    ],

    "generico": [
        "Desculpe, não entendi sua pergunta. Pode reformular ou acessar o menu de ajuda no   app?",
        "Ainda estou aprendendo! Tente perguntar de outra forma ou fale com nosso suporte pelo app.",
        "Essa informação talvez não esteja disponível no momento. Você pode tentar outra dúvida ou consultar o FAQ."
    ],
    
    "adeus": [
        "Tchau! Qualquer dúvida, estarei aqui para ajudar!",
        "Até logo! Se precisar de mais alguma coisa, é só chamar.",
        "Fico feliz em ajudar! Volte sempre que precisar."
    ],
}

# Dicionário que mapeia palavras-chave às categorias de intenção (EXPANDIDO)
palavras_chave = {
    "boas_vindas": [
        "olá", "oi", "ola", "bom dia", "boa tarde", "boa noite", "começar", "início", "e aí", "eae", "salve", 
        "opa", "olaa", "oii", "bom diia", "boa tardee", "boa noit", "gostaria de começar", "ajuda inicial",
        "como posso comecar", "oal", "obm dia", "oe"
    ],
    "cadastro": [
        "cadastro", "cadastrar", "criar conta", "registro", "perfil", "registrar", "inscrição", "nova conta", 
        "abrir conta", "meu perfil", "criar meu perfil", "como me cadastro", "quero me cadastrar", "fazer cadastro",
        "cadatro", "cadastr", "criat conta", "rejistro", "inscrever", "inscricao", "cadastra", "conta nova"
    ],
    "busca_estudantes": [
        "compatíveis", "colegas", "moradia", "compartilhada", "perfil", "estudantes", "encontrar colegas", 
        "achar estudantes", "procurar estudantes", "buscar colegas", "roommate", "roomate", "quem mora perto", 
        "dividir ap", "dividir apartamento", "achar gente", "perfis de estudantes", "match", "dar match",
        "compatveis", "coelgas", "estudntes", "estudates", "mordia", "estudante", "procurar alguem", "alguem para dividir",
        "compativel", "colega de quarto", "colega"
    ],
    "mapa": [
        "mapa", "localização", "proximidade", "visualizar imóveis", "ver imóveis", "ver no mapa", "onde fica", 
        "local", "endereço", "universidades no mapa", "imóveis no mapa", "map", "loalizacao", "proximdade",
        "como usar o mapa", "mostrar mapa", "mapa da cidade", "localisacao", "imoveis proximos"
    ],
    "filtros_feed": [
        "filtros", "feed", "buscar imóveis", "preferências", "refinar busca", "apenas", "meu curso", "filtrar", 
        "refinar", "selecionar curso", "idade", "interesses", "preferencias de moradia", "configurar feed", 
        "ajustar busca", "procurar por curso", "filtos", "fidi", "preferensia", "buscar imoveis", "filtar", 
        "preferencia", "filtrar por", "buscar por", "configuracoes de busca", "configurações de busca"
    ],
    "conexoes": [
        "conexões", "interação", "solicitação", "mensagem", "contato", "chat", "matches", "combinacoes", 
        "conversar", "enviar mensagem", "chamar no chat", "minhas conexões", "quem curtiu meu perfil",
        "conexes", "conexoes", "mensagm", "contato", "cmg", "msg", "solicitacao", "combinacao", "conversas",
        "bate papo", "bate-papo"
    ],
    "seguranca": [
        "segurança", "verificação", "seguro", "confiança", "perfil verificado", "confiaveis", "confiável", 
        "é seguro?", "confiável?", "verificação de cpf", "denunciar", "privacidade", "meus dados", "proteger conta",
        "é confiavel", "seguranca", "verificacao", "confiavel", "seguroo", "privacdade", "denuncia", "cpf",
        "verificar cpf", "confianca"
    ],
    "proprietarios": [
        "proprietário", "anunciar", "cadastrar imóvel", "colocar imóvel", "taxa", "divulgação", "interessados", 
        "imóvel", "alugar", "anunciar meu imóvel", "tenho um imóvel", "alugar meu ap", "como anunciar", 
        "taxas para anunciar", "colocar para alugar", "aluguel", "locador", "propietario", "anunciar imovel", 
        "cadastrar imovel", "imovel", "alugar meu imovel", "meu imovel", "quero anunciar", "divulgar imovel",
        "proprietaria", "anuncio"
    ],
    "problemas": [
        "erro", "problema", "bug", "falha", "suporte", "ajuda", "deu pau", "não funciona", "aplicativo com defeito", 
        "app não abre", "preciso de ajuda", "contatar suporte", "falar com suporte", "prolema", "eror", "bgu", 
        "falha", "suprte", "nao funciona", "app com problema", "ajudem", "socorro", "defeito", "reportar problema",
        "tenho um problema", "to com problema"
    ],
    "travamento": [
        "travando", "travamento", "lagando", "lento", "app travou", "congelou", "não responde", "muito lento", 
        "aplicativo lento", "esta travando muito", "travandoo", "travamneto", "lagado", "lnto", "nao responde",
        "app lento", "aplicativo travado", "congelado"
    ],
    "generico": [ # Mantido mais genérico, pois é um fallback
        "não sei", "não entendi", "outra dúvida", "outra questão", "hmm", "poderia me ajudar com outra coisa", 
        "nao entendi", "nao sei", "duvida", "questao", "como assim"
    ],
    "adeus": [
        "tchau", "flw", "adeus", "até logo", "até mais", "obrigado", "obg", "vlw", "falou", "grato", "grata",
        "resolveu", "já resolveu", "era isso", "thau", "adeuz", "ate log", "ate mais", "brigado", "xau", "thanks"
    ]
}

def identificar_intencao(pergunta):
    """
    Identifica a intenção do usuário com base nas palavras-chave presentes na pergunta
    
    Args:
        pergunta (str): A pergunta do usuário
        
    Returns:
        str: A categoria de intenção identificada ou "generico" se nenhuma for encontrada
    """
    pergunta = pergunta.lower()  # Converte para minúsculas para facilitar a comparação

    # Verifica se alguma palavra-chave das categorias está presente na pergunta
    # Damos prioridade para intenções com mais palavras ou palavras mais longas primeiro para especificidade,
    # mas a estrutura atual com muitas palavras-chave distintas por intenção é razoável.
    # A ordem de checagem no dicionário `palavras_chave` pode influenciar se houver muita sobreposição.
    for categoria, termos in palavras_chave.items():
        for termo in termos:
            # Usar `\b` para encontrar palavras inteiras pode ser mais preciso,
            # mas para erros de digitação e variações, a substring pode ser mais flexível.
            # Ex: `\b` + termo + `\b`
            if termo in pergunta:
                return categoria

    # Se nenhuma palavra-chave for encontrada, retorna a categoria genérica
    return "generico"

def responder_pergunta(pergunta):
    """
    Gera uma resposta para a pergunta do usuário
    
    Args:
        pergunta (str): A pergunta do usuário
        
    Returns:
        str: A resposta gerada para a pergunta
    """
    # Identifica a intenção do usuário
    intencao = identificar_intencao(pergunta)

    # Se a intenção foi identificada e existe na base de conhecimento, retorna uma resposta dessa categoria
    if intencao and intencao in base_conhecimento:
        return random.choice(base_conhecimento[intencao])

    # Se o modelo de IA estiver disponível, tenta usar para gerar uma resposta
    if modelo_ia:
        try:
            # Ajuste no pad_token_id para evitar warnings, se o modelo precisar
            if modelo_ia.tokenizer.pad_token_id is None:
                modelo_ia.tokenizer.pad_token_id = modelo_ia.model.config.eos_token_id
            
            resposta_modelo = modelo_ia(pergunta, max_length=60, num_return_sequences=1, pad_token_id=modelo_ia.tokenizer.pad_token_id)
            # Verifica se a resposta gerada não é apenas um eco da pergunta ou muito curta/sem sentido
            texto_gerado = resposta_modelo[0]['generated_text']
            if len(texto_gerado.split()) > 3 and texto_gerado.lower() not in pergunta.lower(): # Evita eco simples
                 return texto_gerado
        except Exception as e:
            print(f"Erro ao gerar resposta com modelo_ia: {e}")
            pass # Continua para a resposta padrão

    # Resposta padrão caso nenhuma das opções acima funcione
    return random.choice(base_conhecimento["generico"]) # Alterado para usar a resposta genérica da base


# Define a rota da API para receber as mensagens do chat
@app.route('/chat', methods=['POST'])
def chat():
    """
    Endpoint da API que recebe as mensagens do usuário e retorna as respostas do chatbot
    
    Returns:
        JSON: A resposta do chatbot em formato JSON
    """
    # Extrai os dados da requisição
    data = request.get_json()
    if not data or "message" not in data:
        return jsonify({"error": "Requisição inválida. 'message' não encontrado."}), 400
        
    user_input = data.get("message", "")
    if not user_input.strip():
        return jsonify({"reply": random.choice(base_conhecimento["generico"])})


    # Tenta gerar uma resposta para a pergunta do usuário
    resposta = responder_pergunta(user_input)
    
    # A lógica de fallback para o modelo_ia já está dentro de responder_pergunta.
    # A resposta padrão também está lá.
    return jsonify({"reply": resposta})

# Ponto de entrada da aplicação
if __name__ == '__main__':
    # Inicia o servidor Flask
    app.run(host='0.0.0.0', port=5000, debug=True)  # Configuração para desenvolvimento