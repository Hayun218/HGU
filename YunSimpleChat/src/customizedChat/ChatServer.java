package customizedChat;

import java.net.*;
import java.text.SimpleDateFormat;
import java.io.*;
import java.util.*;

public class ChatServer {

	public static void main(String[] args) {
		try {
			ServerSocket server = new ServerSocket(10001); // 포트 10001과 연결한 소켓 서버 생성
			System.out.println("Waiting connection..."); // 기다린다는 표시 출력
			HashMap hm = new HashMap(); // 해쉬맵 변수
			while (true) {
				Socket sock = server.accept(); // 서버 소켓 대기
				ChatThread chatthread = new ChatThread(sock, hm); // 해당 클래스 할당
				chatthread.start(); // 함수 호출
			}
		} catch (Exception e) {
			System.out.println(e);
		}
	} // main
}

class ChatThread extends Thread {
	private Socket sock; // 소켓 변수
	private String id; // Id 아이디 변수
	private BufferedReader br; // 읽어오기 위한 변수
	private HashMap hm; // 해쉬맵
	private HashMap<String, String> phone;
	private HashMap<String, String> actualName;
	private boolean initFlag = false;
	private ArrayList<String> badWords;

	public ChatThread(Socket sock, HashMap hm) { // 생성자
		this.sock = sock;
		this.hm = hm;
		badWords = new ArrayList<String>();

		try {
			phone = new HashMap();
			actualName = new HashMap();
			PrintWriter pw = new PrintWriter(new OutputStreamWriter(sock.getOutputStream())); // socket의 아웃풋 스트림을 통해 적어줌
																								// socket쓰기
			br = new BufferedReader(new InputStreamReader(sock.getInputStream())); // 읽어 올 수 있게 socket읽기

			ArrayList<String> lines = new ArrayList<String>();
			for (int i = 0; i < 3; i++)
				lines.add(br.readLine());
			id = lines.get(0);

			broadcast(id + " entered."); // client 가 사용 중인 화면에 출력
			System.out.println("[Server] User (" + id + ") entered."); // 서버가 있는 콘솔에해당 라인 출력

			synchronized (hm) { // id와 pw소켓 아웃풋 스트림에 출력할 변수) f를
				hm.put(this.id, pw); // hm 에 키값을 아이디로 그리고 벨뉴를 해당 아이디가 입력한 라인을 넣어준다
				phone.put(this.id, (String) lines.get(1));
				actualName.put(this.id, (String) lines.get(2));
			}
			initFlag = true;
		} catch (Exception ex) {
			System.out.println(ex);
		}
	} // construcor

	public void run() {
		try {
			String filename = "words.txt";
			badWords.clear();
			readWordsFromFile(filename);
			String line = null;
			String lines[] = null;
			while ((line = br.readLine()) != null) { // 라인이 비어있지 않을 때
				lines = line.split(" ");
				for (int i = 0; i < lines.length; i++) {
					for (int j = 0; j < badWords.size(); j++) {
						if (lines[i].equals(badWords.get(j))) {
							PrintWriter pw = (PrintWriter) hm.get(id);
							pw.println("Do not use any curse word. WARNING!!!");
							pw.flush();
						}
					}
				}
				if (line.equals("/quit")) // 해당 문자열과 동일할 때 break;
					break;
				if (line.indexOf("/to ") == 0) // 처음 인덱스를 /to를 하면 sendmsg 불러오기
					sendmsg(line);
				if (line.equals("/userlist"))
					send_userlist();
				if (line.equals("/spamlist")) {
					PrintWriter pw = (PrintWriter) hm.get(id);
					pw.println("List of fobidden words : ");
					for (String word : badWords) {
						pw.println(word);
						pw.flush();
					}
					pw.flush();
				}
				if (line.indexOf("/addspam ") == 0) {
					add_forbidden(line);
					save_file(filename);
				} else {
					broadcast(id + " : " + line); // 별다른 명령어가 없으면 id 와 입력받은 line을 출력 (client 화면에
				}

			}
		} catch (Exception ex) {
			System.out.println(ex); // 에러가 떴을때
		} finally {
			synchronized (hm) {
				hm.remove(id); // 나가는 경우 hashmap에서 해당 id를 삭제하고 동기화
			}
			broadcast(id + " exited.");
			try {
				if (sock != null)
					sock.close();
			} catch (Exception ex) {
			}
		}
	} // run

	private String timeToday() {
		SimpleDateFormat format1 = new SimpleDateFormat("ahh:mm");
		// Date time = new Date();
		String time = format1.format(System.currentTimeMillis());
		return time;
	}

	public void readWordsFromFile(String filename) {
		String line = "";

		try {
			File file = new File(filename);
			BufferedReader readfile = new BufferedReader(new FileReader(file));
			while ((line = readfile.readLine()) != null) {
				badWords.add(line);
			}
			readfile.close();
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	public void save_file(String filename) {

		try {
			File file = new File(filename);
			BufferedWriter writefile = new BufferedWriter(new FileWriter(file));

			for (String word : badWords) {
				writefile.write(word);
				writefile.newLine();
				writefile.flush();

			}
			writefile.close();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	/**
	 * 금지어를 추가!
	 * 
	 * @param msg
	 */

	public void add_forbidden(String msg) {
		int start = msg.indexOf(" ") + 1;
		int end = msg.length();
		PrintWriter pw = (PrintWriter) hm.get(id);
		if (end > start) {
			String word = msg.substring(start, end);
			for (String existed : badWords) {
				if (word.equals(existed)) {
					pw.println("The word is already existed in the spam words.");
					pw.flush();
					break;
				}
			}
			badWords.add(word);
			pw.println(word + " is added in the forbidden words.");
			pw.flush();
		} else
			pw.println("There is no given word to add.");

	}

	public void sendmsg(String msg) { // 귓속말 모드
		int start = msg.indexOf(" ") + 1; // 비어있는 인덱스 번호 + 1 => '/to ' 이므로 이 때의 빈 문자열의 위치 + 1
		int end = msg.indexOf(" ", start); // start에서 입력받은 인덱스 번호부터 빈 문자열을 찾아서 해당 인덱스를 end에 저장
		String time = timeToday();
		if (end != -1) {
			String to = msg.substring(start, end); // start 부터 end 인덱스 까지의 문자열을 to로 지정한다 => id
			String msg2 = msg.substring(end + 1); // 인덱스 값이 end+1인것 부터 뒤에 까지 msg2 => line
			Object obj = hm.get(to); // 해당 to 의 문자열을 지닌 해쉬맵의 value 값을 obj에 저장
			if (obj != null) { // 널이 아닌 경우
				PrintWriter pw = (PrintWriter) obj; // obj를 캐스팅 하여 주고
				pw.println("[" + time + "]" + id + " whisphered. : " + msg2);
				pw.flush();
			}
		}
	} // sendmsg

	/**
	 * iter.next가 해당 Id의 value 값과 동일할 때는 해당 user가 본 메세지를 보냈다는 것이므로 skip 하기 위해서
	 * continue하게 하는 If문을 추가시켜 본인이 보낸 메세지는 본인의 콘솔에 다시 출력되지 않도록 하였다.
	 * 
	 * @param msg
	 */
	public void broadcast(String msg) {
		synchronized (hm) { // 동기화
			String time = timeToday();
			Collection collection = hm.values(); // hm 해쉬맵에 있는 value를 collection에 저장
			Iterator iter = collection.iterator(); // 반복
			while (iter.hasNext()) { // iter에 그 다음 값이 존재하지 않을 때까지 반복 다음에 있는 문자열을 프린트! 동기화 하여 적용
				if (iter.next().equals(hm.get(id)))
					continue;
				PrintWriter pw = (PrintWriter) iter.next(); // Iter의 다음 값을 printwirter로 캐스팅
				pw.println("[" + time + "]" + msg); // client가 사용하고 있는 콘솔창에 출력
				pw.flush();
			}

		}
	} // broadcasts

	/**
	 * hm에 key값을 user라는 오브젝트에 하나씩 담아서 출력 하고 for 문이 돌아갈 때마다 cnt++ 을 시켜줘서 총 유저의 명수를 확인
	 */

	public void send_userlist() {

		PrintWriter pw;
		pw = (PrintWriter) hm.get(id);
		int cnt = 0;
		String number, name;
		pw.println("List of Users / names / phone# : ");

		for (Object user : hm.keySet()) {
			pw.println("User ID : " + user);
			
			number = phone.get(user);
			name = actualName.get(user);

			pw.println("Actual name : " + actualName.get(user));
			if (!number.equals("."))
				pw.println("phone# : " + phone.get(user));
			else
				pw.println("No phone# for this user");

			cnt++;
		}
		pw.println("Total Number of Users : " + cnt);
		pw.flush();

	}
}