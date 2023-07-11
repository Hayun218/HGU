package edu.handong.analysis.datamodel;

import java.util.ArrayList;
import java.util.HashMap;

public class Student {

	private String studentId;
	private ArrayList<Course> coursesTaken;
	private HashMap<String, Integer> semestersByYearAndSemester;

	public Student(String studentId) {
		this.studentId = studentId;
		coursesTaken = new ArrayList<Course>();
	}

	public void addCourse(Course newRecord) {
		coursesTaken.add(newRecord);
	}

	public HashMap<String, Integer> getSemestersByYearAndSemester() {

		semestersByYearAndSemester = new HashMap<String, Integer>();
		String yearAndSem = "";
		String temp = "";
		int cnt = 1;
		for (int i = 0; i < coursesTaken.size(); i++) {
			yearAndSem = Integer.toString(coursesTaken.get(i).getYearTaken()) + "-"
					+ Integer.toString(coursesTaken.get(i).getSemesterCourseTaken());
			if (yearAndSem.equals(temp))
				continue;
			else {
				semestersByYearAndSemester.put(yearAndSem, cnt++);
				temp = yearAndSem;
			}
		}
		return semestersByYearAndSemester;
	}

	public int getNumCourseInNthSementer(int semester) {
		String yearAndSem = "";
		int cnt = 0;
		for (int i = 0; i < coursesTaken.size(); i++) {
			yearAndSem = Integer.toString(coursesTaken.get(i).getYearTaken()) + "-"
					+ Integer.toString(coursesTaken.get(i).getSemesterCourseTaken());
			int check = getSemestersByYearAndSemester().get(yearAndSem);
			if (semester == check)
				cnt++;
			else
				continue;
		}

		return cnt;
	}

}
