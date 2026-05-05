import Foundation

enum Goal: String, CaseIterable, Identifiable {
    case friend = "friend"
    case boyfriend = "boyfriend"
    case marriage = "marriage"
    case exclusive = "exclusive"

    var id: String { rawValue }

    var title: String {
        switch self {
        case .friend: return "まずは仲良くなりたい"
        case .boyfriend: return "本命にしたい"
        case .marriage: return "将来を考えてほしい"
        case .exclusive: return "私だけを見てほしい"
        }
    }

    var titleEN: String {
        switch self {
        case .friend: return "Build Trust"
        case .boyfriend: return "Make Him Fall for Me"
        case .marriage: return "Long-Term Love"
        case .exclusive: return "Exclusive Attention"
        }
    }

    var icon: String {
        switch self {
        case .friend: return "sparkles"
        case .boyfriend: return "heart.fill"
        case .marriage: return "crown.fill"
        case .exclusive: return "lock.heart.fill"
        }
    }

    var description: String {
        switch self {
        case .friend: return "距離を縮める前段階。自然体で、また会いたいと思わせることを優先。"
        case .boyfriend: return "特別な存在になる作戦。感情を出すタイミングと余白づくりが鍵。"
        case .marriage: return "長期目線で信頼を積む作戦。重さより安定感と生活感の見せ方が大切。"
        case .exclusive: return "競合の中で印象を残す作戦。追いすぎず、希少性と安心感の両立が必要。"
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
        case .warm: return "笑顔多め"
        case .normal: return "普通"
        case .cold: return "そっけない"
        case .flirty: return "ヤキモチ"
        case .busy: return "忙しそう"
        }
    }

    var icon: String {
        switch self {
        case .warm: return "face.smiling.fill"
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
        case .none: return "ほぼ使っていない"
        case .low: return "少しだけ"
        case .medium: return "ほどほど"
        case .high: return "かなり使っている"
        case .extreme: return "本命級に使っている"
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
        case .rare: return "たまに"
        case .monthly: return "月1〜2回"
        case .weekly: return "週1回"
        case .regular: return "週2回以上"
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
    case goNow = "今すぐアプローチ！"
    case waitMore = "もう少し待って"
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
        Item(behavior: "連日の長文LINEや電話",
             behaviorEN: "Excessive daily messages/calls",
             risk: "返信負荷が上がり、距離を置かれやすい",
             riskEN: "High reply pressure causes fade-out",
             severity: .serious),
        Item(behavior: "他のお客様の悪口を言う",
             behaviorEN: "Badmouthing other customers",
             risk: "スタッフ間で警戒され、出禁候補になりやすい",
             riskEN: "Staff will flag you for potential ban",
             severity: .fatal),
        Item(behavior: "お店の外で待ち伏せする",
             behaviorEN: "Waiting outside the club secretly",
             risk: "即出禁や警察相談につながる可能性",
             riskEN: "Immediate ban, possible police report",
             severity: .fatal),
        Item(behavior: "本当は好きでしょ？と詰める",
             behaviorEN: "Pressuring his feelings",
             risk: "営業の余白が消え、心理的距離を置かれる",
             riskEN: "He will create distance from you",
             severity: .serious),
        Item(behavior: "売掛や支払いを軽く見る",
             behaviorEN: "Not paying your tab",
             risk: "信用低下、出禁、法的対応の可能性",
             riskEN: "Ban + possible legal action",
             severity: .fatal),
        Item(behavior: "無断で写真や店情報をSNS投稿",
             behaviorEN: "Posting unauthorized photos on SNS",
             risk: "プライバシー問題で強く警戒される",
             riskEN: "Ban for privacy violation",
             severity: .serious),
        Item(behavior: "私のことどう思ってる？を毎回聞く",
             behaviorEN: "Asking his feelings every time",
             risk: "空気が重くなり、会話の楽しさが落ちる",
             riskEN: "Breaks the fantasy, kills the mood",
             severity: .mild),
        Item(behavior: "酔って暴言や泣き崩れをする",
             behaviorEN: "Drunk outbursts or breakdowns",
             risk: "店全体に共有され、入店しづらくなる",
             riskEN: "Entire staff will know",
             severity: .serious),
        Item(behavior: "嫉妬させるため他ホストに過剰接近",
             behaviorEN: "Flirting with other hosts for jealousy",
             risk: "駆け引きが見えすぎて信頼を失いやすい",
             riskEN: "Jealousy tactics backfire badly",
             severity: .mild),
        Item(behavior: "最初から好き、結婚してを連発",
             behaviorEN: "Declaring love or marriage from the start",
             risk: "重いお客様認定され、避けられやすい",
             riskEN: "Labeled intense, he will avoid you",
             severity: .serious)
    ]
}
