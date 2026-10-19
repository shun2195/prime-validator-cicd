# Prime Validator CI/CD Lab

Bài thực hành thiết lập CI/CD bằng GitHub Actions cho chương trình C kiểm tra số nguyên tố.

## Chạy tại máy

Yêu cầu GCC, GNU Make và Cppcheck. Trên Ubuntu:

```sh
sudo apt-get update
sudo apt-get install -y gcc make cppcheck
make lint
make build
make test
```

`test_app.c` kiểm tra số âm, 0, 1, số nguyên tố, hợp số, số chính phương và INT_MAX = 2147483647. Điều kiện `i <= n / i` tránh phép nhân `i * i` có thể tràn số nguyên.

## GitHub Actions

- `.github/workflows/ci.yml`: chạy job `continuous-integration` với ba giai đoạn Lint → Build → Test khi push lên main hoặc mở/cập nhật pull request vào main.
- `.github/workflows/release.yml`: chạy khi push tag `v*`, kiểm tra mã nguồn, biên dịch, chạy test, nén `validator` và tự tạo GitHub Release kèm `prime-validator-linux-amd64.tar.gz`.
- Cppcheck vẫn dùng `--enable=all --error-exitcode=1`; chỉ bỏ thông báo thiếu đường dẫn header hệ thống vì thư viện chuẩn do GCC cung cấp trên runner.
- Workflow CD có `contents: write` để đăng Release; token tự động do GitHub cấp, không cần tạo hoặc ghi token riêng trong repo.

## Mô phỏng lỗi theo đề

Thêm tạm `if (n == 4) return 1;` ở đầu `is_prime`, commit và push main. Lint và Build vẫn qua, nhưng Test dừng ở `assert(is_prime(4) == 0)`. Sau đó bỏ dòng sai, commit và push lại để CI trở về Success. Chỉ thực hiện mô phỏng trên repo bài lab này.

## Phát hành

Sau khi CI thành công:

```sh
git tag -a v1.0.0 -m "Phat hanh phien ban chinh thuc dau tien v1.0.0"
git push origin v1.0.0
```

Tải asset trong Releases, giải nén rồi chạy trên Linux x86_64:

```sh
tar -xzf prime-validator-linux-amd64.tar.gz
./validator
```

## Bảo vệ nhánh main

Cấu hình yêu cầu pull request và status check `continuous-integration` thành công trước khi merge. Bật áp dụng cho cả quản trị viên để yêu cầu này được thực thi nhất quán. Thiết lập sau khi hoàn tất mô phỏng push lỗi và khôi phục main.
