ALTER SESSION SET "_ORACLE_SCRIPT" =TRUE;

GRANT DBA TO cn3_user;
GRANT CONNECT TO giamdoc3;
GRANT CONNECT TO truongcn3;
GRANT CONNECT TO nhanvien3;

-- Tạo user cho chi nhánh CN3
CREATE USER cn3_user IDENTIFIED BY password123;
GRANT CONNECT, RESOURCE TO cn3_user;


-- Tạo bảng CHINHANH
CREATE TABLE CHINHANH (
    ChiNhanhID VARCHAR2(10) PRIMARY KEY,
    TenCN VARCHAR2(50),
    DiaChi VARCHAR2(100)
);

-- Tạo bảng LAIXE
CREATE TABLE LAIXE (
    MaLX VARCHAR2(10) PRIMARY KEY,
    HoTen VARCHAR2(50),
    NgaySinh DATE,
    SoDT VARCHAR2(15),
    BienSoXe VARCHAR2(15),
    ChiNhanhID VARCHAR2(10)
);

-- Thêm khóa ngoại cho LAIXE
ALTER TABLE LAIXE
ADD CONSTRAINT fk_laixe_chinhanh
FOREIGN KEY (ChiNhanhID) REFERENCES CHINHANH(ChiNhanhID);

-- Tạo bảng PHUONGTIEN
CREATE TABLE PHUONGTIEN (
    BienSoXe VARCHAR2(15) PRIMARY KEY,
    LoaiXe VARCHAR2(50),
    HangXe VARCHAR2(50),
    SoChoNgoi NUMBER,
    TrangThai VARCHAR2(20)
);

-- Tạo bảng DICHVU
CREATE TABLE DICHVU (
    MaDV VARCHAR2(10) PRIMARY KEY,
    TenDV VARCHAR2(50),
    MoTa VARCHAR2(100),
    DonGia NUMBER
);

-- Tạo bảng KHACHHANG_V1
CREATE TABLE KHACHHANG_V1 (
    MaKH VARCHAR2(10) PRIMARY KEY,
    HoTen VARCHAR2(50),
    NgaySinh DATE,
    SoDT VARCHAR2(15),
    DiaChi VARCHAR2(100)
);

-- Tạo bảng KHACHHANG_V2
CREATE TABLE KHACHHANG_V2 (
    MaKH VARCHAR2(10) PRIMARY KEY,
    NgayDangKy DATE,
    TongTien NUMBER,
    ChiNhanhDangKy VARCHAR2(10)
);

-- Thêm khóa ngoại cho KHACHHANG_V2
ALTER TABLE KHACHHANG_V2
ADD CONSTRAINT fk_khachhang_v2_chinhanh
FOREIGN KEY (ChiNhanhDangKy) REFERENCES CHINHANH(ChiNhanhID);

-- Tạo bảng HOADON
CREATE TABLE HOADON (
    MaHD VARCHAR2(10) PRIMARY KEY,
    MaKH VARCHAR2(10),
    MaLX VARCHAR2(10),
    MaDV VARCHAR2(10),
    NgayLap DATE,
    TongTien NUMBER,
    ChiNhanhID VARCHAR2(10)
);

-- Thêm khóa ngoại cho HOADON
ALTER TABLE HOADON
ADD CONSTRAINT fk_hoadon_khachhang
FOREIGN KEY (MaKH) REFERENCES KHACHHANG_V2(MaKH);

ALTER TABLE HOADON
ADD CONSTRAINT fk_hoadon_laixe
FOREIGN KEY (MaLX) REFERENCES LAIXE(MaLX);

ALTER TABLE HOADON
ADD CONSTRAINT fk_hoadon_dichvu
FOREIGN KEY (MaDV) REFERENCES DICHVU(MaDV);

ALTER TABLE HOADON
ADD CONSTRAINT fk_hoadon_chinhanh
FOREIGN KEY (ChiNhanhID) REFERENCES CHINHANH(ChiNhanhID);

-- Tạo bảng TRANSACTION
CREATE TABLE TRANSACTION (
    MaGiaoDich VARCHAR2(10) PRIMARY KEY,
    MaHD VARCHAR2(10),
    NgayGiaoDich DATE,
    SoKm NUMBER,
    ThanhTien NUMBER,
    ChiNhanhID VARCHAR2(10)
);

-- Thêm khóa ngoại cho TRANSACTION
ALTER TABLE TRANSACTION
ADD CONSTRAINT fk_transaction_hoadon
FOREIGN KEY (MaHD) REFERENCES HOADON(MaHD);

ALTER TABLE TRANSACTION
ADD CONSTRAINT fk_transaction_chinhanh
FOREIGN KEY (ChiNhanhID) REFERENCES CHINHANH(ChiNhanhID);

GRANT DBA TO cn3_user;

-- Tạo DB_LINK đến CN1 và CN2
CREATE DATABASE LINK CN1_LINK
    CONNECT TO cn1_user IDENTIFIED BY password123
    USING '(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=26.94.39.56)(PORT=1521))(CONNECT_DATA=(SERVICE_NAME=orcl)))';

CREATE DATABASE LINK CN2_LINK
    CONNECT TO cn2_user IDENTIFIED BY password123
    USING '(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=26.188.246.23)(PORT=1521))(CONNECT_DATA=(SERVICE_NAME=orcl)))';

SELECT * FROM dba_db_links;

-- GIAMDOC

SELECT * FROM cn2_user.KHACHHANG_V1@CN2_LINK_GIAMDOC;

CREATE PUBLIC DATABASE LINK CN2_LINK_GIAMDOC CONNECT TO giamdoc2 IDENTIFIED BY gd_password
USING'(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=26.188.246.23)(PORT=1521))(CONNECT_DATA=(SERVICE_NAME=orcl)))';

CREATE PUBLIC DATABASE LINK CN1_LINK_GIAMDOC CONNECT TO giamdoc1 IDENTIFIED BY gd_password
USING'(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=26.94.39.56)(PORT=1521))(CONNECT_DATA=(SERVICE_NAME=orcl)))';
--TruongChiNhanh
CREATE PUBLIC DATABASE LINK CN2_LINK_TCN CONNECT TO truongcn2 IDENTIFIED BY tcn_password
USING'(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=26.188.246.23)(PORT=1521))(CONNECT_DATA=(SERVICE_NAME=orcl)))';

CREATE PUBLIC DATABASE LINK CN1_LINK_TCN CONNECT TO truongcn1 IDENTIFIED BY tcn_password
USING'(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=26.94.39.56)(PORT=1521))(CONNECT_DATA=(SERVICE_NAME=orcl)))';

--NhanVien
 CREATE PUBLIC DATABASE LINK CN2_LINK_NV CONNECT TO nhanvien2 IDENTIFIED BY nv_password
USING'(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=26.188.246.23)(PORT=1521))(CONNECT_DATA=(SERVICE_NAME=orcl)))';

CREATE PUBLIC DATABASE LINK CN1_LINK_NV CONNECT TO nhanvien1 IDENTIFIED BY nv_password
USING'(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=26.94.39.56)(PORT=1521))(CONNECT_DATA=(SERVICE_NAME=orcl)))';

-- Phân quyền cho GiamDoc
GRANT SELECT ON cn3_user.CHINHANH TO giamdoc3;
GRANT SELECT ON cn3_user.LAIXE TO giamdoc3;
GRANT SELECT ON cn3_user.PHUONGTIEN TO giamdoc3;
GRANT SELECT ON cn3_user.DICHVU TO giamdoc3;
GRANT SELECT ON cn3_user.KHACHHANG_V1 TO giamdoc3;
GRANT SELECT ON cn3_user.KHACHHANG_V2 TO giamdoc3;
GRANT SELECT ON cn3_user.HOADON TO giamdoc3;
GRANT SELECT ON cn3_user.TRANSACTION TO giamdoc3;
COMMIT;

-- Phân quyền cho Truong Chi Nhanh
GRANT SELECT, INSERT, UPDATE, DELETE ON cn3_user.CHINHANH TO truongcn3;
-- Gán toàn quyền trên bảng LAIXE
GRANT SELECT, INSERT, UPDATE, DELETE ON cn3_user.LAIXE TO truongcn3;
-- Gán toàn quyền trên bảng PHUONGTIEN
GRANT SELECT, INSERT, UPDATE, DELETE ON cn3_user.PHUONGTIEN TO truongcn3;
-- Gán toàn quyền trên bảng DICHVU
GRANT SELECT, INSERT, UPDATE, DELETE ON cn3_user.DICHVU TO truongcn3;
-- Gán toàn quyền trên bảng KHACHHANG_V1
GRANT SELECT, INSERT, UPDATE, DELETE ON cn3_user.KHACHHANG_V1 TO truongcn3;
-- Gán toàn quyền trên bảng KHACHHANG_V2
GRANT SELECT, INSERT, UPDATE, DELETE ON cn3_user.KHACHHANG_V2 TO truongcn3;
-- Gán toàn quyền trên bảng HOADON
GRANT SELECT, INSERT, UPDATE, DELETE ON cn3_user.HOADON TO truongcn3;
-- Gán toàn quyền trên bảng TRANSACTION
GRANT SELECT, INSERT, UPDATE, DELETE ON cn3_user.TRANSACTION TO truongcn3;

-- GRANT SELECT, INSERT, UPDATE, DELETE ON cn3_user.CHINHANH TO nhanvien3;
GRANT SELECT, INSERT, UPDATE, DELETE ON cn3_user.LAIXE TO nhanvien3;
GRANT SELECT, INSERT, UPDATE, DELETE ON cn3_user.PHUONGTIEN TO nhanvien3;
GRANT SELECT, INSERT, UPDATE, DELETE ON cn3_user.DICHVU TO nhanvien3;
GRANT SELECT, INSERT, UPDATE, DELETE ON cn3_user.KHACHHANG_V1 TO nhanvien3;
GRANT SELECT, INSERT, UPDATE, DELETE ON cn3_user.KHACHHANG_V2 TO nhanvien3;
GRANT SELECT, INSERT, UPDATE, DELETE ON cn3_user.HOADON TO nhanvien3;
GRANT SELECT, INSERT, UPDATE, DELETE ON cn3_user.TRANSACTION TO nhanvien3;

COMMIT;

-- Tạo user và gán vai trò
CREATE USER giamdoc3 IDENTIFIED BY gd_password;
GRANT GiamDoc TO giamdoc3;

CREATE USER truongcn3 IDENTIFIED BY tcn_password;
GRANT TruongChiNhanh TO truongcn3;

CREATE USER nhanvien3 IDENTIFIED BY nv_password;
GRANT NhanVien TO nhanvien3;

COMMIT;

-- CHINHANH
INSERT INTO CHINHANH VALUES ('CN3', 'Hà Nội', '99 Giải Phóng, Hà Nội');

-- LAIXE
INSERT INTO LAIXE VALUES ('LX11', 'Mai Văn U', TO_DATE('1983-02-14', 'YYYY-MM-DD'), '0921234567', 'HN123', 'CN3');
INSERT INTO LAIXE VALUES ('LX12', 'Tô Thị V', TO_DATE('1986-08-10', 'YYYY-MM-DD'), '0922345678', 'HN456', 'CN3');
INSERT INTO LAIXE VALUES ('LX13', 'Vũ Văn W', TO_DATE('1990-11-20', 'YYYY-MM-DD'), '0923456789', 'HN789', 'CN3');
INSERT INTO LAIXE VALUES ('LX14', 'Đặng Thị X', TO_DATE('1989-03-25', 'YYYY-MM-DD'), '0924567890', 'HN012', 'CN3');
INSERT INTO LAIXE VALUES ('LX15', 'Lương Văn Y', TO_DATE('1987-06-15', 'YYYY-MM-DD'), '0925678901', 'HN345', 'CN3');

-- PHUONGTIEN
INSERT INTO PHUONGTIEN VALUES ('HN123', 'Sedan', 'Toyota', 4, 'Sẵn sàng');
INSERT INTO PHUONGTIEN VALUES ('HN456', 'SUV', 'Mitsubishi', 7, 'Sẵn sàng');
INSERT INTO PHUONGTIEN VALUES ('HN789', 'Hatchback', 'Suzuki', 5, 'Đang bảo trì');
INSERT INTO PHUONGTIEN VALUES ('HN012', 'Truck', 'Hyundai', 2, 'Sẵn sàng');
INSERT INTO PHUONGTIEN VALUES ('HN345', 'Van', 'Ford', 9, 'Đang sử dụng');

-- DICHVU
INSERT INTO DICHVU VALUES ('DV1', 'Thuê xe tự lái', 'Thuê xe 4 chỗ', 500000);
INSERT INTO DICHVU VALUES ('DV2', 'Thuê xe có tài xế', 'Thuê xe 7 chỗ', 800000);
INSERT INTO DICHVU VALUES ('DV3', 'Thuê xe tải', 'Thuê xe vận chuyển hàng hóa', 700000);
INSERT INTO DICHVU VALUES ('DV4', 'Thuê xe limousine', 'Xe cao cấp', 1200000);
INSERT INTO DICHVU VALUES ('DV5', 'Thuê xe hợp đồng', 'Thuê dài hạn', 1000000);

-- KHACHHANG_V1
INSERT INTO KHACHHANG_V1 VALUES ('KH11', 'Nguyễn Thị Z', TO_DATE('1991-01-05', 'YYYY-MM-DD'), '0951234567', '12 Kim Mã, Hà Nội');
INSERT INTO KHACHHANG_V1 VALUES ('KH12', 'Phan Văn A1', TO_DATE('1984-05-10', 'YYYY-MM-DD'), '0952345678', '23 Láng Hạ, Hà Nội');
INSERT INTO KHACHHANG_V1 VALUES ('KH13', 'Đỗ Thị B1', TO_DATE('1989-08-30', 'YYYY-MM-DD'), '0953456789', '45 Trần Duy Hưng, Hà Nội');
INSERT INTO KHACHHANG_V1 VALUES ('KH14', 'Võ Văn C1', TO_DATE('1992-12-20', 'YYYY-MM-DD'), '0954567890', '67 Phạm Văn Đồng, Hà Nội');
INSERT INTO KHACHHANG_V1 VALUES ('KH15', 'Trần Thị D1', TO_DATE('1995-07-18', 'YYYY-MM-DD'), '0955678901', '89 Cầu Giấy, Hà Nội');

-- KHACHHANG_V2
INSERT INTO KHACHHANG_V2 VALUES ('KH11', TO_DATE('2025-01-10', 'YYYY-MM-DD'), 900000, 'CN3');
INSERT INTO KHACHHANG_V2 VALUES ('KH12', TO_DATE('2025-02-15', 'YYYY-MM-DD'), 1000000, 'CN3');
INSERT INTO KHACHHANG_V2 VALUES ('KH13', TO_DATE('2025-03-20', 'YYYY-MM-DD'), 750000, 'CN3');
INSERT INTO KHACHHANG_V2 VALUES ('KH14', TO_DATE('2025-04-25', 'YYYY-MM-DD'), 1050000, 'CN3');
INSERT INTO KHACHHANG_V2 VALUES ('KH15', TO_DATE('2025-05-01', 'YYYY-MM-DD'), 1150000, 'CN3');

-- HOADON
INSERT INTO HOADON VALUES ('HD11', 'KH11', 'LX11', 'DV1', TO_DATE('2025-05-10', 'YYYY-MM-DD'), 500000, 'CN3');
INSERT INTO HOADON VALUES ('HD12', 'KH12', 'LX12', 'DV2', TO_DATE('2025-05-11', 'YYYY-MM-DD'), 800000, 'CN3');
INSERT INTO HOADON VALUES ('HD13', 'KH13', 'LX13', 'DV3', TO_DATE('2025-05-12', 'YYYY-MM-DD'), 700000, 'CN3');
INSERT INTO HOADON VALUES ('HD14', 'KH14', 'LX14', 'DV4', TO_DATE('2025-05-13', 'YYYY-MM-DD'), 1200000, 'CN3');
INSERT INTO HOADON VALUES ('HD15', 'KH15', 'LX15', 'DV5', TO_DATE('2025-05-14', 'YYYY-MM-DD'), 1000000, 'CN3');

-- TRANSACTION
INSERT INTO TRANSACTION VALUES ('GD11', 'HD11', TO_DATE('2025-05-10', 'YYYY-MM-DD'), 115, 500000, 'CN3');
INSERT INTO TRANSACTION VALUES ('GD12', 'HD12', TO_DATE('2025-05-11', 'YYYY-MM-DD'), 145, 800000, 'CN3');
INSERT INTO TRANSACTION VALUES ('GD13', 'HD13', TO_DATE('2025-05-12', 'YYYY-MM-DD'), 170, 700000, 'CN3');
INSERT INTO TRANSACTION VALUES ('GD14', 'HD14', TO_DATE('2025-05-13', 'YYYY-MM-DD'), 220, 1200000, 'CN3');
INSERT INTO TRANSACTION VALUES ('GD15', 'HD15', TO_DATE('2025-05-14', 'YYYY-MM-DD'), 190, 1000000, 'CN3');


-- Xóa dữ liệu
TRUNCATE TABLE CHINHANH;
TRUNCATE TABLE DICHVU;
TRUNCATE TABLE HOADON;
TRUNCATE TABLE KHACHHANG_V1;
TRUNCATE TABLE KHACHHANG_V2;
TRUNCATE TABLE LAIXE;
TRUNCATE TABLE PHUONGTIEN;
TRUNCATE TABLE TRANSACTION;

-- Lưu thay đổi
COMMIT;

SELECT COUNT(*) FROM TRANSACTION t;

-- Yêu cầu 1: 
SELECT COUNT(*) FROM TRANSACTION@CN1_LINK;
SELECT * FROM TRANSACTION@CN2_LINK;

--Truy vấn 7: AVG - Tính trung bình số km giao dịch tại CN1 và CN3
SELECT AVG(SoKm) AS TrungBinhSoKm
 FROM (
 	SELECT SoKm FROM cn1_user.TRANSACTION@CN1_LINK_GIAMDOC
 	UNION ALL
 	SELECT SoKm FROM cn3_user.TRANSACTION
 );

-- Truy vấn 8: GROUP BY, COUNT - Đếm số hóa đơn theo chi nhánh tại CN2 và CN1
SELECT ChiNhanhID, COUNT(MaHD) AS SoHoaDon
 FROM ( SELECT ChiNhanhID, MaHD
FROM cn2_user.HOADON@CN2_LINK_GIAMDOC
 	UNION ALL
 	SELECT ChiNhanhID, MaHD FROM cn1_user.HOADON@CN1_LINK_GIAMDOC
 )
 GROUP BY ChiNhanhID;

-- Truy vấn 9: Tìm giá trị lớn nhất và nhỏ nhất của tổng tiền hóa đơn tại CN1 và CN2
SELECT MAX(TongTien) AS MaxTongTien, MIN(TongTien) AS MinTongTien
 FROM (
 	SELECT TongTien FROM cn1_user.HOADON@CN1_LINK_GIAMDOC
 	UNION ALL
 	SELECT TongTien FROM cn2_user.HOADON@CN2_LINK_GIAMDOC
 );

-- Truy vấn 10: Tìm chi nhánh có số lượng giao dịch lớn hơn 1 tại CN1, CN2, CN3
SELECT ChiNhanhID, COUNT(MAGIAODICH) AS SoGiaoDich
 FROM (
 	SELECT ChiNhanhID, MAGIAODICH FROM cn3_user.TRANSACTION
 	UNION ALL
 	SELECT ChiNhanhID, MAGIAODICH FROM cn2_user.TRANSACTION@CN2_LINK_GIAMDOC
 	UNION ALL
 	SELECT ChiNhanhID, MAGIAODICH FROM cn1_user.TRANSACTION@CN1_LINK_GIAMDOC
 )
 GROUP BY ChiNhanhID
 HAVING COUNT(MAGIAODICH) > 1;

INSERT INTO LAIXE VALUES ('LX11', 'Mai Văn U', TO_DATE('1983-02-14', 'YYYY-MM-DD'), '0921234567', 'HN123', 'CN3');
INSERT INTO PHUONGTIEN VALUES ('HN123', 'Sedan', 'Toyota', 4, 'Sẵn sàng');
INSERT INTO DICHVU VALUES ('DV1', 'Thuê xe tự lái', 'Thuê xe 4 chỗ', 500000);
INSERT INTO KHACHHANG_V1 VALUES ('KH11', 'Nguyễn Thị Z', TO_DATE('1991-01-05', 'YYYY-MM-DD'), '0951234567', '12 Kim Mã, Hà Nội');
INSERT INTO KHACHHANG_V2 VALUES ('KH11', TO_DATE('2025-01-10', 'YYYY-MM-DD'), 900000, 'CN3');

INSERT INTO HOADON VALUES ('HDcn311', 'KH11', 'LX11', 'DV1', TO_DATE('2025-05-10', 'YYYY-MM-DD'), 5000000, 'CN3');
INSERT INTO HOADON VALUES ('HDcn312', 'KH11', 'LX12', 'DV2', TO_DATE('2025-05-11', 'YYYY-MM-DD'), 5000000, 'CN3');
INSERT INTO HOADON VALUES ('HDcn313', 'KH11', 'LX13', 'DV3', TO_DATE('2025-05-12', 'YYYY-MM-DD'),5000000, 'CN3');
INSERT INTO HOADON VALUES ('HDcn314', 'KH11', 'LX14', 'DV4', TO_DATE('2025-05-13', 'YYYY-MM-DD'), 5000000, 'CN3');
INSERT INTO HOADON VALUES ('HDcn315', 'KH11', 'LX15', 'DV5', TO_DATE('2025-05-14', 'YYYY-MM-DD'), 5000000, 'CN3');

INSERT INTO HOADON VALUES ('HDCN316', 'KH11', 'LX11', 'DV1', TO_DATE('2025-05-10', 'YYYY-MM-DD'), 5000000, 'CN3');
INSERT INTO HOADON VALUES ('HDCN317', 'KH11', 'LX11', 'DV1', TO_DATE('2025-05-10', 'YYYY-MM-DD'), 5000000, 'CN3');
COMMIT;
SELECT * FROM KHACHHANG_V1 kv WHERE KV.MAKH='KH11';

--FUNCTION: Tính tổng số tiền mà một khách hàng đã chi tiêu tại tất cả 3 chi nhánh (CN1, CN2, CN3) dựa vào mã khách hàng (MaKH).
CREATE OR REPLACE FUNCTION get_total_spending_by_customer (
 	p_makh IN VARCHAR2
 ) RETURN NUMBER AS
 	v_total_spending NUMBER := 0;
 	v_spending NUMBER;
 BEGIN
 	-- CN3 (local)
 	BEGIN
     	SELECT NVL(SUM(TongTien), 0) INTO v_spending FROM HOADON WHERE MaKH = p_makh;
     	v_total_spending := v_total_spending + v_spending;
 	EXCEPTION WHEN NO_DATA_FOUND THEN NULL; END;

 	-- CN2 (qua DB link)
 	BEGIN
     	SELECT NVL(SUM(TongTien), 0) INTO v_spending FROM HOADON@CN2_LINK WHERE MaKH = p_makh;
     	v_total_spending := v_total_spending + v_spending;
 	EXCEPTION WHEN NO_DATA_FOUND THEN NULL; END;

 	-- CN1 (qua DB link)
 	BEGIN
     	SELECT NVL(SUM(TongTien), 0) INTO v_spending FROM HOADON@CN1_LINK WHERE MaKH = p_makh;
     	v_total_spending := v_total_spending + v_spending;
 	EXCEPTION WHEN NO_DATA_FOUND THEN NULL; END;

 	RETURN v_total_spending;
 EXCEPTION
 	WHEN OTHERS THEN
     	RAISE_APPLICATION_ERROR(-20004, 'Lỗi tính tổng chi tiêu: ' || SQLERRM);
 END;
/
SELECT * FROM KHACHHANG_V2 WHERE MAKH='KH11';

SELECT get_total_spending_by_customer('KH11') AS TotalSpending FROM DUAL;

-- TRIGGER:  Không cho phép khách hàng tạo quá 10 hóa đơn trong một ngày trên toàn hệ thống (cả CN1, CN2, CN3).
CREATE OR REPLACE TRIGGER trg_LimitTongHoaDonToanHeThong
 BEFORE INSERT ON HOADON
 FOR EACH ROW
 DECLARE
 	v_hd_cn2 NUMBER := 0;
 	v_hd_cn1 NUMBER := 0;
 	v_hd_cn3 NUMBER := 0;
 	v_tong   NUMBER;
 	v_ngay   DATE := TRUNC(:NEW.NgayLap);
 BEGIN
 	-- Đếm tại CN3
 	SELECT COUNT(*) INTO v_hd_cn3 FROM HOADON WHERE MaKH = :NEW.MaKH AND TRUNC(NgayLap) = v_ngay;

 	-- CN1 (link)
 	BEGIN
     	SELECT COUNT(*) INTO v_hd_cn1 FROM HOADON@CN1_LINK WHERE MaKH = :NEW.MaKH AND TRUNC(NgayLap) = v_ngay;
 	EXCEPTION WHEN OTHERS THEN v_hd_cn1 := 0; END;

 	-- CN2 (link)
 	BEGIN
     	SELECT COUNT(*) INTO v_hd_cn2 FROM HOADON@CN2_LINK WHERE MaKH = :NEW.MaKH AND TRUNC(NgayLap) = v_ngay;
 	EXCEPTION WHEN OTHERS THEN v_hd_cn2 := 0; END;

 	v_tong := v_hd_cn1 + v_hd_cn2 + v_hd_cn3 + 1;

 	IF v_tong > 10 THEN
     	RAISE_APPLICATION_ERROR(-20003, 'Khách hàng đã vượt quá 10 hóa đơn trong ngày!');
 	END IF;
 END;
/

INSERT INTO HOADON VALUES ('HDcn3111', 'KH11', 'LX11', 'DV1', TO_DATE('2025-05-10', 'YYYY-MM-DD'), 5000000, 'CN3');
INSERT INTO HOADON VALUES ('HDcn3122', 'KH11', 'LX12', 'DV2', TO_DATE('2025-05-10', 'YYYY-MM-DD'), 5000000, 'CN3');
INSERT INTO HOADON VALUES ('HDcn3133', 'KH11', 'LX13', 'DV3', TO_DATE('2025-05-10', 'YYYY-MM-DD'),5000000, 'CN3');
INSERT INTO HOADON VALUES ('HDcn3144', 'KH11', 'LX14', 'DV4', TO_DATE('2025-05-10', 'YYYY-MM-DD'), 5000000, 'CN3');
INSERT INTO HOADON VALUES ('HDcn3141', 'KH11', 'LX11', 'DV4', TO_DATE('2025-05-10', 'YYYY-MM-DD'), 5000000, 'CN3');
INSERT INTO HOADON VALUES ('HDcn3142', 'KH11', 'LX12', 'DV4', TO_DATE('2025-05-10', 'YYYY-MM-DD'), 5000000, 'CN3');
INSERT INTO HOADON VALUES ('HDcn3143', 'KH11', 'LX13', 'DV4', TO_DATE('2025-05-10', 'YYYY-MM-DD'), 5000000, 'CN3');

SELECT MaKH
FROM cn3_user.HOADON WHERE ChiNhanhID = 'CN3'
INTERSECT
SELECT MaKH FROM cn2_user.HOADON@CN2_LINK_GIAMDOC WHERE ChiNhanhID = 'CN2'
INTERSECT
SELECT MaKH FROM cn1_user.HOADON@CN1_LINK_GIAMDOC WHERE ChiNhanhID = 'CN1';

--  Cho phép thêm hoặc xóa hóa đơn của khách hàng và đồng thời cập nhật tổng chi tiêu của khách trong bảng KHACHHANG_V2 tương ứng với chi nhánh.
CREATE OR REPLACE PROCEDURE manage_customer_transaction (
    p_makh        IN VARCHAR2,
    p_mahd        IN VARCHAR2,
    p_tongtien    IN NUMBER,
    p_chinhanhid  IN VARCHAR2,
    p_ngaylap     IN DATE,
    p_malx        IN VARCHAR2,
    p_madv        IN VARCHAR2,
    p_action      IN VARCHAR2 -- 'INSERT' hoặc 'DELETE'
) AS
    v_tongtien NUMBER;
    v_chinhanh_dangky VARCHAR2(10);
BEGIN
    -- Xác định chi nhánh đăng ký của khách hàng
    BEGIN
        SELECT ChiNhanhDangKy INTO v_chinhanh_dangky
        FROM KHACHHANG_V2@CN1_LINK
        WHERE MaKH = p_makh;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            BEGIN
                SELECT ChiNhanhDangKy INTO v_chinhanh_dangky
                FROM KHACHHANG_V2@CN2_LINK
                WHERE MaKH = p_makh;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    SELECT ChiNhanhDangKy INTO v_chinhanh_dangky
                    FROM KHACHHANG_V2
                    WHERE MaKH = p_makh;
            END;
    END;

    -- INSERT
    IF p_action = 'INSERT' THEN
        IF p_chinhanhid = 'CN1' THEN
            INSERT INTO HOADON@CN1_LINK VALUES (p_mahd, p_makh, p_tongtien, p_chinhanhid, p_ngaylap, p_malx, p_madv);
        ELSIF p_chinhanhid = 'CN2' THEN
            INSERT INTO HOADON@CN2_LINK VALUES (p_mahd, p_makh, p_tongtien, p_chinhanhid, p_ngaylap, p_malx, p_madv);
        ELSIF p_chinhanhid = 'CN3' THEN
            INSERT INTO HOADON VALUES (p_mahd, p_makh, p_tongtien, p_chinhanhid, p_ngaylap, p_malx, p_madv);
        END IF;

        -- UPDATE tổng chi tiêu
        IF v_chinhanh_dangky = 'CN1' THEN
            SELECT TongTien INTO v_tongtien
            FROM KHACHHANG_V2@CN1_LINK
            WHERE MaKH = p_makh;
            UPDATE KHACHHANG_V2@CN1_LINK
            SET TongTien = v_tongtien + p_tongtien
            WHERE MaKH = p_makh;

        ELSIF v_chinhanh_dangky = 'CN2' THEN
            SELECT TongTien INTO v_tongtien
            FROM KHACHHANG_V2@CN2_LINK
            WHERE MaKH = p_makh;
            UPDATE KHACHHANG_V2@CN2_LINK
            SET TongTien = v_tongtien + p_tongtien
            WHERE MaKH = p_makh;

        ELSIF v_chinhanh_dangky = 'CN3' THEN
            SELECT TongTien INTO v_tongtien
            FROM KHACHHANG_V2
            WHERE MaKH = p_makh;
            UPDATE KHACHHANG_V2
            SET TongTien = v_tongtien + p_tongtien
            WHERE MaKH = p_makh;
        END IF;

    -- DELETE
    ELSIF p_action = 'DELETE' THEN
        IF p_chinhanhid = 'CN1' THEN
            DELETE FROM TRANSACTION@CN1_LINK WHERE MaHD = p_mahd;
            DELETE FROM HOADON@CN1_LINK WHERE MaHD = p_mahd;

        ELSIF p_chinhanhid = 'CN2' THEN
            DELETE FROM TRANSACTION@CN2_LINK WHERE MaHD = p_mahd;
            DELETE FROM HOADON@CN2_LINK WHERE MaHD = p_mahd;

        ELSIF p_chinhanhid = 'CN3' THEN
            DELETE FROM TRANSACTION WHERE MaHD = p_mahd;
            DELETE FROM HOADON WHERE MaHD = p_mahd;
        END IF;

        -- UPDATE giảm chi tiêu
        IF v_chinhanh_dangky = 'CN1' THEN
            SELECT TongTien INTO v_tongtien
            FROM KHACHHANG_V2@CN1_LINK
            WHERE MaKH = p_makh;
            UPDATE KHACHHANG_V2@CN1_LINK
            SET TongTien = v_tongtien - p_tongtien
            WHERE MaKH = p_makh;

        ELSIF v_chinhanh_dangky = 'CN2' THEN
            SELECT TongTien INTO v_tongtien
            FROM KHACHHANG_V2@CN2_LINK
            WHERE MaKH = p_makh;
            UPDATE KHACHHANG_V2@CN2_LINK
            SET TongTien = v_tongtien - p_tongtien
            WHERE MaKH = p_makh;

        ELSIF v_chinhanh_dangky = 'CN3' THEN
            SELECT TongTien INTO v_tongtien
            FROM KHACHHANG_V2
            WHERE MaKH = p_makh;
            UPDATE KHACHHANG_V2
            SET TongTien = v_tongtien - p_tongtien
            WHERE MaKH = p_makh;
        END IF;
    END IF;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
/

COMMIT;
SELECT * FROM KHACHHANG_V1 kv;

-- Yêu cầu 2:

-- Yêu cầu 3: 

CREATE OR REPLACE PROCEDURE CapNhatOrChenDichVu (
    p_MaDV      IN VARCHAR2,
    p_TenDV     IN VARCHAR2,
    p_MoTa      IN VARCHAR2,
    p_DonGia    IN NUMBER
)
IS
    v_count     INTEGER;
BEGIN
    -- CN3 - nội bộ
    SELECT COUNT(*) INTO v_count FROM DICHVU WHERE MaDV = p_MaDV;
    IF v_count > 0 THEN
        UPDATE DICHVU
        SET DonGia = p_DonGia,
            TenDV = p_TenDV,
            MoTa = p_MoTa
        WHERE MaDV = p_MaDV;
    ELSE
        INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia)
        VALUES (p_MaDV, p_TenDV, p_MoTa, p_DonGia);
    END IF;

    -- CN1 - qua DB link
    SELECT COUNT(*) INTO v_count FROM DICHVU@CN1_LINK WHERE MaDV = p_MaDV;
    IF v_count > 0 THEN
        UPDATE DICHVU@CN1_LINK
        SET DonGia = p_DonGia,
            TenDV = p_TenDV,
            MoTa = p_MoTa
        WHERE MaDV = p_MaDV;
    ELSE
        INSERT INTO DICHVU@CN1_LINK (MaDV, TenDV, MoTa, DonGia)
        VALUES (p_MaDV, p_TenDV, p_MoTa, p_DonGia);
    END IF;

    -- CN2 - qua DB link
    SELECT COUNT(*) INTO v_count FROM DICHVU@CN2_LINK WHERE MaDV = p_MaDV;
    IF v_count > 0 THEN
        UPDATE DICHVU@CN2_LINK
        SET DonGia = p_DonGia,
            TenDV = p_TenDV,
            MoTa = p_MoTa
        WHERE MaDV = p_MaDV;
    ELSE
        INSERT INTO DICHVU@CN2_LINK (MaDV, TenDV, MoTa, DonGia)
        VALUES (p_MaDV, p_TenDV, p_MoTa, p_DonGia);
    END IF;

    COMMIT;
END;
/

BEGIN
    CapNhatOrChenDichVu(
        p_MaDV   => 'DV3999',
        p_TenDV  => 'Dịch vụ rửa xe',
        p_MoTa   => 'Rửa xe 4 chỗ cao cấp',
        p_DonGia => 120000
    );
END;
/

SELECT * FROM DICHVU d;
