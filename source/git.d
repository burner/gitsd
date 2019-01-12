module git;

import std.stdio;
import std.process;
import std.format;

import options;

bool runGitCommand(string func) {
	string sh = format!"cd %s && %s"(config().gitPath, func);
	auto rslt = executeShell(sh);
	if(rslt.status != 0) {
		return false;
	}
	return true;
}

bool runGitCommand(string func, ref string stdout) {
	string sh = format!"cd %s && %s"(config().gitPath, func);
	auto rslt = executeShell(sh);
	if(rslt.status != 0) {
		return false;
	}
	stdout = rslt.output;
	return true;
}

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
	auto rslt = runGitCommand("git diff-index --quiet HEAD --");
	if(!rslt) {
		writefln!"git has uncommited changes"();
		return false;
	}
	return true;
}

bool checkoutRewindBranch() {
	if(!cleanupGit()) {
		writefln!"failed to cleanup git and checkout master"();
	}
	
	if(!runGitCommand("git checkout -b " ~ config().tmpBranchName)) {
		writefln!"failed to create tmp branch"();
		return false;
	}

	return true;
}

bool cleanupGit() {
	auto rslt = runGitCommand("git checkout -f master");
	if(!rslt) {
		writefln!"failed to checkout master"();
		return false;
	}

	if(runGitCommand("git rev-parse --verify " ~ config().tmpBranchName)) {
		if(!runGitCommand("git branch -d " ~ config().tmpBranchName)) {
			writefln!"failed to delete tmp branch"();
			return false;
		}
	}
	return true;
}

bool deleteCurrentCommit() {
	auto rslt = runGitCommand("git reset HEAD~");
	if(!rslt) {
		return false;
	}
	return true;
}

struct SHA {
	bool worked;
	string sha;
}

SHA getSHA() {
	import std.string : strip;
	SHA ret;
	ret.worked = runGitCommand("git rev-parse HEAD", ret.sha);
	ret.sha = ret.sha.strip();
	return ret;
}
