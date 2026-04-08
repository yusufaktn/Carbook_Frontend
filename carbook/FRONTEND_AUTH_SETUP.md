# Authentication System - Frontend Kurulum Kılavuzu

## 📦 Gerekli Flutter Paketleri

`pubspec.yaml` dosyasına aşağıdaki paketleri ekleyin:

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # Mevcut paketler...
  provider: ^6.1.1
  http: ^1.1.0
  google_fonts: ^6.1.0
  
  # YENİ: Authentication için gerekli paketler
  flutter_secure_storage: ^9.0.0  # Güvenli token storage
  jwt_decoder: ^2.0.1              # JWT token decode (opsiyonel)
```

Paketleri yükleyin:
```bash
cd frontend/carbook
flutter pub get
```

## 🔧 API Configuration

`lib/features/service/ApiService/Auth/auth_service.dart` dosyasında base URL'i güncelleyin:

```dart
static const String baseUrl = 'http://localhost:5291/api/Auth';
// Veya Android emulator için:
// static const String baseUrl = 'http://10.0.2.2:5291/api/Auth';
// Veya gerçek cihaz için:
// static const String baseUrl = 'http://YOUR_COMPUTER_IP:5291/api/Auth';
```

## 📁 Oluşturulan Dosyalar

### Model Layer:
```
lib/features/model/Auth/
├── login_request.dart        ✅ Email, password
├── login_response.dart       ✅ Token ve user bilgileri
├── register_request.dart     ✅ Kayıt bilgileri
├── register_response.dart    ✅ Kayıt sonucu
└── auth_token.dart          ✅ Token yönetimi
```

### Service Layer:
```
lib/features/service/
├── ApiService/Auth/
│   └── auth_service.dart     ✅ Login, Register, Refresh, Logout API
└── Storage/
    └── token_storage_service.dart  ✅ Secure token storage
```

### Provider Layer:
```
lib/features/provider/Auth/
└── auth_provider.dart        ✅ Authentication state management
```

### Screen Layer (Devam edecek):
```
lib/features/screen/
├── login_screen.dart         🚧 Login ekranı
└── register_screen.dart      🚧 Register ekranı
```

## 🔐 Secure Storage Notları

### Android
`android/app/src/main/AndroidManifest.xml` dosyasına ekleyin (zaten varsa gerek yok):

```xml
<manifest>
    <uses-permission android:name="android.permission.INTERNET"/>
</manifest>
```

### iOS
`ios/Podfile` dosyasında minimum iOS version'ı kontrol edin:

```ruby
platform :ios, '11.0'  # Minimum iOS 11
```

## 📱 Kullanım Örneği

### main.dart'a AuthProvider Ekleme

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CategoryProvider()),
        ChangeNotifierProvider(create: (context) => QuestionProvider()),
        ChangeNotifierProvider(create: (context) => AnswerProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => AuthProvider()),  // ✅ YENİ
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          // Initialize auth on app start
          authProvider.initializeAuth();
          
          return MaterialApp(
            title: 'CarBook',
            theme: AppTheme.lightTheme,
            // Home screen based on auth status
            home: authProvider.isAuthenticated 
                ? const HomeScreen() 
                : const LoginScreen(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
```

### Login Örneği

```dart
// In your widget:
final authProvider = Provider.of<AuthProvider>(context, listen: false);

// Login
bool success = await authProvider.login('test@example.com', 'password123');

if (success) {
  // Navigate to home
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const HomeScreen()),
  );
} else {
  // Show error
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(authProvider.error ?? 'Giriş başarısız')),
  );
}
```

### Logout Örneği

```dart
await authProvider.logout();
Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (context) => const LoginScreen()),
);
```

### Token Yenileme (Otomatik)

```dart
// API çağrısından önce:
await authProvider.ensureValidToken();

// Token artık geçerli, API çağrısı yapılabilir
final accessToken = await tokenStorage.getAccessToken();
```

## 🔄 HTTP Interceptor (Gelecek Özellik)

Her API çağrısına otomatik token eklemek için HTTP interceptor oluşturulacak:

```dart
// features/service/http_client.dart
class AuthenticatedHttpClient {
  final AuthProvider authProvider;
  
  Future<http.Response> get(String url) async {
    // Ensure token is valid
    await authProvider.ensureValidToken();
    
    // Get token
    final token = await TokenStorageService().getAccessToken();
    
    // Make request with authorization header
    return await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
  }
}
```

## ✨ Özellikler

✅ **Secure Token Storage** - flutter_secure_storage ile şifrelenmiş depolama
✅ **Auto Token Refresh** - Token süresi dolmadan otomatik yenileme
✅ **State Management** - Provider pattern ile merkezi auth yönetimi
✅ **Error Handling** - Kapsamlı hata yönetimi
✅ **Persistent Session** - Uygulama kapatılıp açılsa bile oturum devam eder

## 🔜 Devam Edecek

- [x] Model layer
- [x] Service layer
- [x] Provider layer
- [ ] Login screen
- [ ] Register screen
- [ ] Auth guard middleware
- [ ] HTTP interceptor
- [ ] Token auto-refresh on 401
- [ ] Main.dart entegrasyonu

---

**Frontend authentication altyapısı hazır!** 🎉

Sonraki adım: Login ve Register ekranlarının oluşturulması.
