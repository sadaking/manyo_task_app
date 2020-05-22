|  カラム  |  データ型 |
| ---- | ---- |
|  title  | string  |
|  content  |  text  |


##デプロイ方法
============

Ruby on Rails 5.2.4.2
------------

### herokuにログイン

>$ heroku login

### 新しいレポジトリを作成

>$ heroku create

###Herokuにデプロイ
>$ git push heroku master

###データベースの移行

>$ heroku run rails db:migrate

###アプリケーションにアクセスを行う
>Herokuアプリのアドレスは、下記URLの形でアクセスできる。

>https://アプリ名.herokuapp.com/ 
