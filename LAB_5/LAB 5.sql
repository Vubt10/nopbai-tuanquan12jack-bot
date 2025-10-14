USE PS41827_QLDA
GO

--BAI 1
--In ra dòng ‘Xin chào’ + @ten
CREATE PROCEDURE HelloVietnameseName
    @ten NVARCHAR(100)
AS
BEGIN
    PRINT N'Xin chào ' + @ten;
END;

EXEC HelloVietnameseName @ten = N'Nguyễn Văn A';

--Nhập 2 số @s1, @s2. In ra ‘Tổng là: @tg’
CREATE PROCEDURE TinhTong
    @s1 INT,
    @s2 INT
AS
BEGIN
    DECLARE @tg INT;
    SET @tg = @s1 + @s2;
    PRINT N'Tổng là: ' + CAST(@tg AS NVARCHAR);
END;
-- THUC THI
EXEC TinhTong @s1 = 5, @s2 = 10;

--Nhập số nguyên @n. In ra tổng các số chẵn từ 1 đến @n
CREATE PROCEDURE TongChan
    @n INT
AS
BEGIN
    DECLARE @i INT = 1;
    DECLARE @tong INT = 0;

    WHILE @i <= @n
    BEGIN
        IF @i % 2 = 0
            SET @tong = @tong + @i;
        SET @i = @i + 1;
    END

    PRINT N'Tổng các số chẵn từ 1 đến ' + CAST(@n AS NVARCHAR) + N' là: ' + CAST(@tong AS NVARCHAR);
END;

-- THUC THI
EXEC TongChan @n = 10;

--Nhập vào 2 số. In ra Ước chung lớn nhất (UCLN)
CREATE PROCEDURE TinhUCLN
    @a INT,
    @b INT
AS
BEGIN
    DECLARE @temp INT;

    -- Đảm bảo a <= b
    IF @a > @b
    BEGIN
        SET @temp = @a;
        SET @a = @b;
        SET @b = @temp;
    END

    -- Thuật toán Euclid tìm UCLN
    WHILE @a != 0
    BEGIN
        SET @temp = @a;
        SET @a = @b % @a;
        SET @b = @temp;
    END

    PRINT N'Ước chung lớn nhất là: ' + CAST(@b AS NVARCHAR);
END;
--THUC THI
EXEC TinhUCLN @a = 18, @b = 24;

--BAI 2
--Xuất thông tin nhân viên theo mã @Manv
CREATE PROCEDURE sp_XuatNhanVienTheoMa
    @Manv NVARCHAR(9)
AS
BEGIN
    SELECT * FROM NHANVIEN WHERE MANV = @Manv;
END;
--THUC THI
EXEC sp_XuatNhanVienTheoMa @Manv = '001';

--Số lượng nhân viên tham gia đề án @MaDa (dựa vào bảng PHANCONG)
CREATE PROCEDURE sp_SoLuongNhanVienTheoDeAn
    @MaDa INT
AS
BEGIN
    SELECT COUNT(DISTINCT MA_NVIEN) AS SoLuong
    FROM PHANCONG
    WHERE MADA = @MaDa;
END;
--THUC THI
CREATE PROCEDURE sp_SoLuongNhanVienTheoDeAn
    @MaDa INT
AS
BEGIN
    SELECT COUNT(DISTINCT MA_NVIEN) AS SoLuong
    FROM PHANCONG
    WHERE MADA = @MaDa;
END;
--THUC THI
EXEC sp_SoLuongNhanVienTheoDeAn @MaDa = 10;

--Số lượng nhân viên tham gia đề án theo mã @MaDa và địa điểm @Ddiem_DA
CREATE PROCEDURE sp_SoLuongNV_MaVaDiaDiem
    @MaDa INT,
    @Ddiem_DA NVARCHAR(15)
AS
BEGIN
    SELECT COUNT(DISTINCT PC.MA_NVIEN) AS SoLuong
    FROM PHANCONG PC
    JOIN DEAN DA ON PC.MADA = DA.MADA
    WHERE DA.MADA = @MaDa AND DA.DDIEM_DA = @Ddiem_DA;
END;
--THUC THI
EXEC sp_SoLuongNV_MaVaDiaDiem @MaDa = 10, @Ddiem_DA = N'Hà Nội';

--Xuất nhân viên thuộc trưởng phòng @Trphg và không có thân nhân
CREATE PROCEDURE sp_NhanVienKhongThanNhan_TheoTP
    @Trphg NVARCHAR(9)
AS
BEGIN
    SELECT NV.*
    FROM NHANVIEN NV
    JOIN PHONGBAN PB ON NV.PHG = PB.MAPHG
    WHERE PB.TRPHG = @Trphg
      AND NOT EXISTS (
          SELECT 1 FROM THANNHAN TN WHERE TN.MA_NVIEN = NV.MANV
      );
END;
--THUC THI
EXEC sp_NhanVienKhongThanNhan_TheoTP @Trphg = '005';

--Kiểm tra nhân viên có thuộc phòng ban @Mapb không
CREATE PROCEDURE sp_KiemTraNV_ThuocPhong
    @Manv NVARCHAR(9),
    @Mapb INT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM NHANVIEN WHERE MANV = @Manv AND PHG = @Mapb)
        PRINT N'Nhân viên thuộc phòng ban';
    ELSE
        PRINT N'Nhân viên KHÔNG thuộc phòng ban';
END;
--THUC THI
EXEC sp_KiemTraNV_ThuocPhong @Manv = '001', @Mapb = 4;

--BAI 3
--Thêm phòng ban tên 'CNTT'
CREATE PROCEDURE sp_ThemPhongBanCNTT
    @TenPHG NVARCHAR(15),
    @MaPHG INT,
    @TRPHG NVARCHAR(9),
    @NG_NHANCHUC DATE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM PHONGBAN WHERE MAPHG = @MaPHG)
        PRINT N'Thêm thất bại: Mã phòng đã tồn tại';
    ELSE
        INSERT INTO PHONGBAN (TENPHG, MAPHG, TRPHG, NG_NHANCHUC)
        VALUES (@TenPHG, @MaPHG, @TRPHG, @NG_NHANCHUC);
END;

--THUC THI
EXEC sp_ThemPhongBanCNTT 
    @TenPHG = N'CNTT', 
    @MaPHG = 9, 
    @TRPHG = '001', 
    @NG_NHANCHUC = '2020-01-01';

--Cập nhật tên phòng ‘CNTT’ thành ‘IT’
CREATE PROCEDURE sp_CapNhatTenPhongCNTT
AS
BEGIN
    UPDATE PHONGBAN
    SET TENPHG = N'IT'
    WHERE TENPHG = N'CNTT';
END;
--THUC THI
EXEC sp_CapNhatTenPhongCNTT;

--Thêm nhân viên (với điều kiện tùy theo lương & tuổi & giới tính)
CREATE PROCEDURE sp_ThemNhanVien
    @HONV NVARCHAR(15),
    @TENLOT NVARCHAR(15),
    @TENNV NVARCHAR(15),
    @MANV NVARCHAR(9),
    @NGSINH DATE,
    @DCHI NVARCHAR(30),
    @PHAI NVARCHAR(3),
    @LUONG FLOAT
AS
BEGIN
    DECLARE @MA_NQL NVARCHAR(9);
    DECLARE @PHG INT;
    DECLARE @TUOI INT;

    -- Tính tuổi
    SET @TUOI = YEAR(GETDATE()) - YEAR(@NGSINH);

    -- Kiểm tra tuổi theo giới tính
    IF (@PHAI = N'Nam' AND (@TUOI < 18 OR @TUOI > 65)) OR
       (@PHAI = N'Nữ' AND (@TUOI < 18 OR @TUOI > 60))
    BEGIN
        PRINT N'Tuổi không hợp lệ';
        RETURN;
    END

    -- Xác định người quản lý theo lương
    IF @LUONG < 25000
        SET @MA_NQL = '009';
    ELSE
        SET @MA_NQL = '005';

    -- Xác định mã phòng IT (sau khi đổi tên từ CNTT)
    SELECT @PHG = MAPHG FROM PHONGBAN WHERE TENPHG = N'IT';

    -- Thêm nhân viên
    INSERT INTO NHANVIEN (HONV, TENLOT, TENNV, MANV, NGSINH, DCHI, PHAI, LUONG, MA_NQL, PHG)
    VALUES (@HONV, @TENLOT, @TENNV, @MANV, @NGSINH, @DCHI, @PHAI, @LUONG, @MA_NQL, @PHG);

    PRINT N'Đã thêm nhân viên thành công';
END;
--THUC THI
EXEC sp_ThemNhanVien
    @HONV = N'Nguyễn',
    @TENLOT = N'Văn',
    @TENNV = N'An',
    @MANV = '010',
    @NGSINH = '1995-06-15',
    @DCHI = N'123 Hà Nội',
    @PHAI = N'Nam',
    @LUONG = 26000;
