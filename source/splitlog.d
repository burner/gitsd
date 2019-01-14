module splitlog;

import std.stdio;
import std.datetime;
import std.conv : to;
import std.datetime.systime;
import std.string : indexOf;
import std.regex;

import result;

enum fChangedRegexStr = ` (?P<number>\d+) file[s]* changed`;
auto fChangedRegex = regex(fChangedRegexStr);

enum fInsertRegexStr = ` (?P<number>\d+) insertion[s]*(\+)`;
auto fInsertRegex = regex(fInsertRegexStr);

enum fDeleteRegexStr = ` (?P<number>\d+) deletion[s]*(\+)`;
auto fDeleteRegex = regex(fInsertRegexStr);

Commit splitLog(string[] log) {
	import std.algorithm.searching : startsWith;
	Commit cmt;
	writeln(log);
	foreach(line; log) {
		enum c = "commit ";
		enum a = "Author: ";
		enum d = "Date: ";
		if(line.startsWith(c)) {
			cmt.hash = line[c.length .. $];
		} else if(line.startsWith(d)) {
			cmt.date = cast(DateTime)SysTime.fromISOExtString(line[d.length .. $]);
		}

		auto fCMatch = matchFirst(line, fChangedRegex);
		if(!fCMatch.empty) {
			cmt.filesChanged = to!long(fCMatch["number"]);
		}

		auto iCMatch = matchFirst(line, fInsertRegex);
		if(!iCMatch.empty) {
			cmt.insertions = to!long(iCMatch["number"]);
		}

		auto dCMatch = matchFirst(line, fDeleteRegex);
		if(!dCMatch.empty) {
			cmt.deletions = to!long(dCMatch["number"]);
		}
	}
	return cmt;
}
