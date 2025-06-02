"""
Tác giả: Lâm Tuấn Thịnh - 22521408 - Nhóm 16 - BTL2 CSDLPT
"""

import pandas as pd
from connect_retrieve import test_connection, get_wsl_ip

# Kết nối tới 2 cơ sở dữ liệu phân mảnh ngang
wsl_ip = get_wsl_ip()

connections = {
    "UIT": test_connection(wsl_ip, 26257, "db1", "UIT"),
    "BKU": test_connection("26.94.39.56", 26257, "db2", "BKU")
}

# ------------------ TRUY VẤN PHÂN MẢNH NGANG ------------------
queries_horizontal = {
    "Sinh viên UIT": """
        SELECT 
            sp.first_name, sp.last_name, sp.email, sp.gender, sp.birth_date,
            d.name as department
        FROM STUDENT_PROFILE sp
        JOIN STUDENT_ACADEMIC sa ON sp.student_id = sa.student_id
        JOIN UNIVERSITY u ON sa.university_id = u.university_id
        JOIN DEPARTMENT d ON sa.department_id = d.department_id
        WHERE u.code = 'UIT'
        ORDER BY sp.last_name, sp.first_name;
    """,
    "Môn học BKU": """
        SELECT 
            c.name as course_name, c.credits,
            d.name as department
        FROM COURSE c
        JOIN UNIVERSITY u ON c.university_id = u.university_id
        JOIN DEPARTMENT d ON c.department_id = d.department_id
        WHERE u.code = 'BKU'
        ORDER BY d.name, c.name;
    """,
    "Khoa của mỗi trường": """
        SELECT 
            d.name as department_name,
            u.name as university,
            COUNT(sa.student_id) as student_count
        FROM DEPARTMENT d
        JOIN UNIVERSITY u ON d.university_id = u.university_id
        LEFT JOIN STUDENT_ACADEMIC sa ON d.department_id = sa.department_id
        GROUP BY d.name, u.name
        ORDER BY u.name, d.name;
    """
}

# ------------------ TRUY VẤN PHÂN MẢNH DỌC ------------------
queries_vertical = {
    "Gộp thông tin cá nhân + học tập": """
        SELECT 
            sp.first_name, sp.last_name, sp.gender, sp.email,
            sa.student_code, sa.gpa, sa.enrollment_year,
            d.name as department
        FROM STUDENT_PROFILE sp
        JOIN STUDENT_ACADEMIC sa ON sp.student_id = sa.student_id
        JOIN DEPARTMENT d ON sa.department_id = d.department_id
        ORDER BY sa.gpa DESC, sp.last_name;
    """,
    "Thông tin học tập ngành CS": """
        SELECT 
            sp.first_name || ' ' || sp.last_name AS student_name,
            sa.student_code,
            sa.enrollment_year,
            c.name as current_course,
            e.grade
        FROM STUDENT_ACADEMIC sa
        JOIN STUDENT_PROFILE sp ON sa.student_id = sp.student_id
        JOIN DEPARTMENT d ON sa.department_id = d.department_id
        JOIN ENROLLMENT e ON e.student_id = sa.student_id
        JOIN COURSE c ON e.course_id = c.course_id
        WHERE d.code = 'CS'
        ORDER BY sa.gpa DESC;
    """,
    "Thông tin cá nhân GPA > 3.5": """
        SELECT 
            sp.first_name, sp.last_name, sp.email, sp.gender,
            sa.gpa, sa.enrollment_year,
            d.name as department
        FROM STUDENT_PROFILE sp
        JOIN STUDENT_ACADEMIC sa ON sp.student_id = sa.student_id
        JOIN DEPARTMENT d ON sa.department_id = d.department_id
        WHERE sa.gpa > 3.5
        ORDER BY sa.gpa DESC, sp.last_name;
    """
}

# ------------------ TRUY VẤN HỖN HỢP ------------------
query_mixed = """
    SELECT 
        sp.first_name, sp.last_name, sp.email, sp.gender,
        sa.gpa, d.name as department,
        u.name as university
    FROM student_profile sp
    JOIN student_academic sa ON sp.student_id = sa.student_id
    JOIN department d ON sa.department_id = d.department_id
    JOIN university u ON sa.university_id = u.university_id
    WHERE sp.gender = 'Female'
    ORDER BY u.name, sa.gpa DESC;
"""

def format_dataframe(df):
    """Format DataFrame để hiển thị đẹp hơn"""
    if df.empty:
        return "(Không có dữ liệu)"
    
    # Đổi tên cột để hiển thị đẹp hơn
    column_names = {
        'first_name': 'Tên',
        'last_name': 'Họ',
        'email': 'Email',
        'gender': 'Giới tính',
        'birth_date': 'Ngày sinh',
        'department': 'Khoa',
        'department_name': 'Tên khoa',
        'university': 'Trường',
        'student_code': 'Mã sinh viên',
        'gpa': 'GPA',
        'enrollment_year': 'Năm nhập học',
        'course_name': 'Tên môn học',
        'credits': 'Số tín chỉ',
        'student_count': 'Số sinh viên',
        'current_course': 'Môn học hiện tại'
    }
    
    df = df.rename(columns=column_names)
    
    # Format các cột số
    if 'GPA' in df.columns:
        df['GPA'] = df['GPA'].round(2)
    if 'Số sinh viên' in df.columns:
        df['Số sinh viên'] = df['Số sinh viên'].astype(int)
    
    return df.to_string(index=False)

# Hàm thực thi và in kết quả truy vấn
def execute_query(label, sql, conn):
    print(f"\n🔍 {label}")
    print("-" * 80)
    try:
        df = pd.read_sql_query(sql, conn)
        print(format_dataframe(df))
    except Exception as e:
        print(f"❌ Lỗi: {e}")

if __name__ == '__main__':
    for name, conn in connections.items():
        if conn:
            print(f"\n{'='*20} 🔹 {name} {'='*20}")

            print("\n📁 PHÂN MẢNH NGANG")
            if name == "UIT":
                execute_query("Danh sách sinh viên UIT", queries_horizontal["Sinh viên UIT"], conn)
            elif name == "BKU":
                execute_query("Danh sách môn học BKU", queries_horizontal["Môn học BKU"], conn)

            execute_query("Thống kê khoa theo trường", queries_horizontal["Khoa của mỗi trường"], conn)

            print("\n📂 PHÂN MẢNH DỌC")
            if name == "UIT":
                execute_query("Thông tin sinh viên (hồ sơ + học tập)", 
                            queries_vertical["Gộp thông tin cá nhân + học tập"], conn)
                execute_query("Sinh viên ngành Công nghệ thông tin", 
                            queries_vertical["Thông tin học tập ngành CS"], conn)
            elif name == "BKU":
                execute_query("Sinh viên xuất sắc (GPA > 3.5)", 
                            queries_vertical["Thông tin cá nhân GPA > 3.5"], conn)

    # Truy vấn hỗn hợp: sinh viên nữ từ cả hai cơ sở dữ liệu
    print(f"\n{'='*20} 🔀 Sinh viên nữ từ cả hai trường {'='*20}")
    for name, conn in connections.items():
        if conn:
            execute_query(f"Sinh viên nữ tại {name}", query_mixed, conn)
            conn.close()
