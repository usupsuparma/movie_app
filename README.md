# movie_app

A new Flutter project.

[![Codemagic build status](https://api.codemagic.io/apps/6a0971bea4003b132f073696/6a0971bea4003b132f073695/status_badge.svg)](https://codemagic.io/app/<app-id>/<workflow-id>/latest_build)

## Generate Test Coverage Report (Windows)

Panduan ini untuk Windows dengan Flutter test coverage dan LCOV dari Chocolatey.

### 1. Masuk ke root project

```powershell
cd D:\project\flutter\movie_app
```

### 2. Jalankan test dengan coverage

```powershell
flutter test --coverage
```

File coverage mentah akan dibuat di `coverage/lcov.info`.

### 3. Generate HTML report

Di Windows, paket `lcov` dari Chocolatey memasang `genhtml` sebagai script Perl. Jalankan dengan `perl`:

```powershell
perl "C:\ProgramData\chocolatey\lib\lcov\tools\bin\genhtml" coverage\lcov.info -o coverage\html
```

### 4. Buka hasil report

```powershell
start coverage\html\index.html
```

### 5. (Opsional) Cek apakah report sudah terbentuk

```powershell
Get-ChildItem coverage\html\index.html
```

### Troubleshooting

- Jika `perl` tidak dikenali:

```powershell
choco install strawberryperl
```

Tutup dan buka ulang terminal, lalu ulangi langkah generate report.

- Jika `genhtml` tidak dikenali saat dipanggil langsung (`genhtml --version`), itu normal pada setup ini. Gunakan perintah `perl ...\genhtml` seperti di atas.
