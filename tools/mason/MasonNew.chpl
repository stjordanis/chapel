
use Path;
use Spawn;
use FileSystem;
use MasonUtils;
use MasonHelp;



proc masonNew(args) {
  if args.size < 3 {
      writeln('error: Invalid arguments.');
      masonNewHelp();
      exit();
    }
  else if isDir(args[2]) {
    writeln('A directory with that name already exists');
  }
  else {
    var vcs = true;
    var show = false;
    var name = 'MyPackage';
    for arg in args[2..] {
      if arg == '-h' || arg == '--help' {
	masonNewHelp();
	exit();
      }
      else if arg == '--no-vcs' {
	vcs = false;
      }
      else if arg == '--show' {
	show = true;
      }
      else {
	name = arg;
      }
    }
    InitProject(name, vcs, show);
  }
}


  
  
proc InitProject(name, vcs, show) {
  if vcs {
    gitInit(name, show);
    addGitIgnore(name);
  }
  else {
    mkdir(name);
  }
  // Confirm git init before creating files
  if isDir(name) {
    makeBasicToml(name);
    makeProjectFiles(name);
    writeln("Created new library project: " + name);
  }
  else {
    writeln("Failed to create project");
  }
}


proc gitInit(name: string, show: bool) {
  var initialize = "git init -q " + name;
  if show then initialize = "git init " + name;
  runCommand(initialize);
}

proc addGitIgnore(name: string) {
  var toIgnore = "\ntarget/\nMason.lock";
  var gitIgnore = open(name+"/.gitignore", iomode.cw);
  var GIwriter = gitIgnore.writer();
  GIwriter.write(toIgnore);
  GIwriter.close();
}


proc makeBasicToml(name: string) {
  const baseToml = '\n[brick]\nname = "' + name +
    '"\nversion = "0.1.0"\n\n[dependencies]\n';
  var tomlFile = open(name+"/Mason.toml", iomode.cw);
  var tomlWriter = tomlFile.writer();
  tomlWriter.write(baseToml);
  tomlWriter.close();
}
  

proc makeProjectFiles(name: string) {
  mkdir(name + "/src");
  const libTemplate = '/* Documentation for ' + name +
    ' */\nmodule '+ name + ' {\n   writeln("New library: '+ name +'");\n}';
  var lib = open(name+'/src/'+name+'.chpl', iomode.cw);
  var libWriter = lib.writer();
  libWriter.write(libTemplate);
  libWriter.close();
}