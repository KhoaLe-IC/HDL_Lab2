import numpy as np
from PIL import Image
import os

# Kích thước ảnh thực tế
width = 430
height = 554
input_file = 'ketqua1.hex'
output_file = 'ketqua1_image.jpg'

print(f"Đang đọc dữ liệu từ {input_file}...")

if not os.path.exists(input_file):
    print(f"Lỗi: Không tìm thấy file {input_file}")
    exit(1)

# Đọc các dòng từ file hex
with open(input_file, 'r') as f:
    hex_data = f.read().splitlines()

# Chuyển đổi mã hex (chuỗi) sang số nguyên (integer 0-255)
pixel_data = []
for h in hex_data:
    h = h.strip()
    if h:
        try:
            pixel_data.append(int(h, 16))
        except ValueError:
            pass

print(f"Đã đọc {len(pixel_data)} điểm ảnh.")

# Kiểm tra xem số lượng pixel có khớp với kích thước không
expected_size = width * height
if len(pixel_data) != expected_size:
    print(f"Cảnh báo: Số lượng điểm ảnh ({len(pixel_data)}) không khớp với kích thước ảnh ({width}x{height} = {expected_size}).")
    
    # Cắt bớt hoặc thêm pixel đen (0) cho đủ size
    if len(pixel_data) < expected_size:
        pixel_data.extend([0] * (expected_size - len(pixel_data)))
    else:
        pixel_data = pixel_data[:expected_size]

# Chuyển mảng 1 chiều sang mảng 2 chiều Numpy (height x width)
# dtype=np.uint8 (số nguyên không dấu 8-bit, khoảng 0-255)
pixel_array = np.array(pixel_data, dtype=np.uint8).reshape((height, width))

# Tạo ảnh từ mảng Numpy (mode 'L' là ảnh Grayscale/ảnh xám 8-bit)
img = Image.fromarray(pixel_array, mode='L')

# Lưu ảnh
img.save(output_file)
print(f"Thành công! Đã lưu ảnh kết quả vào {output_file}")
