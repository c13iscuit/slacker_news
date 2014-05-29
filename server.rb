require 'sinatra'
require 'csv'
require 'pry'
require 'json'
require 'pg'
require 'uri'
require 'net/http'

# Net::HTTP.get_response(URI.parse(url)).code != "200"

def get_articles
  connection = PG.connect(dbname: 'slacker')
  results = connection.exec('SELECT * FROM articles')

  connection.close

  results
end

def save_article(content)
  sql = "INSERT INTO articles (title, url, description,created_at) VALUES ($1,$2,$3,now())"

  connection = PG.connect(dbname: 'slacker')
  connection.exec_params(sql,content)

  connection.close

end

get "/" do
  @articles = get_articles
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
  #if Net::HTTP.get_response(URI.parse(url)).code == "200"

  @title = params["title"]
  @url = params["url"]
  @description = params["description"]
  save_article([@title,@url,@description])
  redirect "/"

  # else
  #   puts "Go fuck yourself!"
  #   redirect '/submission'
  # end
end
