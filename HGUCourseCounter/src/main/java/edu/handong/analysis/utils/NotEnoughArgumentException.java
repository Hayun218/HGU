package edu.handong.analysis.utils;

@SuppressWarnings("serial")
public class NotEnoughArgumentException extends Exception {

	public NotEnoughArgumentException(String message) {
		super(message);
	}

	public NotEnoughArgumentException() {
		super("No CLI argument Exception! Please put a file path.");
	}

}
