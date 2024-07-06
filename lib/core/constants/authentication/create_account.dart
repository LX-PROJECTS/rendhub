import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_account.g.dart';

class CreateAccountConstant {
  final txtHeading = "Create account";
  final txtLabelName = "Name";
  final txtHintName = "Enter Your Name ";
  final txtSubtitle = "This name will be visible to all other users";
  final txtbtn = "CREATE";
  final txtError = "Something went wrong";
}

@riverpod
CreateAccountConstant createAccountConstant(CreateAccountConstantRef ref) {
  return CreateAccountConstant();
}
