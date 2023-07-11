package customizedChat;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.net.Socket;
import java.util.Scanner;

public class ChatClient_new {

	private String username;
	private String server_ip;
	private Socket sock = null;
	private String phone = null;
	private String acutualName = null;
	BufferedReader br = null;
	PrintWriter pw = null; // 변수 초기화
	boolean endflag = false;

	
	public String getPhone() {
		return phone;
	}


	public String getAcutualName() {
		return acutualName;
	}

	public ChatClient_new(String server_ip, String username) {
		this.username = username;
		this.server_ip = server_ip;
	}

	public ChatClient_new() {
	}

	@SuppressWarnings("resource")
	public void input() {
		Scanner sc = new Scanner(System.in);
		System.out.println("your name >> ");
		this.username = sc.next();
		System.out.println("server ip >> ");
		this.server_ip = sc.next();
		System.out.println("your actual name >> ");
		this.acutualName = sc.next();
		System.out.println("your phone number >> (입력을 원치 않을 경우 '.'을 입력하세요.)");
		this.phone = sc.next();
	}

	private void readFromKeyboard(BufferedReader keyboard, PrintWriter pw) {
		String line = null; // 읽어올 문자열 변수 선언
		try {
			while ((line = keyboard.readLine()) != null) { // 키보드에서 입력받은 라인이 널이 아닌 경우
				pw.println(line); // 해당 라인을 소켓의 아웃풋 스트림에 적기 => 서버에서 broadcast 메서드를 통해 클라이언트 화면에 출력
				pw.flush(); // 남아있는 잔해 제거
				if (line.equals("/quit")) { // /quit를 입력받았을 경우
					endflag = true; // endflag 가 true로 전환
					break; // while문을 나감

				}
			}
			System.out.println("Connection closed.");
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	public void start() {

		try {
			sock = new Socket(server_ip, 10001);
			pw = new PrintWriter(new OutputStreamWriter(sock.getOutputStream())); // 소켓 적기
			br = new BufferedReader(new InputStreamReader(sock.getInputStream())); // 소켓 읽기
			BufferedReader keyboard = new BufferedReader(new InputStreamReader(System.in)); // 키보드로 입력받는문자열 => 쓰기
			// send username.
			pw.println(username);
			pw.println(phone);
			pw.println(acutualName);
			
			pw.flush(); // 남아있는 잔해 제거
			InputThread it = new InputThread(sock, br); // InputThread => 병렬처리를 위해서
			it.start(); // 쓰레드 시작
			readFromKeyboard(keyboard, pw);

		} catch (Exception ex) { // 각 경우에 알맞는 exception
			if (!endflag)
				System.out.println(ex);
		} finally {
			try {
				if (pw != null) // pw가 널이 아니라면
					pw.close(); // 닫아주기
			} catch (Exception ex) {
			}
			try {
				if (br != null) // br이 널이 아니라면
					br.close(); // 닫아주기
			} catch (Exception ex) {
			}
			try {
				if (sock != null) // 소켓이 널이 아니라면
					sock.close(); // 닫아주기
			} catch (Exception ex) {
			}
		} // finally
	} // main
} // class