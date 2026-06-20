-- Randevu Ekleme Testi için SQL
-- MySQL'de şu şekilde test edebilirsiniz:

-- 1. Hastane1071_db veritabanını seçin
USE hastane1071_db;

-- 2. Tabloların varlığını kontrol edin
SHOW TABLES LIKE 'Randevular';
SHOW TABLES LIKE 'Hastalar';
SHOW TABLES LIKE 'Doktorlar';

-- 3. Örnek randevu verisi ekleyin (eğer hastalar varsa)
-- INSERT INTO Randevular (HastaID, DoktorID, Tarih, Statu)
-- VALUES (1, 1, DATE_ADD(NOW(), INTERVAL 1 DAY), 'Aktif');

-- 4. Mevcut randevuları gösterin
SELECT r.RandevuID, 
       r.HastaID, 
       r.DoktorID, 
       r.Tarih, 
       r.Statu,
       h.Isim as HastaAdi,
       d.Ad as DoktorAd
FROM Randevular r
LEFT JOIN Hastalar h ON r.HastaID = h.HastaID
LEFT JOIN Doktorlar d ON r.DoktorID = d.DoktorID
ORDER BY r.Tarih DESC;

-- 5. Doktor listesi
SELECT DoktorID, CONCAT(Ad, ' ', Soyad) as FullName, Uzmanlik 
FROM Doktorlar;

-- 6. Hasta listesi (Doktor kaydı için)
SELECT HastaID, CONCAT(TCNo, ' - ', Isim) as HastaInfo 
FROM Hastalar 
LIMIT 10;
