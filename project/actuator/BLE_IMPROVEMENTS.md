# Perbaikan Koneksi BLE Actuator

## Masalah Sebelumnya
- Koneksi BLE hanya terjadi sekali di awal
- Ketika mengirim value dari server dashboard, muncul error "BLE not connected"
- Event loop dibuat dan ditutup setiap kali ada command, menyebabkan koneksi terputus
- Tidak ada mekanisme reconnect yang proper

## Solusi yang Diterapkan

### 1. Persistent Event Loop
- Event loop sekarang dibuat sekali dan dipertahankan selama aplikasi berjalan
- Tidak ada lagi pembuatan dan penutupan event loop berulang kali
- Menggunakan `_event_loop` sebagai class variable yang persistent

### 2. Thread Safety
- Menambahkan `threading.Lock()` untuk memastikan thread safety
- Mencegah race condition ketika multiple thread mengakses BLE connection
- Menggunakan `with ActuatorBLE._lock:` untuk mengamankan operasi BLE

### 3. Automatic Reconnection
- Menambahkan fungsi `_reconnect_ble()` untuk reconnect otomatis
- Ketika koneksi terputus, sistem akan mencoba reconnect secara otomatis
- Reset connection state dan reinitialize jika diperlukan

### 4. Connection State Management
- Menambahkan `device_name` ke BLE controller untuk memudahkan reconnect
- Check connection status sebelum mengirim command
- Proper error handling untuk connection loss

### 5. Improved Error Handling
- Check `client.is_connected` sebelum mengirim command
- Mark connection sebagai disconnected jika terjadi error
- Lebih robust dalam menangani berbagai jenis error

## Cara Kerja Baru

1. **Initialization**: Saat pertama kali dipanggil, sistem akan:
   - Membuat persistent event loop
   - Scan dan connect ke BLE device
   - Menyimpan connection state

2. **Command Execution**: Setiap kali ada command:
   - Check apakah masih connected
   - Jika tidak, coba reconnect otomatis
   - Kirim command menggunakan connection yang ada
   - Gunakan lock untuk thread safety

3. **Reconnection**: Jika koneksi terputus:
   - Reset connection state
   - Reinitialize dengan device name yang sama
   - Coba connect ulang

## Testing

Gunakan file `test_ble_connection.py` untuk test:
```bash
python3 test_ble_connection.py
```

Test ini akan:
- Test initial connection
- Test multiple commands dengan connection yang sama
- Test reconnect setelah delay
- Verify bahwa connection tetap persistent

## Keuntungan

1. **Persistent Connection**: Koneksi BLE tetap hidup antar command
2. **Automatic Recovery**: Reconnect otomatis jika koneksi terputus
3. **Thread Safe**: Aman untuk digunakan dalam multi-thread environment
4. **Better Performance**: Tidak perlu setup connection baru setiap kali
5. **Robust Error Handling**: Lebih baik dalam menangani berbagai error scenario

## Catatan Penting

- Pastikan BLE device tetap dalam range dan powered on
- Jika device disconnect secara fisik, sistem akan mencoba reconnect
- Disconnect manual bisa dilakukan dengan `ActuatorBLE.disconnect()`
- Event loop akan tetap hidup sampai aplikasi berakhir atau manual disconnect
