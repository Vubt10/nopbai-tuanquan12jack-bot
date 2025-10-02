use PS41827_QLDA

--Tìm các nhân viên làm việc ở phòng số 4
SELECT * FROM NHANVIEN WHERE PHG LIKE 4;
--Tìm các nhân viên có mức lương trên 30000
SELECT * FROM NHANVIEN WHERE LUONG > 30000;
--Tìm các nhân viên có mức lương trên 25,000 ở phòng 4 hoặc các nhân viên có mức lương trên 30,000 ở phòng 5
SELECT * FROM NHANVIEN WHERE LUONG > 25000 AND PHG LIKE 4 OR LUONG > 30000 AND PHG LIKE 5;
--Cho biết họ tên đầy đủ của các nhân viên ở TP HCM
SELECT concat(HONV,'',TENLOT,'',TENNV) AS 'HO VA TEN' FROM NHANVIEN WHERE DCHI LIKE '%TP HCM';
--Cho biết họ tên đầy đủ của các nhân viên có họ bắt đầu bằng ký tự 'N'
SELECT concat(HONV,'',TENLOT,'',TENNV) AS 'HO VA TEN' FROM NHANVIEN WHERE HONV LIKE 'N%';
--Cho biết ngày sinh và địa chỉ của nhân viên Dinh Ba Tien.
SELECT NGSINH, DCHI FROM NHANVIEN WHERE HONV = 'Dinh' AND TENLOT = 'Ba' AND TENNV = 'Tien';