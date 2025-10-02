CREATE DATABASE PS41827_QLDAN;
go
USE PS41827_QLDAN;
go
drop database PS41827_QLDAN
-- Bảng PHONGBAN
CREATE TABLE PHONGBAN (
    TENPHG VARCHAR(15),
    MAPHG INT PRIMARY KEY,
    TRPHG VARCHAR(9),
    NG_NHANCHUC DATE
);
go

-- Bảng NHANVIEN
CREATE TABLE NHANVIEN (
    HONV VARCHAR(15),
    TENLOT VARCHAR(15),
    TENNV VARCHAR(15),
    MA_NV VARCHAR(9) PRIMARY KEY,
    NGSINH DATE,
    DCHI VARCHAR(30),
    PHAI VARCHAR(3),
    LUONG FLOAT,
    MA_NQL VARCHAR(9),
    PHG INT,
    FOREIGN KEY (PHG) REFERENCES PHONGBAN(MAPHG),
    FOREIGN KEY (MA_NQL) REFERENCES NHANVIEN(MA_NV)
);
go

-- Bảng THANNHAN
CREATE TABLE THANNHAN (
    MA_NV VARCHAR(9),
    TENTN VARCHAR(15),
    PHAI VARCHAR(3),
    NGSINH DATE,
    QUANHE VARCHAR(15),
    PRIMARY KEY (MA_NV, TENTN),
    FOREIGN KEY (MA_NV) REFERENCES NHANVIEN(MA_NV)
);
go

-- Bảng DIADIEM_PHG
CREATE TABLE DIADIEM_PHG (
    MAPHG INT,
    DIADIEM VARCHAR(15),
    PRIMARY KEY (MAPHG, DIADIEM),
    FOREIGN KEY (MAPHG) REFERENCES PHONGBAN(MAPHG)
);
go

-- Bảng DEAN
CREATE TABLE DEAN (
    TENDA VARCHAR(15),
    MADA INT PRIMARY KEY,
    DDIEM_DA VARCHAR(15),
    PHONG INT,
    FOREIGN KEY (PHONG) REFERENCES PHONGBAN(MAPHG)
);
go

-- Bảng CONGVIEC
CREATE TABLE CONGVIEC (
    MADA INT,
    STT INT,
    TEN_CONG_VIEC VARCHAR(50),
    PRIMARY KEY (MADA, STT),
    FOREIGN KEY (MADA) REFERENCES DEAN(MADA)
);
go

-- Bảng PHANCONG
CREATE TABLE PHANCONG (
    MA_NVIEN VARCHAR(9),
    MADA INT,
    STT INT,
    THOIGIAN FLOAT,
    PRIMARY KEY (MA_NVIEN, MADA, STT),
    FOREIGN KEY (MA_NVIEN) REFERENCES NHANVIEN(MA_NV),
    FOREIGN KEY (MADA, STT) REFERENCES CONGVIEC(MADA, STT)
);
go

INSERT INTO PHONGBAN VALUES
('Nghiên cứu', 5, '005', '1978-05-22'),
('Điều hành', 4, '006', '1985-01-01'),
('Quản lý', 1, '006', '1971-06-19');
go

INSERT INTO NHANVIEN VALUES
('Đinh', 'Bá', 'Tiên', '009', '1960-02-11', '119 Cống Quỳnh, Tp HCM', 'Nam', 30000, '005', 5),
('Nguyễn', 'Thanh', 'Tùng', '005', '1962-08-12', '222 Nguyễn Văn Cừ, Tp HCM', 'Nam', 40000, '006', 5),
('Bùi', 'Ngọc', 'Hưng', '007', '1954-03-13', '332 Nguyễn Thái Học, Tp HCM', 'Nam', 25000, '001', 4),
('Lê', 'Văn', 'Tâm', '001', '1967-02-01', '291 Hồ Văn Huê, Tp HCM', 'Nam', 25000, NULL, 4),
('Nguyễn', 'Thanh', 'Hương', '006', '1967-09-01', '95 Bà Rịa, Vũng Tàu', 'Nữ', 30000, '004', 1),
('Trần', 'Mai', 'Thủy', '004', '1965-07-15', '34 Mai Thị Lự, Tp HCM', 'Nữ', 40000, '006', 1),
('Phạm', 'Văn', 'Vinh', '008', '1965-01-01', '45 Trưng Vương, Hà Nội', 'Nam', 55000, '001', 1);
go

INSERT INTO THANNHAN VALUES
('005', 'Trinh', 'Nữ', '1976-04-05', 'Con gái'),
('006', 'Khang', 'Nam', '1979-10-25', 'Con trai'),
('007', 'Phương', 'Nữ', '1948-03-05', 'Vợ chồng'),
('009', 'Minh', 'Nam', '1972-01-01', 'Con trai'),
('009', 'Châu', 'Nữ', '1978-12-30', 'Con gái'),
('009', 'Phương', 'Nữ', '1957-05-05', 'Vợ chồng');
go

INSERT INTO DIADIEM_PHG VALUES
(1, 'TP HCM'),
(4, 'Hà Nội'),
(5, 'TAU'),
(5, 'NHA TRANG'),
(5, 'TP HCM');
go

INSERT INTO DEAN VALUES
('Sản phẩm X', 1, 'Vũng Tàu', 5),
('Sản phẩm Y', 2, 'Nha Trang', 5),
('Sản phẩm Z', 3, 'TP HCM', 5),
('Tin học hóa', 10, 'Hà Nội', 4),
('Cáp quang', 20, 'TP HCM', 1),
('Đào tạo', 30, 'Hà Nội', 4);
go

INSERT INTO CONGVIEC VALUES
(1, 1, 'Thiết kế sản phẩm X'),
(1, 2, 'Thử nghiệm sản phẩm X'),
(2, 1, 'Sản xuất sản phẩm Y'),
(2, 2, 'Quảng cáo sản phẩm Y'),
(2, 3, 'Khuyến mãi sản phẩm Z'),
(10, 1, 'Tin học hoá phòng nhân sự'),
(10, 2, 'Tin học hoá phòng kinh doanh'),
(20, 1, 'Lắp đặt cáp quang'),
(30, 1, 'Đào tạo nhân viên Marketing'),
(30, 2, 'Đào tạo chuyên viên thiết kế');
go

INSERT INTO PHANCONG VALUES
('009', 1, 1, 32),
('008', 2, 2, 8),
('001', 2, 1, 20.0),
('004', 2, 1, 20.0),
('003', 2, 1, 20.0),
('007', 1, 1, 35),
('007', 2, 2, 5),
('007', 3, 2, 10),
('007', 10, 1, 10),
('001', 20, 1, 15),
('006', 20, 1, 25),
('005', 10, 1, 20),
('005', 10, 2, 30),
('005', 30, 1, 30),
('006', 30, 2, 20);
go

DELETE FROM PHANCONG;