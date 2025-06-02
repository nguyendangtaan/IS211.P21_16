-- Bảng UNIVERSITY: Thông tin về trường đại học (PHÂN MẢNH NGANG)
CREATE TABLE IF NOT EXISTS UNIVERSITY (
    university_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    location VARCHAR(255),
    code VARCHAR(20) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT now()
);

-- Bảng DEPARTMENT: Khoa thuộc trường đại học (PHÂN MẢNH NGANG)
CREATE TABLE IF NOT EXISTS DEPARTMENT (
    department_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    university_id UUID NOT NULL,
    name VARCHAR(255) NOT NULL,
    code VARCHAR(20) NOT NULL,
    created_at TIMESTAMP DEFAULT now(),
    UNIQUE (university_id, code),
    FOREIGN KEY (university_id) REFERENCES UNIVERSITY(university_id) ON DELETE CASCADE
);

-- Bảng STUDENT_PROFILE: Thông tin cơ bản của sinh viên (PHÂN MẢNH DỌC)
CREATE TABLE IF NOT EXISTS STUDENT_PROFILE (
    student_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    birth_date DATE,
    gender VARCHAR(10),
    created_at TIMESTAMP DEFAULT now()
);

-- Bảng STUDENT_ACADEMIC: Thông tin học tập của sinh viên (PHÂN MẢNH DỌC)
CREATE TABLE IF NOT EXISTS STUDENT_ACADEMIC (
    student_id UUID PRIMARY KEY,
    university_id UUID NOT NULL,
    department_id UUID NOT NULL,
    student_code VARCHAR(20) NOT NULL,
    enrollment_year INT,
    current_semester INT,
    gpa DECIMAL(3,2),
    created_at TIMESTAMP DEFAULT now(),
    UNIQUE (university_id, student_code),
    FOREIGN KEY (student_id) REFERENCES STUDENT_PROFILE(student_id) ON DELETE CASCADE,
    FOREIGN KEY (university_id) REFERENCES UNIVERSITY(university_id) ON DELETE CASCADE,
    FOREIGN KEY (department_id) REFERENCES DEPARTMENT(department_id) ON DELETE CASCADE
);

-- Bảng COURSE: Môn học (PHÂN MẢNH NGANG)
CREATE TABLE IF NOT EXISTS COURSE (
    course_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    university_id UUID NOT NULL,
    department_id UUID NOT NULL,
    code VARCHAR(20) NOT NULL,
    name VARCHAR(255) NOT NULL,
    credits INT NOT NULL,
    created_at TIMESTAMP DEFAULT now(),
    UNIQUE (university_id, code),
    FOREIGN KEY (university_id) REFERENCES UNIVERSITY(university_id) ON DELETE CASCADE,
    FOREIGN KEY (department_id) REFERENCES DEPARTMENT(department_id) ON DELETE CASCADE
);

-- Bảng ENROLLMENT: Đăng ký môn học (PHÂN MẢNH NGANG)
CREATE TABLE IF NOT EXISTS ENROLLMENT (
    enrollment_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    student_id UUID NOT NULL,
    course_id UUID NOT NULL,
    semester VARCHAR(20) NOT NULL,
    enrollment_date TIMESTAMP DEFAULT now(),
    grade DECIMAL(4,2),
    status VARCHAR(20) DEFAULT 'active',
    created_at TIMESTAMP DEFAULT now(),
    FOREIGN KEY (student_id) REFERENCES STUDENT_PROFILE(student_id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES COURSE(course_id) ON DELETE CASCADE
);

-------------------------------------------------------------------------------------------------

-- Dữ liệu mẫu cho UIT (Máy Thịnh)
INSERT INTO UNIVERSITY (name, location, code) VALUES 
('University of Information Technology', 'Ho Chi Minh City', 'UIT');

INSERT INTO DEPARTMENT (university_id, name, code) VALUES 
((SELECT university_id FROM UNIVERSITY WHERE code = 'UIT'), 'Computer Science', 'CS'),
((SELECT university_id FROM UNIVERSITY WHERE code = 'UIT'), 'Information Systems', 'IS'),
((SELECT university_id FROM UNIVERSITY WHERE code = 'UIT'), 'Software Engineering', 'SE');

-- Dữ liệu mẫu sinh viên UIT
-- 1. Thêm 9 sinh viên vào STUDENT_PROFILE
INSERT INTO STUDENT_PROFILE (first_name, last_name, email, birth_date, gender) VALUES
('Nguyen', 'Thanh Lam', 'lamnt@uit.edu.vn', '2000-01-10', 'Male'),
('Tran', 'Ngoc Mai', 'maitn@uit.edu.vn', '2000-02-20', 'Female'),
('Le', 'Quoc Hung', 'hunql@uit.edu.vn', '2000-03-15', 'Male'),
('Pham', 'Thu Ha', 'hatp@uit.edu.vn', '2000-04-25', 'Female'),
('Vo', 'Minh Tri', 'trivm@uit.edu.vn', '2000-05-05', 'Male'),
('Hoang', 'Bao Chau', 'chauhb@uit.edu.vn', '2000-06-30', 'Female'),
('Do', 'Viet Khoa', 'khoadv@uit.edu.vn', '2000-07-12', 'Male'),
('Dang', 'Ngoc Anh', 'anhdn@uit.edu.vn', '2000-08-08', 'Female'),
('Nguyen', 'Hoang Nam', 'namnh@uit.edu.vn', '2000-09-09', 'Male');

-- 2. Thêm 3 sinh viên vào khoa CS
INSERT INTO STUDENT_ACADEMIC (
    student_id, university_id, department_id, student_code, enrollment_year, current_semester, gpa
)
SELECT 
    sp.student_id,
    u.university_id,
    d.department_id,
    'UITCS' || LPAD(ROW_NUMBER() OVER ()::text, 4, '0'),
    2020,
    8,
    ROUND(2.5 + random() * 1.5, 2)
FROM STUDENT_PROFILE sp
CROSS JOIN UNIVERSITY u
CROSS JOIN DEPARTMENT d
WHERE u.code = 'UIT' AND d.code = 'CS'
  AND sp.email IN ('lamnt@uit.edu.vn', 'maitn@uit.edu.vn', 'hunql@uit.edu.vn');

-- 3. Thêm 3 sinh viên vào khoa IS
INSERT INTO STUDENT_ACADEMIC (
    student_id, university_id, department_id, student_code, enrollment_year, current_semester, gpa
)
SELECT 
    sp.student_id,
    u.university_id,
    d.department_id,
    'UITIS' || LPAD(ROW_NUMBER() OVER ()::text, 4, '0'),
    2020,
    8,
    ROUND(2.5 + random() * 1.5, 2)
FROM STUDENT_PROFILE sp
CROSS JOIN UNIVERSITY u
CROSS JOIN DEPARTMENT d
WHERE u.code = 'UIT' AND d.code = 'IS'
  AND sp.email IN ('hatp@uit.edu.vn', 'trivm@uit.edu.vn', 'chauhb@uit.edu.vn');

-- 4. Thêm 3 sinh viên vào khoa SE
INSERT INTO STUDENT_ACADEMIC (
    student_id, university_id, department_id, student_code, enrollment_year, current_semester, gpa
)
SELECT 
    sp.student_id,
    u.university_id,
    d.department_id,
    'UITSE' || LPAD(ROW_NUMBER() OVER ()::text, 4, '0'),
    2020,
    8,
    ROUND(2.5 + random() * 1.5, 2)
FROM STUDENT_PROFILE sp
CROSS JOIN UNIVERSITY u
CROSS JOIN DEPARTMENT d
WHERE u.code = 'UIT' AND d.code = 'SE'
  AND sp.email IN ('khoadv@uit.edu.vn', 'anhdn@uit.edu.vn', 'namnh@uit.edu.vn');

-- Dữ liệu mẫu môn học UIT
INSERT INTO COURSE (university_id, department_id, code, name, credits)
SELECT u.university_id, d.department_id,
       d.code || 'C' || LPAD(i::text, 2, '0'),
       d.name || ' Course ' || i,
       3
FROM UNIVERSITY u
JOIN DEPARTMENT d ON u.university_id = d.university_id
CROSS JOIN generate_series(1, 3) AS i
WHERE u.code = 'UIT';

-- Dữ liệu mẫu đăng ký học phần UIT
WITH uit_students AS (
    SELECT sa.student_id, sa.department_id
    FROM STUDENT_ACADEMIC sa
    JOIN UNIVERSITY u ON sa.university_id = u.university_id
    WHERE u.code = 'UIT'
),
uit_courses AS (
    SELECT course_id, department_id,
           ROW_NUMBER() OVER (PARTITION BY department_id ORDER BY code) AS rn
    FROM COURSE
    WHERE university_id = (SELECT university_id FROM UNIVERSITY WHERE code = 'UIT')
),
selected_uit_courses AS (
    SELECT course_id, department_id
    FROM uit_courses
    WHERE rn <= 2
)
INSERT INTO ENROLLMENT (student_id, course_id, semester, grade)
SELECT s.student_id, c.course_id, 'Spring 2024', ROUND(6 + random() * 4, 2)
FROM uit_students s
JOIN selected_uit_courses c ON s.department_id = c.department_id;

--------------------------------------------------------------------------------------------
-- Dữ liệu mẫu cho BKU (Máy Tân)
INSERT INTO UNIVERSITY (name, location, code) VALUES 
('Bach Khoa University', 'Ho Chi Minh City', 'BKU');

INSERT INTO DEPARTMENT (university_id, name, code) VALUES 
((SELECT university_id FROM UNIVERSITY WHERE code = 'BKU'), 'Computer Engineering', 'CE'),
((SELECT university_id FROM UNIVERSITY WHERE code = 'BKU'), 'Mechanical Engineering', 'ME'),
((SELECT university_id FROM UNIVERSITY WHERE code = 'BKU'), 'Industrial Management', 'IM');

-- Dữ liệu mẫu sinh viên BKU
-- 1. Thêm 9 sinh viên vào STUDENT_PROFILE
INSERT INTO STUDENT_PROFILE (first_name, last_name, email, birth_date, gender) VALUES
('Nguyen', 'Van Hieu', 'hieunv@bku.edu.vn', '2000-01-12', 'Male'),
('Tran', 'Thi Kim Ngan', 'ngantt@bku.edu.vn', '2000-02-20', 'Female'),
('Le', 'Quang Minh', 'minhlq@bku.edu.vn', '2000-03-18', 'Male'),
('Pham', 'Ngoc Bich', 'bichpn@bku.edu.vn', '2000-04-25', 'Female'),
('Do', 'Thanh Tung', 'tungdt@bku.edu.vn', '2000-05-10', 'Male'),
('Hoang', 'Thu Trang', 'tranght@bku.edu.vn', '2000-06-08', 'Female'),
('Dang', 'Viet Hoang', 'hoangdv@bku.edu.vn', '2000-07-07', 'Male'),
('Vo', 'Thi Anh', 'anhvt@bku.edu.vn', '2000-08-15', 'Female'),
('Nguyen', 'Quoc Bao', 'baonq@bku.edu.vn', '2000-09-09', 'Male');

-- 2. Thêm 3 sinh viên vào khoa CE
INSERT INTO STUDENT_ACADEMIC (
    student_id, university_id, department_id, student_code, enrollment_year, current_semester, gpa
)
SELECT 
    sp.student_id,
    u.university_id,
    d.department_id,
    'BKUCE' || LPAD(ROW_NUMBER() OVER ()::text, 4, '0'),
    2020,
    8,
    ROUND(2.5 + random() * 1.5, 2)
FROM STUDENT_PROFILE sp
CROSS JOIN UNIVERSITY u
CROSS JOIN DEPARTMENT d
WHERE u.code = 'BKU' AND d.code = 'CE'
  AND sp.email IN ('hieunv@bku.edu.vn', 'ngantt@bku.edu.vn', 'minhlq@bku.edu.vn');

-- 3. Thêm 3 sinh viên vào khoa ME
INSERT INTO STUDENT_ACADEMIC (
    student_id, university_id, department_id, student_code, enrollment_year, current_semester, gpa
)
SELECT 
    sp.student_id,
    u.university_id,
    d.department_id,
    'BKUME' || LPAD(ROW_NUMBER() OVER ()::text, 4, '0'),
    2020,
    8,
    ROUND(2.5 + random() * 1.5, 2)
FROM STUDENT_PROFILE sp
CROSS JOIN UNIVERSITY u
CROSS JOIN DEPARTMENT d
WHERE u.code = 'BKU' AND d.code = 'ME'
  AND sp.email IN ('bichpn@bku.edu.vn', 'tungdt@bku.edu.vn', 'tranght@bku.edu.vn');

-- 4. Thêm 3 sinh viên vào khoa IM
INSERT INTO STUDENT_ACADEMIC (
    student_id, university_id, department_id, student_code, enrollment_year, current_semester, gpa
)
SELECT 
    sp.student_id,
    u.university_id,
    d.department_id,
    'BKUIM' || LPAD(ROW_NUMBER() OVER ()::text, 4, '0'),
    2020,
    8,
    ROUND(2.5 + random() * 1.5, 2)
FROM STUDENT_PROFILE sp
CROSS JOIN UNIVERSITY u
CROSS JOIN DEPARTMENT d
WHERE u.code = 'BKU' AND d.code = 'IM'
  AND sp.email IN ('hoangdv@bku.edu.vn', 'anhvt@bku.edu.vn', 'baonq@bku.edu.vn');

-- Dữ liệu mẫu môn học BKU
INSERT INTO COURSE (university_id, department_id, code, name, credits)
SELECT u.university_id, d.department_id,
       d.code || 'C' || LPAD(i::text, 2, '0'),
       d.name || ' Course ' || i,
       3
FROM UNIVERSITY u
JOIN DEPARTMENT d ON u.university_id = d.university_id
CROSS JOIN generate_series(1, 3) AS i
WHERE u.code = 'BKU';

-- Dữ liệu mẫu cho đăng ký học phần BKU
WITH bku_students AS (
    SELECT sa.student_id, sa.department_id
    FROM STUDENT_ACADEMIC sa
    JOIN UNIVERSITY u ON sa.university_id = u.university_id
    WHERE u.code = 'BKU'
),
bku_courses AS (
    SELECT course_id, department_id,
           ROW_NUMBER() OVER (PARTITION BY department_id ORDER BY code) AS rn
    FROM COURSE
    WHERE university_id = (SELECT university_id FROM UNIVERSITY WHERE code = 'BKU')
),
selected_bku_courses AS (
    SELECT course_id, department_id
    FROM bku_courses
    WHERE rn <= 2
)
INSERT INTO ENROLLMENT (student_id, course_id, semester, grade)
SELECT s.student_id, c.course_id, 'Spring 2024', ROUND(6 + random() * 4, 2)
FROM bku_students s
JOIN selected_bku_courses c ON s.department_id = c.department_id;
