import sys

# Kích thước ảnh dựa trên thiết lập lúc chuyển đổi
width = 2048
height = 1365

# Bạn có thể thay đổi tên file này thành tên file hex từ Verilog xuất ra
input_hex = 'baitap2_out.hex' 
output_img = 'output_baitap2_gray.jpg'

print(f"Đang đọc dữ liệu từ {input_hex}...")

try:
    with open(input_hex, 'r') as f:
        lines = f.readlines()
        
    # Lấy các giá trị hex hợp lệ, bỏ qua dòng trống
    hex_values = [line.strip() for line in lines if line.strip()]
    
    expected_pixels = width * height
    if len(hex_values) != expected_pixels:
        print(f"Cảnh báo: Mong đợi {expected_pixels} pixels, nhưng chỉ đọc được {len(hex_values)} pixels.")

    try:
        from PIL import Image
        img = Image.new('L', (width, height)) # 'L' là chế độ Grayscale (8-bit)
        
        # Dữ liệu hex_values đang được lưu theo quét cột (Column-major)
        # PIL.Image.putdata() yêu cầu dữ liệu nạp vào theo quét hàng (Row-major)
        # Nên ta sẽ chuyển đổi thứ tự quét từ mảng 1D (cột) sang 1D (hàng)
        row_major_pixels = []
        for y in range(height):
            for x in range(width):
                # Vị trí pixel hiện tại trong mảng quét cột
                index = x * height + y
                if index < len(hex_values):
                    pixel_val = int(hex_values[index], 16)
                    row_major_pixels.append(pixel_val)
                else:
                    row_major_pixels.append(0) # Điền đen nếu thiếu dữ liệu
                    
        img.putdata(row_major_pixels)
        img.save(output_img)
        print(f"Thành công! Ảnh đã được lưu tại {output_img} (Sử dụng PIL).")
        
    except ImportError:
        try:
            import cv2
            import numpy as np
            
            # Tạo mảng rỗng kích thước (height, width) với kiểu uint8
            img_array = np.zeros((height, width), dtype=np.uint8)
            
            # Gán dữ liệu vào mảng 2D
            for x in range(width):
                for y in range(height):
                    index = x * height + y
                    if index < len(hex_values):
                        img_array[y, x] = int(hex_values[index], 16)
                        
            cv2.imwrite(output_img, img_array)
            print(f"Thành công! Ảnh đã được lưu tại {output_img} (Sử dụng OpenCV).")
        except ImportError:
            print("Lỗi: Máy tính của bạn không có cài đặt thư viện PIL (Pillow) hoặc cv2 (OpenCV).")

except FileNotFoundError:
    print(f"Lỗi: Không tìm thấy file '{input_hex}'. Hãy đảm bảo bạn đã chạy mô phỏng Verilog và đổi tên file output cho khớp.")
except Exception as e:
    print(f"Đã xảy ra lỗi không xác định: {e}")
