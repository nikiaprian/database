CREATE TABLE IF NOT EXISTS Users (
  id SERIAL PRIMARY KEY,
  email VARCHAR(255) UNIQUE NOT NULL,
  username VARCHAR(255) UNIQUE NOT NULL,
  password VARCHAR(255) DEFAULT '',
  status VARCHAR(255) CHECK( status IN ('ACTIVE', 'DELETED') ) DEFAULT 'ACTIVE',
  provider VARCHAR(255) CHECK( provider IN ('local', 'google') ) DEFAULT 'local',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_email ON Users(email);
CREATE INDEX IF NOT EXISTS idx_username ON Users(username);

CREATE TABLE IF NOT EXISTS GoogleAccounts (
  id SERIAL PRIMARY KEY,
  google_id VARCHAR(255) NOT NULL,
  user_id INTEGER NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

  FOREIGN KEY (user_id) REFERENCES Users (id)
);

CREATE INDEX IF NOT EXISTS idx_user_google_account ON GoogleAccounts(user_id);

CREATE TABLE IF NOT EXISTS Blogs (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    photo VARCHAR(255) NOT NULL,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id) REFERENCES Users (id)
);

CREATE INDEX IF NOT EXISTS idx_title ON Blogs(title);
CREATE INDEX IF NOT EXISTS idx_blog_user ON Blogs(user_id);

ALTER TABLE Users
ADD COLUMN role VARCHAR(255) DEFAULT 'user' NOT NULL;


CREATE TABLE IF NOT EXISTS CommentBlog (
  id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL,
  blog_id INTEGER NOT NULL,
  comment TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

  FOREIGN KEY (user_id) REFERENCES Users (id),
  FOREIGN KEY (blog_id) REFERENCES Blogs (id)
);

CREATE INDEX IF NOT EXISTS idx_commentblog_user ON CommentBlog(user_id);
CREATE INDEX IF NOT EXISTS idx_commentblog_blog ON CommentBlog(blog_id);

CREATE TABLE IF NOT EXISTS Forums (
  id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL,
  title VARCHAR(255) NOT NULL,
  content TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

  FOREIGN KEY (user_id) REFERENCES Users (id)
);

CREATE INDEX IF NOT EXISTS idx_forum_title ON Forums(title);
CREATE INDEX IF NOT EXISTS idx_forum_user ON Forums(user_id);

CREATE TABLE IF NOT EXISTS CommentForum (
  id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL,
  forum_id INTEGER NOT NULL,
  comment TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  
  FOREIGN KEY (user_id) REFERENCES Users (id),
  FOREIGN KEY (forum_id) REFERENCES Forums (id)
);

CREATE INDEX IF NOT EXISTS idx_commentforum_user ON CommentForum(user_id);
CREATE INDEX IF NOT EXISTS idx_commentforum_forum ON CommentForum(forum_id);

CREATE TABLE IF NOT EXISTS Tags (
  id SERIAL PRIMARY KEY,
  tag VARCHAR(255) UNIQUE NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_tags ON Tags(tag);

CREATE TABLE IF NOT EXISTS ForumTags (
  id SERIAL PRIMARY KEY,
  tag_id INTEGER NOT NULL,
  forum_id INTEGER NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

  FOREIGN KEY (tag_id) REFERENCES Tags (id),
  FOREIGN KEY (forum_id) REFERENCES Forums (id)
);

CREATE INDEX IF NOT EXISTS idx_tag_forum_tag ON ForumTags(tag_id);
CREATE INDEX IF NOT EXISTS idx_forum_forum_tag ON ForumTags(forum_id);

CREATE TABLE IF NOT EXISTS BlogTags (
  id SERIAL PRIMARY KEY,
  tag_id INTEGER NOT NULL,
  blog_id INTEGER NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

  FOREIGN KEY (tag_id) REFERENCES Tags (id),
  FOREIGN KEY (blog_id) REFERENCES Blogs (id)
);

CREATE INDEX IF NOT EXISTS idx_tag_blog_tag ON BlogTags(tag_id);
CREATE INDEX IF NOT EXISTS idx_blog_blog_tag ON BlogTags(blog_id);

CREATE TABLE IF NOT EXISTS ForumsLikes (
  id SERIAL PRIMARY KEY,
  forum_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

  FOREIGN KEY (forum_id) REFERENCES Forums (id),
  FOREIGN KEY (user_id) REFERENCES Users (id)
);

CREATE INDEX IF NOT EXISTS idx_forum_forum_like ON ForumsLikes(forum_id);
CREATE INDEX IF NOT EXISTS idx_user_forum_like ON ForumsLikes(user_id);

ALTER TABLE CommentForum
ADD COLUMN is_answer BOOLEAN NOT NULL DEFAULT false;

CREATE TABLE IF NOT EXISTS BlogsLikes (
  id SERIAL PRIMARY KEY,
  blog_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

  FOREIGN KEY (blog_id) REFERENCES Blogs (id),
  FOREIGN KEY (user_id) REFERENCES Users (id)
);

CREATE INDEX IF NOT EXISTS idx_blog_blog_like ON BlogsLikes(blog_id);
CREATE INDEX IF NOT EXISTS idx_user_blog_like ON BlogsLikes(user_id);

CREATE TABLE IF NOT EXISTS ForumCommentLikes (
  id SERIAL PRIMARY KEY,
  forum_comment_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

  FOREIGN KEY (forum_comment_id) REFERENCES CommentForum (id),
  FOREIGN KEY (user_id) REFERENCES Users (id)
);

CREATE INDEX IF NOT EXISTS idx_forum_comment_like ON ForumCommentLikes(forum_comment_id);
CREATE INDEX IF NOT EXISTS idx_user_forum_comment_like ON ForumCommentLikes(user_id);

CREATE TABLE IF NOT EXISTS BlogCommentLikes (
  id SERIAL PRIMARY KEY,
  blog_comment_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

  FOREIGN KEY (blog_comment_id) REFERENCES CommentBlog (id),
  FOREIGN KEY (user_id) REFERENCES Users (id)
);

CREATE INDEX IF NOT EXISTS idx_blog_comment_like ON BlogCommentLikes(blog_comment_id);
CREATE INDEX IF NOT EXISTS idx_user_blog_comment_like ON BlogCommentLikes(user_id);

ALTER TABLE Users
ADD COLUMN photo VARCHAR(255);