module options;

import args;

struct Options {
	@Arg("Path to the git to analyze", 'i')
	string gitPath = "../D/vibe.d";

	@Arg("Output path directory", 'o')
	string outDir = ".";

	@Arg("Name of tmp branch")
	string tmpBranchName = "gitsd_stats_branch";
}

private Options __options;

ref Options configWriteable() {
	return __options;
}

ref const(Options) config() {
	return __options;
}
