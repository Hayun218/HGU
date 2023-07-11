package edu.handong.analysis.utils;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;

import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVParser;
import org.apache.commons.csv.CSVRecord;

public class Utils {

	public static ArrayList<CSVRecord> getLines(String file, boolean removeHeader) {

		ArrayList<CSVRecord> readfile = new ArrayList<CSVRecord>();
		try {
			File fileRead = new File(file);
			if (!fileRead.exists())
				throw new NotEnoughArgumentException("The file path does not exist. Please check your CLI argument!");

			FileReader fr = new FileReader(fileRead);

			CSVParser parser = CSVParser.parse(fr, CSVFormat.EXCEL.withIgnoreSurroundingSpaces().withTrim());
			Iterator<CSVRecord> iter = parser.iterator();

			while (iter.hasNext()) {
				readfile.add(iter.next());
			}
			fr.close();

			if (removeHeader)
				readfile.remove(0);

		} catch (

		FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (NotEnoughArgumentException e) {
			// e.printStackTrace();
			System.out.println(e.getMessage());
			System.exit(0);
		}
		return readfile;
	}

	public static void writeAFile(ArrayList<String> lines, String targetFileName) {
		try {
			File dest = new File(targetFileName);
			BufferedWriter bw = new BufferedWriter(new FileWriter(dest));
			if (!dest.exists())
				dest.createNewFile();
			for (String line : lines) {
				bw.write(line);
				bw.newLine();
			}
			bw.close();
		} catch (IOException e) {
			e.printStackTrace();
		}

	}

}
