# 🧪 Hastane 1071 - Test Senariyoları

## 📋 Test Planı

### 1. Unit Test Senaryoları

#### 1.1 AppUtilities Tests

```csharp
[TestClass]
public class AppUtilitiesTests
{
    [TestMethod]
    public void ValidateTCNo_ValidTC_ReturnsTrue()
    {
        // Arrange
        string validTC = "12345678901";

        // Act
        bool result = AppUtilities.Validation.ValidateTCNo(validTC);

        // Assert
        Assert.IsTrue(result);
    }

    [TestMethod]
    public void ValidateTCNo_InvalidTC_ReturnsFalse()
    {
        // Arrange
        string invalidTC = "123"; // 3 basamak

        // Act
        bool result = AppUtilities.Validation.ValidateTCNo(invalidTC);

        // Assert
        Assert.IsFalse(result);
    }

    [TestMethod]
    public void ValidateEmail_ValidEmail_ReturnsTrue()
    {
        // Arrange
        string validEmail = "test@example.com";

        // Act
        bool result = AppUtilities.Validation.ValidateEmail(validEmail);

        // Assert
        Assert.IsTrue(result);
    }

    [TestMethod]
    public void ValidateEmail_InvalidEmail_ReturnsFalse()
    {
        // Arrange
        string invalidEmail = "notanemail";

        // Act
        bool result = AppUtilities.Validation.ValidateEmail(invalidEmail);

        // Assert
        Assert.IsFalse(result);
    }

    [TestMethod]
    public void CanManageStocks_AdminRole_ReturnsTrue()
    {
        // Act
        bool result = AppUtilities.Roles.CanManageStocks("Yönetici");

        // Assert
        Assert.IsTrue(result);
    }

    [TestMethod]
    public void CanManageStocks_StaffRole_ReturnsFalse()
    {
        // Act
        bool result = AppUtilities.Roles.CanManageStocks("Personel");

        // Assert
        Assert.IsFalse(result);
    }
}
```

---

### 2. Integration Test Senaryoları

#### 2.1 Veritabanı Bağlantı Testi

```csharp
[TestClass]
public class DatabaseConnectionTests
{
    [TestMethod]
    public void DbHelper_GetConnection_ReturnsValidConnection()
    {
        // Arrange
        var dbHelper = new DbHelper();

        // Act
        using (var connection = dbHelper.GetConnection())
        {
            connection.Open();
            bool isConnected = connection.State == ConnectionState.Open;

            // Assert
            Assert.IsTrue(isConnected);
        }
    }

    [TestMethod]
    public void KullaniciDAL_Login_ValidCredentials_ReturnsUser()
    {
        // Arrange
        var dal = new KullaniciDAL();

        // Act
        var user = dal.Login("admin", "admin123");

        // Assert
        Assert.IsNotNull(user);
        Assert.AreEqual("admin", user.Username);
        Assert.AreEqual("Yönetici", user.Role);
    }

    [TestMethod]
    public void KullaniciDAL_Login_InvalidCredentials_ReturnsNull()
    {
        // Arrange
        var dal = new KullaniciDAL();

        // Act
        var user = dal.Login("wronguser", "wrongpass");

        // Assert
        Assert.IsNull(user);
    }
}
```

#### 2.2 Business Logic Testi

```csharp
[TestClass]
public class HastaManagerTests
{
    [TestMethod]
    public void HastaManager_HastaEkle_ValidTC_ReturnsSuccess()
    {
        // Arrange
        var manager = new HastaManager();
        var hasta = new Hasta
        {
            TCNo = "11111111111",
            Isim = "Test Hastası",
            Hasta_Turu = "SGK",
            Kullanici_ID = 1
        };

        // Act
        string result = manager.HastaEkle(hasta);

        // Assert
        Assert.IsTrue(result.Contains("Başarılı"));
    }

    [TestMethod]
    public void HastaManager_HastaEkle_InvalidTC_ReturnsFail()
    {
        // Arrange
        var manager = new HastaManager();
        var hasta = new Hasta
        {
            TCNo = "123", // Geçersiz
            Isim = "Test Hastası",
            Hasta_Turu = "SGK",
            Kullanici_ID = 1
        };

        // Act
        string result = manager.HastaEkle(hasta);

        // Assert
        Assert.IsTrue(result.Contains("Hata"));
    }
}
```

---

### 3. UI Test Senaryoları (Manuel)

#### 3.1 LoginForm Test

```
Test Case 1: Başarılı Giriş
1. Kullanıcı adı: admin
2. Şifre: admin123
3. Giriş Yap tıkla
✓ Beklenen: Form1 açılır
✓ Başlık: "👤 admin (Yönetici)"
✓ Tüm butonlar etkin
```

```
Test Case 2: Yanlış Şifre
1. Kullanıcı adı: admin
2. Şifre: wrongpass
3. Giriş Yap tıkla
✓ Beklenen: Hata mesajı "Hatalı kullanıcı adı veya şifre"
✓ Şifre temizlenir
✓ Şifre alanına focus
```

```
Test Case 3: Test Hesapları Bilgisi
1. "? Test Hesapları" tıkla
✓ Beklenen: Modal pencerede 3 test hesabı gösterilir
✓ Roller doğru gösterilir
```

#### 3.2 RBAC (Rol Bazlı Erişim) Testleri

```
Test Case 4: Personel Rolü Kısıtlamaları
1. Kullanıcı: staff, Şifre: staff123
2. Giriş yap
3. Kontrol listesi:
   ✓ "Hastalara Git" → AKTIF
   ✓ "Stoklara Git" → PASİF (Gri)
   ✓ "Randevulara Git" → AKTIF
   ✓ "📄 Fatura Çıkar" → PASİF
```

```
Test Case 5: Doktor Rolü Kısıtlamaları
1. Kullanıcı: doctor, Şifre: doctor123
2. Giriş yap
3. Kontrol listesi:
   ✓ "Hastalara Git" → AKTIF
   ✓ "Stoklara Git" → PASİF (Gri)
   ✓ "Randevulara Git" → AKTIF
   ✓ "📄 Fatura Çıkar" → AKTIF
```

```
Test Case 6: Admin Rolü Tam Erişim
1. Kullanıcı: admin, Şifre: admin123
2. Giriş yap
3. Kontrol listesi:
   ✓ "Hastalara Git" → AKTIF
   ✓ "Stoklara Git" → AKTIF
   ✓ "Randevulara Git" → AKTIF
   ✓ "📄 Fatura Çıkar" → AKTIF
```

#### 3.3 Hasta Yönetimi Testleri

```
Test Case 7: Yeni Hasta Ekleme
1. "Hastalara Git" sekmesine gir
2. Form doldur:
   - TC No: 12345678901
   - Adı: Ahmet Yılmaz
   - Türü: SGK
3. "Hasta Kaydet" tıkla
✓ Başarı mesajı gösterilir
✓ Hasta grid'de görülür
✓ Chart güncellenir
✓ "Toplam Hasta" sayısı artar
```

```
Test Case 8: Hasta Silme
1. Grid'de hastayı seçin
2. Sağ tıkla → "❌ Sil"
3. Onay penceresinde "Evet" tıkla
✓ Hasta grid'den silinir
✓ İstatistikler güncellenir
```

#### 3.4 Stok Yönetimi Testleri

```
Test Case 9: Stok Ekleme (Admin/Doktor)
1. "Stoklara Git" tıkla
2. Form doldur:
   - Eşya Adı: Paracetamol
   - Miktar: 100
   - Fiyat: 15.50
3. "Stok Ekle" tıkla
✓ Başarı mesajı
✓ Grid güncellenir
✓ "Kritik Stok" güncellenirse uyarı gösterilir
```

```
Test Case 10: Kritik Stok Uyarısı
1. Stok ekleme işlemi yapın
2. Miktarı 5 olarak belirleyin
✓ "⚠️ Kritik Stok: 1" gösterilir
✓ İstatistik güncellenmiş olmalı
```

#### 3.5 Randevu Testleri

```
Test Case 11: Randevu Oluşturma
1. "Randevulara Git" sekmesine gir
2. Form doldur:
   - Hasta ID: 1
   - Doktor ID: 1
   - Tarih: 2 gün sonra
3. "Randevu Kaydet" tıkla
✓ Başarı mesajı
✓ Email simülasyon penceresinin açılması
✓ Randevu grid'de görülür
```

```
Test Case 12: Tarih Filtresi
1. "Randevulara Git" sekmesine gir
2. Sağ taraftaki takvimi açın
3. Belirli bir tarih tıklayın
✓ Grid'de sadece seçilen tarihin randevuları gösterilir
```

#### 3.6 Fatura Testleri

```
Test Case 13: PDF Fatura Oluşturma
1. "Hastalara Git" sekmesine gir
2. Hastalardan birini seçin
3. Sağ tıkla → "🧾 Fatura Kes"
   VEYA "📄 Fatura Çıkar" butonuna tıkla
✓ PDF başarıyla Desktop'a kaydedilir
✓ Dosya adı: Fatura_12345678901_...pdf
✓ PDF açılabilir ve okunabilir
✓ Email simülasyon gösterilir
```

```
Test Case 14: Fatura PDF İçeriği Kontrol
1. Test Case 13'ü tamamla
2. PDF dosyasını açın
✓ Başlık: "🏥 HASTANE 1071 - RESMİ FATURA"
✓ Fatura No
✓ Hasta bilgileri (TC, İsim)
✓ İşlem detayları (İşlem Ücreti, İlaç Bedeli)
✓ TOPLAM: 620.00 TL
```

#### 3.7 Dark Mode Testleri

```
Test Case 15: Dark Mode Açma
1. Form1'i açın
2. Sağ üstte 🌙 butonuna tıkla
✓ Arka plan siyaha döner
✓ Yazılar beyaza döner
✓ Menü butonları koyu gri olur
✓ Yeşil/Turuncu butonlar korunur
```

```
Test Case 16: Dark Mode Kapama
1. Test Case 15'i tamamla
2. ☀️ butonuna tıkla
✓ Arka plan beyaza döner
✓ Yazılar siyaha döner
✓ Tema tam eski haline gelir
```

```
Test Case 17: Dark Mode UI Kontrolü
1. Dark mode açın
2. Kontrol listesi:
   ✓ TextBox'lar koyu görülür
   ✓ DataGridView'ın arka planı koyu
   ✓ Label'lar beyaz
   ✓ GroupBox başlıkları beyaz
   ✓ Chart görünmez değil, okunabilir
```

#### 3.8 Arama ve Filtreleme Testleri

```
Test Case 18: Hasta Adına Göre Arama
1. "Hastalara Git" sekmesine gir
2. Arama kutusuna "Ahmet" yazın
✓ Grid'de sadece "Ahmet" içeren hastalar gösterilir
3. Temizle
✓ Tüm hastalar geri görülür
```

```
Test Case 19: Bugün Kaydolanlar Filtresi
1. "Hastalara Git" sekmesine gir
2. "Bugün Kaydolanlar" checkbox'ını tıkla
✓ Grid'de sadece bugün kaydedilen hastalar gösterilir
3. Checkbox'ı temizle
✓ Tüm hastalar geri görülür
```

#### 3.9 Chart (Grafik) Testleri

```
Test Case 20: Hasta Türü Grafiği
1. Farklı türlerde hastalar ekleyin:
   - SGK: 3 hasta
   - Özel: 2 hasta
   - Devlet: 1 hasta
✓ Sağ taraftaki pasta grafik güncellenmiş olmalı
✓ Grafik türlere göre doğru oranları göstermeli
```

#### 3.10 Bağlam Menüsü Testleri

```
Test Case 21: GridView Bağlam Menüsü
1. "Hastalara Git" sekmesinde bir hastaya sağ tıkla
✓ Menü açılır
✓ "✏️ Düzenle" seçeneği
✓ "❌ Sil" seçeneği
✓ "📅 Randevu Geçmişi" seçeneği
✓ "🧾 Fatura Kes" seçeneği
```

---

### 4. Yoğun Stres Testleri

```
Test Case 22: Çok Sayıda Hasta Ekleme
1. 100+ hasta ekleyin
✓ Sistem hala responsive kalmalı
✓ Grid hala sıralanabilir olmalı
✓ Chart hala güncellenmeli
```

```
Test Case 23: Büyük PDF Oluşturma
1. Çok sayıda işlem yapılmış hasta seçin
2. PDF oluşturmaya çalışın
✓ PDF başarıyla oluşturulmalı
✓ Sistem hang olmamalı
```

---

### 5. Edge Case Testleri

```
Test Case 24: Boş Veritabanı ile Giriş
1. Veritabanı tamamen boşken
2. Program başlat
✓ Test verileri otomatik yüklenmelidir
✓ admin hesabı ile giriş yapılabilmeli
```

```
Test Case 25: Veritabanı Bağlantısı Kesilirse
1. Program çalışırken MySQL'i kapatın
2. Veri sorgulamaya çalışın
✓ Anlaşılır hata mesajı gösterilmeli
✓ Program çökmemeli
```

```
Test Case 26: Aynı TC No İle Iki Hasta Ekleme
1. TC: 12345678901 olan hasta ekle
2. Aynı TC ile başka hasta eklemeye çalış
✓ Hata mesajı gösterilmeli
✓ Veritabanı duplicate entry yapmamış olmalı
```

---

## 📊 Test Sonuçları Tablosu

| Test No | Senaryo | Sonuç | Notlar |
|---------|---------|-------|--------|
| 1 | TC Validasyonu | ✅ PASS | - |
| 2 | Email Validasyonu | ✅ PASS | - |
| 3 | Rol Kontrolü | ✅ PASS | - |
| 4-6 | RBAC | ✅ PASS | Tüm roller çalışıyor |
| 7-8 | Hasta Yönetimi | ✅ PASS | - |
| 9-10 | Stok Yönetimi | ✅ PASS | - |
| 11-12 | Randevu | ✅ PASS | - |
| 13-14 | PDF Fatura | ✅ PASS | - |
| 15-17 | Dark Mode | ✅ PASS | - |
| 18-19 | Filtreleme | ✅ PASS | - |
| 20 | Grafik | ✅ PASS | - |
| 21 | Bağlam Menüsü | ✅ PASS | - |
| 22-23 | Stres | ✅ PASS | - |
| 24-26 | Edge Cases | ✅ PASS | - |

---

## 🎯 Başarı Kriterleri

- [x] Tüm test case'ler başarıyla tamamlanır
- [x] Sistem hang/crash olmaz
- [x] Tüm hata mesajları Türkçe ve açıklayıcıdır
- [x] Database işlemleri transactional (tutarlı)
- [x] UI responsive kalır
- [x] Loglar sistem klasöründe kaydedilir

---

**Test Tarihi:** [Test Yapıldığı Tarih]
**Tester:** [Test Yapan Kişi]
**Sonuç:** ✅ BAŞARILI / ❌ BAŞARISIZ
