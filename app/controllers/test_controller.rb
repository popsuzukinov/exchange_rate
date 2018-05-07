require 'open-uri'
#gem 'nokogiri", "1.6.8.1'
require 'nokogiri'
require 'net/http'
require 'uri'
require 'json'

class TestController < ApplicationController
  #まとめサイトの画像抽出
  def test1
  # スクレイピング先のURL
  url = 'https://matome.naver.jp/tech'
  charset = nil
    html = open(url) do |f|
      charset = f.charset # 文字種別を取得
      f.read # htmlを読み込んで変数htmlに渡す
    end
# htmlをパース(解析)してオブジェクトを作成
    doc = Nokogiri::HTML.parse(html, nil, charset)
    doc.xpath('//li[@class="mdTopMTMList01Item"]').each do |node|
      # tilte
      @title = node.css('h3').inner_text
      # 記事のサムネイル画像
      @img   = node.css('img').attribute('src').value
      # 記事のサムネイル画像
      @href  = node.css('a').attribute('href').value
    end
  end
  #yahooのタイトル抽出
  def test2
    # スクレイピング先のURL
    url = 'https://www.yahoo.co.jp/'
    charset = nil
    html = open(url) do |f|
      charset = f.charset # 文字種別を取得
      f.read # htmlを読み込んで変数htmlに渡す
    end
    # htmlをパース(解析)してオブジェクトを生成
    doc = Nokogiri::HTML.parse(html, nil, charset)
    # タイトルを表示
    #p doc.title
    if 
      doc.css('//meta[property="og:description"]/@content').empty?
      @desc = doc.css('//meta[name$="escription"]/@content')
    else
      @desc = doc.css('//meta[property="og:description"]/@content')
    end
  end

  def test3
    # hash形式でパラメタ文字列を指定し、URL形式にエンコード
    params = URI.encode_www_form({zipcode: '7830060'})
    # URIを解析し、hostやportをバラバラに取得できるようにする
    uri = URI.parse("http://zipcloud.ibsnet.co.jp/api/search?#{params}")
    # リクエストパラメタを、インスタンス変数に格納
    @query = uri.query
    # 新しくHTTPセッションを開始し、結果をresponseへ格納
    response = Net::HTTP.start(uri.host, uri.port) do |http|
      # 接続時に待つ最大秒数を設定
      http.open_timeout = 5
      # 読み込み一回でブロックして良い最大秒数を設定
      http.read_timeout = 10
      # ここでWebAPIを叩いている
      # Net::HTTPResponseのインスタンスが返ってくる
      http.get(uri.request_uri)
    end
    # 例外処理の開始
    begin
      # responseの値に応じて処理を分ける
      case response
      # 成功した場合
      when Net::HTTPSuccess
        # responseのbody要素をJSON形式で解釈し、hashに変換
        @result = JSON.parse(response.body)
        # 表示用の変数に結果を格納
        @zipcode  = @result["results"][0]["zipcode"]
        @address1 = @result["results"][0]["address1"]
        @address2 = @result["results"][0]["address2"]
        @address3 = @result["results"][0]["address3"]
      # 別のURLに飛ばされた場合
      when Net::HTTPRedirection
        @message = "Redirection: code=#{response.code} message=#{response.message}"
      # その他エラー
      else
        @message = "HTTP ERROR: code=#{response.code} message=#{response.message}"
      end
    # エラー時処理
    rescue IOError => e
      @message = "e.message"
    rescue TimeoutError => e
      @message = "e.message"
    rescue JSON::ParserError => e
      @message = "e.message"
    rescue => e
      @message = "e.message"
    end
  end

  def test4
    # hash形式でパラメタ文字列を指定し、URL形式にエンコード
    #q=銘柄コード
    params0 = URI.encode_www_form({q: '6420'})
    #x=市場
    params1 = URI.encode_www_form({x: 'TYO'})
    #i=ティックの長さ
    params2 = URI.encode_www_form({i: '86400'})
    #p=期間
    params3 = URI.encode_www_form({p: '1M'})
    #f=取得する値
    params4 = URI.encode_www_form({f: 'd,c,v,o,h,l'})
    #?
    params5 = URI.encode_www_form({df: 'cpct'})
    #?
    params6 = URI.encode_www_form({auto: '1'})
    #ts=開始日時
    #params7 = URI.encode_www_form({ts: '1489550582260'})
    #ei=セッションキー?
    #params8 = URI.encode_www_form({ei: '4rrIWJHoIYya0QS1i4IQ'})
    # URIを解析し、hostやportをバラバラに取得できるようにする
    parsed_uri = URI.parse("https://www.google.com/finance/getprices?#{params0}&#{params1}&#{params2}&#{params3}&#{params4}&#{params5}&#{params6}")
p "parsed_uri=#{parsed_uri}"
    # リクエストパラメタを、インスタンス変数に格納
    @query = parsed_uri.query
p "query=#{@query}"

    # 新しくHTTPセッションを開始し、結果をresponseへ格納
    response = Net::HTTP.new(parsed_uri.host, parsed_uri.port) do |http|
p "response=#{response}"
      http.use_ssl = true
      # 接続時に待つ最大秒数を設定
      http.open_timeout = 5
      # 読み込み一回でブロックして良い最大秒数を設定
      http.read_timeout = 10
      # ここでWebAPIを叩いている
      # Net::HTTPResponseのインスタンスが返ってくる
      http.get(parsed_uri.request_uri)
    end
    # 例外処理の開始
    begin
      # responseの値に応じて処理を分ける
      case response
      # 成功した場合
      when Net::HTTPSuccess
        # responseのbody要素をJSON形式で解釈し、hashに変換
        @result = JSON.parse(response.body)
        # 表示用の変数に結果を格納
        @q    = @result["results"][0]["q"]
        @x    = @result["results"][0]["x"]
        @i    = @result["results"][0]["i"]
        @p    = @result["results"][0]["p"]
        @f    = @result["results"][0]["f"]
        @df   = @result["results"][0]["df"]
        @auto = @result["results"][0]["auto"]
        @ts   = @result["results"][0]["ts"]
        @ei   = @result["results"][0]["ei"]
      # 別のURLに飛ばされた場合
      when Net::HTTPRedirection
        @message = "Redirection: code=#{response.code} message=#{response.message}"
      # その他エラー
      else
        @message = "HTTP ERROR: code=#{response.code} message=#{response.message}"
      end
    # エラー時処理
    rescue IOError => e
      @message = "IOE.message"
    rescue TimeoutError => e
      @message = "e.message"
    rescue JSON::ParserError => e
      @message = "json.message"
    rescue => e
      @message = "e.message"
    end
  end

  def test5
    # スクレイピング先のURL
    url = 'https://nikkei225jp.com/chart/'
    charset = nil
    html = open(url) do |f|
      charset = f.charset # 文字種別を取得
      f.read # htmlを読み込んで変数htmlに渡す
    end
    # htmlをパース(解析)してオブジェクトを生成
    doc = Nokogiri::HTML.parse(html, nil, charset)
    # タイトルを表示
    #p doc.title
    if 
      #doc.css('//td[class="chart-markup-table pane"]/canvas@content').empty?
      @image = doc.css('//td[class="chart-markup-table pane"]/canvas@content').attribute("graf").value
    else
      @image = doc.css('//td[class="chart-markup-table pane"]/canvas@content').attribute("graf").value
    end
  end

  def test6
    # Youtubeで「ruby on rails」で検索した結果の動画のタイトルの一覧を取得する。
    # youtubeでruby on railsを検索
    doc = Nokogiri::HTML(open('https://www.youtube.com/results?q=ruby+on+rails&sp=CAI%253D'))
    # 動画のノードの一覧を取得
    # ドキュメント全体を検索する場合は「//をつける」
    nodes = doc.xpath("//div[@class='yt-lockup-dismissable yt-uix-tile']")
    @nodes = doc.xpath("//div[@class='yt-lockup-dismissable yt-uix-tile']")

    nodes.each do |node|
      # このノード以下のすべての子要素に対して検索を行う場合は「.//」をつける
      @title_node = node.xpath(".//h3[@class='yt-lockup-title ']")
      # 子要素のみを検索対象とする場合は何もつけない
      @title = node.xpath("a")
      @doc = doc
      #puts title.text
    end
  end

  def test7
  # スクレイピング先のURL
  url = 'https://nikkei225jp.com/chart/'
  charset = nil
    html = open(url) do |f|
      charset = f.charset # 文字種別を取得
      f.read # htmlを読み込んで変数htmlに渡す
    end
# htmlをパース(解析)してオブジェクトを作成
    doc = Nokogiri::HTML.parse(html, nil, charset)
    doc.xpath('//iframe[@id="tradingview_8391e"]').each do |node|
      # tilte
      @title = node.css('iframe').inner_text
      # 記事のサムネイル画像
      @img   = node.css('iframe').attribute('src').value
      # 記事のサムネイル画像
      @href  = node.css('html').attribute('class').value
    end
  end
  #rateをapiで呼出
  def test8
    # hash形式でパラメタ文字列を指定し、URL形式にエンコード
    #q=銘柄コード
    params0 = URI.encode_www_form({symbol: 'JP225USD'})
    #x=市場
    params1 = URI.encode_www_form({interval: '1'})
    #i=ティックの長さ
    params2 = URI.encode_www_form({hidetoptoolbar: '1'})

    params3 = URI.encode_www_form({saveimage: '0'})

    params4 = URI.encode_www_form({toolbarbg: 'f1f3f6'})

    params5 = URI.encode_www_form({studies: ''})

    params6 = URI.encode_www_form({hideideas: '1'})

    params7 = URI.encode_www_form({theme: 'White'})

    params8 = URI.encode_www_form({style: '1'})
    #p=期間
    params9 = URI.encode_www_form({timezone: 'Asia%2FTokyo'})
    #f=取得する値
    params10 = URI.encode_www_form({studies_overrides: '%7B%7D'})

    params11 = URI.encode_www_form({overrides: '%7B%7D'})
    #?
    params12 = URI.encode_www_form({enabled_features: '%5B%5D'})
    #?
    params13= URI.encode_www_form({disabled_features: '%5B%5D'})
    #ts=開始日時
    params14 = URI.encode_www_form({locale: 'ja'})
    #ei=セッションキー?
    params15 = URI.encode_www_form({referral_id: '3613'})

    params16 = URI.encode_www_form({utm_source: 'nikkei225jp.com'})

    params17 = URI.encode_www_form({utm_medium: 'widget'})

    params18 = URI.encode_www_form({utm_campaign: 'chart'})

    params19 = URI.encode_www_form({utm_term: 'JP225USD'})
    # URIを解析し、hostやportをバラバラに取得できるようにする
    parsed_uri = URI.parse("https://s.tradingview.com/widgetembed/?#{params0}&#{params1}&#{params2}&#{params3}&#{params4}&#{params5}&#{params6}&#{params7}&#{params8}&#{params9}&#{params10}&#{params11}&#{params12}&#{params13}&#{params14}&#{params15}&#{params16}&#{params17}&#{params18}&#{params19}")

    # リクエストパラメタを、インスタンス変数に格納
    @query = parsed_uri.query

    # 新しくHTTPセッションを開始し、結果をresponseへ格納
    response = Net::HTTP.new(parsed_uri.host, parsed_uri.port) do |http|
      #@response = response
      http.use_ssl = true
      # 接続時に待つ最大秒数を設定
      http.open_timeout = 5
      # 読み込み一回でブロックして良い最大秒数を設定
      http.read_timeout = 10
      # ここでWebAPIを叩いている
      # Net::HTTPResponseのインスタンスが返ってくる
      http.get(parsed_uri.request_uri)
    end
    # 例外処理の開始
    begin
      # responseの値に応じて処理を分ける
      case response
      # 成功した場合
      when Net::HTTPSuccess
        # responseのbody要素をJSON形式で解釈し、hashに変換
        @result = JSON.parse(response.body)
        # 表示用の変数に結果を格納
        @symbol    = @result["results"][0]["symbol"]
        @x    = @result["results"][0]["x"]
        @i    = @result["results"][0]["i"]
        @p    = @result["results"][0]["p"]
        @f    = @result["results"][0]["f"]
        @df   = @result["results"][0]["df"]
        @auto = @result["results"][0]["auto"]
        @ts   = @result["results"][0]["ts"]
        @ei   = @result["results"][0]["ei"]
      # 別のURLに飛ばされた場合
      when Net::HTTPRedirection
        @message = "Redirection: code=#{response.code} message=#{response.message}"
      # その他エラー
      else
        @message = "HTTP ERROR: code=#{response.code} message=#{response.message}"
      end
    # エラー時処理
    rescue IOError => e
      @message = "IOE.message"
    rescue TimeoutError => e
      @message = "e.message"
    rescue JSON::ParserError => e
      @message = "json.message"
    rescue => e
      @message = "e.message"
    end
  end

  def converterapi
    api_key = '5d18ed158c000c9052f03a1ee570e1f3'
    currencies = 'USD,EUR'
    source = 'JPY'
    format = 1
    #ts = Time.now.to_i
    #h = Digest::SHA1.hexdigest(secret + ts.to_s)
    Net::HTTP.start('https://apilayer.net/api/live',# 443,
      use_ssl: true, ca_file: 'tmp/cacert.pem') do |https|
        @https = https
        #res = https.get("/api/2/search_slideshows?q=#{ERB::Util.url_encode(params[:keywd])}&lang=ja&api_key=#{api_key}&hash=#{h}&ts=#{ts}")
        render json: Hash.from_xml(res.body).to_json
      end
  end

  def nomura
    count = 0      

    rate_list = []

      # スクレイピング先のURL
      url = "http://advance.quote.nomura.co.jp/meigara/nomura2/qsearch.exe?F=users/nomura/exchange"

      charset = nil
      html = open(url) do |f|
        charset = f.charset # 文字種別を取得
        f.read # htmlを読み込んで変数htmlに渡す
      end

    # htmlをパース(解析)してオブジェクトを生成
    doc = Nokogiri::HTML.parse(html, nil, 'charset')
    # id=companyListのulを取得
    rates = doc.css("div#content")
    # id=companyListのul以下のliを配列で取得
    rate_list = rates.css("td")
    #@company_list = company_list
    # 配列内のliを一つ一つeachでfetchする
    #@rate_list = []
    @rate_list = []
    rate_list.each do |rate|
    # dataを保存するArrayを作成
    #@c = company
      data = []
      count += 1
      # liの子要素であるimgのtitle情報を取得
      #name = company.css("img")[0][:title]
      # liの子要素であるaのhrehパラメータを取得
      #url = company.css("a")[0][:href]
      # liの子要素であるimgのsrcパラメータを取得
      rate_now = rate.css("td")[0]

      # 各要素を確認
      #p count, name, url, logo
      @count = count
      @rate_now = rate_now
      #@url = url
      #@logo = logo
      p "rate_data[#{@count}]=#{rate_now}"
      #@name_list.push(name)
      @rate_list.push(rate)
    end
  end

  def gaitame
  # スクレイピング先のURL
  url = 'https://www.gaitameonline.com/rateaj/getrate'
  charset = nil
    html = open(url) do |f|
      charset = f.charset # 文字種別を取得
      f.read # htmlを読み込んで変数htmlに渡す
    end
# htmlをパース(解析)してオブジェクトを作成
    doc = Nokogiri::HTML.parse(html, nil, charset)
    @p = doc

    #end
    #doc.xpath('https://www.gaitameonline.com/rateaj/getrate').each_line do |node|

    #end
  end

  def gaitame2
p "gaitame2 start"
=begin
    # スクレイピング先のURL
    url = 'http://jp.reuters.com/investing/currencies/chart'
    charset = nil
      html = open(url) do |f|
        charset = f.charset # 文字種別を取得
        f.read # htmlを読み込んで変数htmlに渡す
      end
# htmlをパース(解析)してオブジェクトを作成
      doc = Nokogiri::HTML.parse(html, nil, charset)
      doc.xpath('//div[@class="moduleBody"]').each do |node|
        # tilte
        @title = node.css('ait')
        # 記事のサムネイル画像
        @img   = node.css('img').attribute('src').value
        # 記事のサムネイル画像
        @href  = node.css('a').attribute('href').value
      end
  end
=end
#=begin
    count = 0      

    rate_list = []

      # スクレイピング先のURL
      url = "http://jp.reuters.com/investing/currencies/chart"

      charset = nil
      html = open(url) do |f|
        charset = f.charset # 文字種別を取得
        f.read # htmlを読み込んで変数htmlに渡す
      end

    # htmlをパース(解析)してオブジェクトを生成
    doc = Nokogiri::HTML.parse(html, nil, 'charset')
#p "doc=#{doc}"
    # id=companyListのulを取得
    rates = doc.css("div.columnLeft")
#p "rates=#{rates}"
    # id=companyListのul以下のliを配列で取得
    rate_list = rates.css("a")
#p "rate_list=#{rate_list}"
    #@company_list = company_li
    # 配列内のliを一つ一つeachでfetchする
    #@rate_list = []
    @rate_list = []
    rate_list.each do |rate|
#p "#{rate}"
    # dataを保存するArrayを作成
    #@c = company
      data = []
      count += 1
      # liの子要素であるimgのtitle情報を取得
      #name = company.css("img")[0][:title]
      # liの子要素であるaのhrehパラメータを取得
      #url = company.css("a")[0][:href]
      # liの子要素であるimgのsrcパラメータを取得
      rate_now = rate.css("img")[0][:src]

      # 各要素を確認
      #p count, name, url, logo
      @count = count
      @rate_now = rate_now
      #@url = url
      #@logo = logo
      #p "rate_data[#{@count}]=#{@rate_now}"
      #@name_list.push(name)
      @rate_list.push(rate)
    end
  end
#=end

  def test10
    count = 0      

    best_venture_100_list = []

      # スクレイピング先のURL
      url = "http://best100.v-tsushin.jp/"

      charset = nil
      html = open(url) do |f|
        charset = f.charset # 文字種別を取得
        f.read # htmlを読み込んで変数htmlに渡す
      end

    # htmlをパース(解析)してオブジェクトを生成
    doc = Nokogiri::HTML.parse(html, nil, 'charset')
    # id=companyListのulを取得
    companies = doc.css("ul#companyList")
    @companies = companies.to_s
    # id=companyListのul以下のliを配列で取得
    company_list = companies.css("li")
    #@company_list = company_list
    # 配列内のliを一つ一つeachでfetchする
    @name_list = []
    @logo_list = []
    company_list.each do |company|
    # dataを保存するArrayを作成
    #@c = company
      data = []
      count += 1
      # liの子要素であるimgのtitle情報を取得
      name = company.css("img")[0][:title]
      # liの子要素であるaのhrehパラメータを取得
      #url = company.css("a")[0][:href]
      # liの子要素であるimgのsrcパラメータを取得
      logo = company.css("img")[0][:src]

      # 各要素を確認
      #p count, name, url, logo
      @count = count
      @name = name
      @url = url
      @logo = logo
      p "company_data[#{@count}]=#{name}#{url}"
      @name_list.push(name)
      @logo_list.push(logo)
    end
  end

  def test11
    # hash形式でパラメタ文字列を指定し、URL形式にエンコード
    #params = URI.encode_www_form({zipcode: '7830060'})
    # URIを解析し、hostやportをバラバラに取得できるようにする
    uri = URI.parse("https://www.gaitameonline.com/rateaj/getrate")
    # リクエストパラメタを、インスタンス変数に格納
    @query = uri.query
p "#{@query}"
    # 新しくHTTPセッションを開始し、結果をresponseへ格納
    response = Net::HTTP.start(parsed_uri.host, parsed_uri.port) do |http|
p "http=#{http}"
      http.use_ssl = true
      # 接続時に待つ最大秒数を設定
      http.open_timeout = 5
      # 読み込み一回でブロックして良い最大秒数を設定
      http.read_timeout = 10
      # ここでWebAPIを叩いている
      # Net::HTTPResponseのインスタンスが返ってくる
      http.get(uri.request_uri)
    end
    # 例外処理の開始
    begin
      # responseの値に応じて処理を分ける
      case response
      # 成功した場合
      when Net::HTTPSuccess
        # responseのbody要素をJSON形式で解釈し、hashに変換
        @result = JSON.parse(response.body)
        # 表示用の変数に結果を格納
        #@zipcode  = @result["results"][0]["zipcode"]
        @address1 = @result["results"][0]["address1"]
        @address2 = @result["results"][0]["address2"]
        @address3 = @result["results"][0]["address3"]
      # 別のURLに飛ばされた場合
      when Net::HTTPRedirection
        @message = "Redirection: code=#{response.code} message=#{response.message}"
      # その他エラー
      else
        @message = "HTTP ERROR: code=#{response.code} message=#{response.message}"
      end
    # エラー時処理
    rescue IOError => e
      @message = "e.message"
    rescue TimeoutError => e
      @message = "e.message"
    rescue JSON::ParserError => e
      @message = "e.message"
    rescue => e
      @message = "e.message"
    end
  end
  #これつかう
  def gaitame3
    count = 0      

    rate_list = []

      # スクレイピング先のURL
      url = "https://www.gaitameonline.com/rateaj/getrate"

      charset = nil
      html = open(url) do |f|
        charset = f.charset # 文字種別を取得
        f.read # htmlを読み込んで変数htmlに渡す
      end

    # htmlをパース(解析)してオブジェクトを生成
    doc = Nokogiri::HTML.parse(html, nil, 'charset')
#p "doc=#{doc}"
    # id=companyListのulを取得
    rates = doc.css("html")
#p "rates=#{rates}"
    # id=companyListのul以下のliを配列で取得
    rate_list = rates.css("body/p")
#p "rate_list=#{rate_list}"
    #@company_list = company_li
    # 配列内のliを一つ一つeachでfetchする
    #@rate_list = []
    #high=高値,open=始値,bid=買値,ask=売値,low=低値
    @rate_list = []
=begin
    @test1 = []
    @test2 = []
    i = 5
    10.times do

      #@test1 << rate_list[0].to_s.split("\"high\":\"[\d]\"")
      @test1 << rate_list[0].to_s.slice(14,2547)#.split("\"(.+?)@te1\.(.+?)\b\":\"$1@te2\.$2\"")
      #@test1 << rate_list[0].to_s
      #@test2 << rate_list[0].to_s.split("\"^[\d]\"")
      #@test1.each_line do |rate|
#p "rate=#{rate}"
      #end
      #@high1 = @test1[2]
      i += 25
    end
=end
    @cadjpy_high = rate_list[0].to_s.slice(130, 5)
    @cadjpy_open = rate_list[0].to_s.slice(145, 5)
    @cadjpy_bid  = rate_list[0].to_s.slice(159, 5)
    @cadjpy_ask  = rate_list[0].to_s.slice(201, 5)
    @cadjpy_low  = rate_list[0].to_s.slice(215, 5)

    @audjpy_high = rate_list[0].to_s.slice(339, 5)
    @audjpy_open = rate_list[0].to_s.slice(354, 5)
    @audjpy_bid  = rate_list[0].to_s.slice(368, 5)
    @audjpy_ask  = rate_list[0].to_s.slice(410, 5)
    @audjpy_low  = rate_list[0].to_s.slice(424, 5)

    @nzdjpy_high = rate_list[0].to_s.slice(762, 5)
    @nzdjpy_open = rate_list[0].to_s.slice(777, 5)
    @nzdjpy_bid  = rate_list[0].to_s.slice(791, 5)
    @nzdjpy_ask  = rate_list[0].to_s.slice(833, 5)
    @nzdjpy_low  = rate_list[0].to_s.slice(847, 5)

    @zarjpy_high = rate_list[0].to_s.slice(1185, 5)
    @zarjpy_open = rate_list[0].to_s.slice(1200, 5)
    @zarjpy_bid  = rate_list[0].to_s.slice(1214, 5)
    @zarjpy_ask  = rate_list[0].to_s.slice(1256, 5)
    @zarjpy_low  = rate_list[0].to_s.slice(1270, 5)

    @chfjpy_high = rate_list[0].to_s.slice(1394, 5)
    @chfjpy_open = rate_list[0].to_s.slice(1410, 5)
    @chfjpy_bid  = rate_list[0].to_s.slice(1425, 5)
    @chfjpy_ask  = rate_list[0].to_s.slice(1468, 5)
    @chfjpy_low  = rate_list[0].to_s.slice(1483, 5)

    @eurjpy_high = rate_list[0].to_s.slice(1715, 6)
    @eurjpy_open = rate_list[0].to_s.slice(1731, 6)
    @eurjpy_bid  = rate_list[0].to_s.slice(1746, 6)
    @eurjpy_ask  = rate_list[0].to_s.slice(1789, 6)
    @eurjpy_low  = rate_list[0].to_s.slice(1804, 6)

    @usdjpy_high = rate_list[0].to_s.slice(2143, 6)
    @usdjpy_open = rate_list[0].to_s.slice(2159, 6)
    @usdjpy_bid  = rate_list[0].to_s.slice(2174, 6)
    @usdjpy_ask  = rate_list[0].to_s.slice(2217, 6)
    @usdjpy_low  = rate_list[0].to_s.slice(2232, 6)

    @gbpjpy_high = rate_list[0].to_s.slice(2464, 6)
    @gbpjpy_open = rate_list[0].to_s.slice(2480, 6)
    @gbpjpy_bid  = rate_list[0].to_s.slice(2495, 6)
    @gbpjpy_ask  = rate_list[0].to_s.slice(2538, 6)
    @gbpjpy_low  = rate_list[0].to_s.slice(2553, 6)
    array ||= []
        p "array=#{array}" 
    array.push @cadjpy_ask
p "array=#{array}"    
=begin
#p "rate_list=#{rate_list}"
    rate_list.each do |rate|
#p "#{rate}"
    # dataを保存するArrayを作成
    #@c = company
    #rate_list.slice(0..11)
#p "rate_list=#{rate_list}"
      data = []
      count += 1
      # liの子要素であるimgのtitle情報を取得
      #name = company.css("img")[0][:title]
      # liの子要素であるaのhrehパラメータを取得
      #url = company.css("a")[0][:href]
      # liの子要素であるimgのsrcパラメータを取得
      #rate_now = rate.css("p")[0][:quotes]
      #@rate_now = []
      # 各要素を確認
      #p count, name, url, logo
      @count = count
     # @rate_now = rate_now
#p "rate_now=#{rate_now}"
#p "rate_data[#{@count}]=#{rate_now}#{rate_list}"
      #@url = url
      #@logo = logo
      #p "rate_data[#{@count}]=#{@rate_now}"
      #@name_list.push(name)
      @rate_list.push(rate)
    end
=end
  end

  def gaitame4
    # URIを解析し、hostやportをバラバラに取得できるようにする
    parsed_uri = URI.parse("https://www.gaitameonline.com/rateaj/getrate")
    # リクエストパラメタを、インスタンス変数に格納
    @query = parsed_uri.query
p "query=#{@query}"
    # 新しくHTTPセッションを開始し、結果をresponseへ格納
    response = Net::HTTP.new(parsed_uri.host, parsed_uri.port) do |http|
p "response=#{response}"
      http.use_ssl = true
      # 接続時に待つ最大秒数を設定
      http.open_timeout = 5
      # 読み込み一回でブロックして良い最大秒数を設定
      http.read_timeout = 10
      # ここでWebAPIを叩いている
      # Net::HTTPResponseのインスタンスが返ってくる
      http.get(parsed_uri.request_uri)
      @result = JSON.parse(response.p)
p "@result=#{@result}"
    end
    # 例外処理の開始
    begin
      # responseの値に応じて処理を分ける
      case response
      # 成功した場合
      when Net::HTTPSuccess
        # responseのbody要素をJSON形式で解釈し、hashに変換
        @result = JSON.parse(response.p)
p "@result=#{@result}"
        # 表示用の変数に結果を格納
=begin
        @q    = @result["results"][0]["q"]
        @x    = @result["results"][0]["x"]
        @i    = @result["results"][0]["i"]
        @p    = @result["results"][0]["p"]
        @f    = @result["results"][0]["f"]
        @df   = @result["results"][0]["df"]
        @auto = @result["results"][0]["auto"]
        @ts   = @result["results"][0]["ts"]
        @ei   = @result["results"][0]["ei"]
=end
      # 別のURLに飛ばされた場合
      when Net::HTTPRedirection
        @message = "Redirection: code=#{response.code} message=#{response.message}"
      # その他エラー
      else
        @message = "HTTP ERROR: code=#{response.code} message=#{response.message}"
      end
    # エラー時処理
    rescue IOError => e
      @message = "IOE.message"
    rescue TimeoutError => e
      @message = "e.message"
    rescue JSON::ParserError => e
      @message = "json.message"
    rescue => e
      @message = "e.message"
    end
  end
end
