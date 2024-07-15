create database QL_KhoHang
use QL_KhoHang
drop database QL_KhoHang

create table Sanpham (
MaSP nvarchar(100) primary key,
TenSP nvarchar(100),
DVT nvarchar(20),
infoSP nvarchar(500)
)

create table Kehang(
MaKeHang nvarchar(100) primary key,
MaSP nvarchar(100),
TenSP nvarchar(100),
DVT nvarchar(20),
SoLuong int
)

create table Task (
MaTask nvarchar(100) primary key,
Thoigian nvarchar(100),
LoaiTask nvarchar(10),
MaSP nvarchar(100),
MaNV nvarchar(100),
MaKeHang nvarchar(100)
)

create table Nhanvien (
MaNV nvarchar(100) primary key,
TenNV nvarchar(100),
CCCD nvarchar(20),
Diachi nvarchar(200),
SDT nvarchar(20),
Email nvarchar(200),
Matkhau nvarchar(20),
AnhNV varchar(500),
Vaitro int
)

alter table Kehang
add constraint fk_Kehang_MaSP
Foreign key (MaSP) references Sanpham(MaSP)

alter table Task
add constraint fk_Task_MaSP
Foreign key (MaSP) references Sanpham(MaSP)

alter table Task
add constraint fk_Task_MaNV
Foreign key (MaNV) references NhanVien(MaNV)

alter table Task
add constraint fk_Kehang_MaKeHang
Foreign key (MaKeHang) references Kehang(MaKeHang)






