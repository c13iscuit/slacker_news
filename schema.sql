CREATE TABLE articles (
  id serial PRIMARY KEY,
  title varchar(500) NOT NULL,
  url varchar(500) NOT NULL,
  description varchar(2000) NOT NULL,
  created_at timestamp,
  edited_at timestamp
);

CREATE TABLE comments(
  id serial PRIMARY KEY,
  article_id int NOT NULL,
  FOREIGN KEY (article_id) REFERENCES articles(id),
  comment  varchar(2000) NOT NULL,
  created_at timestamp,
  edited_at timestamp
);
