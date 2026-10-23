-- =============================================================================
-- PRAKTIKUM BASIS DATA - PERTEMUAN 05: DATA DEFINITION LANGUAGE (DDL)
-- NAMA      : Narti Khoirunisa
-- NIM       : 25430116
-- KELAS     : D (Semester 3)
-- PROYEK    : Toko Daring Berkah Jaya NK (NisaStore Online)
-- PARAMETER : P = (16 MOD 9) + 1 = 8 -> Batas P + 2 = 10
-- FILE      : p05_ddl_25430116.sql
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 0. INISIALISASI BASIS DATA (DAPAT DIJALANKAN ULANG DARI BASIS DATA KOSONG)
-- -----------------------------------------------------------------------------
DROP DATABASE IF EXISTS db_toko_daring_25430116;
CREATE DATABASE db_toko_daring_25430116
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;
USE db_toko_daring_25430116;

-- Nonaktifkan pengecekan foreign key sementara untuk proses drop tabel yang bersih
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS pembayaran;
DROP TABLE IF EXISTS pengiriman;
DROP TABLE IF EXISTS kurir;
DROP TABLE IF EXISTS detail_pesanan;
DROP TABLE IF EXISTS pesanan;
DROP TABLE IF EXISTS produk;
DROP TABLE IF EXISTS kategori;
DROP TABLE IF EXISTS pelanggan;
SET FOREIGN_KEY_CHECKS = 1;

-- -----------------------------------------------------------------------------
-- 1. TABEL: pelanggan
-- Master data pengguna/konsumen yang berbelanja pada sistem toko daring.
-- -----------------------------------------------------------------------------
CREATE TABLE pelanggan (
    id_pelanggan INT AUTO_INCREMENT NOT NULL,
    kode_pelanggan VARCHAR(15) NOT NULL,
    nama_pelanggan VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    no_telepon VARCHAR(20) NOT NULL,
    alamat_utama TEXT NOT NULL,
    tgl_registrasi DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    -- Kunci Primer
    CONSTRAINT pk_pelanggan PRIMARY KEY (id_pelanggan),
    
    -- Kode identifikasi pelanggan unik (CUST-0116)
    CONSTRAINT uq_pelanggan_kode UNIQUE (kode_pelanggan),
    
    -- [AB-01 P02] Setiap pelanggan wajib memiliki satu alamat email yang unik sebagai identitas akun
    CONSTRAINT uq_pelanggan_email UNIQUE (email),
    
    -- [Keamanan Data Pribadi P02] Nomor telepon kontak harus unik untuk identifikasi akun aktif
    CONSTRAINT uq_pelanggan_telepon UNIQUE (no_telepon)
) ENGINE=InnoDB;

-- -----------------------------------------------------------------------------
-- 2. TABEL: kategori
-- Klasifikasi kelompok kategori produk katalog.
-- -----------------------------------------------------------------------------
CREATE TABLE kategori (
    id_kategori INT AUTO_INCREMENT NOT NULL,
    kode_kategori VARCHAR(10) NOT NULL,
    nama_kategori VARCHAR(50) NOT NULL,
    
    -- Kunci Primer
    CONSTRAINT pk_kategori PRIMARY KEY (id_kategori),
    
    -- Kode kategori dan nama kategori bersifat unik
    CONSTRAINT uq_kategori_kode UNIQUE (kode_kategori),
    CONSTRAINT uq_kategori_nama UNIQUE (nama_kategori)
) ENGINE=InnoDB;

-- -----------------------------------------------------------------------------
-- 3. TABEL: produk
-- Master data barang/produk yang diperjualbelikan pada katalog toko daring.
-- -----------------------------------------------------------------------------
CREATE TABLE produk (
    id_produk INT AUTO_INCREMENT NOT NULL,
    kode_produk VARCHAR(15) NOT NULL,
    nama_produk VARCHAR(150) NOT NULL,
    id_kategori INT NOT NULL,
    harga_katalog DECIMAL(12,2) NOT NULL,
    stok_produk INT NOT NULL DEFAULT 0,
    stok_minimum INT NOT NULL DEFAULT 5,
    
    -- Kunci Primer
    CONSTRAINT pk_produk PRIMARY KEY (id_produk),
    
    -- Kode SKU produk bersifat unik (PRD-001)
    CONSTRAINT uq_produk_kode UNIQUE (kode_produk),
    
    -- [AB-03 P02 & AB-06 P03] Foreign key id_kategori melambangkan tabel kategori
    CONSTRAINT fk_produk_kategori FOREIGN KEY (id_kategori) 
        REFERENCES kategori(id_kategori)
        ON UPDATE CASCADE 
        ON DELETE RESTRICT,
        
    -- [Validasi Finansial] Harga jual katalog produk harus bernilai positif (> 0)
    CONSTRAINT chk_produk_harga CHECK (harga_katalog > 0),
    
    -- [AB-04 P02 & AB-06 P03] Stok produk tidak boleh negatif (>= 0)
    CONSTRAINT chk_produk_stok CHECK (stok_produk >= 0),
    
    -- [Validasi Inventaris] Batas peringatan stok minimum tidak boleh bernilai negatif
    CONSTRAINT chk_produk_stok_min CHECK (stok_minimum >= 0)
) ENGINE=InnoDB;

-- -----------------------------------------------------------------------------
-- 4. TABEL: pesanan
-- Dokumen transaksi kepala faktur pesanan (header invoice).
-- -----------------------------------------------------------------------------
CREATE TABLE pesanan (
    id_pesanan INT AUTO_INCREMENT NOT NULL,
    no_pesanan VARCHAR(20) NOT NULL,
    tgl_pesanan DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    id_pelanggan INT NOT NULL,
    alamat_kirim TEXT NOT NULL,
    total_belanja DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    ongkir DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    diskon DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    total_bayar DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    metode_bayar VARCHAR(50) NOT NULL,
    status_pesanan ENUM('Pending', 'PAID', 'Shipped', 'Completed', 'Cancelled') NOT NULL DEFAULT 'Pending',
    
    -- Kunci Primer
    CONSTRAINT pk_pesanan PRIMARY KEY (id_pesanan),
    
    -- [AB-01 P03] Nomor pesanan unik (ORD-20261006-001)
    CONSTRAINT uq_pesanan_nomor UNIQUE (no_pesanan),
    
    -- [AB-02 P02 & AB-02 P03] Foreign key id_pelanggan melambangkan tabel pelanggan
    CONSTRAINT fk_pesanan_pelanggan FOREIGN KEY (id_pelanggan) 
        REFERENCES pelanggan(id_pelanggan)
        ON UPDATE CASCADE 
        ON DELETE RESTRICT,
        
    -- [Validasi Transaksi] Total belanja dan ongkir tidak boleh bernilai negatif
    CONSTRAINT chk_pesanan_total_belanja CHECK (total_belanja >= 0),
    CONSTRAINT chk_pesanan_ongkir CHECK (ongkir >= 0),
    
    -- [AB-05 P03] Diskon subsidi voucher belanja (P = 8 -> Rp8.000) tidak boleh negatif
    CONSTRAINT chk_pesanan_diskon CHECK (diskon >= 0),
    
    -- [Integritas Finansial Snapshot] Total bayar tidak boleh negatif
    CONSTRAINT chk_pesanan_total_bayar CHECK (total_bayar >= 0)
) ENGINE=InnoDB;

-- -----------------------------------------------------------------------------
-- 5. TABEL: detail_pesanan
-- Rincian baris item barang belanjaan per transaksi pesanan (Entitas Asosiatif).
-- -----------------------------------------------------------------------------
CREATE TABLE detail_pesanan (
    id_detail_pesanan INT AUTO_INCREMENT NOT NULL,
    id_pesanan INT NOT NULL,
    id_produk INT NOT NULL,
    qty_beli INT NOT NULL,
    harga_satuan DECIMAL(12,2) NOT NULL,
    
    -- Kunci Primer
    CONSTRAINT pk_detail_pesanan PRIMARY KEY (id_detail_pesanan),
    
    -- Mencegah duplikasi produk yang sama dalam satu transaksi pesanan
    CONSTRAINT uq_detail_pesanan_item UNIQUE (id_pesanan, id_produk),
    
    -- Foreign key id_pesanan melambangkan tabel pesanan
    CONSTRAINT fk_detail_pesanan FOREIGN KEY (id_pesanan) 
        REFERENCES pesanan(id_pesanan)
        ON UPDATE CASCADE 
        ON DELETE CASCADE,
        
    -- [AB-04 P03] Foreign key id_produk melambangkan tabel produk
    CONSTRAINT fk_detail_produk FOREIGN KEY (id_produk) 
        REFERENCES produk(id_produk)
        ON UPDATE CASCADE 
        ON DELETE RESTRICT,
        
    -- [AB-03 P03 - Aturan P + 2 untuk Satu Baris (Single Row)]
    -- Parameter NIM 25430116: P = (16 MOD 9) + 1 = 8.
    -- Batas maksimal kuantitas pembelian per item produk: P + 2 = 8 + 2 = 10 item.
    -- Minimal pembelian 1 item.
    CONSTRAINT chk_detail_qty CHECK (qty_beli >= 1 AND qty_beli <= 10),
    
    -- [AB-08 P02 & AB-04 P03] Harga satuan aktual transaksi (historis) harus bernilai positif (> 0)
    CONSTRAINT chk_detail_harga CHECK (harga_satuan > 0)
) ENGINE=InnoDB;

-- Catatan Analisis Aturan P + 2 untuk Multi-Baris (Cross-Row Constraint):
-- Sesuai aturan AB-03 P03, satu nomor pesanan dibatasi memuat maksimal 10 ragam barang belanjaan (P + 2 = 10 baris).
-- Batasan jumlah baris per transaksi TIDAK DAPAT dijaga oleh klausa CHECK standar SQL karena CHECK
-- hanya mengevaluasi satu baris saat INSERT/UPDATE (intra-row) dan tidak mendukung kueri subquery agregat (COUNT(*)).
-- Oleh karena itu, batasan maksimal 10 baris item per nomor pesanan DITANDAI UNTUK DISELESAIKAN DI MODUL 14
-- menggunakan mekanisme DATABASE TRIGGER (BEFORE INSERT).

-- -----------------------------------------------------------------------------
-- 6. TABEL: kurir
-- Master data mitra ekspedisi / kurir logistik pengiriman paket pesanan.
-- -----------------------------------------------------------------------------
CREATE TABLE kurir (
    id_kurir INT AUTO_INCREMENT NOT NULL,
    nama_kurir VARCHAR(50) NOT NULL,
    kontak_kurir VARCHAR(20),
    layanan_ekspedisi VARCHAR(50) NOT NULL,
    
    -- Kunci Primer
    CONSTRAINT pk_kurir PRIMARY KEY (id_kurir)
) ENGINE=InnoDB;

-- -----------------------------------------------------------------------------
-- 7. TABEL: pengiriman
-- Dokumen pelacakan logistik dan resi pengiriman barang kepada pelanggan.
-- -----------------------------------------------------------------------------
CREATE TABLE pengiriman (
    id_pengiriman INT AUTO_INCREMENT NOT NULL,
    no_resi VARCHAR(30) NOT NULL,
    id_pesanan INT NOT NULL,
    id_kurir INT NOT NULL,
    tgl_kirim DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    tgl_diterima DATETIME NULL,
    status_kirim ENUM('diproses', 'dalam_perjalanan', 'diterima') NOT NULL DEFAULT 'diproses',
    
    -- Kunci Primer tabel pengiriman
    CONSTRAINT pk_pengiriman PRIMARY KEY (id_pengiriman),
    
    -- [AB-07 P02 & AB-07 P03] Nomor resi ekspedisi bersifat unik
    CONSTRAINT uq_pengiriman_resi UNIQUE (no_resi),
    
    -- Setiap pesanan diterbitkan tepat satu dokumen pengiriman unik (1:1)
    CONSTRAINT uq_pengiriman_pesanan UNIQUE (id_pesanan),
    
    -- Foreign key id_pesanan melambangkan tabel pesanan
    CONSTRAINT fk_pengiriman_pesanan FOREIGN KEY (id_pesanan) 
        REFERENCES pesanan(id_pesanan)
        ON UPDATE CASCADE 
        ON DELETE RESTRICT,
        
    -- [AB-07 P03] Foreign key id_kurir melambangkan tabel kurir
    CONSTRAINT fk_pengiriman_kurir FOREIGN KEY (id_kurir) 
        REFERENCES kurir(id_kurir)
        ON UPDATE CASCADE 
        ON DELETE RESTRICT
) ENGINE=InnoDB;

-- -----------------------------------------------------------------------------
-- 8. TABEL: pembayaran
-- Pencatatan verifikasi pembayaran dan bukti transfer pelanggan.
-- -----------------------------------------------------------------------------
CREATE TABLE pembayaran (
    id_pembayaran INT AUTO_INCREMENT NOT NULL,
    id_pesanan INT NOT NULL,
    metode_bayar VARCHAR(50) NOT NULL,
    tgl_bayar DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    jumlah_bayar DECIMAL(12,2) NOT NULL,
    bukti_transfer VARCHAR(255) NULL,
    status_verifikasi ENUM('menunggu', 'terverifikasi', 'ditolak') NOT NULL DEFAULT 'menunggu',
    
    -- Kunci Primer tabel pembayaran
    CONSTRAINT pk_pembayaran PRIMARY KEY (id_pembayaran),
    
    -- [AB-07 P02] Satu pesanan memiliki satu pencatatan verifikasi pembayaran unik (1:1)
    CONSTRAINT uq_pembayaran_pesanan UNIQUE (id_pesanan),
    
    -- Foreign key id_pesanan melambangkan tabel pesanan
    CONSTRAINT fk_pembayaran_pesanan FOREIGN KEY (id_pesanan) 
        REFERENCES pesanan(id_pesanan)
        ON UPDATE CASCADE 
        ON DELETE RESTRICT,
        
    -- [Integritas Pembayaran] Nominal uang yang dibayarkan harus bernilai positif (> 0)
    CONSTRAINT chk_pembayaran_nominal CHECK (jumlah_bayar > 0)
) ENGINE=InnoDB;

-- =============================================================================
-- SAMPLE DATA DUMMY UNTUK PENGUJIAN INTEGRITAS DAN VALIDASI SKEMA
-- =============================================================================

-- 1. Insert Master Kategori
INSERT INTO kategori (id_kategori, kode_kategori, nama_kategori) VALUES
(1, 'KAT-01', 'Pakaian Pria'),
(2, 'KAT-02', 'Pakaian Wanita'),
(3, 'KAT-03', 'Aksesoris');

-- 2. Insert Master Pelanggan
INSERT INTO pelanggan (id_pelanggan, kode_pelanggan, nama_pelanggan, email, password_hash, no_telepon, alamat_utama) VALUES
(1, 'CUST-0116', 'Budi Santoso', 'budi@email.com', '$2y$10$abcdef1234567890dummyhashforsecurepassword116', '081298765432', 'Jl. Kenanga Indah Blok C2, Lampung'),
(2, 'CUST-0117', 'Siti Aminah', 'siti@email.com', '$2y$10$abcdef1234567890dummyhashforsecurepassword117', '081298765433', 'Jl. Flamboyan No. 12, Metro');

-- 3. Insert Master Produk (id_kategori = 1 melambangkan kategori Pakaian Pria)
INSERT INTO produk (id_produk, kode_produk, nama_produk, id_kategori, harga_katalog, stok_produk, stok_minimum) VALUES
(1, 'PRD-001', 'Kemeja Flanel Pria', 1, 150000.00, 25, 5),
(2, 'PRD-002', 'Celana Chino Hitam', 1, 200000.00, 18, 5),
(3, 'PRD-003', 'Jaket Denim Vintage', 1, 350000.00, 10, 3);

-- 4. Insert Master Kurir
INSERT INTO kurir (id_kurir, nama_kurir, kontak_kurir, layanan_ekspedisi) VALUES
(1, 'JNE Express', '021-29278888', 'REG (Reguler)'),
(2, 'J&T Express', '021-80661888', 'EZ (Standard)');

-- 5. Insert Transaksi Pesanan (id_pelanggan = 1 melambangkan pelanggan Budi Santoso)
INSERT INTO pesanan (id_pesanan, no_pesanan, tgl_pesanan, id_pelanggan, alamat_kirim, total_belanja, ongkir, diskon, total_bayar, metode_bayar, status_pesanan) VALUES
(1, 'ORD-20261006-001', '2026-10-06 10:30:00', 1, 'Jl. Kenanga Indah Blok C2, Lampung', 550000.00, 20000.00, 8000.00, 562000.00, 'Transfer Bank BCA', 'PAID');

-- 6. Insert Detail Pesanan (id_pesanan = 1, id_produk = 1 & 2)
INSERT INTO detail_pesanan (id_detail_pesanan, id_pesanan, id_produk, qty_beli, harga_satuan) VALUES
(1, 1, 1, 1, 150000.00),
(2, 1, 2, 2, 200000.00);

-- 7. Insert Data Pengiriman (id_pengiriman = 1, id_pesanan = 1, id_kurir = 1)
INSERT INTO pengiriman (id_pengiriman, no_resi, id_pesanan, id_kurir, tgl_kirim, status_kirim) VALUES
(1, 'JNE-REG-987654321', 1, 1, '2026-10-06 14:00:00', 'dalam_perjalanan');

-- 8. Insert Verifikasi Pembayaran (id_pembayaran = 1, id_pesanan = 1)
INSERT INTO pembayaran (id_pembayaran, id_pesanan, metode_bayar, tgl_bayar, jumlah_bayar, bukti_transfer, status_verifikasi) VALUES
(1, 1, 'Transfer Bank BCA', '2026-10-06 10:45:00', 562000.00, 'bukti_transfer_ord001.jpg', 'terverifikasi');

-- =============================================================================
-- AKHIR DARI FILE p05_ddl_25430116.sql
-- =============================================================================
