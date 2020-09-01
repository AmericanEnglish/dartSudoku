import "sudo.dart";

void main() {
    Sudoku s = Sudoku();
    s.fromFile("inkala.sudoku");
    print(s.toString());
    s.solve();
    print(s.toString());
}
