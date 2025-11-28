import 'dart:io';

import 'package:git_hooks/git_hooks.dart';
// import 'dart:io';

void main(List arguments) {
  // ignore: omit_local_variable_types
  Map<Git, UserBackFun> params = {
    Git.commitMsg: commitMsg,
    Git.preCommit: preCommit,
  };
  GitHooks.call(arguments, params);
}

Future<bool> commitMsg() async {
  // var commitMsg = Utils.getCommitEditMsg();
  // if (commitMsg.startsWith('fix:')) {
  //   return true; // you can return true let commit go
  // } else {
  //   print('you should add `fix` in the commit message');
  //   return false;
  // }
  return true;
}

Future<bool> preCommit() async {
  print('Running dart fix...');
  Process.runSync('dart', ['fix', '--apply']);

  print('Running dart format...');
  Process.runSync('dart', ['format', '.']);

  // Check if formatting changed anything
  final result = Process.runSync('git', ['diff', '--quiet']);

  if (result.exitCode != 0) {
    print('\nCode formatted. Please commit again.');
    return false;
  }

  print('Code clean.');
  return true;
}
