
# Blueprint: Flutter Firebase App

## Visão Geral

Este é um aplicativo Flutter integrado com os serviços do Firebase. O objetivo é criar uma base sólida para um aplicativo que requer autenticação de usuário e um banco de dados em tempo real.

## Recursos e Design Implementados

- **Configuração do Firebase:**
  - O projeto está configurado para Android e Web.
  - As dependências do Firebase Core (`firebase_core`) foram adicionadas.
  - O aplicativo inicializa o Firebase no `main.dart`.
  - O arquivo `firebase_options.dart` foi gerado para conectar o aplicativo ao projeto Firebase.

## Plano de Desenvolvimento Atual

### Tarefa: Implementar Autenticação e Banco de Dados

**1. Adicionar Dependências:**
   - [x] Adicionar `firebase_auth` para autenticação.
   - [x] Adicionar `cloud_firestore` para o banco de dados NoSQL.
   - [ ] Adicionar `provider` para gerenciamento de estado.

**2. Estrutura de Autenticação:**
   - Criar uma tela de login com campos para e-mail e senha.
   - Implementar a lógica para registrar novos usuários.
   - Implementar a lógica para login de usuários existentes.
   - Criar um "portão de autenticação" (`AuthGate`) que direcione o usuário para a tela de login ou para a tela principal, dependendo do seu estado de autenticação.
   - Implementar a funcionalidade de logout.

**3. Integração com o Cloud Firestore:**
   - Criar uma tela principal (`HomeScreen`) visível apenas para usuários autenticados.
   - Nesta tela, exibir uma lista de itens de uma coleção do Firestore em tempo real.
   - Adicionar um botão para permitir que os usuários insiram novos itens no banco de dados.

**4. Interface do Usuário:**
   - Desenvolver uma interface de usuário limpa e funcional para as telas de login e principal.
   - Usar `StreamBuilder` para exibir os dados do Firestore de forma reativa.
