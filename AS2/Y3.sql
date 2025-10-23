use QLNHATRO_QuanPS41827
go

-- Y3.1-Thêm thông tin vào các bảng
-- SP thêm người dùng
IF OBJECT_ID('sp_ThemNguoiDung', 'P') IS NOT NULL
    DROP PROCEDURE sp_ThemNguoiDung;
GO
CREATE PROCEDURE sp_ThemNguoiDung
    @TenNguoiDung NVARCHAR(50),
    @GioiTinh NVARCHAR(5),
    @DienThoai VARCHAR(15),
    @SoNha NVARCHAR(50),
    @TenDuong NVARCHAR(100),
    @Phuong NVARCHAR(50),
    @Quan NVARCHAR(50),
    @Email NVARCHAR(100)
AS
BEGIN
    IF @TenNguoiDung IS NULL OR @GioiTinh IS NULL OR @DienThoai IS NULL
    BEGIN
        PRINT N'Vui lòng nhập đầy đủ thông tin bắt buộc!';
        RETURN;
    END

    INSERT INTO NGUOIDUNG(TenNguoiDung, GioiTinh, DienThoai, SoNha,Duong, Phuong, Quan, Email)
    VALUES(@TenNguoiDung, @GioiTinh, @DienThoai, @SoNha, @TenDuong, @Phuong, @Quan, @Email);
END;
GO

-- Thành công
EXEC sp_ThemNguoiDung N'Nguyễn Thắng', N'Nam', '0987654321', N'12', N'Nguyễn Trãi', N'Thanh Xuân Trung', N'Thanh Xuân', N'thang@gmail.com';

-- Thất bại
EXEC sp_ThemNguoiDung NULL, N'Nữ', '0987654321', N'12', N'Nguyễn Trãi', N'Thanh Xuân Trung', N'Thanh Xuân', N'lan@gmail.com';

--