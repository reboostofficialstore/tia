Current Status
Check docs/latest-progress.md untuk status terkini.

---

## 📄 **2. docs/AI-CONTEXT.md** (FILE UTAMA UNTUK AI)
```markdown
# 🤖 AI CONTEXT - BACA INI DULU!

## UNTUK SETIAP AI YANG BEKERJA DI PROJECT INI

### 📋 LANGKAH PERTAMA (WAJIB):
1. **BACA FILE INI SAMPAI SELESAI** ← Anda di sini
2. Baca `information.md` untuk detail project
3. Baca `latest-progress.md` untuk status terkini
4. Baca `instructions.md` untuk panduan coding
5. **UPDATE `latest-progress.md` setelah selesai kerja**

---

## 🎯 PROJECT OVERVIEW SINGKAT

**Apa ini?**: Platform link-in-bio seperti Linktree untuk Content Creator & Brand
**Tech**: Next.js 14 + Supabase + Tailwind CSS
**Target**: Secepatnya jadi, quality tinggi
**Model**: Freemium (Basic free, Pro $5/month)

---

## 🚨 ATURAN WAJIB

### KEAMANAN (CRITICAL):
- ❌ **JANGAN PERNAH** hardcode API keys atau secrets
- ✅ **SELALU** sanitasi & validasi input
- ✅ **SELALU** gunakan .env untuk config
- ✅ **SELALU** implementasi rate limiting

### DEVELOPMENT:
- ❌ **JANGAN** panggil database langsung dari frontend
- ✅ **SELALU** gunakan API routes (`/api/`)
- ✅ **SELALU** gunakan TypeScript
- ✅ **SELALU** responsive design

### DOKUMENTASI:
- ✅ **WAJIB** update `latest-progress.md` setiap session
- ✅ **SELALU** dokumentasikan perubahan penting
- ✅ **JANGAN** mulai kerja tanpa baca progress terakhir

---

## 🎯 CURRENT PRIORITY

**FASE SEKARANG**: Foundation - Public Pages & Authentication

**URUTAN KERJA**:
1. Landing page responsive (Hero, Features, CTA, Footer)
2. Authentication system (Register, Login, Verify, Complete)
3. Dashboard basic (Header, Sidebar, Profile form)
4. Social link management
5. Custom link management
6. Public profile pages
7. Analytics basic

---

## 📁 FILE PENTING LAINNYA

- `information.md` → Detail lengkap project & requirements
- `instructions.md` → Panduan coding & best practices  
- `structure.md` → Organisasi file & folder
- `latest-progress.md` → Status terkini & progress
- `database-schema.md` → Struktur database Supabase
- `api-endpoints.md` → Dokumentasi API routes

---

## 🔄 WORKFLOW STANDARD

### SEBELUM MULAI:
1. Baca `latest-progress.md` → Apa yang sudah dikerjakan?
2. Cek current priority → Apa yang harus dikerjakan?
3. Review files terkait → Pahami konteksnya

### SAAT BEKERJA:
1. Follow struktur folder yang sudah ditetapkan
2. Gunakan TypeScript untuk semua code
3. Implement responsive design
4. Handle error dengan baik

### SETELAH SELESAI:
1. **WAJIB** update `latest-progress.md`
2. Dokumentasikan file yang dibuat/diubah
3. Note issues atau blockers yang ditemukan
4. Siapkan context untuk AI selanjutnya

---

## 🚨 RED FLAGS - LANGSUNG TANYA!

Jika menemukan hal ini, TANYA USER dulu:
- Requirements yang bertentangan
- Package yang tidak kompatibel
- Kebutuhan mengubah arsitektur
- Data sensitif yang perlu di-handle

---

## 💡 QUICK DECISIONS

Bisa langsung implement tanpa tanya:
- Bug fixes
- UI improvements
- Performance optimizations
- Code refactoring (selama tidak breaking)

---

## 📞 CONTACT WORKFLOW

**Format komunikasi dengan user**:
🎯 STATUS: [Apa yang sedang dikerjakan]
✅ COMPLETED: [Apa yang sudah selesai]
🔄 IN PROGRESS: [Apa yang sedang dikerjakan]
❓ NEED INPUT: [Apa yang perlu ditanyakan]
📋 NEXT: [Apa yang akan dikerjakan selanjutnya]

---

## 🎯 SUCCESS METRICS

**Setiap session harus menghasilkan**:
- Progress yang terukur (fitur selesai/file baru)
- Documentation yang updated
- Code yang bersih & tested
- Ready untuk AI selanjutnya

---

**INGAT**: Project ini dibangun 100% dengan AI. Consistency dan documentation adalah kunci sukses!

**SEKARANG**: Lanjut baca file dokumentasi lainnya dan mulai coding! 🚀