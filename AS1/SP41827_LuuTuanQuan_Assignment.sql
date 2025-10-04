CREATE DATABASE QLNHATRO_QuanPS41827;
GO

USE QLNHATRO_QuanPS41827

CREATE TABLE LOAINHA (
    MaLoai INT PRIMARY KEY IDENTITY(1,1),
    TenLoai NVARCHAR(100) NOT NULL
);
GO

CREATE TABLE NGUOIDUNG (
    MaNguoiDung INT PRIMARY KEY IDENTITY(1,1),
    TenNguoiDung NVARCHAR(100) NOT NULL,
    GioiTinh NVARCHAR(10) CHECK (GioiTinh IN (N'Nam', N'Nữ')),
    DienThoai VARCHAR(15),
    SoNha NVARCHAR(50),
    Duong NVARCHAR(100),
    Phuong NVARCHAR(50),
    Quan NVARCHAR(50),
    Email NVARCHAR(100) NOT NULL
);
GO

CREATE TABLE NHATRO (
    MaNhaTro INT PRIMARY KEY IDENTITY(1,1),
    MaLoai INT FOREIGN KEY REFERENCES LOAINHA(MaLoai),
    DienTich FLOAT CHECK (DienTich > 0),
    GiaTien MONEY CHECK (GiaTien >= 0),
    SoNha NVARCHAR(50),
    Duong NVARCHAR(100),
    Phuong NVARCHAR(50),
    Quan NVARCHAR(50),
    MoTa NVARCHAR(MAX),
    NgayDangTin DATE,
    MaNguoiLienHe INT FOREIGN KEY REFERENCES NGUOIDUNG(MaNguoiDung)
);
GO

CREATE TABLE DANHGIA (
    MaDanhGia INT PRIMARY KEY IDENTITY(1,1),
    MaNguoiDung INT FOREIGN KEY REFERENCES NGUOIDUNG(MaNguoiDung),
    MaNhaTro INT FOREIGN KEY REFERENCES NHATRO(MaNhaTro),
    TrangThai NVARCHAR(10) CHECK (TrangThai IN ('LIKE', 'DISLIKE')),
    NoiDung NVARCHAR(MAX)
);
GO

INSERT INTO LOAINHA (TenLoai) VALUES
(N'Căn hộ chung cư'), 
(N'Phòng trọ khép kín'), 
(N'Nhà nguyên căn');
GO

INSERT INTO NGUOIDUNG (TenNguoiDung, GioiTinh, DienThoai, SoNha, Duong, Phuong, Quan, Email) VALUES
(N'Trần Văn Nam', N'Nam', '0912345678', '12', N'Giải Phóng', N'Phương Mai', N'Đống Đa', 'namtv@example.com'),
(N'Lê Thị Hoa', N'Nữ', '0934567890', '45', N'Trần Duy Hưng', N'Trung Hòa', N'Cầu Giấy', 'hoaltt@example.com'),
(N'Nguyễn Văn Tùng', N'Nam', '0967890123', '23', N'Xã Đàn', N'Nam Đồng', N'Đống Đa', 'tungnv@example.com'),
(N'Phạm Thị Linh', N'Nữ', '0987654321', '78', N'Nguyễn Trãi', N'Khương Trung', N'Thanh Xuân', 'linhpt@example.com'),
(N'Hoàng Văn Khánh', N'Nam', '0943217890', '16', N'Lê Văn Lương', N'Nhân Chính', N'Thanh Xuân', 'khanhhv@example.com'),
(N'Vũ Thị Mai', N'Nữ', '0901234567', '5', N'Cầu Giấy', N'Dịch Vọng', N'Cầu Giấy', 'maivt@example.com'),
(N'Ngô Văn Hưng', N'Nam', '0933456789', '32', N'Hoàng Quốc Việt', N'Nghĩa Đô', N'Cầu Giấy', 'hungnv@example.com'),
(N'Đặng Thị Hòa', N'Nữ', '0976543210', '27', N'Tây Sơn', N'Quang Trung', N'Đống Đa', 'hoadtt@example.com'),
(N'Trịnh Văn Hậu', N'Nam', '0911122233', '88', N'Kim Giang', N'Hạ Đình', N'Thanh Xuân', 'hautv@example.com'),
(N'Nguyễn Thị Hằng', N'Nữ', '0922334455', '14', N'Chùa Bộc', N'Quang Trung', N'Đống Đa', 'hangnt@example.com');
GO

INSERT INTO NHATRO (MaLoai, DienTich, GiaTien, SoNha, Duong, Phuong, Quan, MoTa, NgayDangTin, MaNguoiLienHe) VALUES
(1, 30.5, 1700000, '12', N'Giải Phóng', N'Phương Mai', N'Đống Đa', N'Phòng sạch đẹp, đầy đủ tiện nghi', '2025-05-01', 1),
(2, 20.0, 1200000, '45', N'Trần Duy Hưng', N'Trung Hòa', N'Cầu Giấy', N'Phòng khép kín, gần trường học', '2025-05-02', 2),
(3, 45.0, 3000000, '23', N'Xã Đàn', N'Nam Đồng', N'Đống Đa', N'Nhà nguyên căn, phù hợp nhóm bạn', '2025-05-03', 3),
(2, 25.0, 1500000, '78', N'Nguyễn Trãi', N'Khương Trung', N'Thanh Xuân', N'Phòng đầy đủ đồ dùng', '2025-05-04', 4),
(1, 35.0, 2200000, '16', N'Lê Văn Lương', N'Nhân Chính', N'Thanh Xuân', N'Căn hộ mới, view đẹp', '2025-05-05', 5),
(3, 50.0, 3500000, '5', N'Cầu Giấy', N'Dịch Vọng', N'Cầu Giấy', N'Nhà riêng có sân', '2025-05-06', 6),
(1, 40.0, 2500000, '32', N'Hoàng Quốc Việt', N'Nghĩa Đô', N'Cầu Giấy', N'Căn hộ tiện nghi, gần công viên', '2025-05-07', 7),
(2, 28.0, 1600000, '27', N'Tây Sơn', N'Quang Trung', N'Đống Đa', N'Phòng riêng tư, an ninh tốt', '2025-05-08', 8),
(2, 22.0, 1300000, '88', N'Kim Giang', N'Hạ Đình', N'Thanh Xuân', N'Phòng gần chợ, yên tĩnh', '2025-05-09', 9),
(3, 60.0, 4000000, '14', N'Chùa Bộc', N'Quang Trung', N'Đống Đa', N'Nhà nguyên căn tiện nghi, có ban công', '2025-05-10', 10);
GO

INSERT INTO DANHGIA (MaNguoiDung, MaNhaTro, TrangThai, NoiDung) VALUES
(2, 1, 'LIKE', N'Phòng sạch sẽ, an ninh tốt.'),
(3, 1, 'LIKE', N'Rất hài lòng với vị trí.'),
(4, 2, 'DISLIKE', N'Phòng hơi chật và cũ.'),
(5, 3, 'LIKE', N'Rộng rãi, phù hợp nhóm bạn.'),
(6, 4, 'DISLIKE', N'Tiếng ồn từ đường khá lớn.'),
(7, 5, 'LIKE', N'Căn hộ tiện nghi, view đẹp.'),
(8, 6, 'LIKE', N'Nhà riêng có sân để xe.'),
(9, 7, 'LIKE', N'Phòng gần công viên, thoáng mát.'),
(10, 8, 'DISLIKE', N'Phòng hơi nóng vào mùa hè.'),
(1, 9, 'LIKE', N'Rất tiện nghi và giá hợp lý.');



