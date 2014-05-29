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

def get_comments(parameter)
  connection = PG.connect(dbname: 'slacker')
  results = connection.exec_params('SELECT * FROM comments WHERE article_id = $1;', [parameter])
  connection.close
  results
end

def save_article(content)
  sql = "INSERT INTO articles (title, url, description,created_at) VALUES ($1,$2,$3,now());"
  connection = PG.connect(dbname: 'slacker')
  connection.exec_params(sql,content)
  connection.close
end

def save_comment(content) ******************
  sql = "INSERT INTO comments (comment,created_at) VALUES ($1,now());"
  connection = PG.connect(dbname: 'slacker')
  connection.exec_params(sql,[content])
  connection.close
end

def url_lookup(url)
  sql = "SELECT url FROM articles WHERE url = $1;"
  connection = PG.connect(dbname: 'slacker')
  results = connection.exec_params(sql,[url])
  connection.close
  results
end

get "/" do
  @articles = get_articles
  erb :index
end

get "/:id/comments" do
  @comments = get_comments(params[:id])
  erb :article_comments
end

post "/comments" do
  @user_comment = params["comment"]

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
  #if Net::HTTP.get_response(URI.parse(url)).code == "200"
  if url_lookup(params["url"]) == nil
    save_article([@title,@url,@description])
    redirect "/"
  else
    redirect "/url_error"
  end
end

get "/url_error" do
  erb :url_error
end
