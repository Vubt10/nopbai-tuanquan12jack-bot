use QLNHATRO_QuanPS41827
go

-- Y3
--1-Thêm thông tin vào các bảng
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

-- SP thêm nhà trọ
IF OBJECT_ID('dbo.sp_ThemNhaTro', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_ThemNhaTro;
GO
CREATE PROCEDURE dbo.sp_ThemNhaTro
    @MaLoaiNha INT,
    @DienTich FLOAT,
    @Gia MONEY,
    @SoNha NVARCHAR(50),
    @TenDuong NVARCHAR(100),
    @Phuong NVARCHAR(50),
    @Quan NVARCHAR(50),
    @MoTa NVARCHAR(200),
    @NgayDang DATE,
    @MaNguoiLienHe INT
AS
BEGIN
    IF @MaLoaiNha IS NULL OR @DienTich IS NULL OR @Gia IS NULL OR @MaNguoiLienHe IS NULL
    BEGIN
        PRINT N'Thiếu thông tin bắt buộc. Không thể thêm nhà trọ.';
        RETURN;
    END;

    INSERT INTO dbo.NHATRO (MaLoai, DienTich, GiaTien, SoNha, Duong, Phuong, Quan, MoTa, NgayDangTin, MaNguoiLienHe)
    VALUES (@MaLoaiNha, @DienTich, @Gia, @SoNha, @TenDuong, @Phuong, @Quan, @MoTa, @NgayDang, @MaNguoiLienHe);

    PRINT N'Thêm nhà trọ thành công.';
END;
GO

-- Thành công
EXEC dbo.sp_ThemNhaTro 1, 25.5, 1700000, N'18', N'Cầu Giấy', N'Dịch Vọng', N'Cầu Giấy', N'Phòng đẹp, sạch sẽ', '2025-10-20', 1;

-- Thất bại
EXEC dbo.sp_ThemNhaTro NULL, NULL, NULL, N'18', N'Cầu Giấy', N'Dịch Vọng', N'Cầu Giấy', N'Lỗi dữ liệu thiếu', '2025-10-20', NULL;

--Thêm đánh giá
IF OBJECT_ID('dbo.sp_ThemDanhGia', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_ThemDanhGia;
GO
CREATE PROCEDURE dbo.sp_ThemDanhGia
    @MaNguoiDung INT,
    @MaNhaTro INT,
    @TrangThai NVARCHAR(10),
    @NoiDung NVARCHAR(200)
AS
BEGIN
    IF @MaNguoiDung IS NULL OR @MaNhaTro IS NULL OR @TrangThai IS NULL
    BEGIN
        PRINT N'Thiếu thông tin bắt buộc. Không thể thêm đánh giá.';
        RETURN;
    END;

    INSERT INTO dbo.DANHGIA (MaNguoiDung, MaNhaTro, TrangThai, NoiDung)
    VALUES (@MaNguoiDung, @MaNhaTro, @TrangThai, @NoiDung);

    PRINT N'Thêm đánh giá thành công.';
END;
GO

-- Thành công
EXEC dbo.sp_ThemDanhGia 1, 1, N'LIKE', N'Phòng sạch, chủ nhà thân thiện';

-- Thất bại
EXEC dbo.sp_ThemDanhGia NULL, 1, N'DISLIKE', N'Lỗi do thiếu mã người dùng';

--2. Truy vấn thông tin

--a. Viết một SP với các tham số đầu vào phù hợp. SP thực hiện tìm kiếm thông tin các 
--phòng trọ thỏa mãn điều kiện tìm kiếm theo: Quận, phạm vi diện tích, phạm vi ngày đăng 
--tin, khoảng giá tiền, loại hình nhà trọ. 
IF OBJECT_ID('dbo.sp_TimNhaTro', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_TimNhaTro;
GO
CREATE PROCEDURE dbo.sp_TimNhaTro
    @Quan NVARCHAR(50) = NULL,
    @DienTichMin FLOAT = NULL,
    @DienTichMax FLOAT = NULL,
    @NgayDangFrom DATE = NULL,
    @NgayDangTo DATE = NULL,
    @GiaMin MONEY = NULL,
    @GiaMax MONEY = NULL,
    @MaLoaiNha INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        -- Cột 1: 'Cho thuê phòng trọ tại' + địa chỉ + quận
        N'Cho thuê phòng trọ tại ' +
            ISNULL(NULLIF(LTRIM(RTRIM(n.SoNha)), ''), '') +
            (CASE WHEN n.SoNha IS NULL OR LTRIM(RTRIM(n.SoNha)) = '' THEN '' ELSE N' ' END) +
            ISNULL(NULLIF(LTRIM(RTRIM(n.Duong)), ''), '') +
            (CASE WHEN n.Phuong IS NULL OR LTRIM(RTRIM(n.Phuong)) = '' THEN '' ELSE N', ' + n.Phuong END) +
            (CASE WHEN n.Quan IS NULL OR LTRIM(RTRIM(n.Quan)) = '' THEN '' ELSE N' - ' + n.Quan END)
            AS DiaChiDayDu,

        -- Cột 2: Diện tích theo chuẩn VN + ' m2' (1 decimal nếu có)
        FORMAT(n.DienTich, 'N1', 'vi-VN') + N' m2' AS DienTichVN,

        -- Cột 3: Giá theo chuẩn VN (no decimal zero)
        FORMAT(n.GiaTien, 'N0', 'vi-VN') AS GiaVN,

        -- Cột 4: Mô tả
        ISNULL(n.MoTa, N'') AS MoTa,

        -- Cột 5: Ngày đăng dưới định dạng dd-MM-yyyy
        CONVERT(NVARCHAR(10), n.NgayDangTin, 105) AS NgayDangVN,

        -- Cột 6: Thông tin người liên hệ: A. Tên (Nam) / C. Tên (Nữ)
        (CASE WHEN u.GioiTinh COLLATE Vietnamese_CI_AS = N'Nam' THEN N'A. ' + u.TenNguoiDung
              WHEN u.GioiTinh COLLATE Vietnamese_CI_AS = N'Nữ' THEN N'C. ' + u.TenNguoiDung
              ELSE u.TenNguoiDung END) AS NguoiLienHe,

        -- Cột 7: Số điện thoại liên hệ
        ISNULL(u.DienThoai, N'') AS DienThoaiLienHe,

        -- Cột 8: Địa chỉ người liên hệ
        ISNULL(u.SoNha,'') +
            (CASE WHEN ISNULL(u.SoNha,'')<>'' AND ISNULL(u.Duong,'')<>'' THEN N' ' ELSE '' END) +
            ISNULL(u.Duong,'') +
            (CASE WHEN u.Phuong IS NULL OR u.Phuong = '' THEN '' ELSE N', ' + u.Phuong END) +
            (CASE WHEN u.Quan IS NULL OR u.Quan = '' THEN '' ELSE N' - ' + u.Quan END) AS DiaChiNguoiLienHe
    FROM dbo.NHATRO n
    INNER JOIN dbo.NGUOIDUNG u ON n.MaNguoiLienHe = u.MaNguoiDung
    WHERE 1 = 1
      AND (@Quan IS NULL OR n.Quan = @Quan)
      AND (@MaLoaiNha IS NULL OR n.MaLoai = @MaLoaiNha)
      AND (@DienTichMin IS NULL OR n.DienTich >= @DienTichMin)
      AND (@DienTichMax IS NULL OR n.DienTich <= @DienTichMax)
      AND (@NgayDangFrom IS NULL OR n.NgayDangTin >= @NgayDangFrom)
      AND (@NgayDangTo IS NULL OR n.NgayDangTin <= @NgayDangTo)
      AND (@GiaMin IS NULL OR n.GiaTien >= @GiaMin)
      AND (@GiaMax IS NULL OR n.GiaTien <= @GiaMax)
    ORDER BY n.NgayDangTin DESC;
END;
GO
IF OBJECT_ID('dbo.sp_TimNhaTro', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_TimNhaTro;
GO
CREATE PROCEDURE dbo.sp_TimNhaTro
    @Quan NVARCHAR(50) = NULL,
    @DienTichMin FLOAT = NULL,
    @DienTichMax FLOAT = NULL,
    @NgayDangFrom DATE = NULL,
    @NgayDangTo DATE = NULL,
    @GiaMin MONEY = NULL,
    @GiaMax MONEY = NULL,
    @MaLoaiNha INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        -- Cột 1: 'Cho thuê phòng trọ tại' + địa chỉ + quận
        N'Cho thuê phòng trọ tại ' +
            ISNULL(NULLIF(LTRIM(RTRIM(n.SoNha)), ''), '') +
            (CASE WHEN n.SoNha IS NULL OR LTRIM(RTRIM(n.SoNha)) = '' THEN '' ELSE N' ' END) +
            ISNULL(NULLIF(LTRIM(RTRIM(n.Duong)), ''), '') +
            (CASE WHEN n.Phuong IS NULL OR LTRIM(RTRIM(n.Phuong)) = '' THEN '' ELSE N', ' + n.Phuong END) +
            (CASE WHEN n.Quan IS NULL OR LTRIM(RTRIM(n.Quan)) = '' THEN '' ELSE N' - ' + n.Quan END)
            AS DiaChiDayDu,

        -- Cột 2: Diện tích theo chuẩn VN + ' m2' (1 decimal nếu có)
        FORMAT(n.DienTich, 'N1', 'vi-VN') + N' m2' AS DienTichVN,

        -- Cột 3: Giá theo chuẩn VN (no decimal zero)
        FORMAT(n.GiaTien, 'N0', 'vi-VN') AS GiaVN,

        -- Cột 4: Mô tả
        ISNULL(n.MoTa, N'') AS MoTa,

        -- Cột 5: Ngày đăng dưới định dạng dd-MM-yyyy
        CONVERT(NVARCHAR(10), n.NgayDangTin, 105) AS NgayDangVN,

        -- Cột 6: Thông tin người liên hệ: A. Tên (Nam) / C. Tên (Nữ)
        (CASE WHEN u.GioiTinh COLLATE Vietnamese_CI_AS = N'Nam' THEN N'A. ' + u.TenNguoiDung
              WHEN u.GioiTinh COLLATE Vietnamese_CI_AS = N'Nữ' THEN N'C. ' + u.TenNguoiDung
              ELSE u.TenNguoiDung END) AS NguoiLienHe,

        -- Cột 7: Số điện thoại liên hệ
        ISNULL(u.DienThoai, N'') AS DienThoaiLienHe,

        -- Cột 8: Địa chỉ người liên hệ
        ISNULL(u.SoNha,'') +
            (CASE WHEN ISNULL(u.SoNha,'')<>'' AND ISNULL(u.Duong,'')<>'' THEN N' ' ELSE '' END) +
            ISNULL(u.Duong,'') +
            (CASE WHEN u.Phuong IS NULL OR u.Phuong = '' THEN '' ELSE N', ' + u.Phuong END) +
            (CASE WHEN u.Quan IS NULL OR u.Quan = '' THEN '' ELSE N' - ' + u.Quan END) AS DiaChiNguoiLienHe
    FROM dbo.NHATRO n
    INNER JOIN dbo.NGUOIDUNG u ON n.MaNguoiLienHe = u.MaNguoiDung
    WHERE 1 = 1
      AND (@Quan IS NULL OR n.Quan = @Quan)
      AND (@MaLoaiNha IS NULL OR n.MaLoai = @MaLoaiNha)
      AND (@DienTichMin IS NULL OR n.DienTich >= @DienTichMin)
      AND (@DienTichMax IS NULL OR n.DienTich <= @DienTichMax)
      AND (@NgayDangFrom IS NULL OR n.NgayDangTin >= @NgayDangFrom)
      AND (@NgayDangTo IS NULL OR n.NgayDangTin <= @NgayDangTo)
      AND (@GiaMin IS NULL OR n.GiaTien >= @GiaMin)
      AND (@GiaMax IS NULL OR n.GiaTien <= @GiaMax)
    ORDER BY n.NgayDangTin DESC;
END;
GO

-- Thành công
EXEC dbo.sp_TimNhaTro
    @Quan = N'Cầu Giấy',
    @DienTichMin = 20,
    @DienTichMax = 30,
    @NgayDangFrom = '2025-01-01',
    @NgayDangTo = '2025-12-31',
    @GiaMin = 1000000,
    @GiaMax = 2500000,
    @MaLoaiNha = 1;
go

--Thất bại
EXEC dbo.sp_TimNhaTro @DienTichMin = 50, @DienTichMax = 10;

--b.Viết một hàm có các tham số đầu vào tương ứng với tất cả các cột của bảng 
--NGUOIDUNG. Hàm này trả về mã người dùng (giá trị của cột khóa chính của bảng 
--NGUOIDUNG) thỏa mãn các giá trị được truyền vào tham số.

IF OBJECT_ID('dbo.fn_TimMaNguoiDung', 'FN') IS NOT NULL
    DROP FUNCTION dbo.fn_TimMaNguoiDung;
GO
CREATE FUNCTION dbo.fn_TimMaNguoiDung
(
    @TenNguoiDung NVARCHAR(100),
    @GioiTinh NVARCHAR(5),
    @DienThoai VARCHAR(15),
    @SoNha NVARCHAR(50),
    @TenDuong NVARCHAR(100),
    @Phuong NVARCHAR(50),
    @Quan NVARCHAR(50),
    @Email NVARCHAR(100)
)
RETURNS INT
AS
BEGIN
    DECLARE @Ma INT;

    SELECT TOP 1 @Ma = MaNguoiDung
    FROM dbo.NGUOIDUNG
    WHERE
        (@TenNguoiDung IS NULL OR TenNguoiDung = @TenNguoiDung)
        AND (@GioiTinh IS NULL OR GioiTinh = @GioiTinh)
        AND (@DienThoai IS NULL OR DienThoai = @DienThoai)
        AND (@SoNha IS NULL OR SoNha = @SoNha)
        AND (@TenDuong IS NULL OR Duong = @TenDuong)
        AND (@Phuong IS NULL OR Phuong = @Phuong)
        AND (@Quan IS NULL OR Quan = @Quan)
        AND (@Email IS NULL OR Email = @Email);

    RETURN @Ma; -- NULL nếu không tìm thấy
END;
GO

--Gọi
SELECT dbo.fn_TimMaNguoiDung(N'Nguyễn Thắng', N'Nam', '0988123456', N'12', N'Nguyễn Trãi', N'Thanh Xuân Trung', N'Thanh Xuân', N'thang@gmail.com') AS MaNguoi;


--c.Viết một hàm có tham số đầu vào là mã nhà trọ (cột khóa chính của bảng 
--NHATRO). Hàm này trả về tổng số LIKE và DISLIKE của nhà trọ này. 
IF OBJECT_ID('dbo.fn_TongDanhGiaTheoNhaTro', 'FN') IS NOT NULL
    DROP FUNCTION dbo.fn_TongDanhGiaTheoNhaTro;
GO
CREATE FUNCTION dbo.fn_TongDanhGiaTheoNhaTro(@MaNhaTro INT)
RETURNS INT
AS
BEGIN
    DECLARE @Tong INT;
    SELECT @Tong = COUNT(*) FROM dbo.DANHGIA WHERE MaNhaTro = @MaNhaTro;
    RETURN ISNULL(@Tong, 0);
END;
GO

--Gọi
SELECT dbo.fn_TongDanhGiaTheoNhaTro(1) AS TongDanhGia;

--d.Tạo một View lưu thông tin của TOP 10 nhà trọ có số người dùng LIKE nhiều nhất gồm 
--các thông tin đã cho
IF OBJECT_ID('dbo.vw_Top10_NhaTro_Like', 'V') IS NOT NULL
    DROP VIEW dbo.vw_Top10_NhaTro_Like;
GO
CREATE VIEW dbo.vw_Top10_NhaTro_Like
AS
SELECT TOP 10
    n.MaNhaTro,
    n.DienTich,
    n.GiaTien,
    n.MoTa,
    n.NgayDangTin,
    u.TenNguoiDung AS TenNguoiLienHe,
    -- Địa chỉ
    ISNULL(n.SoNha,'') +
        (CASE WHEN ISNULL(n.SoNha,'')<>'' AND ISNULL(n.Duong,'')<>'' THEN N' ' ELSE '' END) +
        ISNULL(n.Duong,'') +
        (CASE WHEN n.Phuong IS NULL OR n.Phuong = '' THEN '' ELSE N', ' + n.Phuong END) +
        (CASE WHEN n.Quan IS NULL OR n.Quan = '' THEN '' ELSE N' - ' + n.Quan END) AS DiaChi,
    u.DienThoai,
    u.Email,
    COUNT(d.MaDanhGia) AS SoLuotLike
FROM dbo.NHATRO n
LEFT JOIN dbo.DANHGIA d ON d.MaNhaTro = n.MaNhaTro AND d.TrangThai = N'LIKE'
LEFT JOIN dbo.NGUOIDUNG u ON n.MaNguoiLienHe = u.MaNguoiDung
GROUP BY n.MaNhaTro, n.DienTich, n.GiaTien, n.MoTa, n.NgayDangTin, u.TenNguoiDung, n.SoNha, n.Duong, n.Phuong, n.Quan, u.DienThoai, u.Email
ORDER BY COUNT(d.MaDanhGia) DESC, n.NgayDangTin DESC;
GO

--Gọi
SELECT * FROM dbo.vw_Top10_NhaTro_Like;

--e. Viết một Stored Procedure nhận tham số đầu vào là mã nhà trọ (cột khóa chính của 
--bảng NHATRO). SP này trả về tập kết quả gồm các thông tin đã cho:
IF OBJECT_ID('dbo.sp_GetDanhGiaTheoNhaTro', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_GetDanhGiaTheoNhaTro;
GO
CREATE PROCEDURE dbo.sp_GetDanhGiaTheoNhaTro
    @MaNhaTro INT
AS
BEGIN
    SET NOCOUNT ON;

    IF @MaNhaTro IS NULL
    BEGIN
        RAISERROR(N'Vui lòng truyền mã nhà trọ.', 16, 1);
        RETURN;
    END

    SELECT
        d.MaNhaTro,
        u.TenNguoiDung AS TenNguoiDanhGia,
        d.TrangThai,
        d.NoiDung
    FROM dbo.DANHGIA d
    INNER JOIN dbo.NGUOIDUNG u ON d.MaNguoiDung = u.MaNguoiDung
    WHERE d.MaNhaTro = @MaNhaTro
    ORDER BY d.MaDanhGia DESC;
END;
GO

--Gọi
EXEC dbo.sp_GetDanhGiaTheoNhaTro @MaNhaTro = 1;

--3.Xóa thông tin
--a.SP xóa nhà trọ nếu số lượng DISLIKE lớn hơn tham số
IF OBJECT_ID('dbo.sp_XoaNhaTroTheoSoDislike', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_XoaNhaTroTheoSoDislike;
GO

CREATE PROCEDURE dbo.sp_XoaNhaTroTheoSoDislike
    @SoLuongDISLIKE INT
AS
BEGIN
    SET NOCOUNT ON;

    IF @SoLuongDISLIKE IS NULL OR @SoLuongDISLIKE < 0
    BEGIN
        RAISERROR(N'Tham số không hợp lệ: SoLuongDISLIKE phải >= 0.', 16, 1);
        RETURN;
    END

    BEGIN TRAN;
    BEGIN TRY
        -- Tạo table variable chứa MaNhaTro cần xóa
        DECLARE @ToDelete TABLE (MaNhaTro INT PRIMARY KEY);

        -- Chèn các MaNhaTro có số DISLIKE > @SoLuongDISLIKE vào @ToDelete
        INSERT INTO @ToDelete (MaNhaTro)
        SELECT d.MaNhaTro
        FROM dbo.DANHGIA d
        WHERE d.TrangThai = N'DISLIKE'
        GROUP BY d.MaNhaTro
        HAVING COUNT(*) > @SoLuongDISLIKE;

        -- Nếu không có bản ghi nào thỏa điều kiện thì trả thông báo và rollback/commit nhẹ
        IF NOT EXISTS (SELECT 1 FROM @ToDelete)
        BEGIN
            ROLLBACK TRAN; -- không có gì để xóa, rollback để kết thúc transaction sạch
            PRINT N'Không có nhà trọ nào có số DISLIKE lớn hơn ' + CAST(@SoLuongDISLIKE AS NVARCHAR(10));
            RETURN;
        END

        -- Xóa các đánh giá của nhà trọ này
        DELETE dg
        FROM dbo.DANHGIA dg
        INNER JOIN @ToDelete t ON dg.MaNhaTro = t.MaNhaTro;

        -- Xóa nhà trọ
        DELETE n
        FROM dbo.NHATRO n
        INNER JOIN @ToDelete t ON n.MaNhaTro = t.MaNhaTro;

        COMMIT TRAN;
        PRINT N'Xóa thành công các nhà trọ có DISLIKE lớn hơn ' + CAST(@SoLuongDISLIKE AS NVARCHAR(10));
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0
            ROLLBACK TRAN;

        DECLARE @ErrMsg NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrNo INT = ERROR_NUMBER();
        RAISERROR(N'Lỗi khi xóa: %s (ErrNo: %d)', 16, 1, @ErrMsg, @ErrNo);
    END CATCH;
END;
GO

--Gọi 
EXEC dbo.sp_XoaNhaTroTheoSoDislike @SoLuongDISLIKE = 1;

--b.SP xóa nhà trọ theo khoảng thời gian đăng tin
IF OBJECT_ID('dbo.sp_XoaNhaTroTheoKhoangNgay', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_XoaNhaTroTheoKhoangNgay;
GO
CREATE PROCEDURE dbo.sp_XoaNhaTroTheoKhoangNgay
    @TuNgay DATE,
    @DenNgay DATE
AS
BEGIN
    SET NOCOUNT ON;

    IF @TuNgay IS NULL OR @DenNgay IS NULL OR @TuNgay > @DenNgay
    BEGIN
        RAISERROR(N'Tham số khoảng thời gian không hợp lệ.', 16, 1);
        RETURN;
    END

    BEGIN TRAN;
    BEGIN TRY
        -- Xóa đánh giá của các nhà trọ trong khoảng
        DELETE dg
        FROM dbo.DANHGIA dg
        INNER JOIN dbo.NHATRO n ON dg.MaNhaTro = n.MaNhaTro
        WHERE n.NgayDangTin BETWEEN @TuNgay AND @DenNgay;

        -- Xóa nhà trọ trong khoảng
        DELETE FROM dbo.NHATRO
        WHERE NgayDangTin BETWEEN @TuNgay AND @DenNgay;

        COMMIT TRAN;
        PRINT N'Xóa thành công nhà trọ đăng từ ' + CONVERT(NVARCHAR(10), @TuNgay, 105) + N' đến ' + CONVERT(NVARCHAR(10), @DenNgay, 105);
    END TRY
    BEGIN CATCH
        ROLLBACK TRAN;
        DECLARE @ErrMsg NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(N'Lỗi khi xóa theo khoảng ngày: %s', 16, 1, @ErrMsg);
    END CATCH;
END;
GO

--Gọi
EXEC dbo.sp_XoaNhaTroTheoKhoangNgay @TuNgay = '2024-01-01', @DenNgay = '2024-12-31';


