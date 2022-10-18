# MOGMOG

### 店舗検索画面

![mogmog 店舗検索](https://user-images.githubusercontent.com/82147921/196184527-a7970361-7de0-4423-ac67-73c91e4523ca.gif)





### My店舗への店舗登録

![mogmog Ｍｙ店舗](https://user-images.githubusercontent.com/82147921/196184760-56a1f4ae-9253-4f00-b83e-61fdd5a43e84.gif)





### WebviewでGoogle検索画面を表示

![mogmog 店舗詳細](https://user-images.githubusercontent.com/82147921/196184796-9c466f33-026d-43c2-bd66-488f776c8cd1.gif)





## Overview

HotPepper APIを使った飲食店検索アプリです。
検索したお店の情報を見たり、お気に入り登録したりできます。

## Requirement

・macOS Monterey 12.5.1

・Swift 5

・Xcode 14.0.1

### ・データベース

・Firebase

  -Authentication
  
  -Firestore
  
  ### ・ライブラリ
  
・UIKit
  
・Alamofire

・SwiftyJSON

・SDWebImage 5.11.1

・ViewAnimator

### ・API

・HotPepper API

## Usage

食べたいものや行きたいお店をサーチバーに打ち込み検索できます  
検索したお店の情報を見たい場合は「店舗詳細」をタップすることでGoogle検索ができます

ログインすることで検索したお店をお気に入り登録することもできます  
お気に入り登録したお店はシェア機能でSNSにお店の情報をシェアすることができます


## Features

・ユーザーの新規登録・ログイン機能(Firebase Auth)

        -ログアウト機能
        
        -メールアドレス変更機能
        
        -パスワード変更機能
        
        -ユーザーネーム変更機能(Firebase Firestore)

・飲食店の検索機能(Alamofire,SwiftyJSON,API)

・お気に入り機能(Firebase Firestore)

・シェア機能

・TableViewのアニメーション(ViewAnimator)

・WebKitでのWebView表示

## Reference

・ホットペッパーAPIリファレンス  
(https://webservice.recruit.co.jp/doc/hotpepper/reference.html)

・[iOS14対応] 好きなYoutubeリストを作り他人と公開し合うSNSを作成しよう  
(https://www.udemy.com/course/draft/3703482/)  
※現在この教材は売られていないようです

・その他、Qiita,StackOverView,などのサイトを参考にしました

