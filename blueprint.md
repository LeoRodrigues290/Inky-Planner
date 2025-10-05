# Blueprint: Aplicativo de Nutrição e Treino

Este documento é um guia técnico para a construção de um aplicativo de gerenciamento de nutrição e treinos utilizando o framework Flutter e os serviços do Firebase como backend.

## 1. Visão Geral da Arquitetura

*   **Arquitetura:** Baseada em Features com separação de camadas (UI, Lógica de Negócios/Providers, Repositórios).
*   **Gerenciamento de Estado:** `flutter_riverpod` para injeção de dependências e gerenciamento de estado reativo.
*   **Backend:** Firebase (Authentication, Firestore).

## 2. Estrutura do Projeto (Pastas em `lib/`)

*   **`core/`**: Widgets compartilhados (ex: `CustomBottomNavBar`), constantes e utilitários.
*   **`data/`**: Modelos de dados (ex: `user_model.dart`, `food_model.dart`, `workout_model.dart`).
*   **`features/`**: Cada funcionalidade principal do app em sua própria pasta.
    *   **`auth/`**: Telas de login/cadastro, providers e repositórios de autenticação.
    *   **`onboarding/`**: Telas de configuração inicial do perfil do usuário.
    *   **`nutrition/`**: Telas, providers e repositórios para o tracking de nutrição.
    *   **`workout/`**: Telas, providers e repositórios para o tracking de treinos.
    *   **`progress/`**: Telas e providers para visualização de gráficos de progresso.
    *   **`profile/`**: Tela de perfil do usuário, gerenciamento de bibliotecas e configurações.
*   **`main.dart`**: Ponto de entrada do aplicativo.

---

## 3. Plano de Implementação Detalhado

### Passo 1: Configuração Inicial e Onboarding (Concluído)

*   [x] **Autenticação:**
    *   [x] Telas de Login e Cadastro (`LoginScreen`, `RegisterScreen`).
    *   [x] `AuthRepository` e providers para gerenciar o estado do usuário (`authStateChangesProvider`).
    *   [x] `AuthWrapper` para direcionar o usuário (tela de login ou tela principal).
*   [ ] **Onboarding do Perfil:**
    *   [ ] **Model:** Criar `UserProfile` model em `data/models/user_profile_model.dart` para armazenar metas, nome e avatar.
    *   [ ] **Tela:** Criar `ProfileSetupScreen` em `features/onboarding/screens/`.
    *   [ ] **Lógica:**
        *   Após o primeiro login, o `AuthWrapper` verificará se o perfil do usuário no Firestore está completo.
        *   Se não estiver, o usuário será direcionado para a `ProfileSetupScreen`.
        *   Nesta tela, o usuário definirá suas metas diárias (calorias, macros) e informações de perfil (nome, avatar).
        *   Ao salvar, as informações são gravadas em um documento no Firestore e o usuário é levado à tela principal.

### Passo 2: Navegação Principal (A Fazer)

*   [ ] **Widget de Navegação:**
    *   [ ] Criar um widget `MainScreen` que conterá uma `BottomNavigationBar`.
    *   [ ] A barra de navegação terá 4 abas: "Hoje" (`NutritionDashboardScreen`), "Treino" (`WorkoutDashboardScreen`), "Progresso" (`ProgressChartScreen`), e "Perfil" (`ProfileScreen`).
*   [ ] **Telas Placeholder:**
    *   [ ] Criar arquivos iniciais para `WorkoutDashboardScreen`, `ProgressChartScreen`, e `ProfileScreen` como placeholders.

### Passo 3: Feature de Nutrição (Concluído)

*   [x] **Modelos:** `Food`, `DailyLog`, `Meal`, `LoggedFood`.
*   [x] **Repositório:** `NutritionRepository` para interagir com o Firestore (buscar/salvar logs diários, buscar/criar alimentos).
*   [x] **Providers:** `nutritionRepositoryProvider`, `dailyLogProvider`, `foodSearchProvider`.
*   [x] **Telas:**
    *   [x] `NutritionDashboardScreen`: Exibe o resumo diário, macros e a lista de refeições.
    *   [x] `AddFoodScreen`: Tela para buscar e adicionar alimentos a uma refeição.
    *   [x] `CreateFoodScreen`: Formulário para criar um novo alimento na biblioteca do usuário.

### Passo 4: Feature de Treino (A Fazer)

*   [ ] **Modelos:**
    *   [ ] `Exercise`: Modelo para um exercício (ex: nome, tipo).
    *   [ ] `WorkoutSet`: Modelo para uma série de um exercício (ex: peso, reps).
    *   [ ] `WorkoutLog`: Modelo para um treino completo (ex: nome, data, lista de exercícios com suas séries).
*   [ ] **Repositório:** `WorkoutRepository` para salvar e buscar treinos e exercícios no Firestore.
*   [ ] **Providers:**
    *   [ ] `workoutHistoryProvider`: Fornece o histórico de treinos.
    *   [ ] `activeWorkoutProvider`: Gerencia o estado de um treino em andamento.
*   [ ] **Telas:**
    *   [ ] `WorkoutDashboardScreen`: Exibe a lista de treinos realizados. Um FAB inicia um novo treino.
    *   [ ] `ActiveWorkoutScreen`: Tela para registrar um treino em tempo real. Inclui cronômetro, adição de exercícios e séries.
    *   [ ] `AddExerciseScreen`: Tela de busca para selecionar exercícios da biblioteca do usuário.

### Passo 5: Feature de Progresso (A Fazer)

*   [ ] **Provider:**
    *   [ ] `exerciseProgressProvider`: Um `FutureProvider.family` que buscará o histórico de um exercício específico para o gráfico.
*   [ ] **Tela:** `ProgressChartScreen`
    *   [ ] Um `DropdownButton` para selecionar o exercício.
    *   [ ] Um gráfico de linhas (`fl_chart`) para visualizar a progressão de carga (maior peso levantado por data).

### Passo 6: Feature de Perfil (A Fazer)

*   [ ] **Tela:** `ProfileScreen`
    *   [ ] Exibirá o nome e avatar do usuário.
    *   [ ] Opções em lista:
        *   "Minhas Metas": Navega para uma tela para editar as metas.
        *   "Minha Biblioteca de Alimentos": Gerenciamento dos alimentos criados.
        *   "Minha Biblioteca de Exercícios": Gerenciamento dos exercícios criados.
        *   "Sair": Executa o logout.
