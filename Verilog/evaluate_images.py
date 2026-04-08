import cv2
import numpy as np
import os
import sys

try:
    from skimage.metrics import structural_similarity as ssim
    from skimage.metrics import peak_signal_noise_ratio as psnr
except ImportError:
    print("Vui lòng cài đặt thư viện scikit-image và opencv-python để chạy script này.")
    print("Mở terminal và gõ lệnh: pip install opencv-python scikit-image")
    sys.exit(1)

def evaluate_images(original_img_path, denoised_img_path):
    print(f"Đang đọc ảnh gốc: {original_img_path}")
    print(f"Đang đọc ảnh đã lọc: {denoised_img_path}\n")

    if not os.path.exists(original_img_path):
        print(f"Lỗi: Không tìm thấy ảnh gốc '{original_img_path}'")
        return
    
    if not os.path.exists(denoised_img_path):
        print(f"Lỗi: Không tìm thấy ảnh đã lọc '{denoised_img_path}'")
        return

    # Đọc ảnh dưới dạng ảnh xám (Grayscale)
    img_original = cv2.imread(original_img_path, cv2.IMREAD_GRAYSCALE)
    img_denoised = cv2.imread(denoised_img_path, cv2.IMREAD_GRAYSCALE)

    if img_original is None or img_denoised is None:
        print("Lỗi: Không thể mở một trong hai ảnh. Vui lòng kiểm tra lại định dạng file.")
        return

    # Kích thước ảnh phải bằng nhau để so sánh
    if img_original.shape != img_denoised.shape:
        print(f"Cảnh báo: Kích thước hai ảnh không khớp nhau!")
        print(f"Ảnh gốc: {img_original.shape}")
        print(f"Ảnh lọc: {img_denoised.shape}")
        print("Đang tiến hành resize ảnh lọc về bằng kích thước ảnh gốc...")
        img_denoised = cv2.resize(img_denoised, (img_original.shape[1], img_original.shape[0]))

    # Tính toán PSNR
    psnr_value = psnr(img_original, img_denoised, data_range=255)
    
    # Tính toán SSIM
    ssim_value, _ = ssim(img_original, img_denoised, full=True, data_range=255)

    print("=== KẾT QUẢ ĐÁNH GIÁ CHẤT LƯỢNG ẢNH ===")
    print(f"Chỉ số PSNR (Peak Signal-to-Noise Ratio): {psnr_value:.2f} dB")
    print(f"Chỉ số SSIM (Structural Similarity Index):  {ssim_value:.4f}")
    
    if psnr_value > 30:
        print("\nNhận xét: PSNR > 30 dB cho thấy chất lượng ảnh sau khi lọc nhiễu rất tốt, khó phân biệt bằng mắt thường so với ảnh gốc.")
    elif psnr_value > 20:
        print("\nNhận xét: PSNR từ 20-30 dB là mức có thể chấp nhận được, ảnh có thể còn hơi nhiễu hoặc mờ.")
    else:
        print("\nNhận xét: PSNR < 20 dB, bộ lọc chưa hiệu quả hoặc làm mất quá nhiều chi tiết gốc.")

if __name__ == "__main__":
    img_goc = 'baitap1_anhgoc.jpg'
    img_loc = 'ketqua1_image.jpg'
    evaluate_images(img_goc, img_loc)
