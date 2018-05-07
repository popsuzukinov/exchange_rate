require 'csv'
require 'nkf'

class DataController < ApplicationController
  def show1
    @id = params[:id]
    @records = []
    reader = CSV.open("db/tousyou_one/1tou#{@id}.csv", 'r')
    reader.shift
    reader.each do |row|
      row = row.collect {|value| NKF.nkf('-Sw', value) }
      @records << row
    end  # reader.each do |row|
  end # def show

  def downloadcsv1_1
    file_name="1tou1.csv"
    filepath = Rails.root.join('db','tousyou_one',file_name)
    stat = File::stat(filepath)
    send_file(filepath, filename: file_name, length: stat.size)
  end

  def downloadcsv1_2
    file_name="1tou2.csv"
    filepath = Rails.root.join('db','tousyou_one',file_name)
    stat = File::stat(filepath)
    send_file(filepath, filename: file_name, length: stat.size)
  end

  def show2
    @id = params[:id]
    @records = []
    reader = CSV.open("db/tousyou_two/2tou#{@id}.csv", 'r')
    reader.shift
    reader.each do |row|
      row = row.collect {|value| NKF.nkf('-Sw', value) }
      @records << row
    end  # reader.each do |row|
  end # def show2

  def downloadcsv2_1
    file_name="2tou1.csv"
    filepath = Rails.root.join('db','tousyou_two',file_name)
    stat = File::stat(filepath)
    send_file(filepath, filename: file_name, length: stat.size)
  end

  def downloadcsv2_2
    file_name="2tou2.csv"
    filepath = Rails.root.join('db','tousyou_two',file_name)
    stat = File::stat(filepath)
    send_file(filepath, filename: file_name, length: stat.size)
  end
end
