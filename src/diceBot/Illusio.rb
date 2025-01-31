# -*- coding: utf-8 -*-

class Illusio < DiceBot
  def initialize
    super
    @sortType = 1 # ダイスのソート有
  end

  setPrefixes([
    '(\d+)?IL([1-6])?([1-6])?([1-6])?([1-6])?([1-6])?([1-6])?(P)?'
  ])

  def gameName
    '晃天のイルージオ'
  end

  def gameType
    "Illusio"
  end

  def getHelpMessage
    return <<MESSAGETEXT
判定：[n]IL(BNo)[P]

[]内のコマンドは省略可能。
「n」でダイス数を指定。省略時は「1」。
(BNo)でブロックナンバーを指定。「236」のように記述。順不同可。
コマンド末に「P」を指定で、(BNo)のパリィ判定。（一応、複数指定可）

【書式例】
・6IL236 → 6dでブロックナンバー「2,3,6」の判定。
・IL4512 → 1dでブロックナンバー「1,2,4,5」の判定。
・2IL1P → 2dでパリィナンバー「1」の判定。
MESSAGETEXT
  end

  def rollDiceCommand(command)
    if /(\d+)?IL([1-6])?([1-6])?([1-6])?([1-6])?([1-6])?([1-6])?(P)?$/i === command
      diceCount = ($1 || 1).to_i
      blockNo = [($2 || 0).to_i, ($3 || 0).to_i, ($4 || 0).to_i, ($5 || 0).to_i, ($6 || 0).to_i, ($7 || 0).to_i]
      blockNo.delete(0)
      blockNo = blockNo.sort
      blockNo = blockNo.uniq
      isParry = !$8.nil?

      return checkRoll(diceCount, blockNo, isParry)
    end

    return nil
  end

  def checkRoll(diceCount, blockNo, isParry)
    dice, diceText = roll(diceCount, 6, @sortTye)
    diceArray = diceText.split(/,/).collect { |i| i.to_i }

    resultArray = Array.new
    success = 0
    diceArray.each do |i|
      if blockNo.count(i) > 0
        resultArray.push("×")
      else
        resultArray.push(i)
        success += 1
      end
    end

    blockText = blockNo.join(',')
    blockText2 = "Block"
    blockText2 = "Parry" if isParry
    resultText = resultArray.join(',')

    result = "#{diceCount}D6(#{blockText2}:#{blockText}) ＞ #{diceText} ＞ #{resultText} ＞ "
    if isParry
      if  success < diceCount
        result += "パリィ成立！　次の非ダメージ2倍。"
      else
        result += "成功数：#{success}　パリィ失敗"
      end
    else
      result += "成功数：#{success}"
    end

    return result
  end
end
