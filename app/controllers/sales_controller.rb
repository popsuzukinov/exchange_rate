#require 'gnuplot'
#gem 'chart-js-rails'
#gem 'angularjs-rails'

class SalesController < ApplicationController
  #棒グラフ
  def usdjpy
    # (...データベースからのデータ取得処理...)
    # ダミーのデータを用意
    months = [ 12, 13, 14, 15, 16, 17 ]
    product_A_sales = [ 112.08, 112.10, 112.12,
      112.14, 112.33, 112.16 ]
    #product_B_sales = [   300_000,   500_000,   750_000,
      #1_150_000, 1_350_000, 1_600_000 ] 
    # グラフ（チャート）を作成 
    @chart = LazyHighCharts::HighChart.new("graph") do |c|
      c.title(text: "USD/JPY exchange rate (/h)")
      # X軸の名称を設定 '月'
      c.xAxis(categories: months, title: {text: 'Every hour'})       # Y軸の名称を設定 '円'
      c.yAxis(title: {text: 'Yen'})
      c.series(name: "1USD", data: product_A_sales)
      #c.series(name: "B", data: product_B_sales)
      # 判例を右側に配置
     c.legend(align: 'right', verticalAlign: 'top', 
       x: -100, y: 180, layout: 'vertical')
    end
  end
  #折れ線グラフ
  def eurjpy
    # (...データベースからのデータ取得処理...)
    # ダミーのデータを用意
    months = [ 12, 13, 14, 15, 16, 17 ]
    product_A_sales = [ 127.22, 127.19, 127.23,
      127.37, 127.53, 127.60 ]
    #product_B_sales = [   300_000,   500_000,   750_000,
      #1_150_000, 1_350_000, 1_600_000 ] 
    # グラフ（チャート）を作成 
    @chart = LazyHighCharts::HighChart.new("graph") do |c|
      c.title(text: "EUR/JPY exchange rate (/h)")
      # X軸の名称を設定 '月'
      c.xAxis(categories: months, title: {text: 'Every hour'})       # Y軸の名称を設定 '円'
      c.yAxis(title: {text: 'Yen'})
      c.series(name: "1EUR", data: product_A_sales)
      #c.series(name: "B", data: product_B_sales)
      # 判例を右側に配置
     c.legend(align: 'right', verticalAlign: 'top', 
       x: -100, y: 180, layout: 'vertical')
    end
  end

  def cadjpy
    # (...データベースからのデータ取得処理...)
    # ダミーのデータを用意
    months = [ 12, 13, 14, 15, 16, 17 ]
    product_A_sales = [ 85.25, 85.24, 85.28,
      85.29, 85.46, 85.19 ]
    #product_B_sales = [   300_000,   500_000,   750_000,
      #1_150_000, 1_350_000, 1_600_000 ] 
    # グラフ（チャート）を作成 
    @chart = LazyHighCharts::HighChart.new("graph") do |c|
      c.title(text: "CAD/JPY exchange rate (/h)")
      # X軸の名称を設定 '月'
      c.xAxis(categories: months, title: {text: 'Every hour'})       # Y軸の名称を設定 '円'
      c.yAxis(title: {text: 'Yen'})
      c.series(name: "1CAD", data: product_A_sales)
      #c.series(name: "B", data: product_B_sales)
      # 判例を右側に配置
     c.legend(align: 'right', verticalAlign: 'top', 
       x: -100, y: 180, layout: 'vertical')
    end
  end

  def audjpy
    # (...データベースからのデータ取得処理...)
    # ダミーのデータを用意
    months = [ 12, 13, 14, 15, 16, 17 ]
    product_A_sales = [ 85.55, 85.50, 85.49,
      85.29, 85.15, 85.05 ]
    #product_B_sales = [   300_000,   500_000,   750_000,
      #1_150_000, 1_350_000, 1_600_000 ] 
    # グラフ（チャート）を作成 
    @chart = LazyHighCharts::HighChart.new("graph") do |c|
      c.title(text: "AUD/JPY exchange rate (/h)")
      # X軸の名称を設定 '月'
      c.xAxis(categories: months, title: {text: 'Every hour'})       # Y軸の名称を設定 '円'
      c.yAxis(title: {text: 'Yen'})
      c.series(name: "1AUD", data: product_A_sales)
      #c.series(name: "B", data: product_B_sales)
      # 判例を右側に配置
     c.legend(align: 'right', verticalAlign: 'top', 
       x: -100, y: 180, layout: 'vertical')
    end
  end

  def nzdjpy
    # (...データベースからのデータ取得処理...)
    # ダミーのデータを用意
    months = [ 12, 13, 14, 15, 16, 17 ]
    product_A_sales = [ 80.55, 80.50, 80.49,
      80.29, 80.15, 80.05 ]
    #product_B_sales = [   300_000,   500_000,   750_000,
      #1_150_000, 1_350_000, 1_600_000 ] 
    # グラフ（チャート）を作成 
    @chart = LazyHighCharts::HighChart.new("graph") do |c|
      c.title(text: "NZD/JPY exchange rate (/h)")
      # X軸の名称を設定 '月'
      c.xAxis(categories: months, title: {text: 'Every hour'})       # Y軸の名称を設定 '円'
      c.yAxis(title: {text: 'Yen'})
      c.series(name: "1NZD", data: product_A_sales)
      #c.series(name: "B", data: product_B_sales)
      # 判例を右側に配置
     c.legend(align: 'right', verticalAlign: 'top', 
       x: -100, y: 180, layout: 'vertical')
    end
  end

  def chfjpy
    # (...データベースからのデータ取得処理...)
    # ダミーのデータを用意
    months = [ 12, 13, 14, 15, 16, 17 ]
    product_A_sales = [ 116.80, 116.90, 117.05,
      117.14, 116.96, 116.80 ]
    #product_B_sales = [   300_000,   500_000,   750_000,
      #1_150_000, 1_350_000, 1_600_000 ] 
    # グラフ（チャート）を作成 
    @chart = LazyHighCharts::HighChart.new("graph") do |c|
      c.title(text: "CHF/JPY exchange rate (/h)")
      # X軸の名称を設定 '月'
      c.xAxis(categories: months, title: {text: 'Every hour'})       # Y軸の名称を設定 '円'
      c.yAxis(title: {text: 'Yen'})
      c.series(name: "1CHF", data: product_A_sales)
      #c.series(name: "B", data: product_B_sales)
      # 判例を右側に配置
     c.legend(align: 'right', verticalAlign: 'top', 
       x: -100, y: 180, layout: 'vertical')
    end
  end

  def zarjpy
    # (...データベースからのデータ取得処理...)
    # ダミーのデータを用意
    months = [ 12, 13, 14, 15, 16, 17 ]
    product_A_sales = [ 8.621, 8.620, 8.629,
      8.633, 8.618, 8.620 ]
    #product_B_sales = [   300_000,   500_000,   750_000,
      #1_150_000, 1_350_000, 1_600_000 ] 
    # グラフ（チャート）を作成 
    @chart = LazyHighCharts::HighChart.new("graph") do |c|
      c.title(text: "ZAR/JPY exchange rate (/h)")
      # X軸の名称を設定 '月'
      c.xAxis(categories: months, title: {text: 'Every hour'})       # Y軸の名称を設定 '円'
      c.yAxis(title: {text: 'Yen'})
      c.series(name: "1ZAR", data: product_A_sales)
      #c.series(name: "B", data: product_B_sales)
      # 判例を右側に配置
     c.legend(align: 'right', verticalAlign: 'top', 
       x: -100, y: 180, layout: 'vertical')
    end
  end

  def gbpjpy
    # (...データベースからのデータ取得処理...)
    # ダミーのデータを用意
    months = [ 12, 13, 14, 15, 16, 17 ]
    product_A_sales = [ 143.72, 112.74, 112.72,
      112.66, 112.55, 112.49 ]
    #product_B_sales = [   300_000,   500_000,   750_000,
      #1_150_000, 1_350_000, 1_600_000 ] 
    # グラフ（チャート）を作成 
    @chart = LazyHighCharts::HighChart.new("graph") do |c|
      c.title(text: "GBP/JPY exchange rate (/h)")
      # X軸の名称を設定 '月'
      c.xAxis(categories: months, title: {text: 'Every hour'})       # Y軸の名称を設定 '円'
      c.yAxis(title: {text: 'Yen'})
      c.series(name: "1GBP", data: product_A_sales)
      #c.series(name: "B", data: product_B_sales)
      # 判例を右側に配置
     c.legend(align: 'right', verticalAlign: 'top', 
       x: -100, y: 180, layout: 'vertical')
    end
  end
  def high
  end
end
