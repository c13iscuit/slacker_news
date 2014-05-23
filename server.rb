require 'sinatra'
require 'csv'
require 'pry'

get "/" do
  @articles = CSV.read("submission.csv")
  erb :index
end

get "/comments" do
  @comments = CSV.read("comments.csv")
  erb :comments
end

post "/comments" do
  @user_comment = params["comment"]
  File.open("comments.csv", "a") do |file|
    file.puts("#{@user_comment}")
  end
  redirect "/comments"
end

get "/submission" do
  erb :submission
end

post "/submission" do
  @title = params["title"]
  @url = params["url"]
  @description = params["description"]
  if @title != "" && @description.length > 20
    File.open("submission.csv", "a") do |file|
      file.puts("#{@title},#{@url},#{@description}")
    end
  else
    redirect "/submission"
    puts "ERROR"
  end
  redirect "/"
end
