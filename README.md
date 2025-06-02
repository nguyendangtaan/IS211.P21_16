# IS211.P21_16

## Hệ quản trị cơ sở dữ liệu phân tán CockroachDB - BTL2

Dự án này triển khai một hệ thống quản lý cơ sở dữ liệu phân tán để quản lý thông tin sinh viên đại học trên nhiều trường đại học. Hệ thống thể hiện các khái niệm về cơ sở dữ liệu phân tán bao gồm phân mảnh ngang và dọc, cơ chế sao chép và các thao tác CRUD.

## Cấu Trúc Dự Án

```
BTL2/
├── Connection/           # Quản lý kết nối cơ sở dữ liệu
├── CRUDoperations/      # Các thao tác Create, Read, Update, Delete
├── ReplicationMechanism/# Triển khai sao chép cơ sở dữ liệu
├── RetrieveQueries/     # Triển khai các truy vấn phức tạp
├── create_tables_insert_data.sql  # Cấu trúc và dữ liệu mẫu
└── requirements.txt     # Các gói Python cần thiết
```

## Cấu Trúc Cơ Sở Dữ Liệu

Hệ thống sử dụng cơ sở dữ liệu phân tán với các bảng chính sau:

1. **UNIVERSITY** (Phân Mảnh Ngang)
   - Lưu trữ thông tin về các trường đại học (UIT, BKU)
   - Các trường chính: university_id, name, location, code

2. **DEPARTMENT** (Phân Mảnh Ngang)
   - Lưu trữ thông tin về các khoa của mỗi trường
   - Các trường chính: department_id, university_id, name, code

3. **STUDENT_PROFILE** (Phân Mảnh Dọc)
   - Thông tin cơ bản của sinh viên
   - Các trường chính: student_id, first_name, last_name, email, birth_date, gender

4. **STUDENT_ACADEMIC** (Phân Mảnh Dọc)
   - Thông tin học tập của sinh viên
   - Các trường chính: student_id, university_id, department_id, student_code, gpa

5. **COURSE** (Phân Mảnh Ngang)
   - Thông tin về các môn học
   - Các trường chính: course_id, university_id, department_id, code, name, credits

6. **ENROLLMENT** (Phân Mảnh Ngang)
   - Thông tin đăng ký môn học của sinh viên
   - Các trường chính: enrollment_id, student_id, course_id, semester, grade

## Tính Năng

- **Quản Lý Cơ Sở Dữ Liệu Phân Tán**
  - Phân mảnh ngang cho dữ liệu theo trường
  - Phân mảnh dọc cho thông tin sinh viên

- **Các Thao Tác CRUD**
  - Thao tác tạo, đọc, cập nhật và xóa cho tất cả các đối tượng
  - Quản lý giao dịch
  - Duy trì tính nhất quán dữ liệu

- **Các Thao Tác Truy Vấn**
  - Truy vấn phức tạp trên các bảng phân tán
  - Thao tác join giữa các phân mảnh
  - Truy vấn tổng hợp và phân tích

## Yêu Cầu Hệ Thống

- Python 3.8+
- PostgreSQL 12+
- Các gói Python cần thiết (xem requirements.txt):
  - psycopg2-binary==2.9.9
  - pandas==2.1.4
  - tabulate==0.9.0

## Hướng Dẫn Cài Đặt

1. Clone repository
2. Cài đặt các gói phụ thuộc:
   ```bash
   pip install -r requirements.txt
   ```
3. Thiết lập cụm cơ sở dữ liệu CockroachDB cho mỗi máy.
4. Chạy script SQL trong SQL SHELL của CockroachDB để tạo bảng và chèn dữ liệu mẫu trong create_tables_insert_data.sql.
5. Chạy các file để minh họa các chức năng.

## Cách Sử Dụng

1. Cấu hình kết nối cơ sở dữ liệu giữa 2 máy thực trong module Connection
2. Chạy các thao tác mong muốn từ các module tương ứng:
   - Các thao tác CRUD
   - Các thao tác sao chép
   - Các thao tác truy vấn
   - Các thao tác minh họa cơ chế sao chép

## Chi Tiết Cấu Trúc Dự Án

### Module Connection
- Quản lý kết nối cơ sở dữ liệu
- Xử lý connection pooling
- Triển khai cơ chế failover

### Module CRUD Operations
- Triển khai các thao tác CRUD cơ bản
- Xử lý giao dịch phân tán
- Duy trì tính nhất quán dữ liệu

### Module Replication Mechanism
- Triển khai chiến lược sao chép dữ liệu
- Xử lý đồng bộ hóa giữa các node
- Quản lý xung đột sao chép

### Module Retrieve Queries
- Triển khai các truy vấn phức tạp
- Xử lý join phân tán
- Thực hiện tổng hợp dữ liệu

## Đóng Góp

1. Fork repository
2. Tạo nhánh tính năng mới
3. Commit các thay đổi
4. Push lên nhánh
5. Tạo Pull Request

## Giấy Phép

Dự án này được cấp phép theo MIT License - xem file LICENSE để biết thêm chi tiết. 
