create database QL_KhoHang
use QL_KhoHang
drop database QL_KhoHang

create table Sanpham (
MaSP nvarchar(100) not null ,
TenSP nvarchar(100),
DVT nvarchar(20),
infoSP nvarchar(500)
)

create table Kehang(
MaKeHang nvarchar(100) not null ,
MaSP nvarchar(100),   --Khóa ngoại-Kệ hàng 1
TenSP nvarchar(100),
DVT nvarchar(20),
SoLuongKH int
)

create table Nhanvien (
id int identity(1,1) not null,
MaNV nvarchar(20) not null ,
Email nvarchar(50) not null,
SDT nvarchar(20),
TenNV nvarchar(50) not null,
DiaChi nvarchar(100) not null,
VaiTro tinyint not null,
CCCD nvarchar(20),
TinhTrang tinyint not null,
AnhNV varchar(500),--Chuỗi địa chỉ của ảnh 
MatKhau nvarchar(50)

)

create table Task (
idTask int identity(1,1) not null,
MaTask nvarchar(100) not null,
Thoigiangiao nvarchar(100),
LoaiTask nvarchar(10), --Nhập/Xuất
MaSP nvarchar(100),-- Khóa ngoại-Task 2
MaNV nvarchar(20),--Khóa ngoại-Task 3
Trangthai tinyint not null, -- hoàn thành/ chưa hoàn thành 
SoLuong int,
MaKeHang nvarchar(100)--Khóa ngoại- Task 4
)

create table Phieuxuat (
idPX int identity(1,1) not null,
MaPX nvarchar(100) not null,--Khóa chính-Phiếu xuất 5
Thoigian nvarchar(100),
MaNV  nvarchar(20) not null,--Khóa ngoại-Phiếu xuất 6
Trangthai tinyint not null, -- 0: Chưa hoàn thành, 1: hoàn thành 
)

create table CTPhieuxuat (
MaPX nvarchar(100),--Khóa ngoại-Chi tiết phiếu xuất 7
MaSP nvarchar(100),--Khóa ngoại-Chi tiết phiếu xuất 8
MaKeHang nvarchar(100),--Khóa ngoại-Chi tiết phiếu xuất-task 9 
Soluong int not null,--Khóa ngoại-Chi tiết phiếu xuất-task 10
MaTask nvarchar(100)--Khóa ngoại-Chi tiết phiếu xuất-task 11
)

Create table Phieunhap (
idPN int identity(1,1) not null,
MaPN nvarchar(100) not null ,--Khóa chính-Phieunhap 12
Thoigian nvarchar(100),--Thời gian user hoàn thành  
MaNV  nvarchar(20) not null,--Khóa ngoại-Phieunhap 13 
Trangthai tinyint not null, -- 0: Chưa hoàn thành, 1: hoàn thành 
)

create table CTPhieunhap (
MaPN nvarchar(100),--Khóa ngoại-Chi tiết phiếu nhập 14
MaKeHang nvarchar(100),--Khóa ngoại-Chi tiết phiếu nhập 15
MaSP nvarchar(100),--Khóa ngoại-Chi tiết phiếu nhập 16
Soluong int not null,--Khóa ngoại-Chi tiết phiếu nhập 17 
MaTask nvarchar(100)--Khóa ngoại-Chi tiết phiếu nhập 18
)

--Khóa chính
ALTER TABLE Sanpham  
ADD PRIMARY KEY (MaSP);  

ALTER TABLE KeHang
ADD PRIMARY KEY (MaKeHang);

ALTER TABLE NhanVien
ADD PRIMARY KEY (MaNV);

ALTER TABLE Task
ADD PRIMARY KEY (MaTask);

ALTER TABLE Phieuxuat
ADD PRIMARY KEY (MaPX);

ALTER TABLE Phieunhap
ADD PRIMARY KEY (MaPN);


-- Khóa Ngoại 
--Khóa ngoại của kệ hàng
alter table Kehang
add constraint fk_Kehang_MaSP
Foreign key (MaSP) references Sanpham(MaSP) --1

--Khóa ngoại của Task
alter table Task
add constraint fk_Task_MaSP
Foreign key (MaSP) references Sanpham(MaSP) --2 hoàn thành 

alter table Task
add constraint fk_Task_MaNV
Foreign key (MaNV) references NhanVien(MaNV) --3 hoàn thành 

alter table Task
add constraint fk_Kehang_MaKeHang
Foreign key (MaKeHang) references Kehang(MaKeHang) --4 hoàn thành 

--Khóa ngoại của CT phiếu nhập
alter table CTPhieunhap
add constraint fk_CTPN_MaPN
Foreign key (MaPN) references PhieuNhap(MaPN)--5 hoàn thành 

alter table CTPhieunhap
add constraint fk_CTPN_MaTask
Foreign key (MaTask) references Task(MaTask)--6 hoàn thành 

alter table CTPhieunhap
add constraint fk_CTPN_MaKeHang
Foreign key (MaKeHang) references KeHang(MaKeHang)--7 hoàn thành 

--Khóa ngoại của CT phiếu xuất
alter table CTPhieuxuat
add constraint fk_CTPX_MaPX
Foreign key (MaPX) references Phieuxuat(MaPX)--8 hoàn thành 

alter table CTPhieuxuat
add constraint fk_CTPX_MaTask
Foreign key (MaTask) references Task(MaTask)--9 hoàn thành

alter table CTPhieuxuat
add constraint fk_CTPX_MaKeHang
Foreign key (MaKeHang) references KeHang(MaKeHang)--10 hoàn thành 

--KHóa ngoại của Phiếu nhâp
alter table Phieunhap 
add constraint fk_Phieunhap_MaNV
Foreign key (MaNV) references NhanVien(MaNV)--11 hoàn thành 
--Khóa ngoại của Phiếu xuất
alter table Phieuxuat 
add constraint fk_Phieuxuat_MaNV
Foreign key (MaNV) references NhanVien(MaNV)--12 hoàn thành 



--Đăng Nhập
Create procedure DangNhap @email nvarchar(20),
						  @matkhau nvarchar(50)
as 
begin 
	declare @status int
	 if exists(select * from NhanVien where Email =@email and MatKhau = @matkhau)
	    set @status =1
	 else 
	   set @status =0
	   select @status
end

--Quên mật khẩu
create procedure QuenMatKhau @email nvarchar(50)
as
begin 
     declare @status int 
	 if exists(select * from NhanVien where Email =@email )
	    set @status =1
	 else 
	   set @status =0
	   select @status
end

--Tạo mật khẩu mới 
create procedure TaoMatKhauMoi @email nvarchar(20),
                               @matkhau nvarchar(50)
as
  begin
       update NhanVien set MatKhau = @matkhau 
	   where Email = @email
  end

  -- Lấy vai trò nhân viên
  create procedure LayVaiTroNV @email nvarchar(20)
as
  begin 
       declare @status int 
	 if exists(select VaiTro from NhanVien where Email =@email )
	    set @status =1
	 else 
	   set @status =0
	   select @status
 end

 -- Thay đổi mật khẩu 
 create procedure ThayDoimatKhau (@email nvarchar(20),
                                  @opwd nvarchar(50),
								  @npwd nvarchar(50))
as
  declare @op nvarchar(50)
  select @op= MatKhau from NhanVien where Email = @email
  if @op = @opwd
  begin 
       update NhanVien set MatKhau = @npwd where Email = @email
	   return 1
  end
  else 
       return -1

-- Danh sách nhân viên
create procedure DanhSachNV as 
begin
     select Email, TenNV, DiaChi, VaiTro, TinhTrang
	 from NhanVien
end

--Thêm Nhân viên
create procedure InsertNhanVien 
                                @email nvarchar(50),
								@tennv nvarchar(50),
								@diachi nvarchar(100),
								@vaitro tinyint,
								@cccd nvarchar(20),
								@tinhtrang tinyint
as 
  begin 
       declare @Manv nvarchar(20);
	   declare @Id int;

	   select @Id = ISNULL(MAX(ID),0) + 1 from NhanVien
	   select @Manv = 'NV' + Right('0000' + CAST(@Id AS nvarchar(4)),4)
	   insert into NhanVien (MaNV, Email, TenNV, DiaChi, VaiTro, TinhTrang) values 
	   (@Manv, @email, @tennv, @diachi, @vaitro, @tinhtrang) 
 end

 -- Sửa nhân viên
 create procedure UpdateNhanVien 
                                 @email nvarchar(50),
								@tennv nvarchar(50),
								@diachi nvarchar(100),
								@vaitro tinyint,
								@tinhtrang tinyint
as
  begin
       update NhanVien set TenNV = @tennv, DiaChi = @diachi,
	                       VaiTro = @vaitro, TinhTrang= @tinhtrang
		where Email = @email
 end

 -- Xoá nhân viên
 create procedure DeleteNhanVien @email nvarchar(50)
 as 
   begin
        delete from NhanVien where Email = @email
	end
                     
-- Tìm kiếm Nhân Viên  
create procedure SearchNhanVien @tenNV nvarchar(50)
as
  begin 
      set nocount on;
	  select Email, TenNV, DiaChi, VaiTro, TinhTrang
	  from NhanVien where TenNV like + '%' +@tenNV + '%' 
  end
-- Tạo task
create procedure InsertTask
				@thoigiantao nvarchar(100),
				@loaitask nvarchar(10),
				@masp nvarchar(100),
				@manv nvarchar(20),
				@trangthai tinyint,
				@soluong int,
				@makehang nvarchar(100)
as 
	begin
		declare @matask nvarchar(20);
		declare @Id int;
		--Tạo mã task
		Select @Id =ISNULL(Max(idTask),0)+1 from Task;
		Select @matask = 'T' +Right('0000' + cast(@Id as nvarchar(4)),4);
		-- Tạo MaPN hoac hoặc MaPX dựa vào loaitask
		Declare @MaPN nvarchar(100);
		Declare @MaPX nvarchar(100);

		If @loaitask = 1 --1 là phiếu nhập
		Begin 
			SELECT @Id = ISNULL(Max(idPN),0)+1 from Phieunhap; 
			SELECT @MaPN = 'PN' + RIGHT('0000' + CAST(@Id AS NVARCHAR(4)), 4);  
		
			INSERT INTO PhieuNhap (MaPN, Thoigian, MaNV,Trangthai)  
		    VALUES (@MaPN, @thoigiantao, @manv,0); -- 0: chưa hoàn thành /1: hòan thành 
		
			INSERT INTO CTPhieunhap (MaPN,MaTask, MaSP, MaKeHang,Soluong)  
			VALUES (@MaPN, @matask, @masp,@makehang,@soluong);  
		END
		ELSE IF @loaitask =2 --2 là phiếu xuất
		Begin 
			SELECT @Id = ISNULL(Max(idPX),0)+1 from Phieuxuat;
			SELECT @MaPX = 'PX' + RIGHT('0000' + CAST(@Id AS NVARCHAR(4)), 4);
			
			INSERT INTO Phieuxuat(MaPX, Thoigian, MaNV,Trangthai)  
		    VALUES (@MaPX, @thoigiantao, @manv,0); -- 0: chưa hoàn thành /1: hòan thành 
		
			INSERT INTO CTPhieuxuat(MaPX,MaTask, MaSP, MaKeHang,Soluong)  
			VALUES (@MaPN, @matask, @masp,@makehang,@soluong);  
		END
		--Thêm thông tin vào bảng task
		Insert into Task (MaTask,LoaiTask,MaNV,MaKeHang,MaSP,SoLuong,Thoigiangiao,Trangthai)
        Values(@matask,@loaitask,@manv,@makehang,@masp,@soluong,@thoigiantao,0);-- 0: chưa hoàn thành /1: hòan thành 
End
--Phiếu Nhập sản phẩm 
Create procedure Nhaphang
			@matask nvarchar(100),
			@makehang nvarchar(100),
			@masp nvarchar(100),
			@soluong int,
			@Thoigian nvarchar(100),
			@Trangthai tinyint
AS 
BEGIN
If @Trangthai =1 --Đã hoàn thành 
Begin	

end 
else if @trangthai =0 --chưa hoàn thành
begin 

end
	

-- Thống kê kệ hàng dựa theo mã sản phẩm 
CREATE PROCEDURE spThongKeKehangTheoMaSP
    @MaSP nvarchar(100)
AS
BEGIN
    -- Kiểm tra xem sản phẩm có tồn tại trong kệ hàng không
    IF EXISTS (SELECT 1 FROM Kehang WHERE MaSP = @MaSP)
    BEGIN
        -- Thực hiện truy vấn để thống kê kệ hàng theo mã sản phẩm
        SELECT MaSP, SoLuongKH
        FROM Kehang
        WHERE MaSP = @MaSP
    END
    ELSE
    BEGIN
        RAISERROR('Sản phẩm không tồn tại trong kệ hàng.', 16, 1)
    END
END

--Thống kê sô lượng sản phẩm nhập xuất theo mã nhân viên
CREATE PROCEDURE spThongKeNhapXuatTheoMaNV
    @MaNV nvarchar(100)
AS
BEGIN
    -- Thống kê số lượng sản phẩm nhập và xuất theo mã nhân viên
    SELECT 
        Nhanvien.MaNV,
        Nhanvien.TenNV,
        SUM(CASE WHEN Task.LoaiTask = 'Nhập' THEN Task.SoLuong ELSE 0 END) AS SoLuongNhap,
        SUM(CASE WHEN Task.LoaiTask = 'Xuất' THEN Task.SoLuong ELSE 0 END) AS SoLuongXuat
    FROM Task
    INNER JOIN Nhanvien ON Task.MaNV = Nhanvien.MaNV
    WHERE Task.MaNV = @MaNV
    GROUP BY Nhanvien.MaNV, Nhanvien.TenNV
END