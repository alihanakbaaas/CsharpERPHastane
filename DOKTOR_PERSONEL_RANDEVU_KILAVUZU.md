# 👨‍⚕️ Doktor ve Personel Randevu Sistemi - KULLANMA KILAVUZU

## 📋 Genel Bakış

Sistem artık **Doktor** ve **Personel** rollerine sahip kullanıcılar için ayrı bir randevu oluşturma ekranına sahiptir. Bu ekranda:
- Tüm aktif doktorları listeyebilir
- Doktor seçerek rapidamente bir hasta için randevu oluşturabilir
- Doktorun uzmanlık alanı otomatik olarak tarafından kontrol edilir

## 🔐 Rol Bazlı Erişim

### Admin (İşletmeci)
- Hasta, Stok, Fatura yönetimi
- Doktor listesi: **GÖRÜNTÜLEMEZ**

### Doktor
- **Doktor Listesi paneli**: Aktif
- **Doktor Randevu Oluştur**: Aktif
- Kendi alanında randevu oluşturabilir

### Personel (Sekreter)
- **Doktor Listesi paneli**: Aktif
- **Doktor Randevu Oluştur**: Aktif
- Tüm doktorlar için randevu oluşturabilir

## 🚀 Kullanım Adımları

### 1. Sisteme Giriş Yapın
```
Rol: DOKTOR veya PERSONEL
```

### 2. "👨‍⚕️ Doktorlar" Butonuna Tıklayın
- Sol alt menüde butonunuz göreceksiniz
- Tüm aktif doktorlar listelenecektir

### 3. Doktor Seçin
- Listeden istediğiniz doktora tıklayın
- Seçili doktor adı alt panelde görülecektir

### 4. Randevu Bilgilerini Girin
- **Hasta ID**: Randevu alacak hastanın ID'si
- **Tarih/Saat**: Uygun randevu saati (08:00 - 17:00)
  - Geçmiş tarih seçilemez
  - Sadece iş saatlerinde randevu verilebilir

### 5. "✅ Randevu Kaydet" Butonuna Tıklayın
- Sistem otomatik olarak validasyon yapacaktır
- Başarılı ise hasta ve doktora e-posta simulasyonu gönderilecektir

## ⚠️ Validasyonlar

| Kontrol | Gereklilik | Hata Mesajı |
|---------|-----------|-------------|
| Doktor seçimi | Zorunlu | "Lütfen önce bir doktor seçiniz!" |
| Hasta ID | Zorunlu, Pozitif | "Geçerli bir Hasta ID giriniz!" |
| Tarih | Gelecek, İş saatinde | "Geçmiş tarih seçemezsiniz!" |
| Saat | 08:00 - 17:00 | "Randevu saati 08:00 - 17:00 arasında!" |

## 🔄 Real-time Sistem

✅ Randevu oluşturulduktan sonra:
1. Veritabanında hemen kaydedilir
2. Hasta ve doktora bildirim gönderilir
3. Formlar otomatik temizlenir
4. Yeni randevular anında görüntüleye hazır

## 📊 Veritabanı Yapısı

### Doktorlar Tablosu
```sql
DoktorID      - Benzersiz ID
KullaniciID   - Giriş yapan kullanıcı (isteğe bağlı)
Isim          - Doktor adı soyadı
Uzmanlık      - Branş/Alan (Kardiyoloji, Nöroloji, vb.)
TCNo          - T.C. Kimlik Numarası
DogumTarihi   - Doğum tarihi
Telefon       - İletişim numarası
Email         - E-posta adresi
Statu         - Aktif/Pasif
```

### Doktor Örnek Verileri
```
ID | İsim                | Uzmanlık          | Statu
1  | Dr. Ahmet Yılmaz    | Genel Cerrahı     | Aktif
2  | Dr. Fatma Şahin     | Kardiyoloji       | Aktif
3  | Dr. Mehmet Kaya     | Nöroloji          | Aktif
4  | Dr. Ayşe Demir      | Ortopedi          | Aktif
5  | Dr. Hakan Çelik     | Göz Hastalıkları  | Aktif
```

## 🔧 Teknik Bilgiler

### Oluşturulan Dosyalar
1. **Hastane1071.Entities\Doktor.cs** - Doktor modeli
2. **Hastane1071.DataAccess\DoktorDAL.cs** - Veri erişim katmanı
3. **Hastane1071.Business\DoktorManager.cs** - İş mantığı katmanı

### UI Bileşenleri (Form1.cs)
- `btnDoktorlar` - Doktor listesi butonu
- `groupBoxDoktor` - Doktor listesi panel
- `dataGridViewDoktor` - Doktor tablosu
- `groupBoxDoktorRandevu` - Randevu oluşturma formu
- `seciliDoktor` - Seçili doktor cache

### Metod İmzaları
```csharp
// Doktor Manager
Task<List<Doktor>> TumDoktorlariGetirAsync()
Task<Doktor> DoktorGetirAsync(int doktorId)
Task<List<Doktor>> DoktorlariUzmanlığaGöreGetirAsync(string uzmanlık)
List<string> TumUzmanlıklariGetir()
```

## 🐛 Sorun Giderme

### "Doktor listesi boş göründüğü takdirde"
1. MySQL Workbench'te hastane1071_db veritabanını açın
2. DB_SETUP.sql script'ini çalıştırın
3. Doktor Statu = 'Aktif' olduğundan emin olun

### "Randevu kaydedilemedi hatası"
1. Hasta ID'sinin Hastalar tablosunda olup olmadığını kontrol edin
2. Doktor ID'sinin Doktorlar tablosunda olup olmadığını kontrol edin
3. Tarih/Saat validasyonlarını gözden geçirin

### "E-mail simülasyonu göründüğü takdirde"
- Bu normal bir özelliktir!
- Gerçek e-posta göndermesi için SMTP ayarları gerekir

## 📞 Destek ve Sorunlar

Herhangi bir sorun için:
1. Uygulama log dosyasını kontrol edin: `%APPDATA%\Hastane1071\Logs`
2. Console çıktılarını (Debug ekranında) gözden geçirin
3. Veritabanı bağlantısını kontrol edin

---

**Son Güncelleme**: 2026  
**Versiyon**: 2.0 (Doktor/Personel Randevu Sistemi)
