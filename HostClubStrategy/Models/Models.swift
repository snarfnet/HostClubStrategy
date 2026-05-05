import Foundation

enum Goal: String, CaseIterable, Identifiable {
    case friend = "friend"
    case boyfriend = "boyfriend"
    case marriage = "marriage"
    case exclusive = "exclusive"

    var id: String { rawValue }

    var title: String {
        switch self {
        case .friend: return "友達になりたい"
        case .boyfriend: return "彼氏になってほしい"
        case .marriage: return "結婚したい！"
        case .exclusive: return "私だけを見てほしい"
        }
    }
    var titleEN: String {
        switch self {
        case .friend: return "Just Friends"
        case .boyfriend: return "Boyfriend Mode"
        case .marriage: return "Marriage Goal"
        case .exclusive: return "Exclusive Only"
        }
    }
    var icon: String {
        switch self {
        case .friend: return "star.fill"
        case .boyfriend: return "heart.fill"
        case .marriage: return "crown.fill"
        case .exclusive: return "lock.heart.fill"
        }
    }
    var description: String {
        switch self {
        case .friend: return "まず距離を縮める段階。焦らず自然体で。"
        case .boyfriend: return "特別な存在になる作戦。感情に訴えるタイミングが鍵。"
        case .marriage: return "本気度を見せる。売掛・本指名の積み上げが必要。"
        case .exclusive: return "最高難度。No.1の心を独占する覚悟が必要。"
        }
    }
}

enum HostMood: String, CaseIterable, Identifiable {
    case warm = "warm"
    case normal = "normal"
    case cold = "cold"
    case flirty = "flirty"
    case busy = "busy"

    var id: String { rawValue }
    var label: String {
        switch self {
        case .warm: return "優しい・甘い"
        case .normal: return "普通・営業スマイル"
        case .cold: return "そっけない・冷たい"
        case .flirty: return "やたら距離が近い"
        case .busy: return "忙しそう・余裕なし"
        }
    }
    var icon: String {
        switch self {
        case .warm: return "flame.fill"
        case .normal: return "minus.circle.fill"
        case .cold: return "snowflake"
        case .flirty: return "sparkles"
        case .busy: return "clock.fill"
        }
    }
}

enum SpendingLevel: String, CaseIterable, Identifiable {
    case none = "none"
    case low = "low"
    case medium = "medium"
    case high = "high"
    case extreme = "extreme"

    var id: String { rawValue }
    var label: String {
        switch self {
        case .none: return "ほぼ使ってない"
        case .low: return "ちょっと（〜3万）"
        case .medium: return "まあまあ（3〜10万）"
        case .high: return "かなり（10〜30万）"
        case .extreme: return "本気（30万〜）"
        }
    }
}

enum VisitFrequency: String, CaseIterable, Identifiable {
    case first = "first"
    case rare = "rare"
    case monthly = "monthly"
    case weekly = "weekly"
    case regular = "regular"

    var id: String { rawValue }
    var label: String {
        switch self {
        case .first: return "初回"
        case .rare: return "たまに（月1未満）"
        case .monthly: return "月1〜2回"
        case .weekly: return "週1回"
        case .regular: return "週2回以上の常連"
        }
    }
}

struct StrategyInput {
    var goal: Goal = .friend
    var hostMood: HostMood = .normal
    var spending: SpendingLevel = .none
    var frequency: VisitFrequency = .first
    var hasLineSNS: Bool = false
    var hasPrivateMeet: Bool = false
    var calledByName: Bool = false
    var receivedGift: Bool = false
    var otherCustomersExist: Bool = true
}

struct StrategyResult {
    let timing: TimingAdvice
    let mainTip: String
    let subTips: [String]
    let warningLevel: WarningLevel
    let warningMessage: String?
}

enum TimingAdvice: String {
    case goNow = "今すぐ動け！"
    case waitMore = "もう少し待て"
    case goodTiming = "チャンスあり"
    case danger = "要注意"
}

enum WarningLevel {
    case none, caution, danger
}

struct PainfulCustomerCheck {
    struct Item: Identifiable {
        let id = UUID()
        let behavior: String
        let behaviorEN: String
        let risk: String
        let riskEN: String
        let severity: Severity

        enum Severity { case mild, serious, fatal }
    }

    static let items: [Item] = [
        Item(behavior: "連日の大量LINEや電話",
             behaviorEN: "Excessive daily messages/calls",
             risk: "ブロック→フェードアウト確定",
             riskEN: "Block and fade-out guaranteed",
             severity: .serious),
        Item(behavior: "他の客を悪く言う・嫉妬爆発",
             behaviorEN: "Badmouthing other customers",
             risk: "スタッフに共有されて出禁候補入り",
             riskEN: "Staff will flag you for potential ban",
             severity: .fatal),
        Item(behavior: "お店の外でこっそり待ち伏せ",
             behaviorEN: "Waiting outside the club secretly",
             risk: "即出禁・警察案件",
             riskEN: "Immediate ban, possible police report",
             severity: .fatal),
        Item(behavior: "「本当は好きでしょ」と詰める",
             behaviorEN: "Pressuring 'you actually like me, right?'",
             risk: "幻滅→距離を置かれる",
             riskEN: "He will create distance from you",
             severity: .serious),
        Item(behavior: "売掛（ツケ）を踏み倒す",
             behaviorEN: "Not paying your tab (running up debt)",
             risk: "出禁＋法的措置の可能性",
             riskEN: "Ban + possible legal action",
             severity: .fatal),
        Item(behavior: "SNSで店やホストの写真を無断投稿",
             behaviorEN: "Posting unauthorized photos on SNS",
             risk: "出禁・プライバシー問題",
             riskEN: "Ban for privacy violation",
             severity: .serious),
        Item(behavior: "「私のことどう思ってる？」と毎回聞く",
             behaviorEN: "Asking 'how do you feel about me?' every time",
             risk: "営業感を壊して興醒めされる",
             riskEN: "Breaks the fantasy, kills the mood",
             severity: .mild),
        Item(behavior: "酔って暴言・泣き崩れる",
             behaviorEN: "Drunk outbursts or emotional breakdowns",
             risk: "スタッフ全員に知られる・入店断り可能性",
             riskEN: "Entire staff will know, possible refusal of entry",
             severity: .serious),
        Item(behavior: "担当以外のホストに媚びを売る",
             behaviorEN: "Flirting with other hosts to make him jealous",
             risk: "嫉妬作戦は逆効果・信頼を失う",
             riskEN: "Jealousy tactics backfire badly",
             severity: .mild),
        Item(behavior: "「愛してる」「結婚して」を初期から連発",
             behaviorEN: "Declaring love or marriage from the start",
             risk: "重い客認定→避けられる",
             riskEN: "Labeled 'intense customer', he will avoid you",
             severity: .serious),
    ]
}
