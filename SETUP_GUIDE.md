# 🚀 Hastane 1071 - Kurulum Rehberi

## 1️⃣ Sistem Gereksinimleri

### Yazılım
- **Visual Studio** 2026 Community veya Pro
- **.NET 10 SDK** (veya üzeri)
- **MySQL Server** 8.0+
- **NuGet Package Manager**

### Hardware (Minimum)
- **RAM:** 4GB
- **Disk:** 500MB
- **OS:** Windows 10/11 veya Server 2019+

---

## 2️⃣ Adım-Adım Kurulum

### A. MySQL Veritabanı Kurulumu

#### 1. MySQL Server Kurulumu
```bash
# Windows'da MySQL indirin:
# https://dev.mysql.com/downloads/mysql/

# Kurulum sırasında:
# - Port: 3306 (default)
# - Root Password: istediğiniz şifre
```

#### 2. Veritabanı Oluşturma
```bash
# Command Prompt veya MySQL Workbench'te çalıştırın:

CREATE DATABASE Hastane1071;
USE Hastane1071;

# KULLANICI Tablosu
CREATE TABLE KULLANICI (
    ID INT PRIMARY KEY AUTO_INCREMENT,
    Username VARCHAR(50) UNIQUE NOT NULL,
    Password VARCHAR(100) NOT NULL,
    Role ENUM('Yönetici', 'Doktor', 'Personel') DEFAULT 'Personel',
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX(Username)
);

# HASTA Tablosu
CREATE TABLE HASTA (
    HastaID INT PRIMARY KEY AUTO_INCREMENT,
    Kullanici_ID INT NOT NULL,
    TCNo VARCHAR(11) UNIQUE NOT NULL,
    Isim VARCHAR(100) NOT NULL,
    DogumTarihi DATETIME,
    Hasta_Turu VARCHAR(50),
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(Kullanici_ID) REFERENCES KULLANICI(ID),
    INDEX(TCNo)
);

# STOK Tablosu
CREATE TABLE STOK (
    StokID INT PRIMARY KEY AUTO_INCREMENT,
    EsyaIsmi VARCHAR(100) NOT NULL,
    Miktar INT DEFAULT 0,
    Fiyat DECIMAL(10,2) DEFAULT 0.00,
    KritikSeviye INT DEFAULT 10,
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX(EsyaIsmi)
);

# RANDEVU Tablosu
CREATE TABLE RANDEVU (
    RandevuID INT PRIMARY KEY AUTO_INCREMENT,
    HastaID INT NOT NULL,
    DoctorID INT,
    Tarih DATETIME NOT NULL,
    Statu VARCHAR(20) DEFAULT 'Aktif',
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(HastaID) REFERENCES HASTA(HastaID),
    INDEX(Tarih)
);

# FATURA Tablosu
CREATE TABLE FATURA (
    FaturaID INT PRIMARY KEY AUTO_INCREMENT,
    HastaID INT NOT NULL,
    FaturaTarihi DATETIME DEFAULT CURRENT_TIMESTAMP,
    Tutar DECIMAL(10,2) NOT NULL,
    FaturaNo VARCHAR(50) UNIQUE,
    Statu VARCHAR(20) DEFAULT 'Odenmedi',
    FOREIGN KEY(HastaID) REFERENCES HASTA(HastaID),
    INDEX(FaturaNo)
);

# FATURA_OGESI Tablosu (Fatura Detayları)
CREATE TABLE FATURA_OGESI (
    OgeID INT PRIMARY KEY AUTO_INCREMENT,
    FaturaID INT NOT NULL,
    Aciklama VARCHAR(200),
    Tutar DECIMAL(10,2),
    FOREIGN KEY(FaturaID) REFERENCES FATURA(FaturaID)
);

# Test Verilerini Ekle
INSERT INTO KULLANICI (Username, Password, Role) VALUES
('admin', 'admin123', 'Yönetici'),
('doktor', 'doktor123', 'Doktor'),
('personel', 'personel123', 'Personel');

# Kontrol
SELECT * FROM KULLANICI;
```

---

### B. Visual Studio Projesi Açma

#### 1. Proje Dosyasını Aç
```bash
cd C:\Users\<YourUser>\source\repos\Hastane1071_ERP
```

#### 2. Visual Studio'da Aç
```bash
# Visual Studio başlat
# File → Open → Folder
# Hastane1071_ERP klasörünü seç
```

#### 3. Çözüm Yapısını Doğrula
```
✓ Hastane1071.Entities (Models)
✓ Hastane1071.DataAccess (Database)
✓ Hastane1071.Business (Logic)
✓ Hastane1071.UI (Application)
```

---

### C. Veritabanı Bağlantısı Yapılandırma

#### 1. DbHelper.cs'i Açın
Dosya: `Hastane1071.DataAccess/DbHelper.cs`

#### 2. Connection String'i Düzenleyin
```csharp
public class DbHelper
{
    private string connectionString = 
        "Server=localhost;Database=Hastane1071;Uid=root;Pwd=YOUR_MYSQL_PASSWORD;";

    public MySqlConnection GetConnection()
    {
        return new MySqlConnection(connectionString);
    }
}
```

**Değişkenler:**
- `Server`: MySQL sunucu adresi (localhost veya IP)
- `Database`: Veritabanı adı (Hastane1071)
- `Uid`: MySQL kullanıcı adı (root)
- `Pwd`: MySQL şifresi (kendi şifreniz)

---

### D. NuGet Paketleri Yükleme

#### 1. Package Manager Console Aç
```
Tools → NuGet Package Manager → Package Manager Console
```

#### 2. Paketleri Yükle
```powershell
# MySQL
Install-Package MySql.Data -Version 8.0.33

# PDF Kütüphanesi
Install-Package itext7 -Version 7.2.5

# Chart Controls
Install-Package System.Windows.Forms.DataVisualization.Charting

# JSON (isteğe bağlı)
Install-Package Newtonsoft.Json
```

#### 3. Alternatif (CLI ile)
```bash
cd Hastane1071.UI
dotnet add package MySql.Data
dotnet add package itext7
dotnet restore
```

---

### E. Derleme ve Test

#### 1. Build Edin
```bash
# Visual Studio'da
Build → Build Solution (Ctrl+Shift+B)

# veya CLI
dotnet build
```

#### 2. Derleme Hataları Kontrol Edin
- **CS0234:** `using` direktifleri eksikse ekleyin
- **NU1903:** Güvenlik uyarıları (görmezden gelebilirsiniz)

#### 3. Uygulamayı Çalıştırın
```bash
# Visual Studio'da
Debug → Start Without Debugging (Ctrl+F5)

# veya CLI
dotnet run --project Hastane1071.UI
```

---

## 3️⃣ Ilk Çalıştırma

### Giriş Ekranı

```
┌─────────────────────────────────────┐
│    🏥 HASTANE 1071 - SYSTEM LOGIN   │
│                                     │
│  👤 Kullanıcı Adı: [    admin    ] │
│  🔒 Şifre:         [    ••••••    ] │
│                                     │
│          [✓ Giriş Yap]              │
│       [? Test Hesapları]            │
└─────────────────────────────────────┘
```

### Test Hesapları ile Giriş

**Test 1: Yönetici**
```
Kullanıcı Adı: admin
Şifre: admin123
Beklenen: Tüm menüler aktif
```

**Test 2: Doktor**
```
Kullanıcı Adı: doktor
Şifre: doktor123
Beklenen: Hasta + Fatura menüleri aktif
```

**Test 3: Personel**
```
Kullanıcı Adı: personel
Şifre: personel123
Beklenen: Sadece Hasta menüsü aktif, Stok sekmesi gri
```

---

## 4️⃣ Özellik Testleri

### Test 1: Hasta Ekleme
```
1. "Hastalara Git" butonu tıkla
2. Yeni hastanın bilgilerini gir:
   - TC No: 12345678901
   - Adı: Ahmet Yılmaz
   - Türü: SGK
3. "Hasta Kaydet" tıkla
4. ✓ Hasta gridde görülmeli
```

### Test 2: Chart (Grafik)
```
1. Formun sağında Hasta Türü grafiği görsünür
2. Hastalar eklendikçe grafik güncellenmeli
3. Pasta Grafiği türleri göstermeli
```

### Test 3: PDF Fatura
```
1. Hasta seçip gridde tıkla
2. "📄 Fatura Çıkar" butonuna tıkla
3. ✓ Desktop'a PDF kaydedilmeli
4. ✓ PDF dosya adı: Fatura_12345678901_...pdf
```

### Test 4: Email Simülasyonu
```
1. "Randevulara Git" sekmesine gir
2. Hasta ID ve Doktor ID gir
3. Tarih seç
4. "Randevu Kaydet" tıkla
5. ✓ Email simülasyon penceresinin açılması gerekir
```

### Test 5: Dark Mode
```
1. Sağ üstte 🌙 butonuna tıkla
2. ✓ Tüm ekran kararmış görülmeli
3. Tekrar tıkla
4. ✓ Ekran aydınlanmalı
```

---

## 5️⃣ Sık Sorulan Sorular (FAQ)

### S: "MySQL bağlantısı başarısız" hatası
**C:** DbHelper.cs'deki connection string'i kontrol edin
```csharp
// Yanlış
"Server=192.168.1.1;Database=Hastane1071;Uid=root;Pwd=123;"

// Doğru
"Server=localhost;Database=Hastane1071;Uid=root;Pwd=123;"
```

### S: "Şifre sürekli hatalı" alıyorum
**C:** Veritabanında kullanıcılar var mı kontrol edin
```sql
SELECT * FROM KULLANICI;
```

### S: Chart grafiği görmüyorum
**C:** Şu paket yüklü mü kontrol edin
```powershell
Install-Package System.Windows.Forms.DataVisualization.Charting
```

### S: PDF oluşturulmuyor
**C:** Desktop klasörüne yazma izni var mı kontrol edin
```bash
# Veya farklı klasörü belirle
string path = "C:\\Dosyalar\\Faturalar\\";
```

### S: Dark mode butonuna çalışmıyor
**C:** btnDarkMode nesnesi null mı kontrol edin
```csharp
if (btnDarkMode != null)
    ToggleDarkMode();
```

---

## 6️⃣ Sorun Giderme (Troubleshooting)

### Hata 1: DLL referansı eksik
```
Çözüm:
Tools → NuGet Package Manager → Manage NuGet for Solution
MySql.Data paketini tekrar install edin
```

### Hata 2: "Unknown error 0x80004005"
```
Çözüm:
Visual Studio'yu yönetici olarak açın
File → Open as Administrator
```

### Hata 3: Veritabanında hiç veri yok
```
Çözüm:
Program.cs'deki SeedDefaultUsers() çalıştığını kontrol edin
Elle test verileri ekleyin:

INSERT INTO KULLANICI VALUES (NULL, 'admin', 'admin123', 'Yönetici', NOW());
```

### Hata 4: Uygulamalar çok yavaş
```
Çözüm:
Release modu ile derleyin (Debug değil)
Build → Configuration Manager → Release seçin
```

---

## 7️⃣ Veritabanı Yedekleme

### Yedek Alma
```bash
# MySQL Dump ile
mysqldump -u root -p Hastane1071 > Hastane1071_backup.sql

# MySQL Workbench ile
1. Server → Data Export
2. "Hastane1071" seçin
3. Export Path belirleyin
4. Start Export
```

### Yedek Geri Yükleme
```bash
mysql -u root -p Hastane1071 < Hastane1071_backup.sql
```

---

## 8️⃣ Üretim Ortamına Dağıtım

### Release Build Oluştur
```bash
dotnet publish -c Release -r win-x64 --self-contained
```

### Klasör Yapısı
```
Hastane1071/
├── Hastane1071.UI.exe
├── Hastane1071.Business.dll
├── Hastane1071.DataAccess.dll
├── Hastane1071.Entities.dll
├── README.txt
└── App.config (connection string'i güncelleyin)
```

---

## 9️⃣ Sistem Logları

Sistem logları burada kaydedilir:
```
C:\Users\<YourUsername>\AppData\Roaming\Hastane1071\Logs\
```

Örnek log:
```
Log_20240115.txt:
[2024-01-15 09:30:45] [INFO] ═══ HASTANE 1071 BAŞLATILIYOR ═══
[2024-01-15 09:30:46] [INFO] Test veriler kontrol edildi
[2024-01-15 09:30:50] [INFO] User login successful: admin (Yönetici)
[2024-01-15 09:35:12] [INFO] Patient added: Ahmet YILMAZ (12345678901)
```

---

## 🔟 Sonraki Adımlar

1. **Üretim Veritabanı Kurulumu**
   - Gerçek SQL Server kullanın
   - Şifreleri güvenli yapın

2. **Email Sistemi Aktivasyon**
   - AppUtilities.cs'de `_useSimulation = false` yapın
   - Gmail SMTP ayarlarını girin

3. **Backup Planı**
   - Günlük otomatik yedeklemeler
   - Cloud storage'a yedek

4. **Kullanıcı Eğitimi**
   - Operatörlere sistem tanıtımı
   - Rol-based access açıklama

---

## ✅ Kurulum Kontrolü Listesi

- [ ] .NET 10 SDK yüklü
- [ ] MySQL Server çalışıyor
- [ ] Veritabanı oluşturuldu
- [ ] Tablolar oluşturuldu
- [ ] Test verileri eklendi
- [ ] DbHelper.cs bağlantısı güncellendi
- [ ] NuGet paketleri yüklü
- [ ] Proje başarıyla derlendy
- [ ] Uygulamalar başladı
- [ ] Giriş ile test yapıldı
- [ ] Rolü kontrol edildi

---

**Kurulum tamamlandı! Hastane 1071'e hoş geldiniz! 🏥**

Sorularınız için lütfen README.md dosyasını kontrol edin.
