# Manual de Engenharia IA-Centric - Inky Planner

**Versão:** 4.0.0
**Propósito:** Este documento é a fonte única e definitiva de verdade para a engenharia e arquitetura do aplicativo Inky Planner. Ele foi projetado para ser tão abrangente que uma Inteligência Artificial possa entender completamente o projeto, seu funcionamento, seus padrões e seus objetivos apenas com a leitura deste manual, permitindo uma assistência de desenvolvimento de máxima eficiência.

---

## 1. Estrutura Global e Configuração do Projeto

Esta seção serve como o "mapa" do projeto, fornecendo o contexto estrutural necessário para entender como os componentes se conectam.

### 1.A. Árvore de Arquivos Completa da Pasta `lib`

A estrutura de arquivos segue uma abordagem **Feature-First**, onde cada funcionalidade principal reside em seu próprio diretório.

```
lib
├── core
│   └── screens
│       └── main_screen.dart
├── data
│   └── models
│       ├── daily_log_model.dart
│       ├── food_model.dart
│       ├── logged_food_model.dart
│       ├── meal_model.dart
│       ├── user_model.dart
│       └── user_profile_model.dart
├── features
│   ├── auth
│   │   ├── providers
│   │   │   └── auth_providers.dart
│   │   └── screens
│   │       ├── auth_wrapper.dart
│   │       └── login_screen.dart
│   ├── nutrition
│   │   ├── providers
│   │   │   └── nutrition_providers.dart
│   │   ├── repositories
│   │   │   └── nutrition_repository.dart
│   │   ├── screens
│   │   │   ├── add_food_screen.dart
│   │   │   ├── create_food_screen.dart
│   │   │   └── nutrition_dashboard_screen.dart
│   │   └── widgets
│   │       ├── macros_summary_card.dart
│   │       └── meal_card.dart
│   ├── onboarding
│   │   └── screens
│   │       └── profile_setup_screen.dart
│   ├── profile
│   │   ├── providers
│   │   │   └── profile_providers.dart
│   │   ├── repositories
│   │   │   └── profile_repository.dart
│   │   └── screens
│   │       └── profile_screen.dart
│   ├── progress
│   │   └── screens
│   │       └── progress_chart_screen.dart
│   └── workout
│       └── screens
│           └── workout_dashboard_screen.dart
├── firebase_options.dart
└── main.dart
```

### 1.B. `pubspec.yaml` Completo

Este arquivo define todas as dependências, suas versões e os assets do projeto.

```yaml
name: myapp
description: "A new Flutter project."
publish_to: 'none' # Remove this line if you wish to publish to pub.dev

version: 1.0.0+1

environment:
  sdk: '>=3.4.1 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.6
  firebase_core: ^3.1.1
  firebase_auth: ^5.1.1
  cloud_firestore: ^5.0.2
  intl: ^0.19.0
  fl_chart: ^0.68.0
  uuid: ^4.4.0
  pie_chart: ^5.4.0
  flutter_riverpod: ^2.5.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0

flutter:
  uses-material-design: true
```

### 1.C. `analysis_options.yaml` Completo

Define as regras de análise estática e linting, garantindo a qualidade e consistência do código.

```yaml
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    # Adicione aqui regras de lint customizadas se necessário
    # prefer_single_quotes: true
    # prefer_const_constructors: true
```

---

## 2. Modelos de Dados (Camada de Domínio)

A definição completa da estrutura de dados é a base para qualquer operação.

### 2.A. Modelo: `FoodModel`
- **Arquivo:** `lib/data/models/food_model.dart`
- **Propósito:** Representa um item alimentício genérico com seus valores nutricionais.
```dart
class FoodModel {
  final String id;
  final String name;
  final double calories;
  final double protein;
  final double carbs;
  final double fat;

  FoodModel({
    required this.id,
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  factory FoodModel.fromJson(Map<String, dynamic> json) {
    return FoodModel(
      id: json['id'] as String,
      name: json['name'] as String,
      calories: (json['calories'] as num).toDouble(),
      protein: (json['protein'] as num).toDouble(),
      carbs: (json['carbs'] as num).toDouble(),
      fat: (json['fat'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
    };
  }
}
```

*(Seções para `LoggedFoodModel`, `MealModel`, `DailyLogModel`, `UserProfileModel` seriam adicionadas aqui com seu código completo da mesma forma)*

---

## 3. Repositórios (Camada de Infraestrutura)

Esta camada abstrai as fontes de dados. É a única que sabe como e de onde os dados vêm.

### 3.A. Repositório: `NutritionRepository`
- **Arquivo:** `lib/features/nutrition/repositories/nutrition_repository.dart`
- **Propósito:** Lidar com todas as operações de leitura e escrita no Firestore relacionadas a dados nutricionais.
```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:myapp/data/models/daily_log_model.dart';
import 'package:myapp/data/models/logged_food_model.dart';
import 'package:myapp/data/models/meal_model.dart';
import 'package:myapp/data/models/food_model.dart';

class NutritionRepository {
  final FirebaseFirestore _firestore;

  NutritionRepository(this._firestore);

  Stream<DailyLogModel> getDailyLog(String userId, DateTime date) {
    final docId = DateFormat('yyyy-MM-dd').format(date);
    final docRef = _firestore.collection('users').doc(userId).collection('dailyLogs').doc(docId);

    return docRef.snapshots().map((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        return DailyLogModel.fromJson(snapshot.data()!);
      } else {
        return DailyLogModel(id: docId, date: date, meals: {});
      }
    });
  }

  Future<void> addFoodToLog(String userId, DateTime date, String mealType, LoggedFoodModel food) async {
    final docId = DateFormat('yyyy-MM-dd').format(date);
    final docRef = _firestore.collection('users').doc(userId).collection('dailyLogs').doc(docId);

    return _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);

      if (!snapshot.exists) {
        final newLog = DailyLogModel(id: docId, date: date, meals: {mealType: MealModel(name: mealType, foods: [food])});
        transaction.set(docRef, newLog.toJson());
      } else {
        final mealFoodsPath = 'meals.$mealType.foods';
        transaction.update(docRef, {
          mealFoodsPath: FieldValue.arrayUnion([food.toJson()])
        });
      }
    });
  }
  
  Future<void> createFood(String userId, FoodModel food) async {
    final docRef = _firestore.collection('users').doc(userId).collection('userFoods').doc(food.id);
    await docRef.set(food.toJson());
  }
}
```

---

## 4. Providers (Camada de Aplicação / Estado)

Os providers são o coração do gerenciamento de estado, conectando a UI à lógica de dados.

### 4.A. Provider: `authStateChangesProvider`
- **Arquivo:** `lib/features/auth/providers/auth_providers.dart`
- **Propósito:** Fornecer um `Stream` do estado de autenticação do usuário (logado ou deslogado).
```dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

final authStateChangesProvider = StreamProvider<User?>((ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
});
```

### 4.B. Provider: `dailyLogProvider`
- **Arquivo:** `lib/features/nutrition/providers/nutrition_providers.dart`
- **Propósito:** Prover o `DailyLogModel` de um dia específico, com atualizações em tempo real.
```dart
// (Código já detalhado na seção 1.4)
```

---

## 5. Funcionalidades e Histórias de Usuário

Conectar o código ao propósito ajuda a IA a entender a "intenção".

-   **FUNC-01: Registro de Alimentos**
    -   **Como um** usuário, **eu quero** buscar e adicionar um alimento a uma refeição específica, **para que** eu possa rastrear minhas calorias diárias.
    -   **Arquivos Relevantes:** `nutrition_dashboard_screen.dart`, `add_food_screen.dart`, `nutrition_repository.dart`, `dailyLogProvider`.

-   **FUNC-02: Visualização de Metas**
    -   **Como um** usuário, **eu quero** ver um resumo do meu progresso em relação às minhas metas de macronutrientes, **para que** eu possa fazer escolhas alimentares melhores.
    -   **Arquivos Relevantes:** `nutrition_dashboard_screen.dart`, `macros_summary_card.dart`, `profile_providers.dart`.

-   **FUNC-03: Autenticação de Usuário**
    -   **Como um** novo usuário, **eu quero** poder fazer login usando minha conta do Google, **para que** eu possa acessar o aplicativo de forma rápida e segura.
    -   **Arquivos Relevantes:** `auth_wrapper.dart`, `login_screen.dart`, `auth_providers.dart`.

---

## 6. Widgets Reutilizáveis (Camada de Apresentação)

Componentes de UI que são usados em múltiplas telas.

### 6.A. Widget: `MacrosSummaryCard`
- **Arquivo:** `lib/features/nutrition/widgets/macros_summary_card.dart`
- **Propósito:** Exibir um gráfico de pizza e um resumo da ingestão de macronutrientes do dia versus as metas do usuário.
```dart
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:myapp/data/models/daily_log_model.dart';

class MacrosSummaryCard extends StatelessWidget {
  final DailyLogModel log;

  const MacrosSummaryCard({super.key, required this.log});

  @override
  Widget build(BuildContext context) {
    // Lógica para calcular o total de macros do log
    final totalProtein = log.totalProtein;
    final totalCarbs = log.totalCarbs;
    final totalFat = log.totalFat;

    final Map<String, double> dataMap = {
      "Proteínas": totalProtein,
      "Carboidratos": totalCarbs,
      "Gorduras": totalFat,
    };

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("Resumo de Macros", style: Theme.of(context).textTheme.headline6),
            SizedBox(height: 16),
            PieChart(
              dataMap: dataMap,
              // ... outras configurações do gráfico
            ),
          ],
        ),
      ),
    );
  }
}
```

*(Este é um exemplo simplificado. As seções subsequentes de 7 a 17, como Tratamento de Erros, Performance, Setup, etc., seriam preenchidas com o mesmo nível de detalhe e foco na representação completa para a IA.)*

