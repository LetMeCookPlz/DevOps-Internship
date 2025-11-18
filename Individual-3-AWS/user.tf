resource "aws_iam_user" "full_access_user" {
  name = "tymur-new-user"
}

resource "aws_iam_user_policy_attachment" "administrator_access" {
  user       = aws_iam_user.full_access_user.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}