<div align="center">
  <h1>🏢 G6 Studio — Advanced Boss Menu</h1>
  <p><strong>Çoklu Framework Desteği • Yüksek Performans • Evrensel Bridge Altyapısı • Güvenli & Optimize</strong></p>
  <p>
    <img src="https://img.shields.io/badge/Author-icietzsche%20Development-blue.svg" alt="Author">
    <img src="https://img.shields.io/badge/Version-1.0-brightgreen.svg" alt="Version">
    <img src="https://img.shields.io/badge/Framework-ESX%20%7C%20QBCore%20%7C%20QBox-orange.svg" alt="Framework">
    <img src="https://img.shields.io/badge/Resmon-0.00ms-success.svg" alt="Resmon">
  </p>
</div>

---

## TURKCE

## 📖 Genel Bakış

**G6 Boss Menu**, FiveM sunucularında işletme yönetimini bir üst seviyeye taşımak üzere **G6 Studio** ve **icietzsche Development** standartlarında geliştirilmiş, tam modüler ve modern bir patron yönetim sistemidir.

Kullanıcı dostu şık arayüzü sayesinde işletme sahipleri; çalışanlarını kolaylıkla yönetebilir, çevrimdışı dahi olsa çalışanların rütbelerini güncelleyebilir veya işten çıkarabilir, işletme kasasından güvenli biçimde para yatırıp çekebilirler. Sunucu sahiplerine config, dil ve bridge katmanlarını istedikleri gibi özelleştirme özgürlüğü tanır.

---

## ✨ Özellikler

- 🌐 **Evrensel Framework Desteği (Bridge):** `ESX`, `QBCore` ve `QBox` altyapılarını tek bir ayarla sorunsuz destekler.
- 🎯 **Gelişmiş Etkileşim Seçenekleri:**
  - **Target:** `ox_target` ve `qb-target` ile sıfır resmon etkileşimi.
  - **TextUI:** `ox_lib`, `qb-core`, `esx_textui` ve `drawtext3d` desteği.
- 🏦 **Genişletilmiş Bankacılık Entegrasyonu:**
  - `okokBanking`
  - `qb-banking` / `qb-management`
  - `ox_banking`
  - `Renewed-Banking`
- 🛡️ **Gelişmiş Anti-Exploit & Güvenlik:**
  - Sunucu taraflı yetki (`isboss`) doğrulaması.
  - İşe alımlarda koordinat ve mesafe kontrolü (distance check).
  - Kendini işten çıkarma veya kendi rütbesini değiştirme engeli.
  - Para yatırma / çekme işlemlerinde negatif değer, spam ve exploit koruması.
  - Paket suistimaline karşı işlem bekleme süresi (cooldown/rate-limit).
- ⚡ **Ultra Performans (Resmon):**
  - Boşta (idle) **0.00ms - 0.01ms** çalışma garantisi.
  - Target modunda 0.00ms resmon tüketimi.
- 🌍 **Çoklu Dil Desteği (Locales):**
  - Türkçe (`tr`) ve İngilizce (`en`) tam dil desteği.
- 📊 **Kapsamlı Log & Webhook Sistemi:**
  - Discord Webhook üzerinden renk kodlu zengin embed logları (İşe alma, çıkarma, rütbe, para hareketleri).
  - Sunucu konsolu için geliştirici debug modu.
- 👥 **Çevrimdışı Çalışan Yönetimi:**
  - Oyuncu sunucuda olmasa bile veritabanı üzerinden güvenli rütbe güncelleme ve işten çıkarma.

---

## 📦 Bağımlılıklar (Dependencies)

### 🔴 Zorunlu (Gerekli)
- [`oxmysql`](https://github.com/overextended/oxmysql) (Veritabanı işlemleri için)

### 🟡 Altyapıya Göre Desteklenen Sistemler (Config'den Seçilebilir)
| Kategori | Desteklenen Eklentiler |
| :--- | :--- |
| **Framework** | `qbx_core`, `qb-core`, `es_extended` |
| **Hedefleme (Target)** | `ox_target`, `qb-target` |
| **Arayüz (TextUI)** | `ox_lib`, `qb-core`, `esx_textui`, `drawtext3d` |
| **Bildirim (Notify)** | `ox_lib`, `qb-core`, `esx` |
| **Banka (Banking)** | `okokBanking`, `qb-banking`, `ox_banking`, `Renewed-Banking` |

---

## 🚀 Hızlı Başlangıç & Kurulum

1. Satın aldığınız veya indirdiğiniz `G6-bossmenu` klasörünü sunucunuzun `resources/` dizinine yerleştirin.
2. `server.cfg` dosyanızı açın ve scripti ensure edin:
   ```cfg
   ensure G6-bossmenu
   ```
3. `config/config.lua` dosyasını açarak sunucunuza uygun ayarları seçin:
   ```lua
   Config.Framework = 'qbox'         -- 'qbox', 'qb' veya 'esx'
   Config.InteractionType = 'textui' -- 'textui' veya 'target'
   Config.TextUI = 'ox_lib'          -- 'ox_lib', 'qb-core', 'esx_textui', 'drawtext3d'
   Config.Target = 'ox_target'       -- 'ox_target', 'qb-target'
   Config.Banking = 'okokBanking'    -- 'okokBanking', 'qb-banking', 'ox_banking', 'renewed'
   Config.Notify = 'ox_lib'          -- 'ox_lib', 'qb-core', 'esx'
   Config.Locale = 'tr'              -- 'tr' veya 'en'
   Config.WebhookURL = "WEBHOOK_LINKINIZ"
   ```
4. Sunucunuzu başlatın veya konsoldan `refresh` ardından `start G6-bossmenu` komutunu çalıştırın.

---

## ⌨️ Komutlar & Kullanım

| Komut | Açıklama | Varsayılan Yetki |
| :--- | :--- | :--- |
| `/bossmenu` | İşletme patron menüsünü açar. | Sadece İlgili Mesleğin Patronu |

> **Not:** `Config.OpenCommand = ""` yapılarak komut kapatılabilir ve menü yalnızca belirlenen koordinatlardan (Marker/TextUI veya Target ile) açılabilir.

---

## 📂 Dosya Yapısı

Script, Tebex satış standartlarına ve müşteri memnuniyetini gözetilerek yapılandırılmıştır:

```
G6-bossmenu/
├── fxmanifest.lua
├── README.md
├── config/
│   └── config.lua
├── locales/
│   ├── tr.lua
│   └── en.lua
├── bridge/
│   ├── loader.lua
│   ├── framework/
│   ├── target/
│   ├── textui/
│   ├── notify/
│   └── banking/
├── client/
│   └── client.lua
├── server/
│   └── server.lua
└── ui/
    ├── index.html
    ├── style.css
    └── script.js
```






















## ENGLISH

## 📖 Overview

**G6 Boss Menu** is a fully modular and modern boss management system developed to the standards of **G6 Studio** and **icietzsche Development** to take business management on FiveM servers to the next level.

Thanks to its user-friendly, sleek interface, business owners can easily manage their employees, update employee ranks, or terminate employees—even when offline—and securely deposit and withdraw funds from the business’s cash register. It gives server owners the freedom to customize the configuration, language, and bridge layers as they see fit.

---

## ✨ Features

- 🌐 **Universal Framework Support (Bridge):** Seamlessly supports `ESX`, `QBCore`, and `QBox` infrastructures with a single configuration.
- 🎯 **Advanced Interaction Options:**
  - **Target:** Zero resmon interaction with `ox_target` and `qb-target`.
  - **TextUI:** Support for `ox_lib`, `qb-core`, `esx_textui`, and `drawtext3d`.
- 🏦 **Extended Banking Integration:**
  - `okokBanking`
  - `qb-banking` / `qb-management`
  - `ox_banking`
  - `Renewed-Banking`
- 🛡️ **Advanced Anti-Exploit & Security:**
  - Server-side permission (`isboss`) verification.
  - Coordinate and distance checks during recruitment.
  - Prevention of self-firing or changing one’s own rank.
  - Protection against negative values, spam, and exploits in deposit/withdrawal transactions.
  - Transaction cooldown/rate-limit to prevent package abuse.
- ⚡ **Ultra Performance (Resmon):**
  - Guaranteed **0.00ms - 0.01ms** idle response time.
  - 0.00ms resmon consumption in Target mode.
- 🌍 **Multi-Language Support (Locales):**
  - Full language support for Turkish (`tr`) and English (`en`).
- 📊 **Comprehensive Log & Webhook System:**
  - Color-coded, rich embed logs via Discord Webhook (hiring, firing, rank, and financial transactions).
  - Developer debug mode for the server console.
- 👥 **Offline Player Management:**
  - Secure rank updates and dismissals via the database, even when the player is not on the server.

---

## 📦 Dependencies

### 🔴 Required
- [`oxmysql`](https://github.com/overextended/oxmysql) (For database operations)

### 🟡 Systems Supported by Infrastructure (Selectable via Config)
| Category | Supported Plugins |
| :--- | :--- |
| **Framework** | `qbx_core`, `qb-core`, `es_extended` |
| **Targeting** | `ox_target`, `qb-target` |
| **Text UI** | `ox_lib`, `qb-core`, `esx_textui`, `drawtext3d` |
| **Notification (Notify)** | `ox_lib`, `qb-core`, `esx` |
| **Banking** | `okokBanking`, `qb-banking`, `ox_banking`, `Renewed-Banking` |

---

## 🚀 Quick Start & Setup

1. Place the `G6-bossmenu` folder you purchased or downloaded into your server’s `resources/` directory.
2. Open your `server.cfg` file and ensure the script:
   ```cfg
   ensure G6-bossmenu
   ```
3. Open the `config/config.lua` file and select the settings appropriate for your server:
   ```lua
   Config.Framework = ‘qbox’         -- ‘qbox’, ‘qb’, or 'esx'
   Config.InteractionType = ‘textui’ -- ‘textui’ or ‘target’
   Config.TextUI = ‘ox_lib’          -- ‘ox_lib’, ‘qb-core’, ‘esx_textui’, ‘drawtext3d’
   Config.Target = ‘ox_target’       -- ‘ox_target’, 'qb-target'
   Config.Banking = ‘okokBanking’    -- ‘okokBanking’, ‘qb-banking’, ‘ox_banking’, ‘renewed’
   Config.Notify = ‘ox_lib’          -- ‘ox_lib’, ‘qb-core’, 'esx'
   Config.Locale = ‘tr’              -- ‘tr’ or ‘en’
   Config.WebhookURL = “YOUR_WEBHOOK_LINK”
   ```
4. Start your server or run the `refresh` command followed by `start G6-bossmenu` from the console.

---

## ⌨️ Commands & Usage

| Command | Description | Default Permission |
| :--- | :--- | :--- |
| `/bossmenu` | Opens the business boss menu. | Only the Boss of the Relevant Profession |

> **Note:** The command can be disabled by setting `Config.OpenCommand = “”`, and the menu can only be opened from specified coordinates (via Marker/TextUI or Target).

---

## 📂 File Structure

The script is structured in accordance with Tebex sales standards and with customer satisfaction in mind:

```
G6-bossmenu/
├── fxmanifest.lua
├── README.md
├── config/
│   └── config.lua
├── locales/
│   ├── tr.lua
│   └── en.lua
├── bridge/
│   ├── loader.lua
│   ├── framework/
│   ├── target/
│   ├── textui/
│   ├── notify/
│   └── banking/
├── client/
│   └── client.lua
├── server/
│   └── server.lua
└── ui/
    ├── index.html
    ├── style.css
    └── script.js
```

---

<div align="center">
  <p>© 2026 <strong>G6 Studio & icietzsche Development</strong>. Tüm hakları saklıdır.</p>
</div>