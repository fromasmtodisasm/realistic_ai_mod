//
// тестовый пример работы с SOINN
// http://haselab.info/soinn-e.html
//
// http://robocraft.ru
//

#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#include "CSOINN.h"

#define DIMENSION			2
#define REMOVE_NODE_TIME	200
#define DEAD_AGE			100

// показать информацию о SOINN-сети
void show_SOINN_info(CSOINN* pSOINN);

// расстояние между двумя сигналами
double Distance(const double *signal1, const double *signal2, int dimension=DIMENSION);

int main(int argc, char* argv[])
{
	printf("[i] Start...\n");

	CSOINN* pSOINN = 0;

	// создание объекта SOINN
	pSOINN = new CSOINN ( DIMENSION , REMOVE_NODE_TIME , DEAD_AGE );

	if(!pSOINN){
		printf("[!] Error: cant allocate memory!\n");
		return -1;
	}

	// для хранения входных данных
	double signal[DIMENSION];

	int i=0;

	//-----------------------------------------
	for(i=0; i<10; i++){
		signal[0] = 0;
		signal[1] = i;

		// добавляем данные в сеть
		pSOINN -> InputSignal ( signal );
	}

	// классификация данных
	pSOINN -> Classify ();

	// поcмотрим информацию о SOINN-сети
	show_SOINN_info(pSOINN);
	//-----------------------------------------
	double delta = 0.9;

#if 1
	for(i=0; i<10; i++){
		signal[0] = i;
		signal[1] = i;

		// добавляем данные в сеть
		pSOINN -> InputSignal ( signal );
	}

	// классификация данных
	pSOINN -> Classify ();

	// поcмотрим информацию о SOINN-сети
	show_SOINN_info(pSOINN);
#endif
	//-----------------------------------------

	// 1-NN algorithm .
	double minDist = CSOINN :: INFINITY ;
	int nearestID = CSOINN :: NOT_FOUND ;

	// тестовый сигнал
	double targetSignal[DIMENSION];
	targetSignal[0] = 1+delta;
	targetSignal[1] = 1+delta;

	for(i=0; i < pSOINN->GetNodeNum(); i++ ){

		double* nodeSignal = pSOINN -> GetNode ( i )-> GetSignal ();
		double dist = Distance ( targetSignal , nodeSignal );

		if ( minDist > dist ) {
			minDist = dist ;
			nearestID = i;
		}
	}

	int nearestClassID = pSOINN -> GetNode ( nearestID )-> GetClass ();
	printf ("[i] SOINN: Nearest Node ID : %d, Class ID : %d.\n", nearestID , nearestClassID );

	if(pSOINN){
		delete pSOINN;
		pSOINN = 0;
	}

	printf("[i] End.\n");
	return 0;
}

// показать информацию о SOINN-сети
void show_SOINN_info(CSOINN* pSOINN)
{
	if(!pSOINN){
		return;
	}

	// покажем информацию о сети
	printf("[ ] SOINN info: \n");
	printf("[i] Dimension: %d\n", pSOINN->GetDimension());
	printf("[i] NodeNum: %d\n", pSOINN->GetNodeNum());
	printf("[i] EdgeNum: %d\n", pSOINN->GetEdgeNum());
	printf("[i] ClassNum: %d\n", pSOINN->GetClassNum());
	printf("----------------------------\n");

}

// расстояние между двумя сигналами
double Distance(const double *signal1, const double *signal2, int dimension)
{
	int i;
	double sum;

	if (signal1 == NULL || signal2 == NULL || dimension<=0) return 0.0;
	
	sum = 0.0;
	for (i=0; i<dimension; i++){
		sum += (signal1[i]-signal2[i])*(signal1[i]-signal2[i]);
	}
	
	return sqrt(sum)/(double)dimension;
}
