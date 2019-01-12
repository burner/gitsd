module options;

import args;

struct Options {
	@Arg("Path to the git to analyze", 'i')
	string gitPath = ".";

	@Arg("Output path directory", 'o')
	string outDir = ".";
}

private Options __options;

ref Options configWriteable() {
	return __options;
}

ref const(Options) config() {
	return __options;
}
