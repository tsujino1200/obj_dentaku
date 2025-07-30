class Function {
  float Add(float x, float y){
    return x + y;
  }
  float Sub(float x, float y){
    return x - y;
  }
  float Mult(float x, float y){
    return x * y;
  }
  float Div(float x, float y){
    return x / y;
  }
  float Pow(float x, float y) {
    return pow(x, y);
  }

  float Sin(float x){ 
    return sin(radians(x));
  }
  float Cos(float x){
    return cos(radians(x));
  }
  float Log(float x){
    return log(x);
  }
  float Root(float x){
    return sqrt(x);
  }
  float ABS(float x){
    return abs(x);
  }
}
