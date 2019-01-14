module result;

import std.datetime;

struct Author {
	size_t i;
	string[] name;
	string[] email;
}

struct Commit {
	Author* author;
	Line[] lines;
	// git log --word-diff=porcelain -n 1 --date=iso-strict --stat
	string hash;
	DateTime date;
	long filesChanged;
	long insertions;
	long deletions;
}

struct Line {
	// 40 chars followed by 3 single digits
	string hash;
	string author;
	string author_mail;
	DateTime author_time;
	long author_tz;
	string committer;
	string committer_mail;
	DateTime committer_time;
	long committer_tz;
	string message;
	// hash space filename
	string previous;
	string filename;
	string line;
}

struct ScrappedDate {
	Commit[] commits;
	Author*[] authors;
	Author*[string] authorByMail;
}
