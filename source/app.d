import std.stdio;

import args;

import options;
import git;

int main(string[] args) {
	const helpWanted = parseArgsWithConfigFile(configWriteable(), args);

	if(helpWanted) {
		printArgsHelp(config(), "Extracting statistical data from a git");
		return 0;
	}

	if(!doesGitExists()) {
		return 1;
	}

	if(!isGetInCleanState()) {
		return 2;
	}

	if(!checkoutRewindBranch()) {
		return 3;
	}
	scope(exit) cleanupGit();

	SHA cur;
	size_t commit = 1;
	do { 
		cur = getSHA();
		writefln!"%5d %s"(commit, cur.sha);
		++commit;
	} while(deleteCurrentCommit());

	return 0;
}
