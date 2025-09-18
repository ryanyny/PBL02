/* DDL */
# Membuat database
CREATE DATABASE IF NOT EXISTS pbl2;

/* 
Perintah IF NOT EXISTS berfungsi agar tidak error 
jika obyek yang ingin dibuat ternyata sudah ada
*/

# Menunjuk database yang digunakan
USE pbl2;

# Membuat tabel definisi
CREATE TABLE IF NOT EXISTS siswa (
	nis		VARCHAR(5),
    nama	VARCHAR(50),
 	alamat	VARCHAR(100),
 	kota	VARCHAR(25)
);

# Mengubah nama kolom dan tipe data
ALTER TABLE siswa
	CHANGE nisa nis VARCHAR(10);

# Mengubah tipe data (tanpa nama kolom)
ALTER TABLE siswa
	MODIFY nis VARCHAR(25);

# Mengubah nama kolom (tanpa tipe data)
ALTER TABLE siswa
	RENAME COLUMN nis TO nisa;
    
# Menampilkan seluruh tabel pada database
SHOW TABLES;

# Menampilkan atribut pada tabel tertentu
DESCRIBE siswa;
/* DDL */

/* DML */
# Menambahkan satu record
INSERT siswa VALUES ('1234567890', 'Ryan', 'Arcamanik', 'Bandung');

# Menambahkan beberapa record
INSERT siswa VALUES 
    ('1234567890', 'Nayeon', 'Arcamanik', 'Bandung'), 
    ('1234567890', 'Winter', 'Gubeng', 'Surabaya'), 
    ('1234567890', 'Carmen', 'Gubeng', 'Surabaya'),
    ('1234567890', 'Jihyo', 'Gambir', 'Jakarta');

UPDATE siswa
SET nis = '1209348756'
WHERE nama = 'Nayeon';

UPDATE siswa
SET nis = '0987654321'
WHERE nama = 'Winter';

UPDATE siswa
SET nis = '5647382910'
WHERE nama = 'Carmen';

UPDATE siswa
SET nis = '0912873465'
WHERE nama = 'Carmen';

ALTER TABLE siswa
	ADD PRIMARY KEY (nis);

DESCRIBE siswa;
SELECT * FROM siswa;
/* DML */



CREATE TABLE kota (
	kode	VARCHAR(1) PRIMARY KEY,
    nama	VARCHAR(10)
);

DELIMITER //
CREATE PROCEDURE sp_ins_kota (
	sp_kode VARCHAR(1),
    sp_nama VARCHAR(10)
)
BEGIN
	INSERT kota VALUES (sp_kode, sp_nama);
    SELECT * FROM kota;
END //
DELIMITER ;

CALL sp_ins_kota('1', 'Bandung');
CALL sp_ins_kota('2', 'Surabaya');
CALL sp_ins_kota('3', 'Jakarta');