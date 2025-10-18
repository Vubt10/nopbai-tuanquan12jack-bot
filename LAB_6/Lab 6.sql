USE PS41827_QLDA
GO

--BAI 1
-- Ràng buộc: lương > 15000 
CREATE TRIGGER tri_Luong_NhanVien
ON NHANVIEN
FOR INSERT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE LUONG <= 15000)
    BEGIN
        PRINT (N'Lương phải > 15000');
        ROLLBACK TRANSACTION;
    END
END;
--THUC THI
INSERT INTO NHANVIEN (MANV, TENNV, PHAI, NGSINH, DCHI, LUONG)
VALUES ('NV001', N'Nguyễn Văn A', N'Nam', '1990-01-01', N'Hà Nội', 12000);


-- Ràng buộc tuổi trong khoảng 18–65 khi thêm nhân viên
CREATE TRIGGER tri_Tuoi_NhanVien
ON NHANVIEN
FOR INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM inserted
        WHERE DATEDIFF(YEAR, NGSINH, GETDATE()) < 18 
           OR DATEDIFF(YEAR, NGSINH, GETDATE()) > 65
    )
    BEGIN
        PRINT (N'Tuổi phải từ 18 đến 65');
        ROLLBACK TRANSACTION;
    END
END;
--THUC THI
-- Tuổi < 18
INSERT INTO NHANVIEN (MANV, TENNV, PHAI, NGSINH, DCHI, LUONG)
VALUES ('NV002', N'Trần Thị B', N'Nữ', '2010-01-01', N'Hà Nội', 20000);

--Không cho cập nhật nhân viên có địa chỉ TP HCM
CREATE TRIGGER tri_KhongCapNhatTPHCM
ON NHANVIEN
FOR UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM deleted
        WHERE DCHI LIKE N'%TP HCM%'
    )
    BEGIN
        PRINT (N'Không được cập nhật nhân viên ở TP HCM');
        ROLLBACK TRANSACTION;
    END
END;
--THUC THI
-- Giả sử NV003 đang ở TP HCM
UPDATE NHANVIEN
SET LUONG = 25000
WHERE MANV = 'NV003';

--BAI 2
--Sau khi thêm nhân viên => thống kê số lượng nam/nữ
CREATE TRIGGER tri_ThongKeGioiTinh_Insert
ON NHANVIEN
AFTER INSERT
AS
BEGIN
    DECLARE @nam INT, @nu INT;
    SELECT @nam = COUNT(*) FROM NHANVIEN WHERE PHAI = N'Nam';
    SELECT @nu = COUNT(*) FROM NHANVIEN WHERE PHAI = N'Nữ';

    PRINT N'Tổng số nhân viên Nam: ' + CAST(@nam AS NVARCHAR);
    PRINT N'Tổng số nhân viên Nữ: ' + CAST(@nu AS NVARCHAR);
END;
--THUC THI
INSERT INTO NHANVIEN (MANV, TENNV, PHAI, NGSINH, DCHI, LUONG)
VALUES ('NV004', N'Phạm Văn C', N'Nam', '1985-05-05', N'Đà Nẵng', 18000);

--Sau khi cập nhật giới tính → thống kê lại
CREATE TRIGGER tri_ThongKeGioiTinh_Update
ON NHANVIEN
AFTER UPDATE
AS
BEGIN
    IF UPDATE(PHAI)
    BEGIN
        DECLARE @nam INT, @nu INT;
        SELECT @nam = COUNT(*) FROM NHANVIEN WHERE PHAI = N'Nam';
        SELECT @nu = COUNT(*) FROM NHANVIEN WHERE PHAI = N'Nữ';

        PRINT N'Cập nhật giới tính → Nam: ' + CAST(@nam AS NVARCHAR);
        PRINT N'Nữ: ' + CAST(@nu AS NVARCHAR);
    END
END;
--THUC THI
UPDATE NHANVIEN
SET PHAI = N'Nữ'
WHERE MANV = 'NV004';

--Khi xóa đề án → hiển thị số đề án mỗi nhân viên đã làm
CREATE TRIGGER tri_ThongKeDeAnSauXoa
ON DEAN
AFTER DELETE
AS
BEGIN
    SELECT MA_NVIEN, COUNT(DISTINCT MADA) AS SoDeAn
    FROM PHANCONG
    GROUP BY MA_NVIEN;
END;
--THUC THI
DELETE FROM DEAN
WHERE MADA = 1;

--BAI 3
--Xóa nhân viên → xóa luôn thân nhân liên quan
CREATE TRIGGER tri_XoaNhanVien_KeoThanNhan
ON NHANVIEN
INSTEAD OF DELETE
AS
BEGIN
    DELETE FROM THANNHAN
    WHERE MA_NVIEN IN (SELECT MANV FROM deleted);

    DELETE FROM NHANVIEN
    WHERE MANV IN (SELECT MANV FROM deleted);
END;
--THUC THI
DELETE FROM NHANVIEN
WHERE MANV = 'NV004';

--Thêm nhân viên mới → tự động phân công vào đề án MADA = 1
CREATE TRIGGER tri_ThemNhanVien_PhanCong
ON NHANVIEN
AFTER INSERT
AS
BEGIN
    INSERT INTO PHANCONG (MA_NVIEN, MADA, STT, THOIGIAN)
    SELECT MANV, 1, 1, 10.0 FROM inserted;
END;
--THUC THI
INSERT INTO NHANVIEN (MANV, TENNV, PHAI, NGSINH, DCHI, LUONG)
VALUES ('NV005', N'Lê Văn D', N'Nam', '1992-02-02', N'Cần Thơ', 20000);




