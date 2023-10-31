#!/usr/bin/ruby
#
# J-clusterのXMLと魚リスト:want.txtを読み込んで
# 未交信な都市からのQRVがspotされたら通知するスクリプト
#
# 2023/10/28 by JH4XSY/1
#

require 'nokogiri'
require 'open-uri'
require 'time'


# want.txtを読み込んでリスト化
want_list = []

File.open("/home/jh4xsy/Desktop/want.txt", "r") do |f|
  f.each_line do |line|
    raw = line.split(" ")
    want_list << raw[1]
  end
end


# J-cluster読み込み
url = "http://qrv.jp/xml/All100.xml"
contents = Nokogiri::XML(open(url),nil,"shift_jis")

nodes = contents.xpath('//Spot')

# XMLをparse
nodes.each do |node|
  datime1 = node.xpath('Date').text
  datime2 = node.xpath('Time').text
  t1s = sprintf("%s %s", datime1, datime2)
  t1 = Time.parse(t1s)

  freq = node.xpath('Freq').text
  mode = node.xpath('Mode').text
  call = node.xpath('SpotStation/CallSign').text
  qthname = node.xpath('SpotStation/QthName1').text

  qth = node.xpath('SpotStation/QthID').text
  qth.gsub!(/[A-Z]/, "")

  # wantを検索
  for i in 0..want_list.size-1
    
    if qth == want_list[i]
      # 新着データのみ表示
      diff = (Time.now - t1).to_i
      if diff < 40*60
        # 画面に表示
        msg = sprintf("%s %s@%sMHz,%s from %s(%s)", t1s,call,freq,mode,qth,qthname)
        cmd = sprintf("notify-send \"%s\"", msg)
        system(cmd)
        # アラートを鳴らす
        cmd = sprintf("aplay ~/Downloads/predict-2.3.0/vocalizer/alarm.wav")
        system(cmd)
      end
    end

  end

end
