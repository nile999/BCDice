# -*- coding: utf-8 -*-

class KanColle < DiceBot
  def initialize
    super
    @sendMode = 2
    @sortType = 3
    @d66Type = 2
  end

  def gameName
    '艦これRPG'
  end

  def gameType
    "KanColle"
  end

  def getHelpMessage
    return <<INFO_MESSAGE_TEXT
例) 2D6 ： 単純に2D6した値を出します。
例) 2D6>=7 ： 行為判定。2D6して目標値7以上出れば成功。
例) 2D6+2>=7 ： 行為判定。2D6に修正+2をした上で目標値7以上になれば成功。

2D6での行為判定時は1ゾロでファンブル、6ゾロでスペシャル扱いになります。
天龍ちゃんスペシャルは手動で判定してください。

・各種表
　・感情表　ET／アクシデント表　ACT
　・日常イベント表　EVNT／交流イベント表　EVKT／遊びイベント表　EVAT
　　演習イベント表　EVET／遠征イベント表　EVENT／作戦イベント表　EVST
　・ほのぼのイベント表　ETHT／航海イベント表　ETVT　外出イベント表　ETGT
　　激戦イベント表　ETBT／任務イベント表　ETMT／恐怖イベント表　ETFT／侵攻効果表　ETIT
　・大規模部隊表 LSFT／艦隊敗北表 LFDT／艦隊勝利表 LFVT
　・開発表　DVT／開発表（一括）DVTM
　　　装備１種表　WP1T／装備２種表　WP2T／装備３種表　WP3T／装備４種表　WP4T
　・アイテム表　ITT／目標表　MHT／戦果表　SNT／特殊戦果表　SPSNT
　・ランダム個性選択：一括　KTM／分野　BT
　　　背景　KHT／魅力　KMT／性格　KST／趣味　KSYT／航海　KKT／戦闘　KSNT
　・戦場表　SNZ　暴走表／RNT
　・特殊開発表　WPMC　(燃料6/弾薬3/鋼材6/ボーキ3)
　・新・特殊開発表　WPMCN
　・艦載機関開発表　WPFA　(燃料3/弾薬6/鋼材3/ボーキ6)
　・砲類開発表　WPCN　(燃料3/弾薬6/鋼材6/ボーキ3)　
　・敵深海棲艦の装備決定 BT2～BT12
・D66ダイス(D66S相当=低い方が10の桁になる)
INFO_MESSAGE_TEXT
  end

  def check_2D6(total_n, dice_n, signOfInequality, diff, dice_cnt, dice_max, n1, n_max) # ゲーム別成功度判定(2D6)
    return '' unless signOfInequality == ">="

    if dice_n <= 2
      return " ＞ ファンブル（判定失敗。アクシデント表を自分のＰＣに適用）"
    elsif dice_n >= 12
      return " ＞ スペシャル（判定成功。【行動力】が１Ｄ６点回復）"
    elsif total_n >= diff
      return " ＞ 成功"
    else
      return " ＞ 失敗"
    end
  end

  def rollDiceCommand(command)
    output = '1'
    type = ""
    total_n = ""

    case command
    when 'ET'
      type = '感情表'
      output, total_n = get_emotion_table
    when 'ACT'
      type = 'アクシデント表'
      output, total_n = get_accident_table

    when 'EVNT'
      type = '日常イベント表'
      output, total_n = get_nichijyou_event_table
    when 'EVKT'
      type = '交流イベント表'
      output, total_n = get_kouryu_event_table
    when 'EVAT'
      type = '遊びイベント表'
      output, total_n = get_asobi_event_table
    when 'EVET'
      type = '演習イベント表'
      output, total_n = get_ensyuu_event_table
    when 'EVENT'
      type = '遠征イベント表'
      output, total_n = get_ensei_event_table
    when 'EVST'
      type = '作戦イベント表'
      output, total_n = get_sakusen_event_table
    when 'ETHT'
      type = 'ほのぼのイベント表'
      output, total_n = get_honobono_event_table
    when 'ETVT'
      type = '航海イベント表'
      output, total_n = get_voyage_event_table
    when 'ETGT'
      type = '外出イベント表'
      output, total_n = get_gaisyutsu_event_table
    when 'ETBT'
      type = '激戦イベント表'
      output, total_n = get_battle_event_table
    when 'ETMT'
      type = '任務イベント表'
      output, total_n = get_mission_event_table
    when 'ETFT'
      type = '恐怖イベント表'
      output, total_n = get_fear_event_table

    when 'DVT'
      type = '開発表'
      output, total_n = get_develop_table
    when 'DVTM'
      type = '開発表（一括）'
      output, total_n = get_develop_matome_table
    when 'WP1T'
      type = '装備１種表'
      output, total_n = get_weapon1_table
    when 'WP2T'
      type = '装備２種表'
      output, total_n = get_weapon2_table
    when 'WP3T'
      type = '装備３種表'
      output, total_n = get_weapon3_table
    when 'WP4T'
      type = '装備４種表'
      output, total_n = get_weapon4_table
    when 'ITT'
      type = 'アイテム表'
      output, total_n = get_item_table
    when 'MHT'
      type = '目標表'
      output, total_n = get_mokuhyou_table
    when 'SNT'
      type = '戦果表'
      output, total_n = get_senka_table
    when 'SPSNT'
      type = '特殊戦果表'
      output, total_n = get_special_senka_table

    when 'KTM'
      type = '個性：一括'
      output, total_n = get_kosei_table
    when 'BT'
      type = '個性：分野表'
      output, total_n = get_bunya_table
    when 'KHT'
      type = '個性：背景表'
      output, total_n = get_kosei_haikei_table
    when 'KMT'
      type = '個性：魅力表'
      output, total_n = get_kosei_miryoku_table
    when 'KST'
      type = '個性：性格表'
      output, total_n = get_kosei_seikaku_table
    when 'KSYT'
      type = '個性：趣味表'
      output, total_n = get_kosei_syumi_table
    when 'KKT'
      type = '個性：航海表'
      output, total_n = get_kosei_koukai_table
    when 'KSNT'
      type = '個性：戦闘表'
      output, total_n = get_kosei_sentou_table
    when 'SNZ'
      type = '戦場表'
      output, total_n = get_senzyou_table
    when 'RNT'
      type = '暴走表'
      output, total_n = get_bousou_table
    else
      return getTableCommandResult(command, @@tables)
    end

    return "#{type}(#{total_n}) ＞ #{output}"
  end

  # 感情表
  def get_emotion_table
    table = [
        'かわいい（プラス）／むかつく（マイナス）',
        'すごい（プラス）／ざんねん（マイナス）',
        'たのしい（プラス）／こわい（マイナス）',
        'かっこいい（プラス）／しんぱい（マイナス）',
        'いとしい（プラス）／かまってほしい（マイナス）',
        'だいすき（プラス）／だいっきらい（マイナス）',
    ]

    return get_table_by_1d6(table)
  end

  # アクシデント表
  def get_accident_table
    table = [
        'よかったぁ。何もなし。',
        '意外な手応え。その判定に使った個性の属性（【長所】と【弱点】）が反対になる。自分が判定を行うとき以外はこの効果は無視する。',
        'えーん。大失態。このキャラクターに対して【感情値】を持っているキャラクター全員の声援欄にチェックが入る。',
        '奇妙な猫がまとわりつく。サイクルの終了時、もしくは、艦隊戦の終了時まで、自分の行う行為判定にマイナス１の修正がつく（この効果は、マイナス２まで累積する）。',
        'いててて。損傷が一つ発生する。もしも艦隊戦中なら、自分と同じ航行序列にいる味方艦にも損傷が一つ発生する。',
        'ううう。やりすぎちゃった！自分の【行動力】が１Ｄ６点減少する。',
    ]

    return get_table_by_1d6(table)
  end

  # 日常イベント表
  def get_nichijyou_event_table
    table = [
      '何もない日々：提督が選んだ（キーワード）に対応した指定個性で判定。思いつかない場合は、《待機／航海７》で判定。',
      'ティータイム：《外国暮らし／背景１２》で判定。',
      '釣り：提督が選んだ（キーワード）に対応した指定個性で判定。思いつかない場合は《おおらか／性格３》で判定。',
      'お昼寝：《寝る／趣味２》で判定。',
      '綺麗におそうじ！：《衛生／航海１１》で判定。',
      '海軍カレー：提督が選んだ（キーワード）に対応した指定個性で判定。思いつかない場合は《食べ物／趣味６》で判定。',
      '銀蝿／ギンバイ：《規律／航海５》で判定。',
      '日々の訓練：《素直／魅力２》で判定。',
      '取材：提督が選んだ（キーワード）に対応した指定個性で判定。思いつかない場合は《名声／背景３》で判定。',
      '海水浴：《突撃／戦闘６》で判定。',
      'マイブーム：提督が選んだ（キーワード）に対応した指定個性で判定。思いつかない場合は《口ぐせ／背景６》で判定。',
    ].map { |i| i + '（着任p220）' }
    return get_table_by_2d6(table)
  end

  # 交流イベント表
  def get_kouryu_event_table
    table = [
          '一触即発！：提督が選んだ（キーワード）に対応した指定個性で判定。思いつかない場合は《笑顔／魅力７》で判定。',
          '手取り足取り：自分以外の好きなＰＣ１人を選んで、《えっち／魅力１１》で判定。',
          '恋は戦争：提督が選んだ（キーワード）に対応した指定個性で判定。思いつかない場合は《恋愛／趣味１２》で判定。',
          'マッサージ：自分以外の好きなＰＣ１人を選んで、《けなげ／魅力６》で判定。',
          '裸のつきあい：《入浴／趣味１１》で判定。',
          '深夜のガールズトーク：提督が選んだ（キーワード）に対応した指定個性で判定。思いつかない場合は《おしゃべり／趣味７》で判定。',
          'いいまちがえ：《ばか／魅力８》で判定。',
          '小言百より慈愛の一語：自分以外の好きなＰＣ１人を選んで、《面倒見／性格４》で判定。',
          '差し入れ：自分以外の好きなＰＣ１人を選んで、提督が選んだ（キーワード）に対応した指定個性で判定。思いつかない場合は《優しい／魅力４》で判定。',
          'お手紙：自分以外の好きなＰＣ１人を選んで、《古風／背景５》で判定。',
          '昔語り：自分以外の好きなＰＣ１人を選んで、提督が選んだ（キーワード）に対応した指定個性で判定。思いつかない場合は《暗い過去／背景４》で判定。',
    ].map { |i| i + '（着任p221）' }
    return get_table_by_2d6(table)
  end

  # 遊びイベント表
  def get_asobi_event_table
    table = [
      '遊びのつもりが……：提督が選んだ（キーワード）に対応した指定個性で判定。思いつかない場合は《さわやか／魅力９》で判定。',
      '新しい遊びの開発：《空想／趣味３》で判定。',
      '宴会：提督が選んだ（キーワード）に対応した指定個性で判定。思いつかない場合は《元気／性格７》で判定。',
      '街をぶらつく：《面白い／魅力１０》で判定。',
      'ガールズコーデ：《おしゃれ／趣味１０》で判定。',
      '○○大会開催！：提督が選んだ（キーワード）に対応した指定個性で判定。思いつかない場合は《大胆／性格１２》で判定。',
      'チェス勝負：自分以外の好きなＰＣ１人を選んで、《クール／魅力３》で判定。',
      '熱唱カラオケ大会：《芸能／趣味９》で判定。',
      'アイドルコンサート：提督が選んだ（キーワード）に対応した指定個性で判定。思いつかない場合は《アイドル／背景８》で判定。',
      'スタイル自慢！：《スタイル／背景１１》で判定。',
      'ちゃんと面倒みるから！：提督が選んだ（キーワード）に対応した指定個性で判定。思いつかない場合は《生き物／趣味４》で判定。',
    ].map { |i| i + '（着任p222）' }
    return get_table_by_2d6(table)
  end

  # 演習イベント表
  def get_ensyuu_event_table
    table = [
    '大げんか！：提督が選んだ（キーワード）に対応した指定個性で判定。思いつかない場合は《負けず嫌い／性格６》で判定。',
    '雷撃演習：《魚雷／戦闘１０》で判定。',
    '座学の講義：提督が選んだ（キーワード）に対応した指定個性で判定。思いつかない場合は《マジメ／性格５》で判定。',
    '速力演習：《機動／航海８》で判定。',
    '救援演習：《支援／戦闘９》で判定。シーンプレイヤーのＰＣは、経験点を１０点獲得する。残念：ＰＣ全員の【行動力】が１Ｄ６点減少する。',
    '砲撃演習：提督が選んだ（キーワード）に対応した指定個性で判定。思いつかない場合は《砲撃／戦闘７》で判定。',
    '艦隊戦演習：《派手／魅力１２》で判定。',
    '整備演習：《整備／航海１２》で判定。',
    '夜戦演習：提督が選んだ（キーワード）に対応した指定個性で判定。思いつかない場合は《夜戦／戦闘１２》で判定。',
    '開発演習：《秘密兵器／背景９》で判定。',
    '防空射撃演習：提督が選んだ（キーワード）に対応した指定個性で判定。思いつかない場合は《対空戦闘／戦闘５》で判定。',
  ].map { |i| i + '（着任p223）' }
    return get_table_by_2d6(table)
  end

  # 遠征イベント表
  def get_ensei_event_table
    table = [
    '謎の深海棲艦：提督が選んだ（キーワード）に対応した指定個性で判定。思いつかない場合は《退却／戦闘８》で判定。',
    '資源輸送任務：《買い物／趣味８》で判定。',
    '強行偵察任務：提督が選んだ（キーワード）に対応した指定個性で判定。思いつかない場合は《索敵／航海４》で判定。',
    '航空機輸送作戦：《航空戦／戦闘４》で判定。',
    'タンカー護衛任務：《丁寧／性格９》で判定。',
    '海上護衛任務：提督が選んだ（キーワード）に対応した指定能力で判定。思いつかない場合は《不思議／性格２》で判定。',
    '観艦式：《おしとやか／魅力５》で判定。',
    'ボーキサイト輸送任務：《補給／航海６》で判定。',
    '社交界デビュー？：提督が選んだ（キーワード）に対応した指定個性で判定。思いつかない場合は《お嬢様／背景１０》で判定。',
    '対潜警戒任務：《対潜戦闘／戦闘１１》で判定。',
    '大規模遠征作戦、発令！：提督の選んだ（キーワード）に対応した指定能力値で判定。思いつかな場合は《指揮／航海１０》で判定。',
  ].map { |i| i + '（着任p224）' }
    return get_table_by_2d6(table)
  end

  # 作戦イベント表
  def get_sakusen_event_table
    table = [
    '電子の目：提督が選んだ(キーワード)に対応した指定個性で判定。思いつかない場合は《電子戦／戦闘２》で判定。',
    '直掩部隊：《航空戦／戦闘４》で判定。',
    '噂によれば：提督が選んだ（キーワード）に対応した指定個性で判定。思いつかない場合は《通信／航海３》で判定。',
    '資料室にて：《海図／航海９》で判定。',
    '守護天使：《幸運／背景７》で判定。',
    '作戦会議！：提督が選んだ（キーワード）に対応した指定個性で判定。思いつかない場合は《自由奔放／性格１１》で判定。',
    '暗号解読：《暗号／航海２》で判定。',
    '一か八か？：《楽観的／性格８》で判定。',
    '特務機関との邂逅：提督が選んだ（キーワード）に対応した指定個性で判定。思いつかない場合は《人脈／背景２》で判定。',
    'クイーンズ・ギャンビット：《いじわる／性格１０》で判定。',
    '知彼知己者、百戦不殆：《読書／趣味５》で判定。',

  ].map { |i| i + '（着任p225）' }
    return get_table_by_2d6(table)
  end

  # ほのぼのイベント表
  def get_honobono_event_table
    table = [
    '模様替え：提督が選んだ(キーワード)に対応した指定個性で判定。思いつかない場合は《派手／魅力１２》で判定。',
    '門限破り：《夜戦／戦闘１２》で判定。',
    'ぼやき大会：提督が選んだ（キーワード）に対応した指定個性で判定。思いつかない場合は《いじわる／性格１０》で判定。',
    'もしも……：《自由奔放／性格１１》で判定。',
    '退屈な会議：《暗号／航海２》で判定。',
    '気の合う趣味：提督が選んだ（キーワード）に対応した指定個性で判定。思いつかない場合は《面白い／魅力１０》で判定。',
    '身だしなみ：《さわやか／魅力９》で判定。',
    'ダイエット：《スタイル／背景１１》で判定。',
    '通信販売：提督が選んだ（キーワード）に対応した指定個性で判定。思いつかない場合は《待機／背景２》で判定。',
    '気になる視線：《えっち／魅力１１》で判定。',
    '思い立ったが吉日：提督が選んだ（キーワード）に対応した指定個性で判定。思いつかない場合は《恋愛／趣味１２》で判定。',

  ].map { |i| i + '（建造弐p134）' }
    return get_table_by_2d6(table)
  end

  # 航海イベント表
  def get_voyage_event_table
    table = [
    '厳しくいくぞ：提督が選んだ(キーワード)に対応した指定個性で判定。思いつかない場合は《規律／航海５》で判定。',
    '密航者：《笑顔／魅力７》で判定。',
    '不審の目：《外国暮らし／背景１２》で判定。',
    '危険海域：《海図／航海９》で判定。',
    '波間の影：《砲撃／戦闘７》で判定。',
    'ホームシック：提督が選んだ（キーワード）に対応した指定個性で判定。思いつかない場合は《支援／戦闘９》で判定。',
    '追跡者：《対潜戦闘／戦闘１１》で判定。',
    '大嵐：《機動／航海８》で判定。',
    'うち捨てられた基地：提督が選んだ（キーワード）に対応した指定個性で判定。思いつかない場合は《読書／趣味５》で判定。',
    'ネズミ上陸：《衛生／航海１１》で判定。',
    '味の探求：提督が選んだ（キーワード）に対応した指定個性で判定。思いつかない場合は《読書／趣味５》で判定。',

  ].map { |i| i + '（建造弐p135）' }
    return get_table_by_2d6(table)
  end

  # 外出イベント表
  def get_gaisyutsu_event_table
    table = [
    'ノブレス・オブリージュ：提督が選んだ(キーワード)に対応した指定個性で判定。思いつかない場合は《お嬢様／背景１０》で判定。',
    'サイン会：《名声／背景３》で判定。',
    '蚤の市：提督が選んだ（キーワード）に対応した指定個性で判定。思いつかない場合は《古風／背景５》で判定。',
    '追っかけ：《退却／戦闘８》で判定。',
    '走り込み：《航空戦／戦闘４》で判定。',
    '外食：提督が選んだ（キーワード）に対応した指定個性で判定。思いつかない場合は《索敵／航海４》で判定。',
    '迷子：《面倒見／性格４》で判定。',
    '街頭モデル：《おしゃれ／趣味１０》で判定。',
    '暴れ○○だ！：提督が選んだ（キーワード）に対応した指定個性で判定。思いつかない場合は《生き物／趣味４》で判定。',
    '臨時講師：《おしゃべり／性格１０》で判定。',
    '映画撮影：提督が選んだ（キーワード）に対応した指定個性で判定。思いつかない場合は《芸能／趣味９》で判定。',

  ].map { |i| i + '（建造弐p136）' }
    return get_table_by_2d6(table)
  end

  # 激戦イベント表
  def get_battle_event_table
    table = [
    '分裂の危機：提督が選んだ(キーワード)に対応した指定個性で判定。思いつかない場合は《指揮／航海１０》で判定。',
    '脱走：《通信／航海３》で判定。',
    '勇気の呪文：《口ぐせ／背景６》で判定。',
    '混乱：《整備／航海１２》で判定。',
    '不意の遭遇：《魚雷／戦闘１０》で判定。',
    '敵の襲撃：提督が選んだ（キーワード）に対応した指定個性で判定。思いつかない場合は《大胆／性格１２》で判定。',
    '対空迎撃戦：《対空戦闘／戦闘５》で判定。',
    '傷自慢：《元気／性格７》で判定。',
    '怖がらないで：提督が選んだ（キーワード）に対応した指定個性で判定。思いつかない場合は《優しい／魅力４》で判定。',
    '生き延びろ：《負けず嫌い／性格１０》で判定。',
    '極限の集中：提督が選んだ（キーワード）に対応した指定個性で判定。思いつかない場合は《ばか／魅力８》で判定。',

  ].map { |i| i + '（建造弐p137）' }
    return get_table_by_2d6(table)
  end

  # 任務イベント表
  def get_mission_event_table
    table = [
    '視察：提督が選んだ(キーワード)に対応した指定個性で判定。思いつかない場合は《面倒見／魅力１２》で判定。',
    '酒保祭り：《補給／航海６》で判定。',
    'アイドルユニット結成：提督が選んだ（キーワード）に対応した指定個性で判定。思いつかない場合は《アイドル／背景８》で判定。',
    'お風呂場大改造：《入浴／趣味１１》で判定。',
    '現場の融通：《人脈／背景２》で判定。',
    '緊急空輸：提督が選んだ（キーワード）に対応した指定個性で判定。思いつかない場合は《航空戦／戦闘４》で判定。',
    '資源の再利用：《マジメ／性格５》で判定。',
    '物欲：《買い物／趣味８》で判定。',
    '魔改造：提督が選んだ（キーワード）に対応した指定個性で判定。思いつかない場合は《秘密兵器／背景９》で判定。',
    'ちゃんと伝えたってば！：《クール／魅力３》で判定。',
    'ストライキ：《おおらか／性格３》で判定。',

  ].map { |i| i + '（建造弐p138）' }
    return get_table_by_2d6(table)
  end

  # 恐怖イベント表
  def get_fear_event_table
    table = [
    '未知の怪物：提督が選んだ(キーワード)に対応した指定個性で判定。思いつかない場合は《突撃／戦闘６》で判定。',
    'ドッペルゲンガー：《不思議／性格２》で判定。',
    '悪夢：提督が選んだ（キーワード）に対応した指定個性で判定。思いつかない場合は《寝る／趣味２》で判定。',
    'イマジナリーフレンド：《空想／趣味３》で判定。',
    '幽霊船：《電子戦／戦闘２》で判定。',
    '謎の予言：提督が選んだ（キーワード）に対応した指定個性で判定。思いつかない場合は《楽観的／性格８》で判定。',
    '黒猫：《幸運／背景７》で判定。',
    'サルベージ：《丁寧／性格９》で判定。',
    'フラッシュバック：提督が選んだ（キーワード）に対応した指定個性で判定。思いつかない場合は《暗い過去／背景４》で判定。',
    '深海の呼び声：《素直／魅力２》で判定。',
    '死者の声：提督が選んだ（キーワード）に対応した指定個性で判定。思いつかない場合は《けなげ／魅力６》で判定。',

  ].map { |i| i + '（建造弐p139）' }
    return get_table_by_2d6(table)
  end

  def get_develop_table
    table = [
        '装備１種表（WP1T）',
        '装備１種表（WP1T）',
        '装備２種表（WP2T）',
        '装備２種表（WP2T）',
        '装備３種表（WP3T）',
        '装備４種表（WP4T）',
            ]
    return get_table_by_1d6(table)
  end

  def get_develop_matome_table
    output1 = ''
    output2 = ''
    total_n2 = ""

    dice, = roll(1, 6)

    case dice
    when 1
      output1 = '装備１種表'
      output2, total_n2 = get_weapon1_table
    when 2
      output1 = '装備１種表'
      output2, total_n2 = get_weapon1_table
    when 3
      output1 = '装備２種表'
      output2, total_n2 = get_weapon2_table
    when 4
      output1 = '装備２種表'
      output2, total_n2 = get_weapon2_table
    when 5
      output1 = '装備３種表'
      output2, total_n2 = get_weapon3_table
    when 6
      output1 = '装備４種表'
      output2, total_n2 = get_weapon4_table
    end
    result = "#{output1}：#{output2}"
    number = "#{dice},#{total_n2}"
    return result, number
  end

  def get_weapon1_table
    table = [
        '小口径主砲（P249）',
        '１０ｃｍ連装高角砲（P249）',
        '中口径主砲（P249）',
        '１５．２ｃｍ連装砲（P249）',
        '２０．３ｃｍ連装砲（P249）',
        '魚雷（P252）',
            ]
    return get_table_by_1d6(table)
  end

  def get_weapon2_table
    table = [
        '副砲（P250）',
        '８ｃｍ高角砲（P250）',
        '大口径主砲（P249）',
        '４１ｃｍ連装砲（P250）',
        '４６ｃｍ三連装砲（P250）',
        '機銃（P252）',
            ]
    return get_table_by_1d6(table)
  end

  def get_weapon3_table
    table = [
        '艦上爆撃機（P250）',
        '艦上攻撃機（P251）',
        '艦上戦闘機（P251）',
        '偵察機（P251）',
        '電探（P252）',
        '２５ｍｍ連装機銃（P252）',
            ]
    return get_table_by_1d6(table)
  end

  def get_weapon4_table
    table = [
        '彗星（P250）',
        '天山（P251）',
        '零式艦戦５２型（P251）',
        '彩雲（P251）',
        '６１ｃｍ四連装（酸素）魚雷（P252）',
        '改良型艦本式タービン（P252）',
            ]
    return get_table_by_1d6(table)
  end

  def get_item_table
    table = [
        'アイス',
        '羊羹',
        '開発資材',
        '高速修復剤',
        '応急修理要員',
        '思い出の品',
            ].map { |i| i + '（P241）' }
    return get_table_by_1d6(table)
  end

  def get_mokuhyou_table
    table = [
        '敵艦の中で、もっとも航行序列の高いＰＣ',
        '敵艦の中で、もっとも損傷の多いＰＣ',
        '敵艦の中で、もっとも【装甲力】の低いＰＣ',
        '敵艦の中で、もっとも【回避力】の低いＰＣ',
        '敵艦の中で、もっとも【火力】の高いＰＣ',
        '敵艦の中から完全にランダムに決定',
            ]
    return get_table_by_1d6(table)
  end

  def get_senka_table
    table = [
        '燃料／１Ｄ６＋[敵艦隊の人数]個',
        '弾薬／１Ｄ６＋[敵艦隊の人数]個',
        '鋼材／１Ｄ６＋[敵艦隊の人数]個',
        'ボーキサイト／１Ｄ６＋[敵艦隊の人数]個',
        '任意の資材／１Ｄ６＋[敵艦隊の人数]個',
        '感情値／各自好きなキャラクターへの【感情値】＋１',
            ]
    return get_table_by_1d6(table)
  end

  def get_special_senka_table
    table = [
        'すべての資材／＋３',
        'アイテム表(着任p241)から好きなアイテムを取得',
        '家具コイン／＋１',
        '砲類開発表を使用する(資材は消費しない)',
        '艦載機開発表を使用する(資材は消費しない)',
        '新特殊開発表を使用する(資材は消費しない)',
            ]
    return get_table_by_1d6(table)
  end

  def get_kosei_table
    output1 = ''
    output2 = ''
    total_n2 = ""

    output1, total_n1 = get_bunya_table

    case total_n1
    when 1
      output2, total_n2 =  get_kosei_haikei_table
    when 2
      output2, total_n2 =  get_kosei_miryoku_table
    when 3
      output2, total_n2 =  get_kosei_seikaku_table
    when 4
      output2, total_n2 =  get_kosei_syumi_table
    when 5
      output2, total_n2 =  get_kosei_koukai_table
    when 6
      output2, total_n2 =  get_kosei_sentou_table
    end
    result = "《#{output2}／#{output1}#{total_n2}》"
    number = "#{total_n1},#{total_n2}"
    return result, number
  end

  def get_bunya_table
    table = [
        '背景',
        '魅力',
        '性格',
        '趣味',
        '航海',
        '戦闘',
            ]
    return get_table_by_1d6(table)
  end

  def get_kosei_haikei_table
    table = [
        '人脈',
        '名声',
        '暗い過去',
        '古風',
        '口ぐせ',
        '幸運',
        'アイドル',
        '秘密兵器',
        'お嬢様',
        'スタイル',
        '外国暮らし',
            ]
    return get_table_by_2d6(table)
  end

  def get_kosei_miryoku_table
    table = [
        '素直',
        'クール',
        '優しい',
        'おしとやか',
        'けなげ',
        '笑顔',
        'ばか',
        'さわやか',
        '面白い',
        'えっち',
        '派手',
            ]
    return get_table_by_2d6(table)
  end

  def get_kosei_seikaku_table
    table = [
        '不思議',
        'おおらか',
        '面倒見',
        'マジメ',
        '負けず嫌い',
        '元気',
        '楽観的',
        '丁寧',
        'いじわる',
        '自由奔放',
        '大胆',
            ]
    return get_table_by_2d6(table)
  end

  def get_kosei_syumi_table
    table = [
        '寝る',
        '空想',
        '生き物',
        '読書',
        '食べ物',
        'おしゃべり',
        '買い物',
        '芸能',
        'おしゃれ',
        '入浴',
        '恋愛',
            ]
    return get_table_by_2d6(table)
  end

  def get_kosei_koukai_table
    table = [
        '暗号',
        '通信',
        '索敵',
        '規律',
        '補給',
        '待機',
        '機動',
        '海図',
        '指揮',
        '衛生',
        '整備',
            ]
    return get_table_by_2d6(table)
  end

  def get_kosei_sentou_table
    table = [
        '電子戦',
        '航空打撃戦',
        '航空戦',
        '対空戦闘',
        '突撃',
        '砲撃',
        '退却',
        '支援',
        '魚雷',
        '対潜戦闘',
        '夜戦',
            ]
    return get_table_by_2d6(table)
  end

  def get_senzyou_table
    table = [
    '同航戦',
    '反航戦',
    'Ｔ字有利',
    'Ｔ字不利',
    '悪天候',
    '悪海象（あくかいしょう）',
            ].map { |i| i + '（P231）' }
    return get_table_by_1d6(table)
  end

  def get_bousou_table
    table = [
    '妄想',
    '狂戦士',
    '興奮',
    '溺愛',
    '慢心',
    '絶望',
            ].map { |i| i + '（建造弐p164）' }
    return get_table_by_1d6(table)
  end

  @@tables =
    {

    'BT10' => {
      :name => "指定個性⑩",
      :type => '1D6',
      :table => <<'TABLE_TEXT_END'
1-10　《お嬢様》
2-10　《面白い》
3-10　《いじわる》
4-10　《おしゃれ》
5-10　《指揮》
6-10　《魚雷》
TABLE_TEXT_END
    },

    'BT11' => {
      :name => "指定個性⑪",
      :type => '1D6',
      :table => <<'TABLE_TEXT_END'
1-11　《スタイル》
2-11　《えっち》
3-11　《自由奔放》
4-11　《入浴》
5-11　《衛生》
6-11　《対潜戦闘》
TABLE_TEXT_END
    },

    'BT12' => {
      :name => "指定個性⑫",
      :type => '1D6',
      :table => <<'TABLE_TEXT_END'
1-12　《外国暮らし》
2-12　《派手》
3-12　《大胆》
4-12　《恋愛》
5-12　《整備》
6-12　《夜戦》
TABLE_TEXT_END
    },

    'BT2' => {
      :name => "指定個性②",
      :type => '1D6',
      :table => <<'TABLE_TEXT_END'
1-2　《人脈》
2-2　《素直》
3-2　《不思議》
4-2　《寝る》
5-2　《暗号》
6-2　《電子戦》
TABLE_TEXT_END
    },

    'BT3' => {
      :name => "指定個性③",
      :type => '1D6',
      :table => <<'TABLE_TEXT_END'
1-3　《名声》
2-3　《クール》
3-3　《おおらか》
4-3　《空想》
5-3　《通信》
6-3　《航空打撃戦》
TABLE_TEXT_END
    },

    'BT4' => {
      :name => "指定個性④",
      :type => '1D6',
      :table => <<'TABLE_TEXT_END'
1-4　《暗い過去》
2-4　《優しい》
3-4　《面倒見》
4-4　《生き物》
5-4　《索敵》
6-4　《航空戦》
TABLE_TEXT_END
    },

    'BT5' => {
      :name => "指定個性⑤",
      :type => '1D6',
      :table => <<'TABLE_TEXT_END'
1-5　《古風》
2-5　《おしとやか》
3-5　《マジメ》
4-5　《読書》
5-5　《規律》
6-5　《対空戦闘》
TABLE_TEXT_END
    },

    'BT6' => {
      :name => "指定個性⑥",
      :type => '1D6',
      :table => <<'TABLE_TEXT_END'
1-6　《口ぐせ》
2-6　《けなげ》
3-6　《負けず嫌い》
4-6　《食べ物》
5-6　《補給》
6-6　《突撃》
TABLE_TEXT_END
    },

    'BT7' => {
      :name => "指定個性⑦",
      :type => '1D6',
      :table => <<'TABLE_TEXT_END'
1-7　《幸運》
2-7　《笑顔》
3-7　《元気》
4-7　《おしゃべり》
5-7　《待機》
6-7　《砲撃》
TABLE_TEXT_END
    },

    'BT8' => {
      :name => "指定個性⑧",
      :type => '1D6',
      :table => <<'TABLE_TEXT_END'
1-8　《アイドル》
2-8　《ばか》
3-8　《楽観的》
4-8　《買い物》
5-8　《機動》
6-8　《退却》
TABLE_TEXT_END
    },

    'BT9' => {
      :name => "指定個性⑨",
      :type => '1D6',
      :table => <<'TABLE_TEXT_END'
1-9　《秘密兵器》
2-9　《さわやか》
3-9　《丁寧》
4-9　《芸能》
5-9　《海図》
6-9　《支援》
TABLE_TEXT_END
    },

    'ETIT' => {
      :name => "侵攻効果表",
      :type => '2d6',
      :table => <<'TABLE_TEXT_END'
援軍\n深海棲艦は徐々に力をつけ、大艦隊へとせいちょうしつつある。決戦フェイズの深海棲艦側の艦隊に、駆逐ハ級（『着任ノ書ｐ258』）が一人追加される。
海域汚染\n特定の海域が深海棲艦の住みやすい環境になる。このセッションの艦隊戦のの各ラウンドの開始時に、深海棲艦の艦隊は誰か一人だけ【行動力】を1Ｄ6点減少できるようになる。【行動力】を消費すると、その戦場を好きなものに変更できる。
略奪\n大勢の物資や人々を奪い、連れ去られる。鎮守府の資材がすべて1Ｄ6個失われる。
象徴破壊\n人類に歴史的建造物や貴重な遺産、世界的な観光名所が破壊される。ＰＣ全員は【行動力】を1Ｄ6点減少する。
襲撃\n深海棲艦の侵攻によって、鎮守府の周辺に住む人たちに大きな被害が出る。ＰＣ全員は暴走判定を行うこと。
通商破壊\n深海棲艦の侵攻によって、通商ルートが破壊される。そのセッションの間、資材を獲得する効果が発生したとき、その資材の数がいずれも一つずつ減少する。
謎のキリ\n謎の霧が海域を覆う。このセッションの艦隊戦中、深海棲艦はランドの開始時に、【行動力】を1Ｄ6点消費できるようになる。そのラウンドの間、消費した【行動力】の半分の値（切り捨て。0〜3点の値になる）だけ、深海棲艦全員は、艦隊戦で受けるダメージが軽減できる。この効果は累積するが、この効果で軽減できるダメージの上限は3点である。
陸地浸食\n陸地を浸食し、海に変える。この事態に鎮守府への非難が高まる。そのセッションの間、ＰＣ全員はあらゆる判定にマイナス1の修正がつく。この侵攻以降、行動判定を行うＰＣは、判定直前に自分の【行動力】を1点消費するたび、進行による修正をすべて打ち消すことができる。
新型改造\n深海棲艦は自らを強化しているようだ。そのセッションの決戦フェイズに登場する深海棲艦の中から一人を選ぶ。その深海棲艦をeliteのクラスを付加する。その深海棲艦がすでにeliteならflagshipに、flagshipなら改にすることもできる。
艦娘研究\n艦娘が拿捕され、鹵獲される。一体何を企んでいるのか……？提督は、好きなＮＰＣの艦娘を一人選ぶ。深海棲艦の一人に、その艦娘の持つアビリティ一つを習得させることができる。
基地建設\n深海棲艦は自分たちの基地を建造した。そのセッションの決戦フェイズで、深海棲艦の旗艦は、開幕雷撃戦と雷撃戦でダメージを受けなくなる。
TABLE_TEXT_END
    },

    'LFDT' => {
      :name => "艦隊敗北表",
      :type => '1d6',
      :table => <<'TABLE_TEXT_END'
敵の支援砲撃。ランダムなPC一人に損傷を一つ与える。
敵の罠。ランダムなPC一人に「アクシデント表」を一回適用する。
追い詰められる。戦場が「T字戦不利」になる。
本隊への合流。「敵部隊のサポート」発生。
盟友艦行方不明（MIA）。敵部隊の旗艦が決戦フェイズ中、対応する盟友艦の固有、または戦術アビリティをいずれか一つを修得する。
盟友艦轟沈。盟友艦は失われ「暴走表」を一回振り、暴走する。
TABLE_TEXT_END
    },

    'LFVT' => {
      :name => "艦隊勝利表",
      :type => '1d6',
      :table => <<'TABLE_TEXT_END'
支援砲撃。敵艦の中からランダムな一人に損傷を一つ与える。
士気高揚。この表を振ったPCの【命中力】が１点上昇する。
士気高揚。この表を振ったPCの【火力】が１点上昇する。
士気高揚。この表を振ったPCの【回避力】が１点上昇する。
士気高揚。この表を振ったPCの【装甲力】が１点上昇する。
絆が深まる。その盟友艦からのPCへの【感情値】が１点上昇する。
TABLE_TEXT_END
    },

    'LSFT' => {
      :name => "大規模部隊表",
      :type => '1d6',
      :table => <<'TABLE_TEXT_END'
水上打撃部隊　「脅威力：10」
空母機動部隊　「脅威力：9」
水雷戦隊　　　　「脅威力：8」
潜水艦部隊　　 「脅威力：7」
輸送部隊       「脅威力：6」
主力部隊       「脅威力：12」
TABLE_TEXT_END
    },

    'WPCN' => {
      :name => "砲開発表(燃料3/弾薬6/鋼材6/ボーキ3)",
      :type => '4d6',
      :table => <<'TABLE_TEXT_END'
開発失敗！(資材だけ失う)
開発失敗！(資材だけ失う)
三式弾(建造壱p169)
25mm連装機銃(着任p252)
41cm連装砲(着任p250)
8cm高角砲(着任p250)
15.2cm連装砲(着任p249)
魚雷(着任p252)
機銃(着任p252)
小口径主砲(着任p249)
中口径主砲(着任p249)
小口径主砲(着任p249)
中口径主砲(着任p249)
10cm連装高角砲(着任p249)
20.3cm連装砲(着任p249)
61cm四連装(酸素)魚雷(着任p252)
46cm三連装砲(着任p250)
15.5cm三連装砲(副砲)(建造壱p167)
61cm五連装(酸素)魚雷(建造壱p168)
53cm艦種(酸素)魚雷(建造壱p168)
九一式徹甲弾(建造壱p169)
TABLE_TEXT_END
    },

    'WPFA' => {
      :name => "艦載機開発表(燃料3/弾薬6/鋼材3/ボーキ6)",
      :type => '4d6',
      :table => <<'TABLE_TEXT_END'
開発失敗！(資材だけ失う)
開発失敗！(資材だけ失う)
開発失敗！(資材だけ失う)
開発失敗！(資材だけ失う)
開発失敗！(資材だけ失う)
Ju87C改(建造壱p167)
流星(建造壱p167)
紫電改二(建造壱p167)
零式艦戦52型(着任p251)
艦上戦闘機(着任p251)
偵察機(着任p251)
艦上爆撃機(着任p250)
艦上攻撃機(着任p251)
彩雲(着任p251)
彗星(着任p250)
天山(着任p251)
瑞雲(建造壱p168)
彗星一二型甲(建造壱p167)
流星改(建造壱p167)
烈風(建造壱p168)
零式水上観測機(建造壱p168)
TABLE_TEXT_END
    },

    'WPMC' => {
      :name => "特殊開発表(燃料6/弾薬3/鋼材6/ボーキ3)",
      :type => '2d6',
      :table => <<'TABLE_TEXT_END'
開発失敗！(資材だけ失う)
開発失敗！(資材だけ失う)
開発失敗！(資材だけ失う)
開発失敗！(資材だけ失う)
探照灯(建造壱p169)
電探(着任p252)
改良型艦本式タービン(着任p252)
九四式爆雷投射機(建造壱p169)
甲標的 甲(建造壱p168)
33号対水上電探(建造壱p169)
増設バルジ(中型艦)(建造壱p169)
TABLE_TEXT_END
    },

    'WPMCN' => {
      :name => "新特殊開発表(燃料6/弾薬3/鋼材6/ボーキ3)",
      :type => '2d6',
      :table => <<'TABLE_TEXT_END'
開発失敗！(資材だけ失う)
カ号観測機(建造弐p171)
九三式水中聴音機(建造弐p171)
ドラム缶(輸送用)(建造弐p171)
探照灯(建造壱p169)
電探(着任p252)
改良型艦本式タービン(着任p252)
九四式爆雷投射機(建造壱p169)
甲標的 甲(建造壱p168)
33号対水上電探(建造壱p169)
増設バルジ(中型艦)(建造壱p169)
TABLE_TEXT_END
    },
  }

  setPrefixes([
    'ET', 'ACT',
    'EVNT', 'EVKT', 'EVAT', 'EVET', 'EVENT', 'EVST', 'ETHT', 'ETVT', 'ETGT', 'ETBT', 'ETMT', 'ETFT',
    'DVT', 'DVTM', 'WP1T', 'WP2T', 'WP3T', 'WP4T', 'ITT', 'MHT', 'SNT', 'SPSNT',
    'KTM', 'BT', 'KHT', 'KMT', 'KST', 'KSYT', 'KKT', 'KSNT', 'SNZ', 'RNT'
  ] + @@tables.keys)
end
