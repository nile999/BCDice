# -*- coding: utf-8 -*-

class MagicaLogia < DiceBot
  setPrefixes(['WT', 'FCT', 'ST', 'FT', 'AT', 'BGT', 'DAT', 'FAT', 'WIT', 'RTT', 'TPT', 'TCT', 'PCT', 'MCT', 'ICT', 'SCT', 'XCT', 'WCT', 'CCT', 'BST', 'PT', 'XEST', 'IWST', 'MCST', 'WDST', 'LWST', 'MIT', 'MOT', 'MAT', 'MUT', 'MFT', 'MLT', 'STB', 'RTS', 'RTB', 'RTF', 'RTP', 'RTD', 'RTN', 'MGCT', 'MBST', 'MAST', 'TCST', 'PWST', 'PAST', 'GBST', 'SLST', 'WLAT', 'WMT', 'FFT', 'OLST', 'TPTB', 'FLT'])

  def initialize
    super
    @sendMode = 2
    @sortType = 3
    @d66Type = 2
  end

  def gameName
    'マギカロギア'
  end

  def gameType
    "MagicaLogia"
  end

  def getHelpMessage
    return <<INFO_MESSAGE_TEXT
・判定
スペシャル／ファンブル／成功／失敗を判定
・各種表
経歴表　BGT/初期アンカー表　DAT/運命属性表　FAT
願い表　WIT/プライズ表　PT
時の流れ表　TPT/大判時の流れ表　TPTB
事件表　AT
ファンブル表　FT／変調表　WT
運命変転表　FCT
　典型的災厄 TCT／物理的災厄 PCT／精神的災厄 MCT／狂気的災厄 ICT
　社会的災厄 SCT／超常的災厄 XCT／不思議系災厄 WCT／コミカル系災厄 CCT
　魔法使いの災厄 MGCT
シーン表　ST／大判シーン表　STB
　極限環境 XEST／内面世界 IWST／魔法都市 MCST
　死後世界 WDST／迷宮世界 LWST
　魔法書架 MBST／魔法学院 MAST／クレドの塔 TCST
　並行世界 PWST／終末　　 PAST／異世界酒場 GBST
　ほしかげ SLST／旧図書館 OLST
世界法則追加表 WLAT/さまよう怪物表 WMT
ランダム特技表　RTT
　指定特技（星）　RTS/指定特技（獣）　RTB/指定特技（力）　RTF
　指定特技（歌）　RTP/指定特技（夢）　RTD/指定特技（闇）　RTN
ブランク秘密表　BST/
　宿敵表　MIT/謀略表　MOT/因縁表　MAT
　奇人表　MUT/力場表　MFT/同盟表　MLT
落花表　FFT
その後表 FLT
・D66ダイスあり
INFO_MESSAGE_TEXT
  end

  # ゲーム別成功度判定(2D6)
  def check_2D6(total_n, dice_n, signOfInequality, diff, dice_cnt, dice_max, n1, n_max)
    debug("total_n, dice_n, signOfInequality, diff, dice_cnt, dice_max, n1, n_max", total_n, dice_n, signOfInequality, diff, dice_cnt, dice_max, n1, n_max)

    return '' unless signOfInequality == ">="

    output =
      if dice_n <= 2
        " ＞ ファンブル"
      elsif dice_n >= 12
        " ＞ スペシャル(魔力1D6点か変調1つ回復)"
      elsif total_n >= diff
        " ＞ 成功"
      else
        " ＞ 失敗"
      end

    output += getGainMagicElementText()

    return output
  end

  # 表振り分け
  def rollDiceCommand(command)
    output = '1'
    type = ""
    total_n = ""

    case command
    when 'BGT'
      type = '経歴表'
      output, total_n = magicalogia_background_table
    when 'DAT'
      type = '初期アンカー表'
      output, total_n = magicalogia_defaultanchor_table
    when 'FAT'
      type = '運命属性表'
      output, total_n = magicalogia_fortune_attribution_table
    when 'WIT'
      type = '願い表'
      output, total_n = magicalogia_wish_table
    when 'ST'
      type = 'シーン表'
      output, total_n = magicalogia_scene_table
    when 'FT'
      type = 'ファンブル表'
      output, total_n = magicalogia_fumble_table
    when 'WT'
      type = '変調表'
      output, total_n = magicalogia_wrong_table
    when 'FCT'
      type = '運命変転表'
      output, total_n = magicalogia_fortunechange_table
    when 'AT'
      type = '事件表'
      output, total_n = magicalogia_accident_table
    when 'RTT'
      type = 'ランダム特技決定表'
      output, total_n = magicalogia_random_skill_table
    when 'TPT'
      type = '時の流れ表'
      output, total_n = magicalogia_time_passage_table
    when 'TCT'
      type = '運命変転「典型的災厄」'
      output, total_n = magicalogia_typical_fortune_change_table
    when 'PCT'
      type = '運命変転「物理的災厄」'
      output, total_n = magicalogia_physical_fortune_change_table
    when 'MCT'
      type = '運命変転「精神的災厄」'
      output, total_n = magicalogia_mental_fortune_change_table
    when 'ICT'
      type = '運命変転「狂気的災厄」'
      output, total_n = magicalogia_insanity_fortune_change_table
    when 'SCT'
      type = '運命変転「社会的災厄」'
      output, total_n = magicalogia_social_fortune_change_table
    when 'XCT'
      type = '運命変転「超常的災厄」'
      output, total_n = magicalogia_paranormal_fortune_change_table
    when 'WCT'
      type = '運命変転「不思議系災厄」'
      output, total_n = magicalogia_wonderful_fortune_change_table
    when 'CCT'
      type = '運命変転「コミカル系災厄」'
      output, total_n = magicalogia_comical_fortune_change_table
    when 'BST'
      type = 'ブランク秘密表'
      output, total_n = magicalogia_blank_secret_table
    when 'PT'
      type = 'プライズ表'
      output, total_n = magicalogia_prise_table
    when 'MIT'
      type = '宿敵表'
      output, total_n = magicalogia_inveterate_enemy_table
    when 'MOT'
      type = '謀略表'
      output, total_n = magicalogia_conspiracy_table
    when 'MAT'
      type = '因縁表'
      output, total_n = magicalogia_fate_table
    when 'MUT'
      type = '奇人表'
      output, total_n = magicalogia_cueball_table
    when 'MFT'
      type = '力場表'
      output, total_n = magicalogia_force_field_table
    when 'MLT'
      type = '同盟表'
      output, total_n = magicalogia_alliance_table
    when 'XEST'
      type = '極限環境シーン表'
      output, total_n = magicalogia_extreme_environment_scene_table
    when 'IWST'
      type = '内面世界シーン表'
      output, total_n = magicalogia_innner_world_scene_table
    when 'MCST'
      type = '魔法都市シーン表'
      output, total_n = magicalogia_magic_city_scene_table
    when 'WDST'
      type = '死後世界シーン表'
      output, total_n = magicalogia_world_after_dead_scene_table
    when 'LWST'
      type = '迷宮世界シーン表'
      output, total_n = magicalogia_labyrinth_world_scene_table
    when 'STB'
      type = '大判シーン表'
      output, total_n = magicalogia_new_scene_table
    when 'RTS'
      type = '指定特技（星）'
      output, total_n = magicalogia_random_skill_star_table
    when 'RTB'
      type = '指定特技（獣）'
      output, total_n = magicalogia_random_skill_beast_table
    when 'RTF'
      type = '指定特技（力）'
      output, total_n = magicalogia_random_skill_force_table
    when 'RTP'
      type = '指定特技（歌）'
      output, total_n = magicalogia_random_skill_poem_table
    when 'RTD'
      type = '指定特技（夢）'
      output, total_n = magicalogia_random_skill_dream_table
    when 'RTN'
      type = '指定特技（闇）'
      output, total_n = magicalogia_random_skill_night_table
    when 'MGCT'
      type = '運命変転「魔法使いの災厄」'
      output, total_n = magicalogia_magi_fortune_change_table
    when 'MBST'
      type = '魔法書架シーン表'
      output, total_n = magicalogia_magic_bookshelf_scene_table
    when 'MAST'
      type = '魔法学院シーン表'
      output, total_n = magicalogia_magic_academy_scene_table
    when 'TCST'
      type = 'クレドの塔シーン表'
      output, total_n = magicalogia_tower_credo_scene_table
    when 'PWST'
      type = '並行世界シーン表'
      output, total_n = magicalogia_parallel_world_scene_table
    when 'PAST'
      type = '終末シーン表'
      output, total_n = magicalogia_post_apocalypse_scene_table
    when 'GBST'
      type = '異世界酒場シーン表'
      output, total_n = magicalogia_god_bar_scene_table
    when 'SLST'
      type = 'ほしかげシーン表'
      output, total_n = magicalogia_starlight_scene_table
    when 'WLAT'
      type = '世界法則追加表'
      output, total_n = magicalogia_world_low_add_table
    when 'WMT'
      type = 'さまよう怪物表'
      output, total_n = magicalogia_wondaring_monster_table
    when 'FFT'
      type = '落花表'
      output, total_n = magicalogia_fallen_flower_table
    when 'OLST'
      type = '旧図書館シーン表'
      output, total_n = magicalogia_old_library_scene_table
    when 'TPTB'
      type = '大判時の流れ表'
      output, total_n = magicalogia_new_time_passage_table
    when 'FLT'
      type = 'その後表'
      output, total_n = magicalogia_fallen_after_table

    end

    return "#{type}(#{total_n}) ＞ #{output}"
  end

  # シーン表
  def magicalogia_scene_table
    table = [
             '魔法で作り出した次元の狭間。ここは時間や空間から切り離された、どこでもあり、どこでもない場所だ。',
             '夢の中。遠く過ぎ去った日々が、あなたの前に現れる。',
             '静かなカフェの店内。珈琲の香りと共に、優しく穏やかな雰囲気が満ちている。',
             '強く風が吹き、雲が流されていく。遠く、雷鳴が聞こえた。どうやら、一雨きそうだ。',
             '無人の路地裏。ここならば、邪魔が入ることもないだろう。',
             lambda { return "周囲で〈断章〉が引き起こした魔法災厄が発生する。#{magicalogia_random_skill_table_text_only}の判定を行うこと。成功すると、好きな魔素が一個発生する。失敗すると「運命変転表」を使用する。" },
             '夜の街を歩く。暖かな家々の明かりが、遠く見える。',
             '読んでいた本を閉じる。そこには、あなたが知りたがっていたことが書かれていた。なるほど、そういうことか。',
             '大勢の人々が行き過ぎる雑踏の中。あなたを気に掛ける者は誰もいない。',
             '街のはるか上空。あなたは重力から解き放たれ、自由に空を飛ぶ。',
             '未来の予感。このままだと起きるかもしれない出来事の幻が現れる。',
            ]

    return get_table_by_2d6(table)
  end

  # ファンブル表
  def magicalogia_fumble_table
    table = [
             '魔法災厄が、あなたのアンカーに降りかかる。「運命変転」が発生する。',
             '魔法災厄が、あなたの魔素を奪い取る。チャージしている魔素の中から、好きな組み合わせで2点減少する。',
             '魔法の制御に失敗してしまう。【魔力】が1点減少する。',
             '魔法災厄になり、そのサイクルが終了するまで、行為判定にマイナス1の修正が付く。',
             '魔法災厄が、直接あなたに降りかかる。変調表を振り、その変調を受ける。',
             'ふぅ、危なかった。特に何も起こらない。',
            ]

    return get_table_by_1d6(table)
  end

  # 変調表
  def magicalogia_wrong_table
    table = [
             '『封印』自分の魔法(習得タイプが装備以外)からランダムに一つ選ぶ。選んだ魔法のチェック欄をチェックする。その魔法を使用するには【魔力】を2点消費しなくてはいけない。',
             '『綻び』魔法戦の間、各ラウンドの終了時に自分の【魔力】が1点減少する。',
             '『虚弱』【攻撃力】が1点減少する。',
             '『病魔』【防御力】が1点減少する。',
             '『遮蔽』【根源力】が1点減少する',
             lambda { return "『不運』#{magicalogia_random_skill_table_text_only}のチェック欄をチェックする。その特技が使用不能になり、その分野の特技が指定特技になった判定を行うとき、マイナス1の修正が付く。" },
            ]

    return get_table_by_1d6(table)
  end

  # 運命変転表
  def magicalogia_fortunechange_table
    table = [
             '『挫折』そのキャラクターは、自分にとって大切だった夢を諦める。',
             '『別離』そのキャラクターにとって大切な人――親友や恋人、親や兄弟などを失う。',
             '『大病』そのキャラクターは、不治の病を負う。',
             '『借金』そのキャラクターは、悪人に利用され多額の借金を負う。',
             '『不和』そのキャラクターは、人間関係に失敗し深い心の傷を負う。',
             '『事故』そのキャラクターは交通事故にあい、取り返しのつかない怪我を負う。',
            ]
    return get_table_by_1d6(table)
  end

  # 事件表
  def magicalogia_accident_table
    table = [
             '不意のプレゼント、素晴らしいアイデア、悪魔的な取引……あなたは好きな魔素を1つ獲得するか【魔力】を1D6点回復できる。どちらかを選んだ場合、その人物に対する【運命】が1点上昇する。【運命】の属性は、ゲームマスターが自由に決定できる。',
             '気高き犠牲、真摯な想い、圧倒的な力……その人物に対する【運命】が1点上昇する。【運命】の属性は「尊敬」になる。',
             '軽い口論、殴り合いの喧嘩、魔法戦……互いに1D6を振り、低い目を振った方が、高い目を振った方に対して【運命】が1点上昇する。【運命】の属性は高い目を振った方が、自由に決定できる。',
             '裏切り、策謀、不幸な誤解……その人物に対する【運命】が1点上昇する。【運命】の属性は「宿敵」になる。',
             '意図せぬ感謝、窮地からの救済、一生のお願いを叶える……その人物に対する【運命】が1点上昇する。【運命】の属性は「支配」になる。',
             lambda { return "生ける屍の群れ、地獄の業火、迷宮化……魔法災厄に襲われる。#{magicalogia_random_skill_table_text_only}の選んで判定を行う。失敗すると、その人物に対し「運命変転表」を使用する。" },
             '道路の曲がり角、コンビニ、空から落ちてくる……偶然出会う。その人物に対する【運命】が1点上昇する。【運命】の属性は「興味」になる。',
             '魂のひらめき、愛の告白、怪しい抱擁……その人物に対する【運命】が1点上昇する。【運命】の属性は「恋愛」になる。',
             '師弟関係、恋人同士、すれ違う想い……その人物との未来が垣間見える。たがいに対する【運命】が1点上昇する。',
             '懐かしい表情、大切な思い出、伴侶となる予感……その人物に対する【運命】が1点上昇する。【運命】の属性は「血縁」になる。',
             '献身的な看護、魔法的な祝福、奇跡……その人物に対する【運命】が1点上昇する。【運命】の属性は自由に決定できる。もしも関係欄に疵があれば、その疵を1つ関係欄から消すことができる。',
            ]

    return get_table_by_2d6(table)
  end

  # 魔素獲得チェック
  def getGainMagicElementText()
    diceList = getDiceList
    debug("getGainMagicElementText diceList", diceList)

    return '' if diceList.empty?

    dice1 = diceList[0]
    dice2 = diceList[1]

    # マギカロギア用魔素取得判定
    return  gainMagicElement(dice1, dice2)
  end

  def gainMagicElement(dice1, dice2)
    return "" unless dice1 == dice2

    # ゾロ目
    table = ['星', '獣', '力', '歌', '夢', '闇']
    return " ＞ " + table[dice1 - 1] + "の魔素2が発生"
  end

  # 経歴表
  def magicalogia_background_table
    table = [
             '書警／ブックウォッチ',
             '司書／ライブラリアン',
             '書工／アルチザン',
             '訪問者／ゲスト',
             '異端者／アウトサイダー',
             '外典／アポクリファ',
            ]

    return get_table_by_1d6(table)
  end

  # 初期アンカー表
  def magicalogia_defaultanchor_table
    table = [
             '『恩人』あなたは、困っているところを、そのアンカーに助けてもらった。',
             '『居候』あなたかアンカーは、どちらかの家や経営するアパートに住んでいる。',
             '『酒友』あなたとアンカーは、酒飲み友達である。',
             '『常連』あなたかアンカーは、その仕事場によくやって来る。',
             '『同人』あなたは、そのアンカーと同じ趣味を楽しむ同好の士である。',
             '『隣人』あなたは、そのアンカーの近所に住んでいる。',
             '『同輩』あなたはそのアンカーと仕事場、もしくは学校が同じである。',
             '『文通』あなたは、手紙やメール越しにそのアンカーと意見を交換している。',
             '『旧友』あなたは、そのアンカーと以前に、親交があった。',
             '『庇護』あなたは、そのアンカーを秘かに見守っている。',
             '『情人』あなたは、そのアンカーと肉体関係を結んでいる。',
            ]

    return get_table_by_2d6(table)
  end

  # 運命属性表
  def magicalogia_fortune_attribution_table
    table = [
             '『血縁』自分や、自分が愛した者の親類や家族。',
             '『支配』あなたの部下になることが運命づけられた相手。',
             '『宿敵』何らかの方法で戦いあい、競い合う不倶戴天の敵。',
             '『恋愛』心を奪われ、相手に強い感情を抱いている存在。',
             '『興味』とても稀少だったり、不可解だったりして研究や観察をしたくなる対象。',
             '『尊敬』その才能や思想、姿勢に対し畏敬や尊敬を抱く人物。',
            ]

    return get_table_by_1d6(table)
  end

  # 願い表
  def magicalogia_wish_table
    table = [
             '自分以外の特定の誰かを助けてあげて欲しい。',
             '自分の大切な人や憧れの人に会わせて欲しい。',
             '自分をとりまく不幸を消し去って欲しい。',
             '自分のなくした何かを取り戻して欲しい。',
             '特定の誰かを罰して欲しい。',
             '自分の欲望（金銭欲、名誉欲、肉欲、知識欲など）を満たして欲しい。',
            ]

    return get_table_by_1d6(table)
  end

  # 指定特技ランダム決定表
  def magicalogia_random_skill_table
    skillTableFull = [
                      ['星', ['黄金', '大地', '森', '道', '海', '静寂', '雨', '嵐', '太陽', '天空', '異界']],
                      ['獣', ['肉', '蟲', '花', '血', '鱗', '混沌', '牙', '叫び', '怒り', '翼', 'エロス']],
                      ['力', ['重力', '風', '流れ', '水', '波', '自由', '衝撃', '雷', '炎', '光', '円環']],
                      ['歌', ['物語', '旋律', '涙', '別れ', '微笑み', '想い', '勝利', '恋', '情熱', '癒し', '時']],
                      ['夢', ['追憶', '謎', '嘘', '不安', '眠り', '偶然', '幻', '狂気', '祈り', '希望', '未来']],
                      ['闇', ['深淵', '腐敗', '裏切り', '迷い', '怠惰', '歪み', '不幸', 'バカ', '悪意', '絶望', '死']],
                     ]

    skillTable, total_n = get_table_by_1d6(skillTableFull)
    tableName, skillTable = skillTable
    skill, total_n2 = get_table_by_2d6(skillTable)
    return "「#{tableName}」≪#{skill}≫", "#{total_n},#{total_n2}"
  end

  # 特技だけ抜きたい時用 あまりきれいでない
  def magicalogia_random_skill_table_text_only
    text, = magicalogia_random_skill_table
    return text
  end

  # 魔素の種類獲得表
  def get_magic_element_type
    table = ['星', '獣', '力', '歌', '夢', '闇']
    return get_table_by_1d6(table)
  end

  # 時の流れ表
  def magicalogia_time_passage_table
    output = ""
    num, = roll(1, 6)

    if num == 1
      output = "標的となり追われる生活が続いた。ここ数年は苦しい戦いの日々だった。#{magicalogia_random_skill_table_text_only}の判定を行う。成功するとセッション終了時に追加の功績点1点。失敗すると「運命変転」発生。"
    elsif num == 2
      output = "冒険の日々の途中、大きな幸せが訪れる。#{magicalogia_random_skill_table_text_only}の判定を行う。成功すると、自分のアンカーの災厄か、自分の疵一つを無効化する。"
    elsif num == 3
      text1, = get_magic_element_type
      text2, = get_magic_element_type
      text3, = get_magic_element_type
      output = "瞑想から目を覚ます。もうそんな時間か。おかげで十分な魔素を得ることができた。「#{text1}」「#{text2}」「#{text3}」の魔素を獲得する。"
    elsif num == 4
      output = "傷を癒すには十分な時間だ。自分の【魔力】を最大値まで回復する。もしくは「魔力のリセット」を行うことができる。好きな方を選ぶこと。"
    elsif num == 5
      output = "平穏な日々の中にも、ちょっとした事件が起きる。自分のアンカーを一人選んで「事件表」を振ることができる。"
    elsif num == 6
      output = "日々研鑚を重ね、魔法の修行に精進した。もしも望むなら、蔵書欄にある魔法を、自分の修得できる範囲の中で、現在とは別の魔法に変更して構わない。もしも、魔素がチャージされていた魔法を見習得にした場合、その魔素は失われる。"
    end

    return output, num
  end

  # 典型的災厄
  def magicalogia_typical_fortune_change_table
    table = [
             '挫折。自分にとって大切だった夢をあきらめる。',
             '別離。自分にとって大切な人―親友や恋人、親や兄弟などを失う。',
             '大病。不治の病を負う。',
             '借金。悪人に利用され、多額の借金を負う。',
             '不和。人間関係に失敗し深い心の傷を負う。',
             '事故。交通事故にあい、取り返しのつかないケガを負う。',
            ]
    return get_table_by_1d6(table)
  end

  # 物理的災厄
  def magicalogia_physical_fortune_change_table
    table = [
             '火事。自分の家が焼け落ち、帰るところが無くなる。',
             '盗難。自分の大切なものが盗まれ、失われる。',
             '災害。自然災害に襲われ、生活環境が激変する',
             '失明。眼が見えなくなる。',
             '誘拐。何者かにさらわれ、監禁される。',
             '傷害。通り魔やあなたを憎む者に傷を負わされる。',
            ]
    return get_table_by_1d6(table)
  end

  # 精神的災厄
  def magicalogia_mental_fortune_change_table
    table = [
             '倦怠。疲労感に襲われ、何もやる気がなくなる。',
             '家出。今、自分がいる場所に安らぎを感じなくなり、失踪する。',
             '憎悪。周囲の誰かやPCに対して激しい憎悪を抱くようになる。',
             '不眠。眠れなくなり、疲労する。',
             '虚言。本当のことを話せなくなってしまう。',
             '記憶喪失。友達やPCのことを忘れてしまう。',
            ]
    return get_table_by_1d6(table)
  end

  # 狂気的災厄
  def magicalogia_insanity_fortune_change_table
    table = [
             '二重人格。もう一つの人格が現れ、勝手な行動を始める。',
             '恐怖。高所や異性、蜘蛛など、特定の何かに対する恐怖症になる。',
             '妄想。突拍子もない奇妙な妄想が頭を離れなくなる。',
             '偏愛。特定の物や状況などに熱狂的な愛情を示すようになる。',
             '暴走。時折、自分の感情が制御できなくなり、凶暴化する。',
             '発情。体温が上昇、脈拍が増大し、性的に興奮状態になる。',
            ]
    return get_table_by_1d6(table)
  end

  # 社会的災厄
  def magicalogia_social_fortune_change_table
    table = [
             '逮捕。無実の罪で捕らわれ、留置される。',
             '裏切り。信頼していた人物に騙されたり、恋人に浮気されたりする。',
             '暴露。自分の隠しておきたい秘密を暴露される。',
             '籠絡。どう見てもよくない相手に心を奪われる。',
             '加害。人を傷つけたり、殺めたりしてしまう。',
             '多忙。とてつもない量の仕事に追われ、心身共に疲労する。',
            ]
    return get_table_by_1d6(table)
  end

  # 超常的災厄
  def magicalogia_paranormal_fortune_change_table
    table = [
             '霊感。見えるはずのないものが見えるようになる。',
             '不運。身の回りで、不幸な偶然が頻発するようになる。',
             '感染。吸血鬼やゾンビなど、怪物になりかかってしまう。',
             '阻害。自分の存在が、魔法的存在以外から見えなくなってしまう。',
             '変身。姿が動物や別の人間に変わってしまう。',
             '標的。殺人鬼や魔法災厄など、悪意を引き寄せてしまう。',
            ]
    return get_table_by_1d6(table)
  end

  # 不思議系災厄
  def magicalogia_wonderful_fortune_change_table
    table = [
             '邪気眼。ついつい痛い言動を繰り返すようになってしまう。',
             'ドジ。ありえないほどよく転び、物を壊す体質になってしまう。',
             '方向音痴。信じられないくらい道に迷うようになってしまう。',
             '変語尾。なぜか、自分が話す言葉の語尾が変になってしまう。',
             'ひらがな。話す言葉が全てひらがなで聞こえるようになる。',
             'ヤンデレ。PCのことを病的に愛するようになり、自分以外にPCへの好意を持つ者に対して攻撃的になる。',
            ]
    return get_table_by_1d6(table)
  end

  # コミカル系災厄
  def magicalogia_comical_fortune_change_table
    table = [
             '性別逆転。自分の肉体の性別が逆転してしまう。',
             '猫耳。頭から猫耳が生える。',
             '太る。びっくりするほど太る。',
             '足がくさい。哀しくなるほど足がくさくなる。',
             'ハラペコ。一回の食事で、ご飯を二十杯くらいおかわりしないと空腹でなにもできなくなる。',
             '脱衣。その場ですべての服が脱げる。',
            ]
    return get_table_by_1d6(table)
  end

  # ブランク秘密表用テーブル
  # 宿敵表
  def magicalogia_inveterate_enemy_table
    output = ""
    num, = roll(1, 6)
    if num == 1
      output = '嫉妬。その人物は、実は調査者の実力をねたむ〈大法典〉の魔法使いだった。データは〈火刑人〉を使用する。ただし、魔法の使用には魔素を必要とし、魔法使いをコレクションすることはできない。GMは調査者やそのアンカーに魔法戦を挑み、邪魔をするように操作すること。'
    elsif num == 2
      output = '蒐集。その人物は、実は調査者をコレクションしようとする〈書籍卿〉だった。データは〈混血主義者〉を使用する。GMは〈断章〉に立ち会ったり、魔法戦を挑んだりして、調査者の邪魔をするように操作すること。'
    elsif num == 3
      output = '妨害。その人物は、実は現在調査者が追っている〈断章〉を奪おうとする〈書籍卿〉だった。データは〈囁きの誘惑者〉を使用する。GMは〈断章〉に立ち会ったり、魔法戦を挑んだりして、調査者の邪魔をするように操作すること。'
    elsif num == 4
      output = "断章。その人物には、今回の件と関係ない〈断章〉が憑依していた。データは〈猛獣〉を使用する。ただし特技と召喚する騎士は#{magicalogia_random_skill_table_text_only}に変更する。GMは〈断章〉に立ち会ったり、魔法戦を挑んだりして、調査者の邪魔するように操作すること。"
    elsif num == 5
      output = '黒服。その人物は、実は魔法やオバケなどのあらゆる超常現象を否定する秘密結社「サークルエンド」の工作員だった。データは〈サークルエンド〉を使用する。GMは【隠蔽工作】を使用したり、魔法戦を挑んだりして、調査者の邪魔をするように操作すること。'
    elsif num == 6
      output = '忍者。その人物は、実はあなたを殺せという使命を受けた忍者である。データは〈忍者〉を使用する。GMは〈断章〉に立ち会ったり、魔法戦を挑んだりして、調査者の邪魔をするようにそうさすること。'
    end
    return output, num
  end

  # 謀略表
  def magicalogia_conspiracy_table
    table = [
             '爆弾。その人物には、調査者の肉体を爆発させる魔法爆弾が仕掛けられていた。この【秘密】が公開されると、調査者は1d6点のダメージを受ける。',
             '呪詛。その人物には、調査者に感染する呪いの魔法が仕掛けられていた。この【秘密】が公開されると、調査者はランダムに選んだ変調を一つ受ける。',
             '幽閉。その人物には、調査者を異次元の牢獄に閉じ込める魔法が仕掛けられていた。この【秘密】が公開されると、調査者のプレイヤーがシーンプレイヤーになるか、クライマックスフェイズになるまで、シーンに登場できなくなる(マスターシーンでの登場の可否はGMが決定できる)。',
             '強化。その人物には、調査者の運命の力を吸収する魔法が仕掛けられていた。この【秘密】が公開されると、調査者のアンカーの数と同じ数まで、セッションに登場する〈断章〉の憑依深度が1上昇する。',
             '不幸。その人物には、調査者のアンカーに不幸な出来事を起こす魔法が仕掛けられていた。この【秘密】が公開されると、調査者のアンカーの中から〈愚者〉を一人選び、そのNPCに運命変転表を使用する。',
             '脱走。その人物には、〈断章〉の逃亡を手助けする魔法が仕掛けられていた。この【秘密】が公開されると、GMは〈断章〉一つとNPC一人を選ぶ。その〈断章〉は、そのNPCに憑依できる。このときGMは、すでに魔法使いによって回収された〈断章〉を選んでも良く、その場合【魔力】は1d6点回復する。',
            ]
    return get_table_by_1d6(table)
  end

  # 因縁表
  def magicalogia_fate_table
    table = [
             '思慕。その人物は、実は調査者のことを知っており、深く愛していた。調査者はその人物に対する【運命】を2点上昇し、その属性を「恋愛」にする。その人物の【運命】の属性が「恋愛」の間、調査者は、この人物に対する【運命】が1点上昇するたび、【魔力】がその【運命】の値だけ回復する。',
             '縁者。その人物は、実は調査者と血縁関係があった。調査者はその人物に対する【運命】を2点上昇し、その属性を「血縁」にする。その人物の【運命】の属性が「血縁」の間、調査者の復活判定に、その【運命】の値だけプラスの修正がつく。',
             '怨恨。その人物は、実は調査者に深い恨みを持つ人物だった。調査者はその人物に対する【運命】を2点上昇し、その属性を「宿敵」にする。その人物の【運命】の属性が「宿敵」の間は、調査者がファンブルすると、その【運命】の値だけ【魔力】が減少する。',
             '狂信。その人物は、実は調査者を崇拝していた。調査者はその人物に対する【運命】を2点上昇し、その属性を「支配」にする。その人物の【運命】の属性が「支配」の間、調査者は、その人物に憑依した〈断章〉に魔法戦を挑んだ場合、自動的に勝利することができる。ただし、調査者は、行為判定のとき、その【運命】の値以下の目が出るとファンブルになる。',
             '分身。その人物は、実は調査者の魔法によって切り離された魂の一部だった。そのNPCは、調査者と融合し、調査者は功績点を1点獲得する。',
             '無関係。その人物は、今回の事件に特に関係はなかった。しかし、この出会いは本当に無意味だったのだろうか？ 調査者は、その人物を対象として事件表を振ること。',
            ]
    return get_table_by_1d6(table)
  end

  # 奇人表
  def magicalogia_cueball_table
    table = [
             '寿命。その人物の命脈は尽きていた。この【秘密】が公開されると、その人物は死亡する。',
             '殺意。その人物は、世の中に対する憎悪に溢れ、無差別に誰かを傷つけようとしていた。GMはサイクルの終わりにランダムにこの【秘密】の持ち主以外のNPCを一人選ぶ。そのNPCが〈断章〉に憑依されていない〈愚者〉なら死亡し、そうでなければ、この【秘密】の持ち主本人が死亡する。このとき、いずれにせよその死亡を望まないキャラクターは「闇」の分野かの中からランダムに特技一つを選び、判定を行うことができる。判定に成功するとその死亡を無効化できる。',
             '強運。その人物は、一種の特異点で、とても強い幸運の持ち主だった。このNPCは、プライズとして扱う。このプライズの持ち主は、あらゆる行為判定を行うとき、プラス1の修正がつく。調査者は、このプライズを獲得する。',
             '疵痕。その人物は、過去に魔法によって大切なものを奪われており、魔法とその関係者を憎んでいる。その人物がいるシーンでは、召喚と呪文の判定にマイナス2の修正がつく。',
             '善人。その人物は、強く優しい精神の持ち主だった。その人物に対する【運命】を3点上昇する。',
             '依代。その人物は、霊媒体質で何かに憑依されやすい。この人物に〈断章〉が憑依した場合、【攻撃力】と【防御力】が2点ずつ上昇する。この【秘密】が公開されると、GMはサイクルの終わりに〈断章〉一つを選び、その憑依の対象をこのNPCに変更することができるようになる。ただし、すでに魔法使いによって回収された〈断章〉を選ぶことはできない。',
            ]
    return get_table_by_1d6(table)
  end

  # 力場表
  def magicalogia_force_field_table
    table = [
             '加護。その人物の頭上には、常に星の恩寵が降り注いでいる。この【秘密】が公開されると、そのシーンに「星」の魔素が2点発生する。また、このセッションの間、この人物に対する【運命】が1点上昇したキャラクターは「星」の魔素を2点獲得する。',
             '変化(へんげ)。その人物は、実は歳を経た動物―狐や狸などが化けた存在である。この【秘密】が公開されると、そのシーンに「獣」の魔素が2点発生する。また、このセッションの間、この人物に対する【運命】が1点上昇したキャラクターは「獣」の魔素を2点獲得する。',
             '超能力。その人物には、ESPやPKなど、潜在的な超能力が眠っている。この【秘密】が公開されると、そのシーンに「力」の魔素が2点発生する。また、このセッションの間、この人物に対する【運命】が1点上昇したキャラクターは「力」の魔素を2点獲得する。',
             '詩人。その人物は、詩神に祝福された存在である。この【秘密】が公開されると、そのシーンに「歌」の魔素が2点発生する。また、このセッションの間、この人物に対する【運命】が1点上昇したキャラクターは「歌」の魔素を2点獲得する。',
             '夢想家。その人物には、大きな理想や実現したいと思っている夢がある。何か大きなことを成し遂げようとしている。。この【秘密】が公開されると、そのシーンに「夢」の魔素が2点発生する。また、このセッションの間、この人物に対する【運命】が1点上昇したキャラクターは「夢」の魔素を2点獲得する。',
             '暗黒。その人物は、呪われた運命を背負っており、世界の破滅を呼び込む可能性を持っている。この【秘密】が公開されると、そのシーンに「闇」の魔素が2点発生する。また、このセッションの間、この人物に対する【運命】が1点上昇したキャラクターは「闇」の魔素を2点獲得する。',
            ]
    return get_table_by_1d6(table)
  end

  # 同盟表
  def magicalogia_alliance_table
    output = ""
    num, = roll(1, 6)
    if num == 1
      output = "精霊。その人物は、実は姿を変え、人間界に顕現した精霊だった。象徴する特技は#{magicalogia_random_skill_table_text_only}である。調査者は、そのセッションの間だけ、その特技の【精霊召喚】を修得する。また、セッションに一度だけ、その【精霊召喚】の判定を自動的に成功にすることができる。"
    elsif num == 2
      output = "騎士。その人物は、実は姿を変え、人間界に顕現した騎士だった。象徴する特技は#{magicalogia_random_skill_table_text_only}である。調査者は、そのセッションの間だけ、その特技の【騎士召喚】を修得する。また、セッションに一度だけ、その【騎士召喚】の判定を自動的に成功にすることができる。"
    elsif num == 3
      output = "魔王。その人物は、実は姿を変え、人間界に顕現した魔王だった。象徴する特技は#{magicalogia_random_skill_table_text_only}である。調査者は、そのセッションの間だけ、その特技の【魔王召喚】を修得する。また、セッションに一度だけ、その【魔王召喚】の判定を自動的に成功にすることができる。"
    elsif num == 4
      output = '魔法屋。その人物は、魔法の道具を取引するタリスモンガーだった。以降、この人物のいるシーンでは、自分のチャージしている魔素1つを別の魔素1つに交換してもらうことができる。また、この人物のいるシーンでは、自分の装備魔法1つを修得可能な別の装備魔法1つに交換してもらうことができる。'
    elsif num == 5
      output = '師匠。その人物は、かつて調査者に魔法を教えた師匠だった。以降、この人物のいるシーンでは、自分の修得している特技1つを修得可能な別の特技1つに交換してもらうことができる。また、この人物のいるシーンでは、自分の呪文魔法1つを修得可能な別の呪文魔法1つに交換してもらうことができる。'
    elsif num == 6
      output = '無垢。その人物は、汚れ無き心の持ち主だった。このNPCは、プライズとして扱う。このプライズの持ち主は、セッション中に一度、【浄化】の呪文をコストなしで使用することができる。この判定は自動的に成功する。'
    end
    return output, num
  end

  # ブランク秘密表
  def magicalogia_blank_secret_table
    outtext = ""
    outnum = ''
    num, = roll(1, 6)
    if num == 1
      outtext, outnum = magicalogia_inveterate_enemy_table
      outtext = "宿敵。#{outtext}"
    elsif num == 2
      outtext, outnum = magicalogia_conspiracy_table
      outtext = "謀略。#{outtext}"
    elsif num == 3
      outtext, outnum = magicalogia_fate_table
      outtext = "因縁。#{outtext}"
    elsif num == 4
      outtext, outnum = magicalogia_cueball_table
      outtext = "奇人。#{outtext}"
    elsif num == 5
      outtext, outnum = magicalogia_force_field_table
      outtext = "力場。#{outtext}"
    elsif num == 6
      outtext, outnum = magicalogia_alliance_table
      outtext = "同盟。#{outtext}"
    end
    outnum = "#{num},#{outnum}"
    return outtext, outnum
  end

  # プライズ表
  def magicalogia_prise_table
    table = [
             '敗者は内側から破裂し、四散する。功績点を1点獲得する。',
             '敗者は無数の蟲や小動物へと姿を変え、それを使い魔とする。勝者は好きな特技(魂の特技は除く)を一つ選ぶ。そのセッションの間、指定特技がその特技の【精霊召喚ん】【魔剣召喚】【悪夢召喚】のうち一つを修得する。',
             '敗者は爆発音と共にどこかへと消え、辺りには硫黄のような匂いだけが残る。勝者はそのセッション中に、一度だけ好きなタイミングで「変調」一種を回復することができる。',
             '敗者は奇妙な形をした数枚の金貨へと姿を変える。勝者は倒した相手のランクと等しい元型功績点を獲得する',
             '敗者は地面から突如現れた無数の腕に引き込まれながら、勝者に向かって賞賛の言葉と共に重要な何かを語る。公開されているハンドアウト一つを選び、その【秘密】を公開する。',
             '敗者は無数の光の粒へとなっていき、そこから魔素を得る。勝者は好きな魔素を2点獲得する(立会人に渡してもよい)。',
             '敗者はバラバラのページとなって地面に散らばり、そこから未知の力を読み取る。勝者は【一時的魔力】を2点獲得する。',
             '敗者は妙なる音楽へと変わり、その曲は勝者の心にしみいる。勝者は倒した相手のランクと等しい元型功績点を獲得する。',
             '敗者は一輪の花となる。勝者はそのセッション中に、一度だけ自分が振った行為判定のサイコロを振り直す権利を得る。',
             '敗者は言葉のかけらとなっていき、勝者はそこから未来の運命を読み取る。勝者は「事件表」を使用し、その結果を記録しておく。それ以降、そのセッション中のドラマシーンに、同じシーンに登場しているキャラクター一人を選び、一度だけその結果を適用できる。',
             '敗者は影となって、その場に焼き付き、異境への入り口となる。勝者は、好きな異境を一つ選ぶ。そのセッションの間、その異境へ移動できるようになる。',
            ]
    return get_table_by_2d6(table)
  end

  # 極限環境シーン表
  def magicalogia_extreme_environment_scene_table
    table = [
             '上下左右も分からない、完全なる闇。このシーンに登場しているPCのうち一人は、≪光≫の判定を行う。成功すると、闇の魔素二個を獲得する。失敗すると、｢遮断｣の変調を受ける。誰かが判定を行うと、成否に関わらずこの効果はなくなる。',
             '眼前に広がる業火の海。何もかも喰らい尽すような敵意は圧倒的だ。≪炎≫の判定を行う。失敗すると【魔力】が2点減少する。',
             '激しい天候で地形が一変する。さきほどまでの光景が嘘のようだ。≪嵐≫で判定を行う。失敗すると、【魔力】が1点減少する。',
             'どこまでも続く、砂漠。舞い上がる砂塵に、目を開けていられない。≪大地≫の判定を行う。失敗すると、｢封印｣の変調を受ける。',
             '言葉さえも凍り付きそうな極寒。生き物の気配は感じられない。【魔力】が1点減少する。',
             lambda { return "苛酷な自然環境によってキミたちは窮地に立たされる。#{magicalogia_random_skill_table_text_only}の判定を行うこと。成功すると、なんとか使えそうなものを探し、好きな魔素が一個発生する。失敗すると、キミの負った傷は時間と空間を超えて、キミのアンカーに不幸をもたらす。「運命変転」が発生する。" },
             '一面の雪野原に、てんてんと足跡が残っている。どうやら、先客がいるらしい。',
             '切り立つ崖の上。眼下には大きな海が広がっている。上空からは海鳥の鳴き声が聞こえてくる。',
             '高重力の地。身体全体が鉛に変わってしまったかのように感じられる。≪重力≫の判定を行う。失敗すると【魔力】が1点減少する。',
             '深い水の底。青に染まった空間に、何かが漂っている。このシーンに登場しているPCのうち一人は≪海≫の判定を行うことができる。成功すると、星の魔素を三個獲得する。失敗すると、【魔力】が2点減少する。誰かが判定を行うと、成否にかかわらずこの効果はなくなる。',
             '鼓膜を破りそうな、轟音が鳴り響く。言葉による意思の疎通は諦めた方がよさそうだ。≪旋律≫の判定を行う。失敗すると、チャージしているまその中から好きなものを二個失う。',
            ]
    return get_table_by_2d6(table)
  end

  # 内面世界シーン表
  def magicalogia_innner_world_scene_table
    table = [
             '肌の色と熱い吐息で満たされた場所。無数の男女が、思いつく限りの肉の欲望を実践している。このシーンに登場しているPCのうち一人は、≪エロス≫の判定を行うことができる。成功すると【一時的魔力】を1点獲得する。失敗すると【魔力】が2点減少する。誰かが判定を行うと、成否にかかわらずこの効果はなくなる。',
             '壁一面に、黒光りする虫がびっしりと張り付き、羽音を立てている部屋。この精神の持ち主は、虫が好きなのだろうか、嫌いなのだろうか。このシーンに登場しているPCのうち一人は、≪蟲≫の判定を行うことができる。成功すると、元型「蟲の騎士」をそのセッションの間、相棒にできる。相棒は、破壊か消滅するまで、自分が何らかのシーンに登場すると、そのシーンの種類に関わらず、同じタイミングで召喚される。失敗すると、虫が一斉に飛び立ち、そのシーンに登場しているPC全員の【魔力】が1点減少する。誰かが判定を行うと、成否にかかわらずこの効果はなくなる。',
             '誰もいない教室。なぜか、ヒソヒソと囁く声がどこからともなく聞こえ、見られているような視線を感じる。このシーンに登場しているPCのうち一人は、≪不安≫の判定を行うことができる。成功すると、公開されているハンドアウトの中から、好きな【秘密】を公開することができる。失敗すると、「遮断」の変調を受ける。誰かが判定を行うと、成否にかかわらずこの効果はなくなる。',
             '薄暗いが暖かく、ひどく安らぐ空間。ここはまるで、母親の胎内のようだ。このシーンに登場しているPCが、魔素を消費して、【魔力】の回復を行う場合、魔素一個につき、【魔力】を2点回復できる。',
             '遊園地。賑やかなパレードが目の前を通り過ぎて行くが、客は一人もいない。',
             lambda { return "夜の道。もやもやと黒いものが後ろから、追いかけてくる。はっきりした姿も分からないのに、ひどく恐ろしく感じる。このシーンに登場するPCは、#{magicalogia_random_skill_table_text_only}の判定を行う。成功すると、好きな魔素二個を獲得できる。失敗した場合、もやもやとした黒いものは君のアンカーの前に現れる。「運命変転」が発生する。" },
             '夕暮れの街。なんだか寂しい気分になる。',
             '床、壁、天井までが赤黒い色に染まった部屋。生臭い臭いが充満している。このシーンに登場しているPCのうち一人は≪血≫で判定を行うことができる。成功すると、【一時的魔力】2点を獲得する。失敗すると【魔力】が1点減少する。誰かが判定を行うと、成否にかかわらずこの効果はなくなる。',
             'どこへとも行くか知れぬ電車の中。あなたの他に乗客はいないようだが……。このシーンに登場しているPCのうち一人は≪異界≫で判定を行うことができる。成功すると、好きな異境一つに行くことができる魔法門を発見できる。失敗するとこのシーンに登場しているPC全員の【魔力】が2点減少する。誰かが判定を行うと、成否にかかわらずこの効果はなくなる。',
             '大勢の人が行き交う雑踏の中。誰も、あなたに関心を払わない。このシーンでは「不干渉」の世界法則を無視して、好きなキャラクターを調査することができる。',
             'どことも知れぬ空間。あなたの最も愛しい人が、目の前に現れる。このシーンに登場しているPCのうち一人は、≪情熱≫の判定を行うことができる。成功すると、好きなアンカーに対する【運命】を1点上昇させることができる。失敗すると、「運命変転」が発生する。誰かが判定を行うと、成否にかかわらずこの効果はなくなる。',
            ]
    return get_table_by_2d6(table)
  end

  # 魔法都市シーン表
  def magicalogia_magic_city_scene_table
    table = [
             '急に爆発が起こる。誰かが実験で失敗したらしい。「綻び」の変調を受けた後、「力」の魔素を二個獲得する。',
             '標本の並ぶ地下室。実験によって生み出された魔法生物が、瓶詰めにされて並んでいる。',
             'ごった返す市場。色とりどり食料品や日用品を始め、幻獣の目玉やマンドラゴラの根といった、魔法の触媒となる品までが商われている。このシーンに登場しているPCは、一人一度だけ、功績点1点を消費することで、好きな魔素を二個獲得することができる。',
             '魔法使いたちの集うサロン。ここなら、有益な情報が得られそうだ。このシーンに登場しているPCのうち一人は、≪物語≫の判定を行うことができる。成功すると、公開されているハンドアウトの中から、好きな【秘密】を公開することができる。失敗すると「封印」の変調を受ける。誰かが判定を行うと、成否にかかわらずこの効果はなくなる。',
             '大通り。幻獣の引く馬車や、絨毯や箒などの空飛ぶ乗り物が、せわしなく通り過ぎる。',
             lambda { return "広場。魔法使い同士が喧嘩を始め、魔法が飛び交い始める。このシーンに登場したPCは、#{magicalogia_random_skill_table_text_only}で判定を行う。成功すると、好きな魔素を二個獲得する。失敗すると、この場所の魔法の影響が時空を超えて、アンカーに現れる。「運命変転」が発生する。" },
             '賑わう酒場。客の中には妖精や魔物たちの姿も多い。このシーンに登場したPCは、【魔力】が1点回復する。',
             '入り組んだ路地裏。奇妙な異種族たちで構成された盗賊団に襲われる。≪雷≫で判定を行う。失敗すると【魔力】が2点減少するか、もし魔法にチャージした魔素を二個以上持っていればそれを消費するか、どちらかを選ぶ。',
             '都市の門。新たなる知識を求めてやってきた者、自分の世界へ帰る者、様々な世界の様々な人々が行き来する。',
             '歓楽街。角や尻尾、翼を持つ、肌もあらわな美女たちが、なまめかしい視線を送ってくる。このシーンに登場しているPCのうち一人は、≪エロス≫で判定を行うことができる。成功すると、元型「エロスの乙女」をそのセッションの間、相棒にできる。相棒は、破壊か消滅するまで、自分が何らかのシーンに登場すると、そのシーンの種類に関わらず、同じタイミングで召喚される。失敗すると【魔力】が1点減少する。誰かが判定を行うと、成否にかかわらずこの効果はなくなる。',
             '闘技場。魔法使いが、強化した元型や幻獣を競い合わせている。シーンプレイヤーのPCは、一度だけ、基本ルールブックに載っている、ランク4以下の〈書籍卿〉か〈越境者〉に、魔法戦を挑むことができる。勝利すると、「プライズ表」を使用することができる。',
            ]
    return get_table_by_2d6(table)
  end

  # 死後世界シーン表
  def magicalogia_world_after_dead_scene_table
    table = [
             '寂しげな村。影のような人々が時折行き来する。ここでは、死んだキャラクターに会うことができる。このシーンに登場しているPCのうち一人は、疵をひとつだけ、克服することができる。',
             'どこまでも広がる花畑。穏やかな雰囲気に満たされている。',
             '裁判所。強面の裁判官が、溢れる死者の群れに、次々と裁きを下している。≪嘘≫の判定を行う。失敗すると、【魔力】が2点減少する。',
             '白い光に包まれた食堂。豪勢な食事と美酒が、尽きることなく振る舞われる。このシーンに登場しているPCのうち一人は、≪肉≫の判定を行うことができる。成功すると、【一時的魔力】を1点獲得する。失敗すると、「病魔」の変調を受ける。誰かが判定を行うと、成否にかかわらずこの効果はなくなる。',
             lambda { return "床が白い雲になっている場所。雲の隙間からは、現世のような風景が見える。#{magicalogia_random_skill_table_text_only}の判定を行う。成功すると、このセッション中一度だけ、判定のサイコロを振り直すことができる。失敗すると、時空を越えて、アンカーが死後世界を垣間見てしまう。「運命変転」が発生する。" },
             '広い川の岸辺。向こう岸は、現世なのだろうか。このシーンに登場しているPCのうち一人は≪円環≫の判定を行うことができる。成功すると、魔力をリセットできる。誰かが判定を行うと、成否にかかわらずこの効果はなくなる。',
             '礼拝堂。死んでもなお、祈り続ける魂が、無言で跪いている。このシーンに登場しているPCのうち一人は、≪祈り≫の判定を行うことができる。成功すると、【一時的魔力】を2点獲得する。失敗すると、「不運」の変調を受ける。誰かが判定を行うと、成否にかかわらずこの効果はなくなる。',
             'ごく普通の住宅街。日常の営みを繰り返す魂の集う場所だ。',
             '拷問場。鬼たちが、使者に無限の責め苦を味合わせている。このシーンに登場しているPCのうち一人は、≪絶望≫の判定を行うことができる。成功すると、【一時的魔力】を2点獲得する。失敗すると、「綻び」の変調を受ける。誰かが判定を行うと、成否にかかわらずこの効果はなくなる。',
             '戦場。羽兜の乙女に率いられた戦士たちが、巨人と戦いを繰り広げている。このシーンに登場しているPCのうち一人は、≪天空≫で判定を行うことができる。成功すると、【一時的魔力】を3点獲得する。失敗すると、【魔力】が3点減少する。誰かが判定を行うと、成否にかかわらずこの効果はなくなる。',
             'どことも知れぬ空間。あなたの最も愛しい人が、目の前に現れる。このシーンに登場しているPCのうち一人は、≪情熱≫の判定を行うことができる。成功すると、好きなアンカーに対する【運命】を1点上昇させることができる。失敗すると、「運命変転」が発生する。誰かが判定を行うと、成否にかかわらずこの効果はなくなる。',
            ]
    return get_table_by_2d6(table)
  end

  # 迷宮世界シーン表
  def magicalogia_labyrinth_world_scene_table
    table = [
             'がらんとした、石畳の部屋。床に描かれた魔法陣が、不気味な光を放っている。このシーンに登場しているPCのうち一人は、≪異界≫で判定を行うことができる。成功すると、その魔法陣を地球に帰還できる魔法門として使用できる。失敗すると、魔法門から現れた道の怪物に襲われ、このシーンに登場しているPC全員の【魔力】が1D6減少する。誰かが判定を行うと、成否にかかわらずこの効果はなくなる。',
             '微かなランプの明かりに照らし出される牢獄。檻の中には、誰かの朽ちた骸が転がっている。このシーンに登場しているPCのうち一人は、≪死≫で判定を行うことができる。成功すると公開されているハンドアウトの中から、好きな【秘密】を公開することができる。失敗すると、死体が呪詛の言葉を吐き、このシーンに登場しているPC全員が「綻び」の変調を受ける。誰かが判定を行うと、成否にかかわらずこの効果はなくなる。',
             '通路の先に、扉と看板がある。看板の文字は宿屋と読める。このシーンに登場しているPC全員は、一度だけ、功績点1点を消費することで、調律を一度行うことができる。',
             '人一人通るのが、やっとの狭い通路が続いている。この廊下はどこまで伸びているのだろう?',
             '幾つもの扉と幾つもの分かれ道を進む。おや？いつの間にか、きみは迷ってしまった。シーンプレイヤー以外のPCが、このシーンに登場しようとする場合、≪道≫で判定を行う。失敗したPCは、このシーンに登場できない。',
             lambda { return "怪物が現れ、キミたちを襲う。このシーンに登場しているPC全員は、#{magicalogia_random_skill_table_text_only}の判定を行うこと。成功すると、怪物を倒し、好きな魔素が一個発生する。失敗すると、キミの負った傷は時間と空間を越えて、キミのアンカーに不幸をもたらす。「運命変転」が発生する。" },
             '目の前には、似たような扉がずらりとならんでいる。どの扉を開いたものか?',
             '暗闇の中から、うなり声が聞こえてくる。どうやら、近くに怪物が潜んでいるようだ。うまくやりすごせないものか……。≪静寂≫で判定を行う。失敗すると、【魔力】が1点減少する。',
             '通路が途切れ、深い谷が口を開けている。谷底まで光は届かず、まるで地の底まで続いているかのようだ。「闇」の魔素を一個獲得できる。',
             '金貨や銀貨、宝石に王冠、山のような宝物の積み上げられた部屋。番人は見当たらないが……。このシーンに登場しているPCのうち一人は、≪黄金≫で判定を行うことができる。成功すると1D6点の元型功績点かランダムに決定した魔素三個を獲得できる。失敗すると、このシーンに登場しているPC全員の【魔力】が1点減少する。誰かが判定を行うと、成否にかかわらずこの効果はなくなる。',
             '行き止まりの壁には、一見、意味不明な文字が並んでいる。ここから先に進むためには、この文字の謎を解かねばならないのだろうか。このシーンに登場しているPCのうち一人は、≪謎≫で判定を行うことができる。成功すると公開されているハンドアウトの中から、好きな【秘密】を公開することができる。失敗すると、部屋に仕掛けられた罠が発動し、このシーンは強制的に終了する。誰かが判定を行うと、成否にかかわらずこの効果はなくなる。',
            ]
    return get_table_by_2d6(table)
  end

  # 大判シーン表
  def magicalogia_new_scene_table
    table = [
             'ここではないどこか。魔法の力が満ちた異境の一つへ、一瞬だけ旅をする。そのシーンに星の魔素が1点発生する。',
             '夢の中。遠く過ぎ去った日々が、あなたの前に現れる。そのシーンに夢の魔素が1点発生する。',
             '強く風が吹き、雲が流されていく。遠く、雷鳴が聞こえた。そのシーンに力の魔素が1点発生する。',
             '静かなカフェの店内。珈琲の香りと共に、優しく穏やかな雰囲気が満ちている。',
             '無人の路地裏。ここならば、邪魔が入ることもないだろう。',
             lambda { return "周囲で〈断章〉が引き起こした魔法災厄が発生する。#{magicalogia_random_skill_table_text_only}の判定を行うこと。成功すると、そのシーンに好きな魔素が1点発生する。失敗すると、「運命変転表」を使用する。" },
             'なんの変哲もないおだやかな風景。しかし、その日常の背後で魔法災厄の影を感じる。',
             '読んでいた本を閉じる。そこには、あなたが知りたかったことが書かれていた。なるほど、そういうことか。',
             '夜の街を歩く。暖かな家々の明かりが、遠く見える。そのシーンに歌の魔素が1点発生する。',
             '大勢で賑わう広場。祭りでも行われているのだろうか？ 誰かを呼ぶ声が聞こえる。そのシーンに獣の魔素が1点発生する。',
             '悲劇の予感。家族の不幸、友の絶望、仲間の死......このままだと起きてしまうかもしれない出来事の幻が見える。そのシーンに闇の魔素が1点発生する。',
            ]

    return get_table_by_2d6(table)
  end

  # 指定特技（星）
  def magicalogia_random_skill_star_table
    table = [
             '黄金', '大地', '森', '道', '海', '静寂', '雨', '嵐', '太陽', '天空', '異界',
            ]

    return get_table_by_2d6(table)
  end

  # 指定特技（獣）
  def magicalogia_random_skill_beast_table
    table = [
             '肉', '蟲', '花', '血', '鱗', '混沌', '牙', '叫び', '怒り', '翼', 'エロス',
            ]

    return get_table_by_2d6(table)
  end

  # 指定特技（力）
  def magicalogia_random_skill_force_table
    table = [
             '重力', '風', '流れ', '水', '波', '自由', '衝撃', '雷', '炎', '光', '円環',
            ]

    return get_table_by_2d6(table)
  end

  # 指定特技（歌）
  def magicalogia_random_skill_poem_table
    table = [
             '物語', '旋律', '涙', '別れ', '微笑み', '想い', '勝利', '恋', '情熱', '癒し', '時',
            ]

    return get_table_by_2d6(table)
  end

  # 指定特技（夢）
  def magicalogia_random_skill_dream_table
    table = ['追憶', '謎', '嘘', '不安', '眠り', '偶然', '幻', '狂気', '祈り', '希望', '未来']

    return get_table_by_2d6(table)
  end

  # 指定特技（闇）
  def magicalogia_random_skill_night_table
    table = [
             '深淵', '腐敗', '裏切り', '迷い', '怠惰', '歪み', '不幸', 'バカ', '悪意', '絶望', '死',
            ]

    return get_table_by_2d6(table)
  end

  # 特技だけ抜きたい時用(星) あまりきれいでない
  def magicalogia_random_skill_table_text_only_star
    text, = magicalogia_random_skill_star_table
    return text
  end

  # 特技だけ抜きたい時用(獣) あまりきれいでない
  def magicalogia_random_skill_table_text_only_beast
    text, = magicalogia_random_skill_beast_table
    return text
  end

  # 特技だけ抜きたい時用(力) あまりきれいでない
  def magicalogia_random_skill_table_text_only_force
    text, = magicalogia_random_skill_force_table
    return text
  end

  # 特技だけ抜きたい時用(歌) あまりきれいでない
  def magicalogia_random_skill_table_text_only_poem
    text, = magicalogia_random_skill_poem_table
    return text
  end

  # 特技だけ抜きたい時用(夢) あまりきれいでない
  def magicalogia_random_skill_table_text_only_dream
    text, = magicalogia_random_skill_dream_table
    return text
  end

  # 特技だけ抜きたい時用(闇) あまりきれいでない
  def magicalogia_random_skill_table_text_only_night
    text, = magicalogia_random_skill_night_table
    return text
  end

  # 魔法使いの災厄
  def magicalogia_magi_fortune_change_table
    table = [
             '嫌悪。〈愚者〉たちを嫌悪し、〈大法典〉のやり方に疑問を覚えるようになる。この不幸が二度発生すると、その魔法使いは死亡しないで〈書籍卿〉になり、NPCとなる。この不幸が〈書籍卿〉に降り注いだ場合、不幸は無効化される。',
             '悪心。魔法に関する強い願いや邪悪な欲望が肥大化していく。この不幸が二度発生すると、その魔法使いは死亡した後〈禁書〉となり、NPCとなる。',
             '幽霊。肉体がほとんど失われ、霊的存在になる。この不幸が二度発生すると、その魔法使いは死亡ではなく消滅する。',
             '連鎖。運命変転が発生する。この不幸が二度発生しても死亡しない。',
             '変調。ランダムに変調1つを受ける。この不幸が二度発生しても死亡しない。',
             '消耗。【魔力】が1点減少する。この不幸が二度発生しても死亡しない。',
            ]
    return get_table_by_1d6(table)
  end

  # 魔法書架シーン表
  def magicalogia_magic_bookshelf_scene_table
    table = [
             lambda { return "〈禁書〉の保管庫へ入ることを許可された。幾重にも張り巡らされた決壊や、鋭い目つきの書警たちが目に付く。その隙をついて、〈禁書〉が襲い掛かってきた！このシーンに登場したPCは一人だけ《#{magicalogia_random_skill_table_text_only_force}》の判定を行う。失敗すると、【魔力】が3点減少する。成功すると、【一時的魔力】を3点得る。誰かが判定すると、成否にかかわらず、この効果はなくなる。" },
             '私室。狭いけれど、一番落ち着ける場所だ。このシーンに登場しているPCのうち一人は、【魔力】を上限まで回復させることができる。',
             '町の図書館。いつのまにか、人界に戻ってきてしまったようだ。このシーンに登場しているPCのうち一人は、好きなキャラクターを1人選び、事件表を一回振って、その効果を適用する。',
             '巨大な円卓がしつらえられた部屋。どうやらここは、会議場のようだ。',
             '長い廊下。学院の制服に身を包んだ少年少女が、笑いさざめきながら駆けていく。',
             lambda { return "荒れ果てた部屋。倒れた空っぽの本棚が、目に付く。これは〈大破壊〉の影響なのだろうか…。このシーンに登場するPCは、#{magicalogia_random_skill_table_text_only}の判定を行う。失敗すると、時空を超えてアンカーに影響が現れる。「運命変転」が発生する。" },
             '倉庫。未整理の本が山のように積まれて、司書たちが分類整理に追われている。',
             '誰かの研究室に迷い込む。積まれている魔導書が興味深い。',
             '高い天井と、天井まで続く壁を埋め尽くす、本の群れ。このすべてが、この書庫に所蔵された魔導書だ。このシーンに登場しているPCのうち一人は、【一時的魔力】を1点獲得する。',
             lambda { return "魔導書の閲覧室。数人の魔法使いが、熱心に魔導書を読んでいる。このシーンに登場しているPCのうち一人は、#{magicalogia_random_skill_table_text_only}の判定を行うことができる。成功すると、修得している魔法を一つ、修得可能な別の魔法に入れ替えることができる。失敗すると、「封印」の変調を受ける。誰かが判定すると、成否にかかわらず、この効果はなくなる。" },
             '本棚と本棚の間に、唐突に扉が浮かんでいる。この扉は、異界につながる戸口だ。一体どこにつながっているのだろう。異界シーン表の中からランダムに一つを選んで、その効果を適用する。',
            ]

    return get_table_by_2d6(table)
  end

  # 魔法学園シーン表
  def magicalogia_magic_academy_scene_table
    table = [
             '目の前に美しい黒龍が現れた。学院の長、ザナルパトスだ。彼は、何を告げようとしているのだろうか。',
             lambda { return "突然何かが襲い掛かってきた！生徒が元型の召喚に失敗したようだ。このシーンに登場しているPCのうち一人は、≪#{magicalogia_random_skill_table_text_only_force}≫の判定を行う。失敗すると、【魔力】が3点減少する。成功すると、【一時的魔力】を3点得る。誰かが判定すると、成否にかかわらず、この効果はなくなる。" },
             lambda { return "ここは女子寮？このシーンに男性のPCが登場した場合、その男性PCは≪#{magicalogia_random_skill_table_text_only_beast}≫の判定を行う。失敗すると、「封印」の変調を受ける。" },
             '寮の廊下。「どなたですか？」寮監のシグリットに呼び止められた。このシーンに登場しているPCは≪自由≫で判定を行う。失敗すると、このシーンで行う判定すべてにマイナス1の修正を受ける。',
             '天井の高い廊下。分厚い扉の向こうからかすかに授業を行う講師の声が聞こえてくる。',
             lambda { return "扉を開けて現れたのは、よく知る相手だった。なぜか、学院に迷い込んでしまったようだ。#{magicalogia_random_skill_table_text_only}で判定を行う。失敗すると、「運命変転」が発生する。" },
             '誰かが作った秘密の小部屋に迷い込んでしまう。学園ではあまり食べられないお菓子が山のように仕舞われているようだ。',
             '学院西部に広がるアーデンの森。鳥の鳴き声が聞こえる。',
             lambda { return "授業を行っている教室。講師が呼び出した元型がこちらに向かって飛んでくる。このシーンに登場しているPCは一人だけ#{magicalogia_random_skill_table_text_only}で判定を行う。失敗すると【魔力】が1点減少する。成功すると、その特技の精霊が召喚できる。誰かが判定すると、成否にかかわらず、この効果はなくなる。" },
             lambda { return "生徒に何か魔法を見せて欲しいと乞われる。このシーンに登場しているPCは一人だけ、≪#{magicalogia_random_skill_table_text_only_dream}≫の判定を行う。失敗すると、「不運」の変調を受ける。成功すると、「夢」の魔素をを2点獲得する。誰かが判定すると、成否にかかわらず、この効果はなくなる。" },
             lambda { return "自習室。生徒たちが必死に魔導書を理解しようとしている。このシーンに登場しているPCは一人だけ、≪#{magicalogia_random_skill_table_text_only_star}≫の判定を行う。成功すると、好きな魔素をを2点獲得する。誰かが判定すると、成否にかかわらず、この効果はなくなる。" },
            ]

    return get_table_by_2d6(table)
  end

  # クレドの塔シーン表
  def magicalogia_tower_credo_scene_table
    table = [
             '目の前に一人の少女が現れる。眠り姫の長、ラトゥナだ。ずっと眠り続けている筈の彼女が現れたのは、いったい何を告げるためなのだろうか。',
             lambda { return "突然何かが襲い掛かってきた！未熟な魔法使いが元型の召喚に失敗したようだ。このシーンに登場しているPCは一人だけ、≪#{magicalogia_random_skill_table_text_only_force}≫の判定を行う。失敗すると、【魔力】が3点減少する。成功すると、【一時的魔力】を3点得る。誰かが判定すると、成否にかかわらず、この効果はなくなる。" },
             lambda { return "話しかけてきた天涯預言者が、不幸な未来を予言する。このシーンに登場しているPCは一人だけ、≪#{magicalogia_random_skill_table_text_only_dream}≫の判定を行う。失敗すると、【魔力】が1点減少する。成功すると、「夢」の魔素をを1点獲得する。誰かが判定すると、成否にかかわらず、この効果はなくなる。" },
             '塔の内側の壁に並ぶ、無数の魔道書の前。この中から、なにかの手がかりが得られるかも知れない。このシーンに登場しているPCのうち一人は、【一時的魔力】を1点獲得する。',
             '小さな客間で〈大法典〉からの使者との会合が行われている。天涯が新たな予言を伝えているのかも知れない。',
             lambda { return "こんな場所にいる筈のない人が君の前にあらわれる。眠り姫の眠りの中に迷い込んでしまったらしい。#{magicalogia_random_skill_table_text_only}で判定を行う。失敗すると、「運命変転」が発生する。" },
             '塔の上。山脈の連なりとその上に浮かぶ月が、塔を静かに見下ろしている。',
             '塔の外壁に作られた螺旋階段の上。強い風が吹き付けている。',
             'クレドの塔に続く、険しい山道。何かが潜んでいるんだろうか…。「獣」の魔素を1点獲得できる。',
             '幻夢殿の中。眠り姫達の安らかな寝息が聞こえてくる。こちらも眠くなってくる。',
             '突然、目の前に扉が現れる。この扉は、異界につながる戸口だ。一体どこにつながっているのだろう。異界シーン表の中からランダムに一つを選んで、その効果を適用する。',
            ]

    return get_table_by_2d6(table)
  end

  # 並行世界シーン表
  def magicalogia_parallel_world_scene_table
    table = [
             'カフェのテーブル。FMラジオは、去年解散したはずのバンドの、先日発表した新曲を流している。このシーンに登場しているPCのうち一人は、「時の流れ表」を1回振り、効果を適用する。',
             lambda { return "賑やかな通り。向こうから、あなたにそっくりな人物が歩いてくる。あれはこの世界の、あなた自身だろうか。このシーンに登場しているPCの一人は、#{magicalogia_random_skill_table_text_only}の判定を行う。成功すると、好きな魔素をを2点獲得する。失敗すると、「病魔」の変調を受ける。誰かが判定すると、成否にかかわらず、この効果はなくなる。" },
             '夜の街を歩く。よく知っている筈の風景なのに、どこか違うという違和感がぬぐえない。',
             '買い物客でにぎわう商店街。つぶれたはずの店が健在であったり、繁盛しているはずの店が潰れていたりしている。',
             '繁華街。ビルの大型ビジョンから、知らない国同士の戦争に関するニュースが流れている。',
             lambda { return "縁のある人の家の前。玄関から、見知らぬ人が現れ、こちらを不審げに眺めている。この人はもしかして…？#{magicalogia_random_skill_table_text_only}で判定を行う。失敗すると、「運命変転」が発生する。" },
             '乗客のいない電車の中。時折、聞き覚えのない駅名がアナウンスされる。',
             '学校帰りの学生たちが目立つ、駅前のロータリー。あの学校の制服のリボンは、赤だっただろうか？',
             '洋館の前。ここに、こんな建物はなかった筈だが。',
             lambda { return "小学校の前を通る。音楽室の窓から、見知らぬ音楽家の肖像が見える。≪#{magicalogia_random_skill_table_text_only_poem}≫の判定を行う。失敗すると、「封印」の変調を受ける。" },
             '目の前で、以前、経験した出来事が起きる。この世界では、これは、今から起きる出来事なのだ。このシーンに登場しているPCのうち一人は、このシーンの間、判定に+1の修正を受ける。',
            ]

    return get_table_by_2d6(table)
  end

  # 終末シーン表
  def magicalogia_post_apocalypse_scene_table
    table = [
             '夜。雨宿りのために足を踏み入れた寺院に危険は気配はなく、ゆっくり休めそうだ。静に時が流れていく。',
             '夜。雑草が生い茂り、ツタに覆われた人気のない山村で巨大な肉食獣が襲い掛かってくる。このシーンに登場しているPCのうち一人は、≪牙≫の判定を行わなければならない。失敗すると、【魔力】が2点減少する。誰かが判定すると、成否にかかわらず、この効果はなくなる。',
             '夜。大規模な爆撃で地平線と化した戦場跡。どこの国ともわからぬ国旗が夜風に吠えている。虚憑が一体襲い掛かってくる。魔法戦を行うこと。この魔法戦はゲーム中に一度だけ発生する。',
             lambda { return "夜。もはや廃墟と化した埃っぽい都市。〈愚者〉が虚憑に襲われている。このシーンに登場しているPCの一人は、#{magicalogia_random_skill_table_text_only}の判定することができる。成功すれば救出でき、助け出した〈愚者〉に対し、好きな属性で運命を1点獲得する。失敗すると【魔力】を3点失う。" },
             '夜。虚憑の群れに付きまとわれる。シーンプレイヤーは≪悪意≫の判定を行う。失敗するとこのシーンの間、あらゆる判定がマイナス2される。',
             '夜明け前。ハイウェイが一直線に突き抜ける灰色の荒野。静かすぎて自らの鼓動を感じるほどだ。虚憑が一体襲い掛かってくる。魔法戦を開始すること。2ラウンド経過するまでは夜、以降のラウンドは昼として処理する。この魔法戦はゲーム中に一度だけ発生する。',
             '昼。〈愚者〉の子供が、歴史的な遺産を遊び場に、一人遊びをしている。この子の未来はどうなるのだろうか。',
             '昼。世界大戦で墜落した戦闘機が、砂漠の砂に半ば埋もれている。だが、そのエンジンは死んでいない。このシーンに登場しているPCの一人は≪風≫で判定を行うことができる。成功すると魔力のリセットを行う。成否にかかわらず、この効果は一度だけ発生する。',
             '昼。広い建物が並ぶ美しい海岸。かつてはリゾート地だったそこには、白い遺骨が大量に打ち上げられ、潮騒に洗われている。誰か一人が≪別れ≫の特技の判定に成功すると、ランダムに選んだ魔素3点を獲得する。誰かが判定すると、成否にかかわらず、この効果はなくなる。',
             '昼。崩壊した農村のかたわらで、美味しそうな果実を発見する。≪大地≫の判定に成功すると【魔力】が2点回復する。',
             '夕刻。錆び付いた線路。その先までたくさんのしゃれこうべが無造作に転がっている。虚憑が一体襲い掛かってくる。魔法戦を開始すること。2ラウンド経過するまでは昼、以降のラウンドは夜として処理する。この魔法戦はゲーム中に一度だけ発生する。',
            ]

    return get_table_by_2d6(table)
  end

  # 異世界酒場シーン表
  def magicalogia_god_bar_scene_table
    table = [
             'マスターの雷神に絡まれる。このシーンに登場しているPCのうち一人は、雷神相手に「事件表」を振る。',
             '神々しく光輝く、威厳に溢れた神が現れ、場の雰囲気を支配する。このシーンの間、「世界法則」に「調査阻害」が加わる。',
             '上の階に登ろうとすると、キマイラが待ち構えている。このシーンに登場しているPCのうち一人は、≪炎≫で判定を行う。失敗すると、【魔力】が1点減少する。成功するまで判定を行うこと。この効果は一度だけ発生する。',
             '「かんぱーい！」注がれた酒をつい飲んでしまう。ずいぶん強いスピリッツのようだが。このシーンに登場しているPCのうち一人は、≪水≫で判定を行うことができる。成功すると魔貨を1点手に入れる。成否にかかわらずこの効果は一度だけ発生する。',
             '乾杯のかけ声、酔っ払いの笑い声、あちこちのテーブルでは大きな話し声…。どこにでもある、酒場の光景だ。',
             lambda { return "客の一人に、無理矢理酒を飲まされる。なんて強い酒だろう。#{magicalogia_random_skill_table_text_only}で判定を行う。失敗すると、「運命変転」が発生する。" },
             '階段を上っている。いったいいつから登り始めたのか記憶にない。これはどこまで続くのだろう。',
             '建物の中の筈なのに、雷雲が立ちこめ、嵐が巻き起こる。神々がケンカしている！このシーンに登場しているPCのうち一人は、≪嵐≫で判定を行う。失敗すると、【魔力】が2点減少する。成否にかかわらずこの効果は一度だけ発生する。',
             '扉の前に、妖怪が張り付いていて、通してくれない。妖怪は何かくれと強請ってくる。このシーンに登場しているPCのうち一人は、好きな魔素を1点減少する。減少する魔素がない場合、【魔力】が1点減少する。',
             '上の階に登ろうとすると、竜が待ち構えている。このシーンに登場しているPCのうち一人は、≪牙≫で判定を行う。失敗すると、「綻び」の変調を受ける。成否にかかわらず、この効果は一度だけ発生する。',
             '美しい女神が、鏡をのぞき込んでいる。どうやら、運命が映る鏡だと言うのだが。このシーンに登場しているPCのうち一人は、≪未来≫で判定を行っても良い。成功すると好きなアンカーとの【運命】が1点上昇する。成否にかかわらず、この効果は一度だけ発生する。',
            ]

    return get_table_by_2d6(table)
  end

  # ほしかげシーン表
  def magicalogia_starlight_scene_table
    table = [
             'あなたの持つ「切符」は無効であると車掌に告げられる。他の乗客の視線を感じる。このシーンに登場しているPCのうち一人は、もう一度「切符」を調達しなければならない。魂の特技の判定を、成功するまで繰り返すこと。',
             'ごとごと。ごとごと。ガラスより透き通る銀河の水辺を走る。色とりどりの花々が星の光に冴え渡っては通り過ぎて行く。',
             'ふと目を覚ます。汽車に揺られていつの間にか眠っていたらしい。夢の中で誰かと会っていた気がしてならない。シーンプレイヤーが≪深淵≫の判定に成功すると、ランダムに選んだアンカーとの運命が1点上昇する。',
             '銀河の水辺にぽつりと浮かぶ島に、目の覚めるような白い立派な十字架がそびえたっている。このシーンに登場しているPCのうち一人は、≪祈り≫で判定を行うことができる。成功すると、以降このゲーム中に発生する魔法災厄が一回だけ無効化される。誰かが判定すると、成否にかかわらず、この効果はなくなる。',
             '窓から銀河を見つめる、黒い外套を着た少女がいる。あなたに気づくとお菓子を差し出し、にこりと笑って去っていく。シーンプレイヤーはランダムに選んだ魔素を1点獲得する。',
             'ノイズ混じりの車内放送が「停車駅」への到着を告げる。しばらくすると「汽車」が止まった。キャラクターは「停車駅」で降りることができる。降りる場合、「停車駅」の世界法則を決定し、その法則に従ってシーンを進めること。',
             '車窓の向こうに、星明りに照らされたススキ野原が青白く広がる。そんな中で、不思議な紋様の書かれた三角標が何本か、ぽつり、ぽつりと立ち尽くしているのが見えた。',
             '気づくと誰もいない。青いビロウドを張った座席だけが、空間をむなしく彩っている。シーンプレイヤー以外のPCが、このシーンに登場しようとする場合、≪静寂≫で判定を行う。失敗したPCは、このシーンに登場できない。',
             lambda { return "「この席、よろしいかな？」あなたの隣に〈書籍卿〉が座る。#{magicalogia_random_skill_table_text_only}の判定に成功すると公開されているハンドアウトの中から、好きなものを選び、その【秘密】を公開することができる。誰かが判定すると、成否にかかわらず、この効果はなくなる。" },
             '銀河を超える渡り鳥の群れ。しばし「汽車」と並走し、やがて離れ、天の川のようにきらきらした光の帯になっていく。このシーンに登場しているPCのうち一人は、≪翼≫で判定を行うことができる。成功すると魔力をリセットできる。誰かが判定すると、成否にかかわらず、この効果はなくなる。',
             '隣の車輛から誰かが移ってきた。なんと、あなたのアンカーである。このシーンに登場しているPCをランダムに一人選び、そのPCのアンカーの中から、この異境に存在しない〈愚者〉のアンカーをランダムで一人選ぶこと。そのアンカーが、元の世界へ無事戻ることができたら、ゲーム終了時に功績点を1点獲得する。',
            ]

    return get_table_by_2d6(table)
  end

  # 世界法則追加表
  def magicalogia_world_low_add_table
    table = [
             '世界法則「楽園」。この「停車駅」は美しく、慰めに満ちている。この「停車駅」で降りた〈愚者〉は魅了され、ここで一生を過ごすことになる。「刻印百景」の特技で判定に成功すると、これを押しとどめることができる。この判定は、対象の〈愚者〉一人につき一回しかできない。',
             '世界法則「夜祭」。星の明かりや提灯を頼りに、終わらないお祭りが続いている。このシーンに登場しているキャラクターは、「刻印百景」の特技で判定に成功すると、【手当】の俗呪を使用したとき、消費した魔素1点につき、【魔力】を2点回復できるようになる。',
             '世界法則「遺棄」。この「停車駅」の周辺は、様々なモノが捨てられている。シーンプレイヤーが「刻印百景」の特技で判定に成功すると、魔法【回想】と同じ効果が一回だけ発生する。誰を対象とするかは、シーンに登場しているキャラクターの中から、ランダムに選ばれる。',
             '世界法則「楽園」。この「停車駅」の周辺は、魔素を帯びた不思議な色合いの羽をもつ蝶が生息している。このシーンに登場しているキャラクターは、「刻印百景」の特技で判定に成功すると、任意の魔素を2点獲得できる。失敗すると、ランダムに選んだ変調1つを受ける。',
             'この「停車駅」の周辺は死んだ〈愚者〉たちの終着点でもある。もしここで降りる〈愚者〉がいれば、その人物は死んでいたことになる。このシーンに登場しているキャラクターがその〈愚者〉をアンカーとしている場合、「刻印百景」の特技で判定に成功すると、「疵」になることなく運命欄から消去できる。',
             '世界法則「魔法門」。他の異境への入り口が存在する。「刻印百景」の特技で判定に成功すると、その魔法門を発見できる。',
            ]
    return get_table_by_1d6(table)
  end

  # さまよう怪物表
  def magicalogia_wondaring_monster_table
    table = [
             lambda { return "トロールに率いられたオークとゴブリンの大軍団に遭遇する。数百という怪物たちが野蛮な叫び声をあげながら、魔法使いたちに襲い掛かってくる。≪#{magicalogia_random_skill_table_text_only_star}≫の判定を行う。全員の判定が終わったら、失敗したPCは1d6点のダメージを受ける。このとき、判定に成功したPCの数だけそのダメージの値を軽減できる。" },
             lambda { return "大きな猛牛の頭をした巨漢…ミノタウロスが立ち塞がる。手に持った青銅の斧を振りかぶる。シーンに登場しているPCの中からランダムに代表を1人選ぶ。代表は≪#{magicalogia_random_skill_table_text_only_beast}≫の判定を行う。失敗すると、PC全員は2点のダメージと「綻び」の変調を受ける。" },
             lambda { return "突如、ドラゴンが現れる。深紅の鱗に覆われた巨影は、鎌首をもたげると、数瞬後、強烈な炎を吐いた。シーンに登場しているPC全員は≪#{magicalogia_random_skill_table_text_only_force}≫の判定を行う。全員の判定が終わったら、PC全員は、1+判定に失敗した人数点のダメージを受ける。" },
             lambda { return "白銀の鎧に身を包んだ騎士が現れる。騎士は一対一の勝負を挑んできた。シーンに登場しているPCの中から代表を1人選ぶ。代表は≪#{magicalogia_random_skill_table_text_only_poem}≫の判定を行う。失敗すると代表は5点のダメージを受ける。" },
             lambda { return "美しい上半身と獣の下半身を持つ女怪が現れる。艶めかしくその体をくゆらせながら、手を差し出してくる。シーンに登場しているPC全員は≪#{magicalogia_random_skill_table_text_only_dream}≫の判定を行う。失敗したPCは、3点のダメージを受け、好きな魔素を3点失う。" },
             lambda { return "黒いローブをまとった幽鬼が現れる。枯れ木のような細い腕を振り上げて、勇気は呪いの言葉を叫ぶ。幽鬼の【魔力】は4点。シーンに登場しているPC全員は≪#{magicalogia_random_skill_table_text_only_night}≫の判定を行う。失敗したPCは、「不幸」の変調を受け、運命変転が発生する。" },
            ]
    return get_table_by_1d6(table)
  end

  # 落花表
  def magicalogia_fallen_flower_table
    table = [
             '肉体が枯れるように崩壊する。その苦痛は耐え難いもののようだ。人の言葉にならない断末魔が聞く者を苛み、死ぬ。〈永遠〉をアンカーにしているものは、それが疵になる。',
             '精神が壊れる。その唇から、〈永遠〉が抱く夢や願望だけが小さく小さく、壊れた楽器のように吐き出され、季節が変わる頃に、死ぬ。〈永遠〉をアンカーにしているものは、それが疵になる。',
             'その生命力が暴走し、死と再生が繰り返される。助けてくれと懇願する声すら出せない。1d6ヶ月後、死ぬ。〈永遠〉をアンカーにしているものは、それが疵になる。',
             '〈禁書〉とともに封印に飲み込まれる。運命を結んでいるPCの夢に、暗い、怖い、助けてくれと繰り返し現れるが、次の新月の夜にふつりと途切れる。〈永遠〉をアンカーにしているものは、それが疵になる。',
             'その時は何も起きない。運良く助かったか、〈愚者〉に戻れたようにも見える。だが一度でも眠りにつけば、目を覚ますことなく死ぬ。〈永遠〉をアンカーにしているものは、それが疵になる。',
             '身体がしおれ、「種」が落ちる。しかし、再生することはない。もし大地に埋めてやれば、何かの植物として芽吹くだろう。（〈永遠〉をアンカーにしているものは、そのアンカーを失う。疵にはならない）',
            ]
    return get_table_by_1d6(table)
  end

  # 旧図書館シーン表
  def magicalogia_old_library_scene_table
    table = [
             lambda { return "曲がり角。唐突に〈禁書〉が現れ、襲いかかってきた！このシーンに登場するPCは、#{magicalogia_random_skill_table_text_only}で判定を行う。失敗すると、【魔力】を3点失う。" },
             '通路の真ん中。扉を開けて〈旧世界秩序〉の〈書籍卿〉「古き書物の化身」が現れた。彼はこのシーンに登場しているPCに協力を申し出る。このシーンに登場しているPCの一人は、《嘘》で判定を行う。成功すると〈書籍卿〉はこのシナリオの間、そのPCが行う魔法戦で、一度だけ立会人になる。失敗すると〈書籍卿〉は怒り出し、次のシーンでそのPCに対して、魔法戦をしかけてくる。誰かが判定すると、成否にかかわらず、この効果はなくなる。',
             '元・研究室。壊れた実験道具が床に散らばっている。',
             '元・閲覧室。数人の魔法使いたちが休んでいる。ここならば、色々な話が聞けそうだ。',
             '空の書架が並ぶ、開けた空間。ここならば、一息つけるだろう。',
             lambda { return "破壊された魔導書が、山のように積み重なる場所。本の山に隠れていた〈断章〉が襲い掛かってくる。このシーンに登場するPCは、#{magicalogia_random_skill_table_text_only}で判定を行う。成功すると、〈断章〉を倒し、好きな魔素を一個手に入れる。失敗すると、時空を超えてアンカーに影響が現れる。「運命変転」が発生する。" },
             '破壊された書架が重なり合って作り上げた、迷路のような通路が続く。この先には、何があるのだろうか',
             '元・宿舎。簡素な寝台が、いくつか残っている。',
             '通路の行き止まり。目の前になぜか大きな箱がある。このシーンに登場しているPCの一人は、《謎》で判定を行うことができる。成功すると、箱の中にプライズを発見する。「プライズ表」を1回使用することができる。失敗すると、トラップが発動する。箱は爆発し、このシーンに登場しているPC全員の【魔力】が1点減少する。誰かが判定すると、成否にかかわらず、この効果はなくなる。',
             lambda { return "どこからか湧き出した水が、床の上に泉を作っている場所。泉の上に何者かの呼び出した元型が浮かんでいる。#{magicalogia_random_skill_table_text_only}で判定を行う。成功すると、【一時的魔力】を1点手に入れる。失敗すると、攻撃され、【魔力】が1点減少する。誰かが判定すると、成否にかかわらず、この効果はなくなる。" },
             'なぜ、君がここに？扉を開けると、そこにはPCのアンカーがいた。シーンプレイヤーのアンカーの中から、ランダムに一人を選ぶ。そのアンカーが登場する。シーンプレイヤーは、そのアンカーに「事件」を行っても、行動済みにならない。',
            ]
    return get_table_by_2d6(table)
  end

  # 大判時の流れ表
  def magicalogia_new_time_passage_table
    table = [
             lambda { return "波乱万丈の人生を送る。この時代に起きた有名な事件の背後では、多くの魔法的存在が暗躍していた。あなたも、その事件に関わり、〈禁書〉や〈書籍卿〉たちと戦いを繰り広げる。#{magicalogia_random_skill_table_text_only}の判定を行う。成功するとセッション終了時に追加で功績点を1点獲得する。失敗すると、自分に「運命変転」が発生する。" },
             lambda { return "冒険の日々の途中、大きな幸せがおとずれる。#{magicalogia_random_skill_table_text_only}の判定を行う。成功すると、自分のアンカーが負っている不幸か、自分が負っている疵一つを無効化する。" },
             '瞑想していたのか。それとも何か封印されていたのか。長い眠りから目を覚ます。もうそんな時間か。おかげで十分に休息できた。ランダムに魔素を三個獲得するか、自分が「魔力のリセット」を行うか、自分の受けている変調をすべて回復する。',
             '特殊な異境に旅をしていた。そのせいか、人界で何が起きていたのかまったく分からない。浦島太郎になった気分だ。異境の土産として、魔貨を1d6点獲得する。',
             '市井の人々に交じって平穏な日々をおくる。そんな日々の中にも、ちょっとした事件が起きた。自分のアンカーを一人目標に選んで「事件表」を振ることができる。',
             '日々研鑚を重ね、魔法の修行に精進した。もしも望むなら、蔵書欄にある魔法を、自分の修得可能な別の魔法に変更して構わない。もしも、魔素がチャージされていた魔法を未習得にした場合、その魔素は失われる。',
            ]
    return get_table_by_1d6(table)
  end

  # その後表
  def magicalogia_fallen_after_table_low
    table = [
             '成就者は、邪悪な魔法の力にひかれるようになる。成就者が、そのセッションで〈断章〉に憑依されていたり、魔法災厄の犠牲になったりしていた場合、【堕落値】が1点上昇し、堕落チェックを行う。堕落チェックに失敗した場合、成就者は命を落とし、そのPCの疵となる。',
             '成就者は、自分の不幸が魔法使いによるものだと信じるようになる。成就者が何らかの不幸に見舞われていた場合、【堕落値】が1点上昇し、堕落チェックを行う。堕落チェックに失敗した場合、願いを叶えたPCの成就者との【運命】の値が2点減少する。',
             '成就者は、自分が特別な人間だと信じるようになる。願いを叶える努力を放棄するようになり、自堕落になる。成就者の【堕落値】が2点上昇する。堕落チェックを行う。堕落チェックに失敗した場合、「運命変転表『狂気的災厄』」を使用し、その不幸を受ける。',
             '成就者は、願いが叶い、欲望が増大する。次はより大きな願いを求めるようになるだろう。成就者の【堕落値】が1点上昇する。堕落チェックを行う。堕落チェックに失敗した場合、「運命変転表『社会的災厄』」を使用し、その不幸を受ける。',
             '成就者は、自分の願いを叶えたのが魔法によるものだと気付く。成就者の【堕落値】が1点上昇する。堕落チェックを行う。堕落チェックに失敗した場合、「運命変転表『超常的災厄』」を使用し、その不幸を受ける。',
             '成就者は、自分の願いを叶えたのがPCだと気付く。成就者の【堕落値】が、そのPCの成就者との【運命】の値と同じ値になる。もし、この効果によって【堕落値】が以前より増えていた場合、堕落チェックを行う。堕落チェックに失敗した場合、成就者は〈愚者〉ではなくなり、魔法使いとなる。',
            ]
    return get_table_by_1d6(table)
  end

  def magicalogia_fallen_after_table_high
    table = [
             '成就者は、突如自分に訪れた幸運に罪悪感を覚えるようになる。もし成就者の【堕落値】が1点以上だった場合、堕落チェックを行う。堕落チェックに失敗した場合、「運命変転表『精神的災厄』」を使用し、その不幸を受ける。',
             '成就者は、願いを叶えたPCに対して不信感を感じるようになる。自分は利用されているのでは無いかと疑い始め、願いを叶えたPCと距離を取る。成就者との【運命】の値が1点減少する。',
             '成就者は、叶えて貰った願いを失うことになる。堕落チェックを行う。堕落チェックに成功すると、【堕落値】が1点減少する。',
             '成就者は、願いを叶えたPCが魔法使いだと気付く。以降、その成就者の【堕落値】が上昇することがあった場合、その上昇値が1点増える（この効果は累積しない）。この効果が気に入らない場合、PCはその成就者の自分に関する記憶を消すことで、この効果を無効化することもできる。その場合、PCの成就者との【運命】の値は1になる。',
             '成就者は、突然の幸運に感謝しつつも、自分の日常と戦っていく。もし、成就者に【堕落値】が1点以上ある場合、その値が1点減少する。',
             '成就者は、信じれば夢が叶うと思うようになり、少しだけ前向きになる。PCは功績点を1点獲得する。',
            ]
    return get_table_by_1d6(table)
  end

  def magicalogia_fallen_after_table
    outtext = ""
    outnum = ''
    num, = roll(1, 6)
    if num <= 3
      outtext, outnum = magicalogia_fallen_after_table_low
      outtext = outtext.to_s
    else
      outtext, outnum = magicalogia_fallen_after_table_high
      outtext = outtext.to_s
    end
    outnum = "#{num},#{outnum}"
    return outtext, outnum
  end
end
