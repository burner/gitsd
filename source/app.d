import std.stdio;

import args;

import options;
import result;
import git;
import splitlog;

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
		string[] files = getFiles();
		cur = getSHA();
		string[] log = getLog();
		Commit c = splitLog(log);	
		writefln!"%5d %s %s"(commit, cur.sha, c);
		++commit;
	} while(deleteCurrentCommit());

	return 0;
}
