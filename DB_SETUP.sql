-- Hastane1071 Veritabanı Kontrol ve Oluşturma Scripti
-- Bu script çalıştırılması için MySQL'de hastane1071_db veritabanında çalıştırılmalıdır

-- Randevular table'ı olup olmadığını kontrol et ve gerekirse oluştur
CREATE TABLE IF NOT EXISTS Randevular (
    RandevuID INT AUTO_INCREMENT PRIMARY KEY,
    HastaID INT NOT NULL,
    DoktorID INT NOT NULL,
    Tarih DATETIME NOT NULL,
    Statu VARCHAR(50) DEFAULT 'Aktif',
    OlusturulmaTarihi DATETIME DEFAULT CURRENT_TIMESTAMP,
    GuncellemeTarihi DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (HastaID) REFERENCES Hastalar(HastaID) ON DELETE CASCADE,
    FOREIGN KEY (DoktorID) REFERENCES Doktorlar(DoktorID) ON DELETE CASCADE,

    INDEX idx_HastaID (HastaID),
    INDEX idx_DoktorID (DoktorID),
    INDEX idx_Tarih (Tarih),
    INDEX idx_Statu (Statu)
);

-- Hastalar table'ı kontrol
CREATE TABLE IF NOT EXISTS Hastalar (
    HastaID INT AUTO_INCREMENT PRIMARY KEY,
    KullaniciID INT,
    TCNo VARCHAR(11) UNIQUE NOT NULL,
    Isim VARCHAR(100) NOT NULL,
    DogumTarihi DATE,
    HastaTuru VARCHAR(50),
    OlusturulmaTarihi DATETIME DEFAULT CURRENT_TIMESTAMP,
    GuncellemeTarihi DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    INDEX idx_TCNo (TCNo),
    INDEX idx_Isim (Isim)
);

-- Doktorlar table'ı kontrol
CREATE TABLE IF NOT EXISTS Doktorlar (
    DoktorID INT AUTO_INCREMENT PRIMARY KEY,
    KullaniciID INT,
    Isim VARCHAR(100) NOT NULL,
    Uzmanlık VARCHAR(100),
    TCNo VARCHAR(11) UNIQUE,
    DogumTarihi DATE,
    Telefon VARCHAR(20),
    Email VARCHAR(100),
    Statu VARCHAR(50) DEFAULT 'Aktif',
    OlusturulmaTarihi DATETIME DEFAULT CURRENT_TIMESTAMP,
    GuncellemeTarihi DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    INDEX idx_Isim (Isim),
    INDEX idx_Uzmanlık (Uzmanlık),
    INDEX idx_Statu (Statu)
);

-- Örnek doktor verilerini ekle (eğer yoksa)
INSERT IGNORE INTO Doktorlar (DoktorID, Isim, Uzmanlık, TCNo, Telefon, Email, Statu) VALUES
(1, 'Dr. Ahmet Yılmaz', 'Genel Cerrahı', '12345678901', '+90 212 123 4567', 'ahmet.yilmaz@hospital.com', 'Aktif'),
(2, 'Dr. Fatma Şahin', 'Kardiyoloji', '12345678902', '+90 212 234 5678', 'fatma.sahin@hospital.com', 'Aktif'),
(3, 'Dr. Mehmet Kaya', 'Nöroloji', '12345678903', '+90 212 345 6789', 'mehmet.kaya@hospital.com', 'Aktif'),
(4, 'Dr. Ayşe Demir', 'Ortopedi', '12345678904', '+90 212 456 7890', 'ayse.demir@hospital.com', 'Aktif'),
(5, 'Dr. Hakan Çelik', 'Göz Hastalıkları', '12345678905', '+90 212 567 8901', 'hakan.celik@hospital.com', 'Aktif');

-- Mevcut randevuları göster
SELECT COUNT(*) as MevcutRandevuSayisi FROM Randevular;

-- Tablo yapısını göster
DESCRIBE Randevular;
