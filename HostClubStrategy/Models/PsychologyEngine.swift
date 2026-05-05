import Foundation

// MARK: - Psychology Theories

enum AttachmentStyle: String, CaseIterable, Identifiable {
    case secure = "secure"
    case anxious = "anxious"
    case avoidant = "avoidant"
    case fearful = "fearful"

    var id: String { rawValue }

    var label: String {
        switch self {
        case .secure: return "安定型"
        case .anxious: return "不安型（アンビバレント）"
        case .avoidant: return "回避型"
        case .fearful: return "恐れ型"
        }
    }

    var description: String {
        switch self {
        case .secure: return "感情が安定。適度な距離感を保てる。最も攻略しやすいタイプ。"
        case .anxious: return "愛情に飢えている。頻繁な確認・寂しがり屋。構ってあげると落ちやすいが依存注意。"
        case .avoidant: return "距離を詰めると逃げる。自立心が強い。追いかけすぎると逆効果。追わせる戦略が有効。"
        case .fearful: return "傷つくのを恐れている。信頼構築に時間がかかる。じっくり安心感を与えること。"
        }
    }

    var strategy: String {
        switch self {
        case .secure: return "素直に気持ちを伝えてOK。高額指名よりも「一緒にいると楽しい」という雰囲気を作ろう。"
        case .anxious: return "「あなたのことが気になってる」という言葉に敏感。LINEの返信速度で感情が動く。返信は少し遅めにして「待たせる」テクを使うと効果的。"
        case .avoidant: return "追いかけてはNG。次の来店を焦らず、あえて間隔をあける。彼から「久しぶり」と言わせれば勝ち。"
        case .fearful: return "まず安全な人間だと思わせる。自分の弱さを少し見せる「自己開示」が有効。急かさないこと。"
        }
    }

    var warningSign: String {
        switch self {
        case .secure: return "感情的になると引かれる。冷静に。"
        case .anxious: return "重いと感じたら急に冷たくなる。依存しすぎ注意。"
        case .avoidant: return "追いかけすぎると消える。距離感が命。"
        case .fearful: return "裏切りを感じると完全にシャットダウン。信頼を最優先に。"
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
    let effectiveness: Int // 1-5
}

enum PsychologyEngine {

    static let allTactics: [PsychologyTactic] = [
        PsychologyTactic(
            name: "ツァイガルニク効果",
            nameEN: "Zeigarnik Effect",
            theory: "未完成・未解決のことが記憶に残りやすい心理。話を途中で終わらせると相手の頭から離れなくなる。",
            howTo: "会話の途中で「あ、これ話すの恥ずかしいんだけど...また今度」と打ち切る。LINEの返信をたまに未完のまま送る（「明日続き話すね」）。",
            caution: "やりすぎると焦らしすぎになる。月2回程度に抑えること。",
            effectiveness: 5
        ),
        PsychologyTactic(
            name: "希少性効果",
            nameEN: "Scarcity Principle",
            theory: "手に入りにくいものほど価値が高く見える。常連になっても「毎週来る女」になると飽きられる。",
            howTo: "来店頻度を意図的に不定期にする。「忙しくてなかなか来れなくて」と言いつつ、急に来店。「あなたのためだけに時間を作った」感を演出。",
            caution: "長期間来ないと存在を忘れられる。最長でも3週間以上は空けないこと。",
            effectiveness: 5
        ),
        PsychologyTactic(
            name: "返報性の原理",
            nameEN: "Reciprocity Principle",
            theory: "何かをもらうとお返しをしたくなる人間の本能。先に与えることで相手に義務感を生む。",
            howTo: "誕生日や記念日にさりげないプレゼントを渡す（高額すぎないものが◎）。「あなたのためにわざわざ」という演出が鍵。彼が何か話したら「覚えてたよ」と後日さりげなく触れる。",
            caution: "媚びてるように見えると逆効果。さりげなさが命。",
            effectiveness: 4
        ),
        PsychologyTactic(
            name: "ミラーリング",
            nameEN: "Mirroring",
            theory: "相手の言動・口癖・テンポを無意識に真似ると親近感が生まれる。人は自分に似た人を好む。",
            howTo: "相手の話すスピード・声のトーンに合わせる。よく使う言葉・笑い方を自然に取り入れる。飲み物を一緒に頼む・乾杯のタイミングを合わせる。",
            caution: "わざとらしいと気持ち悪い。自然に、少しずつ。",
            effectiveness: 4
        ),
        PsychologyTactic(
            name: "吊り橋効果",
            nameEN: "Suspension Bridge Effect",
            theory: "ドキドキ・緊張感がある状況で会うと、その興奮を相手への恋愛感情と錯覚しやすい。",
            howTo: "「実は今日すごく緊張してた」「あなたといると心臓がうるさい」と素直に言う。誕生日・特別な日に会う。サプライズ演出を受けた直後に感謝を伝える。",
            caution: "日常的な普通の訪問では効果が薄い。非日常感を演出する場面を選ぶ。",
            effectiveness: 3
        ),
        PsychologyTactic(
            name: "自己開示の返報性",
            nameEN: "Self-Disclosure Reciprocity",
            theory: "自分の弱さ・秘密を話すと、相手も同じくらい開示したくなる。距離が縮まる。",
            howTo: "「こんな話、他の人にはしてないんだけど」と前置きして少し個人的な話をする。家族の話・過去の恋愛・コンプレックスなどを少しだけ見せる。",
            caution: "重すぎる話は引かれる。「ちょっとだけ見せる」がポイント。",
            effectiveness: 4
        ),
        PsychologyTactic(
            name: "単純接触効果",
            nameEN: "Mere Exposure Effect",
            theory: "接触回数が増えるほど好感度が上がる。見慣れた顔・名前は安心感につながる。",
            howTo: "来店回数を増やす（週1が理想）。LINEは短くてもいいので毎日少し送る。指名を続けることで「この子はいつもいる」という存在感を作る。",
            caution: "接触しすぎると「当たり前の存在」になり新鮮さが消える。希少性とのバランスが命。",
            effectiveness: 3
        ),
        PsychologyTactic(
            name: "ゲイン・ロス効果",
            nameEN: "Gain-Loss Effect",
            theory: "最初に否定→後で肯定されると、最初から肯定されるより好感度が高くなる。",
            howTo: "最初の数回はあまり媚びない・ちょっとクールに接する。徐々に打ち解けていく演出をする。突然「あなたって実はすごく面白いと思う」と言う。",
            caution: "最初からやりすぎると「冷たい客」認定。微妙な匙加減が必要。",
            effectiveness: 4
        ),
    ]

    static func recommendTactics(for input: StrategyInput, attachmentStyle: AttachmentStyle) -> [PsychologyTactic] {
        var result: [PsychologyTactic] = []

        switch attachmentStyle {
        case .avoidant:
            result.append(contentsOf: allTactics.filter { $0.name == "希少性効果" || $0.name == "ゲイン・ロス効果" })
        case .anxious:
            result.append(contentsOf: allTactics.filter { $0.name == "返報性の原理" || $0.name == "自己開示の返報性" })
        case .fearful:
            result.append(contentsOf: allTactics.filter { $0.name == "自己開示の返報性" || $0.name == "ミラーリング" })
        case .secure:
            result.append(contentsOf: allTactics.filter { $0.name == "ツァイガルニク効果" || $0.name == "吊り橋効果" })
        }

        switch input.goal {
        case .friend:
            result.append(contentsOf: allTactics.filter { $0.name == "単純接触効果" || $0.name == "ミラーリング" })
        case .boyfriend:
            result.append(contentsOf: allTactics.filter { $0.name == "ツァイガルニク効果" || $0.name == "吊り橋効果" })
        case .marriage:
            result.append(contentsOf: allTactics.filter { $0.name == "返報性の原理" || $0.name == "ゲイン・ロス効果" })
        case .exclusive:
            result.append(contentsOf: allTactics.filter { $0.name == "希少性効果" || $0.name == "ツァイガルニク効果" })
        }

        // Deduplicate
        var seen = Set<String>()
        return result.filter { seen.insert($0.name).inserted }
    }

    static func analyzeStrategy(input: StrategyInput, attachmentStyle: AttachmentStyle) -> StrategyResult {
        var score = 0
        var tips: [String] = []
        var warningMsg: String? = nil
        var warningLevel: WarningLevel = .none

        // Mood scoring
        switch input.hostMood {
        case .warm: score += 3
        case .flirty: score += 2
        case .normal: score += 0
        case .cold: score -= 2
        case .busy: score -= 1
        }

        // Spending
        switch input.spending {
        case .none: score -= 1
        case .low: score += 1
        case .medium: score += 2
        case .high: score += 3
        case .extreme: score += 4
        }

        // Frequency
        switch input.frequency {
        case .first: score += 1; tips.append("初回は印象を残すことに集中。「また来たい」と思わせるだけでOK。")
        case .rare: score -= 1; tips.append("来店が少ない。まず月1〜2回に増やすことを目標に。")
        case .monthly: score += 1
        case .weekly: score += 2
        case .regular: score += 3; tips.append("常連ポジション確立済み。次は「特別な常連」への格上げを狙う。")
        }

        // Bonuses
        if input.hasLineSNS { score += 2; tips.append("LINE連絡先ゲット済み！まずは短いメッセージで存在感を出そう。") }
        if input.hasPrivateMeet { score += 3; tips.append("店外会合あり。これは本命フラグの可能性大。次の一手を慎重に。") }
        if input.calledByName { score += 1; tips.append("名前で呼んでくれてる。親密度は確実に上がっている証拠。") }
        if input.receivedGift { score += 2; tips.append("プレゼントをもらった。返報性の原理で、次はあなたから何か渡す番。") }
        if !input.otherCustomersExist { score += 2; tips.append("競合客が少ない。今がチャンス！攻め時。") }

        // Psychology adjustments
        if attachmentStyle == .avoidant && input.frequency == .regular {
            score -= 2
            warningMsg = "回避型に毎週来店は逆効果。意図的に頻度を落として「追わせる」戦略に切り替えて。"
            warningLevel = .caution
        }
        if attachmentStyle == .anxious && input.hasLineSNS {
            tips.append("不安型は返信が早い。たまに少し遅らせることで「気になる存在」になれる。")
        }

        // Goal difficulty adjustment
        switch input.goal {
        case .friend: break
        case .boyfriend: score -= 1
        case .marriage: score -= 3
        case .exclusive: score -= 5
        }

        // Determine timing
        let timing: TimingAdvice
        if score >= 8 {
            timing = .goNow
            tips.append("今が最高のタイミング！気持ちを行動で示すチャンス。")
        } else if score >= 4 {
            timing = .goodTiming
            tips.append("いい流れ。少しずつ距離を縮めよう。")
        } else if score >= 0 {
            timing = .waitMore
            tips.append("まだ土台が足りない。焦らず関係を積み重ねて。")
        } else {
            timing = .danger
            warningLevel = .danger
            warningMsg = warningMsg ?? "状況が厳しい。一度リセットして基本に戻ろう。"
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
