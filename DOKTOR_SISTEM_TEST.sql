-- Doktor ve Personel Randevu Sistemi - Veritabanı Doğrulama ve Test Script
-- Bu script'i çalıştırmak için MySQL'de hastane1071_db veritabanında yapın

USE hastane1071_db;

-- 1. TABLOLARI KONTROL ET
SHOW TABLES;

-- 2. DOKTORLAR TABLOSUNUN YAPISI
DESCRIBE Doktorlar;

-- 3. HASTALART TABLOSUNUN YAPISI
DESCRIBE Hastalar;

-- 4. RANDEVULAR TABLOSUNUN YAPISI
DESCRIBE Randevular;

-- 5. AKTIF DOKTOR SAYISI
SELECT COUNT(*) as 'Aktif Doktor Sayısı' FROM Doktorlar WHERE Statu = 'Aktif';

-- 6. TÜM DOKTORLARI LISTELE
SELECT DoktorID, Isim, Uzmanlık, Telefon, Email, Statu 
FROM Doktorlar 
ORDER BY Isim;

-- 7. HASTALAR TABLOSUNDA VERİ OLUP OLMADIĞINI KONTROL ET
SELECT COUNT(*) as 'Toplam Hasta' FROM Hastalar;

-- 8. ÖRNEK HASTA VERİSİ EKLE (eğer yoksa)
INSERT IGNORE INTO Hastalar (HastaID, TCNo, Isim, DogumTarihi, HastaTuru) VALUES
(1, '10000000001', 'Metin Yıldırım', '1980-01-15', 'Düzenli Hasta'),
(2, '10000000002', 'Selma Alphan', '1985-06-20', 'Acil Hasta'),
(3, '10000000003', 'Kerem Göktaş', '1990-03-10', 'Kronik Hasta'),
(4, '10000000004', 'Müge Serdar', '1988-09-25', 'Düzenli Hasta'),
(5, '10000000005', 'Recep Uçar', '1975-12-05', 'Kronik Hasta');

-- 9. HASTALARI KONTROL ET
SELECT HastaID, Isim, TCNo, HastaTuru FROM Hastalar ORDER BY Isim;

-- 10. ÖRNEK RANDEVU VERİSİ EKLE (gelecek tarih için)
-- NOT: Tarihi ortamınıza göre güncelleyin
INSERT IGNORE INTO Randevular (RandevuID, HastaID, DoktorID, Tarih, Statu) VALUES
(1, 1, 1, DATE_ADD(CURDATE(), INTERVAL 2 DAY), 'Aktif'),
(2, 2, 2, DATE_ADD(CURDATE(), INTERVAL 3 DAY), 'Aktif'),
(3, 3, 3, DATE_ADD(CURDATE(), INTERVAL 5 DAY), 'Aktif'),
(4, 4, 1, DATE_ADD(CURDATE(), INTERVAL 7 DAY), 'Aktif');

-- 11. TÜM RANDEVULARI DOKTOR VE HASTA BİLGİSİYLE BİRLİKTE GÖSTER
SELECT 
    r.RandevuID,
    r.Tarih,
    h.Isim as 'Hastanın Adı',
    h.TCNo,
    d.Isim as 'Doktor',
    d.Uzmanlık,
    r.Statu
FROM Randevular r
LEFT JOIN Hastalar h ON r.HastaID = h.HastaID
LEFT JOIN Doktorlar d ON r.DoktorID = d.DoktorID
ORDER BY r.Tarih DESC;

-- 12. GÜNÜMÜZ VE SONRAKI GÜNLERİN RANDEVULARINI GÖSTER
SELECT 
    r.RandevuID,
    DATE_FORMAT(r.Tarih, '%d.%m.%Y %H:%i') as 'Tarih/Saat',
    h.Isim as 'Hasta',
    d.Isim as 'Doktor',
    d.Uzmanlık,
    r.Statu
FROM Randevular r
LEFT JOIN Hastalar h ON r.HastaID = h.HastaID
LEFT JOIN Doktorlar d ON r.DoktorID = d.DoktorID
WHERE r.Tarih >= CURDATE()
ORDER BY r.Tarih;

-- 13. İSTATİSTİKLER
SELECT 
    (SELECT COUNT(*) FROM Hastalar) as 'Toplam Hasta',
    (SELECT COUNT(*) FROM Doktorlar WHERE Statu = 'Aktif') as 'Aktif Doktor',
    (SELECT COUNT(*) FROM Randevular WHERE Statu = 'Aktif') as 'Aktif Randevu',
    (SELECT COUNT(*) FROM Randevular WHERE Tarih >= CURDATE() AND Statu = 'Aktif') as 'Gelecek Randevu';

-- 14. UZMANLIKLARA GÖRE DOKTOR SAYISI
SELECT Uzmanlık, COUNT(*) as 'Doktor Sayısı'
FROM Doktorlar
WHERE Statu = 'Aktif'
GROUP BY Uzmanlık
ORDER BY 'Doktor Sayısı' DESC;
