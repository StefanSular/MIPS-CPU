#include<iostream>


int main() {
	int X;
	int Y;
	scanf_s("%d %d", &X, &Y);

	while (X != Y) {
		if (X > Y)
			X -= Y;
		else
			Y -= X;
	}
	printf("CMMDC: %d\n", X);
	printf("CMMDC: %d\n", Y);



	return 0;
}

