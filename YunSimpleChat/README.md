# SimpleChat
Simple Chatting Program (java)

# HOW TO USE?
# 아래의 내용을 수정해주세요.
## Client Compile 방법
 javac customizedChat/ChatClient.java

## Server Compile 방법
 javac customizedChat/ChatServer.java

## Test 방법
### Terminal #1
  java customizedChat/ChatServer
### Terminal #2
  java customizedChat/ChatClient 
  \<username1> \<server--ip-address>
### Terminal #3
  java customizedChat/ChatClient 
  \<username2> \<server--ip-address>

## Lab5: Customizing 1
- 1. ChatClient 실행 구문 변경하기
- 2. broadcast(), sendmsg()에서 클라이언트에게 보내는 메시지 앞부분에 현재시간을 보여주는 기능 추가

## Lab6: Customizing 2
- 1. 현재 접속한 사용자 목록 보기 기능
- 2. 자신이 보낸 채팅 문장은 자신에게는 나타나지 않도록 할 것
- 3. 금지어 경고 기능

## Lab7: Customizing 3
- 1. 클라이언트에서 '/spamlist' 를 입력하면 현재 서버에 등록된 금지어의 목록 출력 기능 구현 (미리 금지어가 등록되어 있을 필요 없음)
- 2. 클라이언트에서 '/addspam 단어'를 입력하면 해당 <단어>가 서버에 금지어로 추가되도록 하는 기능 구현
- 3. 금지어 파일 관리 기능 구현 - 서버를 시작하면 금지어 리스트는 특정 파일에서 불러오고, 서버가 종료되면 새로 추가된 금지어를 포함한 현재 리스트가 파일에 저장되도록 기능 구현
- 4. 처음 채팅방에 들어오기 전 개인정보(전화번호, 이름)을 입력하게 한 후 /userlist를 통해 검색가능하게 함 => 실명확인 용도 => 전화번호 입력을 원치않을 경우 "."을 입력

> Q&A: 21400564@handong.edu
