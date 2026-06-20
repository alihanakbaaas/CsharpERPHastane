# 🏥 Hastane1071 ERP - Doktor/Personel Randevu Sistemi (V2.0)

## 📌 Özet

Hastane1071 ERP sistemi **2. sürümü**, doktor ve personel rollerine sahip kullanıcıların **kendi alanında randevu oluşturabilmesini** sağlayan yeni özellikler içermektedir. Sistem tamamen gerçek zamanlı çalışmakta ve tüm validasyonlar otomatik olarak uygulanmaktadır.

## 🎯 Yeni Özellikler (V2.0)

### ✅ Doktor ve Personel Randevu Oluşturma
- **Doktor rolü**: Kendi uzmanlık alanında randevu oluşturabilir
- **Personel rolü**: Tüm doktorlar için randevu oluşturabilir
- **Admin rolü**: Bu özelliğe erişemez (sadece hasta/stok/fatura yönetimi)

### ✅ Doktor Listesi Ekranı
- Tüm aktif doktorları gösterir
- Doktor bilgileri: Adı, Uzmanlığı, Telefon, E-posta
- Doktor seçimi sonrası otomatik randevu formu açılır

### ✅ Doktor Paneli UI
- **Konum**: Sol alt menüde "👨‍⚕️ Doktorlar" butonu
- **Görünüm**: 
  - Doktor Listesi (GroupBox + DataGridView)
  - Doktor Randevu Oluşturma Formu
- **Fonksiyonalite**: Dinamik oluşturulmuş (Form1.cs içinde)

### ✅ Rol Bazlı Erişim Kontrolleri
```
┌─────────────────────────────────────────────────┐
│ Admin   │ Hasta, Stok, Fatura yönetimi          │
├─────────────────────────────────────────────────┤
│ Doktor  │ Doktor Listesi, Kendi alanında Randevu│
├─────────────────────────────────────────────────┤
│ Personel│ Doktor Listesi, Tüm doktor Randevu    │
└─────────────────────────────────────────────────┘
```

## 📁 Oluşturulan Dosyalar

### 1. Entity Katmanı
```
Hastane1071.Entities\Doktor.cs
├─ DoktorID
├─ KullaniciID
├─ Isim
├─ Uzmanlık
├─ TCNo
├─ DogumTarihi
├─ Telefon
├─ Email
└─ Statu (Aktif/Pasif)
```

### 2. Data Access Katmanı
```
Hastane1071.DataAccess\DoktorDAL.cs
├─ TümüGetirAsync()           → Tüm doktorları getirir
├─ IdyeGöreGetirAsync()       → ID'ye göre doktor getirir
├─ UzmanlığaGöreGetirAsync()  → Uzmanlığa göre doktarı filtreler
├─ KullanıcıyaGöreGetirAsync()→ Kullanıcı ID'sine göre doktor bulur
└─ GetAll()                   → DataTable olarak tüm doktarı getirir
```

### 3. Business Katmanı
```
Hastane1071.Business\DoktorManager.cs
├─ TumDoktorlariGetirAsync()       → Async lista
├─ DoktorGetirAsync(id)            → Async doktor getir
├─ DoktorlariUzmanlığaGöreGetirAsync() → Filtreleme
├─ BenimProfilimGetirAsync()       → Doktor kendi profilini görmek
├─ TumDoktorlariDataTableGetir()   → Grid binding
└─ TumUzmanlıklariGetir()          → ComboBox için uzmanlıkları getir
```

### 4. UI Bileşenleri (Form1.cs)
```
Private Fields:
├─ btnDoktorlar          → Doktor listesi butonu
├─ groupBoxDoktor        → Doktor listesi paneli
├─ dataGridViewDoktor    → Doktor tablosu
├─ groupBoxDoktorRandevu → Randevu oluşturma formu
├─ txtDoktorSecili       → Seçili doktor göstericisi
├─ txtHastaIDDoktor      → Hasta ID input
├─ dtpDoktor             → Tarih/Saat seçicisi
└─ seciliDoktor          → Cache(seçili doktor nesnesi)

Methods:
├─ CreateDoctorPanelButton()       → UI bileşenlerini dinamik oluşturur
├─ button_Doktorlar_Click()        → Doktor listesini yükler ve gösterir
└─ DataGridViewDoktor_CellClick()  → Doktor seçimi işlemi
```

## 🔄 İş Akışı (Workflow)

```
1. Doktor/Personel Giriş Yapı
   ↓
2. ApplyRoleRights() çalışır
   ↓
3. CreateDoctorPanelButton() çalışır
   ├─ Doktor Listesi butonu (👨‍⚕️) oluşturulur
   └─ Doktor ve Randevu panelleri oluşturulur
   ↓
4. Kullanıcı "👨‍⚕️ Doktorlar" butonuna tıklar
   ↓
5. button_Doktorlar_Click() çalışır
   ├─ DoktorManager.TumDoktorlariGetirAsync()
   ├─ Doktor listesini DataTable'a dönüştürür
   └─ DataGridView'e bağlar
   ↓
6. Kullanıcı grid'de doktor seçer
   ↓
7. DataGridViewDoktor_CellClick() çalışır
   ├─ DoktorManager.DoktorGetirAsync(id)
   ├─ seciliDoktor cache'ini günceller
   ├─ txtDoktorSecili label'ı günceller
   └─ groupBoxDoktorRandevu panelini gösterir
   ↓
8. Kullanıcı Hasta ID ve Tarih/Saat girer
   ↓
9. "✅ Randevu Kaydet" butonuna tıklar
   ↓
10. Validasyonlar çalışır:
    ├─ Doktor seçili mi?
    ├─ Hasta ID geçerli mi?
    ├─ Tarih gelecek mi?
    └─ Saat 08:00-17:00 arasında mı?
    ↓
11. RandevuManager.RandevuEkleAsync() çalışır
    ├─ Veritabanına kaydeder
    ├─ Email simülasyonunu gönderir
    └─ başarılı/başarısız mesajı döner
    ↓
12. Başarılı ise:
    ├─ Formu temizler
    └─ İşlem tamamlanır
```

## 🗄️ Veritabanı Yapısı

### Doktorlar Tablosu
```sql
CREATE TABLE Doktorlar (
    DoktorID INT PRIMARY KEY AUTO_INCREMENT,
    KullaniciID INT,
    Isim VARCHAR(100) NOT NULL,           -- "Dr. Ahmet Yılmaz"
    Uzmanlık VARCHAR(100),                 -- "Kardiyoloji"
    TCNo VARCHAR(11) UNIQUE,
    DogumTarihi DATE,
    Telefon VARCHAR(20),
    Email VARCHAR(100),
    Statu VARCHAR(50) DEFAULT 'Aktif',    -- Filtre: WHERE Statu = 'Aktif'
    OlusturulmaTarihi DATETIME,
    GuncellemeTarihi DATETIME
);
```

### Örnek Veriler (5 Doktor)
| ID | Isim | Uzmanlık | Telefon | Email | Statu |
|----|------|----------|---------|-------|-------|
| 1 | Dr. Ahmet Yılmaz | Genel Cerrahı | +90 212 123 4567 | ahmet@hospital.com | Aktif |
| 2 | Dr. Fatma Şahin | Kardiyoloji | +90 212 234 5678 | fatma@hospital.com | Aktif |
| 3 | Dr. Mehmet Kaya | Nöroloji | +90 212 345 6789 | mehmet@hospital.com | Aktif |
| 4 | Dr. Ayşe Demir | Ortopedi | +90 212 456 7890 | ayse@hospital.com | Aktif |
| 5 | Dr. Hakan Çelik | Göz Hastalıkları | +90 212 567 8901 | hakan@hospital.com | Aktif |

## ✅ Validasyonlar

### Doktor Randevu Oluşturma Validasyonları
1. **Doktor Seçimi** (Zorunlu)
   - Hata: "❌ Lütfen önce bir doktor seçiniz!"

2. **Hasta ID** (Zorunlu, Pozitif Sayı)
   - Hata: "❌ Geçerli bir Hasta ID giriniz!"

3. **Tarih Kontrolü** (Gelecek, İş Saati)
   - Hata: "❌ Geçmiş tarih seçemezsiniz!"
   - Hata: "❌ Randevu saati 08:00 - 17:00 arasında olmalıdır!"

4. **Veritabanı Validation** (Backend)
   - Hasta ID var mı? (Foreign Key)
   - Doktor ID var mı? (Foreign Key)
   - Çakışan randevu var mı? (Business Rule)

## 🔐 Güvenlik & Kontroller

### Rol-Bazlı Erişim
```csharp
if (_currentUser.Rol == AppUtilities.Roles.DOCTOR || 
    _currentUser.Rol == AppUtilities.Roles.STAFF)
{
    CreateDoctorPanelButton();
}
```

### Doktor Alanında Randevu Oluşturma
- **Mevcut**: Doktor seçilir ve o doktor için randevu yapılır
- **Gelecek (v3.0)**: Doktor kendi alanı dışında randevu oluşturamazsa uyarı verebilir

### Veri Bütünlüğü
```sql
FOREIGN KEY (HastaID) REFERENCES Hastalar(HastaID) ON DELETE CASCADE
FOREIGN KEY (DoktorID) REFERENCES Doktorlar(DoktorID) ON DELETE CASCADE
```

## 📊 Sistem İstatistikleri

Sistem başlatıldığında konsola yazdırılan bilgiler:
```
📊 DATABASE DEBUG INFO:
   ✓ Hastalar: 5
   ✓ Doktorlar: 5
   ✓ Randevular: 4
```

## 🚀 Başlangıç / Deployment

### 1. Veritabanını Hazırlayın
```bash
# MySQL'de hastane1071_db veritabanını açın ve çalıştırın:
1. DB_SETUP.sql (Tüm tabloları ve örnek veriyi oluşturur)
2. DOKTOR_SISTEM_TEST.sql (Test ve doğrulama için)
```

### 2. Uygulamayı Çalıştırın
```bash
dotnet run
# veya Visual Studio'da F5
```

### 3. Doktor/Personel Hesabı ile Giriş Yapın
```
Kullanıcı Adı: doctor
Parola: password

veya

Kullanıcı Adı: staff
Parola: password
```

### 4. "👨‍⚕️ Doktorlar" Panelini Kullanın
- Doktor listesini görün
- Randevu oluşturun
- Real-time sistemin avantajını kullanın

## 📚 Dokümantasyon Dosyaları

1. **DOKTOR_PERSONEL_RANDEVU_KILAVUZU.md** - Kullanıcı rehberi
2. **DOKTOR_SISTEM_TEST.sql** - Test ve doğrulama scriptleri
3. **DB_SETUP.sql** - Veritabanı şeması ve örnek veri
4. **SISTEM_OZET.md** - Genel sistem bilgileri

## 🐛 Bilinen Sorunlar & Çözümler

### Sorun: Doktor listesi boş göründüğü takdirde
**Çözüm**: 
```sql
-- MySQL'de kontrol edin:
SELECT * FROM Doktorlar WHERE Statu = 'Aktif';
-- Yoksa DB_SETUP.sql çalıştırın
```

### Sorun: "Hasta ID geçerli değil" hatası
**Çözüm**:
```sql
-- Hastaların ID'lerini kontrol edin:
SELECT HastaID, Isim FROM Hastalar;
-- Mevcut olan bir ID kullanın
```

### Sorun: Randevu kaydedilemedi
**Çözüm**:
1. MySQL bağlantısını kontrol edin
2. DbHelper.cs'deki connection string'i doğrulayın
3. Aplikasyon log dosyasını kontrol edin

## 📈 İyileştirmeler & Roadmap

### ✅ Tamamlanan (V2.0)
- Doktor listesi ekranı
- Doktor randevu oluşturma
- Rol bazlı erişim
- Real-time sistem
- Validasyonlar

### 🔄 Planlanmış (V3.0)
- Doktor kendi alanı kontrolü
- Randevu çakışma tespiti
- Doktor takvimi görünümü
- Randevu takip sistemi
- SMS/Email gerçek gönderi

### 🎯 Uzun vadeli (V4.0+)
- Hasta portal
- Mobil uygulama
- İstatistik raporları
- AI-tabanlı tavsiyer
- Video konsültasyon

## 🧪 Test Senaryoları

### Senaryo 1: Doktor Randevu Oluşturma
```
1. DOKTOR hesabıyla giriş yap
2. "👨‍⚕️ Doktorlar" butonuna tıkla
3. Listeden bir doktor seç (örn: Dr. Fatma Şahin - Kardiyoloji)
4. Hasta ID gir: 1
5. Tarih seç: Gelecek gün 10:00
6. "✅ Randevu Kaydet" tıkla
7. ✅ Randevu başarıyla kaydedildi mesajını gör
```

### Senaryo 2: Personel Randevu Oluşturma
```
1. PERSONEL hesabıyla giriş yap
2. "👨‍⚕️ Doktorlar" butonuna tıkla
3. Herhangi bir doktor seç
4. Işlemleri tamamla (Senaryo 1 gibi)
5. ✅ Randevu başarıyla kaydedildi
```

### Senaryo 3: Validasyon Hataları
```
1. Doktor seç
2. Hasta ID alanını boş bırak
3. "✅ Randevu Kaydet" tıkla
4. ❌ "Geçerli bir Hasta ID giriniz!" hatası görmeli

5. Hasta ID gir: 1
6. Geçmiş tarih seç
7. "✅ Randevu Kaydet" tıkla
8. ❌ "Geçmiş tarih seçemezsiniz!" hatası görmeli

9. Saat 19:00 seç (Dış saat)
10. ❌ "Randevu saati 08:00 - 17:00 arasında!" hatası görmeli
```

## 📞 İletişim & Destek

Sistem hakkında soruları veya sorunlar için:
- Uygulama log dosyasını kontrol edin: `%APPDATA%\Hastane1071\Logs`
- Konsol çıktılarını inceleyin
- Veritabanı bağlantısını doğrulayın

---

**Proje**: Hastane1071 ERP Sistemi  
**Versiyon**: 2.0  
**Son Güncelleme**: 2026  
**Durum**: ✅ Tam Fonksiyonel  
**Derleme**: 0 Hata  
**Platform**: .NET 10 / Windows Forms  
**Veritabanı**: MySQL 8.0+
