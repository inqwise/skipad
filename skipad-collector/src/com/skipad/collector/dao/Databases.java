package com.skipad.collector.dao;

public enum Databases {
	Default(null),
    Skipad("skipad"),
	SkipadTag("skipad-tag");

    private final String value;

    public String toString() {
        return value;
    }

    private Databases(String value) {
        this.value = value;
    } 
}
