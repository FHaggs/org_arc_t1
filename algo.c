#include <stdio.h>

int newton_raphson(int x, int i){
    if(i == 0){
        return 1;
    }
    return (newton_raphson(x, i-1) + (x / newton_raphson(x, i-1))) / 2;
}

int main(){
    int my_num = 9;
    int iterations = 3;

    int value = newton_raphson(my_num, iterations);
    printf("%d \n", value);

    return 0;
}
