module git;

import std.process;

bool doesGitExists() {
	import std.file : exists, isDir;
	import std.path : buildPath;
	if(!exists(config().gitPath)) {
		writefln!"'%s' does not exists"(config().gitPath);
		return false;
	}

	if(!isDir(config().gitPath)) {
		writefln!"'%s' is not a directory"(config().gitPath);
		return false;
	}

	const gitDirPath = buildPath(config().gitPath, ".git");
	if(!exists(gitDirPath) || !isDir(gitDirPath)) {
		writefln!"'%s' is not a git directory"(config().gitPath);
		return false;
	}

	return true;
}

bool isGetInCleanState() {
	return false;
}
