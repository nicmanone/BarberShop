#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'

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
  erb :visit
end

post '/visit' do

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

  erb "OK, username is #{@username}, ваш барбер #{@barber}, на #{@usertime}, 
  вы выбрали цвет - #{@color}"

end

