-- HASTANE1071 ERP SISTEMI - VERITABANI SETUP SCRIPT
-- Turkce karaktersiz versiyon

DROP DATABASE IF EXISTS Hastane1071;
CREATE DATABASE Hastane1071 CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE Hastane1071;

-- KULLANICI TABLOSU
CREATE TABLE KULLANICI (
    ID INT PRIMARY KEY AUTO_INCREMENT,
    KullaniciAdi VARCHAR(50) NOT NULL UNIQUE,
    Sifre VARCHAR(100) NOT NULL,
    Rol ENUM('Yonetici', 'Doktor', 'Personel') NOT NULL DEFAULT 'Personel',
    AktifMi TINYINT(1) DEFAULT 1,
    OlusturmaTarihi DATETIME DEFAULT CURRENT_TIMESTAMP,
    SonGuncellemeTarihi DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_kullanici_adi (KullaniciAdi),
    INDEX idx_rol (Rol)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO KULLANICI (KullaniciAdi, Sifre, Rol, AktifMi) VALUES
('admin', 'admin123', 'Yonetici', 1),
('doktor', 'doktor123', 'Doktor', 1),
('personel', 'personel123', 'Personel', 1);

-- HASTA TABLOSU
CREATE TABLE HASTA (
    HastaID INT PRIMARY KEY AUTO_INCREMENT,
    KullaniciID INT NOT NULL,
    TCNo VARCHAR(11) NOT NULL UNIQUE,
    Isim VARCHAR(150) NOT NULL,
    DogumTarihi DATE,
    Cinsiyet ENUM('Erkek', 'Kadin', 'Diger'),
    TelefonNo VARCHAR(20),
    EmailAdresi VARCHAR(100),
    Adres VARCHAR(255),
    HastaTuru VARCHAR(50),
    KanGrubu VARCHAR(5),
    HastalikGecmisi TEXT,
    AktifMi TINYINT(1) DEFAULT 1,
    OlusturmaTarihi DATETIME DEFAULT CURRENT_TIMESTAMP,
    SonGuncellemeTarihi DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_tc (TCNo),
    INDEX idx_ad (Isim),
    FOREIGN KEY (KullaniciID) REFERENCES KULLANICI(ID) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO HASTA (KullaniciID, TCNo, Isim, DogumTarihi, Cinsiyet, TelefonNo, EmailAdresi, Adres, HastaTuru, KanGrubu) VALUES
(3, '12345678901', 'Ahmet Yilmaz', '1980-05-15', 'Erkek', '0555-111-2222', 'ahmet@mail.com', 'Istanbul, Besiktas', 'Normal', 'O+'),
(3, '98765432101', 'Fatma Kaya', '1990-08-22', 'Kadin', '0555-333-4444', 'fatma@mail.com', 'Ankara, Cankaya', 'VIP', 'A+'),
(3, '55555555555', 'Mehmet Ozturk', '1975-03-10', 'Erkek', '0555-555-6666', 'mehmet@mail.com', 'Izmir, Alsancak', 'Normal', 'B+');

-- STOK TABLOSU
CREATE TABLE STOK (
    StokID INT PRIMARY KEY AUTO_INCREMENT,
    EsyaIsmi VARCHAR(150) NOT NULL,
    Miktar INT NOT NULL DEFAULT 0,
    Fiyat DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    KritikSeviye INT NOT NULL DEFAULT 5,
    Aciklama VARCHAR(255),
    Kategori VARCHAR(50),
    UrunKodu VARCHAR(50),
    AktifMi TINYINT(1) DEFAULT 1,
    OlusturmaTarihi DATETIME DEFAULT CURRENT_TIMESTAMP,
    SonGuncellemeTarihi DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_esya_adi (EsyaIsmi),
    INDEX idx_kategori (Kategori)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO STOK (EsyaIsmi, Miktar, Fiyat, KritikSeviye, Aciklama, Kategori, UrunKodu) VALUES
('Parasetamol 500mg', 150, 2.50, 5, 'Agri ve atesi dusuruc', 'Ilac', 'PAR-500'),
('Ampisilin 250mg', 85, 1.75, 5, 'Antibiyotik', 'Ilac', 'AMP-250'),
('Bandaj 5m x 5cm', 45, 5.00, 10, 'Tibbi bandaj rulosu', 'Malzeme', 'BAN-5M'),
('Enjeksiyoncu 3ml', 200, 0.50, 20, 'Tek kullanimlik enjeksiyoncu', 'Malzeme', 'ENJ-3ML'),
('Gazli Bez', 120, 1.00, 15, 'Steril gazli bez', 'Malzeme', 'GAZ-001'),
('Tibbi Iplik', 50, 3.50, 5, 'Cerrahi iplik', 'Malzeme', 'IPL-001');

-- RANDEVU TABLOSU
CREATE TABLE RANDEVU (
    RandevuID INT PRIMARY KEY AUTO_INCREMENT,
    HastaID INT NOT NULL,
    DoctorID INT,
    Tarih DATETIME NOT NULL,
    MuayeneNotu VARCHAR(500),
    Statu VARCHAR(50) DEFAULT 'Aktif',
    OlusturmaTarihi DATETIME DEFAULT CURRENT_TIMESTAMP,
    SonGuncellemeTarihi DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_hasta_id (HastaID),
    INDEX idx_doktor_id (DoctorID),
    INDEX idx_tarih (Tarih),
    UNIQUE INDEX idx_doktor_zaman (DoctorID, Tarih),
    FOREIGN KEY (HastaID) REFERENCES HASTA(HastaID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (DoctorID) REFERENCES KULLANICI(ID) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO RANDEVU (HastaID, DoctorID, Tarih, MuayeneNotu, Statu) VALUES
(1, 2, '2024-12-20 09:00:00', 'Baslangic muayenesi', 'Aktif'),
(2, 2, '2024-12-20 10:00:00', 'Kontrol muayenesi', 'Aktif'),
(3, 2, '2024-12-21 14:00:00', 'Duzenli kontrol', 'Aktif');

-- FATURA TABLOSU
CREATE TABLE FATURA (
    FaturaID INT PRIMARY KEY AUTO_INCREMENT,
    HastaID INT NOT NULL,
    FaturaNo VARCHAR(50) NOT NULL UNIQUE,
    FaturaTarihi DATE NOT NULL,
    OdemeSonuTarihi DATE,
    Tutar DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
    OdenenTutar DECIMAL(12, 2) DEFAULT 0.00,
    KalanTutar DECIMAL(12, 2) DEFAULT 0.00,
    Statu VARCHAR(50) DEFAULT 'Odenmedi',
    OdemeYontemi VARCHAR(50),
    Aciklama TEXT,
    OlusturmaTarihi DATETIME DEFAULT CURRENT_TIMESTAMP,
    SonGuncellemeTarihi DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE INDEX idx_fatura_no (FaturaNo),
    INDEX idx_hasta_id (HastaID),
    INDEX idx_tarih (FaturaTarihi),
    FOREIGN KEY (HastaID) REFERENCES HASTA(HastaID) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO FATURA (HastaID, FaturaNo, FaturaTarihi, OdemeSonuTarihi, Tutar, OdenenTutar, KalanTutar, Statu, OdemeYontemi) VALUES
(1, 'FAT-2024-001', '2024-12-01', '2024-12-15', 150.00, 0.00, 150.00, 'Odenmedi', 'Nakit'),
(2, 'FAT-2024-002', '2024-12-05', '2024-12-20', 250.50, 250.50, 0.00, 'Odendi', 'KrediKarti'),
(3, 'FAT-2024-003', '2024-12-10', '2024-12-25', 75.25, 50.00, 25.25, 'KismiOdendi', 'Nakit');

-- FATURA OGELERI TABLOSU
CREATE TABLE FATURA_OGESI (
    KalemID INT PRIMARY KEY AUTO_INCREMENT,
    FaturaID INT NOT NULL,
    StokID INT,
    Aciklama VARCHAR(255) NOT NULL,
    Miktar INT NOT NULL DEFAULT 1,
    BirimFiyat DECIMAL(10, 2) NOT NULL,
    KDV DECIMAL(5, 2) DEFAULT 0.00,
    Tutar DECIMAL(12, 2) NOT NULL,
    OlusturmaTarihi DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_fatura_id (FaturaID),
    INDEX idx_stok_id (StokID),
    FOREIGN KEY (FaturaID) REFERENCES FATURA(FaturaID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (StokID) REFERENCES STOK(StokID) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO FATURA_OGESI (FaturaID, StokID, Aciklama, Miktar, BirimFiyat, KDV, Tutar) VALUES
(1, 1, 'Doktor Muayenesi', 1, 100.00, 0.00, 100.00),
(1, NULL, 'Laboraturvar Testi', 1, 50.00, 18.00, 50.00),
(2, NULL, 'Operasyon', 1, 250.50, 18.00, 250.50),
(3, 1, 'Enjeksiyon', 1, 35.00, 18.00, 35.00),
(3, 2, 'Bandaj Uygulamasi', 1, 40.25, 18.00, 40.25);

-- STOK HAREKETI TABLOSU
CREATE TABLE STOK_HAREKETI (
    HareketID INT PRIMARY KEY AUTO_INCREMENT,
    StokID INT NOT NULL,
    HareketTipi ENUM('Giris', 'Cikis', 'Duzeltme') NOT NULL,
    Miktar INT NOT NULL,
    Aciklama VARCHAR(255),
    OlusturanKullanici INT,
    OlusturmaTarihi DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_stok_id (StokID),
    FOREIGN KEY (StokID) REFERENCES STOK(StokID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (OlusturanKullanici) REFERENCES KULLANICI(ID) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ODEME TABLOSU
CREATE TABLE ODEME (
    OdemeID INT PRIMARY KEY AUTO_INCREMENT,
    FaturaID INT NOT NULL,
    OdemeTarihi DATE NOT NULL,
    OdemeYontemi VARCHAR(50) NOT NULL,
    OdenenTutar DECIMAL(12, 2) NOT NULL,
    IslemNo VARCHAR(50),
    Aciklama VARCHAR(255),
    OlusturmaTarihi DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_fatura_id (FaturaID),
    FOREIGN KEY (FaturaID) REFERENCES FATURA(FaturaID) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO ODEME (FaturaID, OdemeTarihi, OdemeYontemi, OdenenTutar, IslemNo) VALUES
(2, '2024-12-06', 'KrediKarti', 250.50, 'CC-123456789'),
(3, '2024-12-12', 'Nakit', 50.00, NULL);

-- DOGRULAMA SORGUSU
SELECT 'VERITABANI KURULUMU BASARILI' AS Durum;
