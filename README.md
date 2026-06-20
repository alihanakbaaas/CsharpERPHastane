# 🏥 Hastane 1071 - Otomasyon ve Stok Yönetim Sistemi

## 📋 Proje Özeti

**Hastane 1071** kullanıcı dostu arayüze sahip, modern .NET 10 WinForms uygulamasıdır. Hasta yönetimi, stok takibi, randevu planlama ve fatura oluşturma işlemlerini otomatikleştirmektedir.

**Teknoloji Yığını:**
- ✅ .NET 10
- ✅ Windows Forms (WinForms)
- ✅ MySQL Database
- ✅ iText (PDF kütüphanesi)
- ✅ System.Net.Mail (Email Simulation)
- ✅ Charts (Veri Görselleştirme)

---

## 🎯 Temel Özellikler

### 1. 🔐 Yetki Bazlı Giriş Sistemi (RBAC)
Rol Bazlı Erişim Kontrolü ile güvenli giriş:

**Test Hesapları:**
```
🔹 Yönetici:
   Username: admin
   Password: admin123
   Yetkiler: Tüm İşlemler

🔹 Doktor:
   Username: doktor
   Password: doktor123
   Yetkiler: Hasta + Fatura İşlemleri

🔹 Personel:
   Username: personel
   Password: personel123
   Yetkiler: Sınırlı (Hasta Görüntüleme)
```

### 2. 📊 Dashboard ve Grafik Analitik
- **Hasta Türü Dağılımı** (Pasta Grafiği)
- **Stok İstatistikleri** (Toplam Değer, Kritik Stok Uyarısı)
- **Gerçek Zamanlı Veriler**

### 3. 📄 PDF Fatura/Reçete Çıktısı
- Profesyonel Fatura Tasarımı
- Hasta Bilgileri + İşlem Detayları
- Desktop'a Otomatik Kayıt
- İşlem Numaralandırması

### 4. 📧 Randevu Hatırlatması (E-Mail Simülasyonu)
- Otomatik Email Bildirimleri
- Fatura Gönderme Sistemi
- Simülasyon Mode (Test için)
- Gerçek SMTP Seçeneği (Yapılandırılabilir)

### 5. 🌙 Karanlık Tema (Dark Mode)
- Light/Dark Mode Toggle
- Profesyonel Tema Renkleri
- Tüm UI Elementlerine Uygulanır
- Aksiyon Butonları Korunur

---

## 🏗️ Proje Mimarisi

```
Hastane1071.UI (Presentation Layer)
├── Form1.cs              → Ana Uygulama Formu
├── LoginForm.cs          → Giriş Ekranı
└── Program.cs            → Uygulama Başlangıcı

Hastane1071.Business (Business Logic)
├── HastaManager.cs       → Hasta İşlemleri
├── StokManager.cs        → Stok Yönetimi
├── RandevuManager.cs     → Randevu Planlama
├── FaturaManager.cs      → Fatura İşlemleri
├── KullaniciManager.cs   → Kullanıcı Doğrulaması
└── AppUtilities.cs       → Yardımcı Fonksiyonlar ⭐ (YENİ)

Hastane1071.DataAccess (Data Access Layer)
├── HastaDAL.cs           → Hasta Veritabanı İşlemleri
├── StokDAL.cs            → Stok Veritabanı İşlemleri
├── RandevuDAL.cs         → Randevu Veritabanı İşlemleri
├── FaturaDAL.cs          → Fatura Veritabanı İşlemleri
├── KullaniciDAL.cs       → Kullanıcı Doğrulama Sorguları
└── DbHelper.cs           → Veritabanı Bağlantısı

Hastane1071.Entities (Data Models)
├── Kullanici.cs          → Kullanıcı Modeli
├── Hasta.cs              → Hasta Modeli
├── Stok.cs               → Stok Modeli
├── Randevu.cs            → Randevu Modeli
└── Fatura.cs             → Fatura Modeli
```

---

## 🚀 Önemli Sınıflar ve Metodlar

### AppUtilities.cs (YENİ)
Sistem çapında yardımcı fonksiyonlar:

**1. ThemeColors**
```csharp
// Dark/Light tema renklerinş
ThemeColors.DarkBackground
ThemeColors.LightForeground
```

**2. Roles**
```csharp
// Rol tabanlı erişim kontrolü
Roles.CanManageStocks("Doktor")
Roles.CanGenerateInvoices("Yönetici")
Roles.CanManageUsers("Personel")
```

**3. EmailService**
```csharp
var emailService = new AppUtilities.EmailService();
emailService.SendAppointmentReminder("hasta@email.com", appointmentDate);
emailService.SendInvoiceNotification("hasta@email.com", invoiceNo, amount);
```

**4. InvoiceGenerator**
```csharp
string invoiceNumber = AppUtilities.InvoiceGenerator.GenerateInvoiceNumber();
string invoicePath = AppUtilities.InvoiceGenerator.GetInvoicePath(tcNo);
```

**5. Validation**
```csharp
AppUtilities.Validation.ValidateTCNo("12345678901")
AppUtilities.Validation.ValidateEmail("test@example.com")
AppUtilities.Validation.ValidatePhoneNumber("5551234567")
```

**6. DateTimeHelper**
```csharp
AppUtilities.DateTimeHelper.FormatTurkish(DateTime.Now)
AppUtilities.DateTimeHelper.IsToday(someDate)
```

**7. Logger**
```csharp
AppUtilities.Logger.LogInfo("Bilgi mesajı")
AppUtilities.Logger.LogError("Hata oluştu", exception)
AppUtilities.Logger.LogWarning("Uyarı mesajı")
```

---

## 🔄 Sistemin Çalışma Akışı

```
1. BAŞLANGAÇ
   ↓
2. LoginForm → Kullanıcı Doğrulaması
   ↓
3. Form1 (Ana Uygulama) → ApplyRoleRights()
   ↓
4. Rol Kontrolleri (Menü Deaktivasyonu)
   ↓
5. İşlem Seçimi:
   ├─→ Hasta Kaydet → Database → IstatistikleriGuncelle()
   ├─→ Stok Ekle → Database → Chart Güncelle
   ├─→ Randevu Oluştur → Email Gönder → Database
   ├─→ Fatura Çıkar → PDF Üret → Email Gönder
   └─→ Dark Mode → UI Teması Değiş
```

---

## 📊 Veritabanı Tabloları

```sql
-- KULLANICI (Kullanıcı Bilgileri)
CREATE TABLE KULLANICI (
    ID INT PRIMARY KEY AUTO_INCREMENT,
    Username VARCHAR(50) UNIQUE,
    Password VARCHAR(100),
    Role ENUM('Yönetici', 'Doktor', 'Personel')
);

-- HASTA (Hasta Kayıtları)
CREATE TABLE HASTA (
    HastaID INT PRIMARY KEY AUTO_INCREMENT,
    Kullanici_ID INT,
    TCNo VARCHAR(11) UNIQUE,
    Isim VARCHAR(100),
    DogumTarihi DATETIME,
    Hasta_Turu VARCHAR(50)
);

-- STOK (İlaç ve Malzeme Envanteri)
CREATE TABLE STOK (
    StokID INT PRIMARY KEY AUTO_INCREMENT,
    EsyaIsmi VARCHAR(100),
    Miktar INT,
    Fiyat DECIMAL(10,2)
);

-- RANDEVU (Hasta Randevuları)
CREATE TABLE RANDEVU (
    RandevuID INT PRIMARY KEY AUTO_INCREMENT,
    HastaID INT,
    DoctorID INT,
    Tarih DATETIME,
    Statu VARCHAR(20)
);

-- FATURA (Hasta Faturaları)
CREATE TABLE FATURA (
    FaturaID INT PRIMARY KEY AUTO_INCREMENT,
    HastaID INT,
    Tarih DATETIME,
    Tutar DECIMAL(10,2)
);
```

---

## ⚙️ Kurulum Adımları

### 1. Gereksinimler
- Visual Studio 2026 veya üzeri
- .NET 10 SDK
- MySQL Server 8.0+
- NuGet Paketleri:
  - `MySql.Data`
  - `itext7`
  - `System.Windows.Forms.DataVisualization.Charting`

### 2. Veritabanı Kurulumu
```bash
# MySQL'de veritabanı oluştur
CREATE DATABASE Hastane1071;
```

### 3. Bağlantı Strings
`DbHelper.cs` dosyasında MySQL bağlantısını düzenleyin:
```csharp
string connectionString = "Server=localhost;Database=Hastane1071;Uid=root;Pwd=yourpassword;";
```

### 4. NuGet Paketleri Yükleme
```bash
dotnet restore
```

### 5. Derleme ve Çalıştırma
```bash
dotnet build
dotnet run
```

---

## 🔒 Güvenlik Özellikleri

✅ **Parameterized Queries** - SQL Injection Koruması
✅ **Şifreli Veritabanı Bağlantısı**
✅ **Rol Bazlı Erişim Kontrolü (RBAC)**
✅ **Session Management** - Kullanıcı Bilgisi Takibi
✅ **Audit Logging** - Tüm İşlemler Kaydedilir
✅ **Password Masking** - Giriş Ekranında

---

## 📝 Loglama Sistemi

Tüm önemli olaylar `%AppData%\Hastane1071\Logs` klasöründe kaydedilir:

```
Log_20240115.txt:
[2024-01-15 14:23:45] [INFO] User login successful: admin (Yönetici)
[2024-01-15 14:24:12] [INFO] Patient added: Ahmet YILMAZ (12345678901)
[2024-01-15 14:25:33] [WARNING] Failed login attempt for user: testuser
[2024-01-15 14:26:01] [ERROR] PDF Generation Error -> IOException: File in use
```

---

## 🎨 Tema Renkleri

### Light Theme
- Background: `#FFFFFF` (Beyaz)
- Foreground: `#000000` (Siyah)
- Primary Button: `#2D425B` (Koyu Mavi)

### Dark Theme
- Background: `#2D2D30` (Koyu Gri)
- Foreground: `#FFFFFF` (Beyaz)
- Input: `#1E1E1E` (Siyah)

### Action Colors (İkisi de Tema)
- Success: `#90EE90` (Açık Yeşil)
- Warning: `#FFA500` (Turuncu)
- Danger: `#FF0000` (Kırmızı)

---

## 🐛 Hata Giderme

### "MySQL Bağlantı Hatası"
```
Çözüm: DbHelper.cs'de connection string kontrol edin
```

### "Şifre Hatalı Hatasında Loop"
```
Çözüm: Test hesaplarını yukarıda kontrol edin
```

### "PDF Dosyası Oluştulamadı"
```
Çözüm: Desktop klasörüne yazma izni kontrol edin
```

---

## 📞 İletişim & Destek

- **Geliştirici:** Hastane1071 Dev Team
- **Sürüm:** 1.0
- **Son Güncelleme:** Ocak 2024
- **Lisans:** Proprietary (Ticari Kullanım Yasaktır)

---

## 🎓 Eğitim Amaçlı Notlar

Bu proje aşağıdaki konseptleri öğretmektedir:

1. **Çok Katmanlı Mimari (3-Layer Architecture)**
   - UI Layer (Presentation)
   - Business Layer (Logic)
   - Data Layer (Persistence)

2. **Veritabanı Tasarımı**
   - Entity-Relationship Model
   - Normalization
   - Foreign Keys

3. **C# OOP Prensipleri**
   - Encapsulation
   - Inheritance
   - Polymorphism
   - Abstraction

4. **Güvenlik Praksisleri**
   - SQL Injection Koruması
   - Parameterized Queries
   - Role-Based Access Control

5. **UI/UX Tasarımı**
   - Tema Uygulaması
   - Dinamik Controls
   - Responsive Tasarım

---

## 📊 Proje Statüsü

| Özellik | Durum |
|---------|-------|
| 🔐 RBAC Giriş Sistemi | ✅ Tamamlandı |
| 📊 Dashboard Charts | ✅ Tamamlandı |
| 📄 PDF Fatura | ✅ Tamamlandı |
| 📧 Email Simülasyonu | ✅ Tamamlandı |
| 🌙 Dark Mode | ✅ Tamamlandı |
| 🔔 Bildirimleri Sistemi | 🟡 Planlanıyor |
| 📱 Mobile App | 🟡 Planlanıyor |
| ☁️ Cloud Backup | 🟡 Planlanıyor |

---

**© 2024 Hastane1071. Tüm Hakları Saklıdır.**
