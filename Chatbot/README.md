🧠 Chatbot Backend (DialoGPT + Flask)
Este é um backend simples em Python que utiliza o modelo DialoGPT-medium para gerar respostas de um chatbot. Ele expõe uma API via Flask que pode ser consumida por qualquer frontend, como um app Flutter.

▶️ Como Rodar
1. Instale as dependências
pip install flask transformers torch
2. Execute o servidor
python app.py
📡 Endpoints da API
POST /chat
Descrição: Envia uma mensagem para o chatbot e recebe uma resposta gerada.

URL: http://localhost:5000/chat
Método: POST
Headers:
Content-Type: application/json
Body (exemplo):
{
  "message": "Olá, tudo bem?"
}
Resposta:
{
  "reply": "Olá, tudo bem? Como posso te ajudar hoje?"
}