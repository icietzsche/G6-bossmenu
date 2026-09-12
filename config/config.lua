Config = {}

-- ===============================================================
-- G6 STUDIO - BOSS MENU CONFIGURATION
-- ===============================================================

-- Altyapı / Framework Seçimi: 'qb' | 'qbox' | 'esx'
Config.Framework = 'qbox'

-- Dil Seçimi: 'tr' | 'en' (locales/ klasörü altındaki dosyalar)
Config.Locale = 'tr'

-- Etkileşim Türü: 'textui' (Marker + Tuş) veya 'target' (Göz ile etkileşim)
Config.InteractionType = 'textui'

-- TextUI Entegrasyonu (Config.InteractionType = 'textui' ise geçerlidir)
-- Seçenekler: 'ox_lib' | 'qb-core' | 'esx_textui' | 'drawtext3d'
Config.TextUI = 'ox_lib'

-- Target Entegrasyonu (Config.InteractionType = 'target' ise geçerlidir)
-- Seçenekler: 'ox_target' | 'qb-target'
Config.Target = 'ox_target'

-- Bildirim Sistemi Seçimi: 'ox_lib' | 'qb-core' | 'esx'
Config.Notify = 'ox_lib'

-- Bankacılık Sistemi Seçimi
-- Seçenekler: 'okokBanking' | 'qb-banking' | 'ox_banking' | 'renewed'
Config.Banking = 'okokBanking'

-- Menüyü açacak komut (İsteğe bağlı, boş bırakılırsa kapatılır: "")
Config.OpenCommand = "bossmenu"

-- Para birimi simgesi (UI tarafında bakiye kısmında görünür)
Config.Currency = "$"

-- İşe alım sırasında oyuncu ile hedef arasındaki maksimum mesafe (Metre)
Config.HireDistance = 5.0

-- Yetki Kontrolü: Menüyü sadece işletme patronları (isboss) mı açabilsin?
Config.CheckBoss = true

-- Discord Webhook Log Sistemi (Boş bırakılırsa webhook gönderilmez)
Config.WebhookURL = ""

-- Gelişmiş Konsol Loglama (Geliştirici modu)
Config.Debug = false

-- ===============================================================
-- BOSS MENÜ NOKTALARI VE İŞLETME TANIMLARI
-- ===============================================================
Config.BossMenuLocations = {
    {
        coords = vector3(-346.95, -131.93, 42.04),
        job = "mekanik1",
        label = "LS Custom Boss Menü"
    },
    {
        coords = vector3(-196.87, -1315.83, 31.30),
        job = "mekanik2",
        label = "Benny's Boss Menü"
    },
    {
        coords = vector3(886.81, -2100.75, 34.89),
        job = "mekanik3",
        label = "East Mekanik Boss Menü"
    },
    {
        coords = vector3(1135.70, -782.79, 57.60),
        job = "mekanik4",
        label = "Auto Shop Boss Menü"
    },
    {
        coords = vector3(124.77, -3014.17, 7.04),
        job = "mekanik5",
        label = "6str Boss Menü"
    },
    {
        coords = vector3(-605.90, -918.80, 23.89),
        job = "mekanik6",
        label = "Redline Boss Menü"
    },
    {
        coords = vector3(-596.90, -1053.30, 22.34),
        job = "catcafe",
        label = "Cat Cafe Boss Menü"
    },
    {
        coords = vector3(830.08, -117.55, 80.43),
        job = "irishpub",
        label = "Irish Pub Boss Menü"
    },
    {
        coords = vector3(-1198.14, -897.64, 13.80),
        job = "burgershot",
        label = "Burgershot Boss Menü"
    },
    {
        coords = vector3(7.77, -1605.92, 29.39),
        job = "taco",
        label = "Taco Boss Menü"
    },
    {
        coords = vector3(550.78, 110.62, 96.55),
        job = "pizzathis",
        label = "Pizza This Boss Menü"
    },
    {
        coords = vector3(-561.88, 281.60, 85.68),
        job = "tequila",
        label = "Tequila Boss Menü"
    },
    {
        coords = vector3(-1840.11, -1182.79, 14.31),
        job = "pearl",
        label = "Pearl Boss Menü"
    },
    {
        coords = vector3(737.64, -1127.61, 26.01),
        job = "fightclub",
        label = "Fight Club Boss Menü"
    },
    {
        coords = vector3(1238.31, -348.80, 69.08),
        job = "hornys",
        label = "Horny's Boss Menü"
    },
    {
        coords = vector3(334.16, -811.11, 29.29),
        job = "lastlight",
        label = "Last Light Boss Menü"
    },
    {
        coords = vector3(-1368.90, -626.20, 30.36),
        job = "bahama",
        label = "Bahama Boss Menü"
    },
    {
        coords = vector3(-627.71, 224.01, 81.88),
        job = "beanmachine",
        label = "Bean Machine Boss Menü"
    },
    {
        coords = vector3(-1375.44, -928.70, 9.99),
        job = "suncafe",
        label = "Sun Cafe Boss Menü"
    },
    {
        coords = vector3(338.00, 215.80, 101.47),
        job = "thepalace",
        label = "The Palace Boss Menü"
    },
    {
        coords = vector3(1986.69, 3046.98, 47.22),
        job = "yellowjack",
        label = "Yellow Jack Boss Menü"
    },
    {
        coords = vector3(95.71, -1294.23, 29.26),
        job = "unicorn",
        label = "Unicorn Boss Menü"
    },
    {
        coords = vector3(-816.55, -696.44, 32.14),
        job = "wuchang",
        label = "Wu Chang Boss Menü"
    },
    {
        coords = vector3(-1383.48, -661.96, 24.78),
        job = "threehawkerboys",
        label = "Three Hawker Boss Menü"
    },
}