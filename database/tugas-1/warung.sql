-- SET SQL_SAFE_UPDATES = 0;
-- SET SQL_SAFE_UPDATES = 1;

CREATE DATABASE warung2;

USE warung2;

CREATE TABLE pelanggan (
	kode_pelanggan	VARCHAR(7) PRIMARY KEY NOT NULL,
    nama_pelanggan	VARCHAR(25) NOT NULL,
    kelamin			ENUM('Pria', 'Wanita') NOT NULL,
    alamat			VARCHAR(50),
    kota			VARCHAR(15)
);

CREATE TABLE produk (
	kode_produk	VARCHAR(7) PRIMARY KEY NOT NULL,
    nama_produk	VARCHAR(25) NOT NULL,
    satuan		VARCHAR(15),
    stok		INT DEFAULT 0,
    harga		DECIMAL(10,2) NOT NULL
);

CREATE TABLE penjualan (
    no_penjualan		VARCHAR(7) PRIMARY KEY NOT NULL,
    tanggal_penjualan	DATE NOT NULL,
    kode_pelanggan		VARCHAR(7) NOT NULL,
    
    CONSTRAINT fk_penjualan_pelanggan 
        FOREIGN KEY (kode_pelanggan) REFERENCES pelanggan(kode_pelanggan)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE penjualan_detail (
    id_detail		INT AUTO_INCREMENT PRIMARY KEY,
    no_penjualan	VARCHAR(7) NOT NULL,
    kode_produk		VARCHAR(7) NOT NULL,
    qty				INT DEFAULT 1,
    harga_satuan	DECIMAL(10, 2) NOT NULL,
    subtotal		DECIMAL(12, 2) GENERATED ALWAYS AS (qty * harga_satuan) STORED,
    
    CONSTRAINT fk_detail_penjualan 
        FOREIGN KEY (no_penjualan) REFERENCES penjualan(no_penjualan)
        ON UPDATE CASCADE ON DELETE CASCADE,
        
    CONSTRAINT fk_detail_produk 
        FOREIGN KEY (kode_produk) REFERENCES produk(kode_produk)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

DELIMITER //
CREATE PROCEDURE sp_ins_pelanggan (
	IN p_kode VARCHAR(7),
    IN p_nama VARCHAR(25),
    IN p_kelamin ENUM('Pria','Wanita'),
    IN p_alamat VARCHAR(50),
    IN p_kota VARCHAR(15)
)
BEGIN
    INSERT INTO pelanggan (kode_pelanggan, nama_pelanggan, kelamin, alamat, kota)
    VALUES (p_kode, p_nama, p_kelamin, p_alamat, p_kota);
END //
DELIMITER ;

CALL sp_ins_pelanggan('PLG01', 'Mohamad', 'Pria', 'Priok', 'Jakarta');
CALL sp_ins_pelanggan('PLG02', 'Naufal', 'Pria', 'Cilincing', 'Jakarta');
CALL sp_ins_pelanggan('PLG03', 'Atila', 'Pria', 'Bojongsoang', 'Bandung');
CALL sp_ins_pelanggan('PLG04', 'Tsalsa', 'Wanita', 'Buah Batu', 'Bandung');
CALL sp_ins_pelanggan('PLG05', 'Damay', 'Wanita', 'Gubeng', 'Surabaya');
CALL sp_ins_pelanggan('PLG06', 'Tsaniy', 'Pria', 'Darmo', 'Surabaya');
CALL sp_ins_pelanggan('PLG07', 'Nabila', 'Wanita', 'Lebak Bulus', 'Jakarta');

DELIMITER //
CREATE PROCEDURE sp_upd_pelanggan (
    IN p_kode VARCHAR(7),
    IN p_nama VARCHAR(25),
    IN p_kelamin ENUM('Pria','Wanita'),
    IN p_alamat VARCHAR(50),
    IN p_kota VARCHAR(15)
)
BEGIN
    UPDATE pelanggan
    SET 
        nama_pelanggan = IFNULL(p_nama, nama_pelanggan),
        kelamin        = IFNULL(p_kelamin, kelamin),
        alamat         = IFNULL(p_alamat, alamat),
        kota           = IFNULL(p_kota, kota)
    WHERE kode_pelanggan = p_kode;
END //
DELIMITER ;

CALL sp_upd_pelanggan('PLG01', 'Mohamad Updated', NULL, NULL, NULL);

DELIMITER //
CREATE PROCEDURE sp_del_pelanggan (
    IN p_kode VARCHAR(7)
)
BEGIN
    DELETE FROM pelanggan WHERE kode_pelanggan = p_kode;
END //
DELIMITER ;

CALL sp_del_pelanggan('PLG01');

DELIMITER //
CREATE PROCEDURE sp_ins_produk (
    IN p_kode VARCHAR(7),
    IN p_nama VARCHAR(25),
    IN p_satuan VARCHAR(15),
    IN p_stok INT,
    IN p_harga DECIMAL(10,2)
)
BEGIN
    INSERT INTO produk (kode_produk, nama_produk, satuan, stok, harga)
    VALUES (p_kode, p_nama, p_satuan, IFNULL(p_stok,0), p_harga);
END //
DELIMITER ;

CALL sp_ins_produk('P001', 'Indomie', 'Bungkus', '10', '3000');
CALL sp_ins_produk('P002', 'Roti', 'Pak', '3', '3000');
CALL sp_ins_produk('P003', 'Kecap', 'Botol', '8', '3000');
CALL sp_ins_produk('P004', 'Saos Tomat', 'Botol', '8', '3000');
CALL sp_ins_produk('P005', 'Bihun', 'Bungkus', '5', '3000');
CALL sp_ins_produk('P006', 'Sikat Gigi', 'Pak', '5', '3000');
CALL sp_ins_produk('P007', 'Pasta Gigi', 'Pak', '7', '3000');
CALL sp_ins_produk('P008', 'Saos Sambal', 'Botol', '5', '3000');

DELIMITER //
CREATE PROCEDURE sp_upd_produk (
    IN p_kode VARCHAR(7),
    IN p_nama VARCHAR(25),
    IN p_satuan VARCHAR(15),
    IN p_stok INT,
    IN p_harga DECIMAL(10,2)
)
BEGIN
    UPDATE produk
    SET 
        nama_produk = IFNULL(p_nama, nama_produk),
        satuan      = IFNULL(p_satuan, satuan),
        stok        = IFNULL(p_stok, stok),
        harga       = IFNULL(p_harga, harga)
    WHERE kode_produk = p_kode;
END //
DELIMITER ;

CALL sp_upd_produk('P008', 'Saos Sambal Updated', NULL, NULL, NULL);

DELIMITER //
CREATE PROCEDURE sp_del_produk (
    IN p_kode VARCHAR(7)
)
BEGIN
    DELETE FROM produk WHERE kode_produk = p_kode;
END //
DELIMITER ;

CALL sp_del_produk('P008');

DELIMITER //
CREATE PROCEDURE sp_ins_penjualan (
    IN p_no VARCHAR(7),
    IN p_tanggal DATE,
    IN p_kode_pelanggan VARCHAR(7)
)
BEGIN
    INSERT INTO penjualan (no_penjualan, tanggal_penjualan, kode_pelanggan)
    VALUES (p_no, p_tanggal, p_kode_pelanggan);
END //
DELIMITER ;

CALL sp_ins_penjualan ('J001', '2025-09-08', 'PLG03');
CALL sp_ins_penjualan ('J002', '2025-09-08', 'PLG07');
CALL sp_ins_penjualan ('J003', '2025-09-09', 'PLG02');
CALL sp_ins_penjualan ('J004', '2025-09-10', 'PLG05');

DELIMITER //
CREATE PROCEDURE sp_upd_penjualan (
    IN p_no VARCHAR(7),
    IN p_tanggal DATE,
    IN p_kode_pelanggan VARCHAR(7)
)
BEGIN
    UPDATE penjualan
    SET 
        tanggal_penjualan = IFNULL(p_tanggal, tanggal_penjualan),
        kode_pelanggan    = IFNULL(p_kode_pelanggan, kode_pelanggan)
    WHERE no_penjualan = p_no;
END //
DELIMITER ;

CALL sp_ins_penjualan ('J001', '2020-09-08', NULL);

DELIMITER //
CREATE PROCEDURE sp_del_penjualan (
    IN p_no VARCHAR(7)
)
BEGIN
    DELETE FROM penjualan WHERE no_penjualan = p_no;
END //
DELIMITER ;

CALL sp_ins_penjualan ('J001');

DELIMITER //
CREATE PROCEDURE sp_ins_penjualan_detail (
    IN p_no VARCHAR(7),
    IN p_kode_produk VARCHAR(7),
    IN p_qty INT,
    IN p_harga DECIMAL(10,2)
)
BEGIN
    INSERT INTO penjualan_detail (no_penjualan, kode_produk, qty, harga_satuan)
    VALUES (p_no, p_kode_produk, IFNULL(p_qty,1), p_harga);
END //
DELIMITER ;

CALL sp_ins_penjualan_detail('J001', 'P001', 2, 3000);
CALL sp_ins_penjualan_detail('J001', 'P003', 1, 4700);
CALL sp_ins_penjualan_detail('J001', 'P004', 1, 5800);
CALL sp_ins_penjualan_detail('J002', 'P006', 3, 15000);
CALL sp_ins_penjualan_detail('J002', 'P007', 1, 10000);
CALL sp_ins_penjualan_detail('J003', 'P001', 5, 3000);
CALL sp_ins_penjualan_detail('J003', 'P004', 2, 5800);
CALL sp_ins_penjualan_detail('J003', 'P008', 2, 7300);
CALL sp_ins_penjualan_detail('J003', 'P003', 1, 4700);
CALL sp_ins_penjualan_detail('J004', 'P002', 3, 18000);
CALL sp_ins_penjualan_detail('J004', 'P004', 2, 5800);
CALL sp_ins_penjualan_detail('J004', 'P008', 2, 7300);
CALL sp_ins_penjualan_detail('J004', 'P006', 2, 15000);
CALL sp_ins_penjualan_detail('J004', 'P007', 1, 10000);

DELIMITER //
CREATE PROCEDURE sp_upd_penjualan_detail (
    IN p_id INT,
    IN p_qty INT,
    IN p_harga DECIMAL(10,2)
)
BEGIN
    UPDATE penjualan_detail
    SET 
        qty          = IFNULL(p_qty, qty),
        harga_satuan = IFNULL(p_harga, harga_satuan)
    WHERE id_detail = p_id;
END //
DELIMITER ;

CALL sp_ins_penjualan_detail('J001', NULL, 2, 5000);

DELIMITER //
CREATE PROCEDURE sp_del_penjualan_detail (
    IN p_id INT
)
BEGIN
    DELETE FROM penjualan_detail WHERE id_detail = p_id;
END //
DELIMITER ;

CALL sp_ins_penjualan_detail('J001');

CREATE VIEW v_pelanggan AS
SELECT kode_pelanggan, nama_pelanggan, kelamin, kota
FROM pelanggan;

SELECT * FROM v_pelanggan;

CREATE VIEW v_detail_penjualan AS
SELECT 
    p.no_penjualan,
    p.tanggal_penjualan,
    plg.nama_pelanggan,
    prd.nama_produk,
    d.qty,
    d.harga_satuan,
    d.subtotal
FROM penjualan p
JOIN pelanggan plg ON p.kode_pelanggan = plg.kode_pelanggan
JOIN penjualan_detail d ON p.no_penjualan = d.no_penjualan
JOIN produk prd ON d.kode_produk = prd.kode_produk;

SELECT * FROM v_detail_penjualan;

DELIMITER //
CREATE FUNCTION fn_total_penjualan (p_no_penjualan VARCHAR(7))
RETURNS DECIMAL(12,2)
DETERMINISTIC
BEGIN
    DECLARE v_total DECIMAL(12,2);

    SELECT SUM(subtotal)
    INTO v_total
    FROM penjualan_detail
    WHERE no_penjualan = p_no_penjualan;

    RETURN IFNULL(v_total, 0);
END //
DELIMITER ;

SELECT fn_total_penjualan('J001') AS total;
SELECT fn_total_penjualan('J002') AS total;
SELECT fn_total_penjualan('J003') AS total;
SELECT fn_total_penjualan('J004') AS total;

DELIMITER //
CREATE FUNCTION fn_total_omzet ()
RETURNS DECIMAL(12,2)
DETERMINISTIC
BEGIN
    DECLARE v_total DECIMAL(12,2);

    SELECT SUM(subtotal)
    INTO v_total
    FROM penjualan_detail;

    RETURN IFNULL(v_total, 0);
END //
DELIMITER ;

SELECT fn_total_omzet() AS omzet;

DELIMITER //
CREATE PROCEDURE sp_cari_penjualan_by_pelanggan (
    IN p_kode_pelanggan VARCHAR(7)
)
BEGIN
    SELECT *
    FROM penjualan
    WHERE kode_pelanggan = p_kode_pelanggan;
END //
DELIMITER ;

CALL sp_cari_penjualan_by_pelanggan('PLG03');
CALL sp_cari_penjualan_by_pelanggan('PLG02');
CALL sp_cari_penjualan_by_pelanggan('PLG05');
CALL sp_cari_penjualan_by_pelanggan('PLG07');