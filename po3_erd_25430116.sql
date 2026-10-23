CREATE DATABASE kopma;
USE kopma;

CREATE TABLE petugas (
    id_petugas INT(11) PRIMARY KEY AUTO_INCREMENT,
    nama_petugas VARCHAR(50),
    username VARCHAR(30),
    password VARCHAR(35),
    peran_petugas ENUM('admin','kasir')
);

CREATE TABLE anggota (
    id_anggota VARCHAR(10) PRIMARY KEY,
    nama_anggota VARCHAR(100),
    jk_anggota CHAR(1),
    tempat_lahir_anggota VARCHAR(50),
    tgl_lahir_anggota DATE,
    prodi_anggota VARCHAR(100),
    no_hp_anggota VARCHAR(15),
    status_anggota VARCHAR(20),
    tgl_daftar_anggota DATE
);

CREATE TABLE pemasok (
    id_pemasok INT(11) PRIMARY KEY AUTO_INCREMENT,
    nama_pemasok VARCHAR(100),
    telp_pemasok VARCHAR(15),
    alamat_pemasok VARCHAR(200)
);

CREATE TABLE barang (
    kd_barang VARCHAR(10) PRIMARY KEY,
    nama_barang VARCHAR(100),
    kategori_barang VARCHAR(50),
    harga_jual_barang DECIMAL(10,2),
    stok_barang INT(11),
    stok_min_barang INT(11)
);

CREATE TABLE penjualan (
    no_penjualan VARCHAR(12) PRIMARY KEY,
    no_nota_penjualan VARCHAR(20),
    tgl_penjualan DATETIME,
    jml_penjualan SMALLINT(6),
    total_penjualan DECIMAL(10,2),
    id_petugas INT(11),
    id_anggota VARCHAR(10),
    bayar_penjualan DECIMAL(10,2),
    FOREIGN KEY (id_petugas) REFERENCES petugas(id_petugas),
    FOREIGN KEY (id_anggota) REFERENCES anggota(id_anggota)
);

CREATE TABLE detail_penjualan (
    no_penjualan VARCHAR(12),
    kd_barang VARCHAR(10),
    qty_detail_penjualan INT(11),
    harga_satuan_detail_penjualan DECIMAL(10,2),
    PRIMARY KEY (no_penjualan, kd_barang),
    FOREIGN KEY (no_penjualan) REFERENCES penjualan(no_penjualan),
    FOREIGN KEY (kd_barang) REFERENCES barang(kd_barang)
);

CREATE TABLE pembelian (
    id_pembelian INT(11) PRIMARY KEY AUTO_INCREMENT,
    no_faktur_pembelian VARCHAR(20),
    tgl_pembelian DATE,
    jml_pembelian INT(11),
    id_pemasok INT(11),
    status_pembelian VARCHAR(30),
    FOREIGN KEY (id_pemasok) REFERENCES pemasok(id_pemasok)
);

CREATE TABLE detail_pembelian (
    id_pembelian INT(11),
    kd_barang VARCHAR(10),
    qty_detail_pembelian INT(11),
    harga_beli_detail_pembelian DECIMAL(10,2),
    PRIMARY KEY (id_pembelian, kd_barang),
    FOREIGN KEY (id_pembelian) REFERENCES pembelian(id_pembelian),
    FOREIGN KEY (kd_barang) REFERENCES barang(kd_barang)
);