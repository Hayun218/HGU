package edu.handong.analysis;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.Map;
import java.util.TreeMap;

import org.apache.commons.csv.CSVRecord;

import edu.handong.analysis.datamodel.Course;
import edu.handong.analysis.datamodel.Student;
import edu.handong.analysis.utils.Utils;

public class HGUCoursePatternAnalyzer {

	private HashMap<String, Student> students;

	/**
	 * This method runs our analysis logic to save the number courses taken by each
	 * student per semester in a result file. Run method must not be changed!!
	 * 
	 * @param args
	 * @throws IOException
	 * @throws FileNotFoundException
	 */
	public void run(String input, String output, int startyear, int endyear, boolean flag, String coursesCode) {
		String dataPath = input; // csv file to be analyzed
		String resultPath = output; // the file path where the results are saved.
		ArrayList<CSVRecord> lines = Utils.getLines(dataPath, true);
		students = loadStudentCourseRecords(lines, startyear, endyear);

		Map<String, Student> sortedStudents = new TreeMap<String, Student>(students);

		if (flag) {

			// Generate result lines to be saved.
			ArrayList<String> linesToBeSaved = countNumberOfCoursesTakenInEachSemester(sortedStudents);
			Utils.writeAFile(linesToBeSaved, resultPath);
			// Write a file (named like the value of resultPath) with linesTobeSaved.

		} else {

			ArrayList<String> linesToBeSaved = ratioCourses(lines, coursesCode, startyear, endyear);
			Utils.writeAFile(linesToBeSaved, resultPath);
		}

	}

	/**
	 * This method create HashMap<String,Student> from the data csv file. Key is a
	 * student id and the corresponding object is an instance of Student. The
	 * Student instance have all the Course instances taken by the student.
	 * 
	 * @param lines
	 * @param endyear
	 * @param startyear
	 * @return
	 */
	private HashMap<String, Student> loadStudentCourseRecords(ArrayList<CSVRecord> lines, int startyear, int endyear) {

		HashMap<String, Student> stu = new HashMap<String, Student>();
		ArrayList<String> keys = new ArrayList<String>();
		Course oneCourse = null;
		Student student = null;

		String temp = "";
		int idx = 0;

		for (CSVRecord line : lines) {
			oneCourse = new Course(line);

			if (startyear <= oneCourse.getYearTaken() && oneCourse.getYearTaken() <= endyear) {
				keys.add(oneCourse.getStudentId());
				if (idx == 0) {
					student = new Student(keys.get(0));
					temp = keys.get(0);
					stu.put(keys.get(0), student);
					idx = 1;
				} else {
					if (keys.get(idx).equals(temp)) {
						student.addCourse(oneCourse);
					} else {
						student = new Student(oneCourse.getStudentId());
						student.addCourse(oneCourse);
						temp = keys.get(idx);
					}
					stu.put(keys.get(idx), student);
					idx++;
				}
			} else
				continue;
		}
		return stu;
	}

	/**
	 * This method generate the number of courses taken by a student in each
	 * semester. The result file look like this: StudentID,
	 * TotalNumberOfSemestersRegistered, Semester, NumCoursesTakenInTheSemester
	 * 0001,14,1,9 0001,14,2,8 ....
	 * 
	 * 0001,14,1,9 => this means, 0001 student registered 14 semeters in total. In
	 * the first semeter (1), the student took 9 courses.
	 * 
	 * 
	 * @param sortedStudents
	 * @return
	 */
	private ArrayList<String> countNumberOfCoursesTakenInEachSemester(Map<String, Student> sortedStudents) {

		ArrayList<String> result = new ArrayList<String>();
		result.add("StudentID, TotalNumberOfSemestersRegistered, Semester, NumCoursesTakenInTheSemester");
		int NumCoursesTakenInTheSemester = 0;

		for (String key : sortedStudents.keySet()) {
			int TotalNumberOfSemestersRegistered = 0;
			String stuId = key;
			Student stu = sortedStudents.get(stuId);

			TotalNumberOfSemestersRegistered = stu.getSemestersByYearAndSemester().size();

			for (int i = 1; i <= TotalNumberOfSemestersRegistered; i++) {
				NumCoursesTakenInTheSemester = stu.getNumCourseInNthSementer(i);
				result.add(
						stuId + "," + TotalNumberOfSemestersRegistered + "," + i + "," + NumCoursesTakenInTheSemester);

			}
		}
		return result;
	}

	class AscendingObj implements Comparator<Course> {

		@Override
		public int compare(Course o1, Course o2) {
			String yearAndSem1 = o1.getYearTaken() + "-" + o1.getSemesterCourseTaken();
			String yearAndSem2 = o2.getYearTaken() + "-" + o2.getSemesterCourseTaken();

			return yearAndSem1.compareTo(yearAndSem2);
		}
	}

	private ArrayList<String> ratioCourses(ArrayList<CSVRecord> lines, String courseCode, int startyear, int endyear) {
		ArrayList<String> printLine = new ArrayList<String>();
		HashMap<String, Integer> totalNumberOfStu = new HashMap<String, Integer>();
		HashMap<String, Integer> specificNumberOfStu = new HashMap<String, Integer>();

		ArrayList<Course> specificCourses = new ArrayList<Course>();
		ArrayList<Course> allCourses = new ArrayList<Course>();
		String CourseName = null;

		for (CSVRecord line : lines) {
			Course oneCourse = new Course(line);
			if (startyear <= oneCourse.getYearTaken() && endyear >= oneCourse.getYearTaken()) {
				allCourses.add(oneCourse);
				if (oneCourse.getCourseCode().equals(courseCode)) {
					CourseName = oneCourse.getCourseName();
					specificCourses.add(oneCourse);
				}
			} else
				continue;
		}

		AscendingObj ascending = new AscendingObj();
		Collections.sort(allCourses, ascending);
		Collections.sort(specificCourses, ascending);

		String tempstuID = null;
		String yearAndSem = null;
		String stuID = null;
		int numOfSpecificStu = 1;
		int numOfTotal = 1;
		for (Course all : allCourses) {
			yearAndSem = all.getYearTaken() + "-" + all.getSemesterCourseTaken();
			stuID = all.getStudentId();

			if (totalNumberOfStu.size() == 0) {
				totalNumberOfStu.put(yearAndSem, numOfTotal);
				tempstuID = stuID;
				continue;
			}
			if (tempstuID.equals(stuID))
				continue;
			else {
				numOfTotal = totalNumberOfStu.containsKey(yearAndSem) ? totalNumberOfStu.get(yearAndSem) : 0;
				totalNumberOfStu.put(yearAndSem, numOfTotal + 1);
				tempstuID = stuID;
			}

		}

		for (Course specificStu : specificCourses) {
			String yearAndSem1 = specificStu.getYearTaken() + "-" + specificStu.getSemesterCourseTaken();
			if (specificNumberOfStu.size() == 0) {
				specificNumberOfStu.put(yearAndSem1, numOfSpecificStu);
				continue;
			}

			numOfSpecificStu = specificNumberOfStu.containsKey(yearAndSem1) ? specificNumberOfStu.get(yearAndSem1) : 0;
			specificNumberOfStu.put(yearAndSem1, numOfSpecificStu + 1);
		}

		float ratio = 0;
		printLine.add("Year,Semester,CouseCode, CourseName,TotalStudents,StudentsTaken,Rate");
		Map<String, Integer> sortedAll = new TreeMap<String, Integer>(totalNumberOfStu);
		Map<String, Integer> sortedSome = new TreeMap<String, Integer>(specificNumberOfStu);

		for (String str1 : sortedAll.keySet()) {
			boolean check = false;
			String[] yearAndSemester = str1.split("-");
			for (String str2 : sortedSome.keySet()) {
				if (str1.equals(str2)) {
					check = true;
					ratio = ((float) sortedSome.get(str2) / (float) totalNumberOfStu.get(str1)) * 1000;
					ratio = (Math.round(ratio));
					ratio = ratio/10;
					printLine.add(yearAndSemester[0] + "," + yearAndSemester[1] + "," + courseCode + "," + CourseName
							+ "," + sortedAll.get(str1) + "," + sortedSome.get(str2) + "," + ratio + "%");
				}
			}
			if (!check) {
				printLine.add(yearAndSemester[0] + "," + yearAndSemester[1] + "," + courseCode + "," + CourseName + ","
						+ sortedAll.get(str1) + "," + "0" + "," + " 0.0%");
			}
		}
		return printLine;
	}

}
