import 'package:flutter/material.dart';


TextEditingController number = TextEditingController();
var matrix1  = List.generate(9, (index) => List.filled(9,0),growable : false);
var matrix2  = List.generate(9, (index) => List.filled(9,0),growable : false);

void main() {
  runApp(MaterialApp(
    home: mainPage(),
  ));
}


class mainPage extends StatefulWidget {
  const mainPage({Key? key}) : super(key: key);

  @override
  State<mainPage> createState() => _mainPageState();
}

class _mainPageState extends State<mainPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
            title: Text("Sodoku Solver"),
          ),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(16, 20,8,8),
            child: Column(
              children: [
                Container(
                  height : 500,
                    child : GridView.count(
                          crossAxisCount: 9,
                          children: List.generate(81, (index) {
                            int j =  index % 9;
                            int i = (index/9).floor();
                            return GestureDetector(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.deepOrange,
                                  border: Border.all()
                                ),
                              child: Center(child: Text(
                                matrix1[i][j] == 0? " " : matrix1[i][j].toString()
                              )),

                          ),
                              onTap: (){
                                showDialog(context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text("Set Number"),
                                      content: SizedBox(
                                        height: 150,
                                        child: Column(
                                          children: [
                                            TextField(
                                              controller: number,
                                              keyboardType: TextInputType.number,
                                            ),

                                            SizedBox(
                                              height: 50,
                                            ),

                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [

                                                TextButton(
                                                    onPressed: () {
                                                      setState((){
                                                        matrix2[i][j] = int.parse(number.text);
                                                        matrix1[i][j] = matrix2[i][j];
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                    child: Text("Set")
                                                ),
                                                TextButton(
                                                    onPressed: () {
                                                      setState((){
                                                        matrix2[i][j] = 0;
                                                        matrix1[i][j] = matrix2[i][j];
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                    child: Text("Clear")
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                );
                              },
                            );}
                            ))),
                TextButton(onPressed: (){
                  setState((){
                  for(int i = 0; i < 9; i++){
                    for(int j = 0; j < 9; j++){
                      matrix1[i][j] = 0;
                      matrix2[i][j] = matrix1[i][j];
                    }
                  }});
                }
                    , child: Text("Reset"))
              ],

            ),
          ),
         floatingActionButton: FloatingActionButton(
           onPressed: (){
             if(Solve(0,0)){
            setState((){
              for (int i1 = 0; i1<9; i1++){
                for (int i2 =0; i2 < 9; i2++){
                  matrix1[i1][i2] = matrix2[i1][i2];
                }
              }
            });}
           },
           child: Text("Solve"),
      ),

      ),
    );
  }
}

Widget Build (BuildContext context){
  return Dialog(
    child: Text("Pick a number"),
  );
}


bool Check(int value, int i , int j){
  for (int k = 0; k < 9; k++){
    if(matrix2[k][j] == value){
      return false;
    }
  }
  for (int k = 0; k < 9; k++){
    if(matrix2[i][k] == value){
      return false;
    }
  }

  for (int i1 = (i/3).floor()*3; i1 < (i/3).floor()*3 +3; i1++){
    for (int i2 = (j/3).floor()*3; i2 < (j/3).floor()*3+3; i2++){
      if (matrix2[i1][i2] == value){
        return false;
      }
    }
  }
  return true;

}

bool Solve(int i, int j){

  if(i==9){
    return true;
  }
  if (j==9){
    return Solve(i+1, 0);
  }

  if(matrix2[i][j]==0){
    for (int k = 1; k <=9; k++){
      if(Check(k, i, j)){
        matrix2[i][j] = k;
        if(Solve(i, j+1)){
          return true;
        }
        matrix2[i][j] = 0;
      }
    }
    return false;
  }
  else{
    return Solve(i, j+1);
  }
}


