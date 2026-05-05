import Foundation

enum AttachmentStyle: String, CaseIterable, Identifiable {
    case secure = "secure"
    case anxious = "anxious"
    case avoidant = "avoidant"
    case fearful = "fearful"

    var id: String { rawValue }

    var label: String {
        switch self {
        case .secure: return "安定型"
        case .anxious: return "不安型"
        case .avoidant: return "回避型"
        case .fearful: return "恐れ型"
        }
    }

    var description: String {
        switch self {
        case .secure: return "安心感があり、誠実で信頼できる"
        case .anxious: return "寂しがりで、不安を感じやすい"
        case .avoidant: return "距離を置きたがり、感情表現が少ない"
        case .fearful: return "人を信じたいけど、傷つくのが怖い"
        }
    }

    var strategy: String {
        switch self {
        case .secure: return "駆け引きより素直さが刺さるタイプ。感謝や楽しかった気持ちを短く伝え、次に会う理由を自然に残して。"
        case .anxious: return "安心材料に反応しやすいタイプ。急に詰めず、短い肯定をこまめに入れて、返信は焦らしすぎないのが有効。"
        case .avoidant: return "追われるほど逃げやすいタイプ。予定や感情を押しつけず、軽い余韻だけ残して相手から来る余白を作って。"
        case .fearful: return "信頼構築に時間がかかるタイプ。急接近より、秘密を守る、否定しない、約束を破らないの積み重ねが強い。"
        }
    }

    var warningSign: String {
        switch self {
        case .secure: return "重い確認や試し行動が増えると一気に引かれる。"
        case .anxious: return "依存に見えるほど連絡すると、安心より負担が勝つ。"
        case .avoidant: return "追いかけすぎると消える。距離感が命。"
        case .fearful: return "裏切りを感じると完全に閉じる。信頼を最優先に。"
        }
    }
}

struct PsychologyTactic: Identifiable {
    let id = UUID()
    let name: String
    let nameEN: String
    let theory: String
    let howTo: String
    let caution: String
    let effectiveness: Int
}

enum PsychologyEngine {
    static let allTactics: [PsychologyTactic] = [
        PsychologyTactic(
            name: "ミラーリング",
            nameEN: "Mirroring",
            theory: "相手のテンポ、言葉選び、リアクションに自然に合わせると親近感が生まれやすい。",
            howTo: "話す速度や声量を少し合わせる。彼が使った言葉を一度だけ拾い、同じ空気で返す。",
            caution: "真似している感が出ると逆効果。少しだけ、自然に。",
            effectiveness: 5
        ),
        PsychologyTactic(
            name: "希少性の原理",
            nameEN: "Scarcity Principle",
            theory: "いつでも手に入るものより、少しだけ届きにくいものの価値は高く見えやすい。",
            howTo: "来店や連絡を詰めすぎず、予定のある生活感を見せる。会えた時間の濃さで印象を残す。",
            caution: "空けすぎると忘れられる。頻度よりリズムを大切に。",
            effectiveness: 4
        ),
        PsychologyTactic(
            name: "単純接触効果",
            nameEN: "Mere Exposure Effect",
            theory: "ほどよい接触回数が増えるほど安心感と好意が育ちやすい。",
            howTo: "短い連絡、自然な来店、名前を呼ぶ回数を積み上げる。長文より軽い接点を重ねる。",
            caution: "接触しすぎると新鮮さが落ちる。余白とセットで使う。",
            effectiveness: 4
        ),
        PsychologyTactic(
            name: "吊り橋効果",
            nameEN: "Suspension Bridge Effect",
            theory: "特別な日や少し緊張する場面の高揚感は、恋愛感情として記憶に残りやすい。",
            howTo: "誕生日、イベント、サプライズ後など感情が動く日に、感謝や好意を短く伝える。",
            caution: "普通の日に無理やり演出しても弱い。場面選びが大事。",
            effectiveness: 3
        ),
        PsychologyTactic(
            name: "自己開示の返報性",
            nameEN: "Self-Disclosure Reciprocity",
            theory: "少しだけ本音を見せると、相手も内側を見せたくなりやすい。",
            howTo: "重すぎない弱さや夢を一つだけ話す。聞いてくれてうれしい、で締めると余韻が残る。",
            caution: "悩み相談を長くしすぎると負担になる。明るい出口を用意する。",
            effectiveness: 4
        ),
        PsychologyTactic(
            name: "ゲインロス効果",
            nameEN: "Gain-Loss Effect",
            theory: "最初より評価が上がったと感じると、好意の伸び幅が印象に残りやすい。",
            howTo: "最初は控えめに、後半で素直な褒めや笑顔を出す。変化を彼に感じさせる。",
            caution: "冷たくしすぎるとただの脈なしに見える。柔らかい温度差に留める。",
            effectiveness: 4
        )
    ]

    static func recommendTactics(for input: StrategyInput, attachmentStyle: AttachmentStyle) -> [PsychologyTactic] {
        var names: [String] = []

        switch attachmentStyle {
        case .secure:
            names += ["ミラーリング", "吊り橋効果"]
        case .anxious:
            names += ["自己開示の返報性", "単純接触効果"]
        case .avoidant:
            names += ["希少性の原理", "ゲインロス効果"]
        case .fearful:
            names += ["ミラーリング", "自己開示の返報性"]
        }

        switch input.goal {
        case .friend:
            names += ["単純接触効果", "ミラーリング"]
        case .boyfriend:
            names += ["吊り橋効果", "ゲインロス効果"]
        case .marriage:
            names += ["自己開示の返報性", "単純接触効果"]
        case .exclusive:
            names += ["希少性の原理", "ゲインロス効果"]
        }

        var seen = Set<String>()
        let orderedNames = names.filter { seen.insert($0).inserted }
        return orderedNames.compactMap { name in allTactics.first { $0.name == name } }
    }

    static func analyzeStrategy(input: StrategyInput, attachmentStyle: AttachmentStyle) -> StrategyResult {
        var score = 0
        var tips: [String] = []
        var warningMsg: String?
        var warningLevel: WarningLevel = .none

        switch input.hostMood {
        case .warm: score += 3
        case .flirty: score += 2
        case .normal: break
        case .cold: score -= 2
        case .busy: score -= 1
        }

        switch input.spending {
        case .none: score -= 1
        case .low: score += 1
        case .medium: score += 2
        case .high: score += 3
        case .extreme: score += 4
        }

        switch input.frequency {
        case .first:
            score += 1
            tips.append("初回は印象づくりが最優先。好意よりも「また話したい」を残して。")
        case .rare:
            score -= 1
            tips.append("接点が少なめ。まずは月1〜2回の安定したリズムを作ると強いです。")
        case .monthly:
            score += 1
        case .weekly:
            score += 2
        case .regular:
            score += 3
            tips.append("常連としての土台はあり。次は特別感を少しだけ上げる段階。")
        }

        if input.hasLineSNS {
            score += 2
            tips.append("LINE/SNSがあるなら、短く軽い連絡で存在感を残すのが有効。")
        }
        if input.hasPrivateMeet {
            score += 3
            tips.append("店外で会えているなら本命フラグ強め。焦らず次の一手を丁寧に。")
        }
        if input.calledByName {
            score += 1
            tips.append("名前で呼ばれているのは親密度アップのサイン。自然に受け取って。")
        }
        if input.receivedGift {
            score += 2
            tips.append("贈り物をもらったなら、次はあなたから小さな返報を。")
        }
        if !input.otherCustomersExist {
            score += 2
            tips.append("競合感が少ない今はチャンス。会話の質で差をつけて。")
        }

        if attachmentStyle == .avoidant && input.frequency == .regular {
            score -= 2
            warningMsg = "回避型に高頻度接触は逆効果になりやすいです。少し引いて余白を作って。"
            warningLevel = .caution
        }
        if attachmentStyle == .anxious && input.hasLineSNS {
            tips.append("不安型は反応速度に敏感。返信を遅らせる駆け引きは控えめに。")
        }

        switch input.goal {
        case .friend: break
        case .boyfriend: score -= 1
        case .marriage: score -= 3
        case .exclusive: score -= 5
        }

        let timing: TimingAdvice
        if score >= 8 {
            timing = .goNow
            tips.append("今が最も動きやすいタイミング。感情は短く、明るく伝えて。")
        } else if score >= 4 {
            timing = .goodTiming
            tips.append("流れは悪くありません。少しずつ距離を縮めて。")
        } else if score >= 0 {
            timing = .waitMore
            tips.append("まだ土台づくりの段階。焦らず安心感を積み上げて。")
        } else {
            timing = .danger
            warningLevel = .danger
            warningMsg = warningMsg ?? "今は押すほど逆効果になりやすいです。一度リセットして基本に戻って。"
        }

        return StrategyResult(
            timing: timing,
            mainTip: attachmentStyle.strategy,
            subTips: tips,
            warningLevel: warningLevel,
            warningMessage: warningMsg
        )
    }
}
