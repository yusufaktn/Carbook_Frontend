# 🔐 Authentication System - Kullanım Kılavuzu

## 📋 İçindekiler
- [Login Screen](#login-screen)
- [Register Screen](#register-screen)
- [Auth Guard](#auth-guard)
- [Route Yönetimi](#route-yönetimi)
- [Main.dart Entegrasyonu](#maindart-entegrasyonu)

---

## 🎯 Login Screen

### Özellikler
✅ Email ve şifre ile giriş  
✅ Form validasyonu  
✅ Şifre göster/gizle  
✅ Beni hatırla checkbox  
✅ Şifremi unuttum linki  
✅ Kayıt ol sayfasına yönlendirme  
✅ Loading state  
✅ Hata mesajları  

### Kullanım
```dart
import 'package:flutter/material.dart';
import 'features/screen/Auth/login_screen.dart';

// Direkt kullanım
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const LoginScreen()),
);

// Route ile kullanım
Navigator.pushNamed(context, '/login');
```

### Form Validasyonları
- **Email**: Geçerli email formatı kontrolü
- **Şifre**: Minimum 6 karakter

---

## 📝 Register Screen

### Özellikler
✅ Ad, soyad, email ve şifre ile kayıt  
✅ Şifre tekrar kontrolü  
✅ Güçlü şifre validasyonu  
✅ Kullanım şartları onayı  
✅ Şifre göster/gizle (her iki alan için)  
✅ Loading state  
✅ Başarılı kayıt sonrası otomatik giriş  

### Kullanım
```dart
import 'package:flutter/material.dart';
import 'features/screen/Auth/register_screen.dart';

// Direkt kullanım
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const RegisterScreen()),
);

// Route ile kullanım
Navigator.pushNamed(context, '/register');
```

### Form Validasyonları
- **Ad/Soyad**: Minimum 2 karakter
- **Email**: Geçerli email formatı
- **Şifre**: 
  - Minimum 6 karakter
  - En az 1 harf
  - En az 1 rakam
- **Şifre Tekrar**: İlk şifre ile eşleşmeli
- **Kullanım Şartları**: Kabul edilmeli

---

## 🛡️ Auth Guard

### Özellikler
✅ Otomatik authentication kontrolü  
✅ Korumalı sayfalara erişim kontrolü  
✅ Yetkisiz erişimlerde login'e yönlendirme  
✅ Loading state yönetimi  

### Kullanım

#### Basit AuthGuard
```dart
import 'features/widget/Auth/auth_guard.dart';

// Korumalı sayfa
AuthGuard(
  child: HomeScreen(),
  requireAuth: true, // Varsayılan true
)

// Herkese açık sayfa
AuthGuard(
  child: PublicScreen(),
  requireAuth: false,
)
```

#### Route ile AuthGuard
```dart
import 'features/widget/Auth/auth_guard.dart';

AuthGuardRoute(
  requireAuth: true,
  child: ProfileScreen(userId: 1),
)
```

---

## 🗺️ Route Yönetimi

### AppRoutes Kullanımı

#### Route İsimleri
```dart
AppRoutes.login         // '/login'
AppRoutes.register      // '/register'
AppRoutes.home          // '/home'
AppRoutes.profile       // '/profile'
AppRoutes.questionsList // '/questions'
AppRoutes.questionDetail // '/question-detail'
```

#### Navigation Metodları

**1. Basit Navigasyon**
```dart
// Login sayfasına git
AppRoutes.navigateTo(context, AppRoutes.login);

// Profile sayfasına git (userId parametreli)
AppRoutes.navigateTo(
  context, 
  AppRoutes.profile,
  arguments: {'userId': 123},
);

// Question detail sayfasına git (question objesi ile)
AppRoutes.navigateTo(
  context,
  AppRoutes.questionDetail,
  arguments: {'question': questionObject},
);
```

**2. Replace Navigation**
```dart
// Mevcut sayfayı değiştir (geri dönülemez)
AppRoutes.navigateAndReplace(context, AppRoutes.home);
```

**3. Clear Stack Navigation**
```dart
// Tüm stack'i temizle ve home'a git
AppRoutes.navigateAndRemoveUntil(context, AppRoutes.home);

// Login'e git ve stack'i temizle (logout senaryosu)
AppRoutes.navigateAndRemoveUntil(context, AppRoutes.login);
```

**4. Geri Dönme**
```dart
// Geri dön
AppRoutes.goBack(context);

// Result ile geri dön
AppRoutes.goBack(context, result: {'updated': true});

// Geri dönebilir mi kontrol et
if (AppRoutes.canGoBack(context)) {
  AppRoutes.goBack(context);
}
```

---

## 🚀 Main.dart Entegrasyonu

### Tam Entegrasyon Örneği

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/provider/Auth/auth_provider.dart';
import 'features/routes/app_routes.dart';
import 'features/widget/Auth/auth_guard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Auth Provider
        ChangeNotifierProvider(
          create: (_) => AuthProvider()..initializeAuth(),
        ),
        // Diğer providerlar...
      ],
      child: MaterialApp(
        title: 'CarBook',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        
        // Route generator
        onGenerateRoute: AppRoutes.onGenerateRoute,
        
        // Initial route - auth kontrolü ile
        home: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            // Loading state
            if (authProvider.isLoading) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            
            // Authenticated user - Home screen
            if (authProvider.isAuthenticated) {
              return AuthGuardRoute(
                requireAuth: true,
                child: const HomeScreen(),
              );
            }
            
            // Not authenticated - Login screen
            return const LoginScreen();
          },
        ),
      ),
    );
  }
}
```

### Basit Entegrasyon (Minimal)

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/provider/Auth/auth_provider.dart';
import 'features/routes/app_routes.dart';
import 'features/screen/Auth/login_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        onGenerateRoute: AppRoutes.onGenerateRoute,
        initialRoute: AppRoutes.login,
      ),
    ),
  );
}
```

---

## 📱 Kullanım Senaryoları

### Senaryo 1: Uygulama Açılışı
```dart
// main.dart
home: Consumer<AuthProvider>(
  builder: (context, authProvider, child) {
    if (authProvider.isLoading) {
      return SplashScreen(); // Loading göster
    }
    
    return authProvider.isAuthenticated 
      ? HomeScreen()    // Giriş yapılmış
      : LoginScreen();  // Giriş yapılmamış
  },
)
```

### Senaryo 2: Login İşlemi
```dart
// login_button onPressed
final success = await authProvider.login(email, password);

if (success) {
  // Başarılı - Home'a yönlendir
  Navigator.pushReplacementNamed(context, '/home');
} else {
  // Hatalı - Mesaj göster
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(authProvider.error ?? 'Giriş başarısız')),
  );
}
```

### Senaryo 3: Register İşlemi
```dart
// register_button onPressed
final success = await authProvider.register(request);

if (success) {
  // Başarılı kayıt mesajı
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Kayıt başarılı! Giriş yapılıyor...')),
  );
  
  // Otomatik login
  await Future.delayed(Duration(seconds: 1));
  Navigator.pushReplacementNamed(context, '/home');
}
```

### Senaryo 4: Logout İşlemi
```dart
// logout_button onPressed
await authProvider.logout();

// Login sayfasına yönlendir (tüm stack'i temizle)
AppRoutes.navigateAndRemoveUntil(context, AppRoutes.login);
```

### Senaryo 5: Korumalı Sayfa
```dart
// Protected screen
class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AuthGuardRoute(
      requireAuth: true,
      child: Scaffold(
        appBar: AppBar(title: Text('Ayarlar')),
        body: _buildSettingsContent(),
      ),
    );
  }
}
```

---

## 🎨 UI Özellikleri

### Tasarım
- Modern ve temiz arayüz
- Material Design 3 uyumlu
- Responsive tasarım
- Floating SnackBar mesajları
- Smooth animasyonlar

### Renkler
- Primary: `Colors.blue.shade700`
- Background: `Colors.white`
- Input Fill: `Colors.grey.shade50`
- Border: `Colors.grey.shade300`
- Error: `Colors.red`
- Success: `Colors.green`

### Typography
- Title: 28px, Bold
- Subtitle: 16px, Regular
- Button: 16px, Bold
- Input: Default Material

---

## ⚠️ Önemli Notlar

1. **AuthProvider Initialization**: `main.dart`'da `initializeAuth()` çağrısı önemli
2. **Token Storage**: Secure storage kullanıldı (iOS Keychain, Android KeyStore)
3. **Route Arguments**: Profile ve QuestionDetail sayfaları arguments bekliyor
4. **Error Handling**: Tüm hata durumları handle ediliyor
5. **Loading States**: Her async işlem için loading state var
6. **Form Validation**: Tüm inputlar validate ediliyor

---

## 🔧 Yapılacaklar (TODO)

- [ ] Şifre sıfırlama özelliği
- [ ] Email doğrulama
- [ ] Sosyal medya ile giriş (Google, Apple)
- [ ] Biometric authentication (Touch ID, Face ID)
- [ ] Two-factor authentication (2FA)
- [ ] Session timeout
- [ ] Remember me fonksiyonunu aktif et
- [ ] Offline mode support

---

## 📞 API Endpoints

Backend'de aşağıdaki endpoint'lerin hazır olması gerekiyor:

```
POST /api/auth/login
POST /api/auth/register
POST /api/auth/refresh-token
POST /api/auth/logout
GET  /api/auth/me
```

Detaylar için `BACKEND_AUTH_SETUP.md` dosyasına bakın.

---

## 🎓 Örnek Kullanım

```dart
// 1. Provider'ı context'ten al
final authProvider = context.read<AuthProvider>();

// 2. Login yap
await authProvider.login('user@email.com', 'password123');

// 3. Kullanıcı bilgisini al
final user = authProvider.currentUser;
print('Kullanıcı: ${user?.userName} ${user?.userLastName}');

// 4. Authentication durumunu kontrol et
if (authProvider.isAuthenticated) {
  print('Kullanıcı giriş yapmış');
}

// 5. Logout yap
await authProvider.logout();
```

---

## 📚 İlgili Dosyalar

- `lib/features/screen/Auth/login_screen.dart` - Login UI
- `lib/features/screen/Auth/register_screen.dart` - Register UI
- `lib/features/widget/Auth/auth_guard.dart` - Auth protection
- `lib/features/routes/app_routes.dart` - Route management
- `lib/features/provider/Auth/auth_provider.dart` - Auth state management
- `lib/features/service/ApiService/Auth/auth_service.dart` - API calls
- `lib/features/service/Storage/token_storage_service.dart` - Token storage

---

**✅ Authentication sistemi kullanıma hazır!**
