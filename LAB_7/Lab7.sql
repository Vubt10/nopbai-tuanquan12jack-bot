USE PS41827_QLDA
GO

--BAI 1
--Nhập vào MaNV cho biết tuổi của nhân viên này.
CREATE FUNCTION fu_TuoiNhanVien (@MaNV NVARCHAR(9))
RETURNS INT
AS
BEGIN
    DECLARE @Tuoi INT
    SELECT @Tuoi = YEAR(GETDATE()) - YEAR(NGSINH)
    FROM NHANVIEN
    WHERE MANV = @MaNV
    RETURN @Tuoi
END;
GO
--THUC THI
SELECT dbo.fn_TuoiNhanVien('001');

--Nhập vào Manv cho biết số lượng đề án nhân viên này đã tham gia
CREATE FUNCTION fu_SoDeAnThamGia (@MaNV NVARCHAR(9))
RETURNS INT
AS
BEGIN
    DECLARE @SoDeAn INT
    SELECT @SoDeAn = COUNT(DISTINCT MADA)
    FROM PHANCONG
    WHERE MA_NVIEN = @MaNV
    RETURN @SoDeAn
END;
-- THUC THI
SELECT dbo.fn_SoDeAnThamGia('005');

-- Truyền tham số vào phái nam hoặc nữ, xuất số lượng nhân viên theo phái
CREATE FUNCTION fu_SoLuongTheoPhai (@phai NVARCHAR(3))
RETURNS INT
AS
BEGIN
    RETURN (SELECT COUNT(*) FROM NHANVIEN WHERE PHAI LIKE @phai)
END;
--THUC THI
SELECT dbo.fn_SoLuongTheoPhai(N'Nữ');

--Nhập tên phòng => Trả danh sách nhân viên có lương > trung bình phòng
CREATE FUNCTION fu_NVLuongCaoTrongPhong (@TenPHG NVARCHAR(15))
RETURNS TABLE
AS
RETURN (
    SELECT HONV, TENLOT, TENNV, LUONG
    FROM NHANVIEN NV
    WHERE PHG = (SELECT MAPHG FROM PHONGBAN WHERE TENPHG = @TenPHG)
      AND LUONG > (
        SELECT AVG(LUONG)
        FROM NHANVIEN
        WHERE PHG = (SELECT MAPHG FROM PHONGBAN WHERE TENPHG = @TenPHG)
      )
);
--THUC THI
SELECT * FROM dbo.fn_NVLuongCaoTrongPhong(N'Nghiên Cứu');

--Tryền tham số đầu vào là Mã Phòng, cho biết tên phòng ban, họ tên người trưởng phòng 
--và số lượng đề án mà phòng ban đó chủ trì.
CREATE FUNCTION fu_ThongTinPhong (@MaPHG INT)
RETURNS TABLE
AS
RETURN (
    SELECT 
        PB.TENPHG,
        (NV.HONV + ' ' + NV.TENLOT + ' ' + NV.TENNV) AS HoTenTruongPhong,
        COUNT(DISTINCT DA.MADA) AS SoDeAn
    FROM PHONGBAN PB
    JOIN NHANVIEN NV ON PB.TRPHG = NV.MANV
    LEFT JOIN DEAN DA ON DA.PHONG = PB.MAPHG
    WHERE PB.MAPHG = @MaPHG
    GROUP BY PB.TENPHG, NV.HONV, NV.TENLOT, NV.TENNV
);
--THUC THI
SELECT * FROM dbo.fn_ThongTinPhong(5);

--BAI 2
--Hiển thị HoNV, TenNV, TenPHG, DiaDiemPhg
CREATE VIEW v_ThongTinNhanVien_Phong
AS
SELECT NV.HONV, NV.TENNV, PB.TENPHG, DD.DIADIEM
FROM NHANVIEN NV
JOIN PHONGBAN PB ON NV.PHG = PB.MAPHG
JOIN DIADIEM_PHG DD ON PB.MAPHG = DD.MAPHG;

--Hiển thị TenNV, Lương, Tuổi
CREATE VIEW v_LuongVaTuoi
AS
SELECT TENNV, LUONG, YEAR(GETDATE()) - YEAR(NGSINH) AS TUOI
FROM NHANVIEN;
--thuc thi
SELECT * FROM v_LuongVaTuoi;

--Tên phòng ban & họ tên trưởng phòng của phòng có nhiều nhân viên nhất
CREATE VIEW v_PhongDongNhat
AS
SELECT TOP 1 
    PB.TENPHG,
    (TP.HONV + ' ' + TP.TENLOT + ' ' + TP.TENNV) AS TruongPhong,
    COUNT(NV.MANV) AS SoLuongNV
FROM PHONGBAN PB
JOIN NHANVIEN TP ON PB.TRPHG = TP.MANV       -- Trưởng phòng
JOIN NHANVIEN NV ON NV.PHG = PB.MAPHG         -- Các nhân viên thuộc phòng
GROUP BY PB.TENPHG, TP.HONV, TP.TENLOT, TP.TENNV
ORDER BY COUNT(NV.MANV) DESC;
--thuc thi
SELECT * FROM v_PhongDongNhat;
