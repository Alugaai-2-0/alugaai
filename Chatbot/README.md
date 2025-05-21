# 🧠 Chatbot Backend (DialoGPT + Flask)

A simple Python backend using the DialoGPT-medium model to generate chatbot responses. This exposes an API via Flask that can be consumed by any frontend application, such as a Flutter app.

![Flask](https://img.shields.io/badge/Flask-000000?style=for-the-badge&logo=flask&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![Hugging Face](https://img.shields.io/badge/Hugging%20Face-FF9A00?style=for-the-badge&logo=huggingface&logoColor=white)

## ✨ Features

- Natural language processing using Microsoft's DialoGPT model
- Fallback to predefined responses when the model is unavailable
- Topic-based knowledge base for common questions
- Simple REST API for integration with any frontend
- Cross-Origin Resource Sharing (CORS) support

## 🛠️ Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/Alugaai-2-0/alugaai.git
   cd chatbot
   ```

2. Install the required dependencies:
   ```bash
   pip install flask transformers torch flask-cors
   ```

## ▶️ Running the Server

Start the server with:

```bash
py botServerBackend.py
```

The server will be available at `http://0.0.0.0:5000` and will accept connections from any device on your network.

## 📡 API Reference

### Send Message to Chatbot

```
POST /chat
```

**Description**: Sends a message to the chatbot and receives a generated response.

**URL**: `http://localhost:5000/chat`

**Method**: `POST`

**Headers**:
```
Content-Type: application/json
```

**Request Body**:
```json
{
  "message": "Olá, tudo bem?"
}
```

**Success Response**:
```json
{
  "reply": "Olá! Eu sou o assistente virtual da Alugaai. Estou aqui para te ajudar a encontrar a moradia ideal. Como posso ajudar?"
}
```

## 🔌 Connecting with Flutter

To connect your Flutter app to this backend:

1. Make sure to use the correct IP address:
   - For Android Emulator: `10.0.2.2:5000`
   - For iOS Simulator: `127.0.0.1:5000`
   - For Physical Devices: Your computer's actual local IP (e.g., `192.168.1.xxx:5000`)

2. Set up proper error handling for network requests

3. Use the appropriate endpoint to send and receive messages

## 🧩 Architecture

The backend consists of:

- A Flask server that handles HTTP requests
- DialoGPT integration for AI-powered responses
- Predefined knowledge base for common questions
- Intent recognition system based on keywords

## 📝 License

[MIT](LICENSE)

---

Made with ❤️ for Alugaai
