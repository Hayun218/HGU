package edu.handong.analysis;

import java.util.ArrayList;

import edu.handong.analysis.datamodel.Course;
import edu.handong.analysis.datamodel.Student;

public class HGUCoursePatternAnalyzer {

	String[] lines = { "1999-1, JC Nam, Java Programming", 
					   "1999-2, JC Nam, Programming Language Theory",
					   "1999-1, JC Nam, Data Structures", 
					   "2001-1, JC Nam, Database Systems", 
					   "2018-1, SB Lim, Java Programming",
					   "2018-2, SB Lim, Programming Language Theory", 
					   "2019-1, SB Lim, Data Structures",
					   "2019-1, SB Lim, Algorithm Analysis", 
					   "2018-1, SJ Kim, Java Programming",
					   "2018-2, SJ Kim, Programming Language Theory", 
					   "2019-1, SJ Kim, Logic Design",
					   "2019-1, SJ Kim, Algorithm Analysis", 
			};

	private int numOfStudents;
	private int numOfCourses;
	private ArrayList<Student> students;
	private ArrayList<Course> courses;

	/**
	 * This method runs our analysis logic to get the list of student and course
	 * names from lines.
	 * 
	 * @param args
	 */
	public void run(String[] args) {

		numOfStudents = Integer.parseInt(args[0]);
		numOfCourses = Integer.parseInt(args[1]);

		students = initiateStudentArrayFromLines(lines);

		System.out.println("Number of All Students: " + numOfStudents);
		for (Student student : students) {
				System.out.println(student.getName());
		}

		courses = initiateCourseArrayFromLines(lines);
		System.out.println("Number of All Courses: " + numOfCourses);
		for (Course course : courses) {
				System.out.println(course.getCourseName());
		}

	}

	/**
	 * This method returns a Student array to initiate the field, students, from
	 * lines.
	 * 
	 * @param lines
	 * @return
	 */
	private ArrayList<Student> initiateStudentArrayFromLines(String[] lines) {
		students = new ArrayList<Student>(numOfStudents);
		String name = null;
		Student stuNames = null;
	//	int cnt = 0;

		for (int i = 0; i < lines.length; i++) {
			name = lines[i].split(",")[1];
			stuNames = new Student(name.trim());
			if (studentExist(students, stuNames)) {
				students.add(stuNames);
			} else continue;
		}
		return students;
	}

	/**
	 * This method check if there is the same name of the second argument in the
	 * array, students
	 * 
	 * @param students2
	 * @param student
	 * @return boolean
	 */
	private boolean studentExist(ArrayList<Student> students2, Student student) {
		for(Student name : students2) {
			if (name.getName().equals(student.getName())) 
				return false;
		}
		return true;
	}

	/**
	 * This method returns a Course array to initiate the field, courses, from
	 * lines.
	 * 
	 * @param lines
	 * @return
	 */
	private ArrayList<Course> initiateCourseArrayFromLines(String[] lines) {

		courses = new ArrayList<Course>(numOfCourses);
		String course = null;
		Course courseName = null;

		for (int i = 0; i < lines.length; i++) {
			course = lines[i].split(",")[2];
			courseName = new Course(course.trim());
			if (courseExist(courses, courseName)) {
				courses.add(courseName);
			}
		}
		return courses;
	}

	/**
	 * This method check if there is the same name of the second argument in the
	 * array, courses.
	 * 
	 * @param courses2
	 * @param course
	 * @return boolean
	 */
	private boolean courseExist(ArrayList<Course> courses2, Course course) {

		for(Course course1 : courses2) {
			if (course1.getCourseName().equals(course.getCourseName())) 
				return false;
		}
		return true;
	}

}