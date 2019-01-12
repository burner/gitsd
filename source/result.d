module result;

struct Author {
	size_t i;
	string[] name;
	string[] email;
}

struct Commit {
	Author* author;
}
