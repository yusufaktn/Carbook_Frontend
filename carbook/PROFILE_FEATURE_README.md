# Profil Sayfası - Kullanım Kılavuzu

## 📋 Genel Bakış

Bu doküman, CarBook uygulamasına eklenen **Profil Sayfası** özelliğini açıklamaktadır. Profil sayfası, kullanıcıların kendi bilgilerini görüntülemesine ve düzenlemesine olanak tanır.

## 🎨 Özellikler

### ✨ Profil Sayfası Özellikleri

1. **Profil Header**
   - Profil fotoğrafı (avatar) veya kullanıcı baş harfleri
   - Tam ad görüntüleme
   - E-posta adresi
   - Kullanıcı adı (@username formatında)

2. **İstatistikler Kartı**
   - Kullanıcının toplam soru sayısı
   - Kullanıcının toplam cevap sayısı

3. **Profil Bilgileri Kartı**
   - Ad
   - Soyad
   - E-posta

4. **Aksiyon Butonları**
   - Profili Düzenle
   - Şifre Değiştir
   - Çıkış Yap

## 📁 Eklenen Dosyalar

### Model Katmanı
```
lib/features/model/User/
└── user_model.dart         # Kullanıcı veri modeli
```

### Servis Katmanı
```
lib/features/service/ApiService/User/
└── user_service.dart       # User API servisi
```

### Provider Katmanı
```
lib/features/provider/User/
└── user_provider.dart      # Kullanıcı state yönetimi
```

### Ekran Katmanı
```
lib/features/screen/
└── profile_screen.dart     # Ana profil sayfası
```

### Widget Katmanı
```
lib/features/widget/
├── ProfileHeader.dart           # Profil başlığı widget'ı
├── ProfileInfoCard.dart         # Profil bilgileri kartı
├── ProfileStatsCard.dart        # İstatistikler kartı
└── ProfileActionButtons.dart    # Aksiyon butonları
```

## 🔧 Kurulum ve Yapılandırma

### 1. API Base URL Ayarı

`lib/features/service/ApiService/User/user_service.dart` dosyasında API base URL'ini güncelleyin:

```dart
static const String baseUrl = 'http://localhost:5291/api/User';
// Veya canlı sunucu:
// static const String baseUrl = 'https://your-api.com/api/User';
```

### 2. Provider Kaydı

`main.dart` dosyasına UserProvider zaten eklenmiştir:

```dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (context) => CategoryProvider()),
    ChangeNotifierProvider(create: (context) => QuestionProvider()),
    ChangeNotifierProvider(create: (context) => AnswerProvider()),
    ChangeNotifierProvider(create: (context) => UserProvider()), // ✅ Eklendi
  ],
  // ...
)
```

## 🚀 Kullanım

### Profil Sayfasına Gitme

#### Yöntem 1: AppBar'dan
Ana sayfanın sağ üst köşesindeki profil resmine tıklayın:

```dart
// CustomAppBar.dart içinde otomatik olarak yapılandırılmıştır
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const ProfileScreen(userId: 1),
  ),
);
```

#### Yöntem 2: Programatik Yönlendirme
Herhangi bir yerden profil sayfasına yönlendirme:

```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const ProfileScreen(
      userId: kullaniciId, // Mevcut kullanıcının ID'si
    ),
  ),
);
```

### Profil Düzenleme

1. Profil sayfasında sağ üst köşedeki **düzenle** ikonuna veya
2. **Profili Düzenle** butonuna tıklayın
3. Açılan dialog'da bilgileri güncelleyin
4. **Kaydet** butonuna basın

### Profil Bilgilerini Güncelleme (Kod Örneği)

```dart
// UserProvider'ı kullanarak profil güncelleme
final userProvider = Provider.of<UserProvider>(context, listen: false);

final updatedUser = userProvider.currentUser!.copyWith(
  userName: 'Yeni Ad',
  userLastName: 'Yeni Soyad',
  email: 'yeni@email.com',
);

final success = await userProvider.updateUserProfile(updatedUser);

if (success) {
  print('Profil başarıyla güncellendi!');
} else {
  print('Profil güncellenemedi: ${userProvider.error}');
}
```

## 🎨 Tasarım Sistemi

### Renkler
- **Primary**: `#19DB8A` (Yeşil)
- **Secondary**: `#4B39EF` (Mavi)
- **Background**: `#F1F4F8` (Açık Gri)
- **Text Primary**: `#14181B` (Koyu Gri)
- **Text Secondary**: `#57636C` (Orta Gri)
- **Error**: `Colors.red`

### Tipografi
- **Font Family**: Google Fonts (Inter, Readex Pro)
- **Başlık**: 24px, Bold
- **Alt Başlık**: 18-22px, SemiBold
- **Gövde**: 14-16px, Normal

### Bileşenler
- **Border Radius**: 12-16px
- **Gölge**: BoxShadow ile 0.05-0.1 opacity
- **Spacing**: 16-24px arası padding/margin

## 🔌 API Entegrasyonu

### Backend Endpoints

Profil sayfası aşağıdaki API endpoint'lerini kullanır:

1. **Kullanıcı Getir**
   - `GET /api/User/GetUserById?id={userId}`
   - Belirli bir kullanıcının bilgilerini getirir

2. **Kullanıcı Güncelle**
   - `PUT /api/User/UpdateUser`
   - Body: `{ userId, userName, userLastName, email, passwordHash, profileImageUrl }`
   - Kullanıcı bilgilerini günceller

3. **Tüm Kullanıcıları Getir**
   - `GET /api/User/GetUser`
   - Tüm kullanıcıların listesini getirir

### API Response Format

```json
{
  "userId": 1,
  "userName": "Yusuf",
  "userLastName": "Aktın",
  "email": "yusuf@example.com",
  "profileImageUrl": "https://example.com/profile.jpg"
}
```

## 📱 Ekran Görüntüleri Yapısı

```
ProfileScreen
├── AppBar (Başlık + Düzenle Butonu)
├── ScrollView
    ├── ProfileHeader
    │   ├── Avatar (120x120)
    │   ├── Tam Ad
    │   ├── Email
    │   └── Username
    ├── ProfileStatsCard
    │   ├── Sorular Sayısı
    │   └── Cevaplar Sayısı
    ├── ProfileInfoCard
    │   ├── Ad
    │   ├── Soyad
    │   └── E-posta
    └── ProfileActionButtons
        ├── Profili Düzenle
        ├── Şifre Değiştir
        └── Çıkış Yap
```

## 🔒 Güvenlik Notları

1. **Şifre Yönetimi**: Şu anda `passwordHash` için placeholder değer kullanılıyor. Gerçek bir uygulamada:
   - Şifre değiştirme için ayrı bir endpoint kullanılmalı
   - Şifre asla düz metin olarak gönderilmemeli
   - Şifre hash'leme backend'de yapılmalı

2. **Kimlik Doğrulama**: 
   - Demo amaçlı userId: 1 kullanılıyor
   - Gerçek uygulamada JWT token veya session management kullanın

3. **Yetkilendirme**:
   - Kullanıcılar sadece kendi profillerini düzenleyebilmeli
   - Backend'de proper authorization kontrolleri yapılmalı

## 🐛 Hata Yönetimi

UserProvider içinde kapsamlı hata yönetimi mevcuttur:

```dart
if (userProvider.error != null) {
  // Hata durumunu göster
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(userProvider.error!)),
  );
}
```

### Yaygın Hatalar

1. **Ağ Hatası**: "Sunucuya bağlanılamadı"
2. **Zaman Aşımı**: "Bağlantı zaman aşımına uğradı"
3. **404**: "Kullanıcı bulunamadı"
4. **500**: "Sunucu hatası"

## 🚧 Gelecek Geliştirmeler

- [ ] Profil fotoğrafı yükleme özelliği
- [ ] Şifre değiştirme fonksiyonu
- [ ] Hesap silme özelliği
- [ ] Kullanıcı soruları ve cevapları listeleme
- [ ] Dark mode desteği
- [ ] Bildirim ayarları
- [ ] Gizlilik ayarları

## 📞 Destek

Herhangi bir sorun veya soru için:
- GitHub Issues açın
- Proje sahibi ile iletişime geçin

---

**Not**: Bu profil sayfası CarBook uygulamasının mevcut tasarım sistemi ile tam uyumludur ve tüm bileşenler yeniden kullanılabilir şekilde tasarlanmıştır.
