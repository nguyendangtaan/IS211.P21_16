
ALTER SESSION SET "_ORACLE_SCRIPT"=true;

-- Tạo user cho chi nhánh CN2
CREATE USER cn2_user IDENTIFIED BY password123;
GRANT CONNECT, RESOURCE TO cn2_user;
GRANT DBA TO cn2_user;

-- Kết nối với user cn2_user
CONN cn2_user/password123;

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

ALTER USER cn2_user quota UNLIMITED ON USERS;


-- Tạo DB_LINK đến CN1 và CN3
CREATE DATABASE LINK CN1_LINK
    CONNECT TO cn1_user IDENTIFIED BY password123
    USING '(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=26.94.39.56)(PORT=1521))(CONNECT_DATA=(SERVICE_NAME=orcl)))';

CREATE DATABASE LINK CN3_LINK
   CONNECT TO cn3_user IDENTIFIED BY password123
   USING '(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=26.98.198.216)(PORT=1521))(CONNECT_DATA=(SERVICE_NAME=orcl21)))';


CREATE PUBLIC DATABASE LINK CN1_LINK_GIAMDOC CONNECT TO giamdoc1 IDENTIFIED BY gd_password
          USING'(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=26.94.39.56)(PORT=1521))(CONNECT_DATA=(SERVICE_NAME=orcl)))';


--TruongChiNhanh
          CREATE PUBLIC DATABASE LINK CN1_LINK_TCN CONNECT TO truongcn1 IDENTIFIED BY tcn_password
          USING'(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=26.94.39.56)(PORT=1521))(CONNECT_DATA=(SERVICE_NAME=orcl)))';

          CREATE PUBLIC DATABASE LINK CN3_LINK_GIAMDOC CONNECT TO truongcn3 IDENTIFIED BY tcn_password
          USING'(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=26.98.198.216)(PORT=1521))(CONNECT_DATA=(SERVICE_NAME=orcl21)))';

            --NhanVien
           CREATE PUBLIC DATABASE LINK CN1_LINK_NV CONNECT TO nhanvien1 IDENTIFIED BY nv_password
          USING'(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=26.94.39.56)(PORT=1521))(CONNECT_DATA=(SERVICE_NAME=orcl)))';

          CREATE PUBLIC DATABASE LINK CN3_LINK_NV CONNECT TO nhanvien3 IDENTIFIED BY nv_password
          USING'(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=26.98.198.216)(PORT=1521))(CONNECT_DATA=(SERVICE_NAME=orcl21)))';

          CREATE PUBLIC DATABASE LINK CN3_LINK_GIAMDOC CONNECT TO giamdoc3 IDENTIFIED BY gd_password
          USING'(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=26.98.198.216)(PORT=1521))(CONNECT_DATA=(SERVICE_NAME=orcl21)))';



SELECT * FROM dba_db_links;

SELECT * FROM cn1_user.HOADON@CN1_LINK_GIAMDOC;

SELECT * FROM cn1_user.HOADON@CN1_LINK_TCN;

SELECT * FROM cn1_user.HOADON@CN1_LINK_NV;

SELECT MaDV, TenDV, DonGia FROM DICHVU WHERE DonGia = 500000;



GRANT SELECT ON cn2_user.CHINHANH TO giamdoc2;
GRANT SELECT ON cn2_user.LAIXE TO giamdoc2;
GRANT SELECT ON cn2_user.PHUONGTIEN TO giamdoc2;
GRANT SELECT ON cn2_user.DICHVU TO giamdoc2;
GRANT SELECT ON cn2_user.KHACHHANG_V1 TO giamdoc2;
GRANT SELECT ON cn2_user.KHACHHANG_V2 TO giamdoc2;
GRANT SELECT ON cn2_user.HOADON TO giamdoc2;
GRANT SELECT ON cn2_user.TRANSACTION TO giamdoc2;

COMMIT;

-- Gán toàn quyền trên bảng CHINHANH
GRANT SELECT, INSERT, UPDATE, DELETE ON cn2_user.CHINHANH TO truongcn2;

-- Gán toàn quyền trên bảng LAIXE
GRANT SELECT, INSERT, UPDATE, DELETE ON cn2_user.LAIXE TO truongcn2;

-- Gán toàn quyền trên bảng PHUONGTIEN
GRANT SELECT, INSERT, UPDATE, DELETE ON cn2_user.PHUONGTIEN TO truongcn2;

-- Gán toàn quyền trên bảng DICHVU
GRANT SELECT, INSERT, UPDATE, DELETE ON cn2_user.DICHVU TO truongcn2;

-- Gán toàn quyền trên bảng KHACHHANG_V1
GRANT SELECT, INSERT, UPDATE, DELETE ON cn2_user.KHACHHANG_V1 TO truongcn2;

-- Gán toàn quyền trên bảng KHACHHANG_V2
GRANT SELECT, INSERT, UPDATE, DELETE ON cn2_user.KHACHHANG_V2 TO truongcn2;

-- Gán toàn quyền trên bảng HOADON
GRANT SELECT, INSERT, UPDATE, DELETE ON cn2_user.HOADON TO truongcn2;

-- Gán toàn quyền trên bảng TRANSACTION
GRANT SELECT, INSERT, UPDATE, DELETE ON cn2_user.TRANSACTION TO truongcn2;

-- Toàn quyền thao tác tại CN2 (tất cả bảng trong schema cn2_user)
GRANT SELECT, INSERT, UPDATE, DELETE ON cn2_user.CHINHANH TO nhanvien2;
GRANT SELECT, INSERT, UPDATE, DELETE ON cn2_user.LAIXE TO nhanvien2;
GRANT SELECT, INSERT, UPDATE, DELETE ON cn2_user.PHUONGTIEN TO nhanvien2;
GRANT SELECT, INSERT, UPDATE, DELETE ON cn2_user.DICHVU TO nhanvien2;
GRANT SELECT, INSERT, UPDATE, DELETE ON cn2_user.KHACHHANG_V1 TO nhanvien2;
GRANT SELECT, INSERT, UPDATE, DELETE ON cn2_user.KHACHHANG_V2 TO nhanvien2;
GRANT SELECT, INSERT, UPDATE, DELETE ON cn2_user.HOADON TO nhanvien2;
GRANT SELECT, INSERT, UPDATE, DELETE ON cn2_user.TRANSACTION TO nhanvien2;


-- Tạo user và gán vai trò
CREATE USER giamdoc2 IDENTIFIED BY gd_password;
GRANT GiamDoc TO giamdoc2;
GRANT CONNECT TO giamdoc2

CREATE USER truongcn2 IDENTIFIED BY tcn_password;
GRANT TruongChiNhanh TO truongcn2;
GRANT CONNECT TO truongcn2

CREATE USER nhanvien2 IDENTIFIED BY nv_password;
GRANT NhanVien TO nhanvien2;
GRANT CONNECT TO nhanvien2
COMMIT;
--------
SELECT grantee, granted_role
FROM dba_role_privs
WHERE granted_role IN ('GIAMDOC', 'TRUONGCHINHANH', 'NHANVIEN');

----------------


Truy vấn 5: GROUP BY, SUM - Tính tổng tiền hóa đơn theo khách hàng tại CN1 và CN2
Mô tả: Tính tổng TongTien trong bảng HOADON của từng khách hàng tại CN1 và CN2.
User thực hiện: truongcn2
Truy vấn SQL:


SELECT MaKH, SUM(TongTien) AS TongTien
 FROM (
 	SELECT MaKH, TongTien FROM cn2_user.HOADON
 	UNION ALL
 	SELECT MaKH, TongTien FROM cn1_user.HOADON@CN1_LINK_GIAMDOC
 )
 GROUP BY MaKH;


Truy vấn 6: GROUP BY, HAVING - Tìm khách hàng có tổng tiền hóa đơn lớn hơn 2 triệu tại CN2 và CN3
Mô tả: Tìm các khách hàng có tổng TongTien > 2 triệu tại CN1 và CN3.
User thực hiện: giamdoc2
Truy vấn SQL:

SELECT MaKH, SUM(TongTien) AS TongTien
 FROM (
 	SELECT MaKH, TongTien FROM cn1_user.HOADON@CN1_LINK_GIAMDOC
 	UNION ALL
 	SELECT MaKH, TongTien FROM cn3_user.HOADON@CN3_LINK_GIAMDOC
 )
 GROUP BY MaKH
 HAVING SUM(TongTien) > 2000000;


SELECT * FROM KHACHHANG_V2 WHERE MAKH='KH11';

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
 	-- Đếm tại CN2
 	SELECT COUNT(*) INTO v_hd_cn2 FROM HOADON WHERE MaKH = :NEW.MaKH AND TRUNC(NgayLap) = v_ngay;

 	-- CN1 (link)
 	BEGIN
     	SELECT COUNT(*) INTO v_hd_cn1 FROM HOADON@CN1_LINK WHERE MaKH = :NEW.MaKH AND TRUNC(NgayLap) = v_ngay;
 	EXCEPTION WHEN OTHERS THEN v_hd_cn1 := 0; END;

 	-- CN3 (link)
 	BEGIN
     	SELECT COUNT(*) INTO v_hd_cn3 FROM HOADON@CN3_LINK WHERE MaKH = :NEW.MaKH AND TRUNC(NgayLap) = v_ngay;
 	EXCEPTION WHEN OTHERS THEN v_hd_cn3 := 0; END;

 	v_tong := v_hd_cn1 + v_hd_cn2 + v_hd_cn3 + 1;

 	IF v_tong > 10 THEN
     	RAISE_APPLICATION_ERROR(-20003, 'Khách hàng đã vượt quá 10 hóa đơn trong ngày!');
 	END IF;
 END;
 /


CREATE OR REPLACE TRIGGER trg_LimitTongHoaDonToanHeThong
BEFORE INSERT ON HOADON
FOR EACH ROW
DECLARE
    v_hd_cn2 NUMBER := 0; -- local
    v_hd_cn1 NUMBER := 0;
    v_hd_cn3 NUMBER := 0;
    v_tong   NUMBER;
    v_ngay   DATE := TRUNC(:NEW.NgayLap);
BEGIN
    -- CN2 (local)
    SELECT COUNT(*) INTO v_hd_cn2
    FROM HOADON
    WHERE MaKH = :NEW.MaKH AND TRUNC(NgayLap) = v_ngay;

    -- CN1 (qua link)
    BEGIN
        SELECT COUNT(*) INTO v_hd_cn1
        FROM HOADON@CN1_LINK
        WHERE MaKH = :NEW.MaKH AND TRUNC(NgayLap) = v_ngay;
    EXCEPTION
        WHEN OTHERS THEN
            v_hd_cn1 := 0;
    END;

    -- CN3 (qua link)
    BEGIN
        SELECT COUNT(*) INTO v_hd_cn3
        FROM HOADON@CN3_LINK
        WHERE MaKH = :NEW.MaKH AND TRUNC(NgayLap) = v_ngay;
    EXCEPTION
        WHEN OTHERS THEN
            v_hd_cn3 := 0;
    END;

    v_tong := v_hd_cn1 + v_hd_cn2 + v_hd_cn3 + 1; -- cộng thêm đơn đang chèn

    IF v_tong > 10 THEN
        RAISE_APPLICATION_ERROR(-20003,
            'Khách hàng đã có quá 10 đơn thuê xe trong ngày trên toàn hệ thống');
    END IF;
END;
/


CREATE OR REPLACE PROCEDURE manage_customer_transaction (
    p_makh        IN VARCHAR2,
    p_mahd        IN VARCHAR2,
    p_tongtien    IN NUMBER,
    p_chinhanhid  IN VARCHAR2,
    p_ngaylap     IN DATE,
    p_malx        IN VARCHAR2,
    p_madv        IN VARCHAR2,
    p_action      IN VARCHAR2
) AS
    v_tongtien              NUMBER;
    v_chinhanh_dangky       VARCHAR2(10);
BEGIN
    -- Xác định chi nhánh đăng ký của khách hàng
    BEGIN
        SELECT ChiNhanhDangKy INTO v_chinhanh_dangky
        FROM KHACHHANG_V2;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            BEGIN
                SELECT ChiNhanhDangKy INTO v_chinhanh_dangky
                FROM KHACHHANG_V2@CN1_LINK
                WHERE MaKH = p_makh;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    SELECT ChiNhanhDangKy INTO v_chinhanh_dangky
                    FROM KHACHHANG_V2@CN3_LINK
                    WHERE MaKH = p_makh;
            END;
    END;

    -- XỬ LÝ INSERT
    IF p_action = 'INSERT' THEN
        IF p_chinhanhid = 'CN1' THEN
            INSERT INTO HOADON@CN1_LINK (MaHD, MaKH, TongTien, ChiNhanhID, NgayLap, MaLX, MaDV)
            VALUES (p_mahd, p_makh, p_tongtien, p_chinhanhid, p_ngaylap, p_malx, p_madv);
        ELSIF p_chinhanhid = 'CN2' THEN
            INSERT INTO HOADON (MaHD, MaKH, TongTien, ChiNhanhID, NgayLap, MaLX, MaDV)
            VALUES (p_mahd, p_makh, p_tongtien, p_chinhanhid, p_ngaylap, p_malx, p_madv);
        ELSIF p_chinhanhid = 'CN3' THEN
            INSERT INTO HOADON@CN3_LINK (MaHD, MaKH, TongTien, ChiNhanhID, NgayLap, MaLX, MaDV)
            VALUES (p_mahd, p_makh, p_tongtien, p_chinhanhid, p_ngaylap, p_malx, p_madv);
        END IF;

        -- CẬP NHẬT TỔNG CHI TIÊU
        IF v_chinhanh_dangky = 'CN1' THEN
            SELECT TongTien INTO v_tongtien
            FROM KHACHHANG_V2@CN1_LINK
            WHERE MaKH = p_makh;

            UPDATE KHACHHANG_V2@CN1_LINK
            SET TongTien = v_tongtien + p_tongtien
            WHERE MaKH = p_makh;

        ELSIF v_chinhanh_dangky = 'CN2' THEN
            SELECT TongTien INTO v_tongtien
            FROM KHACHHANG_V2
            WHERE MaKH = p_makh;

            UPDATE KHACHHANG_V2
            SET TongTien = v_tongtien + p_tongtien
            WHERE MaKH = p_makh;

        ELSIF v_chinhanh_dangky = 'CN3' THEN
            SELECT TongTien INTO v_tongtien
            FROM KHACHHANG_V2@CN3_LINK
            WHERE MaKH = p_makh;

            UPDATE KHACHHANG_V2@CN3_LINK
            SET TongTien = v_tongtien + p_tongtien
            WHERE MaKH = p_makh;
        END IF;

    -- XỬ LÝ DELETE
    ELSIF p_action = 'DELETE' THEN
        IF p_chinhanhid = 'CN1' THEN
            DELETE FROM TRANSACTION@CN1_LINK WHERE MaHD = p_mahd;
            DELETE FROM HOADON@CN1_LINK WHERE MaHD = p_mahd;

        ELSIF p_chinhanhid = 'CN2' THEN
            DELETE FROM TRANSACTION WHERE MaHD = p_mahd;
            DELETE FROM HOADON WHERE MaHD = p_mahd;

        ELSIF p_chinhanhid = 'CN3' THEN
            DELETE FROM TRANSACTION@CN3_LINK WHERE MaHD = p_mahd;
            DELETE FROM HOADON@CN3_LINK WHERE MaHD = p_mahd;
        END IF;

        -- GIẢM TỔNG CHI TIÊU
        IF v_chinhanh_dangky = 'CN1' THEN
            SELECT TongTien INTO v_tongtien
            FROM KHACHHANG_V2@CN1_LINK
            WHERE MaKH = p_makh;

            UPDATE KHACHHANG_V2@CN1_LINK
            SET TongTien = v_tongtien - p_tongtien
            WHERE MaKH = p_makh;

        ELSIF v_chinhanh_dangky = 'CN2' THEN
            SELECT TongTien INTO v_tongtien
            FROM KHACHHANG_V2
            WHERE MaKH = p_makh;

            UPDATE KHACHHANG_V2
            SET TongTien = v_tongtien - p_tongtien
            WHERE MaKH = p_makh;

        ELSIF v_chinhanh_dangky = 'CN3' THEN
            SELECT TongTien INTO v_tongtien
            FROM KHACHHANG_V2@CN3_LINK
            WHERE MaKH = p_makh;

            UPDATE KHACHHANG_V2@CN3_LINK
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

SELECT 

COMMIT;
SELECT * FROM DICHVU d

SELECT SUM(TongTien) AS TongTien_CN2
FROM HOADON
WHERE MaKH = 'KH11';


DELETE FROM KHACHHANG_V2
WHERE ROWID NOT IN (
    SELECT MIN(ROWID)
    FROM KHACHHANG_V2
    WHERE MaKH = 'KH11'
);

COMMIT;
BEGIN
         manage_customer_transaction(
        p_makh => 'KH11',
        p_mahd => 'HD101JD',
        p_tongtien => 1000000,
        p_chinhanhid => 'CN2',
        p_ngaylap => TO_DATE('2025-05-29 00:43:00', 'YYYY-MM-DD HH24:MI:SS'),
        p_malx => 'LX1', 
        p_madv => 'DV001', 
        p_action => 'INSERT'
    );
END;
/

SELECT * FROM KHACHHANG_V1 kv







CREATE OR REPLACE PROCEDURE CapNhatOrChenDichVu (
    p_MaDV      IN VARCHAR2,
    p_TenDV     IN VARCHAR2,
    p_MoTa      IN VARCHAR2,
    p_DonGia    IN NUMBER
)
IS
    v_count     INTEGER;
BEGIN
    -- CN2 - nội bộ
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

    -- CN3 - qua DB link
    SELECT COUNT(*) INTO v_count FROM DICHVU@CN3_LINK WHERE MaDV = p_MaDV;
    IF v_count > 0 THEN
        UPDATE DICHVU@CN3_LINK
        SET DonGia = p_DonGia,
            TenDV = p_TenDV,
            MoTa = p_MoTa
        WHERE MaDV = p_MaDV;
    ELSE
        INSERT INTO DICHVU@CN3_LINK (MaDV, TenDV, MoTa, DonGia)
        VALUES (p_MaDV, p_TenDV, p_MoTa, p_DonGia);
    END IF;

    COMMIT;
END;
/


BEGIN
    CapNhatOrChenDichVu(
        p_MaDV   => 'DV943',
        p_TenDV  => 'Dịch vụ rửa xe',
        p_MoTa   => 'Rửa xe 4 chỗ cao cấp',
        p_DonGia => 120000
    );
END;
/



-- 1. Xóa giao dịch
DELETE FROM TRANSACTION;

-- 2. Xóa hóa đơn
DELETE FROM HOADON;

-- 3. Xóa thông tin đăng ký của khách hàng
DELETE FROM KHACHHANG_V2;

-- 4. Xóa thông tin cá nhân của khách hàng
DELETE FROM KHACHHANG_V1;

-- 5. Xóa tài xế
DELETE FROM LAIXE;

-- 6. Xóa phương tiện
DELETE FROM PHUONGTIEN;

-- 7. Xóa dịch vụ
DELETE FROM DICHVU;

-- 8. Xóa chi nhánh
DELETE FROM CHINHANH;

-- Ghi nhận thay đổi
COMMIT;


-- CHINHANH
INSERT INTO CHINHANH VALUES ('CN2', 'Đà Nẵng', '99 Giải Phóng, Đà Nẵng');

-- LAIXE
INSERT INTO LAIXE VALUES ('LX11', 'Mai Văn U', TO_DATE('1983-02-14', 'YYYY-MM-DD'), '0921234567', 'HN123', 'CN2');
INSERT INTO LAIXE VALUES ('LX12', 'Tô Thị V', TO_DATE('1986-08-10', 'YYYY-MM-DD'), '0922345678', 'HN456', 'CN2');
INSERT INTO LAIXE VALUES ('LX13', 'Vũ Văn W', TO_DATE('1990-11-20', 'YYYY-MM-DD'), '0923456789', 'HN789', 'CN2');
INSERT INTO LAIXE VALUES ('LX14', 'Đặng Thị X', TO_DATE('1989-03-25', 'YYYY-MM-DD'), '0924567890', 'HN012', 'CN2');
INSERT INTO LAIXE VALUES ('LX15', 'Lương Văn Y', TO_DATE('1987-06-15', 'YYYY-MM-DD'), '0925678901', 'HN345', 'CN2');

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
INSERT INTO KHACHHANG_V1 VALUES ('KH11', 'Nguyễn Thị Z', TO_DATE('1991-01-05', 'YYYY-MM-DD'), '0951234567', '12 Kim Mã, Đà Nẵng');
INSERT INTO KHACHHANG_V1 VALUES ('KH12', 'Phan Văn A1', TO_DATE('1984-05-10', 'YYYY-MM-DD'), '0952345678', '23 Láng Hạ, Đà Nẵng');
INSERT INTO KHACHHANG_V1 VALUES ('KH13', 'Đỗ Thị B1', TO_DATE('1989-08-30', 'YYYY-MM-DD'), '0953456789', '45 Trần Duy Hưng, Đà Nẵng');
INSERT INTO KHACHHANG_V1 VALUES ('KH14', 'Võ Văn C1', TO_DATE('1992-12-20', 'YYYY-MM-DD'), '0954567890', '67 Phạm Văn Đồng, Đà Nẵng');
INSERT INTO KHACHHANG_V1 VALUES ('KH15', 'Trần Thị D1', TO_DATE('1995-07-18', 'YYYY-MM-DD'), '0955678901', '89 Cầu Giấy, Đà Nẵng');


INSERT INTO KHACHHANG_V1 VALUES ('KH15', 'Trần Thị Mai', TO_DATE('1995-07-18', 'YYYY-MM-DD'), '0955678901', 'quận 2, TP.HCM');
INSERT INTO KHACHHANG_V2 VALUES ('KH15', TO_DATE('2025-05-01', 'YYYY-MM-DD'), 1150000, 'CN2');

INSERT INTO KHACHHANG_V1 VALUES ('KH15', 'Trần Thị Mai', TO_DATE('1995-07-18', 'YYYY-MM-DD'), '0955678901', 'quận 2, TP.HCM');
INSERT INTO KHACHHANG_V2 VALUES ('KH15', TO_DATE('2025-05-01', 'YYYY-MM-DD'), 1150000, 'CN1');

INSERT INTO KHACHHANG_V1 VALUES ('KH15', 'Trần Thị Mai', TO_DATE('1995-07-18', 'YYYY-MM-DD'), '0955678901', 'quận 2, TP.HCM');
INSERT INTO KHACHHANG_V2 VALUES ('KH15', TO_DATE('2025-05-01', 'YYYY-MM-DD'), 1150000, 'CN3');

SELECT * FROM KHACHHANG_V2 kv
-- KHACHHANG_V2
INSERT INTO KHACHHANG_V2 VALUES ('KH11', TO_DATE('2025-01-10', 'YYYY-MM-DD'), 900000, 'CN2');
INSERT INTO KHACHHANG_V2 VALUES ('KH12', TO_DATE('2025-02-15', 'YYYY-MM-DD'), 1000000, 'CN2');
INSERT INTO KHACHHANG_V2 VALUES ('KH13', TO_DATE('2025-03-20', 'YYYY-MM-DD'), 750000, 'CN2');
INSERT INTO KHACHHANG_V2 VALUES ('KH14', TO_DATE('2025-04-25', 'YYYY-MM-DD'), 1050000, 'CN2');
INSERT INTO KHACHHANG_V2 VALUES ('KH15', TO_DATE('2025-05-01', 'YYYY-MM-DD'), 1150000, 'CN2');

-- HOADON
INSERT INTO HOADON VALUES ('HD11', 'KH11', 'LX11', 'DV1', TO_DATE('2025-05-10', 'YYYY-MM-DD'), 500000, 'CN2');
INSERT INTO HOADON VALUES ('HD12', 'KH12', 'LX12', 'DV2', TO_DATE('2025-05-11', 'YYYY-MM-DD'), 800000, 'CN2');
INSERT INTO HOADON VALUES ('HD13', 'KH13', 'LX13', 'DV3', TO_DATE('2025-05-12', 'YYYY-MM-DD'), 700000, 'CN2');
INSERT INTO HOADON VALUES ('HD14', 'KH14', 'LX14', 'DV4', TO_DATE('2025-05-13', 'YYYY-MM-DD'), 1200000, 'CN2');
INSERT INTO HOADON VALUES ('HD15', 'KH15', 'LX15', 'DV5', TO_DATE('2025-05-14', 'YYYY-MM-DD'), 1000000, 'CN2');

-- TRANSACTION
INSERT INTO TRANSACTION VALUES ('GD11', 'HD11', TO_DATE('2025-05-10', 'YYYY-MM-DD'), 115, 500000, 'CN2');
INSERT INTO TRANSACTION VALUES ('GD12', 'HD12', TO_DATE('2025-05-11', 'YYYY-MM-DD'), 145, 800000, 'CN2');
INSERT INTO TRANSACTION VALUES ('GD13', 'HD13', TO_DATE('2025-05-12', 'YYYY-MM-DD'), 170, 700000, 'CN2');
INSERT INTO TRANSACTION VALUES ('GD14', 'HD14', TO_DATE('2025-05-13', 'YYYY-MM-DD'), 220, 1200000, 'CN2');
INSERT INTO TRANSACTION VALUES ('GD15', 'HD15', TO_DATE('2025-05-14', 'YYYY-MM-DD'), 190, 1000000, 'CN2');

-- Lưu thay đổi
COMMIT;


SELECT * FROM DICHVU d;

SELECT * FROM HOADON h;

SELECT * FROM KHACHHANG_V1;

SELECT * FROM KHACHHANG_V2;

SELECT * FROM TRANSACTION t;

SELECT * FROM CHINHANH c;

SELECT * FROM PHUONGTIEN p;

SELECT * FROM LAIXE l;


COMMIT;


SELECT*FROM HOADON@CN1_LINK

SELECT*FROM LAIXE@CN1_LINK

SELECT * FROM DICHVU@CN1_LINK;

SELECT * FROM HOADON@CN1_LINK;

SELECT * FROM KHACHHANG_V1@CN1_LINK;

SELECT * FROM TRANSACTION@CN1_LINK;

SELECT * FROM CHINHANH@CN1_LINK;

SELECT * FROM PHUONGTIEN@CN1_LINK;

SELECT * FROM LAIXE@CN1_LINK;

-- Ghi nhận thay đổi
COMMIT;




CREATE OR REPLACE TRIGGER trg_CheckTongTienHoaDon
BEFORE INSERT ON HOADON
FOR EACH ROW
DECLARE
    v_tong_cn1 NUMBER := 0;
    v_tong_cn2 NUMBER := 0;
    v_tong_cn3 NUMBER := 0;
    v_ngay DATE := TRUNC(:NEW.NgayLap);
    v_tong NUMBER := 0;
BEGIN
    -- Tổng tại CN1 (local)
    SELECT NVL(SUM(TongTien), 0) INTO v_tong_cn1
    FROM HOADON
    WHERE MaKH = :NEW.MaKH AND TRUNC(NgayLap) = v_ngay;

    -- CN2 (remote)
    BEGIN
        SELECT NVL(SUM(TongTien), 0) INTO v_tong_cn2
        FROM HOADON@CN1_LINK
        WHERE MaKH = :NEW.MaKH AND TRUNC(NgayLap) = v_ngay;
    EXCEPTION WHEN OTHERS THEN
        v_tong_cn2 := 0;
    END;

    -- CN3 (remote)
    BEGIN
        SELECT NVL(SUM(TongTien), 0) INTO v_tong_cn3
        FROM HOADON@CN3_LINK
        WHERE MaKH = :NEW.MaKH AND TRUNC(NgayLap) = v_ngay;
    EXCEPTION WHEN OTHERS THEN
        v_tong_cn3 := 0;
    END;

    -- Tổng cộng
    v_tong := v_tong_cn1 + v_tong_cn2 + v_tong_cn3 + :NEW.TongTien;

    -- Nếu vượt quá 10 triệu thì báo lỗi
    IF v_tong > 10000000 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Tổng hóa đơn trong ngày vượt quá 10 triệu');
    END IF;
END;
/



BEGIN
  PROC_QuanLyGiaoDichPhanTan(
    p_action      => 'INSERT',
    p_magd        => 'GD99',
    p_mahd        => 'HD35',
    p_ngay        => SYSDATE,
    p_sokm        => 100,
    p_thanhtien   => 800000,
    p_chinhanh    => 'CN2'
  );
END;
/

COMMIT;

BEGIN
  PROC_QuanLyGiaoDichPhanTan(
    p_action      => 'UPDATE',
    p_magd        => 'GD36',
    p_mahd        => 'HD35',
    p_ngay        => SYSDATE,
    p_sokm        => 150,
    p_tongtien    => 700000,  -- tăng tiền
    p_chinhanh    => 'CN2'
  );
END;
/
 




INSERT INTO CHINHANH (ChiNhanhID, TenCN, DiaChi) VALUES ('CN2', 'TP.HCM', 'Trụ sở TP.HCM');
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV001', 'Thuê xe 4 chỗ tự lái', 'Dịch vụ thuê xe 4 chỗ không tài xế', 500000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV002', 'Thuê xe 7 chỗ có tài xế', 'Dịch vụ thuê xe 7 chỗ kèm tài xế', 600000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV003', 'Thuê xe tải nhỏ', 'Dịch vụ chở hàng dưới 1 tấn', 700000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV004', 'Thuê xe hợp đồng 16 chỗ', 'Xe hợp đồng du lịch', 800000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV005', 'Thuê xe limousine', 'Xe limousine cao cấp', 400000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV006', 'Cho thuê xe cưới', 'Xe cưới trọn gói theo giờ', 500000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV007', 'Dịch vụ đưa đón sân bay', 'Xe đưa đón sân bay', 600000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV008', 'Thuê xe theo tháng', 'Cho thuê xe theo tháng cho công ty', 700000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV009', 'Thuê xe du lịch', 'Tour xe riêng tham quan', 800000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV010', 'Thuê xe công tác', 'Xe dành cho đoàn công tác', 400000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV011', 'Thuê xe 4 chỗ tự lái', 'Dịch vụ thuê xe 4 chỗ không tài xế', 500000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV012', 'Thuê xe 7 chỗ có tài xế', 'Dịch vụ thuê xe 7 chỗ kèm tài xế', 600000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV013', 'Thuê xe tải nhỏ', 'Dịch vụ chở hàng dưới 1 tấn', 700000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV014', 'Thuê xe hợp đồng 16 chỗ', 'Xe hợp đồng du lịch', 800000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV015', 'Thuê xe limousine', 'Xe limousine cao cấp', 400000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV016', 'Cho thuê xe cưới', 'Xe cưới trọn gói theo giờ', 500000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV017', 'Dịch vụ đưa đón sân bay', 'Xe đưa đón sân bay', 600000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV018', 'Thuê xe theo tháng', 'Cho thuê xe theo tháng cho công ty', 700000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV019', 'Thuê xe du lịch', 'Tour xe riêng tham quan', 800000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV020', 'Thuê xe công tác', 'Xe dành cho đoàn công tác', 400000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV021', 'Thuê xe 4 chỗ tự lái', 'Dịch vụ thuê xe 4 chỗ không tài xế', 500000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV022', 'Thuê xe 7 chỗ có tài xế', 'Dịch vụ thuê xe 7 chỗ kèm tài xế', 600000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV023', 'Thuê xe tải nhỏ', 'Dịch vụ chở hàng dưới 1 tấn', 700000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV024', 'Thuê xe hợp đồng 16 chỗ', 'Xe hợp đồng du lịch', 800000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV025', 'Thuê xe limousine', 'Xe limousine cao cấp', 400000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV026', 'Cho thuê xe cưới', 'Xe cưới trọn gói theo giờ', 500000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV027', 'Dịch vụ đưa đón sân bay', 'Xe đưa đón sân bay', 600000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV028', 'Thuê xe theo tháng', 'Cho thuê xe theo tháng cho công ty', 700000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV029', 'Thuê xe du lịch', 'Tour xe riêng tham quan', 800000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV030', 'Thuê xe công tác', 'Xe dành cho đoàn công tác', 400000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV031', 'Thuê xe 4 chỗ tự lái', 'Dịch vụ thuê xe 4 chỗ không tài xế', 500000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV032', 'Thuê xe 7 chỗ có tài xế', 'Dịch vụ thuê xe 7 chỗ kèm tài xế', 600000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV033', 'Thuê xe tải nhỏ', 'Dịch vụ chở hàng dưới 1 tấn', 700000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV034', 'Thuê xe hợp đồng 16 chỗ', 'Xe hợp đồng du lịch', 800000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV035', 'Thuê xe limousine', 'Xe limousine cao cấp', 400000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV036', 'Cho thuê xe cưới', 'Xe cưới trọn gói theo giờ', 500000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV037', 'Dịch vụ đưa đón sân bay', 'Xe đưa đón sân bay', 600000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV038', 'Thuê xe theo tháng', 'Cho thuê xe theo tháng cho công ty', 700000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV039', 'Thuê xe du lịch', 'Tour xe riêng tham quan', 800000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV040', 'Thuê xe công tác', 'Xe dành cho đoàn công tác', 400000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV041', 'Thuê xe 4 chỗ tự lái', 'Dịch vụ thuê xe 4 chỗ không tài xế', 500000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV042', 'Thuê xe 7 chỗ có tài xế', 'Dịch vụ thuê xe 7 chỗ kèm tài xế', 600000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV043', 'Thuê xe tải nhỏ', 'Dịch vụ chở hàng dưới 1 tấn', 700000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV044', 'Thuê xe hợp đồng 16 chỗ', 'Xe hợp đồng du lịch', 800000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV045', 'Thuê xe limousine', 'Xe limousine cao cấp', 400000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV046', 'Cho thuê xe cưới', 'Xe cưới trọn gói theo giờ', 500000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV047', 'Dịch vụ đưa đón sân bay', 'Xe đưa đón sân bay', 600000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV048', 'Thuê xe theo tháng', 'Cho thuê xe theo tháng cho công ty', 700000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV049', 'Thuê xe du lịch', 'Tour xe riêng tham quan', 800000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV050', 'Thuê xe công tác', 'Xe dành cho đoàn công tác', 400000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV051', 'Thuê xe 4 chỗ tự lái', 'Dịch vụ thuê xe 4 chỗ không tài xế', 500000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV052', 'Thuê xe 7 chỗ có tài xế', 'Dịch vụ thuê xe 7 chỗ kèm tài xế', 600000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV053', 'Thuê xe tải nhỏ', 'Dịch vụ chở hàng dưới 1 tấn', 700000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV054', 'Thuê xe hợp đồng 16 chỗ', 'Xe hợp đồng du lịch', 800000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV055', 'Thuê xe limousine', 'Xe limousine cao cấp', 400000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV056', 'Cho thuê xe cưới', 'Xe cưới trọn gói theo giờ', 500000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV057', 'Dịch vụ đưa đón sân bay', 'Xe đưa đón sân bay', 600000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV058', 'Thuê xe theo tháng', 'Cho thuê xe theo tháng cho công ty', 700000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV059', 'Thuê xe du lịch', 'Tour xe riêng tham quan', 800000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV060', 'Thuê xe công tác', 'Xe dành cho đoàn công tác', 400000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV061', 'Thuê xe 4 chỗ tự lái', 'Dịch vụ thuê xe 4 chỗ không tài xế', 500000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV062', 'Thuê xe 7 chỗ có tài xế', 'Dịch vụ thuê xe 7 chỗ kèm tài xế', 600000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV063', 'Thuê xe tải nhỏ', 'Dịch vụ chở hàng dưới 1 tấn', 700000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV064', 'Thuê xe hợp đồng 16 chỗ', 'Xe hợp đồng du lịch', 800000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV065', 'Thuê xe limousine', 'Xe limousine cao cấp', 400000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV066', 'Cho thuê xe cưới', 'Xe cưới trọn gói theo giờ', 500000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV067', 'Dịch vụ đưa đón sân bay', 'Xe đưa đón sân bay', 600000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV068', 'Thuê xe theo tháng', 'Cho thuê xe theo tháng cho công ty', 700000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV069', 'Thuê xe du lịch', 'Tour xe riêng tham quan', 800000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV070', 'Thuê xe công tác', 'Xe dành cho đoàn công tác', 400000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV071', 'Thuê xe 4 chỗ tự lái', 'Dịch vụ thuê xe 4 chỗ không tài xế', 500000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV072', 'Thuê xe 7 chỗ có tài xế', 'Dịch vụ thuê xe 7 chỗ kèm tài xế', 600000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV073', 'Thuê xe tải nhỏ', 'Dịch vụ chở hàng dưới 1 tấn', 700000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV074', 'Thuê xe hợp đồng 16 chỗ', 'Xe hợp đồng du lịch', 800000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV075', 'Thuê xe limousine', 'Xe limousine cao cấp', 400000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV076', 'Cho thuê xe cưới', 'Xe cưới trọn gói theo giờ', 500000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV077', 'Dịch vụ đưa đón sân bay', 'Xe đưa đón sân bay', 600000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV078', 'Thuê xe theo tháng', 'Cho thuê xe theo tháng cho công ty', 700000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV079', 'Thuê xe du lịch', 'Tour xe riêng tham quan', 800000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV080', 'Thuê xe công tác', 'Xe dành cho đoàn công tác', 400000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV081', 'Thuê xe 4 chỗ tự lái', 'Dịch vụ thuê xe 4 chỗ không tài xế', 500000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV082', 'Thuê xe 7 chỗ có tài xế', 'Dịch vụ thuê xe 7 chỗ kèm tài xế', 600000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV083', 'Thuê xe tải nhỏ', 'Dịch vụ chở hàng dưới 1 tấn', 700000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV084', 'Thuê xe hợp đồng 16 chỗ', 'Xe hợp đồng du lịch', 800000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV085', 'Thuê xe limousine', 'Xe limousine cao cấp', 400000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV086', 'Cho thuê xe cưới', 'Xe cưới trọn gói theo giờ', 500000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV087', 'Dịch vụ đưa đón sân bay', 'Xe đưa đón sân bay', 600000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV088', 'Thuê xe theo tháng', 'Cho thuê xe theo tháng cho công ty', 700000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV089', 'Thuê xe du lịch', 'Tour xe riêng tham quan', 800000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV090', 'Thuê xe công tác', 'Xe dành cho đoàn công tác', 400000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV091', 'Thuê xe 4 chỗ tự lái', 'Dịch vụ thuê xe 4 chỗ không tài xế', 500000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV092', 'Thuê xe 7 chỗ có tài xế', 'Dịch vụ thuê xe 7 chỗ kèm tài xế', 600000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV093', 'Thuê xe tải nhỏ', 'Dịch vụ chở hàng dưới 1 tấn', 700000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV094', 'Thuê xe hợp đồng 16 chỗ', 'Xe hợp đồng du lịch', 800000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV095', 'Thuê xe limousine', 'Xe limousine cao cấp', 400000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV096', 'Cho thuê xe cưới', 'Xe cưới trọn gói theo giờ', 500000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV097', 'Dịch vụ đưa đón sân bay', 'Xe đưa đón sân bay', 600000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV098', 'Thuê xe theo tháng', 'Cho thuê xe theo tháng cho công ty', 700000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV099', 'Thuê xe du lịch', 'Tour xe riêng tham quan', 800000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV100', 'Thuê xe công tác', 'Xe dành cho đoàn công tác', 400000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV101', 'Thuê xe 4 chỗ tự lái', 'Dịch vụ thuê xe 4 chỗ không tài xế', 500000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV102', 'Thuê xe 7 chỗ có tài xế', 'Dịch vụ thuê xe 7 chỗ kèm tài xế', 600000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV103', 'Thuê xe tải nhỏ', 'Dịch vụ chở hàng dưới 1 tấn', 700000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV104', 'Thuê xe hợp đồng 16 chỗ', 'Xe hợp đồng du lịch', 800000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV105', 'Thuê xe limousine', 'Xe limousine cao cấp', 400000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV106', 'Cho thuê xe cưới', 'Xe cưới trọn gói theo giờ', 500000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV107', 'Dịch vụ đưa đón sân bay', 'Xe đưa đón sân bay', 600000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV108', 'Thuê xe theo tháng', 'Cho thuê xe theo tháng cho công ty', 700000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV109', 'Thuê xe du lịch', 'Tour xe riêng tham quan', 800000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV110', 'Thuê xe công tác', 'Xe dành cho đoàn công tác', 400000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV111', 'Thuê xe 4 chỗ tự lái', 'Dịch vụ thuê xe 4 chỗ không tài xế', 500000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV112', 'Thuê xe 7 chỗ có tài xế', 'Dịch vụ thuê xe 7 chỗ kèm tài xế', 600000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV113', 'Thuê xe tải nhỏ', 'Dịch vụ chở hàng dưới 1 tấn', 700000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV114', 'Thuê xe hợp đồng 16 chỗ', 'Xe hợp đồng du lịch', 800000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV115', 'Thuê xe limousine', 'Xe limousine cao cấp', 400000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV116', 'Cho thuê xe cưới', 'Xe cưới trọn gói theo giờ', 500000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV117', 'Dịch vụ đưa đón sân bay', 'Xe đưa đón sân bay', 600000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV118', 'Thuê xe theo tháng', 'Cho thuê xe theo tháng cho công ty', 700000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV119', 'Thuê xe du lịch', 'Tour xe riêng tham quan', 800000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV120', 'Thuê xe công tác', 'Xe dành cho đoàn công tác', 400000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV121', 'Thuê xe 4 chỗ tự lái', 'Dịch vụ thuê xe 4 chỗ không tài xế', 500000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV122', 'Thuê xe 7 chỗ có tài xế', 'Dịch vụ thuê xe 7 chỗ kèm tài xế', 600000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV123', 'Thuê xe tải nhỏ', 'Dịch vụ chở hàng dưới 1 tấn', 700000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV124', 'Thuê xe hợp đồng 16 chỗ', 'Xe hợp đồng du lịch', 800000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV125', 'Thuê xe limousine', 'Xe limousine cao cấp', 400000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV126', 'Cho thuê xe cưới', 'Xe cưới trọn gói theo giờ', 500000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV127', 'Dịch vụ đưa đón sân bay', 'Xe đưa đón sân bay', 600000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV128', 'Thuê xe theo tháng', 'Cho thuê xe theo tháng cho công ty', 700000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV129', 'Thuê xe du lịch', 'Tour xe riêng tham quan', 800000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV130', 'Thuê xe công tác', 'Xe dành cho đoàn công tác', 400000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV131', 'Thuê xe 4 chỗ tự lái', 'Dịch vụ thuê xe 4 chỗ không tài xế', 500000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV132', 'Thuê xe 7 chỗ có tài xế', 'Dịch vụ thuê xe 7 chỗ kèm tài xế', 600000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV133', 'Thuê xe tải nhỏ', 'Dịch vụ chở hàng dưới 1 tấn', 700000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV134', 'Thuê xe hợp đồng 16 chỗ', 'Xe hợp đồng du lịch', 800000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV135', 'Thuê xe limousine', 'Xe limousine cao cấp', 400000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV136', 'Cho thuê xe cưới', 'Xe cưới trọn gói theo giờ', 500000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV137', 'Dịch vụ đưa đón sân bay', 'Xe đưa đón sân bay', 600000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV138', 'Thuê xe theo tháng', 'Cho thuê xe theo tháng cho công ty', 700000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV139', 'Thuê xe du lịch', 'Tour xe riêng tham quan', 800000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV140', 'Thuê xe công tác', 'Xe dành cho đoàn công tác', 400000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV141', 'Thuê xe 4 chỗ tự lái', 'Dịch vụ thuê xe 4 chỗ không tài xế', 500000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV142', 'Thuê xe 7 chỗ có tài xế', 'Dịch vụ thuê xe 7 chỗ kèm tài xế', 600000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV143', 'Thuê xe tải nhỏ', 'Dịch vụ chở hàng dưới 1 tấn', 700000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV144', 'Thuê xe hợp đồng 16 chỗ', 'Xe hợp đồng du lịch', 800000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV145', 'Thuê xe limousine', 'Xe limousine cao cấp', 400000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV146', 'Cho thuê xe cưới', 'Xe cưới trọn gói theo giờ', 500000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV147', 'Dịch vụ đưa đón sân bay', 'Xe đưa đón sân bay', 600000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV148', 'Thuê xe theo tháng', 'Cho thuê xe theo tháng cho công ty', 700000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV149', 'Thuê xe du lịch', 'Tour xe riêng tham quan', 800000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV150', 'Thuê xe công tác', 'Xe dành cho đoàn công tác', 400000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV151', 'Thuê xe 4 chỗ tự lái', 'Dịch vụ thuê xe 4 chỗ không tài xế', 500000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV152', 'Thuê xe 7 chỗ có tài xế', 'Dịch vụ thuê xe 7 chỗ kèm tài xế', 600000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV153', 'Thuê xe tải nhỏ', 'Dịch vụ chở hàng dưới 1 tấn', 700000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV154', 'Thuê xe hợp đồng 16 chỗ', 'Xe hợp đồng du lịch', 800000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV155', 'Thuê xe limousine', 'Xe limousine cao cấp', 400000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV156', 'Cho thuê xe cưới', 'Xe cưới trọn gói theo giờ', 500000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV157', 'Dịch vụ đưa đón sân bay', 'Xe đưa đón sân bay', 600000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV158', 'Thuê xe theo tháng', 'Cho thuê xe theo tháng cho công ty', 700000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV159', 'Thuê xe du lịch', 'Tour xe riêng tham quan', 800000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV160', 'Thuê xe công tác', 'Xe dành cho đoàn công tác', 400000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV161', 'Thuê xe 4 chỗ tự lái', 'Dịch vụ thuê xe 4 chỗ không tài xế', 500000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV162', 'Thuê xe 7 chỗ có tài xế', 'Dịch vụ thuê xe 7 chỗ kèm tài xế', 600000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV163', 'Thuê xe tải nhỏ', 'Dịch vụ chở hàng dưới 1 tấn', 700000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV164', 'Thuê xe hợp đồng 16 chỗ', 'Xe hợp đồng du lịch', 800000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV165', 'Thuê xe limousine', 'Xe limousine cao cấp', 400000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV166', 'Cho thuê xe cưới', 'Xe cưới trọn gói theo giờ', 500000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV167', 'Dịch vụ đưa đón sân bay', 'Xe đưa đón sân bay', 600000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV168', 'Thuê xe theo tháng', 'Cho thuê xe theo tháng cho công ty', 700000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV169', 'Thuê xe du lịch', 'Tour xe riêng tham quan', 800000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV170', 'Thuê xe công tác', 'Xe dành cho đoàn công tác', 400000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV171', 'Thuê xe 4 chỗ tự lái', 'Dịch vụ thuê xe 4 chỗ không tài xế', 500000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV172', 'Thuê xe 7 chỗ có tài xế', 'Dịch vụ thuê xe 7 chỗ kèm tài xế', 600000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV173', 'Thuê xe tải nhỏ', 'Dịch vụ chở hàng dưới 1 tấn', 700000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV174', 'Thuê xe hợp đồng 16 chỗ', 'Xe hợp đồng du lịch', 800000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV175', 'Thuê xe limousine', 'Xe limousine cao cấp', 400000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV176', 'Cho thuê xe cưới', 'Xe cưới trọn gói theo giờ', 500000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV177', 'Dịch vụ đưa đón sân bay', 'Xe đưa đón sân bay', 600000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV178', 'Thuê xe theo tháng', 'Cho thuê xe theo tháng cho công ty', 700000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV179', 'Thuê xe du lịch', 'Tour xe riêng tham quan', 800000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV180', 'Thuê xe công tác', 'Xe dành cho đoàn công tác', 400000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV181', 'Thuê xe 4 chỗ tự lái', 'Dịch vụ thuê xe 4 chỗ không tài xế', 500000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV182', 'Thuê xe 7 chỗ có tài xế', 'Dịch vụ thuê xe 7 chỗ kèm tài xế', 600000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV183', 'Thuê xe tải nhỏ', 'Dịch vụ chở hàng dưới 1 tấn', 700000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV184', 'Thuê xe hợp đồng 16 chỗ', 'Xe hợp đồng du lịch', 800000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV185', 'Thuê xe limousine', 'Xe limousine cao cấp', 400000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV186', 'Cho thuê xe cưới', 'Xe cưới trọn gói theo giờ', 500000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV187', 'Dịch vụ đưa đón sân bay', 'Xe đưa đón sân bay', 600000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV188', 'Thuê xe theo tháng', 'Cho thuê xe theo tháng cho công ty', 700000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV189', 'Thuê xe du lịch', 'Tour xe riêng tham quan', 800000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV190', 'Thuê xe công tác', 'Xe dành cho đoàn công tác', 400000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV191', 'Thuê xe 4 chỗ tự lái', 'Dịch vụ thuê xe 4 chỗ không tài xế', 500000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV192', 'Thuê xe 7 chỗ có tài xế', 'Dịch vụ thuê xe 7 chỗ kèm tài xế', 600000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV193', 'Thuê xe tải nhỏ', 'Dịch vụ chở hàng dưới 1 tấn', 700000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV194', 'Thuê xe hợp đồng 16 chỗ', 'Xe hợp đồng du lịch', 800000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV195', 'Thuê xe limousine', 'Xe limousine cao cấp', 400000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV196', 'Cho thuê xe cưới', 'Xe cưới trọn gói theo giờ', 500000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV197', 'Dịch vụ đưa đón sân bay', 'Xe đưa đón sân bay', 600000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV198', 'Thuê xe theo tháng', 'Cho thuê xe theo tháng cho công ty', 700000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV199', 'Thuê xe du lịch', 'Tour xe riêng tham quan', 800000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV200', 'Thuê xe công tác', 'Xe dành cho đoàn công tác', 400000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV201', 'Thuê xe 4 chỗ tự lái', 'Dịch vụ thuê xe 4 chỗ không tài xế', 500000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV202', 'Thuê xe 7 chỗ có tài xế', 'Dịch vụ thuê xe 7 chỗ kèm tài xế', 600000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV203', 'Thuê xe tải nhỏ', 'Dịch vụ chở hàng dưới 1 tấn', 700000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV204', 'Thuê xe hợp đồng 16 chỗ', 'Xe hợp đồng du lịch', 800000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV205', 'Thuê xe limousine', 'Xe limousine cao cấp', 400000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV206', 'Cho thuê xe cưới', 'Xe cưới trọn gói theo giờ', 500000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV207', 'Dịch vụ đưa đón sân bay', 'Xe đưa đón sân bay', 600000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV208', 'Thuê xe theo tháng', 'Cho thuê xe theo tháng cho công ty', 700000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV209', 'Thuê xe du lịch', 'Tour xe riêng tham quan', 800000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV210', 'Thuê xe công tác', 'Xe dành cho đoàn công tác', 400000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV211', 'Thuê xe 4 chỗ tự lái', 'Dịch vụ thuê xe 4 chỗ không tài xế', 500000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV212', 'Thuê xe 7 chỗ có tài xế', 'Dịch vụ thuê xe 7 chỗ kèm tài xế', 600000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV213', 'Thuê xe tải nhỏ', 'Dịch vụ chở hàng dưới 1 tấn', 700000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV214', 'Thuê xe hợp đồng 16 chỗ', 'Xe hợp đồng du lịch', 800000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV215', 'Thuê xe limousine', 'Xe limousine cao cấp', 400000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV216', 'Cho thuê xe cưới', 'Xe cưới trọn gói theo giờ', 500000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV217', 'Dịch vụ đưa đón sân bay', 'Xe đưa đón sân bay', 600000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV218', 'Thuê xe theo tháng', 'Cho thuê xe theo tháng cho công ty', 700000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV219', 'Thuê xe du lịch', 'Tour xe riêng tham quan', 800000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV220', 'Thuê xe công tác', 'Xe dành cho đoàn công tác', 400000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV221', 'Thuê xe 4 chỗ tự lái', 'Dịch vụ thuê xe 4 chỗ không tài xế', 500000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV222', 'Thuê xe 7 chỗ có tài xế', 'Dịch vụ thuê xe 7 chỗ kèm tài xế', 600000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV223', 'Thuê xe tải nhỏ', 'Dịch vụ chở hàng dưới 1 tấn', 700000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV224', 'Thuê xe hợp đồng 16 chỗ', 'Xe hợp đồng du lịch', 800000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV225', 'Thuê xe limousine', 'Xe limousine cao cấp', 400000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV226', 'Cho thuê xe cưới', 'Xe cưới trọn gói theo giờ', 500000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV227', 'Dịch vụ đưa đón sân bay', 'Xe đưa đón sân bay', 600000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV228', 'Thuê xe theo tháng', 'Cho thuê xe theo tháng cho công ty', 700000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV229', 'Thuê xe du lịch', 'Tour xe riêng tham quan', 800000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV230', 'Thuê xe công tác', 'Xe dành cho đoàn công tác', 400000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV231', 'Thuê xe 4 chỗ tự lái', 'Dịch vụ thuê xe 4 chỗ không tài xế', 500000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV232', 'Thuê xe 7 chỗ có tài xế', 'Dịch vụ thuê xe 7 chỗ kèm tài xế', 600000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV233', 'Thuê xe tải nhỏ', 'Dịch vụ chở hàng dưới 1 tấn', 700000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV234', 'Thuê xe hợp đồng 16 chỗ', 'Xe hợp đồng du lịch', 800000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV235', 'Thuê xe limousine', 'Xe limousine cao cấp', 400000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV236', 'Cho thuê xe cưới', 'Xe cưới trọn gói theo giờ', 500000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV237', 'Dịch vụ đưa đón sân bay', 'Xe đưa đón sân bay', 600000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV238', 'Thuê xe theo tháng', 'Cho thuê xe theo tháng cho công ty', 700000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV239', 'Thuê xe du lịch', 'Tour xe riêng tham quan', 800000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV240', 'Thuê xe công tác', 'Xe dành cho đoàn công tác', 400000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV241', 'Thuê xe 4 chỗ tự lái', 'Dịch vụ thuê xe 4 chỗ không tài xế', 500000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV242', 'Thuê xe 7 chỗ có tài xế', 'Dịch vụ thuê xe 7 chỗ kèm tài xế', 600000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV243', 'Thuê xe tải nhỏ', 'Dịch vụ chở hàng dưới 1 tấn', 700000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV244', 'Thuê xe hợp đồng 16 chỗ', 'Xe hợp đồng du lịch', 800000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV245', 'Thuê xe limousine', 'Xe limousine cao cấp', 400000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV246', 'Cho thuê xe cưới', 'Xe cưới trọn gói theo giờ', 500000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV247', 'Dịch vụ đưa đón sân bay', 'Xe đưa đón sân bay', 600000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV248', 'Thuê xe theo tháng', 'Cho thuê xe theo tháng cho công ty', 700000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV249', 'Thuê xe du lịch', 'Tour xe riêng tham quan', 800000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV250', 'Thuê xe công tác', 'Xe dành cho đoàn công tác', 400000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV251', 'Thuê xe 4 chỗ tự lái', 'Dịch vụ thuê xe 4 chỗ không tài xế', 500000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV252', 'Thuê xe 7 chỗ có tài xế', 'Dịch vụ thuê xe 7 chỗ kèm tài xế', 600000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV253', 'Thuê xe tải nhỏ', 'Dịch vụ chở hàng dưới 1 tấn', 700000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV254', 'Thuê xe hợp đồng 16 chỗ', 'Xe hợp đồng du lịch', 800000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV255', 'Thuê xe limousine', 'Xe limousine cao cấp', 400000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV256', 'Cho thuê xe cưới', 'Xe cưới trọn gói theo giờ', 500000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV257', 'Dịch vụ đưa đón sân bay', 'Xe đưa đón sân bay', 600000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV258', 'Thuê xe theo tháng', 'Cho thuê xe theo tháng cho công ty', 700000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV259', 'Thuê xe du lịch', 'Tour xe riêng tham quan', 800000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV260', 'Thuê xe công tác', 'Xe dành cho đoàn công tác', 400000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV261', 'Thuê xe 4 chỗ tự lái', 'Dịch vụ thuê xe 4 chỗ không tài xế', 500000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV262', 'Thuê xe 7 chỗ có tài xế', 'Dịch vụ thuê xe 7 chỗ kèm tài xế', 600000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV263', 'Thuê xe tải nhỏ', 'Dịch vụ chở hàng dưới 1 tấn', 700000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV264', 'Thuê xe hợp đồng 16 chỗ', 'Xe hợp đồng du lịch', 800000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV265', 'Thuê xe limousine', 'Xe limousine cao cấp', 400000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV266', 'Cho thuê xe cưới', 'Xe cưới trọn gói theo giờ', 500000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV267', 'Dịch vụ đưa đón sân bay', 'Xe đưa đón sân bay', 600000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV268', 'Thuê xe theo tháng', 'Cho thuê xe theo tháng cho công ty', 700000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV269', 'Thuê xe du lịch', 'Tour xe riêng tham quan', 800000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV270', 'Thuê xe công tác', 'Xe dành cho đoàn công tác', 400000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV271', 'Thuê xe 4 chỗ tự lái', 'Dịch vụ thuê xe 4 chỗ không tài xế', 500000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV272', 'Thuê xe 7 chỗ có tài xế', 'Dịch vụ thuê xe 7 chỗ kèm tài xế', 600000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV273', 'Thuê xe tải nhỏ', 'Dịch vụ chở hàng dưới 1 tấn', 700000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV274', 'Thuê xe hợp đồng 16 chỗ', 'Xe hợp đồng du lịch', 800000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV275', 'Thuê xe limousine', 'Xe limousine cao cấp', 400000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV276', 'Cho thuê xe cưới', 'Xe cưới trọn gói theo giờ', 500000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV277', 'Dịch vụ đưa đón sân bay', 'Xe đưa đón sân bay', 600000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV278', 'Thuê xe theo tháng', 'Cho thuê xe theo tháng cho công ty', 700000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV279', 'Thuê xe du lịch', 'Tour xe riêng tham quan', 800000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV280', 'Thuê xe công tác', 'Xe dành cho đoàn công tác', 400000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV281', 'Thuê xe 4 chỗ tự lái', 'Dịch vụ thuê xe 4 chỗ không tài xế', 500000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV282', 'Thuê xe 7 chỗ có tài xế', 'Dịch vụ thuê xe 7 chỗ kèm tài xế', 600000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV283', 'Thuê xe tải nhỏ', 'Dịch vụ chở hàng dưới 1 tấn', 700000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV284', 'Thuê xe hợp đồng 16 chỗ', 'Xe hợp đồng du lịch', 800000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV285', 'Thuê xe limousine', 'Xe limousine cao cấp', 400000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV286', 'Cho thuê xe cưới', 'Xe cưới trọn gói theo giờ', 500000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV287', 'Dịch vụ đưa đón sân bay', 'Xe đưa đón sân bay', 600000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV288', 'Thuê xe theo tháng', 'Cho thuê xe theo tháng cho công ty', 700000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV289', 'Thuê xe du lịch', 'Tour xe riêng tham quan', 800000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV290', 'Thuê xe công tác', 'Xe dành cho đoàn công tác', 400000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV291', 'Thuê xe 4 chỗ tự lái', 'Dịch vụ thuê xe 4 chỗ không tài xế', 500000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV292', 'Thuê xe 7 chỗ có tài xế', 'Dịch vụ thuê xe 7 chỗ kèm tài xế', 600000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV293', 'Thuê xe tải nhỏ', 'Dịch vụ chở hàng dưới 1 tấn', 700000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV294', 'Thuê xe hợp đồng 16 chỗ', 'Xe hợp đồng du lịch', 800000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV295', 'Thuê xe limousine', 'Xe limousine cao cấp', 400000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV296', 'Cho thuê xe cưới', 'Xe cưới trọn gói theo giờ', 500000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV297', 'Dịch vụ đưa đón sân bay', 'Xe đưa đón sân bay', 600000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV298', 'Thuê xe theo tháng', 'Cho thuê xe theo tháng cho công ty', 700000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV299', 'Thuê xe du lịch', 'Tour xe riêng tham quan', 800000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV300', 'Thuê xe công tác', 'Xe dành cho đoàn công tác', 400000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV301', 'Thuê xe 4 chỗ tự lái', 'Dịch vụ thuê xe 4 chỗ không tài xế', 500000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV302', 'Thuê xe 7 chỗ có tài xế', 'Dịch vụ thuê xe 7 chỗ kèm tài xế', 600000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV303', 'Thuê xe tải nhỏ', 'Dịch vụ chở hàng dưới 1 tấn', 700000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV304', 'Thuê xe hợp đồng 16 chỗ', 'Xe hợp đồng du lịch', 800000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV305', 'Thuê xe limousine', 'Xe limousine cao cấp', 400000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV306', 'Cho thuê xe cưới', 'Xe cưới trọn gói theo giờ', 500000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV307', 'Dịch vụ đưa đón sân bay', 'Xe đưa đón sân bay', 600000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV308', 'Thuê xe theo tháng', 'Cho thuê xe theo tháng cho công ty', 700000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV309', 'Thuê xe du lịch', 'Tour xe riêng tham quan', 800000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV310', 'Thuê xe công tác', 'Xe dành cho đoàn công tác', 400000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV311', 'Thuê xe 4 chỗ tự lái', 'Dịch vụ thuê xe 4 chỗ không tài xế', 500000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV312', 'Thuê xe 7 chỗ có tài xế', 'Dịch vụ thuê xe 7 chỗ kèm tài xế', 600000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV313', 'Thuê xe tải nhỏ', 'Dịch vụ chở hàng dưới 1 tấn', 700000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV314', 'Thuê xe hợp đồng 16 chỗ', 'Xe hợp đồng du lịch', 800000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV315', 'Thuê xe limousine', 'Xe limousine cao cấp', 400000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV316', 'Cho thuê xe cưới', 'Xe cưới trọn gói theo giờ', 500000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV317', 'Dịch vụ đưa đón sân bay', 'Xe đưa đón sân bay', 600000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV318', 'Thuê xe theo tháng', 'Cho thuê xe theo tháng cho công ty', 700000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV319', 'Thuê xe du lịch', 'Tour xe riêng tham quan', 800000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV320', 'Thuê xe công tác', 'Xe dành cho đoàn công tác', 400000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV321', 'Thuê xe 4 chỗ tự lái', 'Dịch vụ thuê xe 4 chỗ không tài xế', 500000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV322', 'Thuê xe 7 chỗ có tài xế', 'Dịch vụ thuê xe 7 chỗ kèm tài xế', 600000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV323', 'Thuê xe tải nhỏ', 'Dịch vụ chở hàng dưới 1 tấn', 700000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV324', 'Thuê xe hợp đồng 16 chỗ', 'Xe hợp đồng du lịch', 800000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV325', 'Thuê xe limousine', 'Xe limousine cao cấp', 400000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV326', 'Cho thuê xe cưới', 'Xe cưới trọn gói theo giờ', 500000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV327', 'Dịch vụ đưa đón sân bay', 'Xe đưa đón sân bay', 600000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV328', 'Thuê xe theo tháng', 'Cho thuê xe theo tháng cho công ty', 700000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV329', 'Thuê xe du lịch', 'Tour xe riêng tham quan', 800000);
INSERT INTO DICHVU (MaDV, TenDV, MoTa, DonGia) VALUES ('DV330', 'Thuê xe công tác', 'Xe dành cho đoàn công tác', 400000);
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX001', 'Bùi Anh Hương', DATE '1973-04-23', '0901913687', 'CN2001', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2001', 'Sedan', 'Kia', 5, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX002', 'Đặng Hoài Quang', DATE '1976-12-13', '0909836267', 'CN2002', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2002', 'Van', 'Ford', 6, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX003', 'Bùi Ngọc Phong', DATE '1992-11-25', '0907176462', 'CN2003', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2003', 'SUV', 'Mazda', 7, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX004', 'Trần Thị Minh', DATE '1987-04-22', '0903999964', 'CN2004', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2004', 'Sedan', 'Toyota', 4, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX005', 'Lê Ngọc Dũng', DATE '1984-02-01', '0903482256', 'CN2005', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2005', 'Van', 'Kia', 5, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX006', 'Bùi Văn Khoa', DATE '1968-02-04', '0907988325', 'CN2006', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2006', 'SUV', 'Ford', 6, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX007', 'Phan Anh Phong', DATE '1971-10-14', '0901360413', 'CN2007', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2007', 'Sedan', 'Mazda', 7, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX008', 'Nguyễn Minh Quang', DATE '1991-05-22', '0906635087', 'CN2008', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2008', 'Van', 'Toyota', 4, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX009', 'Đặng Hoài Phong', DATE '1987-02-19', '0906101655', 'CN2009', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2009', 'SUV', 'Kia', 5, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX010', 'Lê Ngọc Hiếu', DATE '1988-01-09', '0909124251', 'CN2010', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2010', 'Sedan', 'Ford', 6, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX011', 'Lê Xuân Khoa', DATE '1979-12-26', '0908649177', 'CN2011', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2011', 'Van', 'Mazda', 7, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX012', 'Hoàng Hữu Giang', DATE '1968-01-23', '0903575047', 'CN2012', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2012', 'SUV', 'Toyota', 4, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX013', 'Nguyễn Xuân Trang', DATE '1965-01-11', '0903121873', 'CN2013', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2013', 'Sedan', 'Kia', 5, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX014', 'Lê Minh Sơn', DATE '1993-05-12', '0901581986', 'CN2014', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2014', 'Van', 'Ford', 6, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX015', 'Phan Hoài Sơn', DATE '1975-04-25', '0903727935', 'CN2015', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2015', 'SUV', 'Mazda', 7, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX016', 'Nguyễn Anh Phúc', DATE '1977-02-11', '0903439136', 'CN2016', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2016', 'Sedan', 'Toyota', 4, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX017', 'Nguyễn Xuân Khoa', DATE '1972-06-19', '0908950901', 'CN2017', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2017', 'Van', 'Kia', 5, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX018', 'Đặng Xuân Dũng', DATE '1976-04-23', '0909035971', 'CN2018', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2018', 'SUV', 'Ford', 6, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX019', 'Trần Ngọc An', DATE '1974-10-05', '0907738231', 'CN2019', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2019', 'Sedan', 'Mazda', 7, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX020', 'Phan Thị Lan', DATE '1984-06-03', '0901923311', 'CN2020', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2020', 'Van', 'Toyota', 4, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX021', 'Bùi Minh Hương', DATE '1976-09-22', '0904283564', 'CN2021', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2021', 'SUV', 'Kia', 5, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX022', 'Đặng Thị Quang', DATE '1995-02-28', '0907617330', 'CN2022', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2022', 'Sedan', 'Ford', 6, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX023', 'Đỗ Văn Linh', DATE '1993-07-18', '0907669916', 'CN2023', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2023', 'Van', 'Mazda', 7, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX024', 'Vũ Xuân An', DATE '1996-12-16', '0905775640', 'CN2024', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2024', 'SUV', 'Toyota', 4, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX025', 'Đặng Thị Hạnh', DATE '1996-08-29', '0908452780', 'CN2025', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2025', 'Sedan', 'Kia', 5, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX026', 'Lê Anh Nga', DATE '1985-07-18', '0903341557', 'CN2026', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2026', 'Van', 'Ford', 6, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX027', 'Phạm Ngọc Phúc', DATE '1991-09-17', '0909813089', 'CN2027', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2027', 'SUV', 'Mazda', 7, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX028', 'Vũ Thị An', DATE '1973-07-19', '0907869609', 'CN2028', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2028', 'Sedan', 'Toyota', 4, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX029', 'Bùi Hoài Trang', DATE '1985-11-29', '0903297254', 'CN2029', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2029', 'Van', 'Kia', 5, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX030', 'Hoàng Hoài Bình', DATE '1968-12-27', '0906066600', 'CN2030', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2030', 'SUV', 'Ford', 6, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX031', 'Bùi Hoài Hiếu', DATE '1990-12-16', '0901450300', 'CN2031', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2031', 'Sedan', 'Mazda', 7, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX032', 'Hoàng Hoài Dũng', DATE '1966-04-18', '0905826621', 'CN2032', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2032', 'Van', 'Toyota', 4, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX033', 'Phạm Văn Dũng', DATE '1971-06-18', '0905650930', 'CN2033', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2033', 'SUV', 'Kia', 5, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX034', 'Phan Hoài Trang', DATE '1969-10-15', '0908316015', 'CN2034', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2034', 'Sedan', 'Ford', 6, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX035', 'Phan Văn Hương', DATE '1976-06-11', '0903732123', 'CN2035', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2035', 'Van', 'Mazda', 7, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX036', 'Phan Hoài Dung', DATE '1983-07-11', '0906995933', 'CN2036', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2036', 'SUV', 'Toyota', 4, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX037', 'Phan Anh Linh', DATE '1971-03-17', '0901817300', 'CN2037', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2037', 'Sedan', 'Kia', 5, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX038', 'Trần Minh Giang', DATE '1970-09-09', '0902585592', 'CN2038', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2038', 'Van', 'Ford', 6, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX039', 'Phan Xuân Khoa', DATE '1989-10-03', '0905554325', 'CN2039', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2039', 'SUV', 'Mazda', 7, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX040', 'Đỗ Xuân Dung', DATE '1998-08-30', '0901216386', 'CN2040', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2040', 'Sedan', 'Toyota', 4, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX041', 'Đặng Anh Lan', DATE '1981-07-02', '0903735175', 'CN2041', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2041', 'Van', 'Kia', 5, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX042', 'Bùi Minh Hạnh', DATE '1999-08-05', '0909818990', 'CN2042', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2042', 'SUV', 'Ford', 6, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX043', 'Đặng Thị Dũng', DATE '1990-10-29', '0903201710', 'CN2043', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2043', 'Sedan', 'Mazda', 7, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX044', 'Hoàng Xuân Dung', DATE '1968-06-27', '0908414487', 'CN2044', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2044', 'Van', 'Toyota', 4, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX045', 'Hoàng Văn Dũng', DATE '1964-10-28', '0904730545', 'CN2045', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2045', 'SUV', 'Kia', 5, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX046', 'Hoàng Hữu Hạnh', DATE '1965-06-06', '0903184699', 'CN2046', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2046', 'Sedan', 'Ford', 6, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX047', 'Trần Văn Phúc', DATE '1971-10-13', '0908235132', 'CN2047', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2047', 'Van', 'Mazda', 7, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX048', 'Nguyễn Văn Phúc', DATE '1996-09-13', '0902995183', 'CN2048', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2048', 'SUV', 'Toyota', 4, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX049', 'Hoàng Văn Dũng', DATE '1999-07-16', '0903076911', 'CN2049', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2049', 'Sedan', 'Kia', 5, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX050', 'Phạm Hữu Linh', DATE '1991-05-12', '0901490886', 'CN2050', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2050', 'Van', 'Ford', 6, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX051', 'Đỗ Xuân Linh', DATE '1997-02-25', '0903693705', 'CN2051', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2051', 'SUV', 'Mazda', 7, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX052', 'Đỗ Thị Dũng', DATE '1998-01-22', '0901234617', 'CN2052', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2052', 'Sedan', 'Toyota', 4, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX053', 'Hoàng Hữu Sơn', DATE '1973-02-08', '0901072627', 'CN2053', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2053', 'Van', 'Kia', 5, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX054', 'Đặng Xuân Trang', DATE '1977-09-26', '0904105895', 'CN2054', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2054', 'SUV', 'Ford', 6, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX055', 'Phan Anh Nga', DATE '1969-10-16', '0904594921', 'CN2055', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2055', 'Sedan', 'Mazda', 7, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX056', 'Trần Xuân Dũng', DATE '1976-03-04', '0908816533', 'CN2056', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2056', 'Van', 'Toyota', 4, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX057', 'Phan Ngọc Sơn', DATE '1988-10-17', '0901681298', 'CN2057', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2057', 'SUV', 'Kia', 5, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX058', 'Trần Anh Khoa', DATE '1994-08-17', '0908666277', 'CN2058', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2058', 'Sedan', 'Ford', 6, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX059', 'Phạm Anh Khoa', DATE '1965-05-02', '0908180005', 'CN2059', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2059', 'Van', 'Mazda', 7, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX060', 'Phan Hữu An', DATE '1982-12-31', '0909248490', 'CN2060', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2060', 'SUV', 'Toyota', 4, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX061', 'Bùi Thị Dũng', DATE '1994-10-07', '0903405308', 'CN2061', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2061', 'Sedan', 'Kia', 5, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX062', 'Trần Hữu Châu', DATE '1973-08-03', '0907102041', 'CN2062', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2062', 'Van', 'Ford', 6, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX063', 'Đỗ Anh Dũng', DATE '1992-03-17', '0904906904', 'CN2063', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2063', 'SUV', 'Mazda', 7, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX064', 'Đỗ Ngọc Minh', DATE '1982-04-24', '0906974321', 'CN2064', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2064', 'Sedan', 'Toyota', 4, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX065', 'Bùi Ngọc Dung', DATE '1975-07-29', '0908627505', 'CN2065', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2065', 'Van', 'Kia', 5, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX066', 'Đặng Hoài Hiếu', DATE '1993-04-30', '0903258353', 'CN2066', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2066', 'SUV', 'Ford', 6, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX067', 'Trần Hoài An', DATE '1969-08-03', '0904004727', 'CN2067', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2067', 'Sedan', 'Mazda', 7, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX068', 'Hoàng Thị Châu', DATE '1974-06-06', '0909723295', 'CN2068', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2068', 'Van', 'Toyota', 4, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX069', 'Hoàng Hoài Phúc', DATE '1971-12-15', '0909469050', 'CN2069', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2069', 'SUV', 'Kia', 5, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX070', 'Bùi Văn Bình', DATE '1975-08-11', '0908221021', 'CN2070', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2070', 'Sedan', 'Ford', 6, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX071', 'Phan Anh Phong', DATE '1968-01-18', '0908711752', 'CN2071', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2071', 'Van', 'Mazda', 7, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX072', 'Bùi Ngọc Giang', DATE '1978-04-13', '0909245659', 'CN2072', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2072', 'SUV', 'Toyota', 4, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX073', 'Vũ Hoài Dũng', DATE '2000-05-22', '0909230125', 'CN2073', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2073', 'Sedan', 'Kia', 5, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX074', 'Bùi Hữu Quang', DATE '1981-07-03', '0901935113', 'CN2074', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2074', 'Van', 'Ford', 6, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX075', 'Đỗ Anh Tuấn', DATE '1979-12-24', '0906918393', 'CN2075', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2075', 'SUV', 'Mazda', 7, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX076', 'Nguyễn Văn Dung', DATE '1996-12-25', '0907147341', 'CN2076', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2076', 'Sedan', 'Toyota', 4, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX077', 'Vũ Thị Nga', DATE '1987-09-10', '0906790539', 'CN2077', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2077', 'Van', 'Kia', 5, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX078', 'Nguyễn Minh Hiếu', DATE '1979-12-03', '0904936305', 'CN2078', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2078', 'SUV', 'Ford', 6, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX079', 'Hoàng Thị Lan', DATE '1993-09-03', '0903848423', 'CN2079', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2079', 'Sedan', 'Mazda', 7, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX080', 'Đặng Anh Trang', DATE '1987-12-07', '0909636236', 'CN2080', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2080', 'Van', 'Toyota', 4, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX081', 'Đặng Văn Lan', DATE '1990-08-31', '0907337385', 'CN2081', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2081', 'SUV', 'Kia', 5, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX082', 'Đỗ Thị Phúc', DATE '1967-09-06', '0902678672', 'CN2082', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2082', 'Sedan', 'Ford', 6, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX083', 'Bùi Xuân Giang', DATE '1995-10-17', '0906025126', 'CN2083', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2083', 'Van', 'Mazda', 7, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX084', 'Đặng Thị Sơn', DATE '1988-04-01', '0904591668', 'CN2084', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2084', 'SUV', 'Toyota', 4, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX085', 'Hoàng Anh Hiếu', DATE '1975-11-23', '0902542796', 'CN2085', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2085', 'Sedan', 'Kia', 5, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX086', 'Phan Ngọc Châu', DATE '1989-06-26', '0909909769', 'CN2086', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2086', 'Van', 'Ford', 6, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX087', 'Phan Thị Khoa', DATE '1982-06-03', '0909466446', 'CN2087', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2087', 'SUV', 'Mazda', 7, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX088', 'Phan Minh Nga', DATE '1999-05-22', '0907749490', 'CN2088', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2088', 'Sedan', 'Toyota', 4, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX089', 'Lê Văn Quang', DATE '1976-04-21', '0904129604', 'CN2089', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2089', 'Van', 'Kia', 5, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX090', 'Đặng Ngọc Sơn', DATE '1985-06-27', '0908276689', 'CN2090', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2090', 'SUV', 'Ford', 6, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX091', 'Phạm Xuân Phong', DATE '1973-02-10', '0903478727', 'CN2091', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2091', 'Sedan', 'Mazda', 7, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX092', 'Vũ Anh Lan', DATE '1972-10-21', '0902080914', 'CN2092', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2092', 'Van', 'Toyota', 4, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX093', 'Hoàng Hữu Hương', DATE '1980-03-26', '0904961601', 'CN2093', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2093', 'SUV', 'Kia', 5, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX094', 'Lê Minh An', DATE '1998-09-01', '0905120259', 'CN2094', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2094', 'Sedan', 'Ford', 6, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX095', 'Bùi Anh Nga', DATE '1986-06-23', '0901620819', 'CN2095', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2095', 'Van', 'Mazda', 7, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX096', 'Lê Văn Hương', DATE '1981-08-21', '0905660240', 'CN2096', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2096', 'SUV', 'Toyota', 4, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX097', 'Đặng Văn Bình', DATE '1989-01-16', '0902408104', 'CN2097', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2097', 'Sedan', 'Kia', 5, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX098', 'Vũ Xuân Châu', DATE '1982-09-01', '0907658793', 'CN2098', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2098', 'Van', 'Ford', 6, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX099', 'Đỗ Thị Quang', DATE '1967-08-13', '0909812402', 'CN2099', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2099', 'SUV', 'Mazda', 7, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX100', 'Phạm Thị Lan', DATE '1966-07-19', '0906524500', 'CN2100', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2100', 'Sedan', 'Toyota', 4, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX101', 'Vũ Minh Dung', DATE '1993-08-13', '0902792041', 'CN2101', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2101', 'Van', 'Kia', 5, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX102', 'Đặng Anh Hương', DATE '1981-09-21', '0901938272', 'CN2102', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2102', 'SUV', 'Ford', 6, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX103', 'Phan Anh Phúc', DATE '1985-03-13', '0905133011', 'CN2103', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2103', 'Sedan', 'Mazda', 7, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX104', 'Đặng Xuân Khoa', DATE '1989-05-30', '0901353566', 'CN2104', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2104', 'Van', 'Toyota', 4, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX105', 'Phạm Ngọc Sơn', DATE '1983-10-25', '0907454030', 'CN2105', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2105', 'SUV', 'Kia', 5, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX106', 'Bùi Minh Phong', DATE '1996-03-14', '0907517462', 'CN2106', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2106', 'Sedan', 'Ford', 6, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX107', 'Hoàng Thị Hiếu', DATE '1987-06-12', '0905989928', 'CN2107', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2107', 'Van', 'Mazda', 7, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX108', 'Phan Anh Bình', DATE '1974-04-26', '0905597569', 'CN2108', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2108', 'SUV', 'Toyota', 4, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX109', 'Vũ Xuân Nga', DATE '1977-10-19', '0902684358', 'CN2109', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2109', 'Sedan', 'Kia', 5, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX110', 'Trần Xuân Nga', DATE '1969-08-17', '0906482263', 'CN2110', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2110', 'Van', 'Ford', 6, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX111', 'Lê Hoài Dung', DATE '1971-12-27', '0901051603', 'CN2111', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2111', 'SUV', 'Mazda', 7, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX112', 'Phan Thị Dũng', DATE '1973-12-06', '0903647821', 'CN2112', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2112', 'Sedan', 'Toyota', 4, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX113', 'Vũ Xuân Phong', DATE '1977-07-30', '0909025640', 'CN2113', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2113', 'Van', 'Kia', 5, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX114', 'Đỗ Xuân Khoa', DATE '1974-11-24', '0904333024', 'CN2114', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2114', 'SUV', 'Ford', 6, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX115', 'Lê Anh Minh', DATE '1994-11-09', '0904766269', 'CN2115', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2115', 'Sedan', 'Mazda', 7, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX116', 'Đỗ Minh Châu', DATE '1983-11-01', '0908758202', 'CN2116', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2116', 'Van', 'Toyota', 4, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX117', 'Nguyễn Anh Tuấn', DATE '1997-11-02', '0908195804', 'CN2117', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2117', 'SUV', 'Kia', 5, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX118', 'Trần Xuân Giang', DATE '1970-03-08', '0902968815', 'CN2118', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2118', 'Sedan', 'Ford', 6, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX119', 'Đặng Thị Hiếu', DATE '1995-01-30', '0904408213', 'CN2119', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2119', 'Van', 'Mazda', 7, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX120', 'Đặng Anh Dung', DATE '1994-03-29', '0908236157', 'CN2120', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2120', 'SUV', 'Toyota', 4, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX121', 'Phạm Anh Giang', DATE '1991-07-02', '0907853897', 'CN2121', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2121', 'Sedan', 'Kia', 5, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX122', 'Hoàng Minh Tuấn', DATE '1978-06-12', '0908566133', 'CN2122', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2122', 'Van', 'Ford', 6, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX123', 'Đặng Thị An', DATE '1980-12-08', '0908866528', 'CN2123', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2123', 'SUV', 'Mazda', 7, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX124', 'Phạm Anh Nga', DATE '1984-05-18', '0905298752', 'CN2124', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2124', 'Sedan', 'Toyota', 4, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX125', 'Nguyễn Văn Lan', DATE '1975-09-23', '0904939985', 'CN2125', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2125', 'Van', 'Kia', 5, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX126', 'Đỗ Văn An', DATE '1997-09-14', '0905255656', 'CN2126', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2126', 'SUV', 'Ford', 6, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX127', 'Vũ Xuân Dung', DATE '1975-12-16', '0901689962', 'CN2127', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2127', 'Sedan', 'Mazda', 7, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX128', 'Lê Hoài Lan', DATE '1966-07-01', '0908853160', 'CN2128', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2128', 'Van', 'Toyota', 4, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX129', 'Bùi Anh Dung', DATE '1977-06-12', '0905368887', 'CN2129', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2129', 'SUV', 'Kia', 5, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX130', 'Lê Hoài Hương', DATE '1990-03-26', '0907049733', 'CN2130', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2130', 'Sedan', 'Ford', 6, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX131', 'Đỗ Ngọc Quang', DATE '1975-12-16', '0906251441', 'CN2131', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2131', 'Van', 'Mazda', 7, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX132', 'Đặng Hữu Sơn', DATE '1969-05-11', '0908381800', 'CN2132', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2132', 'SUV', 'Toyota', 4, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX133', 'Nguyễn Minh Giang', DATE '1996-09-17', '0901601668', 'CN2133', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2133', 'Sedan', 'Kia', 5, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX134', 'Đặng Anh Dũng', DATE '1988-06-21', '0909303225', 'CN2134', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2134', 'Van', 'Ford', 6, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX135', 'Bùi Hoài Phong', DATE '1965-04-07', '0909270975', 'CN2135', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2135', 'SUV', 'Mazda', 7, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX136', 'Phan Thị Hạnh', DATE '1968-07-17', '0905766683', 'CN2136', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2136', 'Sedan', 'Toyota', 4, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX137', 'Hoàng Minh Trang', DATE '1968-12-26', '0901069218', 'CN2137', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2137', 'Van', 'Kia', 5, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX138', 'Trần Minh Phúc', DATE '1990-09-29', '0902582179', 'CN2138', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2138', 'SUV', 'Ford', 6, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX139', 'Trần Anh Linh', DATE '1981-03-18', '0902779557', 'CN2139', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2139', 'Sedan', 'Mazda', 7, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX140', 'Trần Hoài Phúc', DATE '1967-03-31', '0908617787', 'CN2140', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2140', 'Van', 'Toyota', 4, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX141', 'Nguyễn Hoài Lan', DATE '1981-10-03', '0903169632', 'CN2141', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2141', 'SUV', 'Kia', 5, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX142', 'Phan Văn Châu', DATE '1986-10-17', '0907398678', 'CN2142', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2142', 'Sedan', 'Ford', 6, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX143', 'Lê Minh Minh', DATE '1977-08-19', '0902496331', 'CN2143', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2143', 'Van', 'Mazda', 7, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX144', 'Vũ Anh Khoa', DATE '1966-09-01', '0903585950', 'CN2144', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2144', 'SUV', 'Toyota', 4, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX145', 'Vũ Ngọc Tuấn', DATE '1990-09-19', '0903202624', 'CN2145', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2145', 'Sedan', 'Kia', 5, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX146', 'Bùi Minh Phúc', DATE '1980-01-11', '0908473283', 'CN2146', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2146', 'Van', 'Ford', 6, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX147', 'Đỗ Anh Châu', DATE '1986-07-10', '0908088983', 'CN2147', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2147', 'SUV', 'Mazda', 7, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX148', 'Vũ Thị Bình', DATE '1998-08-22', '0909612440', 'CN2148', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2148', 'Sedan', 'Toyota', 4, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX149', 'Lê Hoài Quang', DATE '1974-04-06', '0909802632', 'CN2149', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2149', 'Van', 'Kia', 5, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX150', 'Vũ Thị Phúc', DATE '1982-07-24', '0906039762', 'CN2150', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2150', 'SUV', 'Ford', 6, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX151', 'Phạm Anh Khoa', DATE '1980-01-08', '0901800747', 'CN2151', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2151', 'Sedan', 'Mazda', 7, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX152', 'Bùi Thị Quang', DATE '1986-12-07', '0908128865', 'CN2152', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2152', 'Van', 'Toyota', 4, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX153', 'Đỗ Ngọc Linh', DATE '1980-01-10', '0905275844', 'CN2153', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2153', 'SUV', 'Kia', 5, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX154', 'Nguyễn Thị Phong', DATE '1985-03-15', '0904012385', 'CN2154', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2154', 'Sedan', 'Ford', 6, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX155', 'Trần Anh Khoa', DATE '1965-03-18', '0906267145', 'CN2155', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2155', 'Van', 'Mazda', 7, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX156', 'Đỗ Ngọc Lan', DATE '1966-11-03', '0904140556', 'CN2156', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2156', 'SUV', 'Toyota', 4, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX157', 'Đỗ Ngọc Dũng', DATE '1971-06-22', '0908277938', 'CN2157', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2157', 'Sedan', 'Kia', 5, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX158', 'Vũ Thị An', DATE '1999-06-07', '0903881241', 'CN2158', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2158', 'Van', 'Ford', 6, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX159', 'Đỗ Hoài Khoa', DATE '1969-02-10', '0907052024', 'CN2159', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2159', 'SUV', 'Mazda', 7, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX160', 'Lê Hữu An', DATE '1991-05-19', '0904201127', 'CN2160', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2160', 'Sedan', 'Toyota', 4, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX161', 'Nguyễn Minh Phúc', DATE '1994-05-21', '0903435283', 'CN2161', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2161', 'Van', 'Kia', 5, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX162', 'Phạm Thị Khoa', DATE '1996-09-03', '0908774990', 'CN2162', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2162', 'SUV', 'Ford', 6, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX163', 'Nguyễn Thị Giang', DATE '1998-10-13', '0903557220', 'CN2163', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2163', 'Sedan', 'Mazda', 7, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX164', 'Nguyễn Hoài Trang', DATE '1983-11-29', '0905070650', 'CN2164', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2164', 'Van', 'Toyota', 4, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX165', 'Vũ Văn Lan', DATE '1999-05-26', '0901132108', 'CN2165', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2165', 'SUV', 'Kia', 5, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX166', 'Đặng Ngọc Bình', DATE '1968-12-18', '0909178834', 'CN2166', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2166', 'Sedan', 'Ford', 6, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX167', 'Đỗ Hoài Hiếu', DATE '1993-04-30', '0902018455', 'CN2167', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2167', 'Van', 'Mazda', 7, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX168', 'Đỗ Xuân Sơn', DATE '1987-11-28', '0902065530', 'CN2168', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2168', 'SUV', 'Toyota', 4, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX169', 'Trần Hoài Tuấn', DATE '1976-02-17', '0906817736', 'CN2169', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2169', 'Sedan', 'Kia', 5, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX170', 'Lê Ngọc Hạnh', DATE '1983-05-20', '0908872548', 'CN2170', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2170', 'Van', 'Ford', 6, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX171', 'Bùi Minh Trang', DATE '1981-09-12', '0906690043', 'CN2171', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2171', 'SUV', 'Mazda', 7, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX172', 'Hoàng Anh Nga', DATE '1981-09-19', '0907044085', 'CN2172', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2172', 'Sedan', 'Toyota', 4, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX173', 'Phạm Ngọc Châu', DATE '1988-11-13', '0909101545', 'CN2173', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2173', 'Van', 'Kia', 5, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX174', 'Lê Hoài Dũng', DATE '1982-03-19', '0907979059', 'CN2174', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2174', 'SUV', 'Ford', 6, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX175', 'Phạm Văn An', DATE '1982-03-25', '0907019442', 'CN2175', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2175', 'Sedan', 'Mazda', 7, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX176', 'Lê Văn Châu', DATE '1993-07-01', '0906666248', 'CN2176', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2176', 'Van', 'Toyota', 4, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX177', 'Phạm Thị Sơn', DATE '1968-01-18', '0904759700', 'CN2177', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2177', 'SUV', 'Kia', 5, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX178', 'Phan Văn Sơn', DATE '1978-09-19', '0905487758', 'CN2178', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2178', 'Sedan', 'Ford', 6, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX179', 'Đặng Hoài Dũng', DATE '1989-01-06', '0902776570', 'CN2179', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2179', 'Van', 'Mazda', 7, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX180', 'Nguyễn Thị Giang', DATE '1968-11-23', '0902980707', 'CN2180', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2180', 'SUV', 'Toyota', 4, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX181', 'Hoàng Hoài Quang', DATE '1996-09-26', '0909361613', 'CN2181', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2181', 'Sedan', 'Kia', 5, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX182', 'Phan Hữu Dũng', DATE '1979-03-16', '0904387157', 'CN2182', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2182', 'Van', 'Ford', 6, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX183', 'Phạm Hoài Lan', DATE '1995-01-20', '0905811005', 'CN2183', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2183', 'SUV', 'Mazda', 7, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX184', 'Hoàng Xuân Nga', DATE '1971-09-13', '0907050592', 'CN2184', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2184', 'Sedan', 'Toyota', 4, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX185', 'Vũ Minh Dung', DATE '1965-06-19', '0908194453', 'CN2185', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2185', 'Van', 'Kia', 5, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX186', 'Bùi Xuân An', DATE '1986-03-21', '0908425238', 'CN2186', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2186', 'SUV', 'Ford', 6, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX187', 'Trần Thị Lan', DATE '1980-10-20', '0906281544', 'CN2187', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2187', 'Sedan', 'Mazda', 7, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX188', 'Nguyễn Anh Bình', DATE '1972-10-19', '0903532555', 'CN2188', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2188', 'Van', 'Toyota', 4, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX189', 'Hoàng Anh Minh', DATE '1974-06-01', '0906105693', 'CN2189', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2189', 'SUV', 'Kia', 5, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX190', 'Hoàng Hữu Minh', DATE '1995-06-22', '0908485810', 'CN2190', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2190', 'Sedan', 'Ford', 6, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX191', 'Vũ Minh Khoa', DATE '1998-08-04', '0902413999', 'CN2191', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2191', 'Van', 'Mazda', 7, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX192', 'Lê Ngọc Hạnh', DATE '1999-04-14', '0902557253', 'CN2192', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2192', 'SUV', 'Toyota', 4, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX193', 'Phan Hữu An', DATE '1981-10-16', '0901467937', 'CN2193', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2193', 'Sedan', 'Kia', 5, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX194', 'Hoàng Anh Quang', DATE '1990-09-03', '0902852907', 'CN2194', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2194', 'Van', 'Ford', 6, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX195', 'Bùi Xuân Dũng', DATE '1993-05-14', '0901800824', 'CN2195', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2195', 'SUV', 'Mazda', 7, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX196', 'Đỗ Văn Phong', DATE '2000-04-25', '0906687145', 'CN2196', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2196', 'Sedan', 'Toyota', 4, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX197', 'Hoàng Ngọc Trang', DATE '1999-06-02', '0903348331', 'CN2197', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2197', 'Van', 'Kia', 5, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX198', 'Phan Minh Linh', DATE '1974-12-15', '0908622050', 'CN2198', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2198', 'SUV', 'Ford', 6, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX199', 'Vũ Thị Châu', DATE '1968-07-21', '0902043436', 'CN2199', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2199', 'Sedan', 'Mazda', 7, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX200', 'Phạm Hoài Châu', DATE '1985-03-27', '0907195728', 'CN2200', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2200', 'Van', 'Toyota', 4, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX201', 'Bùi Anh Hương', DATE '1985-10-22', '0909368933', 'CN2201', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2201', 'SUV', 'Kia', 5, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX202', 'Vũ Hữu Dung', DATE '1997-02-26', '0909485679', 'CN2202', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2202', 'Sedan', 'Ford', 6, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX203', 'Lê Thị Hạnh', DATE '1973-06-12', '0908640887', 'CN2203', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2203', 'Van', 'Mazda', 7, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX204', 'Bùi Xuân Dũng', DATE '1997-01-10', '0907855503', 'CN2204', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2204', 'SUV', 'Toyota', 4, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX205', 'Đỗ Ngọc Bình', DATE '1971-07-13', '0909770751', 'CN2205', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2205', 'Sedan', 'Kia', 5, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX206', 'Hoàng Xuân Khoa', DATE '1983-01-26', '0905932187', 'CN2206', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2206', 'Van', 'Ford', 6, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX207', 'Lê Anh Bình', DATE '1994-12-28', '0906119801', 'CN2207', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2207', 'SUV', 'Mazda', 7, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX208', 'Đặng Văn Dũng', DATE '1973-10-07', '0906849358', 'CN2208', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2208', 'Sedan', 'Toyota', 4, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX209', 'Đặng Ngọc Trang', DATE '1981-09-05', '0908589583', 'CN2209', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2209', 'Van', 'Kia', 5, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX210', 'Đỗ Hữu Dung', DATE '1990-01-19', '0909468532', 'CN2210', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2210', 'SUV', 'Ford', 6, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX211', 'Lê Xuân Châu', DATE '1980-03-26', '0907872422', 'CN2211', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2211', 'Sedan', 'Mazda', 7, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX212', 'Phan Văn Phong', DATE '1966-11-20', '0905653581', 'CN2212', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2212', 'Van', 'Toyota', 4, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX213', 'Đỗ Ngọc Sơn', DATE '1970-07-02', '0903076710', 'CN2213', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2213', 'SUV', 'Kia', 5, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX214', 'Đỗ Văn Trang', DATE '1990-05-11', '0909753576', 'CN2214', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2214', 'Sedan', 'Ford', 6, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX215', 'Nguyễn Thị Sơn', DATE '1981-08-07', '0904015593', 'CN2215', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2215', 'Van', 'Mazda', 7, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX216', 'Phạm Hoài Châu', DATE '1976-04-26', '0909951380', 'CN2216', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2216', 'SUV', 'Toyota', 4, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX217', 'Đỗ Văn Phúc', DATE '1982-08-19', '0901390292', 'CN2217', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2217', 'Sedan', 'Kia', 5, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX218', 'Vũ Văn Quang', DATE '1973-05-27', '0906324793', 'CN2218', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2218', 'Van', 'Ford', 6, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX219', 'Trần Thị Sơn', DATE '1978-04-09', '0903821189', 'CN2219', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2219', 'SUV', 'Mazda', 7, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX220', 'Hoàng Thị Dung', DATE '1979-10-24', '0906147152', 'CN2220', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2220', 'Sedan', 'Toyota', 4, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX221', 'Đỗ Xuân Giang', DATE '1994-12-31', '0901455856', 'CN2221', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2221', 'Van', 'Kia', 5, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX222', 'Trần Xuân Dung', DATE '1975-06-25', '0907926017', 'CN2222', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2222', 'SUV', 'Ford', 6, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX223', 'Trần Văn Hạnh', DATE '1999-11-23', '0905020206', 'CN2223', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2223', 'Sedan', 'Mazda', 7, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX224', 'Bùi Anh Dũng', DATE '1980-06-06', '0905517895', 'CN2224', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2224', 'Van', 'Toyota', 4, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX225', 'Bùi Anh Châu', DATE '1980-08-15', '0909123050', 'CN2225', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2225', 'SUV', 'Kia', 5, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX226', 'Nguyễn Ngọc Sơn', DATE '1971-06-07', '0902703045', 'CN2226', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2226', 'Sedan', 'Ford', 6, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX227', 'Đỗ Anh Phong', DATE '1974-09-05', '0902407748', 'CN2227', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2227', 'Van', 'Mazda', 7, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX228', 'Phan Hữu Hiếu', DATE '1972-01-29', '0908109386', 'CN2228', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2228', 'SUV', 'Toyota', 4, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX229', 'Nguyễn Hoài Tuấn', DATE '1998-06-06', '0905852800', 'CN2229', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2229', 'Sedan', 'Kia', 5, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX230', 'Đặng Ngọc Tuấn', DATE '1966-06-15', '0905209218', 'CN2230', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2230', 'Van', 'Ford', 6, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX231', 'Đỗ Ngọc Bình', DATE '1991-01-28', '0903708116', 'CN2231', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2231', 'SUV', 'Mazda', 7, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX232', 'Trần Anh Dũng', DATE '1975-02-06', '0903342942', 'CN2232', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2232', 'Sedan', 'Toyota', 4, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX233', 'Phạm Xuân Lan', DATE '1978-09-14', '0905384902', 'CN2233', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2233', 'Van', 'Kia', 5, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX234', 'Phan Xuân Hạnh', DATE '1976-02-21', '0908714152', 'CN2234', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2234', 'SUV', 'Ford', 6, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX235', 'Lê Văn Tuấn', DATE '1999-08-06', '0908994829', 'CN2235', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2235', 'Sedan', 'Mazda', 7, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX236', 'Vũ Hoài Minh', DATE '1999-06-07', '0902361450', 'CN2236', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2236', 'Van', 'Toyota', 4, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX237', 'Trần Xuân Minh', DATE '1967-10-08', '0907005668', 'CN2237', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2237', 'SUV', 'Kia', 5, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX238', 'Trần Hoài Linh', DATE '1978-11-03', '0904237849', 'CN2238', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2238', 'Sedan', 'Ford', 6, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX239', 'Nguyễn Ngọc Linh', DATE '1975-10-29', '0904213032', 'CN2239', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2239', 'Van', 'Mazda', 7, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX240', 'Phạm Hoài Linh', DATE '1974-04-28', '0901617335', 'CN2240', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2240', 'SUV', 'Toyota', 4, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX241', 'Phạm Văn Hạnh', DATE '1972-08-25', '0907645223', 'CN2241', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2241', 'Sedan', 'Kia', 5, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX242', 'Bùi Hoài Giang', DATE '1967-06-16', '0904250925', 'CN2242', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2242', 'Van', 'Ford', 6, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX243', 'Đỗ Hữu Châu', DATE '1972-05-14', '0903137935', 'CN2243', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2243', 'SUV', 'Mazda', 7, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX244', 'Hoàng Minh An', DATE '1965-06-03', '0909941274', 'CN2244', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2244', 'Sedan', 'Toyota', 4, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX245', 'Đặng Văn Nga', DATE '1977-01-02', '0901870113', 'CN2245', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2245', 'Van', 'Kia', 5, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX246', 'Hoàng Thị Quang', DATE '1980-01-23', '0908828026', 'CN2246', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2246', 'SUV', 'Ford', 6, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX247', 'Nguyễn Minh Bình', DATE '1976-05-13', '0905662942', 'CN2247', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2247', 'Sedan', 'Mazda', 7, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX248', 'Nguyễn Anh Hạnh', DATE '1964-07-20', '0906615431', 'CN2248', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2248', 'Van', 'Toyota', 4, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX249', 'Vũ Thị Hiếu', DATE '1965-07-07', '0904303044', 'CN2249', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2249', 'SUV', 'Kia', 5, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX250', 'Trần Thị An', DATE '1968-09-11', '0909052500', 'CN2250', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2250', 'Sedan', 'Ford', 6, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX251', 'Phan Ngọc Hiếu', DATE '1999-12-06', '0902809265', 'CN2251', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2251', 'Van', 'Mazda', 7, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX252', 'Nguyễn Xuân Quang', DATE '1990-09-02', '0904971899', 'CN2252', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2252', 'SUV', 'Toyota', 4, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX253', 'Đặng Thị Châu', DATE '1995-10-19', '0902018157', 'CN2253', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2253', 'Sedan', 'Kia', 5, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX254', 'Trần Hữu Bình', DATE '1993-12-09', '0908414160', 'CN2254', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2254', 'Van', 'Ford', 6, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX255', 'Vũ Thị Dũng', DATE '1990-03-24', '0901936000', 'CN2255', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2255', 'SUV', 'Mazda', 7, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX256', 'Vũ Anh Dũng', DATE '1972-03-16', '0907897247', 'CN2256', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2256', 'Sedan', 'Toyota', 4, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX257', 'Vũ Hoài Nga', DATE '1967-06-29', '0902699161', 'CN2257', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2257', 'Van', 'Kia', 5, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX258', 'Bùi Xuân Trang', DATE '1966-06-08', '0904229300', 'CN2258', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2258', 'SUV', 'Ford', 6, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX259', 'Đỗ Thị Trang', DATE '1998-12-21', '0904248312', 'CN2259', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2259', 'Sedan', 'Mazda', 7, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX260', 'Hoàng Xuân Nga', DATE '1997-02-16', '0909076540', 'CN2260', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2260', 'Van', 'Toyota', 4, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX261', 'Phạm Hữu Bình', DATE '1990-09-09', '0902014873', 'CN2261', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2261', 'SUV', 'Kia', 5, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX262', 'Vũ Xuân Khoa', DATE '1972-09-08', '0903443176', 'CN2262', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2262', 'Sedan', 'Ford', 6, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX263', 'Đỗ Xuân Khoa', DATE '1965-03-03', '0907187940', 'CN2263', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2263', 'Van', 'Mazda', 7, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX264', 'Phạm Văn Nga', DATE '1970-02-05', '0906768277', 'CN2264', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2264', 'SUV', 'Toyota', 4, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX265', 'Trần Xuân Hạnh', DATE '1984-07-06', '0908981342', 'CN2265', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2265', 'Sedan', 'Kia', 5, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX266', 'Đỗ Xuân Tuấn', DATE '1977-04-17', '0906026983', 'CN2266', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2266', 'Van', 'Ford', 6, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX267', 'Trần Hoài Bình', DATE '1989-10-07', '0909320336', 'CN2267', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2267', 'SUV', 'Mazda', 7, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX268', 'Phạm Hoài Tuấn', DATE '1990-07-09', '0904575870', 'CN2268', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2268', 'Sedan', 'Toyota', 4, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX269', 'Vũ Minh Minh', DATE '1970-09-25', '0904091109', 'CN2269', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2269', 'Van', 'Kia', 5, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX270', 'Trần Xuân An', DATE '1984-01-22', '0902932555', 'CN2270', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2270', 'SUV', 'Ford', 6, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX271', 'Phạm Xuân Bình', DATE '1968-08-09', '0901498041', 'CN2271', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2271', 'Sedan', 'Mazda', 7, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX272', 'Lê Minh Hương', DATE '1980-05-31', '0903924009', 'CN2272', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2272', 'Van', 'Toyota', 4, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX273', 'Phạm Văn Giang', DATE '1984-02-06', '0905392083', 'CN2273', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2273', 'SUV', 'Kia', 5, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX274', 'Vũ Thị Lan', DATE '1986-02-19', '0904527197', 'CN2274', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2274', 'Sedan', 'Ford', 6, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX275', 'Phan Xuân Giang', DATE '1981-01-03', '0909840363', 'CN2275', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2275', 'Van', 'Mazda', 7, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX276', 'Trần Hữu Dung', DATE '1970-03-12', '0904181650', 'CN2276', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2276', 'SUV', 'Toyota', 4, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX277', 'Phan Anh Hiếu', DATE '1999-02-19', '0901775026', 'CN2277', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2277', 'Sedan', 'Kia', 5, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX278', 'Hoàng Hữu Lan', DATE '1967-08-19', '0905146852', 'CN2278', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2278', 'Van', 'Ford', 6, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX279', 'Bùi Hoài Hạnh', DATE '1997-03-31', '0902365794', 'CN2279', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2279', 'SUV', 'Mazda', 7, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX280', 'Bùi Anh Quang', DATE '1983-03-20', '0907279143', 'CN2280', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2280', 'Sedan', 'Toyota', 4, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX281', 'Phan Xuân Quang', DATE '1993-01-24', '0909108379', 'CN2281', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2281', 'Van', 'Kia', 5, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX282', 'Đỗ Anh Trang', DATE '1973-10-25', '0901614121', 'CN2282', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2282', 'SUV', 'Ford', 6, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX283', 'Đặng Minh Minh', DATE '1977-09-04', '0904667394', 'CN2283', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2283', 'Sedan', 'Mazda', 7, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX284', 'Đỗ Hữu Linh', DATE '1985-10-31', '0905270292', 'CN2284', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2284', 'Van', 'Toyota', 4, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX285', 'Trần Ngọc Phong', DATE '1985-06-16', '0909704367', 'CN2285', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2285', 'SUV', 'Kia', 5, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX286', 'Nguyễn Hoài Quang', DATE '1992-03-20', '0906643418', 'CN2286', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2286', 'Sedan', 'Ford', 6, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX287', 'Vũ Anh Linh', DATE '1985-12-08', '0909347387', 'CN2287', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2287', 'Van', 'Mazda', 7, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX288', 'Nguyễn Hữu Phong', DATE '1971-01-20', '0904922352', 'CN2288', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2288', 'SUV', 'Toyota', 4, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX289', 'Trần Ngọc Quang', DATE '1966-10-12', '0909603205', 'CN2289', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2289', 'Sedan', 'Kia', 5, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX290', 'Phạm Thị Dũng', DATE '1964-08-27', '0902197032', 'CN2290', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2290', 'Van', 'Ford', 6, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX291', 'Phạm Xuân Hạnh', DATE '1977-12-02', '0906523752', 'CN2291', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2291', 'SUV', 'Mazda', 7, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX292', 'Phạm Hữu Sơn', DATE '1965-07-23', '0905381125', 'CN2292', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2292', 'Sedan', 'Toyota', 4, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX293', 'Phan Anh Minh', DATE '1995-07-05', '0901199493', 'CN2293', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2293', 'Van', 'Kia', 5, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX294', 'Phạm Minh Hạnh', DATE '1991-12-02', '0908959753', 'CN2294', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2294', 'SUV', 'Ford', 6, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX295', 'Phan Thị Lan', DATE '1976-10-26', '0904151542', 'CN2295', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2295', 'Sedan', 'Mazda', 7, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX296', 'Đặng Hoài Sơn', DATE '1964-08-24', '0901505062', 'CN2296', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2296', 'Van', 'Toyota', 4, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX297', 'Lê Ngọc An', DATE '1989-08-03', '0909385256', 'CN2297', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2297', 'SUV', 'Kia', 5, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX298', 'Vũ Anh Minh', DATE '1983-05-23', '0906027078', 'CN2298', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2298', 'Sedan', 'Ford', 6, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX299', 'Nguyễn Hữu Dung', DATE '1986-10-28', '0906540684', 'CN2299', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2299', 'Van', 'Mazda', 7, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX300', 'Phạm Anh Châu', DATE '1990-03-18', '0909967263', 'CN2300', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2300', 'SUV', 'Toyota', 4, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX301', 'Trần Xuân Trang', DATE '1994-03-07', '0908575505', 'CN2301', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2301', 'Sedan', 'Kia', 5, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX302', 'Trần Hữu Bình', DATE '1969-06-24', '0909197571', 'CN2302', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2302', 'Van', 'Ford', 6, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX303', 'Trần Anh Khoa', DATE '1986-12-17', '0904454299', 'CN2303', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2303', 'SUV', 'Mazda', 7, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX304', 'Trần Hoài Bình', DATE '1965-09-26', '0907184958', 'CN2304', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2304', 'Sedan', 'Toyota', 4, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX305', 'Phan Anh Minh', DATE '1967-07-18', '0903634617', 'CN2305', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2305', 'Van', 'Kia', 5, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX306', 'Vũ Hoài Châu', DATE '1994-01-26', '0907526217', 'CN2306', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2306', 'SUV', 'Ford', 6, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX307', 'Hoàng Anh Phúc', DATE '1993-11-11', '0903663907', 'CN2307', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2307', 'Sedan', 'Mazda', 7, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX308', 'Phạm Hoài Hương', DATE '1990-12-10', '0904384010', 'CN2308', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2308', 'Van', 'Toyota', 4, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX309', 'Trần Anh Tuấn', DATE '1993-02-16', '0905141290', 'CN2309', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2309', 'SUV', 'Kia', 5, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX310', 'Đặng Hoài Phong', DATE '1982-09-09', '0901655733', 'CN2310', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2310', 'Sedan', 'Ford', 6, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX311', 'Phan Ngọc Minh', DATE '1970-09-02', '0903938131', 'CN2311', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2311', 'Van', 'Mazda', 7, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX312', 'Đỗ Anh Phong', DATE '1969-06-06', '0907453607', 'CN2312', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2312', 'SUV', 'Toyota', 4, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX313', 'Nguyễn Minh Giang', DATE '1965-04-18', '0905593203', 'CN2313', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2313', 'Sedan', 'Kia', 5, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX314', 'Phạm Hoài Nga', DATE '1991-02-24', '0903033912', 'CN2314', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2314', 'Van', 'Ford', 6, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX315', 'Bùi Xuân Nga', DATE '1989-08-26', '0908565450', 'CN2315', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2315', 'SUV', 'Mazda', 7, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX316', 'Bùi Văn Phong', DATE '1984-10-04', '0901448251', 'CN2316', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2316', 'Sedan', 'Toyota', 4, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX317', 'Phan Anh Hạnh', DATE '1970-04-19', '0907655090', 'CN2317', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2317', 'Van', 'Kia', 5, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX318', 'Trần Hữu Lan', DATE '1970-07-21', '0908788747', 'CN2318', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2318', 'SUV', 'Ford', 6, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX319', 'Trần Minh Phong', DATE '1979-09-15', '0903353101', 'CN2319', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2319', 'Sedan', 'Mazda', 7, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX320', 'Lê Văn Tuấn', DATE '1983-08-11', '0902686363', 'CN2320', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2320', 'Van', 'Toyota', 4, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX321', 'Bùi Anh Giang', DATE '1964-07-07', '0902301665', 'CN2321', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2321', 'SUV', 'Kia', 5, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX322', 'Đặng Xuân Giang', DATE '1994-10-29', '0904635160', 'CN2322', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2322', 'Sedan', 'Ford', 6, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX323', 'Nguyễn Thị Minh', DATE '1986-06-14', '0906172822', 'CN2323', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2323', 'Van', 'Mazda', 7, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX324', 'Nguyễn Văn Minh', DATE '1971-04-02', '0904384602', 'CN2324', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2324', 'SUV', 'Toyota', 4, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX325', 'Phạm Thị An', DATE '1991-07-19', '0908074662', 'CN2325', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2325', 'Sedan', 'Kia', 5, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX326', 'Phạm Thị Hiếu', DATE '1982-09-14', '0902620732', 'CN2326', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2326', 'Van', 'Ford', 6, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX327', 'Vũ Thị Lan', DATE '1996-05-08', '0906413664', 'CN2327', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2327', 'SUV', 'Mazda', 7, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX328', 'Phạm Anh Nga', DATE '1967-04-06', '0903026754', 'CN2328', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2328', 'Sedan', 'Toyota', 4, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX329', 'Phan Xuân Giang', DATE '1999-12-26', '0901251567', 'CN2329', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2329', 'Van', 'Kia', 5, 'Sẵn sàng');
INSERT INTO LAIXE (MaLX, HoTen, NgaySinh, SoDT, BienSoXe, ChiNhanhID) VALUES ('LX330', 'Vũ Minh Phong', DATE '1965-06-06', '0904692601', 'CN2330', 'CN2');
INSERT INTO PHUONGTIEN (BienSoXe, LoaiXe, HangXe, SoChoNgoi, TrangThai) VALUES ('CN2330', 'SUV', 'Ford', 6, 'Sẵn sàng');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH001', 'Phan Văn Châu', DATE '1989-05-26', '0914666842', 'Số 101 Đường Nga P. 10, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH001', DATE '2024-09-16', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD001', 'CN2KH001', 'LX002', 'DV002', DATE '2025-05-01' + 1, 600000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH002', 'Trần Hữu Hương', DATE '2002-08-19', '0912589550', 'Số 102 Đường Tuấn P. 7, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH002', DATE '2024-06-16', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD002', 'CN2KH002', 'LX003', 'DV003', DATE '2025-05-01' + 2, 700000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH003', 'Lê Xuân Giang', DATE '1977-08-26', '0916334600', 'Số 103 Đường Phúc Phường 6, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH003', DATE '2025-05-20', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD003', 'CN2KH003', 'LX004', 'DV004', DATE '2025-05-01' + 3, 800000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH004', 'Đỗ Hoài Minh', DATE '1993-08-30', '0919573595', 'Số 104 Đường Hiếu Phường 4, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH004', DATE '2025-05-19', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD004', 'CN2KH004', 'LX005', 'DV005', DATE '2025-05-01' + 4, 900000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH005', 'Đỗ Thị Khoa', DATE '1992-12-19', '0914966072', 'Số 105 Đường Nga Phường 10, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH005', DATE '2025-04-19', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD005', 'CN2KH005', 'LX006', 'DV006', DATE '2025-05-01' + 5, 500000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH006', 'Nguyễn Hữu Linh', DATE '2001-09-18', '0919367241', 'Số 106 Đường Khoa Phường 3, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH006', DATE '2024-11-18', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD006', 'CN2KH006', 'LX007', 'DV007', DATE '2025-05-01' + 6, 600000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH007', 'Phạm Văn Hiếu', DATE '1978-03-05', '0918444490', 'Số 107 Đường Lan Phường 5, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH007', DATE '2024-12-18', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD007', 'CN2KH007', 'LX008', 'DV008', DATE '2025-05-01' + 7, 700000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH008', 'Nguyễn Anh Khoa', DATE '1984-06-05', '0911397508', 'Số 108 Đường Hiếu P. 6, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH008', DATE '2025-01-25', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD008', 'CN2KH008', 'LX009', 'DV009', DATE '2025-05-01' + 8, 800000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH009', 'Phạm Văn Hiếu', DATE '2002-02-07', '0914731991', 'Số 109 Đường Tuấn P. 9, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH009', DATE '2024-12-16', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD009', 'CN2KH009', 'LX010', 'DV010', DATE '2025-05-01' + 9, 900000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH010', 'Lê Hoài An', DATE '1973-12-28', '0912084091', 'Số 110 Đường Phúc Phường 4, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH010', DATE '2025-05-03', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD010', 'CN2KH010', 'LX011', 'DV011', DATE '2025-05-01' + 10, 500000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH011', 'Lê Minh Dung', DATE '1990-02-15', '0912539467', 'Số 111 Đường Giang Phường 4, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH011', DATE '2024-09-12', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD011', 'CN2KH011', 'LX012', 'DV012', DATE '2025-05-01' + 11, 600000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH012', 'Trần Anh Phong', DATE '2000-10-06', '0916225481', 'Số 112 Đường Giang Phường 4, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH012', DATE '2024-10-24', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD012', 'CN2KH012', 'LX013', 'DV013', DATE '2025-05-01' + 12, 700000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH013', 'Lê Minh Khoa', DATE '2003-01-09', '0915787427', 'Số 113 Đường Trang P. 4, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH013', DATE '2025-01-10', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD013', 'CN2KH013', 'LX014', 'DV014', DATE '2025-05-01' + 13, 800000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH014', 'Đặng Thị Linh', DATE '2002-10-30', '0917681433', 'Số 114 Đường Minh Phường 8, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH014', DATE '2024-10-16', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD014', 'CN2KH014', 'LX015', 'DV015', DATE '2025-05-01' + 14, 900000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH015', 'Vũ Anh Dung', DATE '2006-09-21', '0919086630', 'Số 115 Đường An P. 7, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH015', DATE '2025-04-17', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD015', 'CN2KH015', 'LX016', 'DV016', DATE '2025-05-01' + 15, 500000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH016', 'Hoàng Hữu Sơn', DATE '1991-12-26', '0913947745', 'Số 116 Đường Hương P. 8, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH016', DATE '2024-12-24', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD016', 'CN2KH016', 'LX017', 'DV017', DATE '2025-05-01' + 16, 600000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH017', 'Đặng Ngọc Minh', DATE '1975-04-01', '0919067229', 'Số 117 Đường Châu P. 3, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH017', DATE '2024-10-01', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD017', 'CN2KH017', 'LX018', 'DV018', DATE '2025-05-01' + 17, 700000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH018', 'Phạm Hữu Hạnh', DATE '1990-11-03', '0911070138', 'Số 118 Đường An P. 8, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH018', DATE '2024-11-03', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD018', 'CN2KH018', 'LX019', 'DV019', DATE '2025-05-01' + 18, 800000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH019', 'Vũ Anh Linh', DATE '2005-09-16', '0917443078', 'Số 119 Đường Phúc P. 10, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH019', DATE '2025-04-23', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD019', 'CN2KH019', 'LX020', 'DV020', DATE '2025-05-01' + 19, 900000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH020', 'Vũ Văn Dũng', DATE '1995-08-26', '0917456309', 'Số 120 Đường Trang Phường 4, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH020', DATE '2024-10-18', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD020', 'CN2KH020', 'LX021', 'DV021', DATE '2025-05-01' + 20, 500000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH021', 'Hoàng Xuân Quang', DATE '1965-06-16', '0919197714', 'Số 121 Đường Linh Phường 7, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH021', DATE '2024-10-24', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD021', 'CN2KH021', 'LX022', 'DV022', DATE '2025-05-01' + 21, 600000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH022', 'Phạm Minh Phúc', DATE '2000-05-02', '0911578940', 'Số 122 Đường Linh Phường 3, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH022', DATE '2025-01-16', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD022', 'CN2KH022', 'LX023', 'DV023', DATE '2025-05-01' + 22, 700000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH023', 'Đỗ Hoài Dung', DATE '1980-05-03', '0915266245', 'Số 123 Đường Hiếu Phường 1, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH023', DATE '2025-03-31', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD023', 'CN2KH023', 'LX024', 'DV024', DATE '2025-05-01' + 23, 800000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH024', 'Trần Anh Minh', DATE '2001-02-24', '0912348021', 'Số 124 Đường Quang Phường 7, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH024', DATE '2025-03-06', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD024', 'CN2KH024', 'LX025', 'DV025', DATE '2025-05-01' + 24, 900000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH025', 'Vũ Ngọc Khoa', DATE '1993-11-26', '0919399459', 'Số 125 Đường Sơn P. 10, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH025', DATE '2024-12-23', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD025', 'CN2KH025', 'LX026', 'DV026', DATE '2025-05-01' + 25, 500000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH026', 'Vũ Thị Dũng', DATE '2002-05-19', '0916777952', 'Số 126 Đường Dung P. 4, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH026', DATE '2024-11-07', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD026', 'CN2KH026', 'LX027', 'DV027', DATE '2025-05-01' + 26, 600000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH027', 'Hoàng Văn Giang', DATE '2002-03-16', '0919249747', 'Số 127 Đường An Phường 2, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH027', DATE '2024-06-07', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD027', 'CN2KH027', 'LX028', 'DV028', DATE '2025-05-01' + 27, 700000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH028', 'Vũ Anh Khoa', DATE '1999-10-18', '0918230134', 'Số 128 Đường Giang Phường 6, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH028', DATE '2025-02-23', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD028', 'CN2KH028', 'LX029', 'DV029', DATE '2025-05-01' + 28, 800000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH029', 'Lê Minh Phúc', DATE '2002-11-27', '0914053190', 'Số 129 Đường Quang Phường 8, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH029', DATE '2024-08-12', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD029', 'CN2KH029', 'LX030', 'DV030', DATE '2025-05-01' + 29, 900000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH030', 'Phạm Hữu Hạnh', DATE '1972-06-16', '0911989554', 'Số 130 Đường Giang Phường 5, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH030', DATE '2024-11-01', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD030', 'CN2KH030', 'LX031', 'DV031', DATE '2025-05-01' + 30, 500000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH031', 'Đặng Thị Giang', DATE '1996-07-23', '0912338986', 'Số 131 Đường Khoa Phường 7, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH031', DATE '2025-03-27', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD031', 'CN2KH031', 'LX032', 'DV032', DATE '2025-05-01' + 31, 600000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH032', 'Hoàng Thị Lan', DATE '2000-05-31', '0911497723', 'Số 132 Đường Trang Phường 8, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH032', DATE '2024-09-23', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD032', 'CN2KH032', 'LX033', 'DV033', DATE '2025-05-01' + 32, 700000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH033', 'Trần Văn Bình', DATE '1997-06-07', '0915464094', 'Số 133 Đường An Phường 2, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH033', DATE '2025-02-10', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD033', 'CN2KH033', 'LX034', 'DV034', DATE '2025-05-01' + 33, 800000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH034', 'Bùi Văn Minh', DATE '2006-03-20', '0919725395', 'Số 134 Đường Hương P. 8, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH034', DATE '2024-12-08', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD034', 'CN2KH034', 'LX035', 'DV035', DATE '2025-05-01' + 34, 900000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH035', 'Đỗ Anh Lan', DATE '1969-05-08', '0917220742', 'Số 135 Đường Lan P. 4, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH035', DATE '2024-11-26', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD035', 'CN2KH035', 'LX036', 'DV036', DATE '2025-05-01' + 35, 500000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH036', 'Vũ Anh Tuấn', DATE '1989-03-08', '0911960353', 'Số 136 Đường Linh P. 2, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH036', DATE '2025-05-28', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD036', 'CN2KH036', 'LX037', 'DV037', DATE '2025-05-01' + 36, 600000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH037', 'Đặng Anh Dung', DATE '1966-06-29', '0911430846', 'Số 137 Đường Tuấn Phường 9, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH037', DATE '2025-01-06', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD037', 'CN2KH037', 'LX038', 'DV038', DATE '2025-05-01' + 37, 700000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH038', 'Phạm Xuân Phong', DATE '1989-08-27', '0918972523', 'Số 138 Đường Quang P. 4, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH038', DATE '2025-05-28', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD038', 'CN2KH038', 'LX039', 'DV039', DATE '2025-05-01' + 38, 800000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH039', 'Phan Văn Linh', DATE '2004-08-25', '0911767629', 'Số 139 Đường Lan P. 4, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH039', DATE '2024-07-23', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD039', 'CN2KH039', 'LX040', 'DV040', DATE '2025-05-01' + 39, 900000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH040', 'Đặng Anh Tuấn', DATE '1993-08-01', '0912365149', 'Số 140 Đường Linh P. 8, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH040', DATE '2024-06-26', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD040', 'CN2KH040', 'LX041', 'DV041', DATE '2025-05-01' + 40, 500000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH041', 'Trần Anh Khoa', DATE '1976-09-12', '0914272848', 'Số 141 Đường Dung Phường 3, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH041', DATE '2024-09-17', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD041', 'CN2KH041', 'LX042', 'DV042', DATE '2025-05-01' + 41, 600000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH042', 'Trần Ngọc Sơn', DATE '1989-02-09', '0918831655', 'Số 142 Đường Giang P. 2, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH042', DATE '2024-09-25', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD042', 'CN2KH042', 'LX043', 'DV043', DATE '2025-05-01' + 42, 700000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH043', 'Bùi Minh Hiếu', DATE '1995-04-09', '0914550743', 'Số 143 Đường Giang Phường 2, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH043', DATE '2024-10-19', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD043', 'CN2KH043', 'LX044', 'DV044', DATE '2025-05-01' + 43, 800000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH044', 'Nguyễn Hữu Lan', DATE '1969-09-07', '0917433891', 'Số 144 Đường Hương Phường 5, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH044', DATE '2024-06-23', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD044', 'CN2KH044', 'LX045', 'DV045', DATE '2025-05-01' + 44, 900000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH045', 'Đặng Thị Dung', DATE '2003-02-25', '0919968148', 'Số 145 Đường Phúc Phường 6, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH045', DATE '2025-02-04', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD045', 'CN2KH045', 'LX046', 'DV046', DATE '2025-05-01' + 45, 500000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH046', 'Đỗ Thị Lan', DATE '1995-05-02', '0917325183', 'Số 146 Đường Minh P. 4, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH046', DATE '2025-02-04', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD046', 'CN2KH046', 'LX047', 'DV047', DATE '2025-05-01' + 46, 600000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH047', 'Hoàng Thị Khoa', DATE '1990-01-24', '0912471032', 'Số 147 Đường Dũng Phường 6, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH047', DATE '2024-07-30', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD047', 'CN2KH047', 'LX048', 'DV048', DATE '2025-05-01' + 47, 700000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH048', 'Phạm Thị Trang', DATE '1965-12-30', '0917169603', 'Số 148 Đường Dung P. 7, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH048', DATE '2024-08-07', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD048', 'CN2KH048', 'LX049', 'DV049', DATE '2025-05-01' + 48, 800000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH049', 'Nguyễn Ngọc Bình', DATE '2004-11-16', '0919985927', 'Số 149 Đường Hạnh P. 7, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH049', DATE '2024-12-17', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD049', 'CN2KH049', 'LX050', 'DV050', DATE '2025-05-01' + 49, 900000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH050', 'Phan Hữu Quang', DATE '1980-07-08', '0914726916', 'Số 150 Đường Dũng P. 1, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH050', DATE '2024-08-27', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD050', 'CN2KH050', 'LX051', 'DV051', DATE '2025-05-01' + 50, 500000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH051', 'Đặng Xuân Dung', DATE '1973-01-06', '0915979872', 'Số 151 Đường Hiếu P. 8, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH051', DATE '2025-03-15', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD051', 'CN2KH051', 'LX052', 'DV052', DATE '2025-05-01' + 51, 600000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH052', 'Đỗ Ngọc Dung', DATE '1965-12-03', '0911576194', 'Số 152 Đường Tuấn P. 5, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH052', DATE '2024-09-14', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD052', 'CN2KH052', 'LX053', 'DV053', DATE '2025-05-01' + 52, 700000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH053', 'Trần Ngọc Trang', DATE '1970-04-29', '0919024252', 'Số 153 Đường Hạnh P. 5, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH053', DATE '2024-06-03', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD053', 'CN2KH053', 'LX054', 'DV054', DATE '2025-05-01' + 53, 800000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH054', 'Vũ Văn Lan', DATE '1973-06-09', '0913561918', 'Số 154 Đường Hạnh Phường 1, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH054', DATE '2025-02-27', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD054', 'CN2KH054', 'LX055', 'DV055', DATE '2025-05-01' + 54, 900000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH055', 'Đặng Anh Khoa', DATE '1993-10-11', '0913670819', 'Số 155 Đường An P. 6, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH055', DATE '2024-10-25', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD055', 'CN2KH055', 'LX056', 'DV056', DATE '2025-05-01' + 55, 500000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH056', 'Đặng Xuân Minh', DATE '1988-10-20', '0917560950', 'Số 156 Đường Châu P. 5, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH056', DATE '2024-06-07', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD056', 'CN2KH056', 'LX057', 'DV057', DATE '2025-05-01' + 56, 600000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH057', 'Phạm Anh Dũng', DATE '1995-05-04', '0913196149', 'Số 157 Đường Lan Phường 5, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH057', DATE '2024-10-07', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD057', 'CN2KH057', 'LX058', 'DV058', DATE '2025-05-01' + 57, 700000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH058', 'Lê Hữu Phong', DATE '2007-05-09', '0919094028', 'Số 158 Đường Khoa Phường 4, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH058', DATE '2025-02-07', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD058', 'CN2KH058', 'LX059', 'DV059', DATE '2025-05-01' + 58, 800000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH059', 'Phạm Văn Linh', DATE '1999-12-05', '0912710400', 'Số 159 Đường Dung P. 7, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH059', DATE '2024-06-16', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD059', 'CN2KH059', 'LX060', 'DV060', DATE '2025-05-01' + 59, 900000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH060', 'Lê Văn Dũng', DATE '2003-09-11', '0916965707', 'Số 160 Đường Phúc Phường 1, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH060', DATE '2025-03-30', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD060', 'CN2KH060', 'LX061', 'DV061', DATE '2025-05-01' + 60, 500000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH061', 'Bùi Xuân Trang', DATE '2002-06-14', '0918278315', 'Số 161 Đường Dung P. 4, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH061', DATE '2025-05-12', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD061', 'CN2KH061', 'LX062', 'DV062', DATE '2025-05-01' + 61, 600000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH062', 'Trần Minh Minh', DATE '1977-02-12', '0919197782', 'Số 162 Đường Khoa Phường 7, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH062', DATE '2024-06-09', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD062', 'CN2KH062', 'LX063', 'DV063', DATE '2025-05-01' + 62, 700000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH063', 'Trần Hoài Minh', DATE '1990-04-11', '0915617358', 'Số 163 Đường Phong P. 1, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH063', DATE '2025-03-29', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD063', 'CN2KH063', 'LX064', 'DV064', DATE '2025-05-01' + 63, 800000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH064', 'Trần Thị Dũng', DATE '1965-05-29', '0919207723', 'Số 164 Đường Quang Phường 1, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH064', DATE '2024-08-02', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD064', 'CN2KH064', 'LX065', 'DV065', DATE '2025-05-01' + 64, 900000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH065', 'Đỗ Hoài Hương', DATE '1985-01-03', '0912586340', 'Số 165 Đường Trang Phường 7, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH065', DATE '2024-09-24', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD065', 'CN2KH065', 'LX066', 'DV066', DATE '2025-05-01' + 65, 500000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH066', 'Vũ Ngọc Trang', DATE '1969-10-05', '0913101118', 'Số 166 Đường Dũng P. 2, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH066', DATE '2024-05-29', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD066', 'CN2KH066', 'LX067', 'DV067', DATE '2025-05-01' + 66, 600000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH067', 'Bùi Hữu Minh', DATE '2002-01-22', '0911331289', 'Số 167 Đường Minh P. 2, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH067', DATE '2024-09-06', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD067', 'CN2KH067', 'LX068', 'DV068', DATE '2025-05-01' + 67, 700000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH068', 'Đỗ Thị Hạnh', DATE '1964-10-21', '0912968404', 'Số 168 Đường Giang Phường 1, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH068', DATE '2024-08-18', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD068', 'CN2KH068', 'LX069', 'DV069', DATE '2025-05-01' + 68, 800000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH069', 'Đặng Xuân Dũng', DATE '2003-04-23', '0911656713', 'Số 169 Đường Dung Phường 3, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH069', DATE '2025-04-15', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD069', 'CN2KH069', 'LX070', 'DV070', DATE '2025-05-01' + 69, 900000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH070', 'Bùi Ngọc Bình', DATE '1989-06-27', '0912419525', 'Số 170 Đường Dũng P. 6, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH070', DATE '2024-08-24', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD070', 'CN2KH070', 'LX071', 'DV071', DATE '2025-05-01' + 70, 500000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH071', 'Lê Anh An', DATE '1973-11-17', '0915166404', 'Số 171 Đường Khoa Phường 9, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH071', DATE '2024-12-30', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD071', 'CN2KH071', 'LX072', 'DV072', DATE '2025-05-01' + 71, 600000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH072', 'Bùi Hoài Dung', DATE '1969-05-13', '0919228265', 'Số 172 Đường Lan P. 10, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH072', DATE '2024-08-27', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD072', 'CN2KH072', 'LX073', 'DV073', DATE '2025-05-01' + 72, 700000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH073', 'Bùi Minh Dũng', DATE '1995-10-11', '0911750538', 'Số 173 Đường Hiếu Phường 4, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH073', DATE '2025-03-18', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD073', 'CN2KH073', 'LX074', 'DV074', DATE '2025-05-01' + 73, 800000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH074', 'Hoàng Minh Dung', DATE '1988-12-26', '0914624549', 'Số 174 Đường Trang P. 5, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH074', DATE '2025-03-25', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD074', 'CN2KH074', 'LX075', 'DV075', DATE '2025-05-01' + 74, 900000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH075', 'Đỗ Anh Châu', DATE '1987-03-31', '0915277642', 'Số 175 Đường Hương P. 3, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH075', DATE '2024-11-06', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD075', 'CN2KH075', 'LX076', 'DV076', DATE '2025-05-01' + 75, 500000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH076', 'Đặng Thị Hương', DATE '1999-02-23', '0918136077', 'Số 176 Đường Dung Phường 2, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH076', DATE '2024-07-11', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD076', 'CN2KH076', 'LX077', 'DV077', DATE '2025-05-01' + 76, 600000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH077', 'Hoàng Minh Linh', DATE '1985-10-19', '0919580328', 'Số 177 Đường Tuấn Phường 7, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH077', DATE '2025-03-12', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD077', 'CN2KH077', 'LX078', 'DV078', DATE '2025-05-01' + 77, 700000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH078', 'Phan Anh Minh', DATE '1972-06-03', '0911434695', 'Số 178 Đường Tuấn Phường 2, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH078', DATE '2025-01-11', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD078', 'CN2KH078', 'LX079', 'DV079', DATE '2025-05-01' + 78, 800000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH079', 'Trần Thị Sơn', DATE '1995-10-01', '0917824657', 'Số 179 Đường Châu P. 2, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH079', DATE '2024-11-25', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD079', 'CN2KH079', 'LX080', 'DV080', DATE '2025-05-01' + 79, 900000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH080', 'Phan Ngọc Dung', DATE '1997-07-10', '0914787716', 'Số 180 Đường Hương Phường 2, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH080', DATE '2024-11-17', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD080', 'CN2KH080', 'LX081', 'DV081', DATE '2025-05-01' + 80, 500000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH081', 'Phạm Anh Dũng', DATE '1995-07-02', '0913072044', 'Số 181 Đường Giang P. 10, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH081', DATE '2024-09-21', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD081', 'CN2KH081', 'LX082', 'DV082', DATE '2025-05-01' + 81, 600000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH082', 'Trần Xuân Trang', DATE '1984-03-12', '0915731119', 'Số 182 Đường Sơn P. 10, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH082', DATE '2025-04-09', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD082', 'CN2KH082', 'LX083', 'DV083', DATE '2025-05-01' + 82, 700000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH083', 'Nguyễn Hữu Lan', DATE '1970-07-19', '0917535788', 'Số 183 Đường Giang P. 9, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH083', DATE '2024-08-20', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD083', 'CN2KH083', 'LX084', 'DV084', DATE '2025-05-01' + 83, 800000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH084', 'Đỗ Anh Phúc', DATE '1973-10-18', '0913140306', 'Số 184 Đường Hương Phường 9, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH084', DATE '2024-05-29', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD084', 'CN2KH084', 'LX085', 'DV085', DATE '2025-05-01' + 84, 900000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH085', 'Lê Hữu Dung', DATE '1997-08-20', '0917355220', 'Số 185 Đường Trang P. 1, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH085', DATE '2024-07-06', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD085', 'CN2KH085', 'LX086', 'DV086', DATE '2025-05-01' + 85, 500000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH086', 'Phan Minh Tuấn', DATE '1984-08-08', '0918016965', 'Số 186 Đường Phong Phường 8, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH086', DATE '2024-11-29', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD086', 'CN2KH086', 'LX087', 'DV087', DATE '2025-05-01' + 86, 600000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH087', 'Đặng Ngọc Hương', DATE '1990-08-12', '0918176707', 'Số 187 Đường Quang Phường 5, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH087', DATE '2024-07-08', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD087', 'CN2KH087', 'LX088', 'DV088', DATE '2025-05-01' + 87, 700000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH088', 'Trần Ngọc Nga', DATE '2005-05-19', '0916246854', 'Số 188 Đường Châu Phường 2, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH088', DATE '2025-01-27', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD088', 'CN2KH088', 'LX089', 'DV089', DATE '2025-05-01' + 88, 800000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH089', 'Trần Hữu Trang', DATE '1976-12-27', '0911963205', 'Số 189 Đường Châu P. 9, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH089', DATE '2024-09-19', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD089', 'CN2KH089', 'LX090', 'DV090', DATE '2025-05-01' + 89, 900000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH090', 'Nguyễn Anh Quang', DATE '1969-06-26', '0913288888', 'Số 190 Đường Phúc P. 9, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH090', DATE '2024-06-13', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD090', 'CN2KH090', 'LX091', 'DV091', DATE '2025-05-01' + 90, 500000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH091', 'Bùi Thị Minh', DATE '1970-12-24', '0911233207', 'Số 191 Đường Tuấn Phường 1, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH091', DATE '2024-05-29', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD091', 'CN2KH091', 'LX092', 'DV092', DATE '2025-05-01' + 91, 600000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH092', 'Vũ Xuân Hiếu', DATE '2001-04-11', '0919860239', 'Số 192 Đường Tuấn Phường 10, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH092', DATE '2024-10-12', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD092', 'CN2KH092', 'LX093', 'DV093', DATE '2025-05-01' + 92, 700000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH093', 'Lê Minh Giang', DATE '2001-12-06', '0912260344', 'Số 193 Đường Linh Phường 9, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH093', DATE '2024-11-30', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD093', 'CN2KH093', 'LX094', 'DV094', DATE '2025-05-01' + 93, 800000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH094', 'Nguyễn Anh Phúc', DATE '1974-04-02', '0917360154', 'Số 194 Đường Giang P. 2, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH094', DATE '2024-12-07', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD094', 'CN2KH094', 'LX095', 'DV095', DATE '2025-05-01' + 94, 900000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH095', 'Phạm Thị Khoa', DATE '1983-06-26', '0916019373', 'Số 195 Đường Phúc P. 5, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH095', DATE '2025-02-09', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD095', 'CN2KH095', 'LX096', 'DV096', DATE '2025-05-01' + 95, 500000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH096', 'Nguyễn Anh Hạnh', DATE '1970-08-30', '0916114027', 'Số 196 Đường Quang Phường 8, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH096', DATE '2024-07-17', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD096', 'CN2KH096', 'LX097', 'DV097', DATE '2025-05-01' + 96, 600000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH097', 'Đặng Văn Linh', DATE '2005-10-26', '0911098836', 'Số 197 Đường Tuấn P. 6, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH097', DATE '2024-12-28', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD097', 'CN2KH097', 'LX098', 'DV098', DATE '2025-05-01' + 97, 700000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH098', 'Phan Thị An', DATE '2004-09-15', '0916867356', 'Số 198 Đường Giang P. 6, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH098', DATE '2025-05-25', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD098', 'CN2KH098', 'LX099', 'DV099', DATE '2025-05-01' + 98, 800000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH099', 'Trần Anh Phúc', DATE '1991-10-26', '0914314245', 'Số 199 Đường Châu Phường 7, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH099', DATE '2025-03-27', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD099', 'CN2KH099', 'LX100', 'DV100', DATE '2025-05-01' + 99, 900000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH100', 'Đặng Văn Dung', DATE '1973-10-13', '0915196564', 'Số 200 Đường Hiếu P. 7, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH100', DATE '2024-11-19', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD100', 'CN2KH100', 'LX101', 'DV101', DATE '2025-05-01' + 100, 500000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH101', 'Hoàng Xuân Nga', DATE '1994-01-22', '0914056507', 'Số 201 Đường Sơn P. 2, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH101', DATE '2024-10-17', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD101', 'CN2KH101', 'LX102', 'DV102', DATE '2025-05-01' + 101, 600000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH102', 'Đặng Hữu Dung', DATE '1982-07-12', '0916934735', 'Số 202 Đường Nga Phường 6, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH102', DATE '2024-05-31', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD102', 'CN2KH102', 'LX103', 'DV103', DATE '2025-05-01' + 102, 700000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH103', 'Phạm Thị Hạnh', DATE '1976-06-15', '0915779824', 'Số 203 Đường Bình Phường 7, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH103', DATE '2024-10-26', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD103', 'CN2KH103', 'LX104', 'DV104', DATE '2025-05-01' + 103, 800000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH104', 'Phan Văn Giang', DATE '1975-06-25', '0914338530', 'Số 204 Đường Phúc P. 2, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH104', DATE '2024-10-26', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD104', 'CN2KH104', 'LX105', 'DV105', DATE '2025-05-01' + 104, 900000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH105', 'Đặng Hoài Dung', DATE '1973-12-30', '0916450711', 'Số 205 Đường Minh P. 3, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH105', DATE '2025-04-03', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD105', 'CN2KH105', 'LX106', 'DV106', DATE '2025-05-01' + 105, 500000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH106', 'Trần Văn Dung', DATE '2005-06-14', '0913609561', 'Số 206 Đường Linh Phường 4, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH106', DATE '2025-05-03', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD106', 'CN2KH106', 'LX107', 'DV107', DATE '2025-05-01' + 106, 600000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH107', 'Phan Anh Tuấn', DATE '1996-11-26', '0911134702', 'Số 207 Đường Nga P. 5, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH107', DATE '2025-01-05', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD107', 'CN2KH107', 'LX108', 'DV108', DATE '2025-05-01' + 107, 700000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH108', 'Đặng Thị Nga', DATE '1987-02-26', '0915156509', 'Số 208 Đường Tuấn Phường 9, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH108', DATE '2025-02-23', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD108', 'CN2KH108', 'LX109', 'DV109', DATE '2025-05-01' + 108, 800000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH109', 'Phạm Ngọc Dũng', DATE '1999-04-07', '0915421311', 'Số 209 Đường Hiếu P. 4, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH109', DATE '2024-09-29', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD109', 'CN2KH109', 'LX110', 'DV110', DATE '2025-05-01' + 109, 900000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH110', 'Trần Hữu Hạnh', DATE '2004-05-24', '0913495209', 'Số 210 Đường Hiếu Phường 3, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH110', DATE '2024-11-05', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD110', 'CN2KH110', 'LX111', 'DV111', DATE '2025-05-01' + 110, 500000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH111', 'Nguyễn Ngọc Hạnh', DATE '1969-06-22', '0913452982', 'Số 211 Đường Nga Phường 10, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH111', DATE '2025-02-16', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD111', 'CN2KH111', 'LX112', 'DV112', DATE '2025-05-01' + 111, 600000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH112', 'Trần Văn Minh', DATE '1994-12-24', '0917833312', 'Số 212 Đường Quang P. 4, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH112', DATE '2025-02-05', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD112', 'CN2KH112', 'LX113', 'DV113', DATE '2025-05-01' + 112, 700000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH113', 'Phan Anh Phúc', DATE '1968-01-16', '0912029277', 'Số 213 Đường Quang P. 1, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH113', DATE '2024-12-25', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD113', 'CN2KH113', 'LX114', 'DV114', DATE '2025-05-01' + 113, 800000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH114', 'Trần Ngọc Linh', DATE '1982-05-25', '0915706947', 'Số 214 Đường Linh P. 4, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH114', DATE '2024-12-17', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD114', 'CN2KH114', 'LX115', 'DV115', DATE '2025-05-01' + 114, 900000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH115', 'Nguyễn Hữu Bình', DATE '1989-05-05', '0911008991', 'Số 215 Đường Bình P. 4, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH115', DATE '2025-01-03', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD115', 'CN2KH115', 'LX116', 'DV116', DATE '2025-05-01' + 115, 500000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH116', 'Đặng Ngọc Tuấn', DATE '1982-07-15', '0912690500', 'Số 216 Đường Nga Phường 5, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH116', DATE '2024-09-20', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD116', 'CN2KH116', 'LX117', 'DV117', DATE '2025-05-01' + 116, 600000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH117', 'Phan Xuân Khoa', DATE '1973-05-20', '0912871139', 'Số 217 Đường Dũng Phường 9, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH117', DATE '2025-03-24', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD117', 'CN2KH117', 'LX118', 'DV118', DATE '2025-05-01' + 117, 700000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH118', 'Phan Xuân Linh', DATE '1971-07-27', '0919872833', 'Số 218 Đường Tuấn P. 4, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH118', DATE '2024-07-01', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD118', 'CN2KH118', 'LX119', 'DV119', DATE '2025-05-01' + 118, 800000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH119', 'Hoàng Minh Trang', DATE '2002-01-28', '0917443279', 'Số 219 Đường Châu Phường 3, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH119', DATE '2024-07-11', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD119', 'CN2KH119', 'LX120', 'DV120', DATE '2025-05-01' + 119, 900000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH120', 'Đỗ Thị Bình', DATE '1987-12-30', '0914194945', 'Số 220 Đường Hạnh P. 2, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH120', DATE '2025-04-21', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD120', 'CN2KH120', 'LX121', 'DV121', DATE '2025-05-01' + 120, 500000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH121', 'Bùi Xuân Khoa', DATE '1984-05-22', '0918955730', 'Số 221 Đường Hạnh Phường 1, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH121', DATE '2025-03-25', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD121', 'CN2KH121', 'LX122', 'DV122', DATE '2025-05-01' + 121, 600000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH122', 'Phạm Anh Sơn', DATE '1989-10-12', '0915236674', 'Số 222 Đường Sơn P. 6, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH122', DATE '2024-10-12', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD122', 'CN2KH122', 'LX123', 'DV123', DATE '2025-05-01' + 122, 700000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH123', 'Trần Anh Châu', DATE '1997-06-27', '0919100385', 'Số 223 Đường Nga Phường 3, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH123', DATE '2024-07-27', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD123', 'CN2KH123', 'LX124', 'DV124', DATE '2025-05-01' + 123, 800000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH124', 'Hoàng Hữu Khoa', DATE '1967-06-30', '0911762444', 'Số 224 Đường Trang Phường 4, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH124', DATE '2024-11-07', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD124', 'CN2KH124', 'LX125', 'DV125', DATE '2025-05-01' + 124, 900000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH125', 'Đặng Thị Giang', DATE '1986-02-10', '0918344141', 'Số 225 Đường Quang P. 9, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH125', DATE '2024-11-11', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD125', 'CN2KH125', 'LX126', 'DV126', DATE '2025-05-01' + 125, 500000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH126', 'Vũ Ngọc Hạnh', DATE '1994-01-06', '0914088120', 'Số 226 Đường An Phường 10, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH126', DATE '2025-02-07', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD126', 'CN2KH126', 'LX127', 'DV127', DATE '2025-05-01' + 126, 600000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH127', 'Đỗ Văn Quang', DATE '1998-10-29', '0918641031', 'Số 227 Đường Quang P. 5, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH127', DATE '2025-02-06', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD127', 'CN2KH127', 'LX128', 'DV128', DATE '2025-05-01' + 127, 700000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH128', 'Hoàng Ngọc Sơn', DATE '1973-01-04', '0912998223', 'Số 228 Đường Giang Phường 1, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH128', DATE '2024-08-29', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD128', 'CN2KH128', 'LX129', 'DV129', DATE '2025-05-01' + 128, 800000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH129', 'Phạm Ngọc Bình', DATE '1964-08-08', '0913485367', 'Số 229 Đường Hương Phường 5, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH129', DATE '2025-05-03', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD129', 'CN2KH129', 'LX130', 'DV130', DATE '2025-05-01' + 129, 900000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH130', 'Phạm Minh Sơn', DATE '2003-09-27', '0912949258', 'Số 230 Đường An P. 10, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH130', DATE '2024-11-22', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD130', 'CN2KH130', 'LX131', 'DV131', DATE '2025-05-01' + 130, 500000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH131', 'Phan Thị Sơn', DATE '1974-01-14', '0915429825', 'Số 231 Đường Dung P. 10, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH131', DATE '2024-12-30', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD131', 'CN2KH131', 'LX132', 'DV132', DATE '2025-05-01' + 131, 600000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH132', 'Phan Văn An', DATE '1973-01-01', '0916964017', 'Số 232 Đường Hiếu P. 3, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH132', DATE '2025-01-18', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD132', 'CN2KH132', 'LX133', 'DV133', DATE '2025-05-01' + 132, 700000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH133', 'Nguyễn Thị Minh', DATE '1989-05-24', '0915317535', 'Số 233 Đường Tuấn Phường 8, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH133', DATE '2025-02-06', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD133', 'CN2KH133', 'LX134', 'DV134', DATE '2025-05-01' + 133, 800000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH134', 'Phan Ngọc Hạnh', DATE '1998-03-23', '0917634775', 'Số 234 Đường Dung P. 4, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH134', DATE '2024-10-19', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD134', 'CN2KH134', 'LX135', 'DV135', DATE '2025-05-01' + 134, 900000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH135', 'Phan Hữu Phúc', DATE '1964-05-30', '0912571875', 'Số 235 Đường Phúc Phường 8, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH135', DATE '2025-02-24', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD135', 'CN2KH135', 'LX136', 'DV136', DATE '2025-05-01' + 135, 500000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH136', 'Lê Minh Trang', DATE '2003-07-03', '0919229532', 'Số 236 Đường Giang P. 1, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH136', DATE '2024-12-22', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD136', 'CN2KH136', 'LX137', 'DV137', DATE '2025-05-01' + 136, 600000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH137', 'Lê Hữu Minh', DATE '1965-08-20', '0914151566', 'Số 237 Đường Châu Phường 2, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH137', DATE '2024-10-23', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD137', 'CN2KH137', 'LX138', 'DV138', DATE '2025-05-01' + 137, 700000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH138', 'Phạm Hoài Minh', DATE '1967-10-18', '0912681644', 'Số 238 Đường Quang Phường 1, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH138', DATE '2024-07-25', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD138', 'CN2KH138', 'LX139', 'DV139', DATE '2025-05-01' + 138, 800000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH139', 'Trần Anh Minh', DATE '1968-09-20', '0911347555', 'Số 239 Đường Dũng Phường 1, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH139', DATE '2025-03-23', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD139', 'CN2KH139', 'LX140', 'DV140', DATE '2025-05-01' + 139, 900000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH140', 'Phạm Thị Hương', DATE '1991-07-31', '0913393028', 'Số 240 Đường Tuấn Phường 1, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH140', DATE '2025-04-05', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD140', 'CN2KH140', 'LX141', 'DV141', DATE '2025-05-01' + 140, 500000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH141', 'Bùi Xuân Châu', DATE '1979-05-08', '0914394393', 'Số 241 Đường Dung P. 10, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH141', DATE '2024-10-14', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD141', 'CN2KH141', 'LX142', 'DV142', DATE '2025-05-01' + 141, 600000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH142', 'Lê Ngọc Lan', DATE '1987-09-10', '0919034749', 'Số 242 Đường Dung Phường 1, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH142', DATE '2024-08-24', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD142', 'CN2KH142', 'LX143', 'DV143', DATE '2025-05-01' + 142, 700000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH143', 'Hoàng Thị An', DATE '1992-04-22', '0911747019', 'Số 243 Đường Dũng P. 2, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH143', DATE '2024-09-10', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD143', 'CN2KH143', 'LX144', 'DV144', DATE '2025-05-01' + 143, 800000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH144', 'Vũ Hữu An', DATE '1983-02-16', '0914763343', 'Số 244 Đường An Phường 7, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH144', DATE '2024-11-13', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD144', 'CN2KH144', 'LX145', 'DV145', DATE '2025-05-01' + 144, 900000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH145', 'Lê Xuân Khoa', DATE '1968-01-02', '0914789711', 'Số 245 Đường Minh Phường 8, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH145', DATE '2025-03-04', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD145', 'CN2KH145', 'LX146', 'DV146', DATE '2025-05-01' + 145, 500000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH146', 'Trần Minh Dũng', DATE '1995-09-01', '0915728058', 'Số 246 Đường Linh Phường 10, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH146', DATE '2024-12-10', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD146', 'CN2KH146', 'LX147', 'DV147', DATE '2025-05-01' + 146, 600000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH147', 'Trần Xuân Châu', DATE '1976-02-03', '0911727239', 'Số 247 Đường Tuấn Phường 3, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH147', DATE '2024-10-22', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD147', 'CN2KH147', 'LX148', 'DV148', DATE '2025-05-01' + 147, 700000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH148', 'Bùi Xuân Tuấn', DATE '1978-10-14', '0914042807', 'Số 248 Đường Nga Phường 5, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH148', DATE '2024-07-14', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD148', 'CN2KH148', 'LX149', 'DV149', DATE '2025-05-01' + 148, 800000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH149', 'Hoàng Xuân Dũng', DATE '1973-08-30', '0915548190', 'Số 249 Đường Phúc P. 5, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH149', DATE '2024-05-30', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD149', 'CN2KH149', 'LX150', 'DV150', DATE '2025-05-01' + 149, 900000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH150', 'Trần Văn Dung', DATE '1983-05-10', '0913459356', 'Số 250 Đường Lan Phường 7, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH150', DATE '2024-10-13', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD150', 'CN2KH150', 'LX151', 'DV151', DATE '2025-05-01' + 150, 500000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH151', 'Đặng Thị Dũng', DATE '1996-05-22', '0918171473', 'Số 251 Đường Hương Phường 2, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH151', DATE '2024-12-15', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD151', 'CN2KH151', 'LX152', 'DV152', DATE '2025-05-01' + 151, 600000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH152', 'Lê Hữu Minh', DATE '1976-06-29', '0916915793', 'Số 252 Đường Lan P. 7, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH152', DATE '2024-09-25', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD152', 'CN2KH152', 'LX153', 'DV153', DATE '2025-05-01' + 152, 700000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH153', 'Vũ Xuân Dung', DATE '1998-08-23', '0915125653', 'Số 253 Đường Minh P. 9, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH153', DATE '2024-09-17', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD153', 'CN2KH153', 'LX154', 'DV154', DATE '2025-05-01' + 153, 800000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH154', 'Bùi Hoài Sơn', DATE '1975-07-01', '0919996153', 'Số 254 Đường Hiếu P. 2, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH154', DATE '2024-08-05', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD154', 'CN2KH154', 'LX155', 'DV155', DATE '2025-05-01' + 154, 900000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH155', 'Vũ Minh Châu', DATE '2002-07-07', '0914945884', 'Số 255 Đường Linh Phường 4, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH155', DATE '2025-05-21', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD155', 'CN2KH155', 'LX156', 'DV156', DATE '2025-05-01' + 155, 500000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH156', 'Phan Hoài Dung', DATE '2005-12-27', '0912848116', 'Số 256 Đường Bình P. 6, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH156', DATE '2025-03-19', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD156', 'CN2KH156', 'LX157', 'DV157', DATE '2025-05-01' + 156, 600000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH157', 'Hoàng Hoài Dung', DATE '1986-09-25', '0918064499', 'Số 257 Đường Hiếu Phường 4, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH157', DATE '2025-05-01', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD157', 'CN2KH157', 'LX158', 'DV158', DATE '2025-05-01' + 157, 700000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH158', 'Lê Thị Dung', DATE '1983-06-18', '0917332741', 'Số 258 Đường An P. 6, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH158', DATE '2025-05-02', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD158', 'CN2KH158', 'LX159', 'DV159', DATE '2025-05-01' + 158, 800000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH159', 'Trần Thị Phúc', DATE '1964-10-01', '0913653705', 'Số 259 Đường An Phường 6, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH159', DATE '2025-03-18', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD159', 'CN2KH159', 'LX160', 'DV160', DATE '2025-05-01' + 159, 900000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH160', 'Trần Minh Châu', DATE '1968-05-19', '0911209341', 'Số 260 Đường Trang P. 3, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH160', DATE '2025-02-25', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD160', 'CN2KH160', 'LX161', 'DV161', DATE '2025-05-01' + 160, 500000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH161', 'Đặng Hữu Quang', DATE '1970-06-18', '0916024905', 'Số 261 Đường Phúc P. 6, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH161', DATE '2024-10-14', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD161', 'CN2KH161', 'LX162', 'DV162', DATE '2025-05-01' + 161, 600000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH162', 'Nguyễn Ngọc Dũng', DATE '1997-06-11', '0913615355', 'Số 262 Đường Bình Phường 10, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH162', DATE '2025-03-02', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD162', 'CN2KH162', 'LX163', 'DV163', DATE '2025-05-01' + 162, 700000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH163', 'Bùi Hữu An', DATE '1999-10-21', '0917650332', 'Số 263 Đường Nga P. 9, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH163', DATE '2024-05-30', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD163', 'CN2KH163', 'LX164', 'DV164', DATE '2025-05-01' + 163, 800000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH164', 'Hoàng Ngọc Hiếu', DATE '1999-07-27', '0918108007', 'Số 264 Đường Giang P. 2, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH164', DATE '2024-09-04', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD164', 'CN2KH164', 'LX165', 'DV165', DATE '2025-05-01' + 164, 900000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH165', 'Vũ Hữu Hạnh', DATE '1976-11-04', '0917717637', 'Số 265 Đường Tuấn Phường 4, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH165', DATE '2024-11-10', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD165', 'CN2KH165', 'LX166', 'DV166', DATE '2025-05-01' + 165, 500000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH166', 'Lê Thị Phong', DATE '1975-05-11', '0919009715', 'Số 266 Đường Lan P. 7, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH166', DATE '2025-03-06', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD166', 'CN2KH166', 'LX167', 'DV167', DATE '2025-05-01' + 166, 600000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH167', 'Nguyễn Xuân Nga', DATE '1982-03-23', '0914267037', 'Số 267 Đường Hương Phường 2, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH167', DATE '2025-04-20', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD167', 'CN2KH167', 'LX168', 'DV168', DATE '2025-05-01' + 167, 700000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH168', 'Phan Xuân An', DATE '1995-03-18', '0915018645', 'Số 268 Đường Khoa Phường 9, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH168', DATE '2025-04-05', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD168', 'CN2KH168', 'LX169', 'DV169', DATE '2025-05-01' + 168, 800000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH169', 'Trần Minh Tuấn', DATE '1980-10-06', '0911184163', 'Số 269 Đường Khoa Phường 9, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH169', DATE '2025-02-15', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD169', 'CN2KH169', 'LX170', 'DV170', DATE '2025-05-01' + 169, 900000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH170', 'Nguyễn Minh Hương', DATE '1970-07-16', '0912426723', 'Số 270 Đường Trang Phường 10, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH170', DATE '2024-09-24', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD170', 'CN2KH170', 'LX171', 'DV171', DATE '2025-05-01' + 170, 500000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH171', 'Nguyễn Văn Lan', DATE '1973-09-05', '0912563819', 'Số 271 Đường Khoa Phường 6, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH171', DATE '2025-01-05', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD171', 'CN2KH171', 'LX172', 'DV172', DATE '2025-05-01' + 171, 600000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH172', 'Vũ Minh Lan', DATE '1992-12-19', '0917553873', 'Số 272 Đường Linh Phường 2, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH172', DATE '2024-12-11', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD172', 'CN2KH172', 'LX173', 'DV173', DATE '2025-05-01' + 172, 700000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH173', 'Vũ Thị Quang', DATE '1969-05-04', '0913519714', 'Số 273 Đường An P. 8, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH173', DATE '2024-08-02', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD173', 'CN2KH173', 'LX174', 'DV174', DATE '2025-05-01' + 173, 800000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH174', 'Nguyễn Ngọc Giang', DATE '1990-11-29', '0913542382', 'Số 274 Đường Phong Phường 2, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH174', DATE '2025-01-31', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD174', 'CN2KH174', 'LX175', 'DV175', DATE '2025-05-01' + 174, 900000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH175', 'Phạm Hữu Giang', DATE '2001-04-22', '0919415785', 'Số 275 Đường Quang P. 8, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH175', DATE '2025-03-23', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD175', 'CN2KH175', 'LX176', 'DV176', DATE '2025-05-01' + 175, 500000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH176', 'Phan Ngọc Linh', DATE '1989-10-19', '0918229326', 'Số 276 Đường Bình P. 4, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH176', DATE '2025-02-12', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD176', 'CN2KH176', 'LX177', 'DV177', DATE '2025-05-01' + 176, 600000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH177', 'Đỗ Thị Dung', DATE '1964-10-31', '0919347047', 'Số 277 Đường Dũng Phường 3, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH177', DATE '2024-12-22', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD177', 'CN2KH177', 'LX178', 'DV178', DATE '2025-05-01' + 177, 700000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH178', 'Bùi Thị Phúc', DATE '1997-03-04', '0912578970', 'Số 278 Đường Phong P. 3, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH178', DATE '2024-12-29', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD178', 'CN2KH178', 'LX179', 'DV179', DATE '2025-05-01' + 178, 800000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH179', 'Lê Thị Hương', DATE '1968-11-22', '0917095636', 'Số 279 Đường Linh Phường 2, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH179', DATE '2025-02-27', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD179', 'CN2KH179', 'LX180', 'DV180', DATE '2025-05-01' + 179, 900000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH180', 'Đặng Ngọc Phúc', DATE '1968-06-01', '0915295408', 'Số 280 Đường Phong Phường 2, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH180', DATE '2024-08-11', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD180', 'CN2KH180', 'LX181', 'DV181', DATE '2025-05-01' + 180, 500000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH181', 'Đặng Văn Linh', DATE '1988-04-27', '0915808770', 'Số 281 Đường Minh P. 10, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH181', DATE '2024-06-15', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD181', 'CN2KH181', 'LX182', 'DV182', DATE '2025-05-01' + 181, 600000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH182', 'Lê Hoài Linh', DATE '2002-09-06', '0919597975', 'Số 282 Đường Tuấn P. 6, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH182', DATE '2025-04-17', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD182', 'CN2KH182', 'LX183', 'DV183', DATE '2025-05-01' + 182, 700000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH183', 'Vũ Hoài Hương', DATE '1968-06-03', '0911715977', 'Số 283 Đường Tuấn Phường 4, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH183', DATE '2024-06-05', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD183', 'CN2KH183', 'LX184', 'DV184', DATE '2025-05-01' + 183, 800000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH184', 'Bùi Văn Dung', DATE '1970-08-19', '0912766607', 'Số 284 Đường Khoa P. 3, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH184', DATE '2024-08-11', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD184', 'CN2KH184', 'LX185', 'DV185', DATE '2025-05-01' + 184, 900000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH185', 'Vũ Thị Hiếu', DATE '1972-04-24', '0917513301', 'Số 285 Đường Phong Phường 6, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH185', DATE '2024-10-03', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD185', 'CN2KH185', 'LX186', 'DV186', DATE '2025-05-01' + 185, 500000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH186', 'Đặng Hoài Dũng', DATE '2003-06-29', '0912439863', 'Số 286 Đường Giang Phường 7, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH186', DATE '2024-10-20', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD186', 'CN2KH186', 'LX187', 'DV187', DATE '2025-05-01' + 186, 600000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH187', 'Phạm Anh Lan', DATE '1989-09-16', '0912081652', 'Số 287 Đường Lan P. 10, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH187', DATE '2024-09-23', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD187', 'CN2KH187', 'LX188', 'DV188', DATE '2025-05-01' + 187, 700000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH188', 'Phạm Hoài Dũng', DATE '1964-06-23', '0915670358', 'Số 288 Đường Phong Phường 9, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH188', DATE '2025-03-11', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD188', 'CN2KH188', 'LX189', 'DV189', DATE '2025-05-01' + 188, 800000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH189', 'Đặng Hữu Hạnh', DATE '2005-12-12', '0916371840', 'Số 289 Đường Trang Phường 10, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH189', DATE '2024-11-16', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD189', 'CN2KH189', 'LX190', 'DV190', DATE '2025-05-01' + 189, 900000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH190', 'Nguyễn Xuân Nga', DATE '1976-07-09', '0918942495', 'Số 290 Đường Hạnh Phường 4, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH190', DATE '2025-05-18', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD190', 'CN2KH190', 'LX191', 'DV191', DATE '2025-05-01' + 190, 500000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH191', 'Vũ Ngọc Hương', DATE '1995-12-21', '0913954562', 'Số 291 Đường Châu Phường 2, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH191', DATE '2025-01-09', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD191', 'CN2KH191', 'LX192', 'DV192', DATE '2025-05-01' + 191, 600000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH192', 'Vũ Thị Khoa', DATE '1971-11-03', '0918573586', 'Số 292 Đường Nga Phường 5, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH192', DATE '2025-02-24', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD192', 'CN2KH192', 'LX193', 'DV193', DATE '2025-05-01' + 192, 700000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH193', 'Nguyễn Thị Nga', DATE '1970-04-09', '0916738129', 'Số 293 Đường Khoa Phường 4, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH193', DATE '2024-12-02', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD193', 'CN2KH193', 'LX194', 'DV194', DATE '2025-05-01' + 193, 800000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH194', 'Vũ Hoài Phúc', DATE '1985-11-03', '0919984304', 'Số 294 Đường Giang P. 6, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH194', DATE '2024-06-09', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD194', 'CN2KH194', 'LX195', 'DV195', DATE '2025-05-01' + 194, 900000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH195', 'Đỗ Anh An', DATE '1977-01-22', '0914331283', 'Số 295 Đường Châu Phường 6, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH195', DATE '2024-06-23', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD195', 'CN2KH195', 'LX196', 'DV196', DATE '2025-05-01' + 195, 500000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH196', 'Phan Văn Dung', DATE '1993-06-29', '0918695022', 'Số 296 Đường Dung P. 6, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH196', DATE '2025-04-01', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD196', 'CN2KH196', 'LX197', 'DV197', DATE '2025-05-01' + 196, 600000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH197', 'Vũ Ngọc Quang', DATE '1969-11-29', '0911061687', 'Số 297 Đường Phong Phường 8, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH197', DATE '2024-07-06', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD197', 'CN2KH197', 'LX198', 'DV198', DATE '2025-05-01' + 197, 700000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH198', 'Đỗ Thị Bình', DATE '1967-05-18', '0914667881', 'Số 298 Đường Hạnh P. 9, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH198', DATE '2025-03-05', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD198', 'CN2KH198', 'LX199', 'DV199', DATE '2025-05-01' + 198, 800000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH199', 'Đỗ Anh Hạnh', DATE '1989-02-02', '0916839906', 'Số 299 Đường Hạnh Phường 10, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH199', DATE '2025-05-22', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD199', 'CN2KH199', 'LX200', 'DV200', DATE '2025-05-01' + 199, 900000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH200', 'Phan Xuân An', DATE '1979-11-19', '0916065787', 'Số 300 Đường Khoa Phường 8, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH200', DATE '2024-07-01', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD200', 'CN2KH200', 'LX201', 'DV201', DATE '2025-05-01' + 200, 500000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH201', 'Đặng Anh Nga', DATE '1994-05-22', '0916901033', 'Số 301 Đường Linh P. 9, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH201', DATE '2024-12-09', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD201', 'CN2KH201', 'LX202', 'DV202', DATE '2025-05-01' + 201, 600000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH202', 'Trần Hữu Phong', DATE '1968-01-12', '0918187084', 'Số 302 Đường Linh Phường 9, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH202', DATE '2024-07-29', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD202', 'CN2KH202', 'LX203', 'DV203', DATE '2025-05-01' + 202, 700000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH203', 'Lê Anh Minh', DATE '2003-03-01', '0915781975', 'Số 303 Đường Nga P. 10, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH203', DATE '2025-04-09', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD203', 'CN2KH203', 'LX204', 'DV204', DATE '2025-05-01' + 203, 800000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH204', 'Trần Thị Châu', DATE '1973-09-03', '0911275590', 'Số 304 Đường Tuấn P. 2, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH204', DATE '2024-09-17', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD204', 'CN2KH204', 'LX205', 'DV205', DATE '2025-05-01' + 204, 900000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH205', 'Đỗ Thị Phong', DATE '1977-12-28', '0919445004', 'Số 305 Đường Trang Phường 5, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH205', DATE '2024-10-26', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD205', 'CN2KH205', 'LX206', 'DV206', DATE '2025-05-01' + 205, 500000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH206', 'Phạm Minh Phong', DATE '1967-05-23', '0917393458', 'Số 306 Đường Dũng Phường 8, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH206', DATE '2025-03-27', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD206', 'CN2KH206', 'LX207', 'DV207', DATE '2025-05-01' + 206, 600000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH207', 'Phan Hoài Nga', DATE '1966-08-22', '0917640565', 'Số 307 Đường An P. 4, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH207', DATE '2024-09-12', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD207', 'CN2KH207', 'LX208', 'DV208', DATE '2025-05-01' + 207, 700000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH208', 'Hoàng Ngọc Hương', DATE '1995-11-15', '0916157260', 'Số 308 Đường Nga Phường 1, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH208', DATE '2024-10-29', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD208', 'CN2KH208', 'LX209', 'DV209', DATE '2025-05-01' + 208, 800000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH209', 'Nguyễn Văn An', DATE '1969-03-25', '0913573211', 'Số 309 Đường Linh P. 6, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH209', DATE '2025-03-03', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD209', 'CN2KH209', 'LX210', 'DV210', DATE '2025-05-01' + 209, 900000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH210', 'Đỗ Anh Hiếu', DATE '1993-09-06', '0917565971', 'Số 310 Đường Hạnh P. 1, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH210', DATE '2024-08-07', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD210', 'CN2KH210', 'LX211', 'DV211', DATE '2025-05-01' + 210, 500000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH211', 'Vũ Hữu Minh', DATE '2004-10-21', '0913914492', 'Số 311 Đường Minh P. 9, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH211', DATE '2025-03-09', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD211', 'CN2KH211', 'LX212', 'DV212', DATE '2025-05-01' + 211, 600000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH212', 'Vũ Minh Dũng', DATE '1985-10-08', '0913119470', 'Số 312 Đường Quang Phường 10, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH212', DATE '2024-11-10', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD212', 'CN2KH212', 'LX213', 'DV213', DATE '2025-05-01' + 212, 700000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH213', 'Hoàng Hữu Lan', DATE '1965-05-29', '0914418568', 'Số 313 Đường Châu Phường 1, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH213', DATE '2024-10-18', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD213', 'CN2KH213', 'LX214', 'DV214', DATE '2025-05-01' + 213, 800000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH214', 'Nguyễn Hữu An', DATE '1964-09-20', '0912321583', 'Số 314 Đường Trang P. 1, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH214', DATE '2025-03-24', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD214', 'CN2KH214', 'LX215', 'DV215', DATE '2025-05-01' + 214, 900000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH215', 'Đặng Xuân Giang', DATE '1997-05-02', '0915021865', 'Số 315 Đường Hiếu P. 4, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH215', DATE '2024-08-28', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD215', 'CN2KH215', 'LX216', 'DV216', DATE '2025-05-01' + 215, 500000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH216', 'Phạm Anh Hương', DATE '1981-11-09', '0911868201', 'Số 316 Đường Hương Phường 3, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH216', DATE '2024-07-12', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD216', 'CN2KH216', 'LX217', 'DV217', DATE '2025-05-01' + 216, 600000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH217', 'Nguyễn Thị Dũng', DATE '1970-04-21', '0918702884', 'Số 317 Đường Tuấn Phường 2, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH217', DATE '2025-03-18', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD217', 'CN2KH217', 'LX218', 'DV218', DATE '2025-05-01' + 217, 700000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH218', 'Hoàng Ngọc Giang', DATE '1998-09-19', '0912556542', 'Số 318 Đường Châu P. 6, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH218', DATE '2025-02-12', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD218', 'CN2KH218', 'LX219', 'DV219', DATE '2025-05-01' + 218, 800000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH219', 'Vũ Thị Phúc', DATE '2003-06-20', '0911368376', 'Số 319 Đường Nga Phường 8, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH219', DATE '2024-07-13', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD219', 'CN2KH219', 'LX220', 'DV220', DATE '2025-05-01' + 219, 900000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH220', 'Trần Minh Nga', DATE '1985-08-28', '0917295723', 'Số 320 Đường Lan P. 3, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH220', DATE '2025-02-26', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD220', 'CN2KH220', 'LX221', 'DV221', DATE '2025-05-01' + 220, 500000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH221', 'Hoàng Văn Giang', DATE '2002-08-20', '0911527651', 'Số 321 Đường Dũng P. 6, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH221', DATE '2024-09-24', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD221', 'CN2KH221', 'LX222', 'DV222', DATE '2025-05-01' + 221, 600000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH222', 'Đỗ Văn Giang', DATE '1986-09-04', '0919753488', 'Số 322 Đường Hương Phường 4, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH222', DATE '2024-07-23', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD222', 'CN2KH222', 'LX223', 'DV223', DATE '2025-05-01' + 222, 700000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH223', 'Nguyễn Văn Quang', DATE '1984-05-07', '0919585651', 'Số 323 Đường Dung Phường 6, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH223', DATE '2025-04-01', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD223', 'CN2KH223', 'LX224', 'DV224', DATE '2025-05-01' + 223, 800000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH224', 'Phạm Văn Lan', DATE '1979-11-09', '0913324735', 'Số 324 Đường Hiếu Phường 3, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH224', DATE '2025-01-12', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD224', 'CN2KH224', 'LX225', 'DV225', DATE '2025-05-01' + 224, 900000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH225', 'Hoàng Hoài Hạnh', DATE '1973-12-28', '0912542997', 'Số 325 Đường Linh P. 8, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH225', DATE '2024-09-18', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD225', 'CN2KH225', 'LX226', 'DV226', DATE '2025-05-01' + 225, 500000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH226', 'Vũ Anh Hạnh', DATE '2003-01-09', '0915195866', 'Số 326 Đường Giang Phường 5, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH226', DATE '2024-11-09', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD226', 'CN2KH226', 'LX227', 'DV227', DATE '2025-05-01' + 226, 600000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH227', 'Trần Ngọc Giang', DATE '1999-12-03', '0914453284', 'Số 327 Đường Phúc P. 8, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH227', DATE '2024-10-25', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD227', 'CN2KH227', 'LX228', 'DV228', DATE '2025-05-01' + 227, 700000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH228', 'Đỗ Ngọc Lan', DATE '1996-04-11', '0912804542', 'Số 328 Đường Tuấn P. 7, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH228', DATE '2025-02-16', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD228', 'CN2KH228', 'LX229', 'DV229', DATE '2025-05-01' + 228, 800000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH229', 'Đỗ Xuân Linh', DATE '1992-07-11', '0912078208', 'Số 329 Đường Phong Phường 1, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH229', DATE '2024-09-10', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD229', 'CN2KH229', 'LX230', 'DV230', DATE '2025-05-01' + 229, 900000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH230', 'Hoàng Anh Khoa', DATE '2004-10-07', '0919900282', 'Số 330 Đường Linh P. 1, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH230', DATE '2025-04-01', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD230', 'CN2KH230', 'LX231', 'DV231', DATE '2025-05-01' + 230, 500000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH231', 'Lê Xuân Nga', DATE '2002-03-13', '0914119134', 'Số 331 Đường Linh Phường 2, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH231', DATE '2025-02-08', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD231', 'CN2KH231', 'LX232', 'DV232', DATE '2025-05-01' + 231, 600000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH232', 'Phan Xuân Dung', DATE '2003-05-29', '0916275644', 'Số 332 Đường Dũng Phường 6, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH232', DATE '2024-06-11', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD232', 'CN2KH232', 'LX233', 'DV233', DATE '2025-05-01' + 232, 700000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH233', 'Nguyễn Xuân Hạnh', DATE '1978-12-04', '0918807724', 'Số 333 Đường Trang P. 4, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH233', DATE '2024-08-15', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD233', 'CN2KH233', 'LX234', 'DV234', DATE '2025-05-01' + 233, 800000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH234', 'Trần Anh Khoa', DATE '1992-06-14', '0914559708', 'Số 334 Đường Quang Phường 2, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH234', DATE '2024-08-15', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD234', 'CN2KH234', 'LX235', 'DV235', DATE '2025-05-01' + 234, 900000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH235', 'Hoàng Thị Trang', DATE '1987-11-10', '0918075793', 'Số 335 Đường Nga P. 6, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH235', DATE '2025-02-17', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD235', 'CN2KH235', 'LX236', 'DV236', DATE '2025-05-01' + 235, 500000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH236', 'Phạm Văn Phúc', DATE '1973-05-10', '0919365975', 'Số 336 Đường Bình P. 7, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH236', DATE '2025-03-29', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD236', 'CN2KH236', 'LX237', 'DV237', DATE '2025-05-01' + 236, 600000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH237', 'Trần Hoài Giang', DATE '2004-11-28', '0916484048', 'Số 337 Đường Trang P. 4, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH237', DATE '2024-08-07', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD237', 'CN2KH237', 'LX238', 'DV238', DATE '2025-05-01' + 237, 700000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH238', 'Nguyễn Ngọc An', DATE '1981-11-26', '0911077963', 'Số 338 Đường Phong P. 3, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH238', DATE '2024-11-04', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD238', 'CN2KH238', 'LX239', 'DV239', DATE '2025-05-01' + 238, 800000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH239', 'Nguyễn Văn Lan', DATE '1983-05-25', '0911273003', 'Số 339 Đường Châu P. 2, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH239', DATE '2024-10-29', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD239', 'CN2KH239', 'LX240', 'DV240', DATE '2025-05-01' + 239, 900000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH240', 'Hoàng Ngọc Lan', DATE '1996-07-17', '0916801971', 'Số 340 Đường Minh Phường 9, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH240', DATE '2024-12-20', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD240', 'CN2KH240', 'LX241', 'DV241', DATE '2025-05-01' + 240, 500000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH241', 'Đặng Văn Minh', DATE '1972-04-09', '0916007056', 'Số 341 Đường Phong P. 2, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH241', DATE '2024-11-19', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD241', 'CN2KH241', 'LX242', 'DV242', DATE '2025-05-01' + 241, 600000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH242', 'Đỗ Thị An', DATE '1992-07-16', '0914758337', 'Số 342 Đường Bình Phường 3, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH242', DATE '2025-04-06', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD242', 'CN2KH242', 'LX243', 'DV243', DATE '2025-05-01' + 242, 700000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH243', 'Phan Anh Hiếu', DATE '1970-05-27', '0913855338', 'Số 343 Đường Châu Phường 6, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH243', DATE '2024-08-27', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD243', 'CN2KH243', 'LX244', 'DV244', DATE '2025-05-01' + 243, 800000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH244', 'Nguyễn Văn Hương', DATE '2006-11-24', '0911722698', 'Số 344 Đường Dũng Phường 5, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH244', DATE '2025-04-21', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD244', 'CN2KH244', 'LX245', 'DV245', DATE '2025-05-01' + 244, 900000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH245', 'Hoàng Xuân Tuấn', DATE '1999-06-07', '0917367900', 'Số 345 Đường Hương Phường 3, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH245', DATE '2024-08-04', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD245', 'CN2KH245', 'LX246', 'DV246', DATE '2025-05-01' + 245, 500000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH246', 'Đặng Thị Dung', DATE '1974-01-07', '0916357513', 'Số 346 Đường Dung P. 8, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH246', DATE '2024-06-21', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD246', 'CN2KH246', 'LX247', 'DV247', DATE '2025-05-01' + 246, 600000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH247', 'Trần Minh Trang', DATE '1996-09-02', '0919018281', 'Số 347 Đường Phúc P. 6, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH247', DATE '2024-09-24', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD247', 'CN2KH247', 'LX248', 'DV248', DATE '2025-05-01' + 247, 700000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH248', 'Phạm Thị Hương', DATE '1978-03-02', '0915969984', 'Số 348 Đường Châu P. 9, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH248', DATE '2025-01-25', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD248', 'CN2KH248', 'LX249', 'DV249', DATE '2025-05-01' + 248, 800000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH249', 'Phạm Thị Châu', DATE '1985-07-24', '0919298107', 'Số 349 Đường Bình Phường 1, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH249', DATE '2024-06-20', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD249', 'CN2KH249', 'LX250', 'DV250', DATE '2025-05-01' + 249, 900000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH250', 'Phạm Hoài Minh', DATE '2001-01-17', '0914152731', 'Số 350 Đường Phúc Phường 6, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH250', DATE '2025-02-12', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD250', 'CN2KH250', 'LX251', 'DV251', DATE '2025-05-01' + 250, 500000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH251', 'Đỗ Xuân Khoa', DATE '1970-01-12', '0918617224', 'Số 351 Đường Dung Phường 3, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH251', DATE '2025-02-06', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD251', 'CN2KH251', 'LX252', 'DV252', DATE '2025-05-01' + 251, 600000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH252', 'Phan Anh Phong', DATE '1978-12-01', '0919614497', 'Số 352 Đường Hạnh P. 4, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH252', DATE '2025-04-24', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD252', 'CN2KH252', 'LX253', 'DV253', DATE '2025-05-01' + 252, 700000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH253', 'Hoàng Anh Giang', DATE '1969-03-21', '0916153067', 'Số 353 Đường Trang Phường 3, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH253', DATE '2024-10-05', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD253', 'CN2KH253', 'LX254', 'DV254', DATE '2025-05-01' + 253, 800000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH254', 'Trần Thị Hiếu', DATE '1966-10-28', '0911278299', 'Số 354 Đường Phong Phường 5, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH254', DATE '2025-05-15', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD254', 'CN2KH254', 'LX255', 'DV255', DATE '2025-05-01' + 254, 900000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH255', 'Đặng Hoài Linh', DATE '1981-12-14', '0915455671', 'Số 355 Đường Dũng Phường 6, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH255', DATE '2024-10-21', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD255', 'CN2KH255', 'LX256', 'DV256', DATE '2025-05-01' + 255, 500000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH256', 'Phạm Hữu Minh', DATE '1987-01-08', '0919425356', 'Số 356 Đường Nga P. 1, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH256', DATE '2024-10-16', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD256', 'CN2KH256', 'LX257', 'DV257', DATE '2025-05-01' + 256, 600000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH257', 'Hoàng Xuân Dũng', DATE '1967-07-01', '0911824338', 'Số 357 Đường Minh P. 4, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH257', DATE '2024-12-30', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD257', 'CN2KH257', 'LX258', 'DV258', DATE '2025-05-01' + 257, 700000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH258', 'Phạm Anh Giang', DATE '1974-11-13', '0915629265', 'Số 358 Đường Quang P. 9, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH258', DATE '2024-10-20', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD258', 'CN2KH258', 'LX259', 'DV259', DATE '2025-05-01' + 258, 800000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH259', 'Trần Văn Hiếu', DATE '1988-05-06', '0912863660', 'Số 359 Đường Hiếu Phường 1, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH259', DATE '2025-05-11', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD259', 'CN2KH259', 'LX260', 'DV260', DATE '2025-05-01' + 259, 900000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH260', 'Đỗ Ngọc Hiếu', DATE '2002-08-13', '0912104735', 'Số 360 Đường Sơn Phường 5, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH260', DATE '2025-02-03', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD260', 'CN2KH260', 'LX261', 'DV261', DATE '2025-05-01' + 260, 500000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH261', 'Đỗ Anh Minh', DATE '2005-12-20', '0917591523', 'Số 361 Đường Dũng Phường 5, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH261', DATE '2024-09-18', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD261', 'CN2KH261', 'LX262', 'DV262', DATE '2025-05-01' + 261, 600000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH262', 'Phạm Hữu Hạnh', DATE '1991-11-07', '0916832315', 'Số 362 Đường Khoa P. 1, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH262', DATE '2025-04-11', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD262', 'CN2KH262', 'LX263', 'DV263', DATE '2025-05-01' + 262, 700000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH263', 'Lê Hoài Khoa', DATE '1979-07-02', '0915003370', 'Số 363 Đường Giang P. 2, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH263', DATE '2025-03-05', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD263', 'CN2KH263', 'LX264', 'DV264', DATE '2025-05-01' + 263, 800000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH264', 'Lê Xuân Phong', DATE '1976-11-14', '0913379573', 'Số 364 Đường An P. 7, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH264', DATE '2024-12-09', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD264', 'CN2KH264', 'LX265', 'DV265', DATE '2025-05-01' + 264, 900000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH265', 'Nguyễn Hữu Hương', DATE '1969-01-31', '0912291460', 'Số 365 Đường Giang Phường 10, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH265', DATE '2024-11-30', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD265', 'CN2KH265', 'LX266', 'DV266', DATE '2025-05-01' + 265, 500000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH266', 'Đặng Văn Phúc', DATE '1996-04-09', '0915152535', 'Số 366 Đường Phúc Phường 1, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH266', DATE '2025-05-21', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD266', 'CN2KH266', 'LX267', 'DV267', DATE '2025-05-01' + 266, 600000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH267', 'Đỗ Ngọc Hiếu', DATE '1984-08-08', '0919812554', 'Số 367 Đường Quang Phường 3, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH267', DATE '2025-04-11', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD267', 'CN2KH267', 'LX268', 'DV268', DATE '2025-05-01' + 267, 700000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH268', 'Trần Ngọc Lan', DATE '1978-12-04', '0918593642', 'Số 368 Đường Phúc P. 9, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH268', DATE '2025-01-18', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD268', 'CN2KH268', 'LX269', 'DV269', DATE '2025-05-01' + 268, 800000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH269', 'Đặng Ngọc Linh', DATE '1988-11-25', '0918696560', 'Số 369 Đường An P. 5, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH269', DATE '2024-05-31', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD269', 'CN2KH269', 'LX270', 'DV270', DATE '2025-05-01' + 269, 900000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH270', 'Phan Hoài Dũng', DATE '1994-03-15', '0915528798', 'Số 370 Đường Quang Phường 3, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH270', DATE '2024-10-31', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD270', 'CN2KH270', 'LX271', 'DV271', DATE '2025-05-01' + 270, 500000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH271', 'Phạm Hữu Linh', DATE '1981-10-30', '0919352238', 'Số 371 Đường An Phường 10, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH271', DATE '2024-06-07', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD271', 'CN2KH271', 'LX272', 'DV272', DATE '2025-05-01' + 271, 600000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH272', 'Vũ Xuân Hạnh', DATE '2000-01-25', '0912497768', 'Số 372 Đường Hạnh P. 2, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH272', DATE '2025-01-09', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD272', 'CN2KH272', 'LX273', 'DV273', DATE '2025-05-01' + 272, 700000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH273', 'Bùi Hoài Quang', DATE '1980-11-14', '0913935211', 'Số 373 Đường Hương P. 6, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH273', DATE '2024-11-10', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD273', 'CN2KH273', 'LX274', 'DV274', DATE '2025-05-01' + 273, 800000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH274', 'Đỗ Anh Hương', DATE '1987-05-15', '0916189583', 'Số 374 Đường Hạnh Phường 10, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH274', DATE '2024-09-05', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD274', 'CN2KH274', 'LX275', 'DV275', DATE '2025-05-01' + 274, 900000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH275', 'Phan Thị Nga', DATE '1974-09-16', '0918634097', 'Số 375 Đường Trang P. 5, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH275', DATE '2025-04-03', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD275', 'CN2KH275', 'LX276', 'DV276', DATE '2025-05-01' + 275, 500000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH276', 'Nguyễn Hoài Dung', DATE '1993-01-12', '0918823508', 'Số 376 Đường Dung P. 10, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH276', DATE '2024-08-17', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD276', 'CN2KH276', 'LX277', 'DV277', DATE '2025-05-01' + 276, 600000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH277', 'Lê Ngọc Phúc', DATE '2000-06-20', '0915836199', 'Số 377 Đường Châu P. 1, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH277', DATE '2024-10-09', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD277', 'CN2KH277', 'LX278', 'DV278', DATE '2025-05-01' + 277, 700000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH278', 'Nguyễn Minh Khoa', DATE '1968-07-10', '0913070908', 'Số 378 Đường Bình P. 5, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH278', DATE '2025-05-27', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD278', 'CN2KH278', 'LX279', 'DV279', DATE '2025-05-01' + 278, 800000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH279', 'Vũ Xuân An', DATE '1992-01-05', '0911837217', 'Số 379 Đường Hương Phường 6, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH279', DATE '2025-01-04', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD279', 'CN2KH279', 'LX280', 'DV280', DATE '2025-05-01' + 279, 900000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH280', 'Bùi Hữu Châu', DATE '1982-12-26', '0915541070', 'Số 380 Đường Dung Phường 7, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH280', DATE '2024-08-03', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD280', 'CN2KH280', 'LX281', 'DV281', DATE '2025-05-01' + 280, 500000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH281', 'Trần Ngọc Hiếu', DATE '2001-07-16', '0911539164', 'Số 381 Đường Phúc P. 4, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH281', DATE '2024-06-16', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD281', 'CN2KH281', 'LX282', 'DV282', DATE '2025-05-01' + 281, 600000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH282', 'Vũ Anh Minh', DATE '1994-01-14', '0912646494', 'Số 382 Đường Hương P. 10, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH282', DATE '2024-12-21', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD282', 'CN2KH282', 'LX283', 'DV283', DATE '2025-05-01' + 282, 700000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH283', 'Lê Anh Lan', DATE '1967-01-21', '0913334991', 'Số 383 Đường Hạnh P. 3, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH283', DATE '2024-10-28', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD283', 'CN2KH283', 'LX284', 'DV284', DATE '2025-05-01' + 283, 800000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH284', 'Bùi Minh Khoa', DATE '1993-08-14', '0916116985', 'Số 384 Đường Châu P. 10, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH284', DATE '2024-07-12', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD284', 'CN2KH284', 'LX285', 'DV285', DATE '2025-05-01' + 284, 900000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH285', 'Đặng Hữu Minh', DATE '1994-11-18', '0918329845', 'Số 385 Đường Dũng Phường 9, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH285', DATE '2024-10-15', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD285', 'CN2KH285', 'LX286', 'DV286', DATE '2025-05-01' + 285, 500000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH286', 'Phan Xuân Phong', DATE '1977-08-04', '0916942386', 'Số 386 Đường Nga P. 7, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH286', DATE '2024-10-31', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD286', 'CN2KH286', 'LX287', 'DV287', DATE '2025-05-01' + 286, 600000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH287', 'Đặng Văn Sơn', DATE '2004-06-09', '0911443289', 'Số 387 Đường Nga Phường 3, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH287', DATE '2024-07-19', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD287', 'CN2KH287', 'LX288', 'DV288', DATE '2025-05-01' + 287, 700000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH288', 'Hoàng Minh Trang', DATE '2001-09-11', '0919593404', 'Số 388 Đường Linh Phường 10, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH288', DATE '2024-08-24', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD288', 'CN2KH288', 'LX289', 'DV289', DATE '2025-05-01' + 288, 800000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH289', 'Đỗ Ngọc Bình', DATE '1979-04-25', '0917587730', 'Số 389 Đường Dung P. 1, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH289', DATE '2024-10-05', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD289', 'CN2KH289', 'LX290', 'DV290', DATE '2025-05-01' + 289, 900000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH290', 'Bùi Hoài Bình', DATE '1981-07-06', '0912420343', 'Số 390 Đường Bình P. 2, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH290', DATE '2024-12-10', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD290', 'CN2KH290', 'LX291', 'DV291', DATE '2025-05-01' + 290, 500000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH291', 'Đỗ Thị Khoa', DATE '1984-10-16', '0919077690', 'Số 391 Đường Lan Phường 2, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH291', DATE '2024-08-03', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD291', 'CN2KH291', 'LX292', 'DV292', DATE '2025-05-01' + 291, 600000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH292', 'Bùi Văn Hạnh', DATE '2001-04-15', '0919661473', 'Số 392 Đường Dung P. 3, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH292', DATE '2025-02-04', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD292', 'CN2KH292', 'LX293', 'DV293', DATE '2025-05-01' + 292, 700000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH293', 'Lê Ngọc Khoa', DATE '1998-08-30', '0911108226', 'Số 393 Đường Phúc Phường 2, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH293', DATE '2025-04-25', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD293', 'CN2KH293', 'LX294', 'DV294', DATE '2025-05-01' + 293, 800000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH294', 'Nguyễn Hữu Tuấn', DATE '1977-09-10', '0913030620', 'Số 394 Đường Quang Phường 4, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH294', DATE '2025-02-14', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD294', 'CN2KH294', 'LX295', 'DV295', DATE '2025-05-01' + 294, 900000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH295', 'Trần Hoài An', DATE '2001-08-22', '0919485991', 'Số 395 Đường Phong P. 1, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH295', DATE '2025-03-28', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD295', 'CN2KH295', 'LX296', 'DV296', DATE '2025-05-01' + 295, 500000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH296', 'Hoàng Anh Phúc', DATE '1985-01-26', '0914087744', 'Số 396 Đường Hiếu P. 10, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH296', DATE '2024-06-15', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD296', 'CN2KH296', 'LX297', 'DV297', DATE '2025-05-01' + 296, 600000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH297', 'Đặng Thị Nga', DATE '1976-06-11', '0913453606', 'Số 397 Đường An Phường 3, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH297', DATE '2024-06-27', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD297', 'CN2KH297', 'LX298', 'DV298', DATE '2025-05-01' + 297, 700000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH298', 'Phạm Hữu Quang', DATE '1986-01-15', '0914361332', 'Số 398 Đường Phúc P. 5, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH298', DATE '2025-01-01', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD298', 'CN2KH298', 'LX299', 'DV299', DATE '2025-05-01' + 298, 800000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH299', 'Trần Hoài Linh', DATE '1979-11-30', '0915616776', 'Số 399 Đường Minh P. 2, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH299', DATE '2024-10-04', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD299', 'CN2KH299', 'LX300', 'DV300', DATE '2025-05-01' + 299, 900000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH300', 'Vũ Anh Dung', DATE '1990-06-12', '0911469269', 'Số 400 Đường Khoa P. 2, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH300', DATE '2024-08-14', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD300', 'CN2KH300', 'LX301', 'DV301', DATE '2025-05-01' + 300, 500000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH301', 'Vũ Văn Trang', DATE '2007-04-28', '0916079496', 'Số 401 Đường Bình P. 1, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH301', DATE '2024-11-29', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD301', 'CN2KH301', 'LX302', 'DV302', DATE '2025-05-01' + 301, 600000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH302', 'Lê Hoài Phong', DATE '1984-09-05', '0915645678', 'Số 402 Đường An Phường 6, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH302', DATE '2024-09-15', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD302', 'CN2KH302', 'LX303', 'DV303', DATE '2025-05-01' + 302, 700000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH303', 'Bùi Minh Linh', DATE '1992-01-11', '0919808972', 'Số 403 Đường Minh Phường 3, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH303', DATE '2024-06-28', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD303', 'CN2KH303', 'LX304', 'DV304', DATE '2025-05-01' + 303, 800000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH304', 'Lê Xuân Trang', DATE '1973-10-16', '0916692359', 'Số 404 Đường Phong Phường 5, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH304', DATE '2024-06-26', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD304', 'CN2KH304', 'LX305', 'DV305', DATE '2025-05-01' + 304, 900000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH305', 'Hoàng Anh Châu', DATE '2001-03-02', '0919115888', 'Số 405 Đường Minh P. 10, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH305', DATE '2024-06-26', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD305', 'CN2KH305', 'LX306', 'DV306', DATE '2025-05-01' + 305, 500000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH306', 'Lê Ngọc Dung', DATE '1967-08-20', '0916437103', 'Số 406 Đường Trang P. 10, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH306', DATE '2024-07-17', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD306', 'CN2KH306', 'LX307', 'DV307', DATE '2025-05-01' + 306, 600000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH307', 'Vũ Thị Bình', DATE '1986-12-03', '0911495294', 'Số 407 Đường Giang Phường 2, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH307', DATE '2024-06-23', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD307', 'CN2KH307', 'LX308', 'DV308', DATE '2025-05-01' + 307, 700000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH308', 'Trần Hoài Phúc', DATE '1987-02-19', '0916430103', 'Số 408 Đường Hiếu Phường 2, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH308', DATE '2025-03-01', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD308', 'CN2KH308', 'LX309', 'DV309', DATE '2025-05-01' + 308, 800000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH309', 'Vũ Anh Châu', DATE '1968-01-08', '0912038956', 'Số 409 Đường Tuấn P. 2, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH309', DATE '2025-05-10', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD309', 'CN2KH309', 'LX310', 'DV310', DATE '2025-05-01' + 309, 900000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH310', 'Trần Hoài Linh', DATE '1994-09-22', '0911494247', 'Số 410 Đường Giang P. 2, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH310', DATE '2024-06-06', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD310', 'CN2KH310', 'LX311', 'DV311', DATE '2025-05-01' + 310, 500000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH311', 'Đặng Anh Dung', DATE '1994-08-23', '0914350987', 'Số 411 Đường Hạnh P. 8, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH311', DATE '2024-10-17', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD311', 'CN2KH311', 'LX312', 'DV312', DATE '2025-05-01' + 311, 600000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH312', 'Hoàng Minh Hạnh', DATE '1983-03-28', '0913719411', 'Số 412 Đường Nga Phường 2, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH312', DATE '2024-08-04', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD312', 'CN2KH312', 'LX313', 'DV313', DATE '2025-05-01' + 312, 700000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH313', 'Nguyễn Thị Hạnh', DATE '1967-10-26', '0911557661', 'Số 413 Đường Dung Phường 6, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH313', DATE '2024-11-02', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD313', 'CN2KH313', 'LX314', 'DV314', DATE '2025-05-01' + 313, 800000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH314', 'Đỗ Thị Lan', DATE '1991-03-08', '0914108891', 'Số 414 Đường Quang P. 4, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH314', DATE '2025-02-12', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD314', 'CN2KH314', 'LX315', 'DV315', DATE '2025-05-01' + 314, 900000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH315', 'Đỗ Hoài Quang', DATE '1988-11-29', '0916907359', 'Số 415 Đường Linh Phường 2, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH315', DATE '2024-10-17', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD315', 'CN2KH315', 'LX316', 'DV316', DATE '2025-05-01' + 315, 500000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH316', 'Vũ Anh Châu', DATE '1994-12-17', '0912311035', 'Số 416 Đường Dung P. 2, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH316', DATE '2025-03-30', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD316', 'CN2KH316', 'LX317', 'DV317', DATE '2025-05-01' + 316, 600000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH317', 'Đặng Minh Bình', DATE '2006-08-04', '0916551912', 'Số 417 Đường An Phường 5, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH317', DATE '2025-01-21', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD317', 'CN2KH317', 'LX318', 'DV318', DATE '2025-05-01' + 317, 700000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH318', 'Vũ Xuân Châu', DATE '1987-03-30', '0913648501', 'Số 418 Đường Khoa Phường 9, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH318', DATE '2024-08-08', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD318', 'CN2KH318', 'LX319', 'DV319', DATE '2025-05-01' + 318, 800000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH319', 'Phạm Ngọc Minh', DATE '1988-05-22', '0911950399', 'Số 419 Đường Sơn Phường 10, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH319', DATE '2024-09-30', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD319', 'CN2KH319', 'LX320', 'DV320', DATE '2025-05-01' + 319, 900000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH320', 'Hoàng Văn Bình', DATE '1969-11-08', '0916671458', 'Số 420 Đường Nga P. 4, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH320', DATE '2024-12-09', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD320', 'CN2KH320', 'LX321', 'DV321', DATE '2025-05-01' + 320, 500000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH321', 'Nguyễn Hữu Hạnh', DATE '1989-03-11', '0916529924', 'Số 421 Đường Bình Phường 8, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH321', DATE '2025-04-22', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD321', 'CN2KH321', 'LX322', 'DV322', DATE '2025-05-01' + 321, 600000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH322', 'Đỗ Văn Linh', DATE '1991-06-06', '0912187207', 'Số 422 Đường Nga Phường 9, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH322', DATE '2024-09-26', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD322', 'CN2KH322', 'LX323', 'DV323', DATE '2025-05-01' + 322, 700000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH323', 'Lê Ngọc Bình', DATE '1975-04-05', '0912745857', 'Số 423 Đường Bình P. 9, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH323', DATE '2025-02-03', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD323', 'CN2KH323', 'LX324', 'DV324', DATE '2025-05-01' + 323, 800000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH324', 'Phan Anh Phúc', DATE '1978-06-04', '0916090515', 'Số 424 Đường Hiếu Phường 1, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH324', DATE '2025-05-16', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD324', 'CN2KH324', 'LX325', 'DV325', DATE '2025-05-01' + 324, 900000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH325', 'Phạm Anh An', DATE '2002-10-29', '0919089526', 'Số 425 Đường Bình P. 7, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH325', DATE '2024-06-07', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD325', 'CN2KH325', 'LX326', 'DV326', DATE '2025-05-01' + 325, 500000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH326', 'Lê Anh Nga', DATE '1976-11-04', '0913311404', 'Số 426 Đường Dũng P. 2, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH326', DATE '2024-07-18', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD326', 'CN2KH326', 'LX327', 'DV327', DATE '2025-05-01' + 326, 600000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH327', 'Phan Xuân Hạnh', DATE '1965-01-25', '0916756692', 'Số 427 Đường Nga Phường 4, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH327', DATE '2025-01-31', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD327', 'CN2KH327', 'LX328', 'DV328', DATE '2025-05-01' + 327, 700000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH328', 'Trần Văn Hiếu', DATE '2004-10-31', '0917930088', 'Số 428 Đường Sơn Phường 1, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH328', DATE '2025-01-22', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD328', 'CN2KH328', 'LX329', 'DV329', DATE '2025-05-01' + 328, 800000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH329', 'Nguyễn Thị Bình', DATE '1966-09-21', '0913125939', 'Số 429 Đường Phong Phường 5, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH329', DATE '2025-05-07', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD329', 'CN2KH329', 'LX330', 'DV330', DATE '2025-05-01' + 329, 900000, 'CN2');
INSERT INTO KHACHHANG_V1 (MaKH, HoTen, NgaySinh, SoDT, DiaChi) VALUES ('CN2KH330', 'Phan Xuân Tuấn', DATE '2001-03-18', '0915097740', 'Số 430 Đường Khoa Phường 10, TP.HCM');
INSERT INTO KHACHHANG_V2 (MaKH, NgayDangKy, TongTien, ChiNhanhDangKy) VALUES ('CN2KH330', DATE '2024-11-07', 0, 'CN2');
INSERT INTO HOADON (MaHD, MaKH, MaLX, MaDV, NgayLap, TongTien, ChiNhanhID) VALUES ('CN2HD330', 'CN2KH330', 'LX001', 'DV001', DATE '2025-05-01' + 330, 500000, 'CN2');


SELECT COUNT(*) AS SoLuongCN2
FROM TRANSACTION
WHERE ChiNhanhID = 'CN2';


SELECT*FROM TRANSACTION t
SELECT * FROM HoaDon;


SELECT *
FROM TRANSACTION
WHERE ChiNhanhID = 'CN2'
ORDER BY MaGiaoDich
OFFSET 329999 ROWS FETCH NEXT 1 ROWS ONLY;


SELECT COUNT(*) AS SoLuong_GD_CN2
FROM TRANSACTION
WHERE ChiNhanhID = 'CN2';



SELECT MaKH
 FROM cn1_user.HOADON WHERE ChiNhanhID = 'CN1'
 INTERSECT
 SELECT MaKH FROM cn2_user.HOADON@CN2_LINK_GIAMDOC WHERE ChiNhanhID = 'CN2'
 INTERSECT
 SELECT MaKH FROM cn3_user.HOADON@CN3_LINK_GIAMDOC WHERE ChiNhanhID = 'CN3';


SELECT * FROM LAIXE l
INSERT INTO HOADON VALUES ('HDcn101', 'KH11', 'LX11', 'DV1', TO_DATE('2025-05-10', 'YYYY-MM-DD'), 5000000, 'CN2');


INSERT INTO KHACHHANG_V1 VALUES ('KH11', 'Trần Thị Mai', TO_DATE('1995-07-18', 'YYYY-MM-DD'), '0955678901', 'quận 2, TP.HCM');
INSERT INTO KHACHHANG_V2 VALUES ('KH11', TO_DATE('2025-05-01', 'YYYY-MM-DD'), 1150000, 'CN2');
INSERT INTO LAIXE VALUES ('LX15', 'Lương Văn Y', TO_DATE('1987-06-15', 'YYYY-MM-DD'), '0925678901', 'HN345', 'CN2');
INSERT INTO LAIXE VALUES ('LX11', 'Lương Văn Y', TO_DATE('1987-06-15', 'YYYY-MM-DD'), '0925678901', 'HN345', 'CN2');
INSERT INTO HOADON VALUES ('HD11', 'KH11', 'LX11', 'DV1', TO_DATE('2025-05-10', 'YYYY-MM-DD'), 500000, 'CN2');

SELECT * FROM DICHVU 

-- PHUONGTIEN
INSERT INTO PHUONGTIEN VALUES ('HN123', 'Sedan', 'Toyota', 4, 'Sẵn sàng');


-- DICHVU
INSERT INTO DICHVU VALUES ('DV1', 'Thuê xe tự lái', 'Thuê xe 4 chỗ', 500000);


Mô tả: Tìm các khách hàng (MaKH) có hóa đơn trong bảng HOADON tại cả 3 chi nhánh (CN1, CN2, CN3).
User thực hiện: giamdoc2
Truy vấn SQL:

SELECT MaKH
 FROM cn2_user.HOADON WHERE ChiNhanhID = 'CN2'
 INTERSECT
 SELECT MaKH FROM cn1_user.HOADON@CN1_LINK_GIAMDOC WHERE ChiNhanhID = 'CN1'
 INTERSECT
 SELECT MaKH FROM cn3_user.HOADON@CN3_LINK_GIAMDOC WHERE ChiNhanhID = 'CN3';

SELECT MaKH
 FROM cn2_user.HOADON WHERE ChiNhanhID = 'CN2'
 INTERSECT
 SELECT MaKH FROM cn1_user.HOADON@CN1_LINK_GIAMDOC WHERE ChiNhanhID = 'CN1'
 INTERSECT
 SELECT MaKH FROM cn3_user.HOADON@CN3_LINK_GIAMDOC WHERE ChiNhanhID = 'CN3';

