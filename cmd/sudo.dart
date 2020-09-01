import "dart:io";
import "dart:convert";
import "dart:async";
// Implements sudoku parts
class Sudoku {
    static int tRows = 9;
    static int tCols = 9;
    List<int> orows;
    List<int> rows;

    // Generates a 9x9 nested list
    Sudoku() {
        orows = List.generate(tRows*tCols, (i) => 0, growable: false);
        rows  = List.generate(tRows*tCols, (i) => orows[i], growable: false);
    }
    void fromFile(String filename) {
        File inputs = new File(filename);
        List<String> lines = inputs.readAsLinesSync();
        List<String> line;
        for (int r = 0; r < lines.length; r++) {
            line = lines[r].split(" ");
            for (int c = 0; c < line.length; c++) {
                setOVal(r, c, int.parse(line[c]));
            }
        }
        rows  = List.generate(tRows*tCols, (i) => orows[i], growable: false);
        //print(rows);
    }
    void setOVal(int r, int c, int v) {
        orows[r*tCols+c] = v;
    }
    // Set item in Sudoku
    void setVal(int r, int c, int v) {
        rows[r*tCols+c] = v;
    }

    int getVal(int r, int c) {
        return rows[r*tCols + c];
    }

    // Check if val in row
    bool inRow(int r, int v) {
        int ind;
        for (int c = 0; c < tCols; c++) {
            ind = r*tCols+c;
            if (rows[ind] == v) {
                return true;
            }
        }
        return false;
    }

    // Check if val in col
    bool inCol(int c, int v) {
        int ind;
        for (int r = 0; r < tRows; r++) {
            ind = r*tCols+c;
            if (rows[ind] == v) {
                return true;
            }
        }
        return false;
    }
    bool inSquare(int rRow, int cCol, int v) {
        int ind;
        // Determine base square
        int sqR = rRow ~/ 3;
        int sqC = cCol ~/ 3;
        for (int r = 0; r < 3; r++) {
            for (int c = 0; c < 3; c++) {
                ind = (sqR*3+r)*tCols+(sqC*3+c);
                if (rows[ind] == v) {
                    return true;
                }
            }
        }
        return false;
    }

    bool validNumber(int r, int c, int v) {
        return !inRow(r, v) && !inCol(c, v) && !inSquare(r, c, v);
    }

    bool validSolve() {
        int v;
        for (int r = 0; r < tRows; r++) {
            for (int c = 0; c < tCols; c++) {
                v = getVal(r, c);
                setVal(r, c, 0);
                if (!validNumber(r, c, v)) {
                    return false;
                }
                else {
                    setVal(r, c, v);
                }
            }
        }
        return true;
    }

    void solve() {
        solver(0, 0);
    }
    
    
    bool solver(int r, int c) {
        // print("$r $c");
        // Save on writing this over and over again
        int nr;
        int nc;
        if (c == 8) {
            nc = 0;
            nr = r + 1;
        }
        else {
            nc = c + 1;
            nr = r;
            // print("n $nr $nc");
        }
        // Bottoming Out
        if (r == 9) {
            return validSolve();
        }
        // Skip preset numbers
        if (orows[r*tCols+c] != 0) {
            return solver(nr, nc);
        }
        else {
            // Main body
            for (int v = 1; v <= tCols; v++) {
                if (validNumber(r,c,v)) {
                    setVal(r, c, v);
                    // The magic line!
                    // When we bottom out this breaks us
                    // out of the loop body all the way up
                    // to the top of the recursion
                    if (solver(nr, nc)) {
                        return true;
                    }
                }
            }
            setVal(r,c,0);
            return false;
        }
    }

    // toString because pretty print
    String toString() {
        // Empty body for now....
        String sRows = "";
        int v;
        for (int r = 0; r < tRows; r++) {
            for (int c = 0; c < tCols; c++) {
                v = rows[r*tCols+c];
                if (v != 0) {
                    sRows = "$sRows $v";
                }
                else {
                    sRows = "$sRows  ";
                }
                if (c > 0 && (c+1) < tCols && (c+1) % 3 == 0) {
                    sRows = "$sRows |";
                }
                if (c == tCols-1) {
                    sRows = "$sRows \n";
                    if ((r+1) % 3 == 0 && r < 8) {
                        // A quick barrier
                        for (int i = 0; i < tCols*3-4; i++) {
                            sRows = "$sRows-";
                        }
                        sRows = "$sRows \n";
                    }
                }
            }
        }
        return sRows;
    }
}
