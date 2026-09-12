#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

configure do
  enable :reloader

  db = SQLite3::Database.new(File.join(settings.root, 'barbershop.db'))
  db.results_as_hash = true
  set :db, db
  settings.db.execute <<~SQL
    CREATE TABLE IF NOT EXISTS Users (
      id  INTEGER	PRIMARY KEY AUTOINCREMENT,
	  name  TEXT,
	  phone	TEXT,
	  datestamp	TEXT,
	  barber	TEXT,
	  color	TEXT
  )
  SQL

  settings.db.execute <<~SQL
    CREATE TABLE IF NOT EXISTS Barbers (
      id  INTEGER	PRIMARY KEY AUTOINCREMENT,
	  name  TEXT
  )
  SQL

  barbers_table = settings.db.get_first_value("SELECT COUNT(*) FROM Barbers").to_i
  if barbers_table.zero?
    barbers = ['Sidney', 'Antony', 'Glorie', 'Bob', 'Gus Fring']

    barbers.each do |barber|
      settings.db.execute( 
        'INSERT INTO Barbers (name)
        VALUES (?)', 
        [barber]
      ) 
    end
  end

end

get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"	
end

get '/about' do
  @error = 'somthing wrong'
  erb :about
end

get '/schedule' do
  erb :schedule
end

get '/visit' do
  @barbers_list = settings.db.execute('SELECT * FROM Barbers')
  erb :visit
end

post '/visit' do

  @barbers_list = settings.db.execute('SELECT * FROM Barbers')
  @username = params[:username]
  @phone = params[:phone]
  @datetime = params[:usertime]
  @barber = params[:barber]
  @color = params[:color]

  hh = { :username => 'Enter name',
         :phone => 'Enter phone', 
         :usertime => 'Date and time' }
  
  @error = hh.select {|key,_| params[key] == ""}.values.join(", ")

  if @error != ''
    return erb :visit
  end

  settings.db.execute( 
    'INSERT INTO Users (name, phone, datestamp, barber, color)
    VALUES (?, ?, ?, ?, ?)', 
    [@username, @phone, @datetime, @barber, @color]
                     ) 

  erb "OK, username is #{@username}, ваш барбер #{@barber}, на #{@datetime}, 
  вы выбрали цвет - #{@color}"

end

get '/showusers' do
  @users = settings.db.execute('SELECT * FROM Users ORDER BY id DESC') 
  erb :showusers
end
