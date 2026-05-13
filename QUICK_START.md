# Quick Start - API Settings

## 🚀 Getting Started (30 seconds)

### Step 1: Access Settings
1. Run your Flutter app and go to **Login Screen**
2. **Tap the logo 5 times rapidly** (within 3 seconds)
3. **API Settings Screen** opens

### Step 2: Configure URL
1. Clear the **Base URL** field
2. Enter your API server: `http://YOUR_IP:8000/api`
3. Clear the **Image URL** field  
4. Enter: `http://YOUR_IP:8000/`
5. Click **Save**

### Step 3: Done!
- App now uses your custom URLs
- All API calls will go to the new server
- Settings persist across app restarts

---

## 🎯 Common URLs

### Local Mac (Replace with your actual IP)
```
Base URL:  http://192.168.x.x:8000/api
Image URL: http://192.168.x.x:8000/
```

### Android Emulator
```
Base URL:  http://10.0.2.2:8000/api
Image URL: http://10.0.2.2:8000/
```

### iOS Simulator (Mac)
```
Base URL:  http://localhost:8000/api
Image URL: http://localhost:8000/
```

### Production
```
Base URL:  https://your-api.com/api
Image URL: https://your-api.com/
```

---

## 🔄 Reset to Defaults
1. Tap logo 5 times → Settings screen
2. Click **Reset** button
3. Confirm reset
4. App returns to hardcoded defaults

---

## ❓ Troubleshooting

**Settings screen not opening?**
- Ensure you tap exactly 5 times
- Must be within 3 seconds
- Tap should be on the logo image

**API still using old URL?**
- Close and reopen the app
- Clear app cache: `flutter clean` then `flutter run`
- Verify URLs are saved (should see them in settings)

**Getting connection errors?**
- Check if your server is running
- Verify the IP address is correct
- Ensure both URLs are complete (include http:// or https://)
- For emulator, use 10.0.2.2 not localhost

---

## 📝 What Changed?

The following API endpoints now use your custom URL:
- ✅ Login
- ✅ Menu/Food items
- ✅ Tables
- ✅ Tax calculation
- ✅ Order submission
- ✅ Order status (pending/complete)
- ✅ Dashboard stats

---

**Need Help?** Check `IP_SETTINGS_GUIDE.md` for detailed documentation.

