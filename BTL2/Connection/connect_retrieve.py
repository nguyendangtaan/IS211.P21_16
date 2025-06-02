
"""
Tác giả: Lâm Tuấn Thịnh - 22521408 - Nhóm 16 - BTL2 CSDLPT
"""

import psycopg2
import pandas as pd
import sys
import subprocess
import socket
import time

def get_wsl_ip():
    """Lấy địa chỉ IP của WSL tự động"""
    try:
        result = subprocess.run(['wsl', 'hostname', '-I'], 
                              capture_output=True, text=True, timeout=5)
        if result.returncode == 0:
            ip = result.stdout.strip().split()[0]
            return ip
    except:
        pass
    return "172.25.240.10"  # Fallback

def test_connection(host, port, dbname, connection_name):
    """Test kết nối tới database"""
    try:
        print(f"🔌 Đang kết nối database {connection_name} ({host}:{port}/{dbname})...")
        conn = psycopg2.connect(
            host=host,
            port=port,
            user="root",
            database=dbname,
            sslmode="disable",
            connect_timeout=10
        )
        
        # Test query
        cursor = conn.cursor()
        cursor.execute("SELECT COUNT(*) FROM student_profile;")
        count = cursor.fetchone()[0]
        print(f"✅ Kết nối database thành công! Tìm thấy {count} sinh viên trong {connection_name}")
        cursor.close()
        
        return conn
    except Exception as e:
        print(f"❌ Kết nối database thất bại đến {connection_name}: {e}")
        return None

def main():
    wsl_ip = get_wsl_ip()

    print("=" * 80)
    print("🌐 KẾT NỐI VÀ TRUY VẤN COCKROACHDB")
    print("=" * 80)
    
    # Định nghĩa các kết nối
    connections = [
        {
            "name": "Local Database", 
            "host": wsl_ip,  # WSL IP
            "port": 26257, 
            "db": "db1"
        },
        {
            "name": "Remote Database", 
            "host": "26.94.39.56",  # IP máy Tân
            "port": 26257, 
            "db": "db2"
        }
    ]
    
    # Test từng kết nối
    active_connections = {}
    
    for conn_info in connections:
        print(f"\n🧪 Testing: {conn_info['name']}")
        print("-" * 60)
        
        conn = test_connection(
            conn_info["host"], 
            conn_info["port"], 
            conn_info["db"],
            conn_info["name"]
        )
        
        if conn:
            active_connections[conn_info["name"]] = conn
    
    # Thực hiện truy vấn nếu có kết nối thành công
    if len(active_connections) >= 1:
        print("\n" + "=" * 80)
        print("📊 TRUY VẤN DỮ LIỆU")
        print("=" * 80)
        
        try:
            query = "SELECT first_name, last_name, email, birth_date, gender FROM STUDENT_PROFILE;"
            dataframes = {}
            
            for name, conn in active_connections.items():
                print(f"\n📥 Truy vấn từ {name}...")
                try:
                    df = pd.read_sql_query(query, conn)
                    dataframes[name] = df
                    print(f"✅ Lấy được {len(df)} bản ghi")
                    
                    if len(df) > 0:
                        print("📋 Dữ liệu mẫu:")
                        print(df.to_string(index=False))
                    else:
                        print("(Không có dữ liệu)")
                except Exception as e:
                    print(f"❌ Lỗi truy vấn: {e}")
            
            # Tổng hợp nếu có nhiều database
            if len(dataframes) > 1:
                print(f"\n🔗 TỔNG HỢP TỪ {len(dataframes)} DATABASE:")
                print("-" * 60)
                
                total_records = sum(len(df) for df in dataframes.values())
                print(f"📊 Tổng số bản ghi: {total_records}")
                
                for name, df in dataframes.items():
                    print(f"  • {name}: {len(df)} bản ghi")
        
        except Exception as e:
            print(f"❌ Lỗi khi truy vấn: {e}")
    
    # Đóng kết nối
    print(f"\n" + "=" * 80)
    print("🔒 ĐÓNG KẾT NỐI")
    print("=" * 80)
    
    for name, conn in active_connections.items():
        try:
            conn.close()
            print(f"✅ Đã đóng kết nối: {name}")
        except:
            print(f"⚠️  Lỗi khi đóng: {name}")
    
    print(f"\n🎉 Hoàn thành!")
    print("=" * 80)

if __name__ == "__main__":
    main()