
"""
Tác giả: Lâm Tuấn Thịnh - 22521408 - Nhóm 16 - BTL2 CSDLPT
"""

import psycopg2
import pandas as pd
from tabulate import tabulate
import sys
from datetime import datetime
from connect_retrieve import get_wsl_ip

def get_connection(host, port, dbname):
    """Tạo kết nối đến database"""
    try:
        conn = psycopg2.connect(
            host=host,
            port=port,
            user="root",
            database=dbname,
            sslmode="disable"
        )
        return conn
    except Exception as e:
        print(f"❌ Lỗi kết nối: {e}")
        return None

def get_connections():
    """Tạo kết nối đến tất cả các database"""
    connections = {}
    wsl_ip = get_wsl_ip()
    
    # Kết nối đến UIT database
    uit_conn = get_connection(wsl_ip, 26257, "db1")
    if uit_conn:
        connections["UIT"] = uit_conn
        
    # Kết nối đến BKU database
    bku_conn = get_connection("26.94.39.56", 26257, "db2")
    if bku_conn:
        connections["BKU"] = bku_conn
        
    return connections

def select_university(connections, message="Chọn trường để thao tác"):
    """Hiển thị menu chọn trường và trả về kết nối tương ứng"""
    print("\n" + "=" * 80)
    print(f"🏫 {message}")
    print("=" * 80)
    
    # Hiển thị danh sách trường có sẵn
    universities = list(connections.keys())
    for i, uni in enumerate(universities, 1):
        print(f"{i}. {uni}")
    print("0. Thoát")
    
    while True:
        try:
            choice = int(input("\n👉 Chọn trường (0-2): "))
            if choice == 0:
                return None
            if 1 <= choice <= len(universities):
                return connections[universities[choice-1]]
            print("❌ Lựa chọn không hợp lệ!")
        except ValueError:
            print("❌ Vui lòng nhập số!")

def display_menu():
    """Hiển thị menu chính"""
    print("\n" + "=" * 80)
    print("📚 QUẢN LÝ SINH VIÊN")
    print("=" * 80)
    print("1. Xem danh sách sinh viên")
    print("2. Thêm sinh viên mới")
    print("3. Cập nhật thông tin sinh viên")
    print("4. Xóa sinh viên")
    print("5. Tìm kiếm sinh viên")
    print("6. Xem thông tin trường và khoa")
    print("7. Xem danh sách môn học")
    print("8. Đăng ký môn học")
    print("9. Chuyển đổi trường")
    print("0. Thoát")
    print("=" * 80)
    return input("👉 Chọn chức năng (0-9): ")

def display_students(conn):
    """Hiển thị danh sách sinh viên"""
    try:
        query = """
            SELECT 
                sa.student_code as "Mã số",
                sp.first_name as "Tên",
                sp.last_name as "Họ",
                sp.email as "Email",
                sp.birth_date as "Ngày sinh",
                sp.gender as "Giới tính",
                u.name as "Trường",
                d.name as "Khoa",
                sa.enrollment_year as "Năm nhập học",
                sa.current_semester as "Học kỳ",
                ROUND(sa.gpa, 2) as "GPA"
            FROM STUDENT_PROFILE sp
            JOIN STUDENT_ACADEMIC sa ON sp.student_id = sa.student_id
            JOIN UNIVERSITY u ON sa.university_id = u.university_id
            JOIN DEPARTMENT d ON sa.department_id = d.department_id
            ORDER BY sa.student_code
        """
        df = pd.read_sql_query(query, conn)
        if len(df) > 0:
            print("\n📋 DANH SÁCH SINH VIÊN:")
            print(tabulate(df, headers='keys', tablefmt='psql', showindex=False))
        else:
            print("\nℹ️ Chưa có sinh viên nào trong database")
    except Exception as e:
        print(f"❌ Lỗi khi hiển thị danh sách: {e}")

def add_student(conn):
    """Thêm sinh viên mới"""
    try:
        print("\n📝 THÊM SINH VIÊN MỚI")
        print("-" * 40)
        
        # Thông tin cơ bản
        print("📌 Thông tin cá nhân:")
        first_name = input("Tên: ")
        last_name = input("Họ: ")
        email = input("Email: ")
        birth_date = input("Ngày sinh (YYYY-MM-DD): ")
        gender = input("Giới tính (Nam/Nữ): ")
        
        # Thông tin học tập
        print("\n📌 Thông tin học tập:")
        cursor = conn.cursor()
        
        # Chọn trường
        print("\nDanh sách trường:")
        cursor.execute("SELECT university_id, name, code FROM UNIVERSITY ORDER BY name")
        universities = cursor.fetchall()
        for i, uni in enumerate(universities, 1):
            print(f"{i}. {uni[1]} ({uni[2]})")
        
        uni_choice = int(input("\n👉 Chọn trường (1-2): ")) - 1
        university_id = universities[uni_choice][0]
        
        # Chọn khoa
        print("\nDanh sách khoa:")
        cursor.execute("""
            SELECT department_id, name, code 
            FROM DEPARTMENT 
            WHERE university_id = %s 
            ORDER BY name
        """, (university_id,))
        departments = cursor.fetchall()
        for i, dept in enumerate(departments, 1):
            print(f"{i}. {dept[1]} ({dept[2]})")
        
        dept_choice = int(input("\n👉 Chọn khoa (1-3): ")) - 1
        department_id = departments[dept_choice][0]
        
        # Thông tin học tập
        enrollment_year = int(input("\nNăm nhập học: "))
        current_semester = int(input("Học kỳ hiện tại: "))
        gpa = float(input("GPA: "))
        
        # Tạo mã sinh viên
        cursor.execute("""
            SELECT code FROM UNIVERSITY WHERE university_id = %s
        """, (university_id,))
        uni_code = cursor.fetchone()[0]
        
        cursor.execute("""
            SELECT COUNT(*) + 1 
            FROM STUDENT_ACADEMIC 
            WHERE university_id = %s
        """, (university_id,))
        next_number = cursor.fetchone()[0]
        student_code = f"{uni_code}{str(next_number).zfill(6)}"
        
        # Thêm thông tin sinh viên
        cursor.execute("""
            INSERT INTO STUDENT_PROFILE 
            (first_name, last_name, email, birth_date, gender)
            VALUES (%s, %s, %s, %s, %s)
            RETURNING student_id
        """, (first_name, last_name, email, birth_date, gender))
        student_id = cursor.fetchone()[0]
        
        # Thêm thông tin học tập
        cursor.execute("""
            INSERT INTO STUDENT_ACADEMIC 
            (student_id, university_id, department_id, student_code, 
             enrollment_year, current_semester, gpa)
            VALUES (%s, %s, %s, %s, %s, %s, %s)
        """, (student_id, university_id, department_id, student_code,
              enrollment_year, current_semester, gpa))
        
        conn.commit()
        print(f"\n✅ Đã thêm sinh viên mới thành công!")
        print(f"📌 Mã số sinh viên: {student_code}")
        
    except Exception as e:
        print(f"❌ Lỗi khi thêm sinh viên: {e}")
        conn.rollback()
    finally:
        cursor.close()

def update_student(conn):
    """Cập nhật thông tin sinh viên"""
    try:
        print("\n📝 CẬP NHẬT THÔNG TIN SINH VIÊN")
        print("-" * 40)
        
        student_code = input("Nhập mã số sinh viên cần cập nhật: ")
        
        # Kiểm tra sinh viên tồn tại
        cursor = conn.cursor()
        cursor.execute("""
            SELECT 
                sp.student_id,
                sp.first_name,
                sp.last_name,
                sp.email,
                sp.birth_date,
                sp.gender,
                sa.student_code,
                sa.enrollment_year,
                sa.current_semester,
                sa.gpa
            FROM STUDENT_PROFILE sp
            JOIN STUDENT_ACADEMIC sa ON sp.student_id = sa.student_id
            WHERE sa.student_code = %s
        """, (student_code,))
        student = cursor.fetchone()
        
        if not student:
            print("❌ Không tìm thấy sinh viên với mã số này!")
            return
        
        print(f"\n📌 Thông tin hiện tại:")
        print(f"Mã số: {student[6]}")
        print(f"Họ tên: {student[2]} {student[1]}")
        print(f"Email: {student[3]}")
        print(f"Ngày sinh: {student[4]}")
        print(f"Giới tính: {student[5]}")
        print(f"Năm nhập học: {student[7]}")
        print(f"Học kỳ hiện tại: {student[8]}")
        print(f"GPA: {student[9]}")
        
        print("\n📌 Nhập thông tin mới (Enter để giữ nguyên):")
        first_name = input("Tên mới: ")
        last_name = input("Họ mới: ")
        email = input("Email mới: ")
        birth_date = input("Ngày sinh mới (YYYY-MM-DD): ")
        gender = input("Giới tính mới (Nam/Nữ): ")
        enrollment_year = input("Năm nhập học mới: ")
        current_semester = input("Học kỳ hiện tại mới: ")
        gpa = input("GPA mới: ")
        
        # Cập nhật thông tin
        if any([first_name, last_name, email, birth_date, gender]):
            query = "UPDATE STUDENT_PROFILE SET "
            params = []
            if first_name:
                query += "first_name = %s"
                params.append(first_name)
            if last_name:
                if params:
                    query += ", "
                query += "last_name = %s"
                params.append(last_name)
            if email:
                if params:
                    query += ", "
                query += "email = %s"
                params.append(email)
            if birth_date:
                if params:
                    query += ", "
                query += "birth_date = %s"
                params.append(birth_date)
            if gender:
                if params:
                    query += ", "
                query += "gender = %s"
                params.append(gender)
            query += " WHERE student_id = %s"
            params.append(student[0])
            
            cursor.execute(query, params)
        
        if any([enrollment_year, current_semester, gpa]):
            query = "UPDATE STUDENT_ACADEMIC SET "
            params = []
            if enrollment_year:
                query += "enrollment_year = %s"
                params.append(int(enrollment_year))
            if current_semester:
                if params:
                    query += ", "
                query += "current_semester = %s"
                params.append(int(current_semester))
            if gpa:
                if params:
                    query += ", "
                query += "gpa = %s"
                params.append(float(gpa))
            query += " WHERE student_id = %s"
            params.append(student[0])
            
            cursor.execute(query, params)
        
        conn.commit()
        print("\n✅ Đã cập nhật thông tin sinh viên thành công!")
        
    except Exception as e:
        print(f"❌ Lỗi khi cập nhật sinh viên: {e}")
        conn.rollback()
    finally:
        cursor.close()

def delete_student(conn):
    """Xóa sinh viên"""
    try:
        print("\n🗑️ XÓA SINH VIÊN")
        print("-" * 40)
        
        student_code = input("Nhập mã số sinh viên cần xóa: ")
        
        # Kiểm tra sinh viên tồn tại
        cursor = conn.cursor()
        cursor.execute("""
            SELECT 
                sp.student_id,
                sp.first_name,
                sp.last_name,
                sa.student_code
            FROM STUDENT_PROFILE sp
            JOIN STUDENT_ACADEMIC sa ON sp.student_id = sa.student_id
            WHERE sa.student_code = %s
        """, (student_code,))
        student = cursor.fetchone()
        
        if not student:
            print("❌ Không tìm thấy sinh viên với mã số này!")
            return
        
        confirm = input(f"\n⚠️ Bạn có chắc muốn xóa sinh viên {student[2]} {student[1]} (MSSV: {student[3]})? (y/n): ")
        if confirm.lower() == 'y':
            cursor.execute("DELETE FROM STUDENT_PROFILE WHERE student_id = %s", (student[0],))
            conn.commit()
            print("\n✅ Đã xóa sinh viên thành công!")
        else:
            print("\nℹ️ Đã hủy thao tác xóa")
            
    except Exception as e:
        print(f"❌ Lỗi khi xóa sinh viên: {e}")
        conn.rollback()
    finally:
        cursor.close()

def search_student(conn):
    """Tìm kiếm sinh viên"""
    try:
        print("\n🔍 TÌM KIẾM SINH VIÊN")
        print("-" * 40)
        
        search_term = input("Nhập tên, mã số hoặc email sinh viên cần tìm: ")
        
        cursor = conn.cursor()
        cursor.execute("""
            SELECT 
                sa.student_code as "Mã số",
                sp.first_name as "Tên",
                sp.last_name as "Họ",
                sp.email as "Email",
                sp.birth_date as "Ngày sinh",
                sp.gender as "Giới tính",
                u.name as "Trường",
                d.name as "Khoa",
                sa.enrollment_year as "Năm nhập học",
                sa.current_semester as "Học kỳ",
                ROUND(sa.gpa, 2) as "GPA"
            FROM STUDENT_PROFILE sp
            JOIN STUDENT_ACADEMIC sa ON sp.student_id = sa.student_id
            JOIN UNIVERSITY u ON sa.university_id = u.university_id
            JOIN DEPARTMENT d ON sa.department_id = d.department_id
            WHERE 
                sa.student_code ILIKE %s OR
                sp.first_name ILIKE %s OR
                sp.last_name ILIKE %s OR
                sp.email ILIKE %s
            ORDER BY sa.student_code
        """, (f'%{search_term}%', f'%{search_term}%', f'%{search_term}%', f'%{search_term}%'))
        
        students = cursor.fetchall()
        cursor.close()
        
        if students:
            print("\n📋 KẾT QUẢ TÌM KIẾM:")
            df = pd.DataFrame(students)
            print(tabulate(df, headers='keys', tablefmt='psql', showindex=False))
        else:
            print("\nℹ️ Không tìm thấy sinh viên nào phù hợp")
    except Exception as e:
        print(f"❌ Lỗi khi tìm kiếm sinh viên: {e}")

def display_university_info(conn):
    """Hiển thị thông tin trường và khoa"""
    try:
        print("\n🏫 THÔNG TIN TRƯỜNG VÀ KHOA")
        print("-" * 40)
        
        cursor = conn.cursor()
        cursor.execute("""
            SELECT 
                u.name as "Trường",
                u.location as "Địa điểm",
                u.code as "Mã trường",
                d.name as "Khoa",
                d.code as "Mã khoa"
            FROM UNIVERSITY u
            JOIN DEPARTMENT d ON u.university_id = d.university_id
            ORDER BY u.name, d.name
        """)
        
        results = cursor.fetchall()
        cursor.close()
        
        if results:
            df = pd.DataFrame(results)
            print(tabulate(df, headers='keys', tablefmt='psql', showindex=False))
        else:
            print("\nℹ️ Không có dữ liệu")
    except Exception as e:
        print(f"❌ Lỗi khi hiển thị thông tin: {e}")

def display_courses(conn):
    """Hiển thị danh sách môn học"""
    try:
        print("\n📚 DANH SÁCH MÔN HỌC")
        print("-" * 40)
        
        cursor = conn.cursor()
        cursor.execute("""
            SELECT 
                c.code as "Mã môn",
                c.name as "Tên môn",
                c.credits as "Số tín chỉ",
                u.name as "Trường",
                d.name as "Khoa"
            FROM COURSE c
            JOIN UNIVERSITY u ON c.university_id = u.university_id
            JOIN DEPARTMENT d ON c.department_id = d.department_id
            ORDER BY u.name, d.name, c.code
        """)
        
        courses = cursor.fetchall()
        cursor.close()
        
        if courses:
            df = pd.DataFrame(courses)
            print(tabulate(df, headers='keys', tablefmt='psql', showindex=False))
        else:
            print("\nℹ️ Không có môn học nào")
    except Exception as e:
        print(f"❌ Lỗi khi hiển thị danh sách môn học: {e}")

def enroll_course(conn):
    """Đăng ký môn học"""
    try:
        print("\n📝 ĐĂNG KÝ MÔN HỌC")
        print("-" * 40)
        
        student_code = input("Nhập mã số sinh viên: ")
        
        # Kiểm tra sinh viên tồn tại
        cursor = conn.cursor()
        cursor.execute("""
            SELECT student_id, first_name, last_name
            FROM STUDENT_PROFILE sp
            JOIN STUDENT_ACADEMIC sa ON sp.student_id = sa.student_id
            WHERE sa.student_code = %s
        """, (student_code,))
        student = cursor.fetchone()
        
        if not student:
            print("❌ Không tìm thấy sinh viên!")
            return
        
        # Hiển thị danh sách môn học
        cursor.execute("""
            SELECT 
                c.course_id,
                c.code,
                c.name,
                c.credits,
                u.name as university,
                d.name as department
            FROM COURSE c
            JOIN UNIVERSITY u ON c.university_id = u.university_id
            JOIN DEPARTMENT d ON c.department_id = d.department_id
            ORDER BY c.code
        """)
        courses = cursor.fetchall()
        
        print(f"\n📚 Danh sách môn học cho sinh viên {student[2]} {student[1]}:")
        for i, course in enumerate(courses, 1):
            print(f"{i}. {course[1]} - {course[2]} ({course[3]} tín chỉ) - {course[4]} - {course[5]}")
        
        course_choice = int(input("\n👉 Chọn môn học (1-5): ")) - 1
        course_id = courses[course_choice][0]
        
        semester = input("Nhập học kỳ (VD: 2024-1): ")
        
        # Kiểm tra đã đăng ký chưa
        cursor.execute("""
            SELECT 1 FROM ENROLLMENT
            WHERE student_id = %s AND course_id = %s AND semester = %s
        """, (student[0], course_id, semester))
        
        if cursor.fetchone():
            print("❌ Sinh viên đã đăng ký môn học này trong học kỳ này!")
            return
        
        # Đăng ký môn học
        cursor.execute("""
            INSERT INTO ENROLLMENT (student_id, course_id, semester)
            VALUES (%s, %s, %s)
        """, (student[0], course_id, semester))
        
        conn.commit()
        print("\n✅ Đã đăng ký môn học thành công!")
        
    except Exception as e:
        print(f"❌ Lỗi khi đăng ký môn học: {e}")
        conn.rollback()
    finally:
        cursor.close()

def main():
    # Khởi tạo kết nối đến các database
    connections = get_connections()
    if not connections:
        print("❌ Không thể kết nối đến bất kỳ database nào!")
        sys.exit(1)
    
    # Chọn trường ban đầu
    current_conn = select_university(connections, "Chọn trường để bắt đầu")
    if not current_conn:
        print("❌ Đã hủy thao tác!")
        sys.exit(0)
    
    print(f"\n✅ Đã kết nối đến trường đã chọn")
    
    # Vòng lặp chính
    while True:
        choice = display_menu()
        
        if choice == '0':
            print("\n👋 Tạm biệt!")
            break
        elif choice == '9':
            # Chuyển đổi trường
            new_conn = select_university(connections, "Chọn trường để chuyển đổi")
            if new_conn:
                current_conn = new_conn
                print(f"\n✅ Đã chuyển sang trường mới")
            else:
                print("\n👋 Tạm biệt!") 
                break
            continue
            
        if choice == '1':
            display_students(current_conn)
        elif choice == '2':
            add_student(current_conn)
        elif choice == '3':
            update_student(current_conn)
        elif choice == '4':
            delete_student(current_conn)
        elif choice == '5':
            search_student(current_conn)
        elif choice == '6':
            display_university_info(current_conn)
        elif choice == '7':
            display_courses(current_conn)
        elif choice == '8':
            enroll_course(current_conn)
        else:
            print("❌ Lựa chọn không hợp lệ!")
    
    # Đóng tất cả các kết nối
    for conn in connections.values():
        if conn:
            conn.close()

if __name__ == "__main__":
    main() 