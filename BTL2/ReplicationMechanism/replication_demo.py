"""
File demo dưới đây sẽ:

- Kết nối tới một trong các database bạn đã định nghĩa (Local hoặc Remote).
- Thực hiện các thao tác CRUD đơn giản.
- In ra các thông điệp giải thích rằng CockroachDB đang đảm bảo dữ liệu được sao chép bên trong cụm đó.

Tác giả: Lâm Tuấn Thịnh - 22521408 - Nhóm 16 - BTL2 CSDLPT
"""

# replication_demo.py
import psycopg2
import time
from Connection.connect_retrieve import get_wsl_ip
from tabulate import tabulate
from datetime import datetime

def show_current_data(conn, operation_type=None):
    """Hiển thị dữ liệu hiện tại trong bảng một cách trực quan"""
    try:
        with conn.cursor() as cur:
            cur.execute("""
                SELECT id, message, created_at 
                FROM replication_demo_table 
                ORDER BY id;
            """)
            records = cur.fetchall()
            
            if records:
                print("\n📋 Dữ liệu hiện tại trong bảng:")
                print("-" * 80)
                headers = ["ID", "Message", "Thời gian tạo"]
                print(tabulate(records, headers=headers, tablefmt="grid"))
                
                if operation_type:
                    print(f"\n✨ Thao tác vừa thực hiện: {operation_type}")
                    print(f"📊 Tổng số bản ghi: {len(records)}")
            else:
                print("\n📋 Bảng hiện đang trống")
                
    except Exception as e:
        print(f"⚠️ Không thể hiển thị dữ liệu: {e}")

def connect_db(host, port, dbname, user="root", sslmode="disable", connect_timeout=10):
    """Kết nối tới một database CockroachDB"""
    print(f"\n🔌 Đang kết nối tới database trên {host}:{port}/{dbname}...")
    try:
        conn = psycopg2.connect(
            host=host,
            port=port,
            user=user,
            database=dbname,
            sslmode=sslmode,
            connect_timeout=connect_timeout
        )
        print(f"✅ Kết nối thành công tới {host}:{port}/{dbname}!")
        return conn
    except Exception as e:
        print(f"❌ Kết nối thất bại: {e}")
        return None

def show_cluster_info(conn):
    """Hiển thị thông tin cơ bản về cụm"""
    print("\n📊 Thông tin Cụm:")
    print("-" * 50)
    
    try:
        with conn.cursor() as cur:
            # Thông tin node
            cur.execute("""
                SELECT node_id, address, is_live
                FROM crdb_internal.gossip_nodes 
                WHERE node_id IS NOT NULL
                ORDER BY node_id;
            """)
            nodes = cur.fetchall()
            
            if nodes:
                print("\n🖥️  Nodes trong cụm:")
                headers = ["Node ID", "Địa chỉ", "Trạng thái"]
                print(tabulate(nodes, headers=headers, tablefmt="simple"))
            
    except Exception as e:
        print(f"⚠️ Không thể lấy thông tin cụm: {e}")

def create_replication_test_table(conn):
    """Tạo bảng để kiểm thử (nếu chưa tồn tại)"""
    try:
        with conn.cursor() as cur:
            cur.execute("""
                CREATE TABLE IF NOT EXISTS replication_demo_table (
                    id SERIAL PRIMARY KEY,
                    message TEXT,
                    created_at TIMESTAMPTZ DEFAULT now()
                );
            """)
            conn.commit()
            print("👍 Bảng 'replication_demo_table' đã sẵn sàng.")
    except Exception as e:
        print(f"❌ Lỗi khi tạo bảng: {e}")
        conn.rollback()

def insert_data(conn, message):
    """Chèn dữ liệu và giải thích về sao chép"""
    print(f"\n✏️ Đang chèn dữ liệu: '{message}'")
    try:
        with conn.cursor() as cur:
            cur.execute("INSERT INTO replication_demo_table (message) VALUES (%s) RETURNING id;", (message,))
            new_id = cur.fetchone()[0]
            conn.commit()
            print(f"✅ Dữ liệu đã được chèn với ID: {new_id}")
            print("ℹ️  Dữ liệu được sao chép tới các replica trong cụm")
            show_current_data(conn, "INSERT")
            return new_id
    except Exception as e:
        print(f"❌ Lỗi khi chèn dữ liệu: {e}")
        conn.rollback()
        return None

def select_data(conn, record_id):
    """Đọc dữ liệu và giải thích"""
    print(f"\n🔍 Đang đọc dữ liệu với ID: {record_id}")
    try:
        with conn.cursor() as cur:
            cur.execute("SELECT id, message, created_at FROM replication_demo_table WHERE id = %s;", (record_id,))
            record = cur.fetchone()
            if record:
                print(f"✅ Dữ liệu tìm thấy: ID={record[0]}, Message='{record[1]}', CreatedAt={record[2]}")
                print("ℹ️  Dữ liệu được đọc từ leaseholder để đảm bảo tính nhất quán")
            else:
                print(f"🤷 Không tìm thấy dữ liệu với ID: {record_id}")
            return record
    except Exception as e:
        print(f"❌ Lỗi khi đọc dữ liệu: {e}")
        return None

def update_data(conn, record_id, new_message):
    """Cập nhật dữ liệu và giải thích"""
    print(f"\n🔄 Đang cập nhật dữ liệu cho ID: {record_id}")
    try:
        with conn.cursor() as cur:
            cur.execute("UPDATE replication_demo_table SET message = %s WHERE id = %s RETURNING id;", (new_message, record_id))
            updated_id = cur.fetchone()
            conn.commit()
            if updated_id:
                print(f"✅ Dữ liệu đã được cập nhật")
                print("ℹ️  Thay đổi được sao chép tới các replica")
                show_current_data(conn, "UPDATE")
            else:
                print(f"🤷 Không tìm thấy ID: {record_id} để cập nhật")
            return updated_id
    except Exception as e:
        print(f"❌ Lỗi khi cập nhật dữ liệu: {e}")
        conn.rollback()
        return None

def delete_data(conn, record_id):
    """Xóa dữ liệu và giải thích"""
    print(f"\n🗑️ Đang xóa dữ liệu với ID: {record_id}")
    try:
        with conn.cursor() as cur:
            cur.execute("DELETE FROM replication_demo_table WHERE id = %s RETURNING id;", (record_id,))
            deleted_id = cur.fetchone()
            conn.commit()
            if deleted_id:
                print(f"✅ Dữ liệu đã được xóa")
                print("ℹ️  Xóa được sao chép tới các replica")
                show_current_data(conn, "DELETE")
            else:
                print(f"🤷 Không tìm thấy ID: {record_id} để xóa")
            return deleted_id
    except Exception as e:
        print(f"❌ Lỗi khi xóa dữ liệu: {e}")
        conn.rollback()
        return None

def main():
    wsl_ip = get_wsl_ip()

    # Định nghĩa các kết nối có thể sử dụng
    available_connections_config = [
        {
            "name": "Local WSL Database (db1)",
            "host": wsl_ip,
            "port": 26257,
            "db": "db1"
        },
        {
            "name": "Remote Database Tân (db2)",
            "host": "26.94.39.56", 
            "port": 26257, 
            "db": "db2"
        }
    ]

    print("=" * 50)
    print("🚀 COCKROACHDB REPLICATION DEMO")
    print("=" * 50)
    print("Demo minh họa cách CockroachDB sao chép dữ liệu trong cụm")
    
    print("\nChọn cụm CockroachDB để thực hiện demo:")
    for i, cfg in enumerate(available_connections_config):
        print(f"{i+1}. {cfg['name']} ({cfg['host']}:{cfg['port']}/{cfg['db']})")
    
    choice = -1
    while choice < 1 or choice > len(available_connections_config):
        try:
            choice = int(input(f"Nhập lựa chọn (1-{len(available_connections_config)}): "))
        except ValueError:
            print("Vui lòng nhập một số.")

    selected_config = available_connections_config[choice-1]
    
    # Kết nối tới database đã chọn
    conn = connect_db(selected_config["host"], selected_config["port"], selected_config["db"])

    if conn:
        try:
            # Hiển thị thông tin cụm
            show_cluster_info(conn)
            
            # Tạo bảng và thực hiện các thao tác
            create_replication_test_table(conn)
            show_current_data(conn)
            
            time.sleep(1)
            message1 = "Hello CockroachDB Replication!"
            record_id1 = insert_data(conn, message1)
            
            time.sleep(1)
            if record_id1:
                select_data(conn, record_id1)
            
            time.sleep(1)
            if record_id1:
                new_message = "Replication ensures data is safe and consistent!"
                update_data(conn, record_id1, new_message)
            
            time.sleep(1)
            if record_id1:
                select_data(conn, record_id1)
            
            time.sleep(1)
            message2 = "Another record for testing."
            record_id2 = insert_data(conn, message2)

            time.sleep(1)
            if record_id1:
                delete_data(conn, record_id1)
            
            time.sleep(1)
            if record_id1:
                select_data(conn, record_id1)

            if record_id2:
                select_data(conn, record_id2)

            print("\n" + "="*50)
            print("✨ Demo hoàn tất!")
            print("Những gì bạn đã thấy:")
            print("  1. Dữ liệu được ghi vào cụm CockroachDB")
            print("  2. Mỗi thao tác được sao chép tới các replica")
            print("  3. Dữ liệu vẫn an toàn khi có node gặp sự cố")
            print("="*50)

        finally:
            print("\n🔒 Đóng kết nối...")
            conn.close()
            print("✅ Kết nối đã đóng.")
    else:
        print("Không thể thực hiện demo vì không kết nối được database.")

if __name__ == "__main__":
    main()