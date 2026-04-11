import sys
import time

try:
    from PIL import Image
    # Sử dụng đúng tên file trong thư mục: baitap2_anhgoc.jpg
    print("Đang đọc ảnh bằng PIL...")
    img = Image.open('baitap2_anhgoc.jpg').convert('RGB')
    width, height = img.size
    print(f"Image loaded. Size: {width}x{height}")
    
    start_time = time.time()
    # Lấy dữ liệu toàn bộ ảnh (mặc định của PIL đã là quét theo hàng từ trên xuống dưới, trái qua phải)
    pixels = img.getdata()
    
    print("Đang xử lý và ghi dữ liệu ra file baitap2.hex (có thể mất vài giây)...")
    with open('baitap2.hex', 'w', encoding='ascii') as f:
        # Tối ưu hóa: dùng list comprehension để nối chuỗi cực nhanh và ghi 1 lần (writelines)
        # thay vì dùng vòng lặp for gọi f.write() 2.7 triệu lần khiến máy bị treo.
        lines = [f"{r:02x}{g:02x}{b:02x}\n" for r, g, b in pixels]
        f.writelines(lines)
                
    end_time = time.time()
    print(f"Success! Converted to baitap2.hex using row-major order using PIL.")
    print(f"Thời gian xử lý: {end_time - start_time:.2f} giây.")

except ImportError:
    try:
        import cv2
        print("Đang đọc ảnh bằng OpenCV...")
        img = cv2.imread('baitap2_anhgoc.jpg', cv2.IMREAD_COLOR)
        if img is None:
             print("Error: Could not read image baitap2_anhgoc.jpg.")
             sys.exit(1)
             
        # OpenCV loads images as BGR, chuyển sang RGB
        img = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
        height, width, _ = img.shape
        print(f"Image loaded. Size: {width}x{height}")
        
        start_time = time.time()
        print("Đang xử lý và ghi dữ liệu ra file baitap2.hex (có thể mất vài giây)...")
        # OpenCV img là numpy array 3D (height, width, 3).
        # Reshape nó thành mảng 2D (height*width, 3) để duyệt qua các pixel theo thứ tự quét hàng
        pixels = img.reshape(-1, 3)
        
        with open('baitap2.hex', 'w', encoding='ascii') as f:
            # Tối ưu hóa tốc độ ghi file
            lines = [f"{r:02x}{g:02x}{b:02x}\n" for r, g, b in pixels]
            f.writelines(lines)
            
        end_time = time.time()
        print(f"Success! Converted to baitap2.hex using row-major order using OpenCV.")
        print(f"Thời gian xử lý: {end_time - start_time:.2f} giây.")
        
    except ImportError:
        print("Error: Neither PIL (Pillow) nor cv2 (OpenCV) is installed.")
except Exception as e:
    print(f"An error occurred: {e}")
