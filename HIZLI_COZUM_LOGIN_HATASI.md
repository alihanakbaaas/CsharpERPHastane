# 🔧 HIZLI ÇÖZÜM - Test Hesapları Güncellemesi

## ✅ YAPILAN DEĞIŞIKLIKLER

Test hesapları Türkçe isimlendirmeye göre güncellenmiştir:

| Rol | Eski Kullanıcı | Eski Şifre | Yeni Kullanıcı | Yeni Şifre |
|-----|---|---|---|---|
| Yönetici | admin | admin123 | admin | admin123 |
| Doktor | doctor | doctor123 | **doktor** | **doktor123** |
| Personel | staff | staff123 | **personel** | **personel123** |

## 🔧 GÜNCELLENEN DOSYALAR

1. ✅ `KullaniciDAL.cs` - SeedDefaultUsers() metodunda
2. ✅ `LoginForm.cs` - BtnTestUser_Click() metodunda
3. ✅ `DATABASE_SETUP.sql` - Test verilerinde
4. ✅ `README.md` - Test hesapları bilgisinde
5. ✅ `SETUP_GUIDE.md` - Test senaryolarında

## 📝 YENİ TEST HESAPLARI

```sql
USE Hastane1071;
SELECT * FROM KULLANICI;

-- Sonuç şöyle görünmeli:
-- ID | Username  | Password     | Role
-- 1  | admin     | admin123     | Yönetici
-- 2  | doktor    | doktor123    | Doktor
-- 3  | personel  | personel123  | Personel
```

### 3. Uygulamayı Yeniden Başlatma

```bash
# Visual Studio'da:
Ctrl+Shift+B  # Yeniden derle
Ctrl+F5       # Çalıştır (Debug olmadan)
```

### 4. Test Giriş

```
Kullanıcı Adı: doctor
Şifre: doctor123
Beklenen Sonuç: ✅ Form1 açılır
                 👤 doctor (Doktor)
                 Stoklara Git butonu: GRİ (Deaktif)
```

---

## 🚀 YENİ KULLANICI BİLGİLERİYLE GİRİŞ

### Test 1: Doktor
```
Kullanıcı Adı: doktor
Şifre: doktor123
✓ Beklenen Sonuç: Form1 açılır
                   👤 doktor (Doktor)
                   Stoklara Git: GRİ (Deaktif)
```

### Test 2: Personel
```
Kullanıcı Adı: personel
Şifre: personel123
✓ Beklenen Sonuç: Form1 açılır
                   👤 personel (Personel)
                   Stoklara Git: GRİ (Deaktif)
```

### Test 3: Yönetici (Tüm Yetkiler)
```
Kullanıcı Adı: admin
Şifre: admin123
✓ Beklenen Sonuç: Form1 açılır
                   👤 admin (Yönetici)
                   Stoklara Git: AKTIF (Yeşil)
```

---

## 📝 VERİTABANINI GÜNCELLEME

Eğer eski verileri hala kullanıyorsanız, aşağıdaki SQL'i çalıştırın:

```sql
USE Hastane1071;

-- Eski verileri sil
DELETE FROM KULLANICI WHERE Username IN ('doctor', 'staff');

-- Yeni verileri ekle
INSERT INTO KULLANICI (Username, Password, Role) VALUES
('doktor', 'doktor123', 'Doktor'),
('personel', 'personel123', 'Personel');

-- Doğrulama
SELECT * FROM KULLANICI;
```

---

## 🔧 HALA ÇALIŞMIYORSA

### Adım 1: Connection String'i Kontrol Et
```csharp
// Hastane1071.DataAccess\DbHelper.cs
private string connectionString = 
    "Server=localhost;Port=3307;Database=Hastane1071;Uid=root;Pwd=CenAlihaN34.;";

// Port 3307 doğru mu? Kontrol et:
// MySQL Workbench → Administration → Connections
```

### Adım 2: Veritabanını Sıfırla
```sql
-- Eğer sorun yaşıyorsan veritabanını sıfırla
DROP DATABASE IF EXISTS Hastane1071;
CREATE DATABASE Hastane1071;

-- Sonra DATABASE_SETUP.sql'i yeniden çalıştır
```

### Adım 3: Logs'u Kontrol Et
```
Dosya: C:\Users\akbas\AppData\Roaming\Hastane1071\Logs\

En son log dosyasını aç ve hata mesajını oku
```

### Adım 4: Debug Modunda Çalıştır
```csharp
// LoginForm.cs → BtnLogin_Click metoduna git
// Şuna ekle:

AppUtilities.Logger.LogInfo($"Giriş denemesi: {txtUser.Text}");

var user = kullaniciManager.GirisYap(txtUser.Text, txtPass.Text);

if (user != null)
{
    AppUtilities.Logger.LogInfo($"✅ Giriş başarılı: {user.Username}");
}
else
{
    AppUtilities.Logger.LogError($"❌ Hatalı giriş: {txtUser.Text}");
}
```

---

## 📋 KONTROL LİSTESİ

- [ ] DATABASE_SETUP.sql MySQL'de çalıştırıldı
- [ ] DbHelper.cs'de `Database=Hastane1071` yazıyor
- [ ] Port 3307 doğru
- [ ] Username: doctor, Password: doctor123
- [ ] Uygulamayı yeniden derledin
- [ ] Uygulamayı yeniden başlattın
- [ ] Giriş başarılı oldu ✅

---

## 🎯 BEKLENEN SONUÇ

```
GİRİŞ EKRANI:
┌────────────────────────┐
│ 🏥 HASTANE 1071 GIRIS  │
│                        │
│ 👤: doctor             │
│ 🔒: ••••••••           │
│                        │
│ [✓ Giriş Yap]          │
│ [? Test Hesapları]     │
└────────────────────────┘

                    ↓ (doctor123 girdin)

FORM1 (Ana Ekran):
┌──────────────────────────┐
│ 👤 doctor (Doktor)    🌙 │
│                          │
│ [Hastalara Git]          │
│ [Stoklara Git] ← GRİ!    │
│ [Randevulara Git]        │
│                          │
│ ┌──────────────────────┐ │
│ │ Chart (Pasta Grafiği)│ │
│ └──────────────────────┘ │
└──────────────────────────┘
```

---

## 💡 KAYNAKLAR

- **Veritabanı Setup:** `DATABASE_SETUP.sql`
- **Bağlantı Ayarları:** `Hastane1071.DataAccess/DbHelper.cs`
- **Giriş Mantığı:** `Hastane1071.DataAccess/KullaniciDAL.cs`
- **Login Formu:** `Hastane1071.UI/LoginForm.cs`

---

**Sorun çözüldü! 🎉 Eğer hala çalışmazsa lütfen son hatayı raporla.**
