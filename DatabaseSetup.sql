-- ============================================================================
-- Hastane1071 ERP Sistemi - SQL Server Veritabanı Script
-- Tüm tabloları ve temel verileri oluşturur
-- ============================================================================

-- Mevcut veritabanını kontrol et ve varsa sil
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'Hastane1071_DB')
BEGIN
    ALTER DATABASE Hastane1071_DB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE Hastane1071_DB;
END

-- Yeni veritabanını oluştur
CREATE DATABASE Hastane1071_DB;
GO

USE Hastane1071_DB;
GO

-- ============================================================================
-- Kullanıcılar Tablosu (Users Table)
-- ============================================================================
CREATE TABLE dbo.Kullanicilar
(
    ID INT PRIMARY KEY IDENTITY(1,1),
    KullaniciAdi NVARCHAR(50) NOT NULL UNIQUE,
    Sifre NVARCHAR(255) NOT NULL,
    Rol NVARCHAR(20) NOT NULL DEFAULT 'Sekreter', -- Admin, Doktor, Sekreter
    OlusturulduTarihi DATETIME DEFAULT GETDATE()
);

-- ============================================================================
-- Doktorlar Tablosu (Doctors Table)
-- ============================================================================
CREATE TABLE dbo.Doktorlar
(
    DoktorID INT PRIMARY KEY IDENTITY(1,1),
    KullaniciID INT FOREIGN KEY REFERENCES dbo.Kullanicilar(ID) ON DELETE CASCADE,
    TCNo NVARCHAR(11) UNIQUE NOT NULL,
    Isim NVARCHAR(100) NOT NULL,
    DogumTarihi DATETIME,
    Uzmanlik NVARCHAR(100),
    Telefon NVARCHAR(20),
    OlusturulduTarihi DATETIME DEFAULT GETDATE()
);

-- ============================================================================
-- Hastalar Tablosu (Patients Table)
-- ============================================================================
CREATE TABLE dbo.Hastalar
(
    HastaID INT PRIMARY KEY IDENTITY(1,1),
    KullaniciID INT FOREIGN KEY REFERENCES dbo.Kullanicilar(ID) ON DELETE CASCADE,
    TCNo NVARCHAR(11) UNIQUE NOT NULL,
    Isim NVARCHAR(100) NOT NULL,
    DogumTarihi DATETIME,
    HastaTuru NVARCHAR(50) DEFAULT 'Normal', -- Normal, Sigortalı, vs.
    OlusturulduTarihi DATETIME DEFAULT GETDATE()
);

-- ============================================================================
-- Randevular Tablosu (Appointments Table)
-- ============================================================================
CREATE TABLE dbo.Randevular
(
    RandevuID INT PRIMARY KEY IDENTITY(1,1),
    HastaID INT NOT NULL FOREIGN KEY REFERENCES dbo.Hastalar(HastaID) ON DELETE CASCADE,
    DoktorID INT FOREIGN KEY REFERENCES dbo.Doktorlar(DoktorID) ON DELETE SET NULL,
    Tarih DATETIME NOT NULL,
    Statu NVARCHAR(20) DEFAULT 'Aktif', -- Aktif, İptal, Tamamlandı
    OlusturulduTarihi DATETIME DEFAULT GETDATE(),
    -- Randevu çakışmasını önlemek için UNIQUE CONSTRAINT
    UNIQUE (DoktorID, Tarih)
);

-- ============================================================================
-- Stoklar Tablosu (Inventory Table)
-- ============================================================================
CREATE TABLE dbo.Stoklar
(
    StokID INT PRIMARY KEY IDENTITY(1,1),
    EsyaIsmi NVARCHAR(100) NOT NULL UNIQUE,
    Miktar INT DEFAULT 0,
    Fiyat DECIMAL(10,2) DEFAULT 0,
    KritikSeviye INT DEFAULT 10, -- Kritik stok seviyesi
    OlusturulduTarihi DATETIME DEFAULT GETDATE()
);

-- ============================================================================
-- Faturalar Tablosu (Invoices Table)
-- ============================================================================
CREATE TABLE dbo.Faturalar
(
    FaturaID INT PRIMARY KEY IDENTITY(1,1),
    HastaID INT NOT NULL FOREIGN KEY REFERENCES dbo.Hastalar(HastaID) ON DELETE CASCADE,
    FaturaTarihi DATETIME DEFAULT GETDATE(),
    Tutar DECIMAL(10,2) DEFAULT 0,
    FaturaNo NVARCHAR(50) UNIQUE,
    Statu NVARCHAR(20) DEFAULT 'Ödenmedi', -- Ödenmedi, Ödendi, Kısmi
    OlusturulduTarihi DATETIME DEFAULT GETDATE()
);

-- ============================================================================
-- İndeksler (Indexes)
-- ============================================================================

-- Hasta arama için indeks
CREATE INDEX IX_Hastalar_TCNo ON dbo.Hastalar(TCNo);
CREATE INDEX IX_Hastalar_Isim ON dbo.Hastalar(Isim);

-- Randevu arama için indeks
CREATE INDEX IX_Randevular_HastaID ON dbo.Randevular(HastaID);
CREATE INDEX IX_Randevular_DoktorID ON dbo.Randevular(DoktorID);
CREATE INDEX IX_Randevular_Tarih ON dbo.Randevular(Tarih);

-- Fatura arama için indeks
CREATE INDEX IX_Faturalar_HastaID ON dbo.Faturalar(HastaID);
CREATE INDEX IX_Faturalar_Statu ON dbo.Faturalar(Statu);

-- Stok arama için indeks
CREATE INDEX IX_Stoklar_EsyaIsmi ON dbo.Stoklar(EsyaIsmi);

-- ============================================================================
-- TEST VERİLERİ (Sample Data)
-- ============================================================================

-- Kullanıcıları ekle
INSERT INTO dbo.Kullanicilar (KullaniciAdi, Sifre, Rol) VALUES
('admin', 'admin123', 'Admin'),
('doktor1', 'doktor123', 'Doktor'),
('doktor2', 'doktor123', 'Doktor'),
('sekreter1', 'sekreter123', 'Sekreter');

-- Doktorları ekle
INSERT INTO dbo.Doktorlar (KullaniciID, TCNo, Isim, Uzmanlik, Telefon) VALUES
(2, '12345678901', 'Dr. Ahmet YILMAZ', 'Kardiyoloji', '0532 123 45 67'),
(3, '12345678902', 'Dr. Fatma DEMIR', 'Ortopedi', '0532 234 56 78');

-- Hastaları ekle
INSERT INTO dbo.Hastalar (KullaniciID, TCNo, Isim, HastaTuru) VALUES
(1, '98765432101', 'Mehmet ŞEN', 'Normal'),
(1, '98765432102', 'Ayşe KAYA', 'Sigortalı');

-- Randevuları ekle
INSERT INTO dbo.Randevular (HastaID, DoktorID, Tarih, Statu) VALUES
(1, 1, '2024-12-20 14:00:00', 'Aktif'),
(2, 2, '2024-12-21 10:30:00', 'Aktif');

-- Stokları ekle
INSERT INTO dbo.Stoklar (EsyaIsmi, Miktar, Fiyat, KritikSeviye) VALUES
('Serum', 50, 25.00, 10),
('Eldiven', 200, 5.50, 50),
('Maske N95', 150, 15.00, 30),
('Enjektör', 100, 2.50, 20);

-- Faturaları ekle
INSERT INTO dbo.Faturalar (HastaID, FaturaTarihi, Tutar, FaturaNo, Statu) VALUES
(1, '2024-12-20 14:30:00', 150.00, 'F2024001', 'Ödenmedi'),
(2, '2024-12-21 11:00:00', 200.00, 'F2024002', 'Ödendi');

-- ============================================================================
-- VERİTABANı KONTROL KOMUTU
-- ============================================================================
-- Bu komutu çalıştırarak veritabanının düzgün oluşturulduğunu doğrulayabilirsiniz:
-- SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo'
