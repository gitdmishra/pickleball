class Set {
  int t1FinalScore;
  int t2FinalScore;
  int setNumber;

  // Constructor
  Set(this.setNumber);

  void setFinalScore(int t1Score, int t2Score){
    t1FinalScore = t1Score;
    t2FinalScore = t2Score;
  }
  int getT1FinalScore(){
    return t1FinalScore;
  }
  int getT2FinalScore(){
    return t2FinalScore;
  }
  int getSetNumber(){
    return setNumber;
  }
}