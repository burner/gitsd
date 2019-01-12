module result;

struct Author {
	size_t i;
	string[] name;
	string[] email;
}

struct Commit {
	Author* author;
}

struct ScrappedDate {
	Commit[] commits;
	Author*[] authors;
	Author*[string] authorByMail;
}
