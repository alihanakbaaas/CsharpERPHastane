-- Hastane1071 Veritabanı Setup Script
-- Bu dosyayı MySQL'e çalıştırın

-- Veritabanı oluştur
CREATE DATABASE IF NOT EXISTS Hastane1071;
USE Hastane1071;

-- KULLANICI Tablosu (EN ÖNEMLİ!)
CREATE TABLE IF NOT EXISTS KULLANICI (
    ID INT PRIMARY KEY AUTO_INCREMENT,
    Username VARCHAR(50) UNIQUE NOT NULL,
    Password VARCHAR(100) NOT NULL,
    Role ENUM('Yönetici', 'Doktor', 'Personel') DEFAULT 'Personel',
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX(Username)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_turkish_ci;

-- Test verilerini ekle
INSERT IGNORE INTO KULLANICI (Username, Password, Role) VALUES
('admin', 'admin123', 'Yönetici'),
('doktor', 'doktor123', 'Doktor'),
('personel', 'personel123', 'Personel');

-- HASTA Tablosu
CREATE TABLE IF NOT EXISTS HASTA (
    HastaID INT PRIMARY KEY AUTO_INCREMENT,
    Kullanici_ID INT NOT NULL,
    TCNo VARCHAR(11) UNIQUE NOT NULL,
    Isim VARCHAR(100) NOT NULL,
    DogumTarihi DATETIME,
    Hasta_Turu VARCHAR(50),
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(Kullanici_ID) REFERENCES KULLANICI(ID),
    INDEX(TCNo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_turkish_ci;

-- STOK Tablosu
CREATE TABLE IF NOT EXISTS STOK (
    StokID INT PRIMARY KEY AUTO_INCREMENT,
    EsyaIsmi VARCHAR(100) NOT NULL,
    Miktar INT DEFAULT 0,
    Fiyat DECIMAL(10,2) DEFAULT 0.00,
    KritikSeviye INT DEFAULT 10,
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX(EsyaIsmi)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_turkish_ci;

-- RANDEVU Tablosu
CREATE TABLE IF NOT EXISTS RANDEVU (
    RandevuID INT PRIMARY KEY AUTO_INCREMENT,
    HastaID INT NOT NULL,
    DoctorID INT,
    Tarih DATETIME NOT NULL,
    Statu VARCHAR(20) DEFAULT 'Aktif',
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(HastaID) REFERENCES HASTA(HastaID),
    INDEX(Tarih)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_turkish_ci;

-- FATURA Tablosu
CREATE TABLE IF NOT EXISTS FATURA (
    FaturaID INT PRIMARY KEY AUTO_INCREMENT,
    HastaID INT NOT NULL,
    FaturaTarihi DATETIME DEFAULT CURRENT_TIMESTAMP,
    Tutar DECIMAL(10,2) NOT NULL,
    FaturaNo VARCHAR(50) UNIQUE,
    Statu VARCHAR(20) DEFAULT 'Odenmedi',
    FOREIGN KEY(HastaID) REFERENCES HASTA(HastaID),
    INDEX(FaturaNo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_turkish_ci;

-- FATURA_OGESI Tablosu
CREATE TABLE IF NOT EXISTS FATURA_OGESI (
    OgeID INT PRIMARY KEY AUTO_INCREMENT,
    FaturaID INT NOT NULL,
    Aciklama VARCHAR(200),
    Tutar DECIMAL(10,2),
    FOREIGN KEY(FaturaID) REFERENCES FATURA(FaturaID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_turkish_ci;

-- Doğrulama: Tablolar ve veriler kontrol et
SELECT "✅ Veritabanı kurulumu tamamlandı!" AS Durum;
SELECT COUNT(*) as 'Kullanıcı Sayısı' FROM KULLANICI;
SELECT * FROM KULLANICI;
