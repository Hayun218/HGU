package customizedChat;

import java.net.*;
import java.io.*;

public class ChatClient {

	public static void main(String[] args) {
		if (args.length != 2) { // 아규먼트가 2개가 아닐 경우에러 메세지를 띠우고 프로그램 종료
			System.out.println("java ChatClient");
			ChatClient_new chatClient = new ChatClient_new();
			chatClient.input();
			chatClient.start();
			
		} else {
			System.out.println("Usage : java ChatClient <username> <server-ip>");
			ChatClient_new chatClient = new ChatClient_new(args[1], args[0]);
			chatClient.start();
		}

	}

}

class InputThread extends Thread { // 쓰레드를 상속받은 클래스 
	private Socket sock = null;
	private BufferedReader br = null;

	public InputThread(Socket sock, BufferedReader br) { // 생성자
		this.sock = sock;
		this.br = br;
	}

	public void run() {
		try {
			String line = null;
			while ((line = br.readLine()) != null) { // br에서 읽어오는 문자열이 null일 x
				System.out.println(line); // line을 출력
			}
		} catch (Exception ex) {
		} finally {// 항상 익셉션에 들어오면 해주기 =>소켓과 bufferedreader 닫아주기
			try {
				if (br != null) // br이 널이 아니면 닫아주기 
					br.close();
			} catch (Exception ex) {
			}
			try {
				if (sock != null) // sock이 널이 아니면 닫아주기 
					sock.close();
			} catch (Exception ex) {
			}
		}
	} // InputThread
}

