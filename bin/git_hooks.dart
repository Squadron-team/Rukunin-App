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
  // Get staged files
  final staged = Process.runSync('git', [
    'diff',
    '--cached',
    '--name-only',
    '--diff-filter=ACM',
  ]);

  final files = staged.stdout
      .toString()
      .trim()
      .split('\n')
      .where((f) => f.endsWith('.dart'))
      .toList();

  if (files.isEmpty) {
    print('No Dart files staged.');
    return true;
  }

  print('Running dart fix on staged files...');
  for (final f in files) {
    Process.runSync('dart', ['fix', '--apply', f]);
  }

  print('Running dart format on staged files...');
  Process.runSync('dart', ['format', ...files]);

  // Check if changes occurred in staged files
  final result = Process.runSync('git', ['diff', '--quiet', '--', ...files]);

  if (result.exitCode != 0) {
    print('\nFormatted files changed. Please stage them again.');
    return false;
  }

  return true;
}
