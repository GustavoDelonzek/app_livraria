# 📚 Livraria App

Aplicativo mobile de uma livraria desenvolvido em Flutter, com arquitetura limpa e uso de Provider para gerenciamento de estado. Permite aos usuários explorarem livros, visualizar detalhes, adicionar ao carrinho, realizar pedidos, avaliar livros, seguir perfis e muito mais.

## 🛠️ Tecnologias Utilizadas

- **Flutter**
- **Dart**
- **Firebase Authentication**
- **Cloud Firestore**
- **Provider (Gerenciamento de estado)**
- **Arquitetura Limpa (MVVM)**

## ✨ Funcionalidades

- Autenticação de usuários (login e registro)
- Exploração de livros populares e novos
- Tela de detalhes com imagem, descrição e botão de compra
- Carrinho com controle de quantidade e persistência
- Sistema de pedidos integrado com Firebase
- Avaliações e comentários de livros por usuários autenticados
- Tela de perfil com funcionalidades sociais (seguidores, curtidas)
- Pesquisa por livros e usuários
- UI amigável e responsiva com design moderno

## 📦 Estrutura de Pastas

```bash
lib/
├── main.dart
├── app.dart                      # Configurações globais: tema, rotas
├── core/
│   ├── theme/                    # Temas e estilos
│   ├── services/                 # Firebase, API e integrações
│   ├── widgets/                  # Componentes reutilizáveis (AppHeader, Footer etc.)
├── models/                       # Modelos como Book, User, Review
├── providers/                   # Providers para autenticação, carrinho, reviews etc.
├── views/
│   ├── home/
│   ├── login/
│   ├── register/
│   ├── book_details/
│   ├── cart/
│   ├── profile/
├── utils/                        # Funções e helpers diversos
```

## 🚀 Como Rodar o Projeto

### 1. Clone o repositório

```bash
git clone https://github.com/seu-usuario/livraria-app.git
cd livraria-app
```

### 2. Instale as dependências do Flutter

```bash
flutter pub get
```

### 3. Configure o Firebase

- Crie um projeto no [Firebase Console](https://console.firebase.google.com/)
- Habilite a autenticação por e-mail/senha
- Crie o Firestore Database em modo de teste

### 4. Configure o Proxy Local para CORS

Este projeto utiliza um pequeno servidor Node.js como proxy para contornar restrições de CORS ao acessar APIs públicas.

#### Instalação:

```bash
cd cors-proxy
npm install
```

#### Executar o proxy:

```bash
node index.js
```

#### Configure o arquivo `.env`:

Crie um arquivo `.env` dentro da pasta `assets` com o seguinte conteúdo:

```env
FIREBASE_API_KEY=
FIREBASE_APP_ID=
FIREBASE_PROJECT_ID=
FIREBASE_MESSAGING_SENDER_ID=
FIREBASE_STORAGE_BUCKET=


GOOGLE_BOOKS_API_KEY=
```


### 5. Execute o aplicativo Flutter

De volta à raiz do projeto:

```bash
flutter run
```



## 👨‍💻 Autor

- Gustavo — [@GustavoDelonzek](https://github.com/gustavodelonzek)

---

© 2025 — Projeto acadêmico de uma Livraria Mobile.