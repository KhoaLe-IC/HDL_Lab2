from PIL import Image
import numpy as np

# ======== Cấu hình ========
hex_file = "output.txt"     # file input
width = 430              # chiều rộng ảnh
height = 554             # chiều cao ảnh
output_file = "output.jpg"

# ======== Bước 1: Đọc dữ liệu hex ========
data = []
with open(hex_file, "r") as f:
    for line in f:
        # loại bỏ khoảng trắng và newline
        line = line.strip()
        if not line:
            continue
        # tách nhiều giá trị trên cùng dòng
        for hex_val in line.replace("0x", "").split():
            data.append(int(hex_val, 16))

# ======== Bước 2: Chuyển thành mảng numpy ========
data = np.array(data, dtype=np.uint8)

# Kiểm tra kích thước
if len(data) != width*height:
    raise ValueError(f"Dữ liệu ({len(data)} bytes) không khớp với kích thước {width}x{height}")

data = data.reshape((height, width))

# ======== Bước 3: Lưu ảnh ========
img = Image.fromarray(data, mode='L')  # 'L' = grayscale
img.save(output_file)
print(f"Ảnh đã được lưu thành {output_file}")