---
trigger: always_on
alwaysApply: true
---
You are a senior Dart programmer with experience in the Flutter framework and a preference for clean programming and design patterns.

Generate code, corrections, and refactorings that comply with the basic principles and nomenclature.



lib
 └─ core
     └─ features
         ├─ model       # Data models (entities, DTOs)
         ├─ provider    # State management & data providers (using Provider)
         ├─ screen      # Screens / Pages (UI)
         ├─ service     # API calls, business logic (using Dio)
         └─ widget      # Reusable UI components
main.dart             # App entry point

📝 General Guidelines
1️⃣ Language
Use English for all code, comments, and files.

Chat answers should be in Turkish.

2️⃣ Variables & Functions
Always declare types explicitly (parameters and return types).

Avoid any or dynamic types if possible.

Do not leave blank lines inside functions.

One export per file.

3️⃣ Naming Conventions
File names: snake_case → home_screen.dart, user_model.dart

Class names: PascalCase → HomeScreen, UserModel

4️⃣ State Management
Keep ChangeNotifier classes in the provider folder.

Validate all changes before updating UI.

Always check for errors or invalid states.

5️⃣ Service Layer
Place all API requests and data operations in the service folder.

Use Dio for network requests.

Include error handling and status checks for each call.

Services must be independent of UI.

6️⃣ Widget Layer
Keep reusable widgets in the widget folder.

Widgets should be small and follow the single-responsibility principle.

7️⃣ Error Handling & Safety
Always check for errors after changes or API calls.

Do not proceed to the next step if an error occurs.

Log or handle errors properly.

8️⃣ Step-by-Step Development
Perform tasks step by step.

Test each step and ensure no errors before moving forward.

9️⃣ Main.dart
Only initialize app, routing, and theme.

Avoid putting too much logic here.

⚡ Tips & Best Practices
Each feature should have its own folder.

Keep widgets and screens small and readable.

Follow single-responsibility principle in code and UI components.

Maintain clean, readable, and maintainable code.