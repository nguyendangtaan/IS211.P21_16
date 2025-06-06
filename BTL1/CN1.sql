      
      alter session set "_ORACLE_SCRIPT"=true;
      CREATE USER cn1_user IDENTIFIED BY password123;
      GRANT CONNECT, RESOURCE TO cn1_user;
      GRANT DBA TO cn1_user;
      
      
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
      SELECT BienSoXe FROM PHUONGTIEN WHERE SOCHONGOI=4;
      SELECT * FROM PHUONGTIEN 
      -- Tạo bảng DICHVU
      CREATE TABLE DICHVU (
          MaDV VARCHAR2(10) PRIMARY KEY,
          TenDV VARCHAR2(50),
          MoTa VARCHAR2(100),
          DonGia NUMBER
      );
      SELECT * FROM DICHVU
      
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
      
      ALTER USER cn1_user quota UNLIMITED ON USERS;
     
      DELETE FROM TRANSACTION
      DELETE FROM CHINHANH
      DELETE FROM LAIXE
      DELETE FROM PHUONGTIEN
      DELETE FROM DICHVU
      DELETE FROM KHACHHANG_V1
      DELETE FROM KHACHHANG_V2
      DELETE FROM HOADON


      SELECT* FROM CHINHANH
      SELECT*FROM KHACHHANG_V2
      SELECT*FROM KHACHHANG_V1   
      SELECT*FROM PHUONGTIEN
      SELECT*FROM HOADON  
      SELECT* FROM CHINHANH
      SELECT*FROM LAIXE
      SELECT *FROM TRANSACTION
      SELECT* FROM DICHVU

      SELECT COUNT(*) AS SoLuong_GD_CN1
      FROM TRANSACTION
      WHERE ChiNhanhID = 'CN1';

      COMMIT;
         -- Tạo user và gán vai trò
SELECT username FROM dba_users WHERE username = 'GIAMDOC1';
SELECT role FROM dba_roles WHERE role = 'GIAMDOC';
COMMIT;

      CREATE USER giamdoc IDENTIFIED BY gd_password;

      GRANT CONNECT TO giamdoc
      
      CREATE USER truongcn1 IDENTIFIED BY tcn_password;
      GRANT CONNECT TO truongcn1
      
      CREATE USER nhanvien1 IDENTIFIED BY nv_password;
      GRANT CONNECT TO nhanvien1
      
      -- Tạo DB_LINK đến CN2 và CN3
          CREATE DATABASE LINK CN2_LINK
          CONNECT TO cn2_user IDENTIFIED BY password123
          USING '(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=26.188.246.23)(PORT=1521))(CONNECT_DATA=(SERVICE_NAME=orcl)))';
      
          CREATE DATABASE LINK CN3_LINK
          CONNECT TO cn3_user IDENTIFIED BY password123
          USING '(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=26.98.198.216)(PORT=1521))(CONNECT_DATA=(SERVICE_NAME=orcl21)))';

          SELECT * FROM dba_db_links;


            -- GIAMDOC
       
          CREATE PUBLIC DATABASE LINK CN2_LINK_GIAMDOC CONNECT TO giamdoc2 IDENTIFIED BY gd_password
          USING'(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=26.188.246.23)(PORT=1521))(CONNECT_DATA=(SERVICE_NAME=orcl)))';

          CREATE PUBLIC DATABASE LINK CN3_LINK_GIAMDOC CONNECT TO giamdoc3 IDENTIFIED BY gd_password
          USING'(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=26.98.198.216)(PORT=1521))(CONNECT_DATA=(SERVICE_NAME=orcl21)))';
            
            --TruongChiNhanh
          CREATE PUBLIC DATABASE LINK CN2_LINK_TCN CONNECT TO truongcn2 IDENTIFIED BY tcn_password
          USING'(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=26.188.246.23)(PORT=1521))(CONNECT_DATA=(SERVICE_NAME=orcl)))';

          CREATE PUBLIC DATABASE LINK CN3_LINK_TCN CONNECT TO truongcn3 IDENTIFIED BY tcn_password
          USING'(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=26.98.198.216)(PORT=1521))(CONNECT_DATA=(SERVICE_NAME=orcl21)))';

            --NhanVien
           CREATE PUBLIC DATABASE LINK CN2_LINK_NV CONNECT TO nhanvien2 IDENTIFIED BY nv_password
          USING'(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=26.188.246.23)(PORT=1521))(CONNECT_DATA=(SERVICE_NAME=orcl)))';

          CREATE PUBLIC DATABASE LINK CN3_LINK_NV CONNECT TO nhanvien3 IDENTIFIED BY nv_password
          USING'(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=26.98.198.216)(PORT=1521))(CONNECT_DATA=(SERVICE_NAME=orcl21)))';
      
      
       

      -- Phân quyền cho GiamDoc
      GRANT SELECT ON cn1_user.CHINHANH TO giamdoc1;
      GRANT SELECT ON cn1_user.LAIXE TO giamdoc1;
      GRANT SELECT ON cn1_user.PHUONGTIEN TO giamdoc1;
      GRANT SELECT ON cn1_user.DICHVU TO giamdoc1;
      GRANT SELECT ON cn1_user.KHACHHANG_V1 TO giamdoc1;
      GRANT SELECT ON cn1_user.KHACHHANG_V2 TO giamdoc1;
      GRANT SELECT ON cn1_user.HOADON TO giamdoc1;
      GRANT SELECT ON cn1_user.TRANSACTION TO giamdoc1;
      COMMIT;

      -- Phân quyền cho Truong Chi Nhanh
              GRANT SELECT, INSERT, UPDATE, DELETE ON cn1_user.CHINHANH TO truongcn1;
              -- Gán toàn quyền trên bảng LAIXE
              GRANT SELECT, INSERT, UPDATE, DELETE ON cn1_user.LAIXE TO truongcn1;
              -- Gán toàn quyền trên bảng PHUONGTIEN
              GRANT SELECT, INSERT, UPDATE, DELETE ON cn1_user.PHUONGTIEN TO truongcn1;
              -- Gán toàn quyền trên bảng DICHVU
              GRANT SELECT, INSERT, UPDATE, DELETE ON cn1_user.DICHVU TO truongcn1;
              
              -- Gán toàn quyền trên bảng KHACHHANG_V1
              GRANT SELECT, INSERT, UPDATE, DELETE ON cn1_user.KHACHHANG_V1 TO truongcn1;
              
              -- Gán toàn quyền trên bảng KHACHHANG_V2
              GRANT SELECT, INSERT, UPDATE, DELETE ON cn1_user.KHACHHANG_V2 TO truongcn1;
              
              -- Gán toàn quyền trên bảng HOADON
              GRANT SELECT, INSERT, UPDATE, DELETE ON cn1_user.HOADON TO truongcn1;
              
              -- Gán toàn quyền trên bảng TRANSACTION
              GRANT SELECT, INSERT, UPDATE, DELETE ON cn1_user.TRANSACTION TO truongcn1;

     -- GRANT SELECT, INSERT, UPDATE, DELETE ON cn2_user.CHINHANH TO nhanvien1;
        GRANT SELECT, INSERT, UPDATE, DELETE ON cn1_user.LAIXE TO nhanvien1;
        GRANT SELECT, INSERT, UPDATE, DELETE ON cn1_user.PHUONGTIEN TO nhanvien1;
        GRANT SELECT, INSERT, UPDATE, DELETE ON cn1_user.DICHVU TO nhanvien1;
        GRANT SELECT, INSERT, UPDATE, DELETE ON cn1_user.KHACHHANG_V1 TO nhanvien1;
        GRANT SELECT, INSERT, UPDATE, DELETE ON cn1_user.KHACHHANG_V2 TO nhanvien1;
        GRANT SELECT, INSERT, UPDATE, DELETE ON cn1_user.HOADON TO nhanvien1;
        GRANT SELECT, INSERT, UPDATE, DELETE ON cn1_user.TRANSACTION TO nhanvien1;


--Truy vấn 1: UNION - Lấy danh sách khách hàng từ CN1 và CN2
--Mô tả: Lấy danh sách tất cả khách hàng (MaKH, TenKH) từ bảng KHACHHANG_V1 tại CN1 và CN2, loại bỏ trùng lặp.
--User thực hiện: giamdoc1
--Truy vấn SQL:
  SELECT MaKH, HOTEN
  FROM cn1_user.KHACHHANG_V1
  UNION
  SELECT MaKH, HOTEN
  FROM cn2_user.KHACHHANG_V1@CN2_LINK_GIAMDOC;

--Truy vấn 2: INTERSECT - Tìm khách hàng có mặt tại cả CN1 và CN3
--Mô tả: Tìm các khách hàng (MaKH) có mặt trong bảng KHACHHANG_V1 tại cả CN1 và CN3.
--User thực hiện: truongcn1
Truy vấn SQL:
    SELECT MaKH
     FROM cn1_user.KHACHHANG_V1
     INTERSECT
     SELECT MaKH
     FROM cn3_user.KHACHHANG_V1@CN3_LINK_GIAMDOC;

--Truy vấn 3: MINUS - Tìm khách hàng có ở CN2 nhưng không có ở CN1
--Mô tả: Tìm các khách hàng (MaKH) có trong bảng KHACHHANG_V1 tại CN2 nhưng không có tại CN1.
--User thực hiện: giamdoc1
--Truy vấn SQL:
    SELECT MaKH
     FROM cn2_user.KHACHHANG_V1@CN2_LINK_GIAMDOC
     MINUS
     SELECT MaKH
     FROM cn1_user.KHACHHANG_V1;


--Truy vấn 4: DIVISION - Tìm khách hàng có hóa đơn tại tất cả chi nhánh
--Mô tả: Tìm các khách hàng (MaKH) có hóa đơn trong bảng HOADON tại cả 3 chi nhánh (CN1, CN2, CN3).
--User thực hiện: giamdoc1
--Truy vấn SQL:

       SELECT MaKH
       FROM cn1_user.HOADON WHERE ChiNhanhID = 'CN1'
       INTERSECT
       SELECT MaKH FROM cn2_user.HOADON@CN2_LINK_GIAMDOC WHERE ChiNhanhID = 'CN2'
       INTERSECT
       SELECT MaKH FROM cn3_user.HOADON@CN3_LINK_GIAMDOC WHERE ChiNhanhID = 'CN3';








     
      SELECT*FROM PHUONGTIEN@CN2_LINK_GIAMDOC
      SELECT*FROM LAIXE@CN3_LINK
      SELECT*FROM PHUONGTIEN
      SELECT*FROM LAIXE
      SELECT*FROM HOADON
      SELECT*FROM KHACHHANG_V1 WHERE MAKH='KH11'
      SELECT*FROM TRANSACTION
      INSERT INTO TRANSACTION VALUES ('GD1', 'HD1', SYSDATE, 2000, 500000, 'CN2');
      SELECT *FROM DICHVU d
      COMMIT;
  
  INSERT INTO KHACHHANG_V1 VALUES ('KH11', 'Trần Thị Mai', TO_DATE('1995-07-18', 'YYYY-MM-DD'), '0955678901', 'quận 2, TP.HCM');
  INSERT INTO KHACHHANG_V2 VALUES ('KH11', TO_DATE('2025-05-01', 'YYYY-MM-DD'), 1150000, 'CN1')
  INSERT INTO LAIXE VALUES ('LX15', 'Lương Văn Y', TO_DATE('1987-06-15', 'YYYY-MM-DD'), '0925678901', 'HN345', 'CN1');
  
INSERT INTO HOADON VALUES ('HD11', 'KH11', 'LX11', 'DV001', TO_DATE('2025-05-10', 'YYYY-MM-DD'), 500000, 'CN1');

INSERT INTO HOADON VALUES ('HDcn1011', 'KH11', 'LX11', 'DV001', TO_DATE('2025-05-10', 'YYYY-MM-DD'), 5000000, 'CN1');
INSERT INTO HOADON VALUES ('HDcn1022', 'KH11', 'LX11', 'DV001', TO_DATE('2025-05-10', 'YYYY-MM-DD'), 5000000, 'CN1');
INSERT INTO HOADON VALUES ('HDcn1033', 'KH11', 'LX11', 'DV001', TO_DATE('2025-05-10', 'YYYY-MM-DD'), 5000000, 'CN1');
INSERT INTO HOADON VALUES ('HDcn1044', 'KH11', 'LX11', 'DV001', TO_DATE('2025-05-10', 'YYYY-MM-DD'), 5000000, 'CN1');
INSERT INTO HOADON VALUES ('HDcn1045', 'KH11', 'LX11', 'DV001', TO_DATE('2025-05-10', 'YYYY-MM-DD'), 5000000, 'CN1');
INSERT INTO HOADON VALUES ('HDcn1047', 'KH11', 'LX11', 'DV001', TO_DATE('2025-05-10', 'YYYY-MM-DD'), 5000000, 'CN1');
INSERT INTO HOADON VALUES ('HDcn1048', 'KH11', 'LX11', 'DV001', TO_DATE('2025-05-10', 'YYYY-MM-DD'), 5000000, 'CN1');
INSERT INTO HOADON VALUES ('HDcn1049', 'KH11', 'LX11', 'DV001', TO_DATE('2025-05-10', 'YYYY-MM-DD'), 5000000, 'CN1');


/*Quản lý giao dịch của khách hàng bằng cách thêm (INSERT) hoặc xóa (DELETE) hóa đơn (HOADON) và cập 
nhật tổng chi tiêu (TongTien) trong bảng KHACHHANG_V2 tại các chi nhánh (CN1, CN2, CN3)
*/

-- Tạo Stored Procedure
CREATE OR REPLACE PROCEDURE manage_customer_transaction (
    p_makh IN VARCHAR2,
    p_mahd IN VARCHAR2,
    p_tongtien IN NUMBER,
    p_chinhanhid IN VARCHAR2,
    p_ngaylap IN DATE,
    p_malx IN VARCHAR2, -- Thêm tham số MALX
    p_madv IN VARCHAR2, -- Thêm tham số MADV
    p_action IN VARCHAR2 -- 'INSERT' để thêm, 'DELETE' để xóa
) AS
    v_tongtien NUMBER;
    v_chinhanh_dangky VARCHAR2(10);
BEGIN
    -- Xác định chi nhánh đăng ký của khách hàng (trong suốt vị trí)
    BEGIN
        SELECT ChiNhanhDangKy INTO v_chinhanh_dangky
        FROM KHACHHANG_V2
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
                    FROM KHACHHANG_V2@CN3_LINK
                    WHERE MaKH = p_makh;
            END;
    END;

    IF p_action = 'INSERT' THEN
        -- INSERT: Thêm hóa đơn tại chi nhánh được chỉ định, bao gồm MALX và MADV
        IF p_chinhanhid = 'CN1' THEN
            INSERT INTO HOADON (MaHD, MaKH, TongTien, ChiNhanhID, NgayLap, MALX, MADV)
            VALUES (p_mahd, p_makh, p_tongtien, p_chinhanhid, p_ngaylap, p_malx, p_madv);
        ELSIF p_chinhanhid = 'CN2' THEN
            INSERT INTO HOADON@CN2_LINK (MaHD, MaKH, TongTien, ChiNhanhID, NgayLap, MALX, MADV)
            VALUES (p_mahd, p_makh, p_tongtien, p_chinhanhid, p_ngaylap, p_malx, p_madv);
        ELSIF p_chinhanhid = 'CN3' THEN
            INSERT INTO HOADON@CN3_LINK (MaHD, MaKH, TongTien, ChiNhanhID, NgayLap, MALX, MADV)
            VALUES (p_mahd, p_makh, p_tongtien, p_chinhanhid, p_ngaylap, p_malx, p_madv);
        END IF;

        -- UPDATE: Tăng TongTien trong KHACHHANG_V2
        IF v_chinhanh_dangky = 'CN1' THEN
            SELECT TongTien INTO v_tongtien
            FROM KHACHHANG_V2
            WHERE MaKH = p_makh;

            UPDATE KHACHHANG_V2
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
            FROM KHACHHANG_V2@CN3_LINK
            WHERE MaKH = p_makh;

            UPDATE KHACHHANG_V2@CN3_LINK
            SET TongTien = v_tongtien + p_tongtien
            WHERE MaKH = p_makh;
        END IF;

    ELSIF p_action = 'DELETE' THEN
        -- DELETE: Xóa giao dịch và hóa đơn
        IF p_chinhanhid = 'CN1' THEN
            DELETE FROM TRANSACTION
            WHERE MaHD = p_mahd;
            DELETE FROM HOADON
            WHERE MaHD = p_mahd;
        ELSIF p_chinhanhid = 'CN2' THEN
            DELETE FROM TRANSACTION@CN2_LINK
            WHERE MaHD = p_mahd;
            DELETE FROM HOADON@CN2_LINK
            WHERE MaHD = p_mahd;
        ELSIF p_chinhanhid = 'CN3' THEN
            DELETE FROM TRANSACTION@CN3_LINK
            WHERE MaHD = p_mahd;
            DELETE FROM HOADON@CN3_LINK
            WHERE MaHD = p_mahd;
        END IF;

        -- UPDATE: Giảm TongTien trong KHACHHANG_V2
        IF v_chinhanh_dangky = 'CN1' THEN
            SELECT TongTien INTO v_tongtien
            FROM KHACHHANG_V2
            WHERE MaKH = p_makh;

            UPDATE KHACHHANG_V2
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
COMMIT;


SELECT*FROM DICHVU

BEGIN
         manage_customer_transaction(
        p_makh => 'CN2KH080',
        p_mahd => 'HDcn211112',
        p_tongtien => 1000000,
        p_chinhanhid => 'CN2',
        p_ngaylap => TO_DATE('2025-05-29 00:43:00', 'YYYY-MM-DD HH24:MI:SS'),
        p_malx => 'LX11', 
        p_madv => 'DV001', 
        p_action => 'INSERT'
    );
END;
/

BEGIN
    manage_customer_transaction(
        p_makh        => 'CN2KH080',
        p_mahd        => 'HDcn211112',
        p_tongtien    => 1000000, -- cập nhật tổng tiền mới
        p_chinhanhid  => 'CN2',
        p_ngaylap     => TO_DATE('2025-05-29 00:28:00', 'YYYY-MM-DD HH24:MI:SS'),
        p_malx => 'LX11', 
        p_madv => 'DV001', 
        p_action      => 'DELETE'
    );
END;
/



-- Kiểm tra TongTien tại CN3
SELECT TongTien FROM KHACHHANG_V2@CN3_LINK WHERE MaKH = 'CN3KH001';

-- Kiểm tra TongTien tại CN2
COMMIT;

SELECT TongTien FROM KHACHHANG_V2@CN2_LINK WHERE MaKH = 'CN2KH080';













SELECT get_total_spending_by_customer('KH11') AS TotalSpending
FROM DUAL;
 

--Trigger
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
        FROM HOADON@CN2_LINK
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


COMMIT;

SELECT hd.NgayLap,kv.MAKH,hd.MAHD  FROM HOADON hd, KHACHHANG_V1 kv 
WHERE hd.MAKH=kv.MAKH AND kv.MAKH='KH11' AND hd.NGAYLAP= TO_DATE('2025-05-10', 'YYYY-MM-DD')
UNION
SELECT hd2.NgayLap,kv2.MAKH,hd2.MAHD  FROM HOADON@CN2_LINK hd2, KHACHHANG_V1@CN2_LINK kv2 
WHERE hd2.MAKH=kv2.MAKH AND kv2.MAKH='KH11'AND hd2.NGAYLAP=TO_DATE('2025-05-10', 'YYYY-MM-DD')
UNION
SELECT hd3.NgayLap,kv3.MAKH,hd3.MAHD  FROM HOADON@CN3_LINK hd3, KHACHHANG_V1@CN3_LINK kv3 
WHERE hd3.MAKH=kv3.MAKH AND kv3.MAKH='KH11'AND hd3.NGAYLAP=TO_DATE('2025-05-10', 'YYYY-MM-DD')

INSERT INTO HOADON VALUES ('HDcn1049', 'KH11', 'LX11', 'DV001', TO_DATE('2025-05-10', 'YYYY-MM-DD'), 5000000, 'CN1');
COMMIT;
DELETE FROM HOADON WHERE MAHD='HDcn1022';
DELETE FROM HOADON WHERE MAHD='HDcn1011';
DELETE FROM HOADON WHERE MAHD='HDcn1044';

CREATE OR REPLACE FUNCTION get_total_spending_by_customer (
    p_makh IN VARCHAR2
) RETURN NUMBER AS
    v_total_spending NUMBER := 0;
    v_spending NUMBER;
BEGIN
    -- Tính tổng TongTien tại CN1
    BEGIN
        SELECT NVL(SUM(TongTien), 0) INTO v_spending
        FROM HOADON
        WHERE MaKH = p_makh;
        v_total_spending := v_total_spending + v_spending;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_total_spending := v_total_spending + 0;
    END;

    -- Tính tổng TongTien tại CN2 qua DB_LINK
    BEGIN
        SELECT NVL(SUM(TongTien), 0) INTO v_spending
        FROM HOADON@CN2_LINK
        WHERE MaKH = p_makh;
        v_total_spending := v_total_spending + v_spending;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_total_spending := v_total_spending + 0;
    END;

    -- Tính tổng TongTien tại CN3 qua DB_LINK
    BEGIN
        SELECT NVL(SUM(TongTien), 0) INTO v_spending
        FROM HOADON@CN3_LINK
        WHERE MaKH = p_makh;
        v_total_spending := v_total_spending + v_spending;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_total_spending := v_total_spending + 0;
    END;

    RETURN v_total_spending;
EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20004, 'Error calculating total spending: ' || SQLERRM);
        RETURN NULL;
END;
/

SELECT NVL(SUM(TongTien), 0) 
FROM HOADON
WHERE MaKH = 'KH11';

SELECT NVL(SUM(TongTien), 0) 
FROM HOADON@CN2_LINK
WHERE MaKH = 'KH11';

SELECT NVL(SUM(TongTien), 0) 
FROM HOADON@CN3_LINK
WHERE MaKH = 'KH11';

SELECT get_total_spending_by_customer('KH11') AS TotalSpending
FROM DUAL;

--
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
SELECT * FROM DICHVU WHERE MADV='DV001' ;
BEGIN
    CapNhatOrChenDichVu(
        p_MaDV   => 'DV001',
        p_TenDV  => 'Dịch vụ rửa xe',
        p_MoTa   => 'Rửa xe 4 chỗ cao cấp',
        p_DonGia => 120000
    );
END;
/


SELECT *FROM TRANSACTION WHERE MAGIAODICH ='GD1000162'
SELECT *FROM DICHVU
SELECT *FROM HOADON,KHACHHANG
SELECT* FROM KHACHHANG_V1 WHERE MAKH='CN1KH130'
--CN1KH130

EXPLAIN PLAN FOR
SELECT 
    T.MaGiaoDich, 
    KH_V1.HoTen AS HoTenKhachHang, 
    LX.HoTen AS HoTenLaiXe, 
    T.SoKm
FROM 
    CHINHANH CN, 
    LAIXE LX, 
    KHACHHANG_V1 KH_V1, 
    HOADON HD, 
    TRANSACTION T, 
    DICHVU DV
WHERE 
    CN.ChiNhanhID = LX.ChiNhanhID
    AND CN.ChiNhanhID = HD.ChiNhanhID
    AND CN.ChiNhanhID = T.ChiNhanhID
    AND HD.MaKH = KH_V1.MaKH
    AND HD.MaLX = LX.MaLX
    AND HD.MaDV = DV.MaDV
    AND T.MaHD = HD.MaHD
    AND CN.TenCN = 'Cần Thơ'
    AND DV.TenDV = 'Thuê xe 4 chỗ tự lái'
    AND KH_V1.SoDT = '0913046175'
    AND T.NgayGiaoDich = TO_DATE('02/02/2025 00:00:00', 'DD/MM/YYYY HH24:MI:SS');

    SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);


EXPLAIN PLAN FOR
SELECT T.MaGiaoDich, KH_V1.HoTen AS TenKhachHang, LX.HoTen AS TenLaiXe, T.SoKm
FROM ChiNhanh CN
JOIN LaiXe LX ON CN.ChiNhanhID = LX.ChiNhanhID
JOIN HoaDon HD ON CN.ChiNhanhID = HD.ChiNhanhID AND HD.MaLX = LX.MaLX
JOIN Transaction T ON HD.MaHD = T.MaHD AND T.NgayGiaoDich = TO_DATE('02/02/2025 00:00:00', 'DD/MM/YYYY HH24:MI:SS')
JOIN KhachHang_V1 KH_V1 ON HD.MaKH = KH_V1.MaKH AND KH_V1.SoDT = '0913046175'
JOIN DICHVU DV ON HD.MaDV = DV.MaDV AND DV.TenDV = 'Thuê xe 4 chỗ tự lái'
WHERE CN.TenCN = 'Cần Thơ';

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

