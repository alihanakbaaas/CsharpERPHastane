🔧 RANDEVU LİSTESİNİN BOŞ OLMASI - TROUBLESHOOTING REHBERI
════════════════════════════════════════════════════════════

✅ KONTROL ADIMARI:

1. VERITABANINA BAĞ

LANTI KONTROL
   ├─ Server: 127.0.0.1:3307
   ├─ Database: hastane1071_db
   ├─ Username: root
   ├─ Password: CenAlihaN34.
   └─ Status: MySQL çalışıyor mı? → Services'te MySQL80 çalışmalı

2. RANDEVULAR TABLOSU KONTROL
   ├─ MySQL Workbench aç
   ├─ hastane1071_db seç
   ├─ Randevular tablosu var mı?
   ├─ Çalıştır: SHOW TABLES;
   └─ Sonuç: Randevular listelenmeli

3. VERİ KONTROL
   ├─ Çalıştır: SELECT COUNT(*) FROM Randevular;
   ├─ Sonuç: 0 ise tablo boş → Veri ekle
   └─ Sonuç: > 0 ise veri var → Kod hatası

4. HASTALAR KONTROL
   ├─ Çalıştır: SELECT COUNT(*) FROM Hastalar;
   └─ En az 1 hasta olmalı

5. DOKTORLAR KONTROL
   ├─ Çalıştır: SELECT COUNT(*) FROM Doktorlar;
   └─ En az 1 doktor olmalı

6. BAĞLI KAYITLAR KONTROL
   ├─ Çalıştır: 
   └─ SELECT r.RandevuID, r.Tarih, h.Isim, d.Ad 
        FROM Randevular r
        LEFT JOIN Hastalar h ON r.HastaID = h.HastaID
        LEFT JOIN Doktorlar d ON r.DoktorID = d.DoktorID;

════════════════════════════════════════════════════════════

❌ HATALAR VE ÇÖZÜMLERİ:

ERROR 1: "Unknown table 'Randevular'"
   └─ ÇÖZÜM: CREATE TABLE IF NOT EXISTS Randevular (...) çalıştır

ERROR 2: "Foreign key constraint fails"
   └─ ÇÖZÜM: Önce Hastalar ve Doktorlar veri ekle

ERROR 3: "No data in Randevular"
   └─ ÇÖZÜM: INSERT INTO Randevular (...) VALUES (...) çalıştır

ERROR 4: "ApplicationConfiguration.Initialize() - No database"
   └─ ÇÖZÜM: MySQL hizmetini başlat (Services → MySQL80 start)

════════════════════════════════════════════════════════════

✅ SQL SCRIPT'İ ADIM ADIM ÇALIŞTIR:

1. MySQL Workbench aç
2. hastane1071_db seç
3. New Query tab aç
4. Aşağıdaki kodu yapıştır ve Ctrl+Shift+Enter çalıştır:

---START---

USE hastane1071_db;

-- Doktorlar tablosu
CREATE TABLE IF NOT EXISTS Doktorlar (
    DoktorID INT AUTO_INCREMENT PRIMARY KEY,
    Ad VARCHAR(100) NOT NULL,
    Soyad VARCHAR(100) NOT NULL,
    Uzmanlik VARCHAR(100)
);

-- Hastalar tablosu
CREATE TABLE IF NOT EXISTS Hastalar (
    HastaID INT AUTO_INCREMENT PRIMARY KEY,
    TCNo VARCHAR(11) UNIQUE NOT NULL,
    Isim VARCHAR(100) NOT NULL,
    HastaTuru VARCHAR(50),
    DogumTarihi DATE,
    KullaniciID INT
);

-- Randevular tablosu
CREATE TABLE IF NOT EXISTS Randevular (
    RandevuID INT AUTO_INCREMENT PRIMARY KEY,
    HastaID INT NOT NULL,
    DoktorID INT NOT NULL,
    Tarih DATETIME NOT NULL,
    Statu VARCHAR(50) DEFAULT 'Aktif',
    FOREIGN KEY (HastaID) REFERENCES Hastalar(HastaID),
    FOREIGN KEY (DoktorID) REFERENCES Doktorlar(DoktorID)
);

-- Örnek veriler
INSERT IGNORE INTO Doktorlar VALUES
(1, 'Ahmet', 'Yılmaz', 'Genel Cerrahı'),
(2, 'Fatma', 'Şahin', 'Kardiyoloji');

INSERT IGNORE INTO Hastalar VALUES
(1, '12345678901', 'Hasan YILMAZ', 'Normal', '1980-01-01', 1),
(2, '12345678902', 'Ayşe ŞAHİN', 'VIP', '1985-02-15', 1);

INSERT INTO Randevular (HastaID, DoktorID, Tarih, Statu) VALUES
(1, 1, DATE_ADD(NOW(), INTERVAL 1 DAY), 'Aktif'),
(2, 2, DATE_ADD(NOW(), INTERVAL 2 DAY), 'Aktif');

-- Kontrol
SELECT * FROM Randevular;

---END---

5. Ctrl+A (select all) → Ctrl+Shift+Enter (execute)
6. Sonu: ✓ 2 randevu listelenecek

════════════════════════════════════════════════════════════

✅ UYGULAMA TARAFINDA:

1. Build yapılmış (✅ 0 hata)
2. Debug başlat (F5)
3. Login: admin/admin
4. Button5 "Randevulara Git" tıkla
5. DataGrid'de 2 randevu görünecek!

════════════════════════════════════════════════════════════
