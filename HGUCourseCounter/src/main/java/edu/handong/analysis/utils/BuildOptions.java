package edu.handong.analysis.utils;

import org.apache.commons.cli.CommandLine;
import org.apache.commons.cli.CommandLineParser;
import org.apache.commons.cli.DefaultParser;
import org.apache.commons.cli.HelpFormatter;
import org.apache.commons.cli.Option;
import org.apache.commons.cli.Options;

import edu.handong.analysis.HGUCoursePatternAnalyzer;

public class BuildOptions {
	String input;
	String output;
	String coursecode;
	int startyear;
	int endyear;
	boolean help;
	String analysis;

	public void runOption(String[] args) {
		Options options = createOptions();

		if (parseOptions(options, args)) {
			if (help) {
				printHelp(options);
				return;
			}
			System.out.println("The input file path : " + input);
			System.out.println("The output file path :" + output);
			HGUCoursePatternAnalyzer analyzer = new HGUCoursePatternAnalyzer();
			if (analysis.equals("1")) {
				analyzer.run(input, output, startyear, endyear, true, coursecode);
			} else if (analysis.equals("2")) {
				analyzer.run(input, output, startyear, endyear, false, coursecode);
			}

		}
	}

	private boolean parseOptions(Options options, String[] args) {
		CommandLineParser parser = new DefaultParser();

		try {

			CommandLine cmd = parser.parse(options, args);

			input = cmd.getOptionValue("i");
			output = cmd.getOptionValue("o");
			analysis = cmd.getOptionValue("a");
			coursecode = cmd.getOptionValue("c");
			startyear = Integer.parseInt(cmd.getOptionValue("s"));
			endyear = Integer.parseInt(cmd.getOptionValue("e"));
			help = cmd.hasOption("h");

		} catch (Exception e) {
			printHelp(options);
			return false;
		}

		return true;
	}

// Definition Stage
	private Options createOptions() {
		Options options = new Options();

		// add options by using OptionBuilder
		options.addOption(Option.builder("i").longOpt("input").desc("Set an input file path").hasArg()
				.argName("Input path").required().build());

		// add options by using OptionBuilder
		options.addOption(Option.builder("o").longOpt("output").desc("Set an output file path").hasArg()
				.argName("Output path").required().build());

		options.addOption(Option.builder("a").longOpt("analysis")
				.desc("1: Count courses per semester, 2: Count per course name and year").hasArg()
				.argName("Analysis option").required().build());

		options.addOption(Option.builder("c").longOpt("coursecode").desc("Course code for '-a 2' option").hasArg()
				.argName("course code")
				// .required() // only for -a 2
				.build());

		options.addOption(Option.builder("s").longOpt("startyear").desc("Set the start year for analysis e.g., -s 2002")
				.hasArg().argName("Start year for analysis").required().build());

		options.addOption(Option.builder("e").longOpt("endyear").desc("Set the end year for analysis e.g., -e 2005")
				.hasArg().argName("End year for analysis").required().build());

		// add options by using OptionBuilder
		options.addOption(Option.builder("h").longOpt("help").desc("Show a Help page").argName("help").build());

		return options;
	}

	private void printHelp(Options options) {
		// automatically generate the help statement
		HelpFormatter formatter = new HelpFormatter();
		String header = "HGU Course Analyzer";
		String footer = "";
		formatter.printHelp("HGUCourseCounter", header, options, footer, true);
	}

}